Imports rtl

Public Module Program
	Dim button As HWND = Null
	Const szTitle As LPCWSTR = "RemObjects Elements — Island Windows Sample"
	Const szWindowClass As LPCWSTR = "IslandWindowsSample"

	<CallingConvention(CallingConvention.Stdcall)> _
	Function WndProc(hWnd As HWND, message As UINT, wParam As WPARAM, lParam As LPARAM) As Integer

		Select Case message
			Case WM_COMMAND:
				If (wParam = BN_CLICKED) And (lParam = TryCast(button, rtl.LPARAM)) Then
					MessageBox(hWnd, "You clicked, hello there!", szTitle, 0)
				End If
			Case WM_CLOSE:
				PostQuitMessage(0)
		End Select
		Return DefWindowProc(hWnd, message, wParam, lParam)

	End Function

	Shared Function Main(args As String()) As Int32
		'
		'  Set up and Register the Windows Class
		'
		Dim windowClass As WNDCLASSEX
		windowClass.cbSize = sizeOf(WNDCLASSEX)
		windowClass.style = CS_HREDRAW Or CS_VREDRAW
		windowClass.lpfnWndProc = AddressOf WndProc
		windowClass.cbClsExtra = 0
		windowClass.cbWndExtra = 0
		windowClass.hInstance = rtl.GetModuleHandleW(Null)
		windowClass.hIcon = LoadIcon(windowClass.hInstance, TryCast(IDI_APPLICATION, LPCWSTR))
		windowClass.hCursor = LoadCursor(Null, TryCast(IDC_ARROW, LPCWSTR))
		windowClass.hbrBackground = TryCast(COLOR_WINDOW + 1, HBRUSH)
		windowClass.lpszMenuName = Null
		windowClass.lpszClassName = szWindowClass

		If RegisterClassEx(AddressOf windowClass) = 0 Then
			MessageBox(Null, "Call to RegisterClassEx failed", szTitle, 0)
			Return 1
		End If

		'
		'  Create the Window
		'
		Dim window = CreateWindowExW(0, szWindowClass, szTitle, WS_OVERLAPPED Or WS_CAPTION Or WS_SYSMENU, CW_USEDEFAULT, CW_USEDEFAULT, 400, 300, Null, Null, windowClass.hInstance, Null)
		If window = Null Then
			MessageBox(Null, "Call to CreateWindowExW failed", szTitle, 0)
			Return 1
		End If

		'
		'  Add a button to it
		'
		button = CreateWindowEx(0, "BUTTON", "Click Me", WS_TABSTOP Or WS_VISIBLE Or WS_CHILD Or BS_DEFPUSHBUTTON, 130, 70, 100, 25, window, Null, windowClass.hInstance, Null)

		'
		'  Show the Window
		'
		ShowWindow(window, SW_SHOW)
		UpdateWindow(window)
		'
		'  Finally, run the main Windows message loop
		'
		Dim msg As MSG = Nothing
		Do While GetMessage(AddressOf msg, Null, 0, 0)
			TranslateMessage(AddressOf msg)
			DispatchMessage(AddressOf msg)
		Loop

		Return msg.wParam
	End Function

End Module