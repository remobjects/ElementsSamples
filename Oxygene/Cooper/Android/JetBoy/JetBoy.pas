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

uses
  android.app,
  android.os,
  android.util,
  android.view,
  android.widget;

//  Android JET demonstration code:
//  See the JetBoyView.java file for examples on the use of the JetPlayer class.

type
  JetBoy = public class(Activity, View.OnClickListener)
  private
    // A handle to the thread that's actually running the animation.
    var mJetBoyThread: JetBoyThread;
    // A handle to the View in which the game is running.
    var mJetBoyView: JetBoyView;
    //  the play start button
    var mButton: Button;
    //  used to hit retry
    var mButtonRetry: Button;
    //  the window for instructions and such
    var mTextView: TextView;
    //  game window timer
    var mTimerView: TextView;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onPause; override;
    method onClick(v: View);
    method onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean; override;
    method onKeyUp(keyCode: Integer; msg: KeyEvent): Boolean; override;
    method onTouchEvent(evt: MotionEvent): Boolean; override;
  end;

implementation

/// <summary>
/// Required method from parent class
/// </summary>
/// <param name="savedInstanceState">The previous instance of this app</param>
method JetBoy.onCreate(savedInstanceState: Bundle);
begin
  inherited onCreate(savedInstanceState);
  ContentView := R.layout.main;
  //  get handles to the JetView from XML and the JET thread.
  mJetBoyView := JetBoyView(findViewById(R.id.JetBoyView));
  mJetBoyThread := mJetBoyView.getThread;
  //  look up the happy shiny button
  mButton := Button(findViewById(R.id.Button01));
  mButton.OnClickListener := self;
  mButtonRetry := Button(findViewById(R.id.Button02));
  mButtonRetry.OnClickListener := self;
  //  set up handles for instruction text and game timer text
  mTextView := TextView(findViewById(R.id.text));
  mTimerView := TextView(findViewById(R.id.timer));
  mJetBoyView.setTimerView(mTimerView);
  mJetBoyView.SetButtonView(mButtonRetry);
  mJetBoyView.SetTextView(mTextView);
  Log.w(&Class.Name, 'onCreate');
end;

/// <summary>
/// Called when activity is exiting
/// </summary>
method JetBoy.onPause;
begin
  inherited;
  mJetBoyThread.pause
end;

/// <summary>
/// Handles component interaction
/// </summary>
/// <param name="v">The object which has been clicked</param>
method JetBoy.onClick(v: View);
begin
  //  this is the first screen
  if mJetBoyThread.getGameState = JetBoyThread.STATE_START then
  begin
    mButton.Text := 'PLAY!';
    mTextView.Visibility := View.VISIBLE;
    mTextView.Text := R.string.helpText;
    mJetBoyThread.setGameState(JetBoyThread.STATE_PLAY)
  end
  else
  if mJetBoyThread.getGameState = JetBoyThread.STATE_PLAY then
  begin
    mButton.Visibility := View.INVISIBLE;
    mTextView.Visibility := View.INVISIBLE;
    mTimerView.Visibility := View.VISIBLE;
    mJetBoyThread.setGameState(JetBoyThread.STATE_RUNNING)
  end
  else
  if mButtonRetry.&equals(v) then
  begin
    mTextView.Text := R.string.helpText;
    mButton.Text := 'PLAY!';
    mButtonRetry.Visibility := View.INVISIBLE;
    //  mButtonRestart.Visibility := View.INVISIBLE;
    mTextView.Visibility := View.VISIBLE;
    mButton.Text := 'PLAY!';
    mButton.Visibility := View.VISIBLE;
    mJetBoyThread.setGameState(JetBoyThread.STATE_PLAY)
  end
  else
  begin
    Log.d('JB VIEW', 'unknown click ' + v.Id);
    Log.d('JB VIEW', 'state is  ' + mJetBoyThread.mState)
  end
end;

/// <summary>
/// Standard override to get key-press events.
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method JetBoy.onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  //NOTE: the original demo code did not check for the volume keys so they
  //were ignored during gameplay and the media volume could therefore not
  //be adjusted
  if keyCode in [KeyEvent.KEYCODE_BACK,
                 KeyEvent.KEYCODE_VOLUME_DOWN,
                 KeyEvent.KEYCODE_VOLUME_UP,
                 KeyEvent.KEYCODE_VOLUME_MUTE] then
    exit inherited onKeyDown(keyCode, msg)
  else
    exit mJetBoyThread.doKeyDown(keyCode, msg)
end;

/// <summary>
/// Standard override for key-up.
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method JetBoy.onKeyUp(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  if keyCode = KeyEvent.KEYCODE_BACK then
    exit inherited onKeyUp(keyCode, msg)
  else
    exit mJetBoyThread.doKeyUp(keyCode, msg)
end;

method JetBoy.onTouchEvent(evt: MotionEvent): Boolean;
begin
  var action := evt.ActionMasked;
  if action in [MotionEvent.ACTION_DOWN, MotionEvent.ACTION_UP] then
  begin
    var key: Integer := KeyEvent.KEYCODE_DPAD_CENTER;
    if action = MotionEvent.ACTION_DOWN then
      onKeyDown(key, new KeyEvent(KeyEvent.ACTION_DOWN, key))
    else //MotionEvent.ACTION_UP
      onKeyUp(key, new KeyEvent(KeyEvent.ACTION_UP, key))
  end;
  exit true
end;

end.
