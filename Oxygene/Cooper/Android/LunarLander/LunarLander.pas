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
  android.app,
  android.os,
  android.util,
  android.view,
  android.widget;

type
  /// <summary>
  /// This is a simple LunarLander activity that houses a single LunarView. It
  /// demonstrates...
  /// 
  ///  - animating by calling invalidate() from draw()
  ///  - loading and drawing resources
  ///  - handling onPause() in an animation
  /// </summary>
  LunarLander = public class(Activity)
  private
    const MENU_EASY = 1;
    const MENU_HARD = 2;
    const MENU_MEDIUM = 3;
    const MENU_PAUSE = 4;
    const MENU_RESUME = 5;
    const MENU_START = 6;
    const MENU_STOP = 7;
    // A handle to the thread that's actually running the animation.
    var mLunarThread: LunarThread;
    // A handle to the View in which the game is running.
    var mLunarView: LunarView;    
  public
    method onCreateOptionsMenu(mnu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
  protected
    method onCreate(savedInstanceState: Bundle); override;
    method onPause; override;
    method onSaveInstanceState(outState: Bundle); override;
  end;

implementation

/// <summary>
/// Invoked when the Activity is created.
/// </summary>
/// <param name="savedInstanceState">a Bundle containing state saved from a previous execution, or nil if this is a new execution</param>
method LunarLander.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  //  tell system to use the layout defined in our XML file
  ContentView := R.layout.lunar_layout;
  //  get handles to the LunarView from XML, and its LunarThread
  mLunarView := LunarView(findViewById(R.id.lunar));
  mLunarThread := mLunarView.getThread;
  //  give the LunarView a handle to the TextView used for messages
  mLunarView.setTextView(TextView(findViewById(R.id.text)));
  if savedInstanceState = nil then
  begin
    //  we were just launched: set up a new game
    mLunarThread.setState(LunarThread.STATE_READY);
    Log.w(&Class.Name, 'SIS is null')
  end
  else
  begin
    //  we are being restored: resume a previous game
    mLunarThread.restoreState(savedInstanceState);
    Log.w(&Class.Name, 'SIS is nonnull')
  end
end;

/// <summary>
/// Invoked when the Activity loses user focus.
/// </summary>
method LunarLander.onPause;
begin
  inherited;
  Log.w(&Class.Name, 'onPause');
  mLunarThread.pause
end;

/// <summary>
/// Notification that something is about to happen, to give the Activity a
/// chance to save state.
/// </summary>
/// <param name="outState">a Bundle into which this Activity should save its state</param>
method LunarLander.onSaveInstanceState(outState: Bundle);
begin
  //  just have the View's thread save its state into our Bundle
  inherited;
  mLunarThread.saveState(outState);
  Log.w(&Class.Name, 'SIS called')
end;

/// <summary>
/// Invoked during init to give the Activity a chance to set up its Menu.
/// </summary>
/// <param name="menu">the Menu to which entries may be added</param>
/// <returns>true</returns>
method LunarLander.onCreateOptionsMenu(mnu: Menu): Boolean;
begin
  inherited;
  mnu.&add(0, MENU_START, 0, R.string.menu_start);
  mnu.&add(0, MENU_STOP, 0, R.string.menu_stop);
  mnu.&add(0, MENU_PAUSE, 0, R.string.menu_pause);
  mnu.&add(0, MENU_RESUME, 0, R.string.menu_resume);
  mnu.&add(0, MENU_EASY, 0, R.string.menu_easy);
  mnu.&add(0, MENU_MEDIUM, 0, R.string.menu_medium);
  mnu.&add(0, MENU_HARD, 0, R.string.menu_hard);
  exit true
end;

/// <summary>
/// Invoked when the user selects an item from the Menu.
/// </summary>
/// <param name="item">the Menu entry which was selected</param>
/// <returns>true if the Menu item was legit (and we consumed it), false otherwise</returns>
method LunarLander.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  case item.ItemId of
    MENU_START: mLunarThread.doStart;
    MENU_STOP: mLunarThread.setState(LunarThread.STATE_LOSE, Text[R.string.message_stopped]);
    MENU_PAUSE: mLunarThread.pause;
    MENU_RESUME: mLunarThread.unpause;
    MENU_EASY: mLunarThread.setDifficulty(LunarThread.DIFFICULTY_EASY);
    MENU_MEDIUM: mLunarThread.setDifficulty(LunarThread.DIFFICULTY_MEDIUM);
    MENU_HARD: mLunarThread.setDifficulty(LunarThread.DIFFICULTY_HARD);
    else exit false;
  end;
  exit true
end;

end.