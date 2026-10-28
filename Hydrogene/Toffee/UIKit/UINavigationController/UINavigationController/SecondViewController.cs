using UIKit;

namespace UINavigationController
{
	[IBObject]
	public class SecondViewController: UIViewController
	{
		public this() : base withNibName("SecondViewController") bundle(null)
		{
		  this.title = "Second View Controller";

		}

    public override void viewDidLoad()
    {
        base.viewDidLoad();

        UIBarButtonItem rightButton = new UIBarButtonItem withTitle("Do Stuff") style(UIBarButtonItemStyle.UIBarButtonItemStylePlain) target(this) action(__selector(otherButtonPressed));
        self.navigationItem.rightBarButtonItem  = rightButton;

    }

    [IBAction]
    public void buttonPressed(id sender)
    {
        this.navigationController.popToRootViewControllerAnimated(true);
    }

    public void otherButtonPressed()
    {
         var message = UIAlertController.alertControllerWithTitle("Search Selected") message("If this were a real application you would now go into the DO STUFF mode") preferredStyle(UIAlertControllerStyle.Alert);
         message.addAction(UIAlertAction.actionWithTitle("OK") style(UIAlertActionStyle.Default) handler(null));
         presentViewController(message) animated(true) completion(null);
    }
	}
}