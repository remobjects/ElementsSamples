namespace UINavigationController;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  private
  public
    method init: id; override;
    [IBAction] method buttonPressed(sender :id);
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'UINavigationController';
  end;
  result := self;
end;

method RootViewController.buttonPressed(sender: id);
begin
  var secondViewController := new SecondViewController();
  self.navigationController.pushViewController(secondViewController) animated(true);
end;


end.
