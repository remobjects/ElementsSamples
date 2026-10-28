namespace UINavigationController;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);
      title := 'UINavigationController';
    end;

    [IBAction] method buttonPressed(sender :id);
    begin
      var secondViewController := new SecondViewController();
      self.navigationController.pushViewController(secondViewController) animated(true);
    end;

  end;

end.
