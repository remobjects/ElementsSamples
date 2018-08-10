namespace SharedUI.Shared
{
	public partial class AppDelegate
	{
		public MainWindowController mainWindowController { get; private set; }

		public void start()
		{
			//
			// this is the cross-platform entry point for the app
			//

			mainWindowController = new MainWindowController();
			mainWindowController.showWindow(null);
		}

		//
		// Add Shared code here
		//
	}
}