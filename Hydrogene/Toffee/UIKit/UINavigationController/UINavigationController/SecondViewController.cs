using UIKit;

namespace UINavigationController
{
	[IBObject]
	public class SecondViewController: UIViewController
	{
		public override id init()
		{
			this = base.initWithNibName("SecondViewController") bundle(null);
      if (this != null) {
        this.title = "Second View Controller";
	    }
			return this;
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
         UIAlertView message = new UIAlertView withTitle("Search Selected") message("If this were a real application you would now go into the DO STUFF mode") @delegate(null) cancelButtonTitle("OK") otherButtonTitles(null);
         message.show();
    }
	}
}