namespace Environment2;

//Sample Mono console application
//by Brian Long, 2009

//App is compiled against Mono assemblies and reports various bits of environment information
//Does Win32/Unix differentiation using PlatformID check
//Does Linux/OS X differentiation using a Unix P/Invoke call

interface

uses
  System.Runtime.InteropServices;

type
  ConsoleApp = class
  private
    class method InternalRunningLinuxInsteadOfOSX: Boolean;
    [DllImport('libc')]
    class method uname(buf: IntPtr): Integer; external;
  public
    class method RunningOnUnix: Boolean;
    class method RunningOnLinux: Boolean;
    class method RunningOnOSX: Boolean;
    class method RunningOnWindows: Boolean;
    class method Main;
  end;

implementation

class method ConsoleApp.Main;
begin
  Console.Write('Hello World from your ');
  if RunningOnLinux then
    Console.Write('Linux');
  if RunningOnOSX then
    Console.Write('Mac OS X');
  if RunningOnWindows then
    Console.Write('Windows');
  Console.WriteLine(' system :o)');
  Console.ReadLine
end;

class method ConsoleApp.RunningOnUnix: Boolean;
begin
  //.NET 1.x didn't have a Unix value in System.PlatformID enum, so Mono 
  //just used value 128.
  //.NET 2 added Unix to PlatformID, but with value 4
  //.NET 3.5 added MacOSX with a value of 6
  exit Integer(Environment.OSVersion.Platform) in [4, 6, 128];
end;

class method ConsoleApp.RunningOnLinux: Boolean;
begin
  exit RunningOnUnix and InternalRunningLinuxInsteadOfOSX
end;

class method ConsoleApp.RunningOnOSX: Boolean;
begin
  exit RunningOnUnix and not InternalRunningLinuxInsteadOfOSX
end;

class method ConsoleApp.RunningOnWindows: Boolean;
begin
  Result := not RunningOnUnix
end;

class method ConsoleApp.InternalRunningLinuxInsteadOfOSX: Boolean;
begin
  //based on Mono cross-platform checking code in:
  //  mcs\class\Managed.Windows.Forms\System.Windows.Forms\XplatUI.cs
  if not RunningOnUnix then
    raise new Exception('This is not a Unix platform!');
  var Buf: IntPtr := Marshal.AllocHGlobal(8192);
  try
    if uname(buf) <> 0 then
      //assume Linux of some sort
      exit True
    else
      //Darwin is the Unix variant that OS X is based on
      exit Marshal.PtrToStringAnsi(Buf) <> 'Darwin'
  finally
    Marshal.FreeHGlobal(Buf);
  end;
end;

end.
