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
  java.beans,
  java.util,
  android.content,
  android.content.res,
  android.os, 
  android.util, 
  android.view,
  android.widget, 
  javax.crypto;

type
  /// <summary>
  /// SnakeView: implementation of a simple game of Snake
  /// </summary>
  SnakeView = public class(TileView)
  private
    const TAG = 'SnakeView';
    // Current mode of application: READY to run, RUNNING, or you have already
    // lost. static final ints are used instead of an enum for performance
    // reasons.
    var mMode: Integer := READY;
    // Current direction the snake is headed.
    var mDirection: Integer := NORTH;
    var mNextDirection: Integer := NORTH;
    const NORTH = 1;
    const SOUTH = 2;
    const EAST = 3;
    const WEST = 4;
    // Labels for the drawables that will be loaded into the TileView class
    const RED_STAR = 1;
    const YELLOW_STAR = 2;
    const GREEN_STAR = 3;
    // Gesture detector
    var mGestureDetector: GestureDetector;
    // mScore: used to track the number of apples captured mMoveDelay: number of
    // milliseconds between snake movements. This will decrease as apples are
    // captured.
    var mScore: Int64 := 0;
    var mMoveDelay: Int64 := 600;
    // mLastMove: tracks the absolute time when the snake last moved, and is used
    // to determine if a move should be made based on mMoveDelay.
    var mLastMove: Int64;
    // mStatusText: text shows to the user in some run states
    var mStatusText: TextView;
    // mSnakeTrail: a list of Coordinates that make up the snake's body
    // mAppleList: the secret location of the juicy apples the snake craves.
    var mSnakeTrail: ArrayList<Coordinate> := new ArrayList<Coordinate>();
    var mAppleList: ArrayList<Coordinate> := new ArrayList<Coordinate>();
    var mRedrawHandler: RefreshHandler := new RefreshHandler(self);
    // Everyone needs a little randomness in their life
    class var RNG: Random := new Random; readonly;
    method initSnakeView;
    method initNewGame;
    method coordArrayListToArray(cvec: ArrayList<Coordinate>): array of Integer;
    method coordArrayToArrayList(rawArray: array of Integer): ArrayList<Coordinate>;
    method addRandomApple;
    method updateWalls;
    method updateApples;
    method updateSnake;
  public
    const PAUSE = 0;
    const READY = 1;
    const RUNNING = 2;
    const LOSE = 3;
    constructor (ctx: Context; attrs: AttributeSet);
    constructor (ctx: Context; attrs: AttributeSet; defStyle: Integer);
    method saveState: Bundle;
    method restoreState(icicle: Bundle);
    method onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean; override;
    method onTouchEvent(&event: MotionEvent): Boolean; override;
    method setTextView(newView: TextView);
    method setMode(newMode: Integer);
    method update;
  end;

  /// <summary>
  /// Simple class containing two integer values and a comparison function.
  /// There's probably something I should use instead, but this was quick and
  /// easy to build.
  /// </summary>
  Coordinate nested in SnakeView = private class
  public
    x, y: Integer;
    constructor(newX, newY: Integer);
    method &equals(other: Coordinate): Boolean;
    method toString: String; override;
  end;
     
  /// <summary>
  /// Create a simple handler that we can use to cause animation to happen.  We
  /// set ourselves as a target and we can use the sleep()
  /// function to cause an update/invalidate to occur at a later date.
  /// </summary>
  RefreshHandler nested in SnakeView = public class(Handler)
  private
    mSnakeView: SnakeView;
  public
    constructor (aSnakeView: SnakeView);
    method handleMessage(msg: Message); override;
    method sleep(delayMillis: Int64);
  end;

implementation

/// <summary>
/// Constructs a SnakeView based on inflation from XML
/// </summary>
/// <param name="ctx"></param>
/// <param name="attrs"></param>
constructor SnakeView(ctx: Context; attrs: AttributeSet);
begin
  inherited;
  initSnakeView;
end;

constructor SnakeView(ctx: Context; attrs: AttributeSet; defStyle: Integer);
begin
  inherited;
  initSnakeView;
end;

