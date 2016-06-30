namespace OxygeneiOSIBActionDemo;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  private
  public
    method init: id; override;
    [IBOutlet] label : UILabel;
    [IBAction] method buttonTapped(sender: id);
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'iOS IBAction Demo';
  end;
  result := self;
end;

method RootViewController.buttonTapped(sender: id);
begin
  label.text := "Button Was Tapped";
end;

end.
