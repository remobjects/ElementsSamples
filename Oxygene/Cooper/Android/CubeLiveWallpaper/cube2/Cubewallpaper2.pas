namespace com.example.android.livecubes.cube2;

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
  android.graphics,
  android.os,
  android.service.wallpaper, 
  android.view;

type
  /// <summary>
  /// This animated wallpaper draws a rotating wireframe shape. It is similar to
  /// example #1, but has a choice of 2 shapes, which are user selectable and
  /// defined in resources instead of in code.
  /// </summary>
  CubeWallpaper2 = public class(WallpaperService)
  public
    method onCreateEngine: WallpaperService.Engine; override;
  end;

  CubeEngine nested in CubeWallpaper2 = public class(WallpaperService.Engine,
    SharedPreferences.OnSharedPreferenceChangeListener)      
  private
    var mHandler: Handler := new Handler;
    var mWallpaperService: CubeWallpaper2;
    var mOriginalPoints: array of ThreeDPoint;
    var mRotatedPoints: array of ThreeDPoint;
    var mLines: array of ThreeDLine;
    var mPaint: Paint;
    var mOffset: Single;
    var mTouchX: Single := -1;
    var mTouchY: Single := -1;
    var mStartTime: Int64;
    var mCenterX: Single;
    var mCenterY: Single;
    var mDrawCube: Runnable;
    var mVisible: Boolean;
    var mPrefs: SharedPreferences;
    method readModel(prefix: String);
  public
    const SHARED_PREFS_NAME = 'cube2settings';
    constructor (wallpaperService: CubeWallpaper2);
    method onCreate(holder: SurfaceHolder); override;
    method onDestroy; override;
    method onVisibilityChanged(visible: Boolean); override;
    method onSurfaceCreated(holder: SurfaceHolder); override;
    method onSurfaceDestroyed(holder: SurfaceHolder); override;
    method onSurfaceChanged(holder: SurfaceHolder; format, width, height: Integer); override;
    method onOffsetsChanged(xOffset, yOffset, xOffsetStep, yOffsetStep: Single; xPixelOffset, yPixelOffset: Integer); override;
    method onTouchEvent(&event: MotionEvent); override;
    method onSharedPreferenceChanged(prefs: SharedPreferences; key: String);
    method drawFrame;
    method drawCube(c: Canvas);
    method drawLines(c: Canvas);
    method drawTouchPoint(c: Canvas);
    method rotateAndProjectPoints(xRot, yRot: Single);
  end;

  ThreeDPoint = public class
  assembly
    var x: Single;
    var y: Single;
    var z: Single;
  end;

  ThreeDLine = public class
  assembly
    var startPoint: Integer;
    var endPoint: Integer;
  end;

implementation

constructor CubeWallpaper2.CubeEngine(wallpaperService: CubeWallpaper2);
begin
  inherited constructor(wallpaperService);
  mWallpaperService := wallpaperService;
  mDrawCube := new interface Runnable(run := method begin drawFrame end);
  //  Create a Paint to draw the lines for our cube
  mPaint := new Paint;
  mPaint.Color := $ffffffff as Int64;
  mPaint.AntiAlias := true;
  mPaint.StrokeWidth := 2;
  mPaint.StrokeCap := Paint.Cap.ROUND;
  mPaint.Style := Paint.Style.STROKE;
  mStartTime := SystemClock.elapsedRealtime;
  mPrefs := mWallpaperService.getSharedPreferences(SHARED_PREFS_NAME, 0);
  mPrefs.registerOnSharedPreferenceChangeListener(self);
  onSharedPreferenceChanged(mPrefs, nil);
end;

method CubeWallpaper2.onCreateEngine: WallpaperService.Engine;
begin
  exit new CubeEngine(self)
end;

method CubeWallpaper2.CubeEngine.onCreate(holder: SurfaceHolder);
begin
  inherited onCreate(holder);
  //  By default we don't get touch events, so enable them.
  TouchEventsEnabled := true;
end;

method CubeWallpaper2.CubeEngine.onDestroy;
begin
  inherited onDestroy();
  mHandler.removeCallbacks(mDrawCube);
end;

method CubeWallpaper2.CubeEngine.onVisibilityChanged(visible: Boolean);
begin
  mVisible := visible;
  if visible then
    drawFrame
  else
    mHandler.removeCallbacks(mDrawCube)
end;

method CubeWallpaper2.CubeEngine.onSurfaceCreated(holder: SurfaceHolder);
begin
  inherited
end;

method CubeWallpaper2.CubeEngine.onSurfaceDestroyed(holder: SurfaceHolder);
begin
  inherited onSurfaceDestroyed(holder);
  mVisible := false;
  mHandler.removeCallbacks(mDrawCube);
end;

method CubeWallpaper2.CubeEngine.onSurfaceChanged(holder: SurfaceHolder; format: Integer; width: Integer; height: Integer);
begin
  inherited onSurfaceChanged(holder, format, width, height);
  // store the center of the surface, so we can draw the cube in the right spot
  mCenterX := width / 2.0;
  mCenterY := height / 2.0;
  drawFrame;
