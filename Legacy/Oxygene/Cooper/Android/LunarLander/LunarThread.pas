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

//BUG: The original Android SDK demo has this bug:
//If the game is over and in a win or lose state, rotating the phone or switching away from 
//the game pauses, so when we come back we can unpause and then immediately win or lose again.
//To work around that the implementation of saveState and restoreState should probably
//take into account a win or lose state

//BUG: The original Android SDK demo has this bug:
//Switching away from the app and then back crashes the app with an IllegalThreadStateException

interface

uses 
  android.content,
  android.content.res,
  android.graphics, 
  android.graphics.drawable, 
  android.os,
  android.util,
  android.view;

type
  LunarThread = public class(Thread)
  private
    const KEY_DIFFICULTY = 'mDifficulty';
    const KEY_DX = 'mDX';
    const KEY_DY = 'mDY';
    const KEY_FUEL = 'mFuel';
    const KEY_GOAL_ANGLE = 'mGoalAngle';
    const KEY_GOAL_SPEED = 'mGoalSpeed';
    const KEY_GOAL_WIDTH = 'mGoalWidth';
    const KEY_GOAL_X = 'mGoalX';
    const KEY_HEADING = 'mHeading';
    const KEY_LANDER_HEIGHT = 'mLanderHeight';
    const KEY_LANDER_WIDTH = 'mLanderWidth';
    const KEY_WINS = 'mWinsInARow';
    const KEY_X = 'mX';
    const KEY_Y = 'mY';
    const KEY_MODE = 'mMode';
    // Member (state) fields

    // Handle to the application context, used to e.g. fetch Drawables.
    var mContext: Context;
    // The drawable to use as the background of the animation canvas
    var mBackgroundImage: Bitmap;
    // Current height of the surface/canvas.
    // see setSurfaceSize
    var mCanvasHeight: Integer := 1;
    // Current width of the surface/canvas.
    // see setSurfaceSize
    var mCanvasWidth: Integer := 1;    // What to draw for the Lander when it has crashed
    var mCrashedImage: Drawable;    //
    // Current difficulty -- amount of fuel, allowed angle, etc. Default is
    // MEDIUM.
    var mDifficulty: Integer;
    // Velocity dx.
    var mDX: Double;
    // Velocity dy.
    var mDY: Double;
    // Is the engine burning?
    var mEngineFiring: Boolean;
    // What to draw for the Lander when the engine is firing
    var mFiringImage: Drawable;
    // Fuel remaining
    var mFuel: Double;
    // Allowed angle.
    var mGoalAngle: Integer;
    // Allowed speed.
    var mGoalSpeed: Integer;
    // Width of the landing pad.
    var mGoalWidth: Integer;
    // X of the landing pad.
    var mGoalX: Integer;
    // Message handler used by thread to interact with TextView
    var mHandler: Handler;
    // Lander heading in degrees, with 0 up, 90 right. Kept in the range
    // 0..360.
    var mHeading: Double;
    // Pixel height of lander image.
    var mLanderHeight: Integer;
    // What to draw for the Lander in its normal state
    var mLanderImage: Drawable;
    // Pixel width of lander image.
    var mLanderWidth: Integer;
    // Used to figure out elapsed time between frames
    var mLastTime: Int64;
    // Paint to draw the lines on screen.
    var mLinePaint: Paint;
    // "Bad" speed-too-high variant of the line color.
    var mLinePaintBad: Paint;
    // The state of the game. One of READY, RUNNING, PAUSE, LOSE, or WIN
    var mMode: Integer;
    // Currently rotating, -1 left, 0 none, 1 right.
    var mRotating: Integer;
    // Scratch rect object.
    var mScratchRect: RectF;
    // Handle to the surface manager object we interact with
    var mSurfaceHolder: SurfaceHolder;
    // Number of wins in a row.
    var mWinsInARow: Integer;
    // X of lander center.
    var mX: Double;
    // Y of lander center.
    var mY: Double;
    // To cater for thread pause/resume management
    var mPauseLock: Object := new Object;
    var mPaused: Boolean;
    method doDraw(aCanvas: Canvas);
    method updatePhysics;
  assembly
    method doKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
    method doKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
  public
    // Difficulty setting constants
    const DIFFICULTY_EASY = 0;
    const DIFFICULTY_HARD = 1;
    const DIFFICULTY_MEDIUM = 2;
    // Physics constants
    const PHYS_DOWN_ACCEL_SEC = 35;
    const PHYS_FIRE_ACCEL_SEC = 80;
    const PHYS_FUEL_INIT = 60;
    const PHYS_FUEL_MAX = 100;
    const PHYS_FUEL_SEC = 10;
    const PHYS_SLEW_SEC = 120; //  degrees/second rotate
    const PHYS_SPEED_HYPERSPACE = 180;
    const PHYS_SPEED_INIT = 30;
    const PHYS_SPEED_MAX = 120;
    // State-tracking constants
    const STATE_LOSE = 1;
    const STATE_PAUSE = 2;
    const STATE_READY = 3;
    const STATE_RUNNING = 4;
    const STATE_WIN = 5;
    // Goal condition constants
    const TARGET_ANGLE = 18; //  > this angle means crash
    const TARGET_BOTTOM_PADDING = 17; //  px below gear
    const TARGET_PAD_HEIGHT = 8; //  how high above ground
    const TARGET_SPEED = 28; //  > this speed means crash
    const TARGET_WIDTH = 1.6; //  width of target
    // UI constants (i.e. the speed & fuel bars)
    const UI_BAR = 100; //  width of the bar(s)
    const UI_BAR_HEIGHT = 10; //  height of the bar(s)
    constructor(aSurfaceHolder: SurfaceHolder; aContext: Context; aHandler: Handler);
    method doStart;
    method pause;
    method restoreState(savedState: Bundle); locked; 
    method run; override;
    method saveState(map: Bundle): Bundle;
    method setDifficulty(difficulty: Integer);
    method setFiring(firing: Boolean);
    method setState(mode: Integer);
    method setState(mode: Integer; aMessage: CharSequence);
    method setSurfaceSize(width: Integer; height: Integer);
    method unpause;
  end;

