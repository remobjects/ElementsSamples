namespace GlHelper;

interface

uses
 rtl;


type
  { A 4-dimensional vector. Can be used for a variety of purposes:
    * To represent points or vectors in 4D space, using the X, Y, Z and W
      fields.
    * To represent colors with alpha channel information (using the R, G, B and
      A fields, which are just aliases for X, Y, Z and W)
    * To represent texture coordinates (S, T, P and Q, again just aliases for X,
      Y, Z and W).
    * To group 4 arbitrary values together in an array (C[0]..C[3], also just
      aliases for X, Y, Z and W)

    }
  TVector4 = public record
  {$REGION 'Internal Declarations'}
  private
    method GetComponent(const AIndex: Integer): Single;
    method SetComponent(const AIndex: Integer; const Value: Single);
    method GetLength: Single;
    method SetLength(const AValue: Single);
    method GetLengthSquared: Single;
    method SetLengthSquared(const AValue: Single);
  {$ENDREGION 'Internal Declarations'}
  public
    { Sets the four elements (X, Y, Z and W) to 0. }
    method Init;

    { Sets the four elements (X, Y, Z and W) to A.

      Parameters:
        A: the value to set the three elements to. }
    method Init(const Value: Single);

    { Sets the four elements (X, Y, Z and W) to A1, A2, A3 and A4 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to.
        A4: the value to set the fourth element to. }
    method Init(const A1, A2, A3, A4: Single);

    { Sets the first two elements from a 2D vector, and the last two elements
      from two scalars.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the value to set the third element to.
        A3: the value to set the fourth element to. }
    method Init(const A1: TVector2; const A2, A3: Single);

    { Sets the first and last elements from two scalars, and the middle two
      elements from a 2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the second and third elements.
        A3: the value to set the fourth element to. }
    method Init(const A1: Single; const A2: TVector2; const A3: Single);

    { Sets the first two elements from two scalars and the last two elements
      from a 2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the vector to use for the last two elements. }
    method Init(const A1, A2: Single; const A3: TVector2);

    { Sets the first two elements and last two elements from two 2D vectors.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the vector to use for the last two elements. }
    method Init(const A1, A2: TVector2);

    { Sets the first three elements from a 3D vector, and the fourth element
      from a scalar.

      Parameters:
        A1: the vector to use for the first three elements.
        A2: the value to set the fourth element to. }
    method Init(const A1: TVector3; const A2: Single);

    { Sets the first element from a scaler, and the last three elements from a
      3D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the last three elements. }
    method Init(const A1: Single; const A2: TVector3);



    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
    class operator Equal(const A, B: TVector4): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
    class operator NotEqual(const A, B: TVector4): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z, -A.W)) }
    class operator Minus(const A: TVector4): TVector4; inline;

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B, A.W + B) }
    class operator Add(const A: TVector4; const B: Single): TVector4; inline;

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z, A + B.W) }
    class operator Add(const A: Single; const B: TVector4): TVector4;inline;

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z, A.W + B.W) }
    class operator Add(const A, B: TVector4): TVector4; inline;

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B, A.W - B) }
    class operator Subtract(const A: TVector4; const B: Single): TVector4; inline;

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z, A - B.W) }
    class operator Subtract(const A: Single; const B: TVector4): TVector4; inline;

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z, A.W - B.W) }
    class operator Subtract(const A, B: TVector4): TVector4; inline;

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B, A.W * B) }
    class operator Multiply(const A: TVector4; const B: Single): TVector4; inline;

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z, A * B.W) }
    class operator Multiply(const A: Single; const B: TVector4): TVector4; inline;

    { Multiplies two vectors component-wise.
      To calculate a dot product instead, use the Dot function.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z, A.W * B.W) }
    class operator Multiply(const A, B: TVector4): TVector4; inline;

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B, A.Z / B, A.W / B) }
    class operator Divide(const A: TVector4; const B: Single): TVector4; inline;

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y, A / B.Z, A / B.W) }
    class operator Divide(const A: Single; const B: TVector4): TVector4; inline;

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y, A.Z / B.Z, A.W / B.W) }
    class operator Divide(const A, B: TVector4): TVector4; inline;

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
    method Equals(const AOther: TVector4; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
    method Distance(const AOther: TVector4): Single;

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
    method DistanceSquared(const AOther: TVector4): Single;

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
    method Dot(const AOther: TVector4): Single;

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction.
        ADeltaZ: the delta Z direction.
        ADeltaW: the delta W direction. }
    method Offset(const ADeltaX, ADeltaY, ADeltaZ, ADeltaW: Single);

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
    method Offset(const ADelta: TVector4);


    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
    method Normalize: TVector4;

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
    method NormalizeFast: TVector4;

    { Normalizes this vector. This is, keep the current direction, but set the
      length to 1.

      @bold(Note): this is an SIMD optimized version that uses an approximation,
      resulting in a small error. For an accurate version, use SetNormalized.

      @bold(Note): If you do not want to change this vector, but get a
      normalized version instead, then use NormalizeFast. }
    method SetNormalizedFast;

    { Calculates a vector pointing in the same direction as this vector.

      Parameters:
        I: the incident vector.
        NRef: the reference vector.

      Returns:
        A vector that points away from the surface as defined by its normal. If
        NRef.Dot(I) < 0 then it returns this vector, otherwise it returns the
        negative of this vector. }
    method FaceForward(const I, NRef: TVector4): TVector4;

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
    method Reflect(const N: TVector4): TVector4;

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
    method Refract(const N: TVector4; const Eta: Single): TVector4;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
    method Limit(const AMaxLength: Single): TVector4;

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
    method LimitSquared(const AMaxLengthSquared: Single): TVector4;

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
    method Clamp(const AMinLength, AMaxLength: Single): TVector4;

    { Clamps the length of this vector between a minimim and maximum length.

      Parameters:
        AMinLength: The minimum length of this vector.
        AMaxLength: The maximum length of this vector.

      @bold(Note): If you do not want to change this vector, but get a
      length-clamped version instead, then use Clamp. }
    method SetClamped(const AMinLength, AMaxLength: Single);

    { Linearly interpolates between this vector and a target vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      Returns:
        The interpolation result vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLerp. }
    method Lerp(const ATarget: TVector4; const AAlpha: Single): TVector4;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
    method SetLerp(const ATarget: TVector4; const AAlpha: Single);

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
        True if X, Y, Z and W are exactly 0.0 }
    method IsZero: Boolean;

    { Whether this is a zero vector within a given margin of error.

      Parameters:
        AErrorMargin: the allowed margin of error.

      Returns:
        True if the squared length is smaller then the margin of error. }
    method IsZero(const AErrorMargin: Single): Boolean;

    { Whether this vector has a similar direction compared to another vector.
      The test is performed in 3 dimensions (that is, the W-component is ignored).
      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product (ignoring the W-component) is greater
        than 0. }
    method HasSameDirection(const AOther: TVector4): Boolean;

    { Whether this vector has an opposite direction compared to another vector.
      The test is performed in 3 dimensions (that is, the W-component is ignored).

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product (ignoring the W-component) is less
        than 0. }
    method HasOppositeDirection(const AOther: TVector4): Boolean;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction). The test is performed in 3 dimensions (that
      is, the W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance
        and ignoring the W-component) }
    method IsParallel(const AOther: TVector4; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction. The test is performed in 3 dimensions (that is, the W-component
      is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance
        and ignoring the W-component) }
    method IsCollinear(const AOther: TVector4; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is opposite collinear with another vector. Two vectors
      are opposite collinear if they run parallel to each other and point in
      opposite directions. The test is performed in 3 dimensions (that is, the
      W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is opposite collinear to AOther (within the given
        tolerance and ignoring the W-component) }
    method IsCollinearOpposite(const AOther: TVector4; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector. The test is
    performed in 3 dimensions (that is, the W-component is ignored).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance and ignoring the W-component) }
    method IsPerpendicular(const AOther: TVector4; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-3). Range is checked
          with an assertion. }
    property Components[const AIndex: Integer]: Single read GetComponent write SetComponent; default;

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
  public
      X, Y, Z, W: Single;

        property R : Single read X write X;
        property G : Single read Y write Y;
        property B : Single read Z write Z;
        property A : Single read W write W;

        property S : Single read X write X;
        property T : Single read Y write Y;
        property P : Single read Z write Z;
        property Q : Single read W write W;



