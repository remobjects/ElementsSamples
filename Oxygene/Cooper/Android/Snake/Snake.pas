namespace com.example.android.snake;

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
  android.view,
  android.widget;

type
  /// <summary>
  /// Snake: a simple game that everyone can enjoy.
  /// 
  /// This is an implementation of the classic Game "Snake", in which you control a
  /// serpent roaming around the garden looking for apples. Be careful, though,
  /// because when you catch one, not only will you become longer, but you'll move
  /// faster. Running into yourself or the walls will end the game.
  /// </summary>
  Snake = public class(Activity)
  private
    var mSnakeView: SnakeView;
    const ICICLE_KEY = 'snake-view';    
  public
    method onCreate(savedInstanceState: Bundle); override;
  protected
    method onPause; override;
  public
    method onSaveInstanceState(outState: Bundle); override;
  end;

implementation

/// <summary>
/// Called when Activity is first created. Turns off the title bar, sets up
/// the content views, and fires up the SnakeView.
/// </summary>
/// <param name="savedInstanceState"></param>
method Snake.onCreate(savedInstanceState: Bundle);
begin
  inherited onCreate(savedInstanceState);
  ContentView := R.layout.snake_layout;
  mSnakeView := SnakeView(findViewById(R.id.snake));
  mSnakeView.setTextView(TextView(findViewById(R.id.text)));
  if (savedInstanceState = nil) then
    //  We were just launched -- set up a new game
    mSnakeView.setMode(SnakeView.READY)
  else
  begin
    //  We are being restored
    var map: Bundle := savedInstanceState.Bundle[ICICLE_KEY];
    if map <> nil then
      mSnakeView.restoreState(map)
    else
      mSnakeView.setMode(SnakeView.PAUSE)
  end
end;

method Snake.onPause;
begin
  inherited;
  //  Pause the game along with the activity
  mSnakeView.setMode(SnakeView.PAUSE)
end;

method Snake.onSaveInstanceState(outState: Bundle);
begin
  // Store the game state
  outState.putBundle(ICICLE_KEY, mSnakeView.saveState)
end;

end.
