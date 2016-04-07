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
  android.app,
  android.content,
  android.view,
  android.graphics,
  android.hardware;

type
  //A particle system is just a collection of particles
  ParticleSystem = class
  private
    const NUM_PARTICLES = 3;
    var mBalls: array of Particle := new Particle[NUM_PARTICLES];
    method updatePositions(sx, sy: Single; timestamp: LongInt);
    var mView: SimulationView;
  public
    constructor(v: SimulationView);
    method update(sx, sy: Single; now: LongInt);
    property ParticleCount: Integer read mBalls.length;
    property PosX[i: Integer]: Single read mBalls[i].PosX;
    property PosY[i: Integer]: Single read mBalls[i].PosY;
  end;

implementation

constructor ParticleSystem(v: SimulationView);
begin
  mView := v;
  {*
   * Initially our particles have no speed or acceleration
   *}
  for i: Integer := 0 to mBalls.length-1 do
    mBalls[i] := new Particle(mView);
end;

{*
  * Update the position of each particle in the system using the
  * Verlet integrator.
  *}
method ParticleSystem.updatePositions(sx, sy: Single; timestamp: LongInt);
begin
  var t := timestamp;
  if mView.LastT <> 0 then
  begin
    var dT := Single((t - mView.LastT) * (1.0 / 1000000000.0));
    if mView.LastDeltaT <> 0 then
    begin
      var dTC := dT / mView.LastDeltaT;
      for i: Integer := 0 to mBalls.length - 1 do
        mBalls[i].computePhysics(sx, sy, dT, dTC)
    end;
    mView.LastDeltaT := dT
  end;
  mView.LastT := t
end;

{*
 * Performs one iteration of the simulation. First updating the
 * position of all the particles and resolving the constraints and
 * collisions.
 *}
method ParticleSystem.update(sx, sy: Single; now: LongInt);
const
  NUM_MAX_ITERATIONS = 10;
  MinSpringSpeed = 0.05;
begin

  // update the system's positions
  updatePositions(sx, sy, now);

  // We do no more than a limited number of iterations

  {*
    * Resolve collisions, each particle is tested against every
    * other particle for collision. If a collision is detected the
    * particle is moved away using a virtual spring of infinite
    * stiffness.
    *}

  var more := true;
  var count := mBalls.length;
  for k: Integer := 0 to NUM_MAX_ITERATIONS - 1 do
  begin
    if not more then 
      break;
    more := false;
    for i: Integer := 0 to count - 1 do
    begin
      var curr := mBalls[i];
      for j: Integer := i + 1 to count - 1 do
      begin
        var ball := mBalls[j];
        var dx := ball.PosX - curr.PosX;
        var dy := ball.PosY - curr.PosY;
        var dd := dx * dx + dy * dy;
        // Check for collisions
        if dd < SimulationView.sBallDiameter2 then
        begin
          //add a little bit of entropy, after all nothing is
          //perfect in the universe.
          //if (ball.Speed > MinSpringSpeed) or (curr.Speed > MinSpringSpeed) then
          begin
            dx := dx + (Single(Math.random) - 0.5) * 0.0001;
            dy := dy + (Single(Math.random) - 0.5) * 0.0001;
          end;
          dd := dx * dx + dy * dy;
          // simulate the spring
          var d := Single(Math.sqrt(dd));
          var c := (0.5 * (SimulationView.sBallDiameter - d)) / d;
          curr.PosX := curr.PosX - (dx * c);
          curr.PosY := curr.PosY - (dy * c);
          ball.PosX := ball.PosX + (dx * c);
          ball.PosY := ball.PosY + (dy * c);
          more := true
        end;
      end;
      {*
       * Finally make sure the particle doesn't intersects
       * with the walls.
       *}
      curr.resolveCollisionWithBounds;
    end;
  end;
end;

end.