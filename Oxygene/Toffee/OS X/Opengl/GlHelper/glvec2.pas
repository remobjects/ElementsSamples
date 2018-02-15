namespace GlHelper;

interface
{$GLOBALS ON}
uses
  rtl;

type
  { A 2-dimensional vector. Can be used to represent points or vectors in
    2D space, using the X and Y fields. You can also use it to represent
    texture coordinates, by using S and T (these are just aliases for X and Y).
    It can also be used to group 2 arbitrary values together in an array (using
    C[0] and C[1], which are also just aliases for X and Y).

    }

  TVector2 = public record
  {$REGION 'Internal Declarations'}
  private
    method GetComponent(const AIndex: Integer): Single;
    method SetComponent(const AIndex: Integer; const Value: Single);
    method GetLength: Single;
    method SetLength(const AValue: Single);
    method GetLengthSquared: Single;
    method SetLengthSquared(const AValue: Single);
    method GetAngle: Single;
    method SetAngle(const AValue: Single);
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the two elements (X and Y) to 0. }
    method Init;

    { Sets the two elements (X and Y) to A.

      Parameters:
        A: the value to set the two elements to. }
    method Init(const A: Single);

    { Sets the two elements (X and Y) to A1 and A2 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to. }
    method Init(const A1, A2: Single);


    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator &Equal(const A, B: TVector2): Boolean; //inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TVector2): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y)) }
    class operator Minus(const A: TVector2): TVector2; {$IF FM_INLINE }inline;{$ENDIF}

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B) }
    class operator Add(const A: TVector2; const B: Single): TVector2; inline;

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y) }
    class operator Add(const A: Single; const B: TVector2): TVector2; inline;

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y) }
    class operator Add(const A, B: TVector2): TVector2; {$IF FM_INLINE }inline;{$ENDIF}

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B) }
    class operator Subtract(const A: TVector2; const B: Single): TVector2; inline;

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y) }
    class operator Subtract(const A: Single; const B: TVector2): TVector2; inline;

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y) }
    class operator Subtract(const A, B: TVector2): TVector2; inline;

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B) }
    class operator Multiply(const A: TVector2; const B: Single): TVector2; inline;

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y) }
    class operator Multiply(const A: Single; const B: TVector2): TVector2; inline;

    { Multiplies two vectors component-wise.
      To calculate a dot or cross product instead, use the Dot or Cross function.

      Returns:
        (A.X * B.X, A.Y * B.Y) }
    class operator Multiply(const A, B: TVector2): TVector2; inline;

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B) }
    class operator Divide(const A: TVector2; const B: Single): TVector2; inline;

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y) }
    class operator Divide(const A: Single; const B: TVector2): TVector2;inline;

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y) }
    class operator Divide(const A, B: TVector2): TVector2; inline;

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
    method Equals(const AOther: TVector2; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
    method Distance(const AOther: TVector2): Single;

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
    method DistanceSquared(const AOther: TVector2): Single;

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
    method Dot(const AOther: TVector2): Single; inline;

    { Calculates the cross product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The cross product between this vector and AOther. }
    method Cross(const AOther: TVector2): Single; inline;

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction. }
    method Offset(const ADeltaX, ADeltaY: Single);

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
    method Offset(const ADelta: TVector2);

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
    method Normalize: TVector2;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): The SIMD optimized versions of this method use an
      approximation, resulting in a very small error.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use Normalize. }
    method SetNormalized;

    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use Normalize.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalizedFast. }
    method NormalizeFast: TVector2; inline;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use NormalizeFast. }
    method SetNormalizedFast; inline;

    { Calculates a vector pointing in the same direction as this vector.

      Parameters:
        I: the incident vector.
        NRef: the reference vector.

      Returns:
        A vector that points away from the surface as defined by its normal. If
        NRef.Dot(I) < 0 then it returns this vector, otherwise it returns the
        negative of this vector. }
    method FaceForward(const I, NRef: TVector2): TVector2;

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
    method Reflect(const N: TVector2): TVector2;

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
    method Refract(const N: TVector2; const Eta: Single): TVector2;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
    method Limit(const AMaxLength: Single): TVector2;

    { Limits the length of this vector, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use Limit. }
    method SetLimit(const AMaxLength: Single);

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired squared maximum length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimitSquared. }
    method LimitSquared(const AMaxLengthSquared: Single): TVector2;

    { Limits the length of this vector, based on the desired squared maximum
      length.

      Parameters:
        AMaxLengthSquared: The desired squared maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-limited version instead, then use LimitSquared. }
    method SetLimitSquared(const AMaxLengthSquared: Single);

    { Creates a vector with the same direction as this vector, but with the
      length clamped between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of the vector.
        AMaxLength: The maximum length of the vector.

      Returns:
        A length-clamped version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetClamped. }
    method Clamp(const AMinLength, AMaxLength: Single): TVector2;

    { Clamps the length of this vector between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of this vector.
        AMaxLength: The maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-clamped version instead, then use Clamp. }
    method SetClamped(const AMinLength, AMaxLength: Single);

    { Creates a vector by rotating this vector counter-clockwise.

      AParameters:
        ARadians: the rotation angle in radians, counter-clockwise assuming the
          Y-axis points up.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated. }
    method Rotate(const ARadians: Single): TVector2;

    { Rotates this vector counter-clockwise.

      AParameters:
        ARadians: the rotation angle in radians, counter-clockwise assuming the
          Y-axis points up.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate. }
    method SetRotated(const ARadians: Single);

    { Creates a vector by rotating this vector 90 degrees counter-clockwise.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated90CCW. }
    method Rotate90CCW: TVector2;

    { Rotates this vector 90 degrees counter-clockwise.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate90CCW. }
    method SetRotated90CCW;

    { Creates a vector by rotating this vector 90 degrees clockwise.

      Returns:
        A rotated version version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetRotated90CW. }
    method Rotate90CW: TVector2;

    { Rotates this vector 90 degrees clockwise.

      @bold(Note): If you do not want to change this vector, but get a
      rotated version instead, then use Rotate90CW. }
    method SetRotated90CW;

    { Calculates the angle in radians to rotate this vector/point to a target
      vector. Angles are towards the positive Y-axis (counter-clockwise).

      Parameters:
        ATarget: the target vector.

      Returns:
        The angle in radians to the target vector, in the range -Pi to Pi. }
    method AngleTo(const ATarget: TVector2): Single;

    { Linearly interpolates between this vector and a target vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      Returns:
        The interpolation result vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLerp. }
    method Lerp(const ATarget: TVector2; const AAlpha: Single): TVector2;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
    method SetLerp(const ATarget: TVector2; const AAlpha: Single);

    { Whether the vector is normalized (within a small margin of error).

      Returns:
        True if the length of the vector is (very close to) 1.0 }
    method IsNormalized: Boolean;

    { Whether the vector is normalized within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length of the vector is 1.0 within the margin of
        error. }
    method IsNormalized(const AErrorMargin: Single): Boolean;

    { Whether this is a zero vector.

      Returns:
        True if X and Y are exactly 0.0 }
    method IsZero: Boolean;

    { Whether this is a zero vector within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length is smaller then the margin of error. }
    method IsZero(const AErrorMargin: Single): Boolean;

    { Whether this vector has a similar direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is greater than 0. }
    method HasSameDirection(const AOther: TVector2): Boolean;

    { Whether this vector has an opposite direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is less than 0. }
    method HasOppositeDirection(const AOther: TVector2): Boolean;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance)

      @bold(Note): every vector is considered to run parallel to a zero vector. }
    method IsParallel(const AOther: TVector2; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance) }
    method IsCollinear(const AOther: TVector2; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is opposite collinear with another vector. Two vectors
      are opposite collinear if they run parallel to each other and point in
      opposite directions.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is opposite collinear to AOther (within the given
        tolerance) }
    method IsCollinearOpposite(const AOther: TVector2; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance) }
    method IsPerpendicular(const AOther: TVector2; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.


    { The euclidean length of this vector.

      @bold(Note): If you only want to compare lengths of vectors, you should
      use LengthSquared instead, which is faster.

      @bold(Note): You can also set the length of the vector. In that case, it
      will keep the current direction. }
    property Length: Single read GetLength write SetLength;

    { The squared length of the vector.

      @bold(Note): This property is faster than Length because it avoids
      calculating a square root. It is useful for comparing lengths instead of
      calculating actual lengths.

      @bold(Note): You can also set the squared length of the vector. In that
      case, it will keep the current direction. }
    property LengthSquared: Single read GetLengthSquared write SetLengthSquared;

    { The angle in radians of this vector/point relative to the X-axis. Angles
      are towards the positive Y-axis (counter-clockwise).

      When getting the angle, the result will be between -Pi and Pi. }
    property Angle: Single read GetAngle write SetAngle;
  public
      X,Y : Single;
      property R : Single read X write X;
      property G : Single read X write X;
      property S : Single read X write X;
      property T : Single read X write X;
  {  Parameters:
    AIndex: index of the component to return (0 or 1). Range is checked
    with an assertion. }
    property C[const AIndex: Integer]: Single read GetComponent write SetComponent; default;



//    Union :
//      { X and Y components of the vector. Aliases for C[0] and C[1]. }
//      0: (X, Y: Single);
//
//      { Red and Green components of the vector. Aliases for C[0] and C[1]. }
//      1: (R, G: Single);
//
//      { S and T components of the vector. Aliases for C[0] and C[1]. }
//      2: (S, T: Single);
//
//      { The two components of the vector. }
//      3: (C: array [0..1] of Single);
  end;

implementation

{ TVector2 }

class operator TVector2.Add(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TVector2.Add(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
end;

class operator TVector2.Add(const A, B: TVector2): TVector2;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

method TVector2.Distance(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).Length;
end;

method TVector2.DistanceSquared(const AOther: TVector2): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector2.Divide(const A: TVector2; const B: Single): TVector2;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.X := A.X * InvB;
  Result.Y := A.Y * InvB;
end;

class operator TVector2.Divide(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A / B.X;
  Result.Y := A / B.Y;
end;

class operator TVector2.Divide(const A, B: TVector2): TVector2;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

method TVector2.Dot(const AOther: TVector2): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y);
end;

method TVector2.FaceForward(const I, NRef: TVector2): TVector2;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

method TVector2.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

method TVector2.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

class operator TVector2.Multiply(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TVector2.Multiply(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
end;

class operator TVector2.Multiply(const A, B: TVector2): TVector2;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

method TVector2.NormalizeFast: TVector2;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

method TVector2.Reflect(const N: TVector2): TVector2;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

method TVector2.Refract(const N: TVector2; const Eta: Single): TVector2;
var
  D, K: Single;
begin
  D := N.Dot(Self);
  K := 1 - Eta * Eta * (1 - D * D);
  if (K < 0) then
    Result.Init
  else
    Result := (Eta * Self) - ((Eta * D + Sqrt(K)) * N);
end;

method TVector2.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

class operator TVector2.Subtract(const A: TVector2; const B: Single): TVector2;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TVector2.Subtract(const A: Single; const B: TVector2): TVector2;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
end;

class operator TVector2.Subtract(const A, B: TVector2): TVector2;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

{ TVector2 }

method TVector2.AngleTo(const ATarget: TVector2): Single;
begin
  Result := ArcTan2(Cross(ATarget), Dot(ATarget));
end;

method TVector2.Clamp(const AMinLength, AMaxLength: Single): TVector2;
var
  LenSq, EdgeSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq = 0) then
    Exit(Self);

  EdgeSq := AMaxLength * AMaxLength;
  if (LenSq > EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  EdgeSq := AMinLength * AMinLength;
  if (LenSq < EdgeSq) then
    Exit(Self * Sqrt(EdgeSq / LenSq));

  Result := Self;
end;

method TVector2.Cross(const AOther: TVector2): Single;
begin
  Result := (X * AOther.Y) - (Y * AOther.X);
end;

class operator TVector2.Equal(const A, B: TVector2): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y);
end;

method TVector2.Equals(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X - AOther.X) <= ATolerance)
        and (Abs(Y - AOther.Y) <= ATolerance);
end;

method TVector2.GetAngle: Single;
begin
  Result := ArcTan2(Y, X)
end;

method TVector2.GetComponent(const AIndex: Integer): Single;
begin
  if AIndex = 0 then exit X else exit Y;
end;

method TVector2.HasSameDirection(const AOther: TVector2): Boolean;
begin
  Result := (Dot(AOther) > 0);
end;

method TVector2.HasOppositeDirection(const AOther: TVector2): Boolean;
begin
  Result := (Dot(AOther) < 0);
end;


method TVector2.Init;
begin
  X := 0;
  Y := 0;
end;

method TVector2.Init(const A: Single);
begin
  X := A;
  Y := A;
end;

method TVector2.Init(const A1, A2: Single);
begin
  X := A1;
  Y := A2;
end;


method TVector2.IsCollinear(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) > 0);
end;

method TVector2.IsCollinearOpposite(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (Dot(AOther) < 0);
end;

method TVector2.IsNormalized: Boolean;
begin
  Result := IsNormalized(0.000000001);
end;

method TVector2.IsNormalized(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

method TVector2.IsParallel(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X * AOther.Y - Y * AOther.X) <= ATolerance);
end;

method TVector2.IsPerpendicular(const AOther: TVector2; const ATolerance: Single): Boolean;
begin
  Result := (Abs(Dot(AOther)) <= ATolerance);
end;

method TVector2.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0);
end;

method TVector2.IsZero(const AErrorMargin: Single): Boolean;
begin
  Result := (LengthSquared < AErrorMargin);
end;

method TVector2.Lerp(const ATarget: TVector2; const AAlpha: Single): TVector2;
begin
  Result := Mix(Self, ATarget, AAlpha);
end;

method TVector2.Limit(const AMaxLength: Single): TVector2;
begin
  Result := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector2.LimitSquared(const AMaxLengthSquared: Single): TVector2;
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq > AMaxLengthSquared) then
    Result := Self * Sqrt(AMaxLengthSquared / LenSq)
  else
    Result := Self;
end;

class operator TVector2.Minus(const A: TVector2): TVector2;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

method TVector2.Normalize: TVector2;
begin
  Result := Self / Length;
end;

class operator TVector2.NotEqual(const A, B: TVector2): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y);
end;

