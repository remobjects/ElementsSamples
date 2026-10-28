namespace CircularSlider;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);

      // Custom initialization
    end;

    property preferredStatusBarStyle: UIStatusBarStyle read UIStatusBarStyle.UIStatusBarStyleLightContent; override;

    method viewDidLoad; override;
    begin
      inherited;

      view.backgroundColor := UIColor.colorWithRed(0.1) green(0.1) blue(0.1) alpha(1);

      //Create the Circular Slider
      var slider := new TBCircularSlider withFrame(CGRectMake(0, 60, TBCircularSlider.TB_SLIDER_SIZE, TBCircularSlider.TB_SLIDER_SIZE));

      //Define Target-Action behaviour
      slider.addTarget(self) action(selector(newValue:)) forControlEvents(UIControlEvents.UIControlEventValueChanged);
      view.addSubview(slider);
    end;

    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning;

      // Dispose of any resources that can be recreated.
    end;

    [IBAction] method newValue(aSlider: TBCircularSlider);
    begin
      // handle the slider event
    end;

  end;

end.
