namespace com.example.android.livecubes.cube1;

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
  android.graphics,
  android.os,
  android.service.wallpaper, 
  android.view;

type
  /// <summary>
  /// This animated wallpaper draws a rotating wireframe cube.
  /// </summary>
  CubeWallpaper1 = public class(WallpaperService)
  public
    method onCreateEngine: WallpaperService.Engine; override;
  end;

  CubeEngine nested in CubeWallpaper1 = public class(WallpaperService.Engine)
  private
    var mHandler: Handler := new Handler;
    var mOffset: Single;
    var mPaint: Paint;
    var mTouchX: Single := -1;
    var mTouchY: Single := -1;
    var mStartTime: Int64;
    var mCenterX: Single;
    var mCenterY: Single;
    var mDrawCube: Runnable;
    var mVisible: Boolean;
  public
    constructor (wallpaperService: CubeWallpaper1);
    method onCreate(holder: SurfaceHolder); override;
    method onDestroy; override;
    method onVisibilityChanged(visible: Boolean); override;
    method onSurfaceCreated(holder: SurfaceHolder); override;
    method onSurfaceDestroyed(holder: SurfaceHolder); override;
    method onSurfaceChanged(holder: SurfaceHolder; format, width, height: Integer); override;
    method onOffsetsChanged(xOffset, yOffset, xOffsetStep, yOffsetStep: Single; xPixelOffset, yPixelOffset: Integer); override;
    method onTouchEvent(&event: MotionEvent); override;
    method drawFrame;
    method drawCube(c: Canvas);
    method drawLine(c: Canvas; x1, y1, z1, x2, y2, z2: Integer);
    method drawTouchPoint(c: Canvas);
  end;

implementation

constructor CubeWallpaper1.CubeEngine(wallpaperService: CubeWallpaper1);
begin
  inherited constructor(wallpaperService);
  mDrawCube := new interface Runnable(run := method begin drawFrame end);
  //  Create a Paint to draw the lines for our cube
  mPaint := new Paint;
  mPaint.Color := $ffffffff as Int64;
  mPaint.AntiAlias := true;
  mPaint.StrokeWidth := 2;
  mPaint.StrokeCap := Paint.Cap.ROUND;
  mPaint.Style := Paint.Style.STROKE;
  mStartTime := SystemClock.elapsedRealtime;
end;

method CubeWallpaper1.onCreateEngine: WallpaperService.Engine;
begin
  exit new CubeEngine(self)
end;

method CubeWallpaper1.CubeEngine.onCreate(holder: SurfaceHolder);
begin
  inherited onCreate(holder);
  //  By default we don't get touch events, so enable them.
  TouchEventsEnabled := true;
end;

method CubeWallpaper1.CubeEngine.onDestroy;
begin
  inherited onDestroy();
  mHandler.removeCallbacks(mDrawCube);
end;

method CubeWallpaper1.CubeEngine.onVisibilityChanged(visible: Boolean);
begin
  mVisible := visible;
  if visible then
    drawFrame
  else
    mHandler.removeCallbacks(mDrawCube)
end;

method CubeWallpaper1.CubeEngine.onSurfaceCreated(holder: SurfaceHolder);
begin
  inherited
end;

method CubeWallpaper1.CubeEngine.onSurfaceDestroyed(holder: SurfaceHolder);
begin
  inherited onSurfaceDestroyed(holder);
  mVisible := false;
  mHandler.removeCallbacks(mDrawCube);
end;

method CubeWallpaper1.CubeEngine.onSurfaceChanged(holder: SurfaceHolder; format: Integer; width: Integer; height: Integer);
begin
  inherited onSurfaceChanged(holder, format, width, height);
  // store the center of the surface, so we can draw the cube in the right spot
  mCenterX := width / 2.0;
  mCenterY := height / 2.0;
  drawFrame;
end;

method CubeWallpaper1.CubeEngine.onOffsetsChanged(xOffset: Single; yOffset: Single; xOffsetStep: Single; yOffsetStep: Single; xPixelOffset: Integer; yPixelOffset: Integer);
begin
  mOffset := xOffset;
  drawFrame;
end;

/// <summary>
/// Store the position of the touch event so we can use it for drawing later
/// </summary>
/// <param name="event"></param>
method CubeWallpaper1.CubeEngine.onTouchEvent(&event: MotionEvent);
begin
  if &event.Action = MotionEvent.ACTION_MOVE then
  begin
    mTouchX := &event.X;
    mTouchY := &event.Y
  end
  else
  begin
    mTouchX := - 1;
    mTouchY := - 1
  end;
  inherited onTouchEvent(&event);
