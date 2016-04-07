using AppKit;
using Calculator.Engine;

namespace Calculator.OSX
{
	[IBObject]
	public class MainWindowController : NSWindowController {

		[IBOutlet]
		__weak NSTextField edValue;
		
		public override instancetype init()
		{			
			base.initWithWindowNibName("MainWindowController");			
			// Custom initialization
		}

		public override void windowDidLoad()
		{
			base.windowDidLoad();

			// Implement this method to handle any initialization after your window controller's
			// window has been loaded from its nib file.
		}

		[IBAction]
		public void pressBackButton(id sender) 
		{
			var s = edValue.stringValue;
			if (s.length > 0)
			{
				s = s.substringToIndex(s.length - 1);
				edValue.stringValue = s;
			}
		}

		[IBAction]
		public void pressExitButton(id sender) 
		{
			close();
		}

		[IBAction]
		public void pressEvaluateButton(id sender) 
		{
			try
			{
				var eval = new Evaluator();
				edValue.stringValue = "" + eval.Evaluate(edValue.stringValue);
			} 
			catch (EvaluatorError e) 
			{
				var alert = new NSAlert();
				alert.messageText = "Error evaluating: " + e.reason;
				alert.runModal();
			}
		}

		[IBAction]
		public void pressCharButton(id sender) 
		{
			edValue.stringValue += ((NSButton)sender).title;
		}
	}
}
