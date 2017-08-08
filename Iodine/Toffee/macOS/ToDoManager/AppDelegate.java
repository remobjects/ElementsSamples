package ToDoManager;

import AppKit.*;

@IBObject
@NSApplicationMain
public class AppDelegate implements INSApplicationDelegate
{
	public MainWindowController _mainWindowController;

	public void applicationDidFinishLaunching(NSNotification notification)
	{
		_mainWindowController = new MainWindowController();
		_mainWindowController.showWindow(null);
	}

	public void applicationWillTerminate(NSNotification notification)
	{
		DataLayer.getSharedInstance().save();
	}

}