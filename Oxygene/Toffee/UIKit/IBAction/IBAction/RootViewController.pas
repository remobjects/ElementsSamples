namespace OxygeneiOSIBActionDemo;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);
      title := 'iOS IBAction Demo';
    end;

    [IBOutlet] label : UILabel;
    [IBAction] method buttonTapped(sender: id);
    begin
      label.text := "Button Was Tapped";
    end;

  end;

end.
