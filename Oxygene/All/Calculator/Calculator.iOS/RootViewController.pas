namespace Calculator.iOS;

uses
  UIKit,
  Calculator.Engine;

type
  [IBObject]
  RootViewController = private class(UIViewController)
    [IBOutlet]
    var edValue: weak UITextField;
  public

    constructor;
    begin
      inherited constructor withNibName("RootViewController") bundle(nil);
      title := 'Calculator.iOS';
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad();
      // Do any additional setup after loading the view.
    end;

    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning();
      // Dispose of any resources that can be recreated.
    end;

    [IBAction]
    method pressBackButton(sender: id);
    begin
      var s := edValue.text;
      if s.length > 0 then begin
        s := s.substringToIndex(s.length - 1);
        edValue.text := s;
      end;
    end;

    [IBAction]
    method pressExitButton(sender: id);
    begin
      self.dismissViewControllerAnimated(true) completion(nil);
    end;

    [IBAction]
    method pressEvaluateButton(sender: id);
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

    [IBAction]
    method pressCharButton(sender: id);
    begin
      edValue.text := (UIButton(sender)).titleLabel.text;
    end;
end;

end.