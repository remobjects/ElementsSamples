import System.Windows

open __partial class App : Application {

	private var appDelegate: AppDelegate!

	open override func OnStartup(_ e: StartupEventArgs!) {
		appDelegate = AppDelegate()
		appDelegate.start()
	}
}