end;

method CubeWallpaper2.CubeEngine.onOffsetsChanged(xOffset: Single; yOffset: Single; xOffsetStep: Single; yOffsetStep: Single; xPixelOffset: Integer; yPixelOffset: Integer);
begin
  mOffset := xOffset;
  drawFrame;
end;

/// <summary>
/// Store the position of the touch event so we can use it for drawing later
/// </summary>
/// <param name="event"></param>
method CubeWallpaper2.CubeEngine.onTouchEvent(&event: MotionEvent);
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
method CubeWallpaper2.CubeEngine.drawFrame;
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
method CubeWallpaper2.CubeEngine.drawCube(c: Canvas);
begin
  c.save;
  c.translate(mCenterX, mCenterY);
  c.drawColor($ff000000 as Int64);
  var now: Int64 := SystemClock.elapsedRealtime;
  var xrot: Single := Single(now - mStartTime) div 1000;
  var yrot: Single := (0.5 - mOffset) * 2.0;
  rotateAndProjectPoints(xrot, yrot);
  drawLines(c);
  c.restore
end;

method CubeWallpaper2.CubeEngine.drawLines(c: Canvas);
begin
  var n: Integer := mLines.length;
  for i: Integer := 0 to pred(n) do
  begin
    var l: ThreeDLine := mLines[i];
    var start: ThreeDPoint := mRotatedPoints[l.startPoint];
    var &end: ThreeDPoint := mRotatedPoints[l.endPoint];
    c.drawLine(start.x, start.y, &end.x, &end.y, mPaint);
  end;
end;

/// <summary>
/// Draw a circle around the current touch point, if any.
/// </summary>
/// <param name="c"></param>
method CubeWallpaper2.CubeEngine.drawTouchPoint(c: Canvas);
begin
  if (mTouchX >= 0) and (mTouchY >= 0) then
    c.drawCircle(mTouchX, mTouchY, 80, mPaint)
end;

method CubeWallpaper2.CubeEngine.onSharedPreferenceChanged(prefs: SharedPreferences; key: String);
begin
  var shape: String := prefs.String['cube2_shape', 'cube'];
  //  read the 3D model from the resource
  readModel(shape);
end;

method CubeWallpaper2.CubeEngine.readModel(prefix: String);
begin
  //  Read the model definition in from a resource.
  //  get the resource identifiers for the arrays for the selected shape
  var pid: Integer := mWallpaperService.Resources.Identifier[prefix + 'points', 'array', mWallpaperService.PackageName];
  var lid: Integer := mWallpaperService.Resources.Identifier[prefix + 'lines',  'array', mWallpaperService.PackageName];
  var p: array of String := mWallpaperService.Resources.StringArray[pid];
  var numpoints: Integer := p.length;
  mOriginalPoints := new ThreeDPoint[numpoints];
  mRotatedPoints := new ThreeDPoint[numpoints];
  for i: Integer := 0 to pred(numpoints) do
  begin
    mOriginalPoints[i] := new ThreeDPoint();
    mRotatedPoints[i] := new ThreeDPoint();
    var coord: array of String := p[i].split(' ');
    mOriginalPoints[i].x := Float.valueOf(coord[0]);
    mOriginalPoints[i].y := Float.valueOf(coord[1]);
    mOriginalPoints[i].z := Float.valueOf(coord[2]);
  end;
  var l: array of String := mWallpaperService.Resources.StringArray[lid];
  var numlines: Integer := l.length;
  mLines := new ThreeDLine[numlines];
  for i: Integer := 0 to pred(numlines) do
  begin
    mLines[i] := new ThreeDLine();
    var idx: array of String := l[i].split(' ');
    mLines[i].startPoint := Integer.valueOf(idx[0]);
    mLines[i].endPoint := Integer.valueOf(idx[1]);
  end;
end;

method CubeWallpaper2.CubeEngine.rotateAndProjectPoints(xRot: Single; yRot: Single);
begin
  var n: Integer := mOriginalPoints.length;
  for i: Integer := 0 to pred(n) do
  begin
    // rotation around X-axis
    var p: ThreeDPoint := mOriginalPoints[i];
    var x := p.x;
    var y := p.y;
    var z := p.z;
    var newy := Math.sin(xRot) * z + Math.cos(xRot) * y;
    var newz := Math.cos(xRot) * z - Math.sin(xRot) * y;

    // rotation around Y-axis
    var newx := Math.sin(yRot) * newz + Math.cos(yRot) * x;
    newz := Math.cos(yRot) * newz - Math.sin(yRot) * x;

    // 3D-to-2D projection
    var screenX := newx / (4 - newz / 400);
    var screenY := newy / (4 - newz / 400);

    mRotatedPoints[i].x := screenX;
    mRotatedPoints[i].y := screenY;
    mRotatedPoints[i].z := 0;
  end
end;

end.