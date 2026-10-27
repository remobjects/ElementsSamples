namespace com.example.android.jetboy;

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

type
  Asteroid = public class
  public
    var mAniIndex: Integer := 0;
    var mDrawY: Integer := 0;
    var mDrawX: Integer := 0;
    var mExploding: Boolean := false;
    var mMissed: Boolean := false;
    var mStartTime: Int64 := 0;
  end;

implementation

end.