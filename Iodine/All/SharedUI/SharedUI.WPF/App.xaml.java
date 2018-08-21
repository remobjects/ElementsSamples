package SharedUI.WPF;

import System.Windows.*;
import SharedUI.Shared.*;

public class App extends Application
{
	private AppDelegate appDelegate;

	@Override
	protected void OnStartup(StartupEventArgs e)
	{
		appDelegate = new AppDelegate();
		appDelegate.start();
	}
}