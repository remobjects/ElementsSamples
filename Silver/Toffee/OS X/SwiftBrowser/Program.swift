// Sample from http://practicalswift.com/2014/06/27/a-minimal-webkit-browser-in-30-lines-of-swift/

import Foundation
import AppKit
import WebKit

let application = NSApplication.sharedApplication()
application.setActivationPolicy(.Regular)
let window = NSWindow(contentRect: NSMakeRect(0, 0, 1000, 600),
					  styleMask:  NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, 
					  backing: .Buffered, // note: this needs NSBackingStoreBuffered if building for 10.9 or earlier
					  `defer`: false) 
window.center()
window.title = "Minimal Swift WebKit Browser"
window.makeKeyAndOrderFront(window)

class WindowDelegate: NSObject, INSWindowDelegate {
	func windowWillClose(notification: NSNotification?) {
		NSApplication.sharedApplication().terminate(0)
	}
}

let windowDelegate = WindowDelegate()
window.delegate = windowDelegate

class ApplicationDelegate: NSObject, INSApplicationDelegate {
	var _window: NSWindow
	init(window: NSWindow) {
		self._window = window
	}
	func applicationDidFinishLaunching(notification: NSNotification?) {
		let webView = WebView(frame: self._window.contentView.frame)
		self._window.contentView.addSubview(webView)
		webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.elementscompiler.com/elements/silver")))
	}
}

let applicationDelegate = ApplicationDelegate(window: window)
application.delegate = applicationDelegate
application.activateIgnoringOtherApps(true)
application.run()

return 0