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
  android.util,
  android.content,
  android.view,
  android.graphics,
  android.hardware;

type
  {*
  * Each of our particle holds its previous and current position, its
  * acceleration. for added realism each particle has its own friction
  * coefficient.
  *}
  Particle = class
  private
    // friction of the virtual table and air
    const sFriction = 0.1;

    var mAccelX: Single;
    var mAccelY: Single;
    var mPosX: Single;
    var mPosY: Single;
    var mLastPosX: Single;
    var mLastPosY: Single;
    var mOneMinusFriction: Single;
    var mView: SimulationView;
  public
    constructor(v: SimulationView);
    method computePhysics(sx, sy, dT, dTC: Single);
    method resolveCollisionWithBounds;
    property PosX: Single read mPosX write mPosX;
    property PosY: Single read mPosY write mPosY;
  end;

implementation

constructor Particle(v: SimulationView);
begin
  mView := v;
  // make each particle a bit different by randomizing its
  // coefficient of friction
  var r := (Single(Math.random) - 0.5) * 0.2;
  mOneMinusFriction := 1.0 - sFriction + r;
end;

method Particle.computePhysics(sx, sy, dT, dTC: Single);
const
  m = 1000; // mass of our virtual object
  invm = 1.0 / m;
begin
  // Force of gravity applied to our virtual object

  var gx := -sx * m;
  var gy := -sy * m;

  {*
   * ?F = mA <=> A = ?F / m We could simplify the code by
   * completely eliminating "m" (the mass) from all the equations,
   * but it would hide the concepts from this sample code.
   *}
  var ax := gx * invm;
  var ay := gy * invm;

  {*
   * Time-corrected Verlet integration The position Verlet
   * integrator is defined as x(t+?t) = x(t) + x(t) - x(t-?t) +
   * a(t)?t² However, the above equation doesn't handle variable
   * ?t very well, a time-corrected version is needed: x(t+?t) =
   * x(t) + (x(t) - x(t-?t)) * (?t/?t_prev) + a(t)?t² We also add
   * a simple friction term (f) to the equation: x(t+?t) = x(t) +
   * (1-f) * (x(t) - x(t-?t)) * (?t/?t_prev) + a(t)?t²
   *}
  var dTdT := dT * dT;
  //x(t+?t) = x(t) + (1-f) * (x(t) - x(t-?t)) * (?t/?t_prev) + a(t)?t²
  var x := mPosX + (mOneMinusFriction * dTC * (mPosX - mLastPosX)) + (mAccelX * dTdT);
  var y := mPosY + (mOneMinusFriction * dTC * (mPosY - mLastPosY)) + (mAccelY * dTdT);
  mLastPosX := mPosX;
  mLastPosY := mPosY;
  mPosX := x;
  mPosY := y;
  mAccelX := ax;
  mAccelY := ay;
end;

{*
 * Resolving constraints and collisions with the Verlet integrator
 * can be very simple, we simply need to move a colliding or
 * constrained particle in such way that the constraint is
 * satisfied.
 *}
method Particle.resolveCollisionWithBounds;
begin
  var xmax := mView.HorizontalBound;
  var ymax := mView.VerticalBound;
  var x := mPosX;
  var y := mPosY;
  if x > xmax then
    mPosX := xmax
  else 
    if x < -xmax then
      mPosX := -xmax;
  if y > ymax then
    mPosY := ymax
  else 
    if y <= -ymax then
      mPosY := -ymax;
end;

end.