method SnakeView.initSnakeView;
begin
  Focusable := true;
  var res: Resources := Context.Resources;
  resetTiles(4);
  loadTile(RED_STAR, res.Drawable[R.drawable.redstar]);
  loadTile(YELLOW_STAR, res.Drawable[R.drawable.yellowstar]);
  loadTile(GREEN_STAR, res.Drawable[R.drawable.greenstar]);
  // Set up gesture detector
  mGestureDetector := new GestureDetector(Context, new SnakeGestureListener(self));
end;

method SnakeView.initNewGame;
begin
  mSnakeTrail.clear;
  mAppleList.clear;
  //  For now we're just going to load up a short default eastbound snake
  //  that's just turned north
  mSnakeTrail.&add(new Coordinate(7, 7));
  mSnakeTrail.&add(new Coordinate(6, 7));
  mSnakeTrail.&add(new Coordinate(5, 7));
  mSnakeTrail.&add(new Coordinate(4, 7));
  mSnakeTrail.&add(new Coordinate(3, 7));
  mSnakeTrail.&add(new Coordinate(2, 7));
  mNextDirection := NORTH;
  //  Two apples to start with
  addRandomApple;
  addRandomApple;
  mMoveDelay := 600;
  mScore := 0;
end;

/// <summary>
/// Given a ArrayList of coordinates, we need to flatten them into an array of
/// ints before we can stuff them into a map for flattening and storage.
/// </summary>
/// <param name="cvec">a ArrayList of Coordinate objects</param>
/// <returns>a simple array containing the x/y values of the coordinates as [x1,y1,x2,y2,x3,y3...]</returns>
method SnakeView.coordArrayListToArray(cvec: ArrayList<Coordinate>): array of Integer;
begin
  var count: Integer := cvec.size;
  var rawArray: array of Integer := new Integer[count * 2];
  for &index: Integer := 0 to pred(count) do
    begin
      var c: Coordinate := cvec.get(&index);
      rawArray[(2 * &index)] := c.x;
      rawArray[((2 * &index) + 1)] := c.y;
    end;
  exit rawArray;
end;

/// <summary>
/// Given a flattened array of ordinate pairs, we reconstitute them into a
/// ArrayList of Coordinate objects
/// </summary>
/// <param name="rawArray">[x1,y1,x2,y2,...]</param>
/// <returns>a ArrayList of Coordinates</returns>
method SnakeView.coordArrayToArrayList(rawArray: array of Integer): ArrayList<Coordinate>;
begin
  var coordArrayList: ArrayList<Coordinate> := new ArrayList<Coordinate>();
  var coordCount: Integer := rawArray.length;
  var &index: Integer := 0;
  while &index < coordCount do
  begin
    var c: Coordinate := new Coordinate(rawArray[&index], rawArray[&index + 1]);
    coordArrayList.&add(c);
    inc(&index, 2)
  end;
  exit coordArrayList;
end;

/// <summary>
/// Selects a random location within the garden that is not currently covered
/// by the snake. Currently _could_ go into an infinite loop if the snake
/// currently fills the garden, but we'll leave discovery of this prize to a
/// truly excellent snake-player.
/// </summary>
method SnakeView.addRandomApple;
begin
  var newCoord: Coordinate := nil;
  var found: Boolean := false;
  while not found do
  begin
    //  Choose a new location for our apple
    var newX: Integer := 1 + RNG.nextInt(mXTileCount - 2);
    var newY: Integer := 1 + RNG.nextInt(mYTileCount - 2);
    newCoord := new Coordinate(newX, newY);
    //  Make sure it's not already under the snake
    var collision: Boolean := false;
    var snakelength: Integer := mSnakeTrail.size;
    for &index: Integer := 0 to pred(snakelength) do
      if mSnakeTrail.get(&index).&equals(newCoord) then
        collision := true;
    //  if we're here and there's been no collision, then we have
    //  a good location for an apple. Otherwise, we'll circle back
    //  and try again
    found := not collision
  end;
  if newCoord = nil then
    Log.e(TAG, 'Somehow ended up with a null newCoord!');
  mAppleList.&add(newCoord);
end;

/// <summary>
/// Draws some walls.
/// </summary>
method SnakeView.updateWalls;
begin
  for x: Integer := 0 to pred(mXTileCount) do
  begin
    setTile(GREEN_STAR, x, 0);
    setTile(GREEN_STAR, x, mYTileCount - 1);
  end;
  for y: Integer := 0 to pred(mYTileCount) do
  begin
    setTile(GREEN_STAR, 0, y);
    setTile(GREEN_STAR, mXTileCount - 1, y);
  end;
