namespace GlHelper;


interface

uses
  rtl;

type
  { A quaternion.

   }
  TQuaternion = public record

  private
    method GetLength: Single;
    method GetLengthSquared: Single;

  public
    { Initializes the quaternion to an identity quaternion. Sets the X, Y and
      Z components to 0 and the W component to 1. }
    method Init;

    { Sets the four components of the quaternion.

      Parameters:
        AX: the X-component.
        AY: the Y-component.
        AZ: the Z-component.
        AW: the W-component. }
    method Init(const AX, AY, AZ, AW: Single);

    { Sets the quaternion from the given axis vector and the angle around that
      axis in radians.

      Parameters:
        AAxis: The axis.
        AAngleRadians: The angle in radians. }
    method Init(const AAxis: TVector3; const AAngleRadians: Single);

    { Sets the quaternion to the given euler angles in radians.

      Parameters:
        AYaw: the rotation around the Y axis in radians.
        APitch: the rotation around the X axis in radians.
        ARoll: the rotation around the Z axis in radians. }
    method Init(const AYaw, APitch, ARoll: Single);

    { Sets the quaternion from a matrix.

      Parameters:
        AMatrix: the matrix. }
    method Init(const AMatrix: TMatrix4);

    { Creates a rotation matrix that represents this quaternion.

      Returns:
        A rotation matrix that represents this quaternion. }
    method ToMatrix: TMatrix4;


    { Adds to quaternions together.

      Returns:
        A + B }
    class operator Add(const A, B: TQuaternion): TQuaternion; inline;

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B, A.W * B) }
    class operator Multiply(const A: TQuaternion; const B: Single): TQuaternion; inline;

    { Multiplies a vector with a scalar value.

      Returns:
        (A * B.X, A * B.Y, A * B.Z, A * B.W) }
    class operator Multiply(const A: Single; const B: TQuaternion): TQuaternion; inline;

    { Multiplies two quaternions.

      Returns:
        A * B }
    class operator Multiply(const A, B: TQuaternion): TQuaternion; inline;

    { Whether this is an identity quaternion.

      Returns:
        True if X, Y and Z are exactly 0.0 and W is exactly 1.0 }
    method IsIdentity: Boolean;

    { Whether this is an identity quaternion within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if this is an identity quaternion within the error margin. }
    method IsIdentity(const AErrorMargin: Single): Boolean;

    { Calculates a normalized version of this quaternion.

      Returns:
        The normalized quaternion of of this vector (with a length of 1).

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this quaternion. To update this quaternion
      itself, use SetNormalized. }
    method Normalize: TQuaternion;

    { Normalizes this quaternion to a length of 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this quaternion, but get a
      normalized version instead, then use Normalize. }
    method SetNormalized;

    { Calculates a normalized version of this quaternion.

      Returns:
        The normalized version of of this quaternion (with a length of 1).

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this quaternion. To update this quaternion
      itself, use SetNormalizedFast. }
    method NormalizeFast: TQuaternion;

    { Normalizes this quaternion to a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this quaternion, but get a
      normalized version instead, then use NormalizeFast. }
    method SetNormalizedFast;

    { Creates a conjugate of the quaternion.

      Returns:
        The conjugate (eg. (-X, -Y, -Z, W))

      @bold(Note): Does not change this quaterion. To update this quaterion
      itself, use SetConjugate. }
    method Conjugate: TQuaternion;

    { Conjugate this quaternion.

      @bold(Note): If you do not want to change this quaternion, but get a
      conjugate version instead, then use Conjugate. }
    method SetConjugate;

    { The euclidean length of this quaternion.

      @bold(Note): If you only want to compare lengths of quaternion, you should
      use LengthSquared instead, which is faster. }
    property Length: Single read GetLength;

    { The squared length of the quaternion.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths. }
    property LengthSquared: Single read GetLengthSquared;
  public

      { X, Y, Z and W components of the quaternion }
      X, Y, Z, W: Single;

      { The four components of the quaternion. }
    // C: array [0..3] of Single;
  end;

implementation

{ TQuaternion }

class operator TQuaternion.Add(const A, B: TQuaternion): TQuaternion;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

method TQuaternion.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

method TQuaternion.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z) + (W * W);
end;

class operator TQuaternion.Multiply(const A: TQuaternion; const B: Single): TQuaternion;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TQuaternion.Multiply(const A: Single; const B: TQuaternion): TQuaternion;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
  Result.W := A * B.W;
end;

class operator TQuaternion.Multiply(const A, B: TQuaternion): TQuaternion;
begin
  Result.X := (A.W * B.X) + (A.X * B.W) + (A.Y * B.Z) - (A.Z * B.Y);
  Result.Y := (A.W * B.Y) + (A.Y * B.W) + (A.Z * B.X) - (A.X * B.Z);
  Result.Z := (A.W * B.Z) + (A.Z * B.W) + (A.X * B.Y) - (A.Y * B.X);
  Result.W := (A.W * B.W) - (A.X * B.X) - (A.Y * B.Y) - (A.Z * B.Z);
end;

method TQuaternion.NormalizeFast: TQuaternion;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

method TQuaternion.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

{ TQuaternion }

