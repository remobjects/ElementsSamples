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
  com.example.android.livecubes,
  android.content,
  android.os,
  android.preference;

type
  CubeWallpaper2Settings = public class(PreferenceActivity, SharedPreferences.OnSharedPreferenceChangeListener)
  protected
    method onCreate(icicle: Bundle); override;
    method onDestroy; override;
  public
    method onSharedPreferenceChanged(sharedPreferences: SharedPreferences; key: String);
  end;

implementation

method CubeWallpaper2Settings.onCreate(icicle: Bundle);
begin
  inherited onCreate(icicle);
  PreferenceManager.SharedPreferencesName := CubeWallpaper2.CubeEngine.SHARED_PREFS_NAME;
  addPreferencesFromResource(R.xml.cube2_settings);
  PreferenceManager.SharedPreferences.registerOnSharedPreferenceChangeListener(self)
end;

method CubeWallpaper2Settings.onDestroy;
begin
  PreferenceManager.SharedPreferences.unregisterOnSharedPreferenceChangeListener(self);
  inherited
end;

method CubeWallpaper2Settings.onSharedPreferenceChanged(sharedPreferences: SharedPreferences; key: String);
begin
end;

end.