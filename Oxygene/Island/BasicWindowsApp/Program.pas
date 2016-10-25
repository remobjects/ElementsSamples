namespace BasicWindowsApp;
uses
  rtl;
type
  Program = class
  public
    class var szTitle: LPCWSTR := 'RemObjects Island Windows Sample';
    class var szWindowClass: LPCWSTR := 'RemObjectsIslandWindowsSample';
    class var lOkBtn: ^__struct_HKEY__;
    [CallingConvention(CallingConvention.Stdcall)]
    class method WndProc(hwnd: ^__struct_HKEY__; message: UINT; wparam: WPARAM; lparam: LPARAM): Integer;
    begin
      case message of 
        WM_COMMAND:
          if (Word(wparam) = BN_CLICKED) and (lparam = rtl.LPARAM(lOkBtn)) then begin 
            MessageBox(hwnd, 'You clicked, hello there!', szTitle, 0);
          end;
        WM_CLOSE:
          PostQuitMessage(0);
      end;
      exit DefWindowProc(hWnd, message, wParam, lParam);
    end;
    class method Main(args: array of String): Int32;
    begin
      var lWindowClass: WNDCLASSEX;
      lWindowClass.cbSize := sizeOf(WNDCLASSEX);
      lWindowClass.style := CS_HREDRAW or CS_VREDRAW;
      lWindowClass.lpfnWndProc := @WndProc;
      lWindowClass.cbClsExtra := 0;
      lWindowClass.cbWndExtra := 0;
      lWindowClass.hInstance := rtl.GetModuleHandleW(nil);
      lWindowClass.hIcon := LoadIcon(lWindowClass.hInstance, LPCWSTR(IDI_APPLICATION));
      lWindowClass.hCursor := LoadCursor(nil, LPCWSTR(IDC_ARROW));
      lWindowClass.hbrBackground := ^Void(COLOR_WINDOW + 1);
      lWindowClass.lpszMenuName := nil;
      lWindowClass.lpszClassName := szWindowClass;
      if 0 = RegisterClassEx(@lWindowClass) then begin 
        MessageBox(nil, 'Call to RegisterClassEx failed!', szTitle, 0);
        exit 0;
      end;
      var lhWnd := CreateWindowExW(0, szWindowClass, szTitle, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, nil, nil, lWindowClass.hInstance, nil);
      if lhWnd = nil then begin 
        MessageBox(nil, 'Call to CreateWindowExW failed!', szTitle, 0);
        exit 0;
      end;
      lOkBtn := CreateWindowEx(0, 
        'BUTTON',  // Predefined class; Unicode assumed 
        'Click Me',      // Button text 
        WS_TABSTOP or WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,  // Styles 
        130,         // x position 
        70,         // y position 
        100,        // Button width
        25,        // Button height
        lhwnd,     // Parent window
        nil,       // No menu.
        lWindowClass.hInstance, 
        nil);      // Pointer not needed.

      ShowWindow(lhWnd,SW_SHOW);
      UpdateWindow(lhWnd);

      var msg: MSG;
      while GetMessage(@msg, nil, 0, 0) do begin
        TranslateMessage(@msg);
        DispatchMessage(@msg);
      end;

      exit Integer(msg.wParam);
    end;
  end;

end.
