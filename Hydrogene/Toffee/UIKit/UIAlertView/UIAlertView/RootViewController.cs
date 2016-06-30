namespace CSharpiOSUIAlertViewDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController
	{

    [IBOutlet]
    public UITextField messageField;

		public override id init()
		{
			this = base.initWithNibName("RootViewController") bundle(null);
			if (this != null)
			{
				title = "CSharp UIAlertView Demo";
			}
			return this;
		}


    [IBAction]
		public  void sendMessage(id sender)
		{
			UIAlertView message = new UIAlertView withTitle("Message") message(this.messageField.text) @delegate(this) cancelButtonTitle("OK") otherButtonTitles("More Info", "Even More Info", null);
		  message.show();
		}

    
	  public void alertView(UIAlertView alertView) clickedButtonAtIndex(NSInteger buttonIndex)
    {
        string buttonText = alertView.buttonTitleAtIndex(buttonIndex);
        NSLog("Button Text:%@",buttonText );
        if (buttonText == "OK")
          NSLog("OK");
       
        switch (buttonText)
        {
           case "OK": 
			     {
					   NSLog("OK was selected.");
             break;
           }
        }
    }


	}
}
