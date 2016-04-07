namespace com.example.android.jetboy;

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

// Android JET demonstration code:
// All inline comments related to the use of the JetPlayer class are preceded by "JET info:"

uses
  android.content,
  android.content.res,
  android.graphics,
  android.media,
  android.os,
  android.util,
  android.view,
  android.widget,
  java.util,
  java.util.concurrent;

type
  // JET info: the JetBoyThread receives all the events from the JET player
  // JET info: through the OnJetEventListener interface.
  JetBoyThread = public class(Thread, JetPlayer.OnJetEventListener)
  private
    //  how many frames per beat? The basic animation can be changed for
    //  instance to 3/4 by changing this to 3.
    //  untested is the impact on other parts of game logic for non 4/4 time.
    const ANIMATION_FRAMES_PER_BEAT = 4;
    
    //  string value for timer display
    var mTimerValue: String;
    
    //NOTE: in the original code the two title bitmaps were declared in JetBoyView
    //  a lazy graphic fudge for the initial title splash
    var mTitleBG: Bitmap;
    var mTitleBG2: Bitmap;
    
    // The drawable to use as the far background of the animation canvas
    var mBackgroundImageFar: Bitmap;
    
    // The drawable to use as the close background of the animation canvas
    var mBackgroundImageNear: Bitmap;
    
    //  JET info: event IDs within the JET file.
    //  JET info: in this game 80 is used for sending asteroid across the screen
    //  JET info: 82 is used as game time for 1/4 note beat.
    const NEW_ASTEROID_EVENT = 80;
    const TIMER_EVENT = 82;

    //NOTE: these track numbers were hardcoded in the original code
    const LASER_CHANNEL = 23;
    const EXPLOSION_CHANNEL = 24;
    
    //  used to track beat for synch of mute/unmute actions
    var mBeatCount: Integer := 1;
    
    //  our intrepid space boy
    var mShipFlying: array of Bitmap := new Bitmap[4];
    
    //  the twinkly bit
    var mBeam: array of Bitmap := new Bitmap[4];
    
    //  the things you are trying to hit
    
    var mAsteroids: array of Bitmap := new Bitmap[12];
    
    //  hit animation
    var mExplosions: array of Bitmap := new Bitmap[4];
    
    var mTimerShell: Bitmap;
    var mLaserShot: Bitmap;
    
    //  used to save the beat event system time.
    var mLastBeatTime: Int64;
    
    //  how much do we move the asteroids per beat?
    var mPixelMoveX: Integer := 25;
    
    //  the asteroid send events are generated from the Jet File.
    //  but which land they start in is random.
    var mRandom: Random := new Random;
    
    //  JET info: the star of our show, a reference to the JetPlayer object.
    var mJet: JetPlayer := nil;
    var mJetPlaying: Boolean := false;
    
    // Message handler used by thread to interact with TextView
    var mHandler: Handler;
    
    // Handle to the surface manager object we interact with
    var mSurfaceHolder: SurfaceHolder;
    
    // Handle to the application context, used to e.g. fetch Drawables.
    var mContext: Context;
    
    // Thread management members
    var mPauseLock: Object := new Object;
    var mPaused: Boolean;
    
    //  updates the screen clock. Also used for tempo timing.
    var mTimer: Timer := nil;
    var mTimerTask: TimerTask := nil;
    
    //  one second - used to update timer
    const mTaskIntervalInMillis = 1000;
    
    // Current height of the surface/canvas.
    // see setSurfaceSize
    var mCanvasHeight: Integer := 1;
    
    // Current width of the surface/canvas.
    // see setSurfaceSize
    var mCanvasWidth: Integer := 1;
    
    //  used to track the picture to draw for ship animation
    var mShipIndex: Integer := 0;
    
    //  stores all of the asteroid objects in order
    var mDangerWillRobinson: Vector<Asteroid>;
    var mExplosion: Vector<Explosion>;
    
    //  right to left scroll tracker for near and far BG
    var mBGFarMoveX: Integer := 0;
    var mBGNearMoveX: Integer := 0;
    
    //  how far up (close to top) jet boy can fly
    var mJetBoyYMin: Integer := 40;
    
    var mJetBoyX: Integer := 0;
    var mJetBoyY: Integer := 0;
    
    //NOTE: various hardcoded numbers used to place the laser beam guide and
    //work out asteroid shootability caused problems on larger displays.
    //Hence some extra fields and some calculations rather than fixed values.
    var mBeamImageXOffset: Integer;
    const mGuideOffsetInBeamImage = 40;
    const mAsteroidOffsetInImage = 8;
    const mAsteroidImageWidth = 64;
    const mAsteroidImageHeight = 64;
    var mNumAsteroidPaths: Integer;

    //  this is the pixel position of the laser beam guide.    
    var mAsteroidMoveLimitX: Integer; //NOTE: was hardcoded at 110;

    //  how far up asteroid can be painted    
    var mAsteroidMinY: Integer := 40;
    var mJetBoyView: JetBoyView;
    
    //  array to store the mute masks that are applied during game play to respond to
    //  the player's hit streaks
    var muteMask: array of array of Boolean;
    
    method initializeJetPlayer;
    method setInitialGameState;
    method doDraw(aCanvas: Canvas);
    method doDrawRunning(aCanvas: Canvas);
    method doDrawReady(aCanvas: Canvas);
    method doDrawPlay(aCanvas: Canvas);
    method doAsteroidCreation;
    method doAsteroidAnimation(aCanvas: Canvas);
  protected
    // Queue for GameEvents
    var mEventQueue: ConcurrentLinkedQueue<GameEvent> := new ConcurrentLinkedQueue<GameEvent>;
    // Context for processKey to maintain state accross frames
    var mKeyContext: Object := nil;
    method updateGameState;
    method updateLaser(inputContext: Object);
    method updateAsteroids(inputContext: Object);
    method updateExplosions(inputContext: Object);
    method processKeyEvent(evt: KeyGameEvent; ctx: Object): Object;
    method processJetEvent(player: JetPlayer; segment: SmallInt; track, channel, controller, value: SByte);
  assembly
    //  has laser been fired and for how long?
    //  user for fx logic on laser fire
    var mLaserOn: Boolean := false;
    var mLaserFireTime: Int64 := 0;
    var mRes: Resources;
  public
    const TAG = 'JetBoy';
    // State-tracking constants.
    const STATE_START = - 1;
    const STATE_PLAY = 0;
    const STATE_LOSE = 1;
    const STATE_PAUSE = 2;
    const STATE_RUNNING = 3;
    var mInitialized: Boolean := false;
    //  the timer display in seconds
    var mTimerLimit: Integer;
    //  used for internal timing logic.
    const TIMER_LIMIT = 72;
    //  start, play, running, lose are the states we use
    var mState: Integer;
    constructor(aJetBoyView: JetBoyView; aSurfaceHolder: SurfaceHolder; aContext: Context; aHandler: Handler);
    method run; override;
    method onJetNumQueuedSegmentUpdate(player: JetPlayer; nbSegments: Integer);
    method onJetEvent(player: JetPlayer; segment: SmallInt; track, channel, controller, value: SByte);
    method onJetPauseUpdate(player: JetPlayer; paused: Integer);
    method onJetUserIdUpdate(player: JetPlayer; userId, repeatCount: Integer);
    method doKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
    method doKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
    method doCountDown;
    method setSurfaceSize(width, height: Integer);
    method pause;
    method unPause;
    method getGameState: Integer;
    method setGameState(mode: Integer);
  end;

  CountdownTimerTask nested in JetBoyThread = private class(TimerTask)
  private
    _thread: JetBoyThread;
  public
    constructor(aThread: JetBoyThread);
    method run; override;
  end;

