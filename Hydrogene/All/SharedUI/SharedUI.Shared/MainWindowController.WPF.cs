namespace SharedUI.Shared
{
	#if ECHOES
	using System.Windows;
	using System.Windows.Controls;

	public partial class MainWindowController
	{
		public this()
		{
			window = new MainWindow withController(this);
			setup();
		}

		public Window window { get; }

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
}