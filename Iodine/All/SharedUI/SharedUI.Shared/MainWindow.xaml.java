package SharedUI.Shared;

#if ECHOES

import System.Windows.*;
import System.Windows.Controls.*;

public __partial class MainWindow extends Window
{
	private MainWindowController controller { __get { return (MainWindowController)DataContext; } }
} }

	public MainWindow(MainWindowController controller)
	{
		DataContext = controller;
		InitializeComponent();
	}

	//
	// Forward actions to the controller
	//

	private void CalculateResult_Click(Object sender, RoutedEventArgs e)
	{
		controller.calculateResult(sender);
	}
}

#endif