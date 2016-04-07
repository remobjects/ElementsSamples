namespace NSMenu;

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

    [IBOutlet] messageLabel : NSTextField;
    method init: id; override;
    method sayHello;
    method sayGoodBye;
  end;

implementation

method MainWindowController.init: id;
begin
  self := inherited initWithWindowNibName('MainWindowController');
  result := self;
end;


method MainWindowController.sayHello;
begin
   self.messageLabel.stringValue := "Hello"
end;

method MainWindowController.sayGoodBye;
begin
  self.messageLabel.stringValue := "GoodBye"
end;



end.
