package Documents;

import AppKit.*;

@objc public class FooDocument extends NSDocument {

	//
	// NSDocument implementation
	//

	@Override this withType(NSString type) error(NSError *error) { // workaround for invalid NSError pointer being passed in, sometimes
		data = new FooDocumentData();
	}

	@Override public boolean readFromURL(NSURL! url) ofType(NSString! typeName) error(__ref NSError error) {
		return loadDocumentFromURL(url);
	}

	@Override public boolean writeToURL(NSURL! url) ofType(NSString! typeName) forSaveOperation(NSSaveOperationType aveOperation) originalContentsURL(NSURL? absoluteOriginalContentsURL) error(__ref NSError error) {
		return saveDocumentToURL(url);
	}

	@Override public void makeWindowControllers() {
		addWindowController(new FooDocumentWindowController withDocument(self));
	}

	@Override public static boolean autosavesInPlace {
		__get {
			return true; // enables the title bar menu, among other things
		}
	}

	//
	// Custom members
	//

	boolean loadDocumentFromURL(NSURL url) {
		data = new FooDocumentData withURL(url);
		return data != null;
	}

	boolean saveDocumentToURL(NSURL url) {
		if (data == null)
			return false;
		data.save(url);
		return true;
	}

	public FooDocumentData data { __get; private __set; }
}

//
// data stored in the document:
//

public class FooDocumentData {

	public NSString text { __get; __set; }

	public this() {
		text = "New Foo!";
	}

	public this withURL(NSURL url) {
		if (File.Exists(url.path))
			text = File.ReadText(url.path);
		else
			return null;
	}

	public void save(NSURL url) {
		File.WriteText(url.path, text);
	}
}