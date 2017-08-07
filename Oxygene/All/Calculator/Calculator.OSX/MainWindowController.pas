namespace Calculator.OSX;

interface

uses
  AppKit,
  Calculator.Engine;

type
  [IBObject]
  MainWindowController = public class(NSWindowController)
  private
    var edValue: weak NSTextField;
  public
    method init: instancetype; override;
    method windowDidLoad; override;
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

method MainWindowController.init: instancetype;
begin
  inherited initWithWindowNibName('MainWindowController') ;
end;

method MainWindowController.windowDidLoad;
begin
  inherited windowDidLoad();
  // Implement this method to handle any initialization after your window controller's
  // window has been loaded from its nib file.
end;

method MainWindowController.pressBackButton(sender: id);
begin
  var s := edValue.stringValue;
  if s.length > 0 then begin
    s := s.substringToIndex(s.length - 1);
    edValue.stringValue := s;
  end;
end;

method MainWindowController.pressExitButton(sender: id);
begin
  close();
end;

method MainWindowController.pressEvaluateButton(sender: id);
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

method MainWindowController.pressCharButton(sender: id);
begin
  edValue.stringValue := (NSButton(sender)).title;
end;

end.