namespace CircularSlider;

interface

// Based on "How to build a custom control in iOS
// by Yari D'areglia (@Yariok), February 2012, 2013.
// http://www.thinkandbuild.it/how-to-build-a-custom-control-in-ios/

// converted to Oxygene in maybe 30 minutes of work (without Oxidizer)

uses
  UIKit;

type
  [IBObject]
  TBCircularSlider = public class(UIControl)
  private
    fRadius: CGFloat;
    fTextField: UITextField;

    method ToRad(deg: CGFloat): CGFloat; inline;
    method ToDeg(rad: CGFloat): CGFloat; inline;
    method SQR(x: CGFloat): CGFloat; inline;
    method angleFromNorth(p1, p2: CGPoint; aFlipped: Boolean): CGFloat; inline;

    method drawHandle(aContext: CGContextRef);
    method moveHandle(aLastPoint: CGPoint);
    method pointFromAngle(aAngle: Int32): CGPoint;

  protected
  public
    method initWithFrame(aFrame: CGRect): id; override;

    method beginTrackingWithTouch(touch: not nullable UITouch) withEvent(&event: UIEvent): Boolean; override;
    method continueTrackingWithTouch(touch: not nullable UITouch) withEvent(&event: UIEvent): Boolean; override;
    method endTrackingWithTouch(touch: UITouch) withEvent(&event: UIEvent); override;
    method drawRect(rect: CGRect); override;

    property angle: Int32;

    const 
      TB_SLIDER_SIZE = 320;                          //The width and the heigth of the slider
      TB_BACKGROUND_WIDTH = 60;                      //The width of the dark background
      TB_LINE_WIDTH = 40;                            //The width of the active area (the gradient) and the width of the handle
      TB_FONTSIZE = 65;                              //The size of the textfield font
      TB_FONTFAMILY = 'Futura-CondensedExtraBold';   //The font family of the textfield font
      TB_SAFEAREA_PADDING = 60.0;
  end;

implementation

method TBCircularSlider.initWithFrame(aFrame: CGRect): id;
begin
  self := inherited initWithFrame(aFrame);
  if assigned(self) then begin

    opaque := NO;
        
    //Define the circle radius taking into account the safe area
    fRadius := frame.size.width/2 - TB_SAFEAREA_PADDING;
        
    //Initialize the Angle at 0
    angle := 360;
       
        
    //Define the Font
    var lFont := UIFont.fontWithName(TB_FONTFAMILY) size(TB_FONTSIZE);
    //Calculate font size needed to display 3 numbers
    var lStr := '000';
    var lFontSize := lStr.sizeWithFont(lFont);
        
    //61103: Toffee: Internal error: Unknown type "x"
    //Using a TextField area we can easily modify the control to get user input from this field
    fTextField := new UITextField withFrame(CGRectMake((frame.size.width  - lFontSize.width) /2,
                                                        (frame.size.height - lFontSize.height) /2,
                                                        lFontSize.width,
                                                        lFontSize.height));
    fTextField.backgroundColor := UIColor.clearColor;
    fTextField.textColor := UIColor.colorWithWhite(1) alpha(0.8);
    fTextField.textAlignment := NSTextAlignment.NSTextAlignmentCenter;
    fTextField.font := lFont;
    fTextField.text := NSString.stringWithFormat('%d',angle);
    fTextField.enabled := NO;
        
    addSubview(fTextField);

  end;
  result := self;
end;

method TBCircularSlider.beginTrackingWithTouch(touch: not nullable UITouch) withEvent(&event: UIEvent): Boolean;
begin
  inherited;

  //We need to track continuously
  result := true;
end;

method TBCircularSlider.continueTrackingWithTouch(touch: not nullable UITouch) withEvent(&event: UIEvent): Boolean;
begin
  inherited;
    
  //Get touch location
  var lastPoint := touch.locationInView(self);

  //Use the location to design the Handle
  moveHandle(lastPoint);
    
  //Control value has changed, let's notify that   
  sendActionsForControlEvents(UIControlEvents.UIControlEventValueChanged);
    
  result := true;
end;

method TBCircularSlider.endTrackingWithTouch(touch: UITouch) withEvent(&event: UIEvent);
begin
  inherited;
end;

