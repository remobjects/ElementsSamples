using AppKit;

namespace Documents
{
	[IBObject]
	public class FooDocument : NSDocument
	{
		//
		// NSDocument implementation
		//

		public override this withType(NSString type) error(NSError *error) // workaround for invalid NSError pointer being passed in, sometimes
		{
			data = new FooDocumentData();
		}

		public override bool readFromURL(NSURL! url) ofType(NSString! typeName) error(ref NSError error)
		{
			return loadDocumentFromURL(url);
		}

		public override bool writeToURL(NSURL! url) ofType(NSString! typeName) forSaveOperation(NSSaveOperationType aveOperation) originalContentsURL(NSURL? absoluteOriginalContentsURL) error(ref NSError error)
		{
			return saveDocumentToURL(url);
		}

		public override void makeWindowControllers()
		{
			addWindowController(new FooDocumentWindowController withDocument(self));
		}

		public override static bool autosavesInPlace
		{
			get
			{
				return true; // enables the title bar menu, among other things
			}
		}

		//
		// Custom members
		//

		bool loadDocumentFromURL(NSURL url)
		{
			data = new FooDocumentData withURL(url);
			return data != null;
		}

		bool saveDocumentToURL(NSURL url)
		{
			if (data == null)
			return false;
			data.save(url);
			return true;
		}

		public FooDocumentData data { get; private set; }
	}

	//
	// data stored in the document:
	//

	public class FooDocumentData
	{
		public NSString text { get; set; }

		public this()
		{
			text = "New Foo!";
		}

		public this withURL(NSURL url)
		{
			if (File.Exists(url.path))
			text = File.ReadText(url.path);
			else
			return null;
		}

		public void save(NSURL url)
		{
			File.WriteText(url.path, text);
		}
	}
}