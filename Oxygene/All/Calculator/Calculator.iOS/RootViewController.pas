namespace Calculator.iOS;

interface

uses
  UIKit,
  Calculator.Engine;

type
  [IBObject]
  RootViewController = private class(UIViewController)
    [IBOutlet]
    var edValue: weak UITextField;
  public
    method init: InstanceType; override;
    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;
    [IBAction]
    method pressBackButton(sender: id);
    [IBAction]
    method pressExitButton(sender: id);
    [IBAction]
    method pressEvaluateButton(sender: id);
    [IBAction]
    method pressCharButton(sender: id);
end;

implementation

method RootViewController.init: instancetype;
begin
  inherited initWithNibName("RootViewController") bundle(nil);
  title := 'Calculator.iOS';
end;

method RootViewController.viewDidLoad;
begin
  inherited viewDidLoad();
  // Do any additional setup after loading the view.
end;

method RootViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning();
  // Dispose of any resources that can be recreated.
end;

method RootViewController.pressBackButton(sender: id);
begin
  var s := edValue.text;
  if s.length > 0 then begin
    s := s.substringToIndex(s.length - 1);
    edValue.text := s;
  end;
end;

method RootViewController.pressExitButton(sender: id);
begin
  self.dismissViewControllerAnimated(true) completion(nil);
end;

method RootViewController.pressEvaluateButton(sender: id);
begin
  try
    var eval := new Evaluator();
    edValue.text := '' + eval.Evaluate(edValue.text);
  except
    on e: EvaluatorError do begin
      var alert := UIAlertController.alertControllerWithTitle("Calculator!") message("Error evaluation: "+e.reason) preferredStyle(UIAlertControllerStyle.Alert);
      presentViewController(alert) animated (true) completion(nil);
    end;
  end;
end;

method RootViewController.pressCharButton(sender: id);
begin
  edValue.text := (UIButton(sender)).titleLabel.text;
end;

end.