end;

/// <summary>
/// Draws some apples.
/// </summary>
method SnakeView.updateApples;
begin
  for c: Coordinate in mAppleList do
    setTile(YELLOW_STAR, c.x, c.y)
end;

/// <summary>
/// Figure out which way the snake is going, see if he's run into anything (the
/// walls, himself, or an apple). If he's not going to die, we then add to the
/// front and subtract from the rear in order to simulate motion. If we want to
/// grow him, we don't subtract from the rear.
/// </summary>
method SnakeView.updateSnake;
begin
  var growSnake: Boolean := false;
  //  grab the snake by the head
  var head: Coordinate := mSnakeTrail.get(0);
  var newHead: Coordinate := new Coordinate(1, 1);
  mDirection := mNextDirection;
  case mDirection of
    EAST: newHead := new Coordinate(head.x + 1, head.y);
    WEST: newHead := new Coordinate(head.x - 1, head.y);
    NORTH: newHead := new Coordinate(head.x, head.y - 1);
    SOUTH: newHead := new Coordinate(head.x, head.y + 1);
  end;
  // Collision detection
  // For now we have a 1-square wall around the entire arena
  if (newHead.x < 1) or (newHead.y < 1) or (newHead.x > mXTileCount - 2)
          or (newHead.y > mYTileCount - 2) then
  begin
    setMode(LOSE);
    exit
  end;
  //  Look for collisions with itself
  var snakelength: Integer := mSnakeTrail.size;
  for snakeindex: Integer := 0 to pred(snakelength) do
  begin
    var c: Coordinate := mSnakeTrail.get(snakeindex);
    if c.&equals(newHead) then
    begin
      setMode(LOSE);
      exit
    end;
  end;
  //  Look for apples
  var applecount: Integer := mAppleList.size();
  for appleindex: Integer := 0 to pred(applecount) do
  begin
    var c: Coordinate := mAppleList.get(appleindex);
    if c.&equals(newHead) then
    begin
      mAppleList.&remove(c);
      addRandomApple;
      inc(mScore);
      mMoveDelay := Int64(mMoveDelay * 0.9);
      growSnake := true
    end;
  end;
  //  push a new head onto the ArrayList and pull off the tail
  mSnakeTrail.&add(0, newHead);
  //  except if we want the snake to grow
  if not growSnake then
    mSnakeTrail.&remove(mSnakeTrail.size - 1);
  var &index: Integer := 0;
  for each c: Coordinate in mSnakeTrail do
  begin
    if &index = 0 then
      setTile(YELLOW_STAR, c.x, c.y)
    else
      setTile(RED_STAR, c.x, c.y);
    inc(&index)
  end;
end;

method SnakeView.saveState: Bundle;
begin
  var map: Bundle := new Bundle;
  map.putIntArray('mAppleList', coordArrayListToArray(mAppleList));
  map.putInt('mDirection', Integer.valueOf(mDirection));
  map.putInt('mNextDirection', Integer.valueOf(mNextDirection));
  map.putLong('mMoveDelay', Long.valueOf(mMoveDelay));
  map.putLong('mScore', Long.valueOf(mScore));
  map.putIntArray('mSnakeTrail', coordArrayListToArray(mSnakeTrail));
  exit map;
end;

/// <summary>
/// Restore game state if our process is being relaunched
/// </summary>
/// <param name="icicle">a Bundle containing the game state</param>
method SnakeView.restoreState(icicle: Bundle);
begin
  setMode(PAUSE);
  mAppleList := coordArrayToArrayList(icicle.getIntArray('mAppleList'));
  mDirection := icicle.Int['mDirection'];
  mNextDirection := icicle.Int['mNextDirection'];
  mMoveDelay := icicle.Long['mMoveDelay'];
  mScore := icicle.Long['mScore'];
  mSnakeTrail := coordArrayToArrayList(icicle.IntArray['mSnakeTrail']);
end;

