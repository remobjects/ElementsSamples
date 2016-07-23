import AppKit

@NSApplicationMain @IBObject class AppDelegate : INSApplicationDelegate {

	var mainWindowController: MainWindowController?

	@objc public func applicationDidFinishLaunching(_ notification: NSNotification!) {

		mainWindowController = MainWindowController();
		mainWindowController?.showWindow(nil);
	}

}