implementation

/// <summary>
/// This is the constructor for the main worker bee
/// </summary>
constructor JetBoyThread(aJetBoyView: JetBoyView; aSurfaceHolder: SurfaceHolder; aContext: Context; aHandler: Handler);
begin
  mJetBoyView := aJetBoyView;
  mSurfaceHolder := aSurfaceHolder;
  mHandler := aHandler;
  mContext := aContext;
  mRes := aContext.Resources;
  //  JET info: this are the mute arrays associated with the music beds in the
  //  JET info: JET file
  //Alocate all the muteMasks
  muteMask := new array of Boolean[9];
  for ii: Integer := 0 to pred(muteMask.length) do
    muteMask[ii] := new Boolean[32];

  for ii: Integer := 0 to pred(8) do
    for xx: Integer := 0 to pred(32) do
      muteMask[ii][xx] := true;
  muteMask[0][2] := false;
  muteMask[0][3] := false;
  muteMask[0][4] := false;
  muteMask[0][5] := false;

  muteMask[1][2] := false;
  muteMask[1][3] := false;
  muteMask[1][4] := false;
  muteMask[1][5] := false;
  muteMask[1][8] := false;
  muteMask[1][9] := false;

  muteMask[2][2] := false;
  muteMask[2][3] := false;
  muteMask[2][6] := false;
  muteMask[2][7] := false;
  muteMask[2][8] := false;
  muteMask[2][9] := false;

  muteMask[3][2] := false;
  muteMask[3][3] := false;
  muteMask[3][6] := false;
  muteMask[3][11] := false;
  muteMask[3][12] := false;

  muteMask[4][2] := false;
  muteMask[4][3] := false;
  muteMask[4][10] := false;
  muteMask[4][11] := false;
  muteMask[4][12] := false;
  muteMask[4][13] := false;

  muteMask[5][2] := false;
  muteMask[5][3] := false;
  muteMask[5][10] := false;
  muteMask[5][12] := false;
  muteMask[5][15] := false;
  muteMask[5][17] := false;

  muteMask[6][2] := false;
  muteMask[6][3] := false;
  muteMask[6][14] := false;
  muteMask[6][15] := false;
  muteMask[6][16] := false;
  muteMask[6][17] := false;

  muteMask[7][2] := false;
  muteMask[7][3] := false;
  muteMask[7][6] := false;
  muteMask[7][14] := false;
  muteMask[7][15] := false;
  muteMask[7][16] := false;
  muteMask[7][17] := false;
  muteMask[7][18] := false;

  //  set all tracks to play
  for xx: Integer := 0 to pred(32) do
    muteMask[8][xx] := false;

  //  always set state to start, ensure we come in from front door if
  //  app gets tucked into background
  mState := STATE_START;

  setInitialGameState;

  mTitleBG := BitmapFactory.decodeResource(mRes, R.drawable.title_hori);

  //  load background image as a Bitmap instead of a Drawable b/c
  //  we don't need to transform it and it's faster to draw this
  //  way...thanks lunar lander :)

  //  two background since we want them moving at different speeds
  mBackgroundImageFar := BitmapFactory.decodeResource(mRes, R.drawable.background_a);

  mLaserShot := BitmapFactory.decodeResource(mRes, R.drawable.laser);

  mBackgroundImageNear := BitmapFactory.decodeResource(mRes, R.drawable.background_b);

  mShipFlying[0] := BitmapFactory.decodeResource(mRes, R.drawable.ship2_1);
  mShipFlying[1] := BitmapFactory.decodeResource(mRes, R.drawable.ship2_2);
  mShipFlying[2] := BitmapFactory.decodeResource(mRes, R.drawable.ship2_3);
  mShipFlying[3] := BitmapFactory.decodeResource(mRes, R.drawable.ship2_4);

  mBeam[0] := BitmapFactory.decodeResource(mRes, R.drawable.intbeam_1);
  mBeam[1] := BitmapFactory.decodeResource(mRes, R.drawable.intbeam_2);
  mBeam[2] := BitmapFactory.decodeResource(mRes, R.drawable.intbeam_3);
  mBeam[3] := BitmapFactory.decodeResource(mRes, R.drawable.intbeam_4);

  mBeamImageXOffset := (mShipFlying[0].Width div 2) + 40;
  mAsteroidMoveLimitX := mBeamImageXOffset + mGuideOffsetInBeamImage;

  mTimerShell := BitmapFactory.decodeResource(mRes, R.drawable.int_timer);

  //  I wanted them to rotate in a certain way
  //  so I loaded them backwards from the way created.
  mAsteroids[11] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid01);
  mAsteroids[10] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid02);
  mAsteroids[9] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid03);
  mAsteroids[8] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid04);
  mAsteroids[7] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid05);
  mAsteroids[6] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid06);
  mAsteroids[5] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid07);
  mAsteroids[4] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid08);
  mAsteroids[3] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid09);
  mAsteroids[2] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid10);
  mAsteroids[1] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid11);
  mAsteroids[0] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid12);

  mExplosions[0] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid_explode1);
  mExplosions[1] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid_explode2);
  mExplosions[2] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid_explode3);
  mExplosions[3] := BitmapFactory.decodeResource(mRes, R.drawable.asteroid_explode4);

  mTimerValue := mContext.String[R.string.timer];
