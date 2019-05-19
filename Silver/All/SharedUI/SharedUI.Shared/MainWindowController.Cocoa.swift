#if TOFFEE

@IBObject
extension MainWindowController : NSWindowController {

	public init() {
		super.init(windowNibName: "MainWindow")
		setup()
	}

	open override func windowDidLoad() {
		super.windowDidLoad()

		//  Implement this method to handle any initialization after your window controller's
		//  window has been loaded from its nib file.
	}


	//
	// Add Cocoa-specific code here
	//
}

#endif