namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
  mouseDownstate = enum(none, cmd, shift, alt, ctrl);
[IBObject]
Metal_View = public class(MTKView)
private

  trackingArea: NSTrackingArea;
  fMousePos : NSPoint;
   {$HIDE H6}
  fMouseDownPos : NSPoint;
  mState : mouseDownstate;
  {$SHOW H6}
 {$HIDE H7}
  fMousein : Boolean;
  fFilllayer : Boolean := true;
  {$SHOW H7}
  method setTrackingAreas;

private
  fMouseDelegate : nullable MetalMouseDelegate;
public
 method awakeFromNib; override;
  method setFrameSize(newSize: NSSize); override;

  method mouseEntered(&event: not nullable NSEvent); override;
  method mouseExited(&event: not nullable NSEvent); override;
  method mouseDown(&event: not nullable NSEvent); override;
  method mouseUp(&event: not nullable NSEvent); override;
  method mouseMoved(&event: not nullable NSEvent); override;
  method mouseDragged(&event: not nullable NSEvent); override;

  property MouseDelegate : nullable MetalMouseDelegate read fMouseDelegate write fMouseDelegate;

end;

implementation

method Metal_View.awakeFromNib;
begin
  inherited;
  device := MTLCreateSystemDefaultDevice();
  if device = nil then
  NSLog("Could not create a default MetalDevice!!");
  setTrackingAreas;
end;

method Metal_View.mouseEntered(&event: not nullable NSEvent);
begin
  fMousein := true;
  NSLog("mouseEntered");
  if fMouseDelegate:DontShowCursor then
  begin
    NSCursor.hide;
    fMouseDelegate:showCrosshair := true;
  end;
end;

method Metal_View.mouseExited(&event: not nullable NSEvent);
begin
  fMousein := false;
  NSLog("mouseExited");
 // if fMouseDelegate:DontShowCursor then
  NSCursor.unhide;
  fMouseDelegate:showCrosshair := false;
end;

method Metal_View.mouseDown(&event: not nullable NSEvent);
begin
  NSLog("mouseDown");
end;

method Metal_View.mouseUp(&event: not nullable NSEvent);
begin
  NSLog("mouseUp");
end;

method Metal_View.mouseMoved(&event: not nullable NSEvent);
begin
  fMousePos :=convertPointToBacking(
  convertPoint(&event.locationInWindow) fromView(nil));
  fMouseDelegate:MouseMove(fMousePos.x, fMousePos.y);
 // NSLog("mouseMoved");
end;

method Metal_View.mouseDragged(&event: not nullable NSEvent);
begin
  fMousePos :=convertPointToBacking(
  convertPoint(&event.locationInWindow) fromView(nil));
  fMouseDelegate:MouseMove(fMousePos.x, fMousePos.y);
 // NSLog("mouseDragged");
end;



method Metal_View.setTrackingAreas;
begin
   // Remove existing tracking area if necessary.
  if trackingArea <> nil then
    removeTrackingArea(trackingArea);

  // Create new tracking area.
  var  options: NSTrackingAreaOptions := [
  NSTrackingAreaOptions.MouseEnteredAndExited,
  NSTrackingAreaOptions.MouseMoved,
  NSTrackingAreaOptions.ActiveInActiveApp,
  NSTrackingAreaOptions.NSTrackingInVisibleRect
  ,NSTrackingAreaOptions.EnabledDuringMouseDrag

       // NSTrackingAreaOptions.ActiveInActiveApp,
  ];
  trackingArea := new NSTrackingArea() withRect(frame) options(options) owner(self) userInfo(nil);
  addTrackingArea(trackingArea);
end;

method Metal_View.setFrameSize(newSize: NSSize);
begin
  inherited setFrameSize(newSize);
  setTrackingAreas;
end;



end.