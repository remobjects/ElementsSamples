namespace GLExample;

interface

uses
  AppKit,
  GlHelper,
  Foundation;

type
  [NSApplicationMain, IBObject]
  AppDelegate = class(INSApplicationDelegate)
  private
    fMainWindowController: MainWindowController;

  protected
  public
    method applicationDidFinishLaunching(aNotification: NSNotification);
    method applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) : Boolean;
  end;

implementation

method AppDelegate.applicationDidFinishLaunching(aNotification: NSNotification);
begin
  fMainWindowController := new MainWindowController();
  fMainWindowController.showWindow(nil);

end;

method AppDelegate.applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) : Boolean;
begin
  exit true;
end;

end.