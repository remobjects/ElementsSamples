namespace BasicApplication
{
	using AppKit;

	[IBObject]
	public class MainWindowController : NSWindowController
	{

    [IBOutlet]
    public NSTextField textField;

    [IBOutlet]
    public NSTextField displayMessage;

		public override id init()
		{
			this = base.initWithWindowNibName("MainWindowController");
			return this;
		}

	  [IBAction]
    public void submitButtonPressed( id sender)
    {
        this.displayMessage.stringValue = this.textField.stringValue;
    }
	}
}
