using UIKit;
using Calculator.Engine;

namespace Calculator.iOS
{
	[IBObject]
	class RootViewController : UIViewController 
	{
		[IBOutlet] 
		__weak UITextField edValue;

		public override instancetype init()
		{
			base.initWithNibName("RootViewController") bundle(null);
			title = "Calculator.iOS";
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

		[IBAction]
		public void pressBackButton(id sender) 
		{
			var s = edValue.text;
			if (s.length > 0)
			{
				s = s.substringToIndex(s.length - 1);
				edValue.text = s;
			}
		}

		[IBAction]
		public void pressExitButton(id sender) 
		{
			this.dismissViewControllerAnimated(true) completion(null);
		}

		[IBAction]
		public void pressEvaluateButton(id sender) 
		{
			try 
			{
				var eval = new Evaluator();
				edValue.text = "" + eval.Evaluate(edValue.text);
			} 
			catch (EvaluatorError e)  
			{
				var alert = new UIAlertView withTitle("Calculator") message("Error evaluation: " + e.reason) @delegate(null) cancelButtonTitle("OK") otherButtonTitles(null);
				alert.show();
			}
		}

		[IBAction]
		public void pressCharButton(id sender) 
		{
			edValue.text += ((UIButton)sender).titleLabel.text;
		}
	}
}
