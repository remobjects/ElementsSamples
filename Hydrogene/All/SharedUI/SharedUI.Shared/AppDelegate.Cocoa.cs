namespace SharedUI.Shared
{
	#if TOFFEE
	[NSApplicationMain, IBObject]
	public partial class AppDelegate : INSApplicationDelegate
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
}