namespace CircularSlider;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  private
  public
    method init: id; override;

    property preferredStatusBarStyle: UIStatusBarStyle read UIStatusBarStyle.UIStatusBarStyleLightContent; override;

    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;

    [IBAction] method newValue(aSlider: TBCircularSlider);
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin

    // Custom initialization

  end;
  result := self;
end;

method RootViewController.viewDidLoad;
begin
  inherited;

  view.backgroundColor := UIColor.colorWithRed(0.1) green(0.1) blue(0.1) alpha(1);

  //Create the Circular Slider
  var slider := new TBCircularSlider withFrame(CGRectMake(0, 60, TBCircularSlider.TB_SLIDER_SIZE, TBCircularSlider.TB_SLIDER_SIZE));

  //Define Target-Action behaviour
  slider.addTarget(self) action(selector(newValue:)) forControlEvents(UIControlEvents.UIControlEventValueChanged);
  view.addSubview(slider);
end;

method RootViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;

  // Dispose of any resources that can be recreated.
end;

method RootViewController.newValue(aSlider: TBCircularSlider);
begin
  // handle the slider event
end;

end.
