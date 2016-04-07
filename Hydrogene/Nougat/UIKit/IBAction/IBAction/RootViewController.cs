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

		public override id init()
		{
			this = base.initWithNibName("RootViewController") bundle(null);
			if (this != null)
			{
				title = "iOS IBAction Demo";
			}
			return this;
		}

    [IBAction]
    public void buttonTapped(id sender)
    {
       label.text = "Button Was Tapped";
    }
	
	}
}