method TVector2.Offset(const ADeltaX, ADeltaY: Single);
begin
  X := X + ADeltaX;
  Y := Y + ADeltaY;
end;

method TVector2.Offset(const ADelta: TVector2);
begin
  Self := Self + ADelta;
end;

method TVector2.Rotate(const ARadians: Single): TVector2;
var
  lS, lC: Single;
begin
  SinCos(ARadians, out lS, out lC);
  Result.X := (X * lC) - (Y * lS);
  Result.Y := (X * lS) + (Y * lC);
end;

method TVector2.Rotate90CCW: TVector2;
begin
  Result.X := -Y;
  Result.Y := X;
end;

method TVector2.Rotate90CW: TVector2;
begin
  Result.X := Y;
  Result.Y := -X;
end;

method TVector2.SetLerp(const ATarget: TVector2; const AAlpha: Single);
begin
  Self := Mix(Self, ATarget, AAlpha);
end;

method TVector2.SetNormalized;
begin
  Self := Self / Length;
end;

method TVector2.SetRotated90CCW;
begin
  Self := Rotate90CCW;
end;

method TVector2.SetRotated90CW;
begin
  Self := Rotate90CW;
end;

method TVector2.SetAngle(const AValue: Single);
begin
  X := Length;
  Y := 0;
  SetRotated(AValue);
end;

method TVector2.SetClamped(const AMinLength, AMaxLength: Single);
begin
  Self := Clamp(AMinLength, AMaxLength);
end;

method TVector2.SetComponent(const AIndex: Integer; const Value: Single);
begin
    if AIndex = 0 then X := Value else Y := Value;
end;

method TVector2.SetLength(const AValue: Single);
begin
  setLengthSquared(AValue * AValue);
end;

method TVector2.SetLengthSquared(const AValue: Single);
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq <> 0) and (LenSq <> AValue) then
    Self := Self * Sqrt(AValue / LenSq);
end;

method TVector2.SetLimit(const AMaxLength: Single);
begin
  Self := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector2.SetLimitSquared(const AMaxLengthSquared: Single);
begin
  Self := LimitSquared(AMaxLengthSquared);
end;

method TVector2.SetRotated(const ARadians: Single);
begin
  Self := Rotate(ARadians);
end;

end.