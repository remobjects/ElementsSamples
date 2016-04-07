namespace UINavigationController
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
				title = "UINavigationController";
			}
			return this;
		}

		[IBAction]
    public void buttonPressed(id sender)
    {
        SecondViewController secondViewController = new SecondViewController();
        this.navigationController.pushViewController(secondViewController) animated(true); 
	  }
  }
}
