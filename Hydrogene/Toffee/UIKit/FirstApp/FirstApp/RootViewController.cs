namespace FirstCSharpiOSApp
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
				title = "My First iOS App";
			}
			return this;
		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			
      //Create a Frame To Work With
      CGRect frame = CGRectMake(0, 0, 320, 200);

      //Create a new label based on the frame.
      UILabel label = new UILabel withFrame(frame);

      //Set some properties of the label
      label.textColor = UIColor.blueColor;
      label.font =  UIFont.fontWithName("American Typewriter") size(30);
      label.textAlignment = NSTextAlignment.NSTextAlignmentCenter;
      label.text  = "My First iOS App.";

      //Add the label to the view
      self.view.addSubview(label);
		}

	}
}
