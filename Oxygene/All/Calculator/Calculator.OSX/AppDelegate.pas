namespace Calculator.OSX;

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
    method applicationDidFinishLaunching(aNotification: NSNotification);
  end;

implementation

method AppDelegate.applicationDidFinishLaunching(aNotification: NSNotification);
begin
  fMainWindowController := new MainWindowController();
  fMainWindowController.showWindow(nil);
end;

end.