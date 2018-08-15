#if ECHOES

import System.Windows;
import System.Windows.Controls;

extension MainWindowController {

	let window: Window

	public init() {
		window = MainWindow(controller: self)
		setup()
	}

	//
	// Compatibility Helpers. These could/should be in a shared base class, in a real app with many window/views
	//

	public func showWindow(_ sender: id!) {
		window.Show()
	}

	//
	// Add WPF-specific code here
	//
}

#endif