using System.Windows;
using SharedUI.Shared;

namespace SharedUI.WPF
{
	public partial class App : Application
	{
		public MainWindowController mainWindowController { get; set; }

		protected override void OnStartup(StartupEventArgs e)
		{
			mainWindowController = new MainWindowController();
			mainWindowController.showWindow(null);
		}

	}
}