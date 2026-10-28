namespace CSharpiOSTableViewCellDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{
		public this() : base withNibName("RootViewController") bundle(null)
		{
		  title = "CSharpiOSTableViewCellDemo";

		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			// Do any additional setup after loading the view.
		}

		public override void didReceiveMemoryWarning()
		{
			base.didReceiveMemoryWarning();
		   // Dispose of any resources that can be recreated.
		}
	}
}