end;

/// <summary>
/// Draw one frame of the animation. This method gets called repeatedly
/// by posting a delayed Runnable. You can do any drawing you want in
/// here. This example draws a wireframe cube.
/// </summary>
method CubeWallpaper1.CubeEngine.drawFrame;
begin
  var holder: SurfaceHolder := SurfaceHolder;
  var c: Canvas := nil;
  try
    c := holder.lockCanvas;
    if c <> nil then
    begin
      //  draw something
      drawCube(c);
      drawTouchPoint(c)
    end;
  finally
    if c <> nil then
      holder.unlockCanvasAndPost(c);
  end;
  //  Reschedule the next redraw
  mHandler.removeCallbacks(mDrawCube);
  if mVisible then
    mHandler.postDelayed(mDrawCube, 1000 div 25)
end;

/// <summary>
/// Draw a wireframe cube by drawing 12 3 dimensional lines between
/// adjacent corners of the cube
/// </summary>
/// <param name="c"></param>
method CubeWallpaper1.CubeEngine.drawCube(c: Canvas);
begin
  c.save;
  c.translate(mCenterX, mCenterY);
  c.drawColor($ff000000 as Int64);
  drawLine(c, -400, -400, -400,  400, -400, -400);
  drawLine(c,  400, -400, -400,  400,  400, -400);
  drawLine(c,  400,  400, -400, -400,  400, -400);
  drawLine(c, -400,  400, -400, -400, -400, -400);
  drawLine(c, -400, -400,  400,  400, -400,  400);
  drawLine(c,  400, -400,  400,  400,  400,  400);
  drawLine(c,  400,  400,  400, -400,  400,  400);
  drawLine(c, -400,  400,  400, -400, -400,  400);
  drawLine(c, -400, -400,  400, -400, -400, -400);
  drawLine(c,  400, -400,  400,  400, -400, -400);
  drawLine(c,  400,  400,  400,  400,  400, -400);
  drawLine(c, -400,  400,  400, -400,  400, -400);
  c.restore
end;

/// <summary>
/// Draw a 3 dimensional line on to the screen
/// </summary>
/// <param name="c"></param>
/// <param name="x1"></param>
/// <param name="y1"></param>
/// <param name="z1"></param>
/// <param name="x2"></param>
/// <param name="y2"></param>
/// <param name="z2"></param>
method CubeWallpaper1.CubeEngine.drawLine(c: Canvas; x1: Integer; y1: Integer; z1: Integer; x2: Integer; y2: Integer; z2: Integer);
begin
  var now: Int64 := SystemClock.elapsedRealtime;
  var xrot: Single := Single(now - mStartTime) div 1000;
  var yrot: Single := (0.5 - mOffset) * 2.0;
  
  //  3D transformations
  
  //  rotation around X-axis
  var newy1: Single := (Math.sin(xrot) * z1) + (Math.cos(xrot) * y1);
  var newy2: Single := (Math.sin(xrot) * z2) + (Math.cos(xrot) * y2);
  var newz1: Single := (Math.cos(xrot) * z1) - (Math.sin(xrot) * y1);
  var newz2: Single := (Math.cos(xrot) * z2) - (Math.sin(xrot) * y2);
  
  //  rotation around Y-axis
  var newx1: Single := (Math.sin(yrot) * newz1) + (Math.cos(yrot) * x1);
  var newx2: Single := (Math.sin(yrot) * newz2) + (Math.cos(yrot) * x2);
  newz1 := (Math.cos(yrot) * newz1) - (Math.sin(yrot) * x1);
  newz2 := (Math.cos(yrot) * newz2) - (Math.sin(yrot) * x2);
 
  //  3D-to-2D projection
  var startX: Single := newx1 / (4 - (newz1 / 400.0));
  var startY: Single := newy1 / (4 - (newz1 / 400.0));
  var stopX:  Single := newx2 / (4 - (newz2 / 400.0));
  var stopY:  Single := newy2 / (4 - (newz2 / 400.0));
  c.drawLine(startX, startY, stopX, stopY, mPaint);
end;

/// <summary>
/// Draw a circle around the current touch point, if any.
/// </summary>
/// <param name="c"></param>
method CubeWallpaper1.CubeEngine.drawTouchPoint(c: Canvas);
begin
  if (mTouchX >= 0) and (mTouchY >= 0) then
    c.drawCircle(mTouchX, mTouchY, 80, mPaint)
end;

end.