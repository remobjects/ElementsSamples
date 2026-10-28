namespace FirstCSharpiOSApp
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{
		public this() : base withNibName("RootViewController") bundle(null)
		{
		  title = "My First iOS App";

		}

		public override void viewDidLoad()
		{
      base.viewDidLoad();
      view.backgroundColor = UIColor.systemBackgroundColor;
      var label = new UILabel();
      label.translatesAutoresizingMaskIntoConstraints = false;
      label.text = "My First iOS App.";
      label.textColor = UIColor.labelColor;
      label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1);
      label.adjustsFontForContentSizeCategory = true;
      label.numberOfLines = 0;
      label.textAlignment = NSTextAlignment.Center;
      view.addSubview(label);

      // Safe-area constraints adapt to rotation, resizing and larger text.
      var guide = view.safeAreaLayoutGuide;
      label.leadingAnchor.constraintEqualToAnchor(guide.leadingAnchor) constant(20).active = true;
      label.trailingAnchor.constraintEqualToAnchor(guide.trailingAnchor) constant(-20).active = true;
      label.centerYAnchor.constraintEqualToAnchor(guide.centerYAnchor).active = true;
    }

	}
}
