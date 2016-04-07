unit com.example.android.accelerometerplay;

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
  java.util,
  android.os,
  android.content,
  android.util,
  android.view,
  android.graphics,
  android.hardware;

type
  SimulationView = class(View, SensorEventListener)
  private
    var mAccelerometer: Sensor;
    var mLastT: LongInt;
    var mLastDeltaT: Single;

    var mXDpi: Single;
    var mYDpi: Single;
    var mMetersToPixelsX: Single;
    var mMetersToPixelsY: Single;
    var mBitmap: Bitmap;
    var mWood: Bitmap;
    var mXOrigin: Single;
    var mYOrigin: Single;
    var mSensorX: Single;
    var mSensorY: Single;
    var mSensorTimeStamp: LongInt;
    var mCpuTimeStamp: LongInt;
    var mHorizontalBound: Single;
    var mVerticalBound: Single;
    var mParticleSystem: ParticleSystem;

    var mContext: Context;
  protected
    method onDraw(aCanvas: Canvas); override;
    method onSizeChanged(w, h, oldw, oldh: Integer); override;
  public
    // diameter of the balls in meters
    const sBallDiameter = 0.004;
    const sBallDiameter2 = sBallDiameter * sBallDiameter;

    constructor(Ctx: Context);
    method onSensorChanged(se: SensorEvent);
    method onAccuracyChanged(aSensor: Sensor; accuracy: Integer);
    method StartSimulation;
    method StopSimulation;
    property HorizontalBound: Single read mHorizontalBound;
    property VerticalBound: Single read mVerticalBound;
    property LastT: LongInt read mLastT write mLastT;
    property LastDeltaT: Single read mLastDeltaT write mLastDeltaT;
  end;

implementation

constructor SimulationView(Ctx: Context);
const
  MetersPerInch = 0.0254;
begin
  inherited;
  mContext := Ctx;
  mParticleSystem := new ParticleSystem(Self);
  mAccelerometer := AccelerometerPlayActivity(mContext).SensorMgr.DefaultSensor[Sensor.TYPE_ACCELEROMETER];
  var dispMetrics: DisplayMetrics := new DisplayMetrics();
  AccelerometerPlayActivity(mContext).WindowManager.DefaultDisplay.Metrics[dispMetrics];
  mXDpi := dispMetrics.xdpi;
  mYDpi := dispMetrics.ydpi;
  mMetersToPixelsX := mXDpi / MetersPerInch;
  mMetersToPixelsY := mYDpi / MetersPerInch;
  var ball: Bitmap := BitmapFactory.decodeResource(Resources, R.drawable.ball);
  var dstWidth := Integer(sBallDiameter * mMetersToPixelsX + 0.5);
  var dstHeight := Integer(sBallDiameter * mMetersToPixelsY + 0.5);
  mBitmap := Bitmap.createScaledBitmap(ball, dstWidth, dstHeight, true);
  var opts := new BitmapFactory.Options;
  opts.inDither := true;
  opts.inPreferredConfig := Bitmap.Config.RGB_565;
  mWood := BitmapFactory.decodeResource(Resources, R.drawable.wood, opts)
end;

method SimulationView.onSizeChanged(w, h, oldw, oldh: Integer);
begin
  // compute the origin of the screen relative to the origin of
  // the bitmap
  mXOrigin := (w - mBitmap.Width) * 0.5;
  mYOrigin := (h - mBitmap.Height) * 0.5;
  mHorizontalBound := (w / mMetersToPixelsX - sBallDiameter) * 0.5;
  mVerticalBound := (h / mMetersToPixelsY - sBallDiameter) * 0.5;
  // Resize the background bitmap
  // NOTE: the original code did not resize the background bitmap
  // so it did not cover the background on larger displays
  mWood := Bitmap.createScaledBitmap(mWood, w, h, true)
end;

method SimulationView.onSensorChanged(se: SensorEvent);
begin
  if se.sensor.Type <> Sensor.TYPE_ACCELEROMETER then
    exit;

  {
  * record the accelerometer data, the event's timestamp as well as
  * the current time. The latter is needed so we can calculate the
  * "present" time during rendering. In this application, we need to
  * take into account how the screen is rotated with respect to the
  * sensors (which always return data in a coordinate space aligned
  * with the screen in its native orientation).
  }

  case AccelerometerPlayActivity(mContext).DefaultDisplay.Rotation of 
    Surface.ROTATION_0:
    begin
      mSensorX := se.values[0];
      mSensorY := se.values[1];
    end;
    Surface.ROTATION_90:
    begin
      mSensorX := -se.values[1];
      mSensorY := se.values[0];
    end;
    Surface.ROTATION_180:
    begin
      mSensorX := -se.values[0];
      mSensorY := -se.values[1];
    end;
    Surface.ROTATION_270:
    begin
      mSensorX := se.values[1];
      mSensorY := -se.values[0];
    end;
  end;

  mSensorTimeStamp := se.timestamp;
  mCpuTimeStamp := System.nanoTime()
end;

method SimulationView.onAccuracyChanged(aSensor: Sensor; accuracy: Integer);
begin
end;

method SimulationView.StartSimulation;
begin
 {
  * It is not necessary to get accelerometer events at a very high
  * rate, by using a slower rate (SENSOR_DELAY_UI), we get an
  * automatic low-pass filter, which "extracts" the gravity component
  * of the acceleration. As an added benefit, we use less power and
  * CPU resources.
  }
  AccelerometerPlayActivity(mContext).SensorMgr.registerListener(
    self, mAccelerometer, SensorManager.SENSOR_DELAY_UI)
end;

method SimulationView.StopSimulation;
begin
  AccelerometerPlayActivity(mContext).SensorMgr.unregisterListener(Self)
end;

method SimulationView.onDraw(aCanvas: Canvas);
begin
  //draw the background
  aCanvas.drawBitmap(mWood, 0, 0, nil);

  //compute the new position of our object, based on accelerometer
  //data and present time.
  var particleSystem := mParticleSystem;
  var now := mSensorTimeStamp + (System.nanoTime - mCpuTimeStamp);
  var sx := mSensorX;
  var sy := mSensorY;

  particleSystem.update(sx, sy, now);
  var xc := mXOrigin;
  var yc := mYOrigin;
  var xs := mMetersToPixelsX;
  var ys := mMetersToPixelsY;
  for i: Integer := 0 to particleSystem.ParticleCount - 1 do
  begin
   {*
    * We transform the canvas so that the coordinate system matches
    * the sensors coordinate system with the origin in the center
    * of the screen and the unit is the meter.
    *}
    var x := xc + particleSystem.PosX[i] * xs;
    var y := yc - particleSystem.PosY[i] * ys;
    aCanvas.drawBitmap(mBitmap, x, y, nil);
  end;

  // and make sure to redraw asap
  invalidate
end;

end.
