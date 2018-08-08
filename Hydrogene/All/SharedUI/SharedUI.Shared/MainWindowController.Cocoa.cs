namespace SharedUI.Shared
{
	#if TOFFEE
	using AppKit;

	[IBObject]
	public partial class MainWindowController : NSWindowController
	{
		public this() : base withWindowNibName("MainWindow")
		{
			setup();
		}

		public override void windowDidLoad()
		{
			base.windowDidLoad();

			// Implement this method to handle any initialization after your window controller's
			// window has been loaded from its nib file.
		}

	}
	#endif
}