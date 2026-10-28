namespace CSharpiOSIBActionDemo
{
	using UIKit;

	[IBObject]
  public class RootViewController : UIViewController
	{


	  private UILabel fLabel;

    [IBOutlet]
    public UILabel label
    {
        get {
           return fLabel;
        }

        set {
            fLabel = value;
        }
		}

		public this() : base withNibName("RootViewController") bundle(null)
		{
		  title = "iOS IBAction Demo";

		}

    [IBAction]
    public void buttonTapped(id sender)
    {
       label.text = "Button Was Tapped";
    }

	}
}
