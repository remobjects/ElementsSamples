namespace NewtonObservatory;

uses
  {$IF COOPER}org.jline.terminal,{$ENDIF}
  {$IF TOFFEE OR ISLAND}rtl,{$ENDIF}
  RemObjects.Elements.RTL;

type
  {$IF ISLAND AND WINDOWS}
  // ReadConsoleInputW writes a 20-byte INPUT_RECORD. Its key event starts
  // at byte four and bKeyDown occupies a full Win32 BOOL before the repeat
  // count, virtual key, scan code and UTF-16 character.
  ConsoleKeyRecord = record
    field EventType, Padding: UInt16;
    field KeyDown: Int32;
    field RepeatCount, VirtualKey, ScanCode, Character: UInt16;
    field ControlState: UInt32;
  end;
  {$ENDIF}

  // Keep terminal setup, timed input and screen size in one place so the
  // renderer and keyboard controls work the same way on each runtime.
  Terminal = static class
  private

    {$IF ECHOES}
    class var fOriginalControlC: Boolean;
    class var fWindowsOutput: IntPtr;
    class var fWindowsMode: UInt32;

    // Windows interprets ANSI cursor sequences only when this output flag is set.
    [System.Runtime.InteropServices.DllImport('kernel32.dll')]
    class method GetStdHandle(aKind: Int32): IntPtr; external;
    [System.Runtime.InteropServices.DllImport('kernel32.dll')]
    class method GetConsoleMode(aHandle: IntPtr; out aMode: UInt32): Boolean; external;
    [System.Runtime.InteropServices.DllImport('kernel32.dll')]
    class method SetConsoleMode(aHandle: IntPtr; aMode: UInt32): Boolean; external;
    {$ELSEIF COOPER}
    class var fTerminal: org.jline.terminal.Terminal;
    class var fOriginal: Attributes;
    {$ELSEIF WINDOWS}
    class var fIn, fOut: rtl.HANDLE;
    class var fInputMode, fOutputMode: rtl.DWORD;

    class method IsConsoleStream(aHandle: rtl.HANDLE): Boolean;
    begin
      if rtl.GetFileType(aHandle) ≠ rtl.FILE_TYPE_CHAR then
        exit false;
      var lMode: rtl.DWORD;
      exit (Integer(rtl.GetConsoleMode(aHandle, @lMode)) ≠ 0) or (rtl.GetLastError() = rtl.ERROR_ACCESS_DENIED);
    end;

    class method OpenConsoleDevice(aName: RemObjects.Elements.System.String): rtl.HANDLE;
    begin
      exit rtl.CreateFileW(aName.FirstChar, rtl.GENERIC_READ or rtl.GENERIC_WRITE,
                           rtl.FILE_SHARE_READ or rtl.FILE_SHARE_WRITE, nil, rtl.OPEN_EXISTING, 0, nil);
    end;
    {$ELSE}
    // libc fills this aligned buffer with the host's termios structure.
    class var fOriginal: array[0..31] of UInt64;
    {$ENDIF}
    {$IF ECHOES OR WINDOWS}
    class var fArrow: Integer;
    {$ENDIF}

  public

    class method Open: Boolean;
    begin
      {$IF ECHOES}
      if System.Console.IsInputRedirected or System.Console.IsOutputRedirected then
        exit false;
      if System.OperatingSystem.IsWindows then begin
        fWindowsOutput := GetStdHandle(-11);
        if not GetConsoleMode(fWindowsOutput, out fWindowsMode) or not SetConsoleMode(fWindowsOutput, fWindowsMode or 4) then
          exit false;
      end;
      fOriginalControlC := System.Console.TreatControlCAsInput;
      System.Console.TreatControlCAsInput := true;
      exit true;
      {$ELSEIF COOPER}
      if java.lang.System.console = nil then
        exit false;
      fTerminal := TerminalBuilder.builder.system(true).dumb(false).build;
      fOriginal := fTerminal.enterRawMode;
      exit true;
      {$ELSEIF WINDOWS}
      // A shell can attach read-only input and write-only output handles.
      // Console mode changes need both permissions. Reopen the devices only
      // after checking that the streams belong to a character device.
      if not IsConsoleStream(rtl.GetStdHandle(rtl.STD_INPUT_HANDLE)) or not IsConsoleStream(rtl.GetStdHandle(rtl.STD_OUTPUT_HANDLE)) then
        exit false;
      fIn := OpenConsoleDevice('CONIN$');
      fOut := OpenConsoleDevice('CONOUT$');
      var lOpened := false;
      try
        if (Integer(rtl.GetConsoleMode(fIn, @fInputMode)) = 0) or (Integer(rtl.GetConsoleMode(fOut, @fOutputMode)) = 0) then
          exit false;
        if Integer(rtl.SetConsoleMode(fOut, fOutputMode or 5)) = 0 then
          exit false;
        if Integer(rtl.SetConsoleMode(fIn, fInputMode and not UInt32(7))) = 0 then begin
          rtl.SetConsoleMode(fOut, fOutputMode);
          exit false;
        end;
        lOpened := true;
        exit true;
      finally
        if not lOpened then begin
          rtl.CloseHandle(fIn);
          rtl.CloseHandle(fOut);
        end;
      end;
      {$ELSE}
      if (isatty(0) ≠ 1) or (isatty(1) ≠ 1) or (tcgetattr(0, @fOriginal[0]) ≠ 0) then
        exit false;
      var lRaw: array[0..31] of UInt64;
      memcpy(@lRaw[0], @fOriginal[0], sizeOf(lRaw));
      cfmakeraw(@lRaw[0]);
      exit tcsetattr(0, 2, @lRaw[0]) = 0;
      {$ENDIF}
    end;

    class method Close;
    begin
      {$IF ECHOES}
      System.Console.TreatControlCAsInput := fOriginalControlC;
      if System.OperatingSystem.IsWindows then
        SetConsoleMode(fWindowsOutput, fWindowsMode);
      {$ELSEIF COOPER}
      try
        fTerminal.setAttributes(fOriginal);
      finally
        fTerminal.close;
      end;
      {$ELSEIF WINDOWS}
      rtl.SetConsoleMode(fIn, fInputMode);
      rtl.SetConsoleMode(fOut, fOutputMode);
      rtl.CloseHandle(fIn);
      rtl.CloseHandle(fOut);
      {$ELSE}
      if tcsetattr(0, 2, @fOriginal[0]) ≠ 0 then
        raise new Exception('Could not restore terminal settings. Run stty sane if needed.');
      {$ENDIF}
    end;

    class method Size(out aRows, aColumns: Integer): Boolean;
    begin
      {$IF ECHOES}
      aRows := System.Console.WindowHeight;
      aColumns := System.Console.WindowWidth;
      {$ELSEIF COOPER}
      var lSize := fTerminal.getSize;
      aRows := lSize.getRows;
      aColumns := lSize.getColumns;
      {$ELSEIF WINDOWS}
      var lInfo: rtl.CONSOLE_SCREEN_BUFFER_INFO;
      if Integer(GetConsoleScreenBufferInfo(fOut, @lInfo)) = 0 then
        exit false;
      aRows := lInfo.srWindow.Bottom - lInfo.srWindow.Top + 1;
      aColumns := lInfo.srWindow.Right - lInfo.srWindow.Left + 1;
      {$ELSE}
      var lSize: array[0..3] of UInt16;
      if ioctl(1, {$IF LINUX}$5413{$ELSE}$40087468{$ENDIF}, @lSize[0]) ≠ 0 then
        exit false;
      aRows := lSize[0];
      aColumns := lSize[1];
      {$ENDIF}
      exit true;
    end;

    class method Send(aText: not nullable String);
    begin
      {$IF ECHOES}
      System.Console.Write(aText);
      {$ELSEIF COOPER}
      fTerminal.writer.print(aText);
      fTerminal.writer.flush;
      {$ELSEIF WINDOWS}
      var lWritten: rtl.DWORD;
      if Integer(rtl.WriteConsoleW(fOut, (aText as RemObjects.Elements.System.String).FirstChar, length(aText), @lWritten, nil)) = 0 then
        raise new Exception('Could not write the frame.');
      {$ELSE}
      var lBytes := Encoding.UTF8.GetBytes(aText);
      var lOffset := 0;
      while lOffset < length(lBytes) do begin
        var lWritten := rtl.write(1, @lBytes[lOffset], length(lBytes) - lOffset);
        if lWritten ≤ 0 then
          raise new Exception('Could not write the frame.');
        lOffset := lOffset + Integer(lWritten);
      end;
      {$ENDIF}
    end;

    // A timeout (-2) lets the explorer notice a resize while the user is idle.
    // An end of input (-1) closes the view just like the quit key.
    class method ReadKey: Integer;
    begin
      {$IF ECHOES OR WINDOWS}
      if fArrow < 0 then begin
        fArrow := -fArrow;
        exit ord('[');
      end;
      if fArrow > 0 then begin
        result := fArrow;
        fArrow := 0;
        exit;
      end;
      {$ENDIF}
      {$IF ECHOES}
      if not System.Console.KeyAvailable then begin
        System.Threading.Thread.Sleep(100);
        exit -2;
      end;
      var lKey := System.Console.ReadKey(true);
      case lKey.Key of
        System.ConsoleKey.UpArrow: fArrow := -ord('A');
        System.ConsoleKey.DownArrow: fArrow := -ord('B');
        System.ConsoleKey.RightArrow: fArrow := -ord('C');
        System.ConsoleKey.LeftArrow: fArrow := -ord('D');
      else
        exit ord(lKey.KeyChar);
      end;
      exit 27;
      {$ELSEIF COOPER}
      exit fTerminal.reader.read(100);
      {$ELSEIF WINDOWS}
      if rtl.WaitForSingleObject(fIn, 100) = rtl.WAIT_TIMEOUT then
        exit -2;
      var lEvent: ConsoleKeyRecord;
      var lCount: rtl.DWORD;
      if Integer(rtl.ReadConsoleInputW(fIn, ^rtl.INPUT_RECORD(@lEvent), 1, @lCount)) = 0 then
        exit -1;
      if (lCount = 0) or (lEvent.EventType ≠ 1) or (lEvent.KeyDown = 0) then
        exit -2;
      case lEvent.VirtualKey of
        rtl.VK_UP: fArrow := -ord('A');
        rtl.VK_DOWN: fArrow := -ord('B');
        rtl.VK_RIGHT: fArrow := -ord('C');
        rtl.VK_LEFT: fArrow := -ord('D');
      else
        exit lEvent.Character;
      end;
      exit 27;
      {$ELSE}
      var lPoll: PollDescriptor;
      lPoll.Descriptor := 0;
      lPoll.Events := 1;
      var lReady := poll(@lPoll, 1, 100);
      if lReady = 0 then
        exit -2;
      if lReady < 0 then begin
        if ({$IF LINUX}__errno_location{$ELSE}__error{$ENDIF})^ = 4 then
          exit -2;
        exit -1;
      end;
      var lByte: Byte;
      if rtl.read(0, @lByte, 1) ≠ 1 then
        exit -1;
      exit lByte;
      {$ENDIF}
    end;

  end;

