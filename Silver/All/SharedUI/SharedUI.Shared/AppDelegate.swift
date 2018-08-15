class AppDelegate {

	public private(set) var mainWindowController: MainWindowController!

	public func start() {
		//
		//  this is the cross-platform entry point for the app
		//

		mainWindowController = MainWindowController()
		mainWindowController.showWindow(nil)
	}
}