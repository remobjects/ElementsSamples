namespace com.example.android.accelerometerplay;

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
  android.app,
  android.util,
  android.content,
  android.view,
  android.hardware;

{*
 * This is an example of using the accelerometer to integrate the device's
 * acceleration to a position using the Verlet method. This is illustrated with
 * a very simple particle system comprised of a few iron balls freely moving on
 * an inclined wooden table. The inclination of the virtual table is controlled
 * by the device's accelerometer.
 * 
 * see SensorManager, SensorEvent and Sensor
 *}

type
  AccelerometerPlayActivity = public class(Activity)
  private
    var mSimulationView: SimulationView;
    var mSensorManager: SensorManager;
    var mPowerManager: PowerManager;
    var mDisplay: Display;
    var mWakeLock: PowerManager.WakeLock;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onResume; override;
    method onPause; override;
    property SensorMgr: SensorManager read mSensorManager;
    property DefaultDisplay: Display read mDisplay;
  end;

implementation

method AccelerometerPlayActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  {
  //Hide the regular activity title
  RequestWindowFeature(Window.FEATURE_NO_TITLE);
  //Hide the OS status bar
  Window.SetFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
  }
  // Get an instance of the SensorManager
  mSensorManager := SensorManager(SystemService[SENSOR_SERVICE]);
  // Get an instance of the PowerManager
  mPowerManager := PowerManager(SystemService[POWER_SERVICE]);
  //Get the display object
  mDisplay := WindowManager.DefaultDisplay;
  // Create a bright wake lock
  mWakeLock := mPowerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK, &Class.Name);
  // instantiate our simulation view and set it as the activity's content
  mSimulationView := new SimulationView(Self);
  //Set activity content to be the custom-drawn view
  ContentView := mSimulationView;
end;

method AccelerometerPlayActivity.onResume;
begin
  inherited;
  {
  * when the activity is resumed, we acquire a wake-lock so that the
  * screen stays on, since the user will likely not be fiddling with the
  * screen or buttons.
  }
  mWakeLock.acquire;
  // Start the simulation
  mSimulationView.StartSimulation
end;

method AccelerometerPlayActivity.onPause;
begin
  inherited;
  {
  * When the activity is paused, we make sure to stop the simulation,
  * release our sensor resources and wake locks
  }

  // Stop the simulation
  mSimulationView.StopSimulation;
  // and release our wake-lock
  mWakeLock.release
end;

end.