implementation

constructor LunarThread(aSurfaceHolder: SurfaceHolder; aContext: Context; aHandler: Handler);
begin
  //  get handles to some important objects
  mSurfaceHolder := aSurfaceHolder;
  mHandler := aHandler;
  mContext := aContext;
  var res: Resources := aContext.Resources;
  //  cache handles to our key sprites & other drawables
  mLanderImage  := res.Drawable[R.drawable.lander_plain];
  mFiringImage  := res.Drawable[R.drawable.lander_firing];
  mCrashedImage := res.Drawable[R.drawable.lander_crashed];
  //  load background image as a Bitmap instead of a Drawable b/c
  //  we don't need to transform it and it's faster to draw this way
  mBackgroundImage := BitmapFactory.decodeResource(res, R.drawable.earthrise);
  //  Use the regular lander image as the model size for all sprites
  mLanderWidth  := mLanderImage.IntrinsicWidth;
  mLanderHeight := mLanderImage.IntrinsicHeight;
  //  Initialize paints for speedometer
  mLinePaint := new Paint;
  mLinePaint.AntiAlias := true;
  mLinePaint.setARGB(255, 0, 255, 0);
  mLinePaintBad := new Paint;
  mLinePaintBad.AntiAlias := true;
  mLinePaintBad.setARGB(255, 120, 180, 0);
  mScratchRect := new RectF(0, 0, 0, 0);
  mWinsInARow := 0;
  mDifficulty := DIFFICULTY_MEDIUM;
  //  initial show-up of lander (not yet playing)
  mX := mLanderWidth;
  mY := mLanderHeight * 2;
  mFuel := PHYS_FUEL_INIT;
  mDX := 0;
  mDY := 0;
  mHeading := 0;
  mEngineFiring := true
end;