/// <summary>
/// handles key events in the game. Update the direction our snake is traveling
/// based on the DPAD. Ignore events that would cause the snake to immediately
/// turn back on itself.
/// </summary>
/// <param name="keyCode"></param>
/// <param name="msg"></param>
/// <returns></returns>
method SnakeView.onKeyDown(keyCode: Integer; msg: KeyEvent): Boolean;
begin
  if keyCode = KeyEvent.KEYCODE_DPAD_UP then
  begin
    if mMode in [READY, LOSE] then
    begin
      // At the beginning of the game, or the end of a previous one,
      // we should start a new game.
      initNewGame;
      setMode(RUNNING);
      update;
      exit true
    end;
    if mMode = PAUSE then
    begin
      // If the game is merely paused, we should just continue where
      // we left off.
      setMode(RUNNING);
      update;
      exit true
    end;
    if mDirection <> SOUTH then
      mNextDirection := NORTH;
    exit true
  end;
  if keyCode = KeyEvent.KEYCODE_DPAD_DOWN then
  begin
    if mDirection <> NORTH then
      mNextDirection := SOUTH;
    exit true
  end;
  if keyCode = KeyEvent.KEYCODE_DPAD_LEFT then
  begin
    if mDirection <> EAST then
      mNextDirection := WEST;
    exit true
  end;
  if keyCode = KeyEvent.KEYCODE_DPAD_RIGHT then
  begin
    if mDirection <> WEST then
      mNextDirection := EAST;
    exit true
  end;
  exit inherited onKeyDown(keyCode, msg);
end;

/// <summary>
/// additional code to detect swipe gestures to move the snake
/// in the absence of a D-Pad
/// </summary>
/// <param name="event"></param>
/// <returns></returns>
method SnakeView.onTouchEvent(&event: MotionEvent): Boolean;
begin
  exit mGestureDetector.onTouchEvent(&event);
end;

/// <summary>
/// Sets the TextView that will be used to give information (such as "Game
/// Over" to the user.
/// </summary>
/// <param name="newView"></param>
method SnakeView.setTextView(newView: TextView);
begin
  mStatusText := newView;
end;

/// <summary>
/// Updates the current mode of the application (RUNNING or PAUSED or the like)
/// as well as sets the visibility of textview for notification
/// </summary>
/// <param name="newMode"></param>
method SnakeView.setMode(newMode: Integer);
begin
  var oldMode: Integer := mMode;
  mMode := newMode;
  if (newMode = RUNNING) and (oldMode <> RUNNING) then
  begin
    mStatusText.Visibility := View.INVISIBLE;
    update;
    exit
  end;
  var res: Resources := Context.Resources;
  var str: CharSequence := '';
  if newMode = PAUSE then
    str := res.Text[R.string.mode_pause];
  if newMode = READY then
    str := res.Text[R.string.mode_ready];
  if newMode = LOSE then
    str := res.String[R.string.mode_lose_prefix] + mScore + res.String[R.string.mode_lose_suffix];
  mStatusText.Text := str;
  mStatusText.Visibility := View.VISIBLE;
end;

/// <summary>
/// Handles the basic update loop, checking to see if we are in the running
/// state, determining if a move should be made, updating the snake's location.
/// </summary>
method SnakeView.update;
begin
  if mMode = RUNNING then
  begin
    var now: Int64 := System.currentTimeMillis;
    if now - mLastMove > mMoveDelay then
    begin
      clearTiles;
      updateWalls;
      updateSnake;
      updateApples;
      mLastMove := now
    end;
    mRedrawHandler.sleep(mMoveDelay)
  end;
end;

constructor SnakeView.Coordinate(newX: Integer; newY: Integer);
begin
  x := newX;
  y := newY
end;

method SnakeView.Coordinate.&equals(other: Coordinate): Boolean;
begin
  exit (x = other.x) and (y = other.y)
end;

method SnakeView.Coordinate.toString: String;
begin
  exit 'Coordinate: [' + x + ',' + y + ']'
end;

constructor SnakeView.RefreshHandler(aSnakeView: SnakeView);
begin
  inherited constructor;
  mSnakeView := aSnakeView;
end;

method SnakeView.RefreshHandler.handleMessage(msg: Message);
begin
  mSnakeView.update;
  mSnakeView.invalidate;
end;

method SnakeView.RefreshHandler.sleep(delayMillis: Int64);
begin
  removeMessages(0);
  sendMessageDelayed(obtainMessage(0), delayMillis)
end;

end.