end;

/// <summary>
/// Does the grunt work of setting up initial jet requirements
/// </summary>
method JetBoyThread.initializeJetPlayer();
begin
  //  JET info: let's create our JetPlayer instance using the factory.
  //  JET info: if we already had one, the same singleton is returned.
  mJet := JetPlayer.JetPlayer;

  mJetPlaying := false;

  //  JET info: make sure we flush the queue,
  //  JET info: otherwise left over events from previous gameplay can hang around.
  //  JET info: ok, here we don't really need that but if you ever reuse a JetPlayer
  //  JET info: instance, clear the queue before reusing it, this will also clear any
  //  JET info: trigger clips that have been triggered but not played yet.
  mJet.clearQueue;

  //  JET info: we are going to receive in this example all the JET callbacks
  //  JET info: inthis animation thread object.
  mJet.EventListener := self;

  Log.d(TAG, 'opening jet file');

  //  JET info: load the actual JET content the game will be playing,
  //  JET info: it's stored as a raw resource in our APK, and is labeled "level1"
  mJet.loadJetFile(mContext.Resources.openRawResourceFd(R.raw.level1));
  //  JET info: if our JET file was stored on the sdcard for instance, we would have used
  //  JET info: mJet.loadJetFile("/sdcard/level1.jet");

  Log.d(TAG, 'opening jet file DONE');

  mJetBoyView.mCurrentBed := 0;
  var sSegmentID: SByte := 0;

  Log.d(TAG, ' start queuing jet file');

  //  JET info: now we're all set to prepare queuing the JET audio segments for the game.
  //  JET info: in this example, the game uses segment 0 for the duration of the game play,
  //  JET info: and plays segment 1 several times as the "outro" music, so we're going to
  //  JET info: queue everything upfront, but with more complex JET compositions, we could
  //  JET info: also queue the segments during the game play.

  //  JET info: this is the main game play music
  //  JET info: it is located at segment 0
  //  JET info: it uses the first DLS lib in the .jet resource, which is at index 0
  //  JET info: index -1 means no DLS
  mJet.queueJetSegment(0, 0, 0, 0, 0, sSegmentID);

  //  JET info: end game music, loop 4 times normal pitch
  mJet.queueJetSegment(1, 0, 4, 0, 0, sSegmentID);

  //  JET info: end game music loop 4 times up an octave
  mJet.queueJetSegment(1, 0, 4, 1, 0, sSegmentID);

  //  JET info: set the mute mask as designed for the beginning of the game, when the
  //  JET info: the player hasn't scored yet.
  mJet.setMuteArray(muteMask[0], true);

  Log.d(TAG, ' start queuing jet file DONE')
end;

