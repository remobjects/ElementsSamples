import AppKit

@IBObject class AppDelegate : INSApplicationDelegate {

	var mainWindowController: MainWindowController?

	public func applicationDidFinishLaunching(notification: NSNotification!) {

		mainWindowController = MainWindowController();
		mainWindowController?.showWindow(nil);
	}

}
