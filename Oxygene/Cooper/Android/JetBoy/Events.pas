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

uses 
  android.media,
  android.view;

type
  /// <summary>
  /// Base class for any external event passed to the JetBoyThread. This can
  /// include user input, system events, network input, etc.
  /// </summary>
  GameEvent = public class
  assembly
    var eventTime: Int64;
  public
    constructor;
  end;

  /// <summary>
  /// A GameEvent subclass for key based user input. Values are those used by
  /// the standard onKey
  /// </summary>
  KeyGameEvent = public class(GameEvent)
  public
    constructor(aKeyCode: Integer; aUp: Boolean; aMsg: KeyEvent);
    var keyCode: Integer;
    var msg: KeyEvent;
    var up: Boolean;
  end;

  /// <summary>
  /// A GameEvent subclass for events from the JetPlayer.
  /// </summary>
  JetGameEvent = public class(GameEvent)
  public
    constructor(aPlayer: JetPlayer; aSegment: SmallInt; aTrack, aChannel, aController, aValue: SByte);
    var player: JetPlayer;
    var segment: SmallInt;
    var track: SByte;
    var channel: SByte;
    var controller: SByte;
    var value: SByte;
  end;

implementation

constructor GameEvent;
begin
  eventTime := System.currentTimeMillis
end;

constructor KeyGameEvent(aKeyCode: Integer; aUp: Boolean; aMsg: KeyEvent);
begin
  keyCode := aKeyCode;
  msg := aMsg;
  up := aUp
end;

constructor JetGameEvent(aPlayer: JetPlayer; aSegment: SmallInt; aTrack, aChannel, aController, aValue: SByte);
begin
  player := aPlayer;
  segment := aSegment;
  track := aTrack;
  channel := aChannel;
  controller := aController;
  value := aValue
end;

end.