/// <summary>
/// the heart of the worker bee
/// </summary>
method JetBoyThread.run;
begin
  while true do
  begin
    var c: Canvas := nil;
    if mState = STATE_RUNNING then
    begin
      //  Process any input and apply it to the game state
      updateGameState;
      if not mJetPlaying then
      begin
        mInitialized := false;
        Log.d(TAG, '------> STARTING JET PLAY');
        mJet.play;
        mJetPlaying := true
      end;
      //  kick off the timer task for counter update if not already
      //  initialized
      if mTimerTask = nil then
      begin
        mTimerTask := new CountdownTimerTask(self);
        mTimer.schedule(mTimerTask, mTaskIntervalInMillis)
      end
    end
    else
    if (mState = STATE_PLAY) and not mInitialized then
      setInitialGameState
    else
    if mState = STATE_LOSE then
      mInitialized := false;
    try
      c := mSurfaceHolder.lockCanvas(nil);
      //NOTE: original SDK demo had this commented out
      locking mSurfaceHolder do
      begin
        //NOTE: original SDK demo did not check for nil here
        //On some devices immediately after pause (on switching away) c will be nil
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
    //If the thread has been paused, then block until we are
    //notified we can proceed
    locking mPauseLock do 
      while mPaused do
        try
          mPauseLock.wait
        except
          on e: InterruptedException do 
            { whatever };
        end
  end;
end;

// JET info: JET event listener interface implementation:

/// <summary>
/// required OnJetEventListener method. Notifications for queue updates
/// </summary>
/// <param name="player"></param>
/// <param name="nbSegments"></param>
method JetBoyThread.onJetNumQueuedSegmentUpdate(player: JetPlayer; nbSegments: Integer);
begin
  //Log.i(TAG, "onJetNumQueuedUpdate(): nbSegs =" + nbSegments);
end;

// JET info: JET event listener interface implementation:

/// <summary>
/// The method which receives notification from event listener.
/// This is where we queue up events 80 and 82.
/// 
/// Most of this data passed is unneeded for JetBoy logic but shown 
/// for code sample completeness.
/// </summary>
/// <param name="player"></param>
/// <param name="segment"></param>
/// <param name="track"></param>
/// <param name="channel"></param>
/// <param name="controller"></param>
/// <param name="value"></param>
method JetBoyThread.onJetEvent(player: JetPlayer; segment: SmallInt; track, channel, controller, value: SByte);
begin
  // Log.d(TAG, "jet got event " + value);

  // events fire outside the animation thread. This can cause timing issues.
  // put in queue for processing by animation thread.
  mEventQueue.&add(new JetGameEvent(player, segment, track, channel, controller, value));
end;

// JET info: JET event listener interface implementation:
method JetBoyThread.onJetPauseUpdate(player: JetPlayer; paused: Integer);
begin
  //Log.i(TAG, "onJetPauseUpdate(): paused =" + paused);
end;

// JET info: JET event listener interface implementation:
method JetBoyThread.onJetUserIdUpdate(player: JetPlayer; userId, repeatCount: Integer);
begin
  //Log.i(TAG, "onJetUserIdUpdate(): userId =" + userId + " repeatCount=" + repeatCount);
end;

/// <summary>
/// Add key press input to the GameEvent queue
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method JetBoyThread.doKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  mEventQueue.add(new KeyGameEvent(keyCode, false, msg));
  exit true;
end;

/// <summary>
/// Add key press input to the GameEvent queue
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method JetBoyThread.doKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  mEventQueue.add(new KeyGameEvent(keyCode, true, msg));
  exit true;
end;

/// <summary>
/// Does the work of updating timer
/// </summary>
method JetBoyThread.doCountDown;
begin
  // Log.d(TAG,"Time left is " + mTimerLimit);
  dec(mTimerLimit);
  try
    // subtract one minute and see what the result is.
    var moreThanMinute: Integer := mTimerLimit - 60;
    if moreThanMinute >= 0 then
    begin
      if moreThanMinute > 9 then
        mTimerValue := '1:' + moreThanMinute
      else
        mTimerValue := '1:0' + moreThanMinute
    end
    else
    begin
      if mTimerLimit > 9 then
        mTimerValue := '0:' + mTimerLimit
      else
        mTimerValue := '0:0' + mTimerLimit
    end;
  except
    on e1: Exception do 
      Log.e(TAG, 'doCountDown threw ' + e1.toString)
  end;
  var msg: Message := mHandler.obtainMessage;
  var b: Bundle := new Bundle;
  b.putString('text', mTimerValue);
  // time's up
  if mTimerLimit = 0 then
  begin
    b.putString('STATE_LOSE', '' + STATE_LOSE);
    mTimerTask := nil;
    mState := STATE_LOSE
  end
  else
  begin
    mTimerTask := new CountdownTimerTask(self);
    mTimer.schedule(mTimerTask, mTaskIntervalInMillis)
  end;
  // this is how we send data back up to the main JetBoyView thread.
  // if you look in constructor of JetBoyView you will see code for
  // Handling of messages. This is borrowed directly from lunar lander.
  // Thanks again!
  msg.Data := b;
  mHandler.sendMessage(msg);
end;

/// <summary>
/// Callback invoked when the surface dimensions change.
/// </summary>
method JetBoyThread.setSurfaceSize(width, height: Integer);
begin
  //  synchronized to make sure these all change atomically
  locking mSurfaceHolder do 
  begin
    mCanvasWidth := width;
    mCanvasHeight := height;
    //  don't forget to resize the background image
    mBackgroundImageFar := Bitmap.createScaledBitmap(mBackgroundImageFar, width * 2, height, true);
    //  don't forget to resize the background image
    mBackgroundImageNear := Bitmap.createScaledBitmap(mBackgroundImageNear, width * 2, height, true);
    //NOTE: new code to work out no. of asteroid paths based on height
    //minus the non-beam section at top and bottom
    mNumAsteroidPaths := (mCanvasHeight - mAsteroidMinY - mAsteroidMinY) div mAsteroidImageHeight;
  end;
