namespace NSMenu
{
	using AppKit;

	[IBObject]
	public class AppDelegate : INSApplicationDelegate
	{
		public MainWindowController mainWindowController { get; set; }

		public void applicationDidFinishLaunching(NSNotification notification)
		{
			mainWindowController = new MainWindowController();
			mainWindowController.showWindow(null);
		}

	[IBAction]
	public void addMenus (id sender)
	{
		NSMenuItem mItem = (NSMenuItem)sender;
		NSMenuItem parent = mItem.parentItem;
		NSMenu menu = parent.submenu;

		//Remove the Add Menu Items Menu Item
		menu.removeItem(mItem);

		//Add The New Say Goodbye Item
		NSMenuItem menuItem = new NSMenuItem withTitle("Say Goodbye") action(__selector(sayGoodBye:)) keyEquivalent("b");
		// Note: on 10.9, this needs newItem.setKeyEquivalentModifierMask(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask);
		menuItem.setKeyEquivalentModifierMask(NSEventModifierFlags.NSControlKeyMask | NSEventModifierFlags.NSAlternateKeyMask | NSEventModifierFlags.NSCommandKeyMask);

		menu.addItem(menuItem);
	}

	[IBAction]
	public void sayHello(id sender)
	{
	   this.mainWindowController.sayHello();
	}

	public void sayGoodBye(id sender)
	{
		this.mainWindowController.sayGoodBye();
	}
		
	}
}