/// <summary>
/// Starts the game, setting parameters for the current difficulty.
/// </summary>
method LunarThread.doStart;
begin
  locking mSurfaceHolder do 
  begin
    //  First set the game for Medium difficulty
    mFuel := PHYS_FUEL_INIT;
    mEngineFiring := false;
    mGoalWidth := Integer(mLanderWidth * TARGET_WIDTH);
    mGoalSpeed := TARGET_SPEED;
    mGoalAngle := TARGET_ANGLE;
    var speedInit: Integer := PHYS_SPEED_INIT;
    //  Adjust difficulty params for EASY/HARD
    if mDifficulty = DIFFICULTY_EASY then
    begin
      mFuel := mFuel * 3 div 2;
      mGoalWidth := mGoalWidth * 4 div 3;
      mGoalSpeed := mGoalSpeed * 3 div 2;
      mGoalAngle := mGoalAngle * 4 div 3;
      speedInit := speedInit * 3 div 4
    end
    else
    if mDifficulty = DIFFICULTY_HARD then
    begin
      mFuel := mFuel * 7 div 8;
      mGoalWidth := mGoalWidth * 3 div 4;
      mGoalSpeed := mGoalSpeed * 7 div 8;
      speedInit := speedInit * 4 div 3
    end;
    //  pick a convenient initial location for the lander sprite
    mX := mCanvasWidth div 2;
    mY := mCanvasHeight - mLanderHeight div 2;
    //  start with a little random motion
    mDY := Math.random * -speedInit;
    mDX := (Math.random * 2 * speedInit) - speedInit;
    mHeading := 0;
    //  Figure initial spot for landing, not too near center
    while true do
    begin
      mGoalX := Integer(Math.random * (mCanvasWidth - mGoalWidth));
      if Math.abs(mGoalX - (mX - mLanderWidth div 2)) > mCanvasHeight div 6 then
        break
    end;
    mLastTime := System.currentTimeMillis + 100;
    setState(STATE_RUNNING)
  end
end;

/// <summary>
/// Pauses the physics update & animation.
/// </summary>
method LunarThread.pause;
begin
  Log.w(&Class.Name, 'LunarThread.pause');
  //Check for already-paused state
  if mPaused then
    exit;
  locking mSurfaceHolder do 
    if mMode = STATE_RUNNING then
      setState(STATE_PAUSE);
  //NOTE: new thread management code
  //To pause the thread we set a flag to true
  locking mPauseLock do 
    mPaused := true
end;

/// <summary>
/// Resumes from a pause.
/// </summary>
method LunarThread.unpause;
begin
  Log.w(&Class.Name, 'LunarThread.pause');
  //  Move the real time clock up to now
  locking mSurfaceHolder do 
    mLastTime := System.currentTimeMillis + 100;
  setState(STATE_RUNNING);

  //NOTE: new thread management code
  //To resume the thread we unset the flag and notify all waiting on the lock
  locking mPauseLock do 
  begin
    mPaused := false;
    mPauseLock.notifyAll
  end;
end;

/// <summary>
/// Dump game state to the provided Bundle. Typically called when the
/// Activity is being suspended.
/// </summary>
/// <param name="map"></param>
/// <returns>Bundle with this view's state</returns>
method LunarThread.saveState(map: Bundle): Bundle;
begin
  locking mSurfaceHolder do 
  begin
    if map <> nil then
    begin
      map.putInt(KEY_DIFFICULTY, mDifficulty);
      map.putDouble(KEY_X, mX);
      map.putDouble(KEY_Y, mY);
      map.putDouble(KEY_DX, mDX);
      map.putDouble(KEY_DY, mDY);
      map.putDouble(KEY_HEADING, mHeading);
      map.putInt(KEY_LANDER_WIDTH, mLanderWidth);
      map.putInt(KEY_LANDER_HEIGHT, mLanderHeight);
      map.putInt(KEY_GOAL_X, mGoalX);
      map.putInt(KEY_GOAL_SPEED, mGoalSpeed);
      map.putInt(KEY_GOAL_ANGLE, mGoalAngle);
      map.putInt(KEY_GOAL_WIDTH, mGoalWidth);
      map.putInt(KEY_WINS, mWinsInARow);
      map.putDouble(KEY_FUEL, mFuel);
      //NOTE: mMode wasn't stored in the original Java version. This meant
      //that is you died and rotated the device, you'd die again. The same
      //applied to winning
      map.putInt(KEY_MODE, mMode);
    end
  end;
  exit map