end;

/// <summary>
/// Pauses the physics update & animation.
/// </summary>
method JetBoyThread.pause;
begin
  //Check for already-paused state
  if mPaused then
    exit;
  locking mSurfaceHolder do 
  begin
    //NOTE: JetBoy doesn't seem to have any support for a PAUSE state, so we'll ignore this
    //if mState = STATE_RUNNING then
    //  setGameState(STATE_PAUSE);
    if mTimerTask <> nil then
    begin
      mTimerTask.cancel;
      //NOTE: original code did not set mTimerTask to nil
      mTimerTask := nil
    end;
    if mJet <> nil then
    begin
      Log.d(TAG, ' pausing JET');
      if mJetPlaying then
        mJet.pause;
      Log.d(TAG, ' paused JET');
      //NOTE: this wasn't in the original code
      mJetPlaying := false;
    end;
  end;
  //NOTE: new thread management code
  //To pause the thread we set a flag to true
  locking mPauseLock do 
    mPaused := true;
end;

/// <summary>
/// Resumes the physics update & animation.
/// </summary>
method JetBoyThread.unPause;
begin
  //NOTE: new thread management code
  //To resume the thread we unset the flag and notify all waiting on the lock
  locking mPauseLock do 
  begin
    mPaused := false;
    mPauseLock.notifyAll
  end;
end;

/// <summary>
/// returns the current int value of game state as defined by state
/// tracking constants
/// </summary>
method JetBoyThread.getGameState: Integer;
begin
  locking mSurfaceHolder do 
    exit mState
end;

/// <summary>
/// Sets the game mode. That is, whether we are running, paused, in the
/// failure state, in the victory state, etc.
/// see setState(int, CharSequence)
/// </summary>
/// <param name="mode">one of the STATE_* constants</param>
method JetBoyThread.setGameState(mode: Integer);
begin
  locking mSurfaceHolder do 
  begin
    //  change state if needed
    if mState <> mode then
      mState := mode;
    if mState = STATE_PLAY then
    begin
      var res: Resources := mContext.Resources;
      mBackgroundImageFar := BitmapFactory.decodeResource(res, R.drawable.background_a);
      //  don't forget to resize the background image
      mBackgroundImageFar := Bitmap.createScaledBitmap(mBackgroundImageFar, mCanvasWidth * 2, mCanvasHeight, true);
      mBackgroundImageNear := BitmapFactory.decodeResource(res, R.drawable.background_b);
      //  don't forget to resize the background image
      mBackgroundImageNear := Bitmap.createScaledBitmap(mBackgroundImageNear, mCanvasWidth * 2, mCanvasHeight, true)
    end
    else
    if mState = STATE_RUNNING then
    begin
      //  When we enter the running state we should clear any old
      //  events in the queue
      mEventQueue.clear;
      //  And reset the key state so we don't think a button is pressed when it isn't
      mKeyContext := nil
    end
  end;
end;

method JetBoyThread.doDraw(aCanvas: Canvas);
begin
  if mState = STATE_RUNNING then
    doDrawRunning(aCanvas)
  else
  if mState = STATE_START then
    doDrawReady(aCanvas)
  else
  if mState in [STATE_PLAY, STATE_LOSE] then
  begin
    if mTitleBG2 = nil then
      mTitleBG2 := BitmapFactory.decodeResource(mRes, R.drawable.title_bg_hori);
    doDrawPlay(aCanvas)
  end; // end state play block
end;

/// <summary>
/// Draws current state of the game Canvas.
/// </summary>
/// <param name="aCanvas"></param>
method JetBoyThread.doDrawRunning(aCanvas: Canvas);
begin
  //  decrement the far background
  mBGFarMoveX := mBGFarMoveX - 1;

  //  decrement the near background
  mBGNearMoveX := mBGNearMoveX - 4;

  //  calculate the wrap factor for matching image draw
  var newFarX: Integer := mBackgroundImageFar.Width - - mBGFarMoveX;

  //  if we have scrolled all the way, reset to start
  if newFarX <= 0 then
  begin
    mBGFarMoveX := 0;
    //  only need one draw
    aCanvas.drawBitmap(mBackgroundImageFar, mBGFarMoveX, 0, nil)
  end
  else
  begin
    //  need to draw original and wrap
    aCanvas.drawBitmap(mBackgroundImageFar, mBGFarMoveX, 0, nil);
    aCanvas.drawBitmap(mBackgroundImageFar, newFarX, 0, nil)
  end;

  //  same story different image...
  //  TODO possible method call
  var newNearX: Integer := mBackgroundImageNear.Width - -mBGNearMoveX;
  if newNearX <= 0 then
  begin
    mBGNearMoveX := 0;
    aCanvas.drawBitmap(mBackgroundImageNear, mBGNearMoveX, 0, nil)
  end
  else
  begin
    aCanvas.drawBitmap(mBackgroundImageNear, mBGNearMoveX, 0, nil);
    aCanvas.drawBitmap(mBackgroundImageNear, newNearX, 0, nil)
  end;

  doAsteroidAnimation(aCanvas);

  //NOTE: original code used hardcoded numbers here (X = 50 + 21), which made things
  //very tight for the space ship on larger displays.
  //Also the beam wasn't stretched across the full vertical space of larger displays
  //TODO: remove this from the oft-called drawing code and scale the bitmap when the surface changes
  var src := new Rect(0, 0, mBeam[mShipIndex].Width, mBeam[mShipIndex].Height);
  var dest := new Rect(mBeamImageXOffset, 0, mBeam[mShipIndex].Width + mBeamImageXOffset, aCanvas.Height);
  aCanvas.drawBitmap(mBeam[mShipIndex], src, dest, nil);

  inc(mShipIndex);

  if mShipIndex = 4 then
    mShipIndex := 0;

  //  draw the space ship in the same lane as the next asteroid
  aCanvas.drawBitmap(mShipFlying[mShipIndex], mJetBoyX, mJetBoyY, nil);

  if mLaserOn then
    aCanvas.drawBitmap(mLaserShot, mJetBoyX + mShipFlying[0].Width, mJetBoyY + (mShipFlying[0].Height div 2), nil);

  //  tick tock
  aCanvas.drawBitmap(mTimerShell, mCanvasWidth - mTimerShell.Width, 0, nil)
