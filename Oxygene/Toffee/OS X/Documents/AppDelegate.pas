namespace Documents;

interface

uses
  AppKit;

type
  [NSApplicationMain]
  [IBObject]
  AppDelegate = class(INSApplicationDelegate)
  public
	method applicationDidFinishLaunching(notification: NSNotification);
  end;

implementation

method AppDelegate.applicationDidFinishLaunching(notification: NSNotification);
begin
end;

end.