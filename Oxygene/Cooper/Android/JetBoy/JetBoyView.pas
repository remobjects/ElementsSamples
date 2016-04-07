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
  android.os,
  android.util,
  android.view, 
  android.widget;

type
  JetBoyView = public class(SurfaceView, SurfaceHolder.Callback)
  private
    // The thread that actually draws the animation
    var thread: JetBoyThread;
    var mTimerView: TextView;
    var mButtonRetry: Button;    
    // var mButtonRestart: Button;
    var mTextView: TextView;
  public
    const TAG = 'JetBoy';
    //  the number of asteroids that must be destroyed
    const mSuccessThreshold = 50;
    //  used to calculate level for mutes and trigger clip
    var mHitStreak: Integer := 0;
    //  total number asteroids you need to hit.
    var mHitTotal: Integer := 0;
    //  which music bed is currently playing?
    var mCurrentBed: Integer := 0;
    // have we already started up
    var mGameIsRunning: Boolean := false;
  public
    constructor(ctx: Context; attrs: AttributeSet);
    method onWindowFocusChanged(hasWindowFocus: Boolean); override;
    method setTimerView(tv: TextView);
    method getThread: JetBoyThread;
    method SetButtonView(_buttonRetry: Button);
    method SetTextView(textView: TextView);

    // SurfaceHolder.Callback methods
    method surfaceCreated(arg0: SurfaceHolder);
    method surfaceChanged(holder: SurfaceHolder; format, width, height: Integer);
    method surfaceDestroyed(arg0: SurfaceHolder);
  end;

implementation

/// <summary>
/// The constructor called from the main JetBoy activity
/// </summary>
/// <param name="ctx"></param>
/// <param name="attrs"></param>
constructor JetBoyView(ctx: Context; attrs: AttributeSet);
begin
  inherited;
  //  register our interest in hearing about changes to our surface
  var surfHolder: SurfaceHolder := Holder;
  surfHolder.addCallback(self);
  if  not isInEditMode then
  begin
    //  create thread only; it's started in surfaceCreated()
    thread := new JetBoyThread(self, surfHolder, ctx, new Handler(
      new interface Handler.Callback(handleMessage := method (m: Message);
      begin
        mTimerView.Text := m.Data.String['text'];
        if m.Data.String['STATE_LOSE'] <> nil then
        begin
          // mButtonRestart.Visibility := View.VISIBLE;
          mButtonRetry.Visibility := View.VISIBLE;
          mTimerView.Visibility := View.INVISIBLE;
          mTextView.Visibility := View.VISIBLE;
          Log.d(TAG, 'the total was ' + mHitTotal);
          if mHitTotal >= mSuccessThreshold then
            mTextView.Text := R.string.winText
          else
            mTextView.Text := 'Sorry, You Lose! You got ' + mHitTotal + '. You need 50 to win.';
          mTimerView.Text := ctx.String[R.string.timer];
          mTextView.Height := 20
        end
      end)))
  end;
  Focusable := true;
  //  make sure we get key events
  Log.d(TAG, '@@@ done creating view!')
end;

/// <summary>
/// Pass in a reference to the timer view widget so we can update it from here.
/// </summary>
/// <param name="tv"></param>
method JetBoyView.setTimerView(tv: TextView);
begin
  mTimerView := tv
end;

/// <summary>
/// Standard window-focus override. Notice focus lost so we can pause on
/// focus lost. e.g. user switches to take a call.
/// </summary>
/// <param name="hasWindowFocus"></param>
method JetBoyView.onWindowFocusChanged(hasWindowFocus: Boolean);
begin
  if not hasWindowFocus then
    if thread <> nil then
      thread.pause
end;

/// <summary>
/// Fetches the animation thread corresponding to this LunarView.
/// </summary>
/// <returns>the animation thread</returns>
method JetBoyView.getThread: JetBoyThread;
begin
  exit thread
end;

method JetBoyView.surfaceCreated(arg0: SurfaceHolder);
begin
  //  start the thread here 
  //NOTE: mGameIsRunning will remain true if the user
  //switches away from and back to the app
  if not mGameIsRunning then
  begin
    thread.start;
    mGameIsRunning := true
  end
  else
    thread.unPause;
end;

/// <summary>
/// Callback invoked when the surface dimensions change.
/// </summary>
/// <param name="holder"></param>
/// <param name="format"></param>
/// <param name="width"></param>
/// <param name="height"></param>
method JetBoyView.surfaceChanged(holder: SurfaceHolder; format, width, height: Integer);
begin
  thread.setSurfaceSize(width, height)
end;

method JetBoyView.surfaceDestroyed(arg0: SurfaceHolder);
begin
  //NOTE: thread management code change
  //We no longer try and encourage the thread to exit here
  //Instead it gets paused and resumed
end;

/// <summary>
/// A reference to the button to start game over.
/// </summary>
/// <param name="_buttonRetry"></param>
method JetBoyView.SetButtonView(_buttonRetry: Button);
begin
  mButtonRetry := _buttonRetry
end;

/// <summary>
/// we reuse the help screen from the end game screen.
/// </summary>
/// <param name="textView"></param>
method JetBoyView.SetTextView(textView: TextView);
begin
  mTextView := textView
end;

end.