end;

method JetBoyThread.doDrawReady(aCanvas: Canvas);
begin
  //NOTE: original code did not resize the bitmap, so it didn't cover larger displays
  //TODO: remove this from the oft-called drawing code and scale the bitmap when the surface changes
  var src := new Rect(0, 0, mTitleBG.Width, mTitleBG.Height);
  var dest := new Rect(0, 0, aCanvas.Width, aCanvas.Height);
  aCanvas.drawBitmap(mTitleBG, src, dest, nil);
end;

method JetBoyThread.doDrawPlay(aCanvas: Canvas);
begin
  //NOTE: original code did not resize the bitmap, so it didn't cover larger displays
  //TODO: remove this from the oft-called drawing code and scale the bitmap when the surface changes
  var src := new Rect(0, 0, mTitleBG2.Width, mTitleBG2.Height);
  var dest := new Rect(0, 0, aCanvas.Width, aCanvas.Height);
  aCanvas.drawBitmap(mTitleBG2, src, dest, nil);
end;

method JetBoyThread.setInitialGameState;
begin
  mTimerLimit := TIMER_LIMIT;

  mJetBoyY := mJetBoyYMin;

  //  set up jet stuff
  initializeJetPlayer;

  mTimer := new Timer;

  mDangerWillRobinson := new Vector<Asteroid>;

  mExplosion := new Vector<Explosion>;

  mInitialized := true;

  mJetBoyView.mHitStreak := 0;
  mJetBoyView.mHitTotal := 0
end;

method JetBoyThread.doAsteroidCreation;
begin
  //  Log.d(TAG, 'asteroid created');
  var ast: Asteroid := new Asteroid;
  //NOTE: original code hardcoded 4 asteroid paths and hardcoded
  //a value of 63 to multiply drawIndex by
  var drawIndex: Integer := mRandom.nextInt(mNumAsteroidPaths);
  ast.mDrawY := mAsteroidMinY + (drawIndex * mAsteroidImageHeight);
  ast.mDrawX := mCanvasWidth - mAsteroids[0].Width;
  ast.mStartTime := System.currentTimeMillis;
  mDangerWillRobinson.&add(ast);
end;

method JetBoyThread.doAsteroidAnimation(aCanvas: Canvas);
begin
  if ((mDangerWillRobinson = nil) or (mDangerWillRobinson.size = 0)) and
     ((mExplosion <> nil) and (mExplosion.size = 0)) then
    exit;

  //  Compute what percentage through a beat we are and adjust
  //  animation and position based on that. This assumes 140bpm(428ms/beat).
  //  This is just inter-beat interpolation, no game state is updated
  var frameDelta: Int64 := System.currentTimeMillis - mLastBeatTime;

  var animOffset: Integer := ANIMATION_FRAMES_PER_BEAT * frameDelta div 428;

  for i: Integer := mDangerWillRobinson.size - 1 downto 0 do
  begin
    var ast: Asteroid := mDangerWillRobinson.elementAt(i);
    if not ast.mMissed then
      mJetBoyY := ast.mDrawY;
    //  Log.d(TAG, ' drawing asteroid ' + ii.toString + ' at ' + ast.mDrawX );
    aCanvas.drawBitmap(mAsteroids[(ast.mAniIndex + animOffset) mod mAsteroids.length], ast.mDrawX, ast.mDrawY, nil);
  end;

  for i: Integer := mExplosion.size - 1 downto 0 do
  begin
    var ex: Explosion := mExplosion.elementAt(i);
    aCanvas.drawBitmap(mExplosions[(ex.mAniIndex + animOffset) mod mExplosions.length], ex.mDrawX, ex.mDrawY, nil);
  end;
end;

