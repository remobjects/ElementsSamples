namespace com.example.android.snake;

// Extra functionality added by Brian Long (htt://blong.com)
// Supports screen swipe gestures to enhance the original game
// that required a D-Pad

interface

uses 
  android.util,
  android.view;

type
  SnakeGestureListener = public class(GestureDetector.SimpleOnGestureListener)
    // swipe gesture constants
    const SWIPE_MIN_DISTANCE = 120;
    const SWIPE_THRESHOLD_VELOCITY = 200;
    var mView: View;
  public
    constructor(v: View);
    method onDown(&event: MotionEvent): Boolean; override;
    method onFling(e1: MotionEvent; e2: MotionEvent; velocityX: Single; velocityY: Single): Boolean; override;
  end;

implementation

constructor SnakeGestureListener(v: View);
begin
  inherited constructor;
  mView := v
end;

method SnakeGestureListener.onFling(e1: MotionEvent; e2: MotionEvent; velocityX: Single; velocityY: Single): Boolean;
begin
  try
    if (e1.X - e2.X > SWIPE_MIN_DISTANCE) and (Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) then
      mView.onKeyDown(KeyEvent.KEYCODE_DPAD_LEFT,
                      new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DPAD_LEFT))
    else
    if (e2.X - e1.X > SWIPE_MIN_DISTANCE) and (Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) then
      mView.onKeyDown(KeyEvent.KEYCODE_DPAD_RIGHT,
                      new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DPAD_RIGHT))
    else
    if (e1.Y - e2.Y > SWIPE_MIN_DISTANCE) and (Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) then
      mView.onKeyDown(KeyEvent.KEYCODE_DPAD_UP,
                      new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DPAD_UP))
    else
    if (e2.Y - e1.Y > SWIPE_MIN_DISTANCE) and (Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) then
      mView.onKeyDown(KeyEvent.KEYCODE_DPAD_DOWN,
                      new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DPAD_DOWN))
  except
    on e: Exception do
      e.printStackTrace
  end;
  exit true
end;

method SnakeGestureListener.onDown(&event: MotionEvent): Boolean;
begin
  exit true;
end;

end.