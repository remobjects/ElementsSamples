namespace BasicWindowsApp;

uses
  rtl;

type
  Program = class
  public
  
    class var szTitle: LPCWSTR := 'RemObjects Elements — Island Windows Sample';
    class var szWindowClass: LPCWSTR := 'IslandWindowsSample';
    class var fButton: HWND;
    
    [CallingConvention(CallingConvention.Stdcall)]
    class method WndProc(hWnd: HWND; message: UINT; wParam: WPARAM; lParam: LPARAM): Integer;
    begin
      case message of 
        WM_COMMAND:
          if (wParam = BN_CLICKED) and (lParam = rtl.LPARAM(fButton)) then begin 
            MessageBox(hWnd, 'You clicked, hello there!', szTitle, 0);
          end;
        WM_CLOSE:
          PostQuitMessage(0);
      end;
      result := DefWindowProc(hWnd, message, wParam, lParam);
    end;
    
    class method Main(args: array of String): Int32;
    begin
      
      //
      // Set up and Register the Windows Class
      //
      
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
      
      if RegisterClassEx(@lWindowClass) = 0 then begin 
        MessageBox(nil, 'Call to RegisterClassEx failed', szTitle, 0);
        exit 0;
      end;
      
      //
      // Create the Window
      //
      
      var lWindow := CreateWindowExW(0, szWindowClass, szTitle, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, nil, nil, lWindowClass.hInstance, nil);
      if lWindow = nil then begin 
        MessageBox(nil, 'Call to CreateWindowExW failed', szTitle, 0);
        exit 0;
      end;
      
      //
      // Add a button to it
      //
      
      fButton := CreateWindowEx(0, 
                               'BUTTON',   // Predefined class; Unicode assumed 
                               'Click Me', // Button text 
                               WS_TABSTOP or WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,  // Styles 
                               130,        // x position 
                               70,         // y position 
                               100,        // Button width
                               25,         // Button height
                               lWindow,      // Parent window
                               nil,        // No menu.
                               lWindowClass.hInstance, 
                               nil);       // Pointer not needed.
                      
      //
      // Show the Window
      //
      
      ShowWindow(lWindow, SW_SHOW);
      UpdateWindow(lWindow);
                               
      //
      // Finally, run the main Windows message loop
      //

      var lMsg: MSG;
      while GetMessage(@lMsg, nil, 0, 0) do begin
        TranslateMessage(@lMsg);
        DispatchMessage(@lMsg);
      end;

      result := Integer(lMsg.wParam);
    end;
    
  end;

end.
