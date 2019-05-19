#if ECHOES

import System.Windows;
import System.Windows.Controls;

__partial class MainWindow : Window {

	private var controller: MainWindowController {
		return DataContext as! MainWindowController
	}

	public init(controller: MainWindowController!) {
		DataContext = controller
		InitializeComponent()
	}

	//
	// Forward actions to the controller
	//

	private func CalculateResult_Click(_ sender: Object!, _ e: RoutedEventArgs!) {
		controller.calculateResult(sender)
	}
}

#endif