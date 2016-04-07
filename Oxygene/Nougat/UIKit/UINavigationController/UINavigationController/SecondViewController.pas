namespace UINavigationController;

interface

uses
  UIKit;

type
  [IBObject]
  SecondViewController = public class(UIViewController)
  private
  public
    method init: id; override;
    method viewDidLoad; override;
    [IBAction] method buttonPressed(sender: id);
    method otherButtonPressed;
  end;

implementation

method SecondViewController.init: id;
begin
  self := inherited initWithNibName("SecondViewController") bundle(nil);
  if assigned(self) then begin
    self.title := "Second View Controller";
  end;
  result := self;
end;

method SecondViewController.buttonPressed(sender: id);
begin
  self.navigationController.popToRootViewControllerAnimated(true);
end;

method SecondViewController.otherButtonPressed;
begin
  var message := new UIAlertView withTitle("Search") message("If this were a real application you would now be in the DO STUFF mode") &delegate(nil) cancelButtonTitle("OK") otherButtonTitles(nil);
  message.show();
end;

method SecondViewController.viewDidLoad;
begin
  inherited viewDidLoad;
  var rightButton := new UIBarButtonItem withTitle("Do Stuff") style(UIBarButtonItemStyle.UIBarButtonItemStylePlain) &target(self) action(selector(otherButtonPressed)); 
  self.navigationItem.rightBarButtonItem := rightButton;
end;

end.
