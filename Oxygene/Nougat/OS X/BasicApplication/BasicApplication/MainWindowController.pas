namespace BasicApplication;

interface

uses
  AppKit,
  Foundation;

type
  [IBObject]
  MainWindowController = public class(NSWindowController)
  private
  protected
  public
    [IBOutlet] textField : NSTextField;
    [IBOutlet] displayLabel: NSTextField;
    method init: id; override;
    [IBAction] method submitButtonPressed(sender : id);
  end;

implementation

method MainWindowController.init: id;
begin
  self := inherited initWithWindowNibName('MainWindowController');
  result := self;
end;


method MainWindowController.submitButtonPressed(sender: id);
begin
  self.displayLabel.stringValue := self.textField.stringValue;
end;

end.
