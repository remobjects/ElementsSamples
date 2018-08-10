using System.Windows;
using SharedUI.Shared;

namespace SharedUI.WPF
{
	public partial class App : Application
	{
		private AppDelegate appDelegate;

		protected override void OnStartup(StartupEventArgs e)
		{
			appDelegate = new AppDelegate();
			appDelegate.start();
		}

	}
}