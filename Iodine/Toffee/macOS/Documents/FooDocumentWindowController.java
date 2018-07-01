package Documents;

import AppKit.*;

@IBObject public class FooDocumentWindowController extends NSWindowController {

	public this withDocument(FooDocument document) {

		_document = document;
		super windowNibName("FooDocumentWindow");
	}

	@Override public void windowDidLoad() {

		super.windowDidLoad();

		// Implement this method to handle any initialization after your window controller's
		// window has been loaded from its nib file.
	}

	private FooDocument _document;
	public FooDocumentData? data { __get { return _document.data; } }

}