{$IF ISLAND AND WINDOWS}
[DllImport('kernel32.dll')]
method GetConsoleScreenBufferInfo(aOutput: rtl.HANDLE; aInfo: ^rtl.CONSOLE_SCREEN_BUFFER_INFO): rtl.BOOL; external;
{$ENDIF}

{$IF TOFFEE OR (ISLAND AND NOT WINDOWS)}
type
  PollDescriptor = record
    field Descriptor: Int32;
    field Events, ReturnedEvents: Int16;
  end;

{$IF ISLAND}
const CRuntime = {$IF LINUX}'libc.so.6'{$ELSE}'/usr/lib/libSystem.B.dylib'{$ENDIF};
{$ENDIF}

{$IF ISLAND}[DllImport(CRuntime, EntryPoint := 'tcgetattr')]{$ENDIF}
method tcgetattr(aFd: Int32; aBuffer: ^UInt64): Int32; external;
{$IF ISLAND}[DllImport(CRuntime, EntryPoint := 'tcsetattr')]{$ENDIF}
method tcsetattr(aFd, aWhen: Int32; aBuffer: ^UInt64): Int32; external;
{$IF ISLAND}[DllImport(CRuntime, EntryPoint := 'cfmakeraw')]{$ENDIF}
method cfmakeraw(aBuffer: ^UInt64); external;
{$IF ISLAND}[DllImport(CRuntime, EntryPoint := 'poll')]{$ENDIF}
method poll(aDescriptors: ^PollDescriptor; aCount: {$IF LINUX}NativeUInt{$ELSE}UInt32{$ENDIF}; aTimeout: Int32): Int32; external;
{$IF LINUX}
{$IF ISLAND}[DllImport(CRuntime, EntryPoint := '__errno_location')]{$ENDIF}
method __errno_location: ^Int32; external;
{$ELSE}
{$IF ISLAND}[DllImport(CRuntime, EntryPoint := '__error')]{$ENDIF}
method __error: ^Int32; external;
{$ENDIF}
{$ENDIF}

end.