//    case Byte of
//      { X, Y, Z and W components of the vector. Aliases for C[0], C[1], C[2]
//        and C[3]. }
//      0: (X, Y, Z, W: Single);
//
//      { Red, Green, Blue and Alpha components of the vector. Aliases for C[0],
//        C[1], C[2] and C[3]. }
//      1: (R, G, B, A: Single);
//
//      { S, T, P and Q components of the vector. Aliases for C[0], C[1], C[2] and
//        C[3]. }
//      2: (S, T, P, Q: Single);
//
//      { The four components of the vector. }
//      3: (C: array [0..3] of Single);
  end;

implementation

{ TVector4 }

class operator TVector4.Add(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TVector4.Add(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A + B.X;
  Result.Y := A + B.Y;
  Result.Z := A + B.Z;
  Result.W := A + B.W;
end;

class operator TVector4.Add(const A, B: TVector4): TVector4;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

method TVector4.Distance(const AOther: TVector4): Single;
begin
  Result := (Self - AOther).Length;
end;

method TVector4.DistanceSquared(const AOther: TVector4): Single;
begin
  Result := (Self - AOther).LengthSquared;
end;

class operator TVector4.Divide(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TVector4.Divide(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A / B.X;
  Result.Y := A / B.Y;
  Result.Z := A / B.Z;
  Result.W := A / B.W;
end;

class operator TVector4.Divide(const A, B: TVector4): TVector4;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
  Result.W := A.W / B.W;
end;

method TVector4.Dot(const AOther: TVector4): Single;
begin
  Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z) + (W * AOther.W);
end;

method TVector4.FaceForward(const I, NRef: TVector4): TVector4;
begin
  if (NRef.Dot(I) < 0) then
    Result := Self
  else
    Result := -Self;
end;

method TVector4.GetLength: Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

method TVector4.GetLengthSquared: Single;
begin
  Result := (X * X) + (Y * Y) + (Z * Z) + (W * W);
end;

class operator TVector4.Multiply(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TVector4.Multiply(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A * B.X;
  Result.Y := A * B.Y;
  Result.Z := A * B.Z;
  Result.W := A * B.W;
end;

class operator TVector4.Multiply(const A, B: TVector4): TVector4;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TVector4.Minus(const A: TVector4): TVector4;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

method TVector4.NormalizeFast: TVector4;
begin
  Result := Self * InverseSqrt(Self.LengthSquared);
end;

method TVector4.Reflect(const N: TVector4): TVector4;
begin
  Result := Self - ((2 * N.Dot(Self)) * N);
end;

method TVector4.Refract(const N: TVector4; const Eta: Single): TVector4;
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

method TVector4.SetNormalizedFast;
begin
  Self := Self * InverseSqrt(Self.LengthSquared);
end;

class operator TVector4.Subtract(const A: TVector4; const B: Single): TVector4;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TVector4.Subtract(const A: Single; const B: TVector4): TVector4;
begin
  Result.X := A - B.X;
  Result.Y := A - B.Y;
  Result.Z := A - B.Z;
  Result.W := A - B.W;
end;

class operator TVector4.Subtract(const A, B: TVector4): TVector4;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

{ TVector4 }

method TVector4.Clamp(const AMinLength, AMaxLength: Single): TVector4;
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

class operator TVector4.Equal(const A, B: TVector4): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

method TVector4.Equals(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := (Abs(X - AOther.X) <= ATolerance)
        and (Abs(Y - AOther.Y) <= ATolerance)
        and (Abs(Z - AOther.Z) <= ATolerance)
        and (Abs(W - AOther.W) <= ATolerance);
end;

method TVector4.GetComponent(const AIndex: Integer): Single;
begin

     case AIndex of
        0 : result := X;
        1 : result := Y;
        2 : result := Z;
        3 : result := W;
     end;
 // Result := C[AIndex];
end;

method TVector4.HasSameDirection(const AOther: TVector4): Boolean;
begin
  Result := (((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) > 0);
end;

method TVector4.HasOppositeDirection(const AOther: TVector4): Boolean;
begin
  Result := (((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) < 0);
end;


method TVector4.Init(const A1, A2, A3, A4: Single);
begin
  X := A1;
  Y := A2;
  Z := A3;
  W := A4;
end;

method TVector4.Init(const Value: Single);
begin
  X := Value;
  Y := Value;
  Z := Value;
  W := Value;
end;

method TVector4.Init;
begin
  X := 0;
  Y := 0;
  Z := 0;
  W := 0;
end;

method TVector4.Init(const A1: TVector2; const A2, A3: Single);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A2;
  W := A3;
end;

method TVector4.Init(const A1, A2: TVector2);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A2.X;
  W := A2.Y;
end;

method TVector4.Init(const A1, A2: Single; const A3: TVector2);
begin
  X := A1;
  Y := A2;
  Z := A3.X;
  W := A3.Y;
end;

method TVector4.Init(const A1: Single; const A2: TVector2; const A3: Single);
begin
  X := A1;
  Y := A2.X;
  Z := A2.Y;
  W := A3;
end;

method TVector4.Init(const A1: TVector3; const A2: Single);
begin
  X := A1.X;
  Y := A1.Y;
  Z := A1.Z;
  W := A2;
end;

method TVector4.Init(const A1: Single; const A2: TVector3);
begin
  X := A1;
  Y := A2.X;
  Z := A2.Y;
  W := A2.Z;
end;

method TVector4.IsCollinear(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (HasSameDirection(AOther));
end;

method TVector4.IsCollinearOpposite(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := IsParallel(AOther, ATolerance) and (HasOppositeDirection(AOther));
end;

method TVector4.IsNormalized: Boolean;
begin
  Result := IsNormalized(0.000000001);
end;

method TVector4.IsNormalized(const AErrorMargin: Single): Boolean;
begin
  Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

method TVector4.IsParallel(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := (TVector3.Vector3(Y * AOther.Z - Z * AOther.Y,
                      Z * AOther.X - X * AOther.Z,
                      X * AOther.Y - Y * AOther.X).LengthSquared <= ATolerance);
end;

method TVector4.IsPerpendicular(const AOther: TVector4; const ATolerance: Single): Boolean;
begin
  Result := (Abs((X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z)) <= ATolerance);
end;

method TVector4.IsZero: Boolean;
begin
  Result := (X = 0) and (Y = 0) and (Z = 0) and (W = 0);
end;

method TVector4.IsZero(const AErrorMargin: Single): Boolean;
begin
  Result := (LengthSquared < AErrorMargin);
end;

method TVector4.Lerp(const ATarget: TVector4; const AAlpha: Single): TVector4;
begin
  Result := Mix(Self, ATarget, AAlpha);
end;

method TVector4.Limit(const AMaxLength: Single): TVector4;
begin
  Result := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector4.LimitSquared(const AMaxLengthSquared: Single): TVector4;
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq > AMaxLengthSquared) then
    Result := Self * Sqrt(AMaxLengthSquared / LenSq)
  else
    Result := Self;
end;

method TVector4.Normalize: TVector4;
begin
  Result := Self / Length;
end;

class operator TVector4.NotEqual(const A, B: TVector4): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

method TVector4.Offset(const ADeltaX, ADeltaY, ADeltaZ, ADeltaW: Single);
begin
  X := X + ADeltaX;
  Y := Y + ADeltaY;
  Z := Z + ADeltaZ;
  W := W + ADeltaW;
end;

method TVector4.Offset(const ADelta: TVector4);
begin
  Self := Self + ADelta;
end;

method TVector4.SetClamped(const AMinLength, AMaxLength: Single);
begin
  Self := Clamp(AMinLength, AMaxLength);
end;

method TVector4.SetComponent(const AIndex: Integer; const Value: Single);
begin

     case AIndex of
        0 : X := Value;
        1 : Y := Value;
        2 : Z := Value;
        3 : W := Value;
    end;
//  C[AIndex] := Value;
end;

method TVector4.SetLength(const AValue: Single);
begin
  setLengthSquared(AValue * AValue);
end;

method TVector4.SetLengthSquared(const AValue: Single);
var
  LenSq: Single;
begin
  LenSq := GetLengthSquared;
  if (LenSq <> 0) and (LenSq <> AValue) then
    Self := Self * Sqrt(AValue / LenSq);
end;

method TVector4.SetLerp(const ATarget: TVector4; const AAlpha: Single);
begin
  Self := Mix(Self, ATarget, AAlpha);
end;

method TVector4.SetLimit(const AMaxLength: Single);
begin
  Self := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector4.SetLimitSquared(const AMaxLengthSquared: Single);
begin
  Self := LimitSquared(AMaxLengthSquared);
end;

method TVector4.SetNormalized;
begin
  Self := Self / Length;
end;

end.