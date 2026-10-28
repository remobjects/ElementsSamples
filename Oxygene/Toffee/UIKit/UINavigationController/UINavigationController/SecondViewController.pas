namespace UINavigationController;

uses
  UIKit;

type
  [IBObject]
  SecondViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName("SecondViewController") bundle(nil);
      self.title := "Second View Controller";
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;
      var rightButton := new UIBarButtonItem withTitle("Do Stuff") style(UIBarButtonItemStyle.UIBarButtonItemStylePlain) &target(self) action(selector(otherButtonPressed));
      self.navigationItem.rightBarButtonItem := rightButton;
    end;

    [IBAction] method buttonPressed(sender: id);
    begin
      self.navigationController.popToRootViewControllerAnimated(true);
    end;

    method otherButtonPressed;
    begin
      var message := UIAlertController.alertControllerWithTitle("Search") message("If this were a real application you would now be in the DO STUFF mode") preferredStyle(UIAlertControllerStyle.Alert);
      message.addAction(UIAlertAction.actionWithTitle("OK") style(UIAlertActionStyle.Default) handler(nil));
      presentViewController(message) animated(true) completion(nil);
    end;

  end;

end.
