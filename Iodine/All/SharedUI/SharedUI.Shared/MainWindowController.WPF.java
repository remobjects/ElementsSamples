package SharedUI.Shared;

#if ECHOES

import System.Windows.*;
import System.Windows.Controls.*;

public __partial class MainWindowController
{
	public Window window { __get; }

	public MainWindowController()
	{
		window = new MainWindow(this);
		setup();
	}

	//
	// Compatibility Helpers. These could/should be in a shared base class, in a real app with many window/views
	//

	public void showWindow(id sender)
	{
		window.Show();
	}


	//
	// Add WPF-specific code here
	//
}

#endif