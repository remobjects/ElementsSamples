namespace FirstOxygeneiOSApp;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);
      title := 'My First App';
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;

      view.backgroundColor := UIColor.systemBackgroundColor;
      var lLabel := new UILabel;
      lLabel.translatesAutoresizingMaskIntoConstraints := false;
      lLabel.text := "My First iOS App.";
      lLabel.textColor := UIColor.labelColor;
      lLabel.font := UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1);
      lLabel.adjustsFontForContentSizeCategory := true;
      lLabel.numberOfLines := 0;
      lLabel.textAlignment := NSTextAlignment.Center;
      view.addSubview(lLabel);

      // Safe-area constraints adapt to rotation, resizing and larger text.
      var lGuide := view.safeAreaLayoutGuide;
      lLabel.leadingAnchor.constraintEqualToAnchor(lGuide.leadingAnchor) constant(20).active := true;
      lLabel.trailingAnchor.constraintEqualToAnchor(lGuide.trailingAnchor) constant(-20).active := true;
      lLabel.centerYAnchor.constraintEqualToAnchor(lGuide.centerYAnchor).active := true;
    end;

  end;

end.