end;

/// <summary>
/// Restores game state from the indicated Bundle. Typically called when
/// the Activity is being restored after having been previously
/// destroyed.
/// </summary>
/// <param name="savedState">Bundle containing the game state</param>
method LunarThread.restoreState(savedState: Bundle);
begin
  locking mSurfaceHolder do 
  begin
    mRotating := 0;
    mEngineFiring := false;
    mDifficulty := savedState.Int[KEY_DIFFICULTY];
    mX := savedState.Double[KEY_X];
    mY := savedState.Double[KEY_Y];
    mDX := savedState.Double[KEY_DX];
    mDY := savedState.Double[KEY_DY];
    mHeading := savedState.Double[KEY_HEADING];
    mLanderWidth := savedState.Int[KEY_LANDER_WIDTH];
    mLanderHeight := savedState.Int[KEY_LANDER_HEIGHT];
    mGoalX := savedState.Int[KEY_GOAL_X];
    mGoalSpeed := savedState.Int[KEY_GOAL_SPEED];
    mGoalAngle := savedState.Int[KEY_GOAL_ANGLE];
    mGoalWidth := savedState.Int[KEY_GOAL_WIDTH];
    mWinsInARow := savedState.Int[KEY_WINS];
    mFuel := savedState.Double[KEY_FUEL];
    //NOTE: mMode wasn't stored in the original Java version. This meant
    //that is you died and rotated the device, you'd die again. The same
    //applied to winning
    mMode := savedState.Int[KEY_MODE];
    case mMode of
      STATE_LOSE, STATE_WIN: setState(STATE_READY);
      STATE_RUNNING: setState(STATE_PAUSE)
    end;
  end
end;

method LunarThread.run;
begin
  while true do
  begin
    var c: Canvas := nil;
    try
      c := mSurfaceHolder.lockCanvas(nil);
      locking mSurfaceHolder do 
      begin
        if mMode = STATE_RUNNING then
          updatePhysics;
        //NOTE: original SDK demo did not check for nil here
        //On some devices immediately after rotation c will be nil
        if c <> nil then
          doDraw(c);
      end;
    finally
      //  do this in a finally so that if an exception is thrown
      //  during the above, we don't leave the Surface in an
      //  inconsistent state
      if c <> nil then
        mSurfaceHolder.unlockCanvasAndPost(c)
    end;
    //NOTE: new thread management code
    //If the thread has been paused, then block until we are
    //notified we can proceed
    locking mPauseLock do 
      while mPaused do
        try
          mPauseLock.wait
        except
          on e: InterruptedException do 
            ;
        end
  end
end;

/// <summary>
/// Sets the current difficulty.
/// </summary>
method LunarThread.setDifficulty(difficulty: Integer);
begin
  locking mSurfaceHolder do 
    mDifficulty := difficulty
end;

/// <summary>
/// Sets if the engine is currently firing.
/// </summary>
method LunarThread.setFiring(firing: Boolean);
begin
  locking mSurfaceHolder do 
    mEngineFiring := firing
end;

/// <summary>
/// Sets the game mode. That is, whether we are running, paused, in the
/// failure state, in the victory state, etc.
/// see setState(int, CharSequence)
/// </summary>
/// <param name="mode">one of the STATE_* constants</param>
method LunarThread.setState(mode: Integer);
begin
  locking mSurfaceHolder do 
    setState(mode, nil)
end;

