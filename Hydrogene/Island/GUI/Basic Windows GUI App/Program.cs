using rtl;

namespace BasicWindowsApp
{

	class Program
	{
  
		const LPCWSTR szTitle = "RemObjects Elements — Island Windows Sample";
		const LPCWSTR szWindowClass = "IslandWindowsSample";
		static HWND button = 0;
	
		[CallingConvention(CallingConvention.Stdcall)]
		static int WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
		{
			switch (message)
			{
				case WM_COMMAND:
				{
					if (wParam == BN_CLICKED && lParam == (rtl.LPARAM)button)
					{
						MessageBox(hWnd, "You clicked, hello there!", szTitle, 0);
					}
					break;
				}
				case WM_CLOSE:
				{
					PostQuitMessage(0);
					break;
				}
			}
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
	
		static Int32 Main(string[] args)
		{
			//
			// Set up and Register the Windows Class
			//
	  
			WNDCLASSEX windowClass; 
			windowClass.cbSize = sizeOf(WNDCLASSEX);
			windowClass.style = CS_HREDRAW | CS_VREDRAW;
			windowClass.lpfnWndProc = WndProc;
			windowClass.cbClsExtra = 0;
			windowClass.cbWndExtra = 0;
			windowClass.hInstance = rtl.GetModuleHandleW(null);
			windowClass.hIcon = LoadIcon(windowClass.hInstance, (LPCWSTR)IDI_APPLICATION);
			windowClass.hCursor = LoadCursor(null, (LPCWSTR)IDC_ARROW);
			windowClass.hbrBackground = (void *)(COLOR_WINDOW + 1);
			windowClass.lpszMenuName = null;
			windowClass.lpszClassName = szWindowClass;
	  
			if (RegisterClassEx(&windowClass) == 0)
			{
				MessageBox(null, "Call to RegisterClassEx failed", szTitle, 0);
				return 1;
			}
	  
			//
			// Create the Window
			//
	  
			var window = CreateWindowExW(0, szWindowClass, szTitle, WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, null, null, windowClass.hInstance, null);
			if (window == null) {
				MessageBox(null, "Call to CreateWindowExW failed", szTitle, 0);
				return 1;
			}
	  
			//
			// Add a button to it
			//
	  
			button = CreateWindowEx(0, 
									"BUTTON",   // Predefined class Unicode assumed 
									"Click Me", // Button text 
									WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,  // Styles 
									130,		// x position 
									70,		 // y position 
									100,		// Button width
									25,		 // Button height
									window,	// Parent window
									null,		// No menu.
									windowClass.hInstance, 
									null);	  // Pointer not needed.
					  
			//
			// Show the Window
			//
	  
			ShowWindow(window, SW_SHOW);
			UpdateWindow(window);

			//
			// Finally, run the main Windows message loop
			//

			MSG msg = default(MSG);
			while (GetMessage(&msg, null, 0, 0)) {
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
			return msg.wParam;
		}					   
	}
}