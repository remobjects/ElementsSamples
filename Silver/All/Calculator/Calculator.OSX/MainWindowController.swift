import AppKit

@IBObject public class MainWindowController : NSWindowController {

	@IBOutlet weak var edValue: NSTextField!
	init() {

		super.init(windowNibName: "MainWindowController");

		// Custom initialization
	}

	public override func windowDidLoad() {

		super.windowDidLoad();

		// Implement this method to handle any initialization after your window controller's
	// window has been loaded from its nib file.
	}

	@IBAction
	public func pressBackButton(sender: id!) {
		var s = edValue.stringValue
		if s.length > 0 {
			s = s.substringToIndex(s.length - 1)
			edValue.stringValue = s
		}
	}

	@IBAction
	public func pressExitButton(sender: id!) {
		close()
	}

	@IBAction
	public func pressEvaluateButton(sender: id!) {
		__try {
			var eval = Evaluator()
			edValue.stringValue = "" + eval.Evaluate(edValue.stringValue)
		} __catch e: EvaluatorError {
		var alert = NSAlert()
			alert.messageText = "Error evaluating: " + e.reason
			alert.runModal()
		}
	}

	@IBAction
	public func pressCharButton(sender: id!) {
		edValue.stringValue += (sender as! NSButton).title
	}
}