method TQuaternion.Conjugate: TQuaternion;
begin
  Result.X := -X;
  Result.Y := -Y;
  Result.Z := -Z;
  Result.W := W;
end;


method TQuaternion.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 1;
end;

method TQuaternion.Init(const AX, AY, AZ, AW: Single);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := AW;
end;

method TQuaternion.Init(const AAxis: TVector3; const AAngleRadians: Single);
var
  D, S, CS: Single;
begin
  D := AAxis.Length;
  if (D = 0) then
  begin
    Init;
    Exit;
  end;

  D := 1 / D;
  SinCos(AAngleRadians * 0.5, out S, out CS);
  X := D * AAxis.X * S;
  Y := D * AAxis.Y * S;
  Z := D * AAxis.Z * S;
  W := CS;
  SetNormalized;
end;

method TQuaternion.Init(const AYaw, APitch, ARoll: Single);
var
  A, S, C: TVector4;
  CYSP, SYCP, CYCP, SYSP: Single;
begin
  A.Init(APitch * 0.5, AYaw * 0.5, ARoll * 0.5, 0);
  SinCos(A, out S, out C);

  CYSP := C.Y * S.X;
  SYCP := S.Y * C.X;
  CYCP := C.Y * C.X;
  SYSP := S.Y * S.X;

  X := (CYSP * C.Z) + (SYCP * S.Z);
  Y := (SYCP * C.Z) - (CYSP * S.Z);
  Z := (CYCP * S.Z) - (SYSP * C.Z);
  W := (CYCP * C.Z) + (SYSP * S.Z);
end;

method TQuaternion.Init(const AMatrix: TMatrix4);
var
  Trace, S: Double;
begin
  Trace := AMatrix.m11 + AMatrix.m22 + AMatrix.m33;
  if (Trace > EPSILON) then
  begin
    S := 0.5 / Sqrt(Trace + 1.0);
    X := (AMatrix.m23 - AMatrix.m32) * S;
    Y := (AMatrix.m31 - AMatrix.m13) * S;
    Z := (AMatrix.m12 - AMatrix.m21) * S;
    W := 0.25 / S;
  end
  else if (AMatrix.m11 > AMatrix.m22) and (AMatrix.m11 > AMatrix.m33) then
  begin
    S := Sqrt(Math.Max(EPSILON, 1 + AMatrix.m11 - AMatrix.m22 - AMatrix.m33)) * 2.0;
    X := 0.25 * S;
    Y := (AMatrix.m12 + AMatrix.m21) / S;
    Z := (AMatrix.m31 + AMatrix.m13) / S;
    W := (AMatrix.m23 - AMatrix.m32) / S;
  end
  else if (AMatrix.m22 > AMatrix.m33) then
  begin
    S := Sqrt(Math.Max(EPSILON, 1 + AMatrix.m22 - AMatrix.m11 - AMatrix.m33)) * 2.0;
    X := (AMatrix.m12 + AMatrix.m21) / S;
    Y := 0.25 * S;
    Z := (AMatrix.m23 + AMatrix.m32) / S;
    W := (AMatrix.m31 - AMatrix.m13) / S;
  end else
  begin
    S := Sqrt(Math.Max(EPSILON, 1 + AMatrix.m33 - AMatrix.m11 - AMatrix.m22)) * 2.0;
    X := (AMatrix.m31 + AMatrix.m13) / S;
    Y := (AMatrix.m23 + AMatrix.m32) / S;
    Z := 0.25 * S;
    W := (AMatrix.m12 - AMatrix.m21) / S;
  end;
  SetNormalized;
end;

method TQuaternion.IsIdentity: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0) and (W = 1);
end;

method TQuaternion.IsIdentity(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(X) <= AErrorMargin) and (Abs(Y) <= AErrorMargin)
    and (Abs(Z) <= AErrorMargin) and ((Abs(W) - 1) <= AErrorMargin)
end;

method TQuaternion.Normalize: TQuaternion;
begin
  Result := Self * (1 / Length);
end;

method TQuaternion.SetConjugate;
begin
  X := -X;
  Y := -Y;
  Z := -Z;
end;

method TQuaternion.SetNormalized;
begin
  Self := Self * (1 / Length);
end;

method TQuaternion.ToMatrix: TMatrix4;
var
  Q: TQuaternion;
  XX, XY, XZ, XW, YY, YZ, YW, ZZ, ZW: Single;
begin
  Q := Normalize;
  XX := Q.X * Q.X;
  XY := Q.X * Q.Y;
  XZ := Q.X * Q.Z;
  XW := Q.X * Q.W;
  YY := Q.Y * Q.Y;
  YZ := Q.Y * Q.Z;
  YW := Q.Y * Q.W;
  ZZ := Q.Z * Q.Z;
  ZW := Q.Z * Q.W;

  Result.Init(
    1 - 2 * (YY + ZZ), 2 * (XY + ZW), 2 * (XZ - YW), 0,
    2 * (XY - ZW), 1 - 2 * (XX + ZZ), 2 * (YZ + XW), 0,
    2 * (XZ + YW), 2 * (YZ - XW), 1 - 2 * (XX + YY), 0,
    0, 0, 0, 1);
end;

end.