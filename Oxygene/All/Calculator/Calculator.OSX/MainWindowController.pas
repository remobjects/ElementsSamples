namespace Calculator.OSX;

uses
  AppKit,
  Calculator.Engine;

type
  [IBObject]
  MainWindowController = public class(NSWindowController)
  private

    [IBOutlet] property edValue: weak NSTextField;
  public

    constructor;
    begin
      inherited constructor withWindowNibName('MainWindowController');
    end;
    method windowDidLoad; override;
    begin
      inherited windowDidLoad();
      // Implement this method to handle any initialization after your window controller's
      // window has been loaded from its nib file.
    end;
    [IBAction]
    method pressBackButton(sender: id);
    begin
      var s := edValue.stringValue;
      if s.length > 0 then begin
        s := s.substringToIndex(s.length - 1);
        edValue.stringValue := s;
      end;
    end;
    [IBAction]
    method pressExitButton(sender: id);
    begin
      close();
    end;
    [IBAction]
    method pressEvaluateButton(sender: id);
    begin
      try
        var eval := new Evaluator();
        edValue.stringValue := '' + eval.Evaluate(edValue.stringValue);
      except
        on e: EvaluatorError do
        begin
          var alert := new NSAlert();
          alert.messageText := 'Error evaluating: ' + e.reason;
          alert.runModal();
        end;
      end;
    end;
    [IBAction]
    method pressCharButton(sender: id);
    begin
      edValue.stringValue := edValue.stringValue + NSButton(sender).title;
    end;
  end;

end.