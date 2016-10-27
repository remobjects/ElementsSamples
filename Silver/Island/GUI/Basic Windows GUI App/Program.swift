import rtl

class Program {
  
    static let szTitle: LPCWSTR = "RemObjects Elements — Island Windows Sample"
    static let  szWindowClass: LPCWSTR = "IslandWindowsSample"
    static var button: HWND = 0
    
    @CallingConvention(CallingConvention.Stdcall)
    static func WndProc(_ hWnd: HWND, _ message: UINT, _ wParam: WPARAM, _ lParam: LPARAM) -> Integer {
        switch message {
            case WM_COMMAND:
                if wParam == BN_CLICKED && lParam == rtl.LPARAM(button) {
                    MessageBox(hWnd, "You clicked, hello there!", szTitle, 0)
                }
            case WM_CLOSE:
                PostQuitMessage(0)
            default:
        }
        return DefWindowProc(hWnd, message, wParam, lParam)
    }
    
    static func SetupWindow() -> Bool {
      
        //
        // Set up and Register the Windows Class
        //
      
        var windowClass: WNDCLASSEX
        windowClass.cbSize = sizeOf(WNDCLASSEX)
        windowClass.style = CS_HREDRAW | CS_VREDRAW
        windowClass.lpfnWndProc = WndProc
        windowClass.cbClsExtra = 0
        windowClass.cbWndExtra = 0
        windowClass.hInstance = rtl.GetModuleHandleW(nil)
        windowClass.hIcon = LoadIcon(windowClass.hInstance, LPCWSTR(IDI_APPLICATION))
        windowClass.hCursor = LoadCursor(nil, LPCWSTR(IDC_ARROW))
        windowClass.hbrBackground = (COLOR_WINDOW + 1) as! UnsafePointer<Void>
        windowClass.lpszMenuName = nil
        windowClass.lpszClassName = szWindowClass
      
        if RegisterClassEx(&windowClass) == 0 {
            MessageBox(nil, "Call to RegisterClassEx failed", szTitle, 0)
            return false
        }
      
        //
        // Create the Window
        //
      
        var window = CreateWindowExW(0, szWindowClass, szTitle, WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, nil, nil, windowClass.hInstance, nil)
        if window == nil {
            MessageBox(nil, "Call to CreateWindowExW failed", szTitle, 0)
            return false
        }
      
        //
        // Add a button to it
        //
      
        button = CreateWindowEx(0, 
                                "BUTTON",   // Predefined class Unicode assumed 
                                "Click Me", // Button text 
                                WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,  // Styles 
                                130,        // x position 
                                70,         // y position 
                                100,        // Button width
                                25,         // Button height
                                window,    // Parent window
                                nil,        // No menu.
                                windowClass.hInstance, 
                                nil)       // Pointer not needed.
                      
        //
        // Show the Window
        //
      
        ShowWindow(window, SW_SHOW)
        UpdateWindow(window)
        return true
    }
                               
}

if !Program.SetupWindow() {
    return -1
}

//
// Finally, run the main Windows message loop
//

var msg: MSG = `default`(MSG)
while GetMessage((&msg), nil, 0, 0) {
    TranslateMessage(&msg)
    DispatchMessage(&msg)
}

return msg.wParam
