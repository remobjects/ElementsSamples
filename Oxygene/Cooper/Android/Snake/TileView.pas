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
  android.content,
  android.content.res,
  android.graphics,
  android.graphics.drawable,
  android.os,
  android.util,
  android.view, 
  org.w3c.dom;

type
  /// <summary>
  /// TileView: a View-variant designed for handling arrays of "icons" or other
  /// drawables.
  /// </summary>
  TileView = public class(View)
  protected
    // Parameters controlling the size of the tiles and their range within view.
    // Width/Height are in pixels, and Drawables will be scaled to fit to these
    // dimensions. X/Y Tile Counts are the number of tiles that will be drawn.
    class var mTileSize:   Integer;
    class var mXTileCount: Integer;
    class var mYTileCount: Integer;
  private
    class var mXOffset: Integer;
    class var mYOffset: Integer;
    // A hash that maps integer handles specified by the subclasser to the
    // drawable that will be used for that reference
    var mTileArray: array of Bitmap;
    // A two-dimensional array of integers in which the number represents the
    // index of the tile that should be drawn at that locations
    var mTileGrid: array of array of Integer;
    var mPaint: Paint := new Paint(); readonly;
  public
    constructor(context: Context; attrs: AttributeSet; defStyle: Integer);
    constructor(context: Context; attrs: AttributeSet);
    method resetTiles(tilecount: Integer);
  protected
    method onSizeChanged(w: Integer; h: Integer; oldw: Integer; oldh: Integer); override;
  public
    method loadTile(key: Integer; tile: Drawable);
    method clearTiles();
    method setTile(tileindex: Integer; x: Integer; y: Integer);
    method onDraw(canvas: Canvas); override;
  end;

implementation

constructor TileView(context: Context; attrs: AttributeSet; defStyle: Integer);
begin
  inherited constructor (context, attrs, defStyle);
  var a: TypedArray := context.obtainStyledAttributes(attrs, R.styleable.TileView);
  mTileSize := a.Int[R.styleable.TileView_tileSize, 12];
  a.recycle
end;

constructor TileView(context: Context; attrs: AttributeSet);
begin
  inherited constructor (context, attrs);
  var a: TypedArray := context.obtainStyledAttributes(attrs, R.styleable.TileView);
  mTileSize := a.Int[R.styleable.TileView_tileSize, 12];
  a.recycle
end;

/// <summary>
/// Rests the internal array of Bitmaps used for drawing tiles, and
/// sets the maximum index of tiles to be inserted
/// </summary>
/// <param name="tilecount"></param>
method TileView.resetTiles(tilecount: Integer);
begin
  mTileArray := new Bitmap[tilecount]
end;

method TileView.onSizeChanged(w: Integer; h: Integer; oldw: Integer; oldh: Integer);
begin
  mXTileCount := Integer(Math.floor(w div mTileSize));
  mYTileCount := Integer(Math.floor(h div mTileSize));
  mXOffset := (w - mTileSize * mXTileCount) div 2;
  mYOffset := (h - mTileSize * mYTileCount) div 2;
  mTileGrid := new array of Integer[mXTileCount];
  for i: Integer := 0 to pred(mTileGrid.length) do
    mTileGrid[i] := new Integer[mYTileCount];
  clearTiles
end;

/// <summary>
/// Function to set the specified Drawable as the tile for a particular
/// integer key.
/// </summary>
/// <param name="key"></param>
/// <param name="tile"></param>
method TileView.loadTile(key: Integer; tile: Drawable);
begin
  var lBitmap: Bitmap := Bitmap.createBitmap(mTileSize, mTileSize, Bitmap.Config.ARGB_8888);
  var canvas: Canvas := new Canvas(lBitmap);
  tile.setBounds(0, 0, mTileSize, mTileSize);
  tile.draw(canvas);
  mTileArray[key] := lBitmap
end;

/// <summary>
/// Resets all tiles to 0 (empty)
/// </summary>
method TileView.clearTiles();
begin
  for x: Integer := 0 to pred(mXTileCount) do
    for y: Integer := 0 to pred(mYTileCount) do
      setTile(0, x, y);
end;

/// <summary>
/// Used to indicate that a particular tile (set with loadTile and referenced
/// by an integer) should be drawn at the given x/y coordinates during the
/// next invalidate/draw cycle.
/// </summary>
/// <param name="tileindex"></param>
/// <param name="x"></param>
/// <param name="y"></param>
method TileView.setTile(tileindex: Integer; x: Integer; y: Integer);
begin
  mTileGrid[x][y] := tileindex
end;

method TileView.onDraw(canvas: Canvas);
begin
  inherited onDraw(canvas);
  for x: Integer := 0 to pred(mXTileCount) do
    for y: Integer := 0 to pred(mYTileCount) do
          if mTileGrid[x][y] > 0 then
            canvas.drawBitmap(mTileArray[mTileGrid[x][y]],
              mXOffset + x * mTileSize,
              mYOffset + y * mTileSize,
              mPaint)
end;

end.