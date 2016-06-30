namespace FirstOxygeneiOSApp;

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
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'My First App';
  end;
  result := self;
end;

method RootViewController.viewDidLoad;
begin
  inherited viewDidLoad;

  //Create a Frame To Work With
  var frame := CGRectMake(0, 0, 320, 200);

  //Create a new label based on the frame.
  var label := new UILabel withFrame(frame);

  //Set some properties of the label
  label.textColor := UIColor.redColor;
  label.font :=  UIFont.fontWithName("American Typewriter") size(30);
  label.textAlignment := NSTextAlignment.NSTextAlignmentCenter;
  label.text  := "My First iOS App.";

  //Add the label to the view
  self.view.addSubview(label);
  
end;


end.
