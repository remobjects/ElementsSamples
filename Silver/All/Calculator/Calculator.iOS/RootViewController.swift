import UIKit

@IBObject class RootViewController : UIViewController {

	@IBOutlet weak var edValue: UITextField!

	init() {

		super.init(nibName: "RootViewController", bundle: nil)
		title = "Calculator.iOS";
	}

	public override func viewDidLoad() {

		super.viewDidLoad();
		// Do any additional setup after loading the view.
	}

	public override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning();
	// Dispose of any resources that can be recreated.
	}

	@IBAction
	public func pressBackButton(_ sender: id!) {
		var s = edValue.text
		if let s = s, s.length > 0 {
			edValue.text = s.substringToIndex(s.length - 1)
		}
	}
	
	@IBAction
	public func pressExitButton(_ sender: id!) {
		dismissViewControllerAnimated(true, completion:{ });
	}

	@IBAction
	public func pressEvaluateButton(_ sender: id!) {
		__try {
			var eval = Evaluator()
			edValue.text = "" + eval.Evaluate(edValue.text as! Sugar.String)
		} __catch e: EvaluatorError {
			var alert = UIAlertView(title: "Calculator", message: "Error evaluation: " + e.reason , delegate:  nil, cancelButtonTitle:  "OK", otherButtonTitles:  nil)
			alert.show()
		}
	}

	@IBAction
	public func pressCharButton(_ sender: id!) {
		edValue.text += (sender as! UIButton).titleLabel?.text
	}
}
