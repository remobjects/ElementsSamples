namespace OxygeneiOSUIAlertViewDemo;

uses UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    [IBOutlet] property messageField: UITextField;

    constructor;
    begin
      inherited constructor withNibName("RootViewController") bundle(nil);
      title := "Alerts";
    end;

    [IBAction]
    method sendMessage(aSender: id);
    begin
      var lAlert := UIAlertController.alertControllerWithTitle("Message") message(messageField.text) preferredStyle(UIAlertControllerStyle.Alert);
      for each lTitle in ["OK", "More Info", "Even More Info"] do
        lAlert.addAction(UIAlertAction.actionWithTitle(lTitle) style(UIAlertActionStyle.Default) handler(aAction -> NSLog("%@ was selected.", aAction.title)));
      presentViewController(lAlert) animated(true) completion(nil);
    end;

  end;

end.
