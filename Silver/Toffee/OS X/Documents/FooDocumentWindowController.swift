import AppKit

@IBObject public class FooDocumentWindowController : NSWindowController {

	init(document: FooDocument) {

		_document = document
		super.init(windowNibName: "FooDocumentWindow")
	}

	public override func windowDidLoad() {

		super.windowDidLoad()

		// Implement this method to handle any initialization after your window controller's
		// window has been loaded from its nib file.
	}

	private var _document: FooDocument
	public var data: FooDocumentData? { return _document.data }

}