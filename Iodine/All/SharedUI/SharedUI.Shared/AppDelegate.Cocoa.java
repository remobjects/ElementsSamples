package SharedUI.Shared;

#ifdef TOFFEE

@NSApplicationMain, @IBObject
public __partial class AppDelegate extends INSApplicationDelegate
{
	public void applicationDidFinishLaunching(NSNotification notification)
	{
		start();
	}

	//
	// Add Cocoa-specific code here
	//
}

#endif