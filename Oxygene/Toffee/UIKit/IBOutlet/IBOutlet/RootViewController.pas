namespace OxygeneiOSIBOutletDemo;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);
      title := 'Oxygene iOS IBOutlet Demo';
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;
      self.label.textColor := UIColor.redColor;
      self.label.text := "IBOutlet Demo Text";
    end;

    [IBOutlet] label: UILabel;
  end;

end.
