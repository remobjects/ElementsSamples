namespace OxygeneiOSUIAlertViewDemo;

interface

uses
  UIKit;
  

type
  [IBObject]
  RootViewController = public class(UIViewController, IUIAlertViewDelegate)
  private
    method alertView(alertView : UIAlertView) clickedButtonAtIndex(buttonIndex: NSInteger);
  public
    method init: id; override;

    [IBOutlet] messageField : UITextField;
    [IBAction] method sendMessage(sender: id);
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'Oxygene UIAlertView Demo';
  end;
  result := self;
end;

method  RootViewController.sendMessage(sender: id);
begin
  var message := new UIAlertView withTitle("Message") message(messageField.text) &delegate(self) cancelButtonTitle("OK") otherButtonTitles("More Info", "Even More Info", nil);
  message.show();
end;

method RootViewController.alertView(alertView : UIAlertView) clickedButtonAtIndex(buttonIndex: NSInteger);
begin
   case alertView.buttonTitleAtIndex(buttonIndex) of 
    "OK": NSLog("OK was selected.");
    "More Info": NSLog("More Info was selected.");
    "Even More Info": NSLog("Even More Info was selected.");
   end;
end;

end.
