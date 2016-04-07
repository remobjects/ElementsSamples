namespace Maps;

interface

uses
  UIKit;

type
  AppDelegate = class(IUIApplicationDelegate)
  private
  public
    property window: UIWindow;

    method application(application: UIApplication) didFinishLaunchingWithOptions(launchOptions: NSDictionary): Boolean;

  end;

implementation

method AppDelegate.application(application: UIApplication) didFinishLaunchingWithOptions(launchOptions: NSDictionary): Boolean;
begin
  result := true;
end;


end.
