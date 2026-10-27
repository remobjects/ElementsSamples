namespace com.example.android.lunarlander;

{*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

interface

uses
  android.content,
  android.content.res,
  android.graphics,
  android.graphics.drawable,
  android.os,
  android.util,
  android.view,
  android.widget;

/// <summary>
/// View that draws, takes keystrokes, etc. for a simple LunarLander game.
/// 
/// Has a mode which RUNNING, PAUSED, etc. Has a x, y, dx, dy, ... capturing the
/// current ship physics. All x/y etc. are measured with (0,0) at the lower left.
/// updatePhysics() advances the physics based on realtime. draw() renders the
/// ship, and does an invalidate() to prompt another draw() as soon as possible
/// by the system.
/// </summary>
type
  Direction = (Top, Right, Bottom, Left);

  LunarView = public class(SurfaceView, SurfaceHolder.Callback)
  private
    // Pointer to the text view to display "Paused.." etc.
    var mStatusText: TextView;
    // The thread that actually draws the animation
    var thread: LunarThread;
    var mContext: Context;
    var mHandler: Handler;
    // If this is set, then we have a thread active to resume
    var mGameIsRunning: Boolean := false;
    method whichTriangularQuadrant(x, y: Single): Direction;
  public
    constructor(ctx: Context; attrs: AttributeSet);
    method getThread: LunarThread;
    method onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean; override;
    method onKeyUp(keyCode: Integer; msg: KeyEvent): Boolean; override;
    method onTouchEvent(evt: MotionEvent): Boolean; override;
    method onWindowFocusChanged(hasWindowFocus: Boolean); override;
    method setTextView(textView: TextView);
    method surfaceChanged(holder: SurfaceHolder; format, width, height: Integer);
    method surfaceCreated(holder: SurfaceHolder);
    method surfaceDestroyed(holder: SurfaceHolder);
  end;

implementation

constructor LunarView(ctx: Context; attrs: AttributeSet);
begin
  inherited;
  Log.w(&Class.Name, 'LunarView constructor');
  mContext := ctx;
  //  register our interest in hearing about changes to our surface
  var surfHolder := Holder;
  surfHolder.addCallback(self);
  mHandler := new Handler(new interface Handler.Callback(
    handleMessage := 
    method(m: Message);
    begin
      mStatusText.Visibility := m.Data.Int['viz'];
      mStatusText.Text := m.Data.String['text']
    end));
  //  create thread only; it's started in surfaceCreated()
    Log.w(&Class.Name, 'Creating gameplay thread');
  thread := new LunarThread(surfHolder, mContext, mHandler);
  Focusable := true;
end;

/// <summary>
/// Fetches the animation thread corresponding to this LunarView.
/// </summary>
/// <returns>the animation thread</returns>
method LunarView.getThread: LunarThread;
begin
  exit thread
end;

/// <summary>
/// Standard override to get key-press events.
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method LunarView.onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  exit thread.doKeyDown(keyCode, msg)
end;

/// <summary>
/// Standard override for key-up. We actually care about these, so we can
/// turn off the engine or stop rotating.
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method LunarView.onKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  exit thread.doKeyUp(keyCode, msg)
end;

method LunarView.onTouchEvent(evt: MotionEvent): Boolean;
begin
  //Get coords by index to cater for multiple pointers (multi-touch)
  var pointerIndex := evt.ActionIndex;
  var x := evt.X[pointerIndex];
  var y := evt.Y[pointerIndex];
  //var pointerId := evt.PointerId[pointerIndex];
  var action := evt.ActionMasked;
  //var pointCnt := motionEvent.PointerCount;
  if action in [MotionEvent.ACTION_DOWN, MotionEvent.ACTION_POINTER_DOWN,
                MotionEvent.ACTION_UP,   MotionEvent.ACTION_POINTER_UP] then
  begin
    var key: Integer := case whichTriangularQuadrant(x, y) of
      Direction.Left: KeyEvent.KEYCODE_Q;  //same as DPad left
      Direction.Right: KeyEvent.KEYCODE_W; //same as DPad right
      Direction.Top: KeyEvent.KEYCODE_DPAD_UP;   //start game or pause
      else {Direction.Bottom:} KeyEvent.KEYCODE_SPACE; //fire thrusters - same as DPad centre
    end;
    if action in [MotionEvent.ACTION_DOWN, MotionEvent.ACTION_POINTER_DOWN] then
      onKeyDown(key, new KeyEvent(KeyEvent.ACTION_DOWN, key))
    else //MotionEvent.ACTION_UP, MotionEvent.ACTION_POINTER_UP
      onKeyUp(key, new KeyEvent(KeyEvent.ACTION_UP, key))
  end;
  exit true
end;

/// <summary>
/// Standard window-focus override. Notice focus lost so we can pause on
/// focus lost. e.g. user switches to take a call.
/// </summary>
/// <param name="hasWindowFocus"></param>
method LunarView.onWindowFocusChanged(hasWindowFocus: Boolean);
begin
  if not hasWindowFocus then
    thread.pause
end;

/// <summary>
/// Installs a pointer to the text view used for messages.
/// </summary>
/// <param name="textView"></param>
method LunarView.setTextView(textView: TextView);
begin
  mStatusText := textView
end;

/// <summary>
/// Callback invoked when the Surface has been created and is ready to be
/// used
/// </summary>
/// <param name="holder"></param>
method LunarView.surfaceCreated(holder: SurfaceHolder);
begin
  Log.w(&Class.Name, 'surfaceCreated');

  // start the thread here
  if not mGameIsRunning then
  begin
    Log.w(&Class.Name, 'starting thread');
    thread.start;
    mGameIsRunning := true
  end
  else
  begin
    Log.w(&Class.Name, 'unpausing thread');
    thread.unpause;
  end
end;

/// <summary>
/// Callback invoked when the surface dimensions change.
/// </summary>
/// <param name="holder"></param>
/// <param name="format"></param>
/// <param name="width"></param>
/// <param name="height"></param>
method LunarView.surfaceChanged(holder: SurfaceHolder; format, width, height: Integer);
begin
  thread.setSurfaceSize(width, height)
end;

/// <summary>
/// Callback invoked when the Surface has been destroyed and must no longer
/// be touched. WARNING: after this method returns, the Surface/Canvas must
/// never be touched again!
/// </summary>
/// <param name="holder"></param>
method LunarView.surfaceDestroyed(holder: SurfaceHolder);
begin
  Log.w(&Class.Name, 'surfaceDestroyed');
end;

method LunarView.whichTriangularQuadrant(x, y: Single): Direction;
begin
  var slope: Single := Single(Width) / Height;
  var leftOrBottom: Boolean := x < y * slope;
  var leftOrTop: Boolean := x < (Height - y) * slope;
  if leftOrTop and leftOrBottom then
    exit Direction.Left;
  if leftOrTop and not leftOrBottom then
    exit Direction.Top;
  if not leftOrTop and leftOrBottom then
    exit Direction.Bottom;
  //Only option now
  //if not leftOrTop and not leftOrBottom then
    exit Direction.Right;
end;

end.