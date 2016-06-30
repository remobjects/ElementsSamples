namespace OxygeneiOSUITableViewCellDemo;

interface

uses
  UIKit;

type
  [IBObject]
  AppDelegate = class(IUIApplicationDelegate)
  private
  public
    property window: UIWindow;

    method application(application: UIApplication) didFinishLaunchingWithOptions(launchOptions: NSDictionary): Boolean;
  

  end;

implementation

method AppDelegate.application(application: UIApplication) didFinishLaunchingWithOptions(launchOptions: NSDictionary): Boolean;
begin
  window := new UIWindow withFrame(UIScreen.mainScreen.bounds);
  window.rootViewController := new UINavigationController withRootViewController(new RootViewController);
  window.makeKeyAndVisible;
  result := true;
end;



end.
