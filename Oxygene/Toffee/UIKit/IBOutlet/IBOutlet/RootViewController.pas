namespace OxygeneiOSIBOutletDemo;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  private
  public
    method init: id; override;
    method viewDidLoad; override;
    [IBOutlet] label: UILabel;
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'Oxygene iOS IBOutlet Demo';
  end;
  result := self;
end;

method RootViewController.viewDidLoad;
begin
  inherited viewDidLoad;
  self.label.textColor := UIColor.redColor;
  self.label.text := "IBOutlet Demo Text";
end;



end.