/// <summary>
/// Sets the game mode. That is, whether we are running, paused, in the
/// failure state, in the victory state, etc.
/// </summary>
/// <param name="mode">one of the STATE_* constants</param>
/// <param name="message">string to add to screen or null</param>
method LunarThread.setState(mode: Integer; aMessage: CharSequence);
begin
  // This method optionally can cause a text aMessage to be displayed
  // to the user when the mode changes. Since the View that actually
  // renders that text is part of the main View hierarchy and not
  // owned by this thread, we can't touch the state of that View.
  // Instead we use a Message + Handler to relay commands to the main
  // thread, which updates the user-text View.
  locking mSurfaceHolder do 
  begin
    mMode := mode;
    if mMode = STATE_RUNNING then
    begin
      var msg: Message := mHandler.obtainMessage;
      var b: Bundle := new Bundle;
      b.putString('text', '');
      b.putInt('viz', View.INVISIBLE);
      msg.Data := b;
      mHandler.sendMessage(msg)
    end
    else
    begin
      mRotating := 0;
      mEngineFiring := false;
      var res: Resources := mContext.Resources;
      var str: CharSequence := case mMode of
        STATE_READY: res.Text[R.string.mode_ready];
        STATE_PAUSE: res.Text[R.string.mode_pause];
        STATE_LOSE: res.Text[R.string.mode_lose];
        else {STATE_WIN} res.String[R.string.mode_win_prefix] + mWinsInARow + ' ' + res.String[R.string.mode_win_suffix]
      end;
      if aMessage <> nil then
        str := aMessage.toString + #10 + str;
      if mMode = STATE_LOSE then
        mWinsInARow := 0;
      var msg: Message := mHandler.obtainMessage;
      var b: Bundle := new Bundle;
      b.putString('text', str.toString);
      b.putInt('viz', View.VISIBLE);
      msg.Data := b;
      mHandler.sendMessage(msg)
    end
  end
end;

/// <summary>
/// Callback invoked when the surface dimensions change.
/// </summary>
method LunarThread.setSurfaceSize(width: Integer; height: Integer);
begin
  //  synchronized to make sure these all change atomically
  locking mSurfaceHolder do 
  begin
    mCanvasWidth := width;
    mCanvasHeight := height;
    //  don't forget to resize the background image
    mBackgroundImage := Bitmap.createScaledBitmap(mBackgroundImage, width, height, true)
  end
end;

/// <summary>
/// Handles a key-down event.
/// </summary>
/// <param name="keyCode">the key that was pressed</param>
/// <param name="msg">the original event object</param>
/// <returns>true</returns>
method LunarThread.doKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  locking mSurfaceHolder do 
  begin
    var okStart: Boolean := false;
    if keyCode in [KeyEvent.KEYCODE_DPAD_UP, KeyEvent.KEYCODE_DPAD_DOWN, KeyEvent.KEYCODE_S] then
      okStart := true;
    if okStart and (mMode in [STATE_READY, STATE_LOSE, STATE_WIN]) then
    begin
      //  ready-to-start -> start
      doStart;
      exit true
    end
    else
    if (mMode = STATE_PAUSE) and okStart then
    begin
      //  paused -> running
      unpause;
      exit true
    end
    else
    if mMode = STATE_RUNNING then
      case keyCode of
        //  center/space -> fire
        KeyEvent.KEYCODE_DPAD_CENTER, KeyEvent.KEYCODE_SPACE:
        begin
          Log.i(&Class.Name, 'firing');
          setFiring(true);
          exit true
        end;
        // left/q -> left      
        KeyEvent.KEYCODE_DPAD_LEFT, KeyEvent.KEYCODE_Q:
        begin
            mRotating := -1;
          exit true
        end;
        // right/w -> right
        KeyEvent.KEYCODE_DPAD_RIGHT, KeyEvent.KEYCODE_W:
        begin
          mRotating := 1;
          exit true
        end;
        // up -> pause
        KeyEvent.KEYCODE_DPAD_UP:
        begin
          pause;
          exit true
        end;
      end;
    exit false
  end
end;

