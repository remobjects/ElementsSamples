namespace CSharpiOSTableViewCellDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{
		public override id init()
		{
			this = base.initWithNibName("RootViewController") bundle(null);
			if (this != null)
			{
				title = "CSharpiOSTableViewCellDemo";
			}
			return this;
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