/// <summary>
/// This method handles updating the model of the game state. No
/// rendering is done here only processing of inputs and update of state.
/// This includes positons of all game objects (asteroids, player,
/// explosions), their state (animation frame, hit), creation of new
/// objects, etc.
/// </summary>
method JetBoyThread.updateGameState;
begin
  // Process any game events and apply them
  while true do 
  begin
    var evt: GameEvent := mEventQueue.poll;
    if evt = nil then
      break;
    //  Log.d(TAG,'*** EVENT = ' + event);
    //  Process keys tracking the input context to pass in to later
    //  calls
    if evt is KeyGameEvent then
    begin
      //  Process the key for affects other then asteroid hits
      mKeyContext := processKeyEvent(KeyGameEvent(evt), mKeyContext);
      //  Update laser state. Having this here allows the laser to
      //  be triggered right when the key is pressed. If we comment
      //  this out the laser will only be turned on when updateLaser
      //  is called when processing a timer event below.
      updateLaser(mKeyContext)
    end
    else
    if evt is JetGameEvent then
    begin
      var jetEvent: JetGameEvent := JetGameEvent(evt);
      //  Only update state on a timer event
      if jetEvent.value = TIMER_EVENT then
      begin
        //  Note the time of the last beat
        mLastBeatTime := System.currentTimeMillis;
        //  Update laser state, turning it on if a key has been
        //  pressed or off if it has been on for too long.
        updateLaser(mKeyContext);
        //  Update explosions before we update asteroids because
        //  updateAsteroids may add new explosions that we do
        //  not want updated until next frame
        updateExplosions(mKeyContext);
        //  Update asteroid positions, hit status and animations
        updateAsteroids(mKeyContext)
      end;
      processJetEvent(jetEvent.player, jetEvent.segment, jetEvent.track, jetEvent.channel, jetEvent.controller, jetEvent.value)
    end
  end;
end;

/// <summary>
/// This method updates the laser status based on user input and shot
/// duration
/// </summary>
method JetBoyThread.updateLaser(inputContext: Object);
begin
  //  Lookup the time of the fire event if there is one
  var keyTime: Int64 := if inputContext = nil then 0 else GameEvent(inputContext).eventTime;
  //  Log.d(TAG, 'keyTime delta = ' +
  //  System.currentTimeMillis-keyTime + ": obj = " + inputContext);
  //  If the laser has been on too long shut it down
  if mLaserOn and (System.currentTimeMillis - mLaserFireTime > 400) then
    mLaserOn := false
  else
  if System.currentTimeMillis - mLaserFireTime > 300 then
  begin
    //  JET info: the laser sound is on track 23, we mute it (true) right away (false)
    mJet.setMuteFlag(LASER_CHANNEL, true, false)
  end;
  //  Now check to see if we should turn the laser on. We do this after
  //  the above shutdown logic so it can be turned back on in the same frame
  //  it was turned off in. If we want to add a cooldown period this may change.
  if not mLaserOn and (System.currentTimeMillis - keyTime <= 400) then
  begin
    mLaserOn := true;
    mLaserFireTime := keyTime;
    //  JET info: unmute the laser track (false) right away (false)
    mJet.setMuteFlag(LASER_CHANNEL, false, false)
  end;
end;

/// <summary>
/// Update asteroid state including position and laser hit status.
/// </summary>
method JetBoyThread.updateAsteroids(inputContext: Object);
begin
  if (mDangerWillRobinson = nil) or (mDangerWillRobinson.size = 0) then
    exit;
  for i: Integer := pred(mDangerWillRobinson.size) downto 0 do
  begin
    var ast: Asteroid := mDangerWillRobinson.elementAt(i);
    // If the asteroid is within laser range but not already missed
    // check if the key was pressed close enough to the beat to make a hit
    //NOTE: original code hardcoded a figure of 20 instead of mAsteroidOffsetInImage
    if (ast.mDrawX <= mAsteroidMoveLimitX + mAsteroidOffsetInImage) and not ast.mMissed then
    begin
      // If the laser was fired on the beat destroy the asteroid
      if mLaserOn then
      begin
        // Track hit streak for adjusting music
        inc(mJetBoyView.mHitStreak);
        inc(mJetBoyView.mHitTotal);

        // replace the asteroid with an explosion
        var ex: Explosion := new Explosion;
        ex.mAniIndex := 0;
        ex.mDrawX := ast.mDrawX;
        ex.mDrawY := ast.mDrawY;
        mExplosion.add(ex);

        mJet.setMuteFlag(EXPLOSION_CHANNEL, false, false);

        mDangerWillRobinson.removeElementAt(i);

        // This asteroid has been removed process the next one
        continue;
      end
      else
      begin
        // Sorry, timing was not good enough, mark the asteroid
        // as missed so on next frame it cannot be hit even if it is still
        // within range
        ast.mMissed := true;
        dec(mJetBoyView.mHitStreak);
        if mJetBoyView.mHitStreak < 0 then
          mJetBoyView.mHitStreak := 0;
      end;
    end;
    //  Update the asteroids position, even missed ones keep moving
    ast.mDrawX := ast.mDrawX - mPixelMoveX;

    // Update asteroid animation frame
    ast.mAniIndex := (ast.mAniIndex + ANIMATION_FRAMES_PER_BEAT) mod mAsteroids.length;

    // if we have scrolled off the screen
    if ast.mDrawX < 0 then
      mDangerWillRobinson.removeElementAt(i);
  end;
end;

