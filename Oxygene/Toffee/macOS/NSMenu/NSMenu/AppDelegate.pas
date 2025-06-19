namespace NSMenu;

interface

uses
  AppKit,
  Foundation;

type
  [IBObject]
  AppDelegate = public class(INSApplicationDelegate)
  private
    fMainWindowController: MainWindowController;
  protected
  public
    [IBAction] method addNewMenus(sender : id);
    [IBAction] method sayHello(sender : id);
    method sayGoodBye(sender : id);

    method applicationDidFinishLaunching(aNotification: NSNotification);
  end;

implementation

method AppDelegate.applicationDidFinishLaunching(aNotification: NSNotification);
begin
  fMainWindowController := new MainWindowController();
  fMainWindowController.showWindow(nil);
end;

method AppDelegate.addNewMenus(sender: id);
begin
  var mItem : NSMenuItem := sender as NSMenuItem;
  var parent : NSMenuItem := mItem.parentItem;
  var menu : NSMenu := parent.submenu;
  
  //Remove The Add Menu Item
  menu.removeItem(mItem);
  
  //Add The Say GoodBye Menu Item
  var newItem := new NSMenuItem() withTitle("Say GoodBye") action(selector(sayGoodBye:)) keyEquivalent("b");
  // Note: on 10.9, this needs newItem.setKeyEquivalentModifierMask(NSControlKeyMask or NSAlternateKeyMask or NSCommandKeyMask);
  newItem.setKeyEquivalentModifierMask(NSEventModifierFlags.NSControlKeyMask or NSEventModifierFlags.NSAlternateKeyMask or NSEventModifierFlags.NSCommandKeyMask);
  menu.addItem(newItem);

end;

method AppDelegate.sayHello(sender: id);
begin
  if assigned(fMainWindowController) then begin
    fMainWindowController.sayHello();
  end;
end;

method AppDelegate.sayGoodBye(sender: id);
begin
  if assigned(fMainWindowController) then begin
    fMainWindowController.sayGoodBye();
  end;
end;

end.