method TBCircularSlider.drawRect(rect: CGRect);
begin
  inherited;
    
  var lContext := UIGraphicsGetCurrentContext();
    
  //* Draw the Background *//
    
  //Create the path
  CGContextAddArc(lContext, frame.size.width/2, frame.size.height/2, fRadius, 0, M_PI *2, 0);
    
  //Set the stroke color to black
  UIColor.blackColor.setStroke();
    
  //Define line width and cap
  CGContextSetLineWidth(lContext, TB_BACKGROUND_WIDTH);
  CGContextSetLineCap(lContext, CGLineCap.kCGLineCapButt);
    
  //draw it!
  CGContextDrawPath(lContext, CGPathDrawingMode.kCGPathStroke);
    
   
  //** Draw the circle (using a clipped gradient) **//
    
    
  //** Create THE MASK Image **//
  UIGraphicsBeginImageContext(CGSizeMake(TB_SLIDER_SIZE,TB_SLIDER_SIZE));
  var imagelContext := UIGraphicsGetCurrentContext();
    
  CGContextAddArc(imagelContext, frame.size.width/2  , frame.size.height/2, fRadius, 0, ToRad(angle), 0);
  UIColor.redColor.set();
    
  //Use shadow to create the Blur effect
  CGContextSetShadowWithColor(imagelContext, CGSizeMake(0, 0), angle/20, UIColor.blackColor.CGColor);
    
  //define the path
  CGContextSetLineWidth(imagelContext, TB_LINE_WIDTH);
  CGContextDrawPath(imagelContext, CGPathDrawingMode.kCGPathStroke);
    
  //save the context content into the image mask
  var mask := CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
  UIGraphicsEndImageContext();
    

  //** Clip Context to the mask **//
  CGContextSaveGState(lContext);
    
  CGContextClipToMask(lContext, bounds, mask);
  CGImageRelease(mask);

    
  //** THE GRADIENT **//
    
  //list of components
  var components: array[0..7] of CGFloat := [0.0, 0.0, 1.0, 1.0,     // Start color - Blue
                                             1.0, 0.0, 1.0, 1.0];   // End color - Violet
    
  var baseSpace := CGColorSpaceCreateDeviceRGB();
  var gradient := CGGradientCreateWithColorComponents(baseSpace, components, nil, 2);
  CGColorSpaceRelease(baseSpace);
  baseSpace := nil;
    
  //Gradient direction
  var startPoint := CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  var endPoint := CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
  //Draw the gradient
  CGContextDrawLinearGradient(lContext, gradient, startPoint, endPoint, 0);
  CGGradientRelease(gradient);
  gradient := nil;
    
  CGContextRestoreGState(lContext);
    
    
  //** Add some light reflection effects on the background circle**//
    
  CGContextSetLineWidth(lContext, 1);
  CGContextSetLineCap(lContext, CGLineCap.kCGLineCapRound);
    
  //Draw the outside light
  CGContextBeginPath(lContext);
  CGContextAddArc(lContext, frame.size.width/2  , frame.size.height/2, fRadius+TB_BACKGROUND_WIDTH/2, 0, ToRad(-angle), 1);
  UIColor.colorWithWhite(1.0) alpha(0.05).set();
  CGContextDrawPath(lContext, CGPathDrawingMode.kCGPathStroke);
    
  //draw the inner light
  CGContextBeginPath(lContext);
  CGContextAddArc(lContext, frame.size.width/2  , frame.size.height/2, fRadius-TB_BACKGROUND_WIDTH/2, 0, ToRad(-angle), 1);
  UIColor.colorWithWhite(1.0) alpha(0.05).set();
  CGContextDrawPath(lContext, CGPathDrawingMode.kCGPathStroke);
    
    
  //** Draw the handle **//
  drawHandle(lContext);
end;

method TBCircularSlider.drawHandle(aContext: CGContextRef);
begin
  CGContextSaveGState(aContext);
    
  //I Love shadows
  CGContextSetShadowWithColor(aContext, CGSizeMake(0, 0), 3, UIColor.blackColor.CGColor);
  //61106: Toffee: Toffee: Internal error: Attempted to read or write protected memory. in CircularSlider project
    
  //Get the handle position
  var handleCenter := pointFromAngle(angle);
    
  //Draw It!
  UIColor.colorWithWhite(1.0) alpha(0.7).set();
  CGContextFillEllipseInRect(aContext, CGRectMake(handleCenter.x, handleCenter.y, TB_LINE_WIDTH, TB_LINE_WIDTH));
    
  CGContextRestoreGState(aContext);
end;

method TBCircularSlider.moveHandle(aLastPoint: CGPoint);
begin
  //Get the center
  var centerPoint := CGPointMake(frame.size.width/2, frame.size.height/2);
    
  //Calculate the direction from a center point and a arbitrary position.
  var currentAngle := angleFromNorth(centerPoint, aLastPoint, NO);
  //Message  1  (H11) Local variable "angleFromNorth.8.self" is assigned to but never read  Z:\Code\Toffee Tests\CircularSlider\TBCircularSlider.pas  233  23  CircularSlider
  var angleInt := floor(currentAngle);
    
  //Store the new angle
  angle := 360 - Int32(angleInt);
  //Update the textfield 
  fTextField.text := NSString.stringWithFormat('%d', angle);
    
  //Redraw
  setNeedsDisplay();
end;

method TBCircularSlider.pointFromAngle(aAngle: Int32): CGPoint;
begin
  //Circle center
  var centerPoint := CGPointMake(frame.size.width/2 - TB_LINE_WIDTH/2, frame.size.height/2 - TB_LINE_WIDTH/2);
    
  //The point position on the circumference
  result.y := round(centerPoint.y + fRadius * sin(ToRad(-aAngle))) ;
  result.x := round(centerPoint.x + fRadius * cos(ToRad(-aAngle)));
end;

method TBCircularSlider.angleFromNorth(p1: CGPoint; p2: CGPoint; aFlipped: Boolean): CGFloat;
begin
  var v := CGPointMake(p2.x-p1.x,p2.y-p1.y);
  var vmag := sqrt(SQR(v.x) + SQR(v.y));
  v.x := v.x / vmag;
  v.y := v.y / vmag;
  var radians := atan2(v.y,v.x);
  result := ToDeg(radians);
  if result < 0 then result := result + 360.0;
end;

method TBCircularSlider.ToRad(deg: CGFloat): CGFloat; 
begin
  result := ( (M_PI * (deg)) / 180.0 )
end;

method TBCircularSlider.ToDeg(rad: CGFloat): CGFloat;
begin
  result :=  ( (180.0 * (rad)) / M_PI )
end;

method TBCircularSlider.SQR(x: CGFloat): CGFloat;
begin
  result := ( (x) * (x) );
end;


end.