/// <summary>
/// This method updates explosion animation and removes them once they
/// have completed.
/// </summary>
method JetBoyThread.updateExplosions(inputContext: Object);
begin
  if (mExplosion = nil) or (mExplosion.size = 0) then
    exit;
  for i: Integer := pred(mExplosion.size) downto 0 do
  begin
    var ex: Explosion := mExplosion.elementAt(i);
    ex.mAniIndex := ex.mAniIndex + ANIMATION_FRAMES_PER_BEAT;
    
    //  When the animation completes remove the explosion
    if ex.mAniIndex > 3 then
    begin
      mJet.setMuteFlag(EXPLOSION_CHANNEL, true, false);
      mJet.setMuteFlag(LASER_CHANNEL, true, false);

      mExplosion.removeElementAt(i)
    end;
  end;
end;

/// <summary>
/// This method handles the state updates that can be caused by key press
/// events. Key events may mean different things depending on what has
/// come before, to support this concept this method takes an opaque
/// context object as a parameter and returns an updated version. This
/// context should be set to null for the first event then should be set
/// to the last value returned for subsequent events.
/// </summary>
/// <param name="evt"></param>
/// <param name="ctx"></param>
/// <returns></returns>
method JetBoyThread.processKeyEvent(evt: KeyGameEvent; ctx: Object): Object;
begin
  //  Log.d(TAG, "key code is " + event.keyCode + " " + (event.up ?
  //  "up":"down"));
  //  If it is a key up on the fire key make sure we mute the
  //  associated sound
  if evt.up then
  begin
    if evt.keyCode = KeyEvent.KEYCODE_DPAD_CENTER then
      exit nil
  end
  else
  begin
    if (evt.keyCode = KeyEvent.KEYCODE_DPAD_CENTER) and (ctx = nil) then
      exit evt
  end;
  //  Return the context unchanged
  exit ctx;
end;

/// <summary>
/// This method handles the state updates that can be caused by JET
/// events.
/// </summary>
method JetBoyThread.processJetEvent(player: JetPlayer; segment: SmallInt; track, channel, controller, value: SByte);
begin
  // Log.d(TAG, "onJetEvent(): seg=" + segment + " track=" + track + " chan=" + channel
  //         + " cntrlr=" + controller + " val=" + value);
  //  Check for an event that triggers a new asteroid
  if value = NEW_ASTEROID_EVENT then
    doAsteroidCreation;
  
  inc(mBeatCount);

  if mBeatCount > 4 then
    mBeatCount := 1;

  //  Scale the music based on progress

  //  it was a game requirement to change the mute array on 1st beat of
  //  the next measure when needed
  //  and so we track beat count, after that we track hitStreak to
  //  determine the music "intensity"
  //  if the intensity has gone up, call a corresponding trigger clip, otherwise just
  //  execute the rest of the music bed change logic.
  if mBeatCount = 1 then
  begin
    //  do it back wards so you fall into the correct one
    if mJetBoyView.mHitStreak > 28 then
    begin
      //  did the bed change?
      if mJetBoyView.mCurrentBed <> 7 then
      begin
        //  did it go up?
        if mJetBoyView.mCurrentBed < 7 then
          mJet.triggerClip(7);
        mJetBoyView.mCurrentBed := 7;
        //  JET info: change the mute mask to update the way the music plays based
        //  JET info: on the player's skills.
        mJet.setMuteArray(muteMask[7], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 24 then
    begin
      if mJetBoyView.mCurrentBed <> 6 then
      begin
        if mJetBoyView.mCurrentBed < 6 then
        begin
          //  JET info: quite a few asteroids hit, trigger the clip with the guy's
          //  JET info: voice that encourages the player.
          mJet.triggerClip(6)
        end;
        mJetBoyView.mCurrentBed := 6;
        mJet.setMuteArray(muteMask[6], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 20 then
    begin
      if mJetBoyView.mCurrentBed <> 5 then
      begin
        if mJetBoyView.mCurrentBed < 5 then
          mJet.triggerClip(5);
        mJetBoyView.mCurrentBed := 5;
        mJet.setMuteArray(muteMask[5], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 16 then
    begin
      if mJetBoyView.mCurrentBed <> 4 then
      begin
        if mJetBoyView.mCurrentBed < 4 then
          mJet.triggerClip(4);
        mJetBoyView.mCurrentBed := 4;
        mJet.setMuteArray(muteMask[4], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 12 then
    begin
      if mJetBoyView.mCurrentBed <> 3 then
      begin
        if mJetBoyView.mCurrentBed < 3 then
          mJet.triggerClip(3);
        mJetBoyView.mCurrentBed := 3;
        mJet.setMuteArray(muteMask[3], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 8 then
    begin
      if mJetBoyView.mCurrentBed <> 2 then
      begin
        if mJetBoyView.mCurrentBed < 2 then
          mJet.triggerClip(2);
        mJetBoyView.mCurrentBed := 2;
        mJet.setMuteArray(muteMask[2], false)
      end
    end
    else
    if mJetBoyView.mHitStreak > 4 then
    begin
      if mJetBoyView.mCurrentBed <> 1 then
      begin
        if mJetBoyView.mCurrentBed < 1 then
          mJet.triggerClip(1);
        mJet.setMuteArray(muteMask[1], false);
        mJetBoyView.mCurrentBed := 1
      end
    end
  end;
end;

constructor JetBoyThread.CountdownTimerTask(aThread: JetBoyThread);
begin
  inherited constructor;
  _thread := aThread
end;

method JetBoyThread.CountdownTimerTask.run;
begin
  _thread.doCountDown
end;

end.