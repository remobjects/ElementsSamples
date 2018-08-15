#if TOFFEE

@NSApplicationMain @IBObject
extension AppDelegate : INSApplicationDelegate {

	public func applicationDidFinishLaunching(_ notification: NSNotification!) {
		start()
	}

	//
	// Add Cocoa-specific code here
	//
}

#endif