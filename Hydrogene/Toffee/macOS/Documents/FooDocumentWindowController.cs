using AppKit;

namespace Documents
{

	[IBObject]
	public class FooDocumentWindowController : NSWindowController
	{
		public this withDocument(FooDocument document) : base windowNibName("FooDocumentWindow")
		{
			_document = document;
		}

		public override void windowDidLoad() {

			base.windowDidLoad();

			// Implement this method to handle any initialization after your window controller's
			// window has been loaded from its nib file.
		}

		private FooDocument _document;
		public FooDocumentData? data { get { return _document.data; } }
	}
}