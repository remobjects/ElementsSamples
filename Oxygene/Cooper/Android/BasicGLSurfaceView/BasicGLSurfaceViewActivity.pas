namespace com.example.android.basicglsurfaceview;

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
  android.app,
  android.content,
  android.os,
  android.util,
  android.view,
  android.widget;

type
  BasicGLSurfaceViewActivity = public class(Activity)
  private
    var mView: BasicGLSurfaceView;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onPause; override;
    method onResume; override;
  end;

implementation

method BasicGLSurfaceViewActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  mView := new BasicGLSurfaceView(Application);
  ContentView := mView;
end;

method BasicGLSurfaceViewActivity.onPause;
begin
  inherited;
  mView.onPause;
end;

method BasicGLSurfaceViewActivity.onResume;
begin
  inherited;
  mView.onResume;
end;

end.