/// <summary>
/// Handles a key-up event.
/// </summary>
/// <param name="keyCode">the key that was pressed</param>
/// <param name="msg">the original event object</param>
/// <returns>true if the key was handled and consumed, or else false</returns>
method LunarThread.doKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  var handled: Boolean := false;
  locking mSurfaceHolder do 
  begin
    if mMode = STATE_RUNNING then
      case keyCode of
        KeyEvent.KEYCODE_DPAD_CENTER, KeyEvent.KEYCODE_SPACE:
        begin
          Log.i(&Class.Name, 'not firing');
          setFiring(false);
          handled := true
        end;
        KeyEvent.KEYCODE_DPAD_LEFT, KeyEvent.KEYCODE_Q, KeyEvent.KEYCODE_DPAD_RIGHT, KeyEvent.KEYCODE_W:
        begin
          mRotating := 0;
          handled := true
        end;
      end;
  end;
  exit handled
end;

/// <summary>
/// Draws the ship, fuel/speed bars, and background to the provided
/// Canvas.
/// </summary>
method LunarThread.doDraw(aCanvas: Canvas);
begin
  //  Draw the background image. Operations on the Canvas accumulate
  //  so this is like clearing the screen.
  aCanvas.drawBitmap(mBackgroundImage, 0, 0, nil);
  var yTop: Integer := mCanvasHeight - Integer(mY + mLanderHeight div 2);
  var xLeft: Integer := Integer(mX - mLanderWidth div 2);
  //  Draw the fuel gauge
  var fuelWidth: Integer := Integer(UI_BAR * mFuel div PHYS_FUEL_MAX);
  mScratchRect.&set(4, 4, 4 + fuelWidth, 4 + UI_BAR_HEIGHT);
  aCanvas.drawRect(mScratchRect, mLinePaint);
  //  Draw the speed gauge, with a two-tone effect
  var speed: Double := Math.sqrt(mDX * mDX + mDY * mDY);
  var speedWidth: Integer := Integer(UI_BAR * speed div PHYS_SPEED_MAX);
  if speed <= mGoalSpeed then
  begin
    mScratchRect.&set(4 + UI_BAR + 4, 4, 4 + UI_BAR + 4 + speedWidth, 4 + UI_BAR_HEIGHT);
    aCanvas.drawRect(mScratchRect, mLinePaint)
  end
  else
  begin
    //  Draw the bad color in back, with the good color in front of
    //  it
    mScratchRect.&set(4 + UI_BAR + 4, 4, 4 + UI_BAR + 4 + speedWidth, 4 + UI_BAR_HEIGHT);
    aCanvas.drawRect(mScratchRect, mLinePaintBad);
    var goalWidth: Integer := UI_BAR * mGoalSpeed div PHYS_SPEED_MAX;
    mScratchRect.&set(4 + UI_BAR + 4, 4, 4 + UI_BAR + 4 + goalWidth, 4 + UI_BAR_HEIGHT);
    aCanvas.drawRect(mScratchRect, mLinePaint)
  end;
  //  Draw the landing pad
  aCanvas.drawLine(mGoalX, 1 + mCanvasHeight - TARGET_PAD_HEIGHT, mGoalX + mGoalWidth, 1 + mCanvasHeight - TARGET_PAD_HEIGHT, mLinePaint);
  //  Draw the ship with its current rotation
  aCanvas.save;
  aCanvas.rotate(Single(mHeading), Single(mX), mCanvasHeight - Single(mY));
  if mMode = STATE_LOSE then
  begin
    mCrashedImage.setBounds(xLeft, yTop, xLeft + mLanderWidth, yTop + mLanderHeight);
    mCrashedImage.draw(aCanvas)
  end
  else
  if mEngineFiring then
  begin
    mFiringImage.setBounds(xLeft, yTop, xLeft + mLanderWidth, yTop + mLanderHeight);
    mFiringImage.draw(aCanvas)
  end
  else
  begin
    mLanderImage.setBounds(xLeft, yTop, xLeft + mLanderWidth, yTop + mLanderHeight);
    mLanderImage.draw(aCanvas)
  end;
  aCanvas.restore
