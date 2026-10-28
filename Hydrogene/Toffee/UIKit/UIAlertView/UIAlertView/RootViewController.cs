namespace CSharpiOSUIAlertViewDemo
{
  using UIKit;

  [IBObject]
  class RootViewController : UIViewController
  {
    [IBOutlet] public UITextField messageField;

    public this() : base withNibName("RootViewController") bundle(null)
    {
      title = "Alerts";
    }

    [IBAction]
    public void sendMessage(id sender)
    {
      var alert = UIAlertController.alertControllerWithTitle("Message") message(messageField.text) preferredStyle(UIAlertControllerStyle.Alert);
      foreach (var title in new string[] { "OK", "More Info", "Even More Info" })
        alert.addAction(UIAlertAction.actionWithTitle(title) style(UIAlertActionStyle.Default) handler(action => NSLog("%@ was selected.", action.title)));
      presentViewController(alert) animated(true) completion(null);
    }
  }
}
