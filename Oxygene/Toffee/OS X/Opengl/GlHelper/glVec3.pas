

namespace GlHelper;

interface

uses
    rtl;


type
  { A 3-dimensional vector. Can be used for a variety of purposes:
    * To represent points or vectors in 3D space, using the X, Y and Z fields.
    * To represent colors (using the R, G and B fields, which are just aliases
      for X, Y and Z)
    * To represent texture coordinates (S, T and P, again just aliases for X, Y
      and Z).
    * To group 3 arbitrary values together in an array (C[0]..C[2], also just
      aliases for X, Y and Z)

    @bold(Note): when possible, use TVector4 instead of TVector3, since TVector4
    has better hardware support. Operations on TVector4 types are usually faster
    than operations on TVector3 types.

    }
    TVector3 = public record
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
      constructor (const A1, A2, A3: Single);
      class method Vector3(const A1, A2, A3: Single): TVector3;

    { Sets the three elements (X, Y and Z) to 0. }
        method Init;

    { Sets the three elements (X, Y and Z) to A.

      Parameters:
        A: the value to set the three elements to. }
        method Init(const A: Single);

    { Sets the three elements (X, Y and Z) to A1, A2 and A3 respectively.

      Parameters:
        A1: the value to set the first element to.
        A2: the value to set the second element to.
        A3: the value to set the third element to. }
        method Init(const A1, A2, A3: Single);

    { Sets the first two elements from a 2D vector, and the third element from
      a scalar.

      Parameters:
        A1: the vector to use for the first two elements.
        A2: the value to set the third element to. }
        method Init(const A1: TVector2; const A2: Single);

    { Sets the first element from a scaler, and the last two elements from a
      2D vector.

      Parameters:
        A1: the value to set the first element to.
        A2: the vector to use for the last two elements. }
        method Init(const A1: Single; const A2: TVector2);


    { Checks two vectors for equality.

      Returns:
        True if the two vectors match each other exactly. }
        class operator Equal(const A, B: TVector3): Boolean; inline;

    { Checks two vectors for inequality.

      Returns:
        True if the two vectors are not equal. }
        class operator NotEqual(const A, B: TVector3): Boolean; inline;

    { Negates a vector.

      Returns:
        The negative value of a vector (eg. (-A.X, -A.Y, -A.Z)) }
        class operator Minus(const A: TVector3): TVector3; inline;

    { Adds a scalar value to a vector.

      Returns:
        (A.X + B, A.Y + B, A.Z + B) }
        class operator Add(const A: TVector3; const B: Single): TVector3; inline;

    { Adds a vector to a scalar value.

      Returns:
        (A + B.X, A + B.Y, A + B.Z) }
        class operator Add(const A: Single; const B: TVector3): TVector3; inline;

    { Adds two vectors.

      Returns:
        (A.X + B.X, A.Y + B.Y, A.Z + B.Z) }
        class operator Add(const A, B: TVector3): TVector3; inline;

    { Subtracts a scalar value from a vector.

      Returns:
        (A.X - B, A.Y - B, A.Z - B) }
        class operator Subtract(const A: TVector3; const B: Single): TVector3;inline;

    { Subtracts a vector from a scalar value.

      Returns:
        (A - B.X, A - B.Y, A - B.Z) }
        class operator Subtract(const A: Single; const B: TVector3): TVector3; inline;

    { Subtracts two vectors.

      Returns:
        (A.X - B.X, A.Y - B.Y, A.Z - B.Z) }
        class operator Subtract(const A, B: TVector3): TVector3; inline;

    { Multiplies a vector with a scalar value.

      Returns:
        (A.X * B, A.Y * B, A.Z * B) }
        class operator Multiply(const A: TVector3; const B: Single): TVector3; inline;

    { Multiplies a scalar value with a vector.

      Returns:
        (A * B.X, A * B.Y, A * B.Z) }
        class operator Multiply(const A: Single; const B: TVector3): TVector3; inline;

    { Multiplies two vectors component-wise.
      To calculate a dot or cross product instead, use the Dot or Cross function.

      Returns:
        (A.X * B.X, A.Y * B.Y, A.Z * B.Z) }
        class operator Multiply(const A, B: TVector3): TVector3; inline;

    { Divides a vector by a scalar value.

      Returns:
        (A.X / B, A.Y / B, A.Z / B) }
        class operator Divide(const A: TVector3; const B: Single): TVector3; inline;

    { Divides a scalar value by a vector.

      Returns:
        (A / B.X, A / B.Y, A / B.Z) }
        class operator Divide(const A: Single; const B: TVector3): TVector3; inline;

    { Divides two vectors component-wise.

      Returns:
        (A.X / B.X, A.Y / B.Y, A.Z / B.Z) }
        class operator Divide(const A, B: TVector3): TVector3; inline;

    { Whether this vector equals another vector, within a certain tolerance.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if both vectors are equal (within the given tolerance). }
        method Equals(const AOther: TVector3; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Calculates the distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The distance between this vector and AOther.

      @bold(Note): If you only want to compare distances, you should use
      DistanceSquared instead, which is faster. }
        method Distance(const AOther: TVector3): Single;

    { Calculates the squared distance between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The squared distance between this vector and AOther. }
        method DistanceSquared(const AOther: TVector3): Single;

    { Calculates the dot product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The dot product between this vector and AOther. }
        method Dot(const AOther: TVector3): Single;

    { Calculates the cross product between this vector and another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        The cross product between this vector and AOther. }
        method Cross(const AOther: TVector3): TVector3;

    { Offsets this vector in a certain direction.

      Parameters:
        ADeltaX: the delta X direction.
        ADeltaY: the delta Y direction.
        ADeltaZ: the delta Z direction. }
        method Offset(const ADeltaX, ADeltaY, ADeltaZ: Single);

    { Offsets this vector in a certain direction.

      Parameters:
        ADelta: the delta.

      @bold(Note): this is equivalent to adding two vectors together. }
        method Offset(const ADelta: TVector3);


    { Calculates a normalized version of this vector.

      Returns:
        The normalized version of of this vector. That is, a vector in the same
        direction as A, but with a length of 1.

      @bold(Note): for a faster, less accurate version, use NormalizeFast.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetNormalized. }
        method Normalize: TVector3;

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
        method NormalizeFast: TVector3;

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
        method FaceForward(const I, NRef: TVector3): TVector3;

    { Calculates the reflection direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the desired
          result.

      Returns:
        The reflection direction calculated as Self - 2 * N.Dot(Self) * N. }
        method Reflect(const N: TVector3): TVector3;

    { Calculates the refraction direction for this (incident) vector.

      Parameters:
        N: the normal vector. Should be normalized in order to achieve the
          desired result.
        Eta: the ratio of indices of refraction.

      Returns:
        The refraction vector.

      @bold(Note): This vector should be normalized in order to achieve the
      desired result.}
        method Refract(const N: TVector3; const Eta: Single): TVector3;

    { Creates a vector with the same direction as this vector, but with the
      length limited, based on the desired maximum length.

      Parameters:
        AMaxLength: The desired maximum length of the vector.

      Returns:
        A length-limited version of this vector.

      @bold(Note): Does not change this vector. To update this vector itself,
      use SetLimit. }
        method Limit(const AMaxLength: Single): TVector3;

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
        method LimitSquared(const AMaxLengthSquared: Single): TVector3;

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
        method Clamp(const AMinLength, AMaxLength: Single): TVector3;

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
        method Lerp(const ATarget: TVector3; const AAlpha: Single): TVector3;

    { Linearly interpolates between this vector and a target vector and stores
      the result in this vector.

      Parameters:
        ATarget: the target vector.
        AAlpha: the interpolation coefficient (between 0.0 and 1.0).

      @bold(Note): If you do not want to change this vector, but get an
      interpolated version instead, then use Lerp. }
        method SetLerp(const ATarget: TVector3; const AAlpha: Single);

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
        True if X, Y and Z are exactly 0.0 }
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
        method HasSameDirection(const AOther: TVector3): Boolean;

    { Whether this vector has an opposite direction compared to another vector.

      Parameters:
        AOther: the other vector.

      Returns:
        True if the normalized dot product is less than 0. }
        method HasOppositeDirection(const AOther: TVector3): Boolean;

    { Whether this vector runs parallel to another vector (either in the same
      or the opposite direction).

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector runs parallel to AOther (within the given tolerance) }
        method IsParallel(const AOther: TVector3; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is collinear with another vector. Two vectors are
      collinear if they run parallel to each other and point in the same
      direction.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is collinear to AOther (within the given tolerance) }
        method IsCollinear(const AOther: TVector3; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

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
        method IsCollinearOpposite(const AOther: TVector3; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Whether this vector is perpendicular to another vector.

      Parameters:
        AOther: the other vector.
        ATolerance: (optional) tolerance. If not specified, a small tolerance
          is used.

      Returns:
        True if this vector is perpendicular to AOther. That is, if the dot
        product is 0 (within the given tolerance) }
        method IsPerpendicular(const AOther: TVector3; const ATolerance: Single := SINGLE_TOLERANCE): Boolean;

    { Returns the components of the vector.
      This is identical to accessing the C-field, but this property can be used
      as a default array property.

      Parameters:
        AIndex: index of the component to return (0-2). Range is checked
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
        X, Y, Z: Single;

        property R : Single read X write X;
        property G : Single read Y write Y;
        property B : Single read Z write Z;

        property S : Single read X write X;
        property T : Single read Y write Y;
        property P : Single read Z write Z;

//    case Byte of
//      { X, Y and Z components of the vector. Aliases for C[0], C[1] and C[2]. }
//      0: (X, Y, Z: Single);
//
//      { Red, Green and Blue components of the vector. Aliases for C[0], C[1]
//        and C[2]. }
//      1: (R, G, B: Single);
//
//      { S, T and P components of the vector. Aliases for C[0], C[1] and C[2]. }
//      2: (S, T, P: Single);
//
//      { The three components of the vector. }
//      3: (C: array [0..2] of Single);
    end;

implementation

{ TVector3 }

class operator TVector3.Add(const A: TVector3; const B: Single): TVector3;
begin
    Result.X := A.X + B;
    Result.Y := A.Y + B;
    Result.Z := A.Z + B;
end;

class operator TVector3.Add(const A: Single; const B: TVector3): TVector3;
begin
    Result.X := A + B.X;
    Result.Y := A + B.Y;
    Result.Z := A + B.Z;
end;

class operator TVector3.Add(const A, B: TVector3): TVector3;
begin
    Result.X := A.X + B.X;
    Result.Y := A.Y + B.Y;
    Result.Z := A.Z + B.Z;
end;

method TVector3.Distance(const AOther: TVector3): Single;
begin
    Result := (Self - AOther).Length;
end;

method TVector3.DistanceSquared(const AOther: TVector3): Single;
begin
    Result := (Self - AOther).LengthSquared;
end;

class operator TVector3.Divide(const A: TVector3; const B: Single): TVector3;
var
    InvB: Single;
begin
    InvB := 1 / B;
    Result.X := A.X * InvB;
    Result.Y := A.Y * InvB;
    Result.Z := A.Z * InvB;
end;

class operator TVector3.Divide(const A: Single; const B: TVector3): TVector3;
begin
    Result.X := A / B.X;
    Result.Y := A / B.Y;
    Result.Z := A / B.Z;
end;

class operator TVector3.Divide(const A, B: TVector3): TVector3;
begin
    Result.X := A.X / B.X;
    Result.Y := A.Y / B.Y;
    Result.Z := A.Z / B.Z;
end;

method TVector3.Cross(const AOther: TVector3): TVector3;
begin
    Result.X := (Y * AOther.Z) - (AOther.Y * Z);
    Result.Y := (Z * AOther.X) - (AOther.Z * X);
    Result.Z := (X * AOther.Y) - (AOther.X * Y);
end;

method TVector3.Dot(const AOther: TVector3): Single;
begin
    Result := (X * AOther.X) + (Y * AOther.Y) + (Z * AOther.Z);
end;

method TVector3.FaceForward(const I, NRef: TVector3): TVector3;
begin
    if (NRef.Dot(I) < 0) then
        Result := Self
    else
        Result := -Self;
end;

method TVector3.GetLength: Single;
begin
    Result := Sqrt((X * X) + (Y * Y) + (Z * Z));
end;

method TVector3.GetLengthSquared: Single;
begin
    Result := (X * X) + (Y * Y) + (Z * Z);
end;

class operator TVector3.Multiply(const A: TVector3; const B: Single): TVector3;
begin
    Result.X := A.X * B;
    Result.Y := A.Y * B;
    Result.Z := A.Z * B;
end;

class operator TVector3.Multiply(const A: Single; const B: TVector3): TVector3;
begin
    Result.X := A * B.X;
    Result.Y := A * B.Y;
    Result.Z := A * B.Z;
end;

class operator TVector3.Multiply(const A, B: TVector3): TVector3;
begin
    Result.X := A.X * B.X;
    Result.Y := A.Y * B.Y;
    Result.Z := A.Z * B.Z;
end;

class operator TVector3.Minus(const A: TVector3): TVector3;
begin
    Result.X := -A.X;
    Result.Y := -A.Y;
    Result.Z := -A.Z;
end;

method TVector3.NormalizeFast: TVector3;
begin
    Result := Self * InverseSqrt(Self.LengthSquared);
end;

method TVector3.Reflect(const N: TVector3): TVector3;
begin
    Result := Self - ((2 * N.Dot(Self)) * N);
end;

method TVector3.Refract(const N: TVector3; const Eta: Single): TVector3;
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

method TVector3.SetNormalizedFast;
begin
    Self := Self * InverseSqrt(Self.LengthSquared);
end;

class operator TVector3.Subtract(const A: TVector3; const B: Single): TVector3;
begin
    Result.X := A.X - B;
    Result.Y := A.Y - B;
    Result.Z := A.Z - B;
end;

class operator TVector3.Subtract(const A: Single; const B: TVector3): TVector3;
begin
    Result.X := A - B.X;
    Result.Y := A - B.Y;
    Result.Z := A - B.Z;
end;

class operator TVector3.Subtract(const A, B: TVector3): TVector3;
begin
    Result.X := A.X - B.X;
    Result.Y := A.Y - B.Y;
    Result.Z := A.Z - B.Z;
end;

{ TVector3 }

method TVector3.Clamp(const AMinLength, AMaxLength: Single): TVector3;
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

class operator TVector3.Equal(const A, B: TVector3): Boolean;
begin
    Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

method TVector3.Equals(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
    Result := (Abs(X - AOther.X) <= ATolerance)
    and (Abs(Y - AOther.Y) <= ATolerance)
    and (Abs(Z - AOther.Z) <= ATolerance);
end;

method TVector3.GetComponent(const AIndex: Integer): Single;
begin

    case AIndex of
        0 : result := X;
        1 : result := Y;
        2 : result := Z;
    end;
  //Result := C[AIndex];
end;

method TVector3.HasSameDirection(const AOther: TVector3): Boolean;
begin
    Result := (Dot(AOther) > 0);
end;

method TVector3.HasOppositeDirection(const AOther: TVector3): Boolean;
begin
    Result := (Dot(AOther) < 0);
end;



method TVector3.Init(const A: Single);
begin
    X := A;
    Y := A;
    Z := A;
end;

method TVector3.Init;
begin
    X := 0;
    Y := 0;
    Z := 0;
end;

method TVector3.Init(const A1, A2, A3: Single);
begin
    X := A1;
    Y := A2;
    Z := A3;
end;

method TVector3.Init(const A1: Single; const A2: TVector2);
begin
    X := A1;
    Y := A2.X;
    Z := A2.Y;
end;

method TVector3.Init(const A1: TVector2; const A2: Single);
begin
    X := A1.X;
    Y := A1.Y;
    Z := A2;
end;

method TVector3.IsCollinear(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
    Result := IsParallel(AOther, ATolerance) and (Dot(AOther) > 0);
end;

method TVector3.IsCollinearOpposite(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
    Result := IsParallel(AOther, ATolerance) and (Dot(AOther) < 0);
end;

method TVector3.IsNormalized: Boolean;
begin
    Result := IsNormalized(0.000000001);
end;

method TVector3.IsNormalized(const AErrorMargin: Single): Boolean;
begin
    Result := (Abs(LengthSquared - 1.0) < AErrorMargin);
end;

method TVector3.IsParallel(const AOther: TVector3; const ATolerance: Single): Boolean;

begin
    Result := ((Vector3(Y * AOther.Z - Z * AOther.Y,
    Z * AOther.X - X * AOther.Z,
    X * AOther.Y - Y * AOther.X).LengthSquared) <= ATolerance);
end;

method TVector3.IsPerpendicular(const AOther: TVector3; const ATolerance: Single): Boolean;
begin
    Result := (Abs(Dot(AOther)) <= ATolerance);
end;

method TVector3.IsZero: Boolean;
begin
    Result := (X = 0) and (Y = 0) and (Z = 0);
end;

method TVector3.IsZero(const AErrorMargin: Single): Boolean;
begin
    Result := (LengthSquared < AErrorMargin);
end;

method TVector3.Lerp(const ATarget: TVector3; const AAlpha: Single): TVector3;
begin
    Result := Mix(Self, ATarget, AAlpha);
end;

method TVector3.Limit(const AMaxLength: Single): TVector3;
begin
    Result := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector3.LimitSquared(const AMaxLengthSquared: Single): TVector3;
var
    LenSq: Single;
begin
    LenSq := GetLengthSquared;
    if (LenSq > AMaxLengthSquared) then
        Result := Self * Sqrt(AMaxLengthSquared / LenSq)
    else
        Result := Self;
end;

method TVector3.Normalize: TVector3;
begin
    Result := Self / Length;
end;

class operator TVector3.NotEqual(const A, B: TVector3): Boolean;
begin
    Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

method TVector3.Offset(const ADeltaX, ADeltaY, ADeltaZ: Single);
begin
    X := X + ADeltaX;
    Y := Y + ADeltaY;
    Z := Z + ADeltaZ;
end;

method TVector3.Offset(const ADelta: TVector3);
begin
    Self := Self + ADelta;
end;

method TVector3.SetClamped(const AMinLength, AMaxLength: Single);
begin
    Self := Clamp(AMinLength, AMaxLength);
end;

method TVector3.SetComponent(const AIndex: Integer; const Value: Single);
begin

    case AIndex of
        0 : X := Value;
        1 : Y := Value;
        2 : Z := Value;
    end;
  //C[AIndex] := Value;
end;

method TVector3.SetLength(const AValue: Single);
begin
    setLengthSquared(AValue * AValue);
end;

method TVector3.SetLengthSquared(const AValue: Single);
var
    LenSq: Single;
begin
    LenSq := GetLengthSquared;
    if (LenSq <> 0) and (LenSq <> AValue) then
        Self := Self * Sqrt(AValue / LenSq);
end;

method TVector3.SetLerp(const ATarget: TVector3; const AAlpha: Single);
begin
    Self := Mix(Self, ATarget, AAlpha);
end;

method TVector3.SetLimit(const AMaxLength: Single);
begin
    Self := LimitSquared(AMaxLength * AMaxLength);
end;

method TVector3.SetLimitSquared(const AMaxLengthSquared: Single);
begin
    Self := LimitSquared(AMaxLengthSquared);
end;

method TVector3.SetNormalized;
begin
    Self := Self / Length;
end;

class method TVector3.Vector3(const A1: Single; const A2: Single; const A3: Single): TVector3;
begin
 result.Init(A1, A2, A3);
end;

constructor TVector3(const A1: Single; const A2: Single; const A3: Single);
begin
  X := A1;
  Y := A2;
  Z := A3;
end;


end.