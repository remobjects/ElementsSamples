namespace CSharpiOSIBOutletDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{

		[IBOutlet]
		public UILabel label;

		public this() : base withNibName("RootViewController") bundle(null)
		{
		  title = "CSharp iOS IBOutlet Demo";

		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			this.label.textColor = UIColor.redColor;
			this.label.text = "IBOutlet Demo Text";
		}

	}
}