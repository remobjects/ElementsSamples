namespace UINavigationController
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{
		public this() : base withNibName("RootViewController") bundle(null)
		{
		  title = "UINavigationController";

		}

		[IBAction]
    public void buttonPressed(id sender)
    {
        SecondViewController secondViewController = new SecondViewController();
        this.navigationController.pushViewController(secondViewController) animated(true);
	  }
  }
}