end;

/// <summary>
/// Figures the lander state (x, y, fuel, ...) based on the passage of
/// realtime. Does not invalidate(). Called at the start of draw().
/// Detects the end-of-game and sets the UI to the next state.
/// </summary>
method LunarThread.updatePhysics;
begin
  var now: Int64 := System.currentTimeMillis;
  //  Do nothing if mLastTime is in the future.
  //  This allows the game-start to delay the start of the physics
  //  by 100ms or whatever.
  if mLastTime > now then
    exit;
  var elapsed: Double := (now - mLastTime) / 1000.0;
  //  mRotating -- update heading
  if mRotating <> 0 then
  begin
    mHeading := mHeading + (mRotating * PHYS_SLEW_SEC * elapsed);
    //  Bring things back into the range 0..360
    if mHeading < 0 then
      mHeading := mHeading + 360
    else
    if mHeading >= 360 then
      mHeading := mHeading - 360
  end;
  //  Base accelerations -- 0 for x, gravity for y
  var ddx: Double := 0;
  var ddy: Double := -PHYS_DOWN_ACCEL_SEC * elapsed;
  if mEngineFiring then
  begin
    //  taking 0 as up, 90 as to the right
    //  cos(deg) is ddy component, sin(deg) is ddx component
    var elapsedFiring: Double := elapsed;
    var fuelUsed: Double := elapsedFiring * PHYS_FUEL_SEC;
    //  tricky case where we run out of fuel partway through the
    //  elapsed
    if fuelUsed > mFuel then
    begin
      elapsedFiring := mFuel div fuelUsed * elapsed;
      fuelUsed := mFuel;
      //  Oddball case where we adjust the "control" from here
      mEngineFiring := false
    end;
    mFuel := mFuel - fuelUsed;
    //  have this much acceleration from the engine
    var accel: Double := PHYS_FIRE_ACCEL_SEC * elapsedFiring;
    var radians: Double := 2 * Math.PI * mHeading div 360;
    ddx := Math.sin(radians) * accel;
    ddy := ddy + Math.cos(radians) * accel
  end;
  var dxOld: Double := mDX;
  var dyOld: Double := mDY;
  //  figure speeds for the end of the period
  mDX := mDX + ddx;
  mDY := mDY + ddy;
  //  figure position based on average speed during the period
  mX := mX + (elapsed * (mDX + dxOld) div 2);
  mY := mY + (elapsed * (mDY + dyOld) div 2);
  mLastTime := now;
  //  Evaluate if we have landed ... stop the game
  var yLowerBound: Double := TARGET_PAD_HEIGHT + (mLanderHeight div 2) - TARGET_BOTTOM_PADDING;
  if mY <= yLowerBound then
  begin
    mY := yLowerBound;
    var &result: Integer := STATE_LOSE;
    var msg: CharSequence := '';
    var res: Resources := mContext.Resources;
    var speed: Double := Math.sqrt(mDX * mDX + mDY * mDY);
    var onGoal: Boolean := (mGoalX <= mX - mLanderWidth div 2) and 
                           (mX + mLanderWidth div 2 <= mGoalX + mGoalWidth);
    //  "Hyperspace" win -- upside down, going fast,
    //  puts you back at the top.
    if (onGoal and (Math.abs(mHeading - 180) < mGoalAngle) and 
       (speed > PHYS_SPEED_HYPERSPACE)) then
    begin
      &result := STATE_WIN;
      inc(mWinsInARow);
      doStart;
      exit
    end
    else
    if not onGoal then
      msg := res.Text[R.string.message_off_pad]
    else
    if not (mHeading <= mGoalAngle) or (mHeading >= 360 - mGoalAngle) then
      msg := res.getText(R.string.message_bad_angle)
    else
    if speed > mGoalSpeed then
      msg := res.Text[R.string.message_too_fast]
    else
    begin
      &result := STATE_WIN;
      inc(mWinsInARow)
    end;
    setState(&result, msg)
  end
end;

end.