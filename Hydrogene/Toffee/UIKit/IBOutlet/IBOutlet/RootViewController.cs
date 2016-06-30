namespace CSharpiOSIBOutletDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{

    [IBOutlet]
    public UILabel label;

		public override id init()
		{
			this = base.initWithNibName("RootViewController") bundle(null);
			if (this != null)
			{
				title = "CSharp iOS IBOutlet Demo";
			}
			return this;
		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			this.label.textColor = UIColor.redColor;
      this.label.text = "IBOutlet Demo Text";
		}

	}
}
