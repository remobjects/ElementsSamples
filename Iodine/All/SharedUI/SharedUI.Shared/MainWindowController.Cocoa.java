package SharedUI.Shared;

#if TOFFEE

@IBObject
public __partial class MainWindowController extends NSWindowController
{
	public MainWindowController()
	{
		super("MainWindow");
		setup();
	}

	@Override
	public void windowDidLoad()
	{
		super.windowDidLoad();
		//  Implement this method to handle any initialization after your window controller's
		//  window has been loaded from its nib file.
	}
}

#endif