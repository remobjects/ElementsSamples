namespace NSMenu
{
	using AppKit;

	[IBObject]
	public class MainWindowController : NSWindowController
	{

    [IBOutlet]
    public NSTextField messageLabel;

		public override id init()
		{
			this = base.initWithWindowNibName("MainWindowController");
			return this;
		}

    public void sayHello()
    {
        this.messageLabel.stringValue = "Hello";
    }


    public void sayGoodBye()
    {
        this.messageLabel.stringValue = "Goodbye";
    }

	

	}
}
