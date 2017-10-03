namespace GlHelper;

interface

type
  { A 4x4 matrix in row-major order (M[Row, Column]).
    You can access the elements directly using M[0,0]..M[3,3] or m11..m44.

    }

{$DEFINE USEINLINE}
 TMatrix4 = public record
  private

    method GetComponent(const ARow, AColumn: Integer): Single; {$IF USEINLINE} inline; {$ENDIF}
    method SetComponent(const ARow, AColumn: Integer; const Value: Single); {$IF USEINLINE} inline; {$ENDIF}
    method GetRow(const AIndex: Integer): TVector4;
    method SetRow(const AIndex: Integer; const Value: TVector4);

    method GetDeterminant: Single;

  public
    { Initializes the matrix to an identity matrix (filled with 0 and value 1
      for the diagonal) }
    method Init;

    { Fills the matrix with zeros and sets the diagonal.

      Parameters:
        ADiagonal: the value to use for the diagonal. Use 1 to set the matrix
          to an identity matrix. }
    method Init(const ADiagonal: Single);


    { Initializes the matrix using four row vectors.

      Parameters:
        ARow0: the first row of the matrix.
        ARow1: the second row of the matrix.
        ARow2: the third row of the matrix.
        ARow3: the fourth row of the matrix. }
    method Init(const ARow0, ARow1, ARow2, ARow3: TVector4);


    { Initializes the matrix with explicit values.

      Parameters:
        A11-A44: the values of the matrix elements, in row-major order. }
    method Init(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32, A33,
      A34, A41, A42, A43, A44: Single);


    { Initializes the matrix with a 3x3 matrix. The 3x3 matrix is copied to the
      top-left corner of the 4x4 matrix, and the remaining elements are set
      according to an identity matrix.

      Parameters:
        AMatrix: the source 3x3 matrix. }
    method Init(const AMatrix: TMatrix3);

    { Creates a scaling matrix that scales uniformly.

      Parameters:
        AScale: the uniform scale factor }
    method InitScaling(const AScale: Single);

    { Creates a scaling matrix.

      Parameters:
        AScaleX: the value to scale by on the X axis
        AScaleY: the value to scale by on the Y axis
        AScaleZ: the value to scale by on the Z axis }
    method InitScaling(const AScaleX, AScaleY, AScaleZ: Single);

    { Creates a scaling matrix.

      Parameters:
        AScale: the scale factors }
    method InitScaling(const AScale: TVector3);

    { Creates a translation matrix.

      Parameters:
        ADeltaX: translation in the X direction
        ADeltaY: translation in the Y direction
        ADeltaZ: translation in the Z direction }
    method InitTranslation(const ADeltaX, ADeltaY, ADeltaZ: Single);

    { Creates a translation matrix.

      Parameters:
        ADelta: translation vector }
    method InitTranslation(const ADelta: TVector3);

    { Creates a matrix for rotating points around the X axis.

      Parameters:
        AAngle: the rotation angle around the X axis, in radians }
    method InitRotationX(const AAngle: Single);

    { Creates a matrix for rotating points around the Y axis.

      Parameters:
        AAngle: the rotation angle around the Y axis, in radians }
    method InitRotationY(const AAngle: Single);

    { Creates a matrix for rotating points around the Z axis.

      Parameters:
        AAngle: the rotation angle around the Z axis, in radians }
    method InitRotationZ(const AAngle: Single);

    { Creates a matrix for rotating points around a certain axis.

      Parameters:
        AAxis: the direction of the axis to rotate around.
        AAngle: the rotation angle around AAxis, in radians }
    method InitRotation(const AAxis: TVector3; const AAngle: Single);

    { Creates a rotation matrix from a yaw, pitch and roll angle.

      Parameters:
        AYaw: the rotation angle around the Y axis, in radians
        APitch: the rotation angle around the X axis, in radians
        ARoll: the rotation angle around the Z axis, in radians }
    method InitRotationYawPitchRoll(const AYaw, APitch, ARoll: Single);

    { Creates a rotation matrix from a heading, pitch and bank angle.

      Parameters:
        AHeading: the heading angle, in radians
        APitch: the pitch angle, in radians
        ABank: the bank angle, in radians }
    method InitRotationHeadingPitchBank(const AHeading, APitch, ABank: Single);

    { Creates a left-handed view matrix looking at a certain target.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraTarget: the target towards which the camera is pointing.
        ACameraUp: the direction that is "up" from the camera's point of view }
    method InitLookAtLH(const ACameraPosition, ACameraTarget, ACameraUp: TVector3);

    { Creates a right-handed view matrix looking at a certain target.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraTarget: the target towards which the camera is pointing.
        ACameraUp: the direction that is "up" from the camera's point of view }
    method InitLookAtRH(const ACameraPosition, ACameraTarget, ACameraUp: TVector3);

    { Creates a left-handed view matrix looking into a certain direction.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraDirection: the direction the camera is pointing in.
        ACameraUp: the direction that is "up" from the camera's point of view }
    method InitLookAtDirLH(const ACameraPosition, ACameraDirection, ACameraUp: TVector3);

    { Creates a right-handed view matrix looking into a certain direction.

      Parameters:
        ACameraPosition: position of the camera (or eye).
        ACameraDirection: the direction the camera is pointing in.
        ACameraUp: the direction that is "up" from the camera's point of view }
    method InitLookAtDirRH(const ACameraPosition, ACameraDirection, ACameraUp: TVector3);

    { Creates a left-handed orthographic projection matrix from the given view
      volume dimensions.

      Parameters:
        AWidth: the width of the view volume.
        AHeight: the height of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    method InitOrthoLH(const AWidth, AHeight, AZNearPlane, AZFarPlane: Single);

    { Creates a right-handed orthographic projection matrix from the given view
      volume dimensions.

      Parameters:
        AWidth: the width of the view volume.
        AHeight: the height of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    method InitOrthoRH(const AWidth, AHeight, AZNearPlane, AZFarPlane: Single);

    { Creates a customized left-handed orthographic projection matrix.

      Parameters:
        ALeft: the minimum X-value of the view volume.
        ATop: the maximum Y-value of the view volume.
        ARight: the maximum X-value of the view volume.
        ABottom: the minimum Y-value of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    method InitOrthoOffCenterLH(const ALeft, ATop, ARight, ABottom,
      AZNearPlane, AZFarPlane: Single);

    { Creates a customized right-handed orthographic projection matrix.

      Parameters:
        ALeft: the minimum X-value of the view volume.
        ATop: the maximum Y-value of the view volume.
        ARight: the maximum X-value of the view volume.
        ABottom: the minimum Y-value of the view volume.
        AZNearPlane: the minimum Z-value of the view volume.
        AZFarPlane: the maximum Z-value of the view volume. }
    method InitOrthoOffCenterRH(const ALeft, ATop, ARight, ABottom,
      AZNearPlane, AZFarPlane: Single);

    { Creates a left-handed perspective projection matrix based on a field of
      view, aspect ratio, and near and far view plane distances.

      Parameters:
        AFieldOfView: the field of view in radians.
        AAspectRatio: the aspect ratio, defined as view space width divided by
          height.
        ANearPlaneDistance:the distance to the near view plane.
        AFarPlaneDistance:the distance to the far view plane.
        AHorizontalFOV: (optional) boolean indicating the direction of the
          field of view. If False (default), AFieldOfView is in the Y direction,
          otherwise in the X direction }
    method InitPerspectiveFovLH(const AFieldOfView, AAspectRatio,
      ANearPlaneDistance, AFarPlaneDistance: Single;
      const AHorizontalFOV: Boolean := False);

    { Creates a right-handed perspective projection matrix based on a field of
      view, aspect ratio, and near and far view plane distances.

      Parameters:
        AFieldOfView: the field of view in radians.
        AAspectRatio: the aspect ratio, defined as view space width divided by
          height.
        ANearPlaneDistance:the distance to the near view plane.
        AFarPlaneDistance:the distance to the far view plane.
        AHorizontalFOV: (optional) boolean indicating the direction of the
          field of view. If False (default), AFieldOfView is in the Y direction,
          otherwise in the X direction }
    method InitPerspectiveFovRH(const AFieldOfView, AAspectRatio,
      ANearPlaneDistance, AFarPlaneDistance: Single;
      const AHorizontalFOV: Boolean := False);



    { Checks two matrices for equality.

      Returns:
        True if the two matrices match each other exactly. }
    class operator Equal(const A, B: TMatrix4): Boolean; {$IF USEINLINE} inline; {$ENDIF}

    { Checks two matrices for inequality.

      Returns:
        True if the two matrices are not equal. }
    class operator NotEqual(const A, B: TMatrix4): Boolean; {$IF USEINLINE} inline; {$ENDIF}

    { Negates a matrix.

      Returns:
        The negative value of the matrix (with all elements negated). }
    class operator Minus(const A: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: TMatrix4; const B: Single): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: Single; const B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Adds two matrices component-wise. }
    class operator Add(const A, B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Subtracts a scalar value from each element of a matrix. }
    class operator Subtract(const A: TMatrix4; const B: Single): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Subtracts a matrix from a scalar value. }
    class operator Subtract(const A: Single; const B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Subtracts two matrices component-wise. }
    class operator Subtract(const A, B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: TMatrix4; const B: Single): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: Single; const B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Performs a matrix * row vector linear algebraic multiplication. }
    class operator Multiply(const A: TMatrix4; const B: TVector4): TVector4; {$IF USEINLINE} inline; {$ENDIF}

    { Performs a column vector * matrix linear algebraic multiplication. }
    class operator Multiply(const A: TVector4; const B: TMatrix4): TVector4; {$IF USEINLINE} inline; {$ENDIF}

    { Multiplies two matrices using linear algebraic multiplication. }
    class operator Multiply(const A, B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Divides a matrix by a scalar value. }
    class operator Divide(const A: TMatrix4; const B: Single): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Divides a scalar value by a matrix. }
    class operator Divide(const A: Single; const B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Divides a matrix by a vector. This is equivalent to multiplying the
      inverse of the matrix with a row vector using linear algebraic
      multiplication. }
    class operator Divide(const A: TMatrix4; const B: TVector4): TVector4; {$IF USEINLINE} inline; {$ENDIF}

    { Divides a vector by a matrix. This is equivalent to multiplying a column
      vector with the inverse of the matrix using linear algebraic
      multiplication. }
    class operator Divide(const A: TVector4; const B: TMatrix4): TVector4; {$IF USEINLINE} inline; {$ENDIF}

    { Divides two matrices. This is equivalent to multiplying the first matrix
      with the inverse of the second matrix using linear algebraic
      multiplication. }
    class operator Divide(const A, B: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Multiplies this matrix with another matrix component-wise.

      Parameters:
        AOther: the other matrix.

      Returns:
        This matrix multiplied by AOther component-wise.
        That is, Result.M[I,J] := M[I,J] * AOther.M[I,J].

      @bold(Note): For linear algebraic matrix multiplication, use the multiply
      (*) operator instead. }
    method CompMult(const AOther: TMatrix4): TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Creates a transposed version of this matrix.

      Returns:
        The transposed version of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetTransposed. }
    method Transpose: TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Transposes this matrix.

      @bold(Note): If you do not want to change this matrix, but get a
      transposed version instead, then use Transpose. }
    method SetTransposed;

    { Calculates the inverse of this matrix.

      Returns:
        The inverse of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetInversed.

      @bold(Note): The values in the returned matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    method Inverse: TMatrix4; {$IF USEINLINE} inline; {$ENDIF}

    { Inverts this matrix.

      @bold(Note): If you do not want to change this matrix, but get an
      inversed version instead, then use Inverse.

      @bold(Note): The values in the inversed matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    method SetInversed;
    { Returns the rows of the matrix. This is identical to accessing the
      R-field.

      Parameters:
        AIndex: index of the row to return (0-3). Range is checked with
          an assertion. }
    property Rows[const AIndex: Integer]: TVector4 read GetRow write SetRow;



    { The determinant of this matrix. }
    property Determinant: Single read GetDeterminant;

    method getPglMatrix4f : ^Single;
  public
  {The Rows of the Matrix}
      V: array [0..3] of TVector4;
        { Returns the elements of the matrix (in row-major order).
      This is identical to accessing the M-field, but this property can be used
      as a default array property.

      Parameters:
        ARow: the row index (0-3). Range is checked with an assertion.
        AColumn: the column index (0-3). Range is checked with requires. }
    property M[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;



      property m11 : Single read GetComponent(0,0);
      property m12 : Single read GetComponent(0,1);
      property m13 : Single read GetComponent(0,2);
      property m14 : Single read GetComponent(0,3);

      property m21 : Single read GetComponent(1,0);
      property m22 : Single read GetComponent(1,1);
      property m23 : Single read GetComponent(1,2);
      property m24 : Single read GetComponent(1,3);

      property m31 : Single read GetComponent(2,0);
      property m32 : Single read GetComponent(2,1);
      property m33 : Single read GetComponent(2,2);
      property m34 : Single read GetComponent(2,3);

      property m41 : Single read GetComponent(3,0);
      property m42 : Single read GetComponent(3,1);
      property m43 : Single read GetComponent(3,2);
      property m44 : Single read GetComponent(3,3);

      //m11,
     // m12, m13, m14: Single;
     //     m21, m22, m23, m24: Single;
    //      m31, m32, m33, m34: Single;
    //      m41, m42, m43, m44: Single;
  end;

implementation

{ TMatrix 4 }

class operator TMatrix4.Add(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TMatrix4.Add(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A + B.V[0];
  Result.V[1] := A + B.V[1];
  Result.V[2] := A + B.V[2];
  Result.V[3] := A + B.V[3];
end;

class operator TMatrix4.Add(const A, B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

method TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := V[I] * AOther.V[I];
end;

class operator TMatrix4.Divide(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A / B.V[0];
  Result.V[1] := A / B.V[1];
  Result.V[2] := A / B.V[2];
  Result.V[3] := A / B.V[3];
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: Single): TMatrix4;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;

method TMatrix4.Inverse: TMatrix4;
var
  C00, C02, C03, C04, C06, C07, C08, C10, C11: Single;
  C12, C14, C15, C16, C18, C19, C20, C22, C23: Single;
  F0, F1, F2, F3, F4, F5, V0, V1, V2, V3, I0, I1, I2, I3, SA, SB, Row, Dot: TVector4;
  Inv: TMatrix4;
  OneOverDeterminant: Single;
begin
  C00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  C02 := (M[1,2] * M[3,3]) - (M[3,2] * M[1,3]);
  C03 := (M[1,2] * M[2,3]) - (M[2,2] * M[1,3]);

  C04 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  C06 := (M[1,1] * M[3,3]) - (M[3,1] * M[1,3]);
  C07 := (M[1,1] * M[2,3]) - (M[2,1] * M[1,3]);

  C08 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  C10 := (M[1,1] * M[3,2]) - (M[3,1] * M[1,2]);
  C11 := (M[1,1] * M[2,2]) - (M[2,1] * M[1,2]);

  C12 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  C14 := (M[1,0] * M[3,3]) - (M[3,0] * M[1,3]);
  C15 := (M[1,0] * M[2,3]) - (M[2,0] * M[1,3]);

  C16 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  C18 := (M[1,0] * M[3,2]) - (M[3,0] * M[1,2]);
  C19 := (M[1,0] * M[2,2]) - (M[2,0] * M[1,2]);

  C20 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);
  C22 := (M[1,0] * M[3,1]) - (M[3,0] * M[1,1]);
  C23 := (M[1,0] * M[2,1]) - (M[2,0] * M[1,1]);

  F0.Init(C00, C00, C02, C03);
  F1.Init(C04, C04, C06, C07);
  F2.Init(C08, C08, C10, C11);
  F3.Init(C12, C12, C14, C15);
  F4.Init(C16, C16, C18, C19);
  F5.Init(C20, C20, C22, C23);

  V0.Init(M[1,0], M[0,0], M[0,0], M[0,0]);
  V1.Init(M[1,1], M[0,1], M[0,1], M[0,1]);
  V2.Init(M[1,2], M[0,2], M[0,2], M[0,2]);
  V3.Init(M[1,3], M[0,3], M[0,3], M[0,3]);

  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);

  SA.Init(+1, -1, +1, -1);
  SB.Init(-1, +1, -1, +1);

  Inv.Init(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  Row.Init(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  Dot := V[0] * Row;

  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  Result := Inv * OneOverDeterminant;
end;

class operator TMatrix4.Multiply(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A * B.V[0];
  Result.V[1] := A * B.V[1];
  Result.V[2] := A * B.V[2];
  Result.V[3] := A * B.V[3];
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

class operator TMatrix4.Multiply(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result.X := (B.M[0,0] * A.X) + (B.M[1,0] * A.Y) + (B.M[2,0] * A.Z) + (B.M[3,0] * A.W);
  Result.Y := (B.M[0,1] * A.X) + (B.M[1,1] * A.Y) + (B.M[2,1] * A.Z) + (B.M[3,1] * A.W);
  Result.Z := (B.M[0,2] * A.X) + (B.M[1,2] * A.Y) + (B.M[2,2] * A.Z) + (B.M[3,2] * A.W);
  Result.W := (B.M[0,3] * A.X) + (B.M[1,3] * A.Y) + (B.M[2,3] * A.Z) + (B.M[3,3] * A.W);
end;

class operator TMatrix4.Multiply(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TMatrix4.Multiply(const A, B: TMatrix4): TMatrix4;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[0,1] * B.M[1,0]) + (A.M[0,2] * B.M[2,0]) + (A.M[0,3] * B.M[3,0]);
  Result.M[0,1] := (A.M[0,0] * B.M[0,1]) + (A.M[0,1] * B.M[1,1]) + (A.M[0,2] * B.M[2,1]) + (A.M[0,3] * B.M[3,1]);
  Result.M[0,2] := (A.M[0,0] * B.M[0,2]) + (A.M[0,1] * B.M[1,2]) + (A.M[0,2] * B.M[2,2]) + (A.M[0,3] * B.M[3,2]);
  Result.M[0,3] := (A.M[0,0] * B.M[0,3]) + (A.M[0,1] * B.M[1,3]) + (A.M[0,2] * B.M[2,3]) + (A.M[0,3] * B.M[3,3]);

  Result.M[1,0] := (A.M[1,0] * B.M[0,0]) + (A.M[1,1] * B.M[1,0]) + (A.M[1,2] * B.M[2,0]) + (A.M[1,3] * B.M[3,0]);
  Result.M[1,1] := (A.M[1,0] * B.M[0,1]) + (A.M[1,1] * B.M[1,1]) + (A.M[1,2] * B.M[2,1]) + (A.M[1,3] * B.M[3,1]);
  Result.M[1,2] := (A.M[1,0] * B.M[0,2]) + (A.M[1,1] * B.M[1,2]) + (A.M[1,2] * B.M[2,2]) + (A.M[1,3] * B.M[3,2]);
  Result.M[1,3] := (A.M[1,0] * B.M[0,3]) + (A.M[1,1] * B.M[1,3]) + (A.M[1,2] * B.M[2,3]) + (A.M[1,3] * B.M[3,3]);

  Result.M[2,0] := (A.M[2,0] * B.M[0,0]) + (A.M[2,1] * B.M[1,0]) + (A.M[2,2] * B.M[2,0]) + (A.M[2,3] * B.M[3,0]);
  Result.M[2,1] := (A.M[2,0] * B.M[0,1]) + (A.M[2,1] * B.M[1,1]) + (A.M[2,2] * B.M[2,1]) + (A.M[2,3] * B.M[3,1]);
  Result.M[2,2] := (A.M[2,0] * B.M[0,2]) + (A.M[2,1] * B.M[1,2]) + (A.M[2,2] * B.M[2,2]) + (A.M[2,3] * B.M[3,2]);
  Result.M[2,3] := (A.M[2,0] * B.M[0,3]) + (A.M[2,1] * B.M[1,3]) + (A.M[2,2] * B.M[2,3]) + (A.M[2,3] * B.M[3,3]);

  Result.M[3,0] := (A.M[3,0] * B.M[0,0]) + (A.M[3,1] * B.M[1,0]) + (A.M[3,2] * B.M[2,0]) + (A.M[3,3] * B.M[3,0]);
  Result.M[3,1] := (A.M[3,0] * B.M[0,1]) + (A.M[3,1] * B.M[1,1]) + (A.M[3,2] * B.M[2,1]) + (A.M[3,3] * B.M[3,1]);
  Result.M[3,2] := (A.M[3,0] * B.M[0,2]) + (A.M[3,1] * B.M[1,2]) + (A.M[3,2] * B.M[2,2]) + (A.M[3,3] * B.M[3,2]);
  Result.M[3,3] := (A.M[3,0] * B.M[0,3]) + (A.M[3,1] * B.M[1,3]) + (A.M[3,2] * B.M[2,3]) + (A.M[3,3] * B.M[3,3]);
end;

class operator TMatrix4.Minus(const A: TMatrix4): TMatrix4;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

method TMatrix4.SetInversed;
begin
  Self := Inverse;
end;

method TMatrix4.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix4.Subtract(const A: TMatrix4; const B: Single): TMatrix4;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TMatrix4.Subtract(const A, B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TMatrix4.Subtract(const A: Single; const B: TMatrix4): TMatrix4;
begin
  Result.V[0] := A - B.V[0];
  Result.V[1] := A - B.V[1];
  Result.V[2] := A - B.V[2];
  Result.V[3] := A - B.V[3];
end;

method TMatrix4.Transpose: TMatrix4;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];
  Result.M[0,3] := M[3,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];
  Result.M[1,3] := M[3,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
  Result.M[2,3] := M[3,2];

  Result.M[3,0] := M[0,3];
  Result.M[3,1] := M[1,3];
  Result.M[3,2] := M[2,3];
  Result.M[3,3] := M[3,3];
end;

{ TMatrix4 }

class operator TMatrix4.Divide(const A, B: TMatrix4): TMatrix4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result := A.Inverse * B;
end;

method TMatrix4.GetDeterminant: Single;
var
  F00, F01, F02, F03, F04, F05: Single;
  C: TVector4;
begin
  F00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  F01 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  F02 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  F03 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  F04 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  F05 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);

  C.X := + ((M[1,1] * F00) - (M[1,2] * F01) + (M[1,3] * F02));
  C.Y := - ((M[1,0] * F00) - (M[1,2] * F03) + (M[1,3] * F04));
  C.Z := + ((M[1,0] * F01) - (M[1,1] * F03) + (M[1,3] * F05));
  C.W := - ((M[1,0] * F02) - (M[1,1] * F04) + (M[1,2] * F05));

  Result := (M[0,0] * C.X) + (M[0,1] * C.Y) + (M[0,2] * C.Z) + (M[0,3] * C.W);
end;

class operator TMatrix4.Equal(const A, B: TMatrix4): Boolean;
begin
  Result := (A.V[0] = B.V[0]) and (A.V[1] = B.V[1]) and (A.V[2] = B.V[2]) and (A.V[3] = B.V[3]);
end;

method TMatrix4.Init(const ADiagonal: Single);
begin
  V[0].Init(ADiagonal, 0, 0, 0);
  V[1].Init(0, ADiagonal, 0, 0);
  V[2].Init(0, 0, ADiagonal, 0);
  V[3].Init(0, 0, 0, ADiagonal);
end;

method TMatrix4.Init;
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.Init(const A11, A12, A13, A14, A21, A22, A23, A24, A31, A32,
  A33, A34, A41, A42, A43, A44: Single);
begin
  V[0].Init(A11, A12, A13, A14);
  V[1].Init(A21, A22, A23, A24);
  V[2].Init(A31, A32, A33, A34);
  V[3].Init(A41, A42, A43, A44);
end;


method TMatrix4.Init(const AMatrix: TMatrix3);
begin
  V[0].Init(AMatrix.V[0], 0);
  V[1].Init(AMatrix.V[1], 0);
  V[2].Init(AMatrix.V[2], 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitLookAtLH(const ACameraPosition, ACameraTarget,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := (ACameraTarget - ACameraPosition).Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

method TMatrix4.InitLookAtRH(const ACameraPosition, ACameraTarget,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := (ACameraPosition - ACameraTarget).Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

method TMatrix4.InitLookAtDirLH(const ACameraPosition, ACameraDirection,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := -ACameraDirection.Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

method TMatrix4.InitLookAtDirRH(const ACameraPosition, ACameraDirection,
  ACameraUp: TVector3);
var
  XAxis, YAxis, ZAxis: TVector3;
begin
  ZAxis := ACameraDirection.Normalize;
  XAxis := ACameraUp.Cross(ZAxis).Normalize;
  YAxis := ZAxis.Cross(XAxis);

  V[0].Init(XAxis.X, YAxis.X, ZAxis.X, 0);
  V[1].Init(XAxis.Y, YAxis.Y, ZAxis.Y, 0);
  V[2].Init(XAxis.Z, YAxis.Z, ZAxis.Z, 0);
  V[3].Init(-XAxis.Dot(ACameraPosition),
            -YAxis.Dot(ACameraPosition),
            -ZAxis.Dot(ACameraPosition), 1);
end;

method TMatrix4.InitScaling(const AScale: Single);
begin
  V[0].Init(AScale, 0, 0, 0);
  V[1].Init(0, AScale, 0, 0);
  V[2].Init(0, 0, AScale, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitScaling(const AScaleX, AScaleY, AScaleZ: Single);
begin
  V[0].Init(AScaleX, 0, 0, 0);
  V[1].Init(0, AScaleY, 0, 0);
  V[2].Init(0, 0, AScaleZ, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitScaling(const AScale: TVector3);
begin
  V[0].Init(AScale.X, 0, 0, 0);
  V[1].Init(0, AScale.Y, 0, 0);
  V[2].Init(0, 0, AScale.Z, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitTranslation(const ADeltaX, ADeltaY, ADeltaZ: Single);
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(ADeltaX, ADeltaY, ADeltaZ, 1);
end;

method TMatrix4.InitTranslation(const ADelta: TVector3);
begin
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(ADelta.X, ADelta.Y, ADelta.Z, 1);
end;

class operator TMatrix4.NotEqual(const A, B: TMatrix4): Boolean;
begin
  Result := (A.V[0] <> B.V[0]) or (A.V[1] <> B.V[1]) or (A.V[2] <> B.V[2]) or (A.V[3] <> B.V[3]);
end;

method TMatrix4.InitRotationX(const AAngle: Single);
var
  S, C: Single;
begin
  SinCos(AAngle, out S, out C);
  V[0].Init(1, 0, 0, 0);
  V[1].Init(0, C, S, 0);
  V[2].Init(0, -S, C, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitRotationY(const AAngle: Single);
var
  S, C: Single;
begin
  SinCos(AAngle, out S, out C);
  V[0].Init(C, 0, -S, 0);
  V[1].Init(0, 1, 0, 0);
  V[2].Init(S, 0, C, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitRotationZ(const AAngle: Single);
var
  S, C: Single;
begin
  SinCos(AAngle, out S,out  C);
  V[0].Init(C, S, 0, 0);
  V[1].Init(-S, C, 0, 0);
  V[2].Init(0, 0, 1, 0);
  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitRotation(const AAxis: TVector3; const AAngle: Single);
var
  S, C, C1: Single;
  N: TVector3;
begin
  SinCos(AAngle, out S, out C);
  C1 := 1 - C;
  N := AAxis.Normalize;

  V[0].Init((C1 * N.X * N.X) + C,
            (C1 * N.X * N.Y) + (N.Z * S),
            (C1 * N.Z * N.X) - (N.Y * S), 0);


  V[1].Init((C1 * N.X * N.Y) - (N.Z * S),
            (C1 * N.Y * N.Y) + C,
            (C1 * N.Y * N.Z) + (N.X * S), 0);

  V[2].Init((C1 * N.Z * N.X) + (N.Y * S),
            (C1 * N.Y * N.Z) - (N.X * S),
            (C1 * N.Z * N.Z) + C, 0);

  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitRotationYawPitchRoll(const AYaw, APitch, ARoll: Single);
var
  A, S, C: TVector4;
begin
  A.Init(APitch, AYaw, ARoll, 0);
  SinCos(A, out S, out C);

  V[0].Init((C.Y * C.Z) + (S.X * S.Y * S.Z),
            (C.Y * S.X * S.Z) - (C.Z * S.Y),
            -C.X * S.Z, 0);

  V[1].Init(C.X * S.Y,
            C.X * C.Y,
            S.X, 0);

  V[2].Init((C.Y * S.Z) - (C.Z * S.X * S.Y),
           (-C.Z * C.Y * S.X) - (S.Z * S.Y),
             C.X * C.Z, 0);

  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.InitRotationHeadingPitchBank(const AHeading, APitch, ABank: Single);
var
  A, S, C: TVector4;
begin
  A.Init(AHeading, APitch, ABank, 0);
  SinCos(A, out S, out C);

  V[0].Init((C.X * C.Z) + (S.X * S.Y * S.Z),
           (-C.X * S.Z) + (S.X * S.Y * C.Z),
             S.X * C.Y, 0);

  V[1].Init(S.Z * C.Y,
            C.Y * C.Z,
           -S.Y, 0);

  V[2].Init((-S.X * C.Z) + (C.X * S.Y * S.Z),
             (S.Z * S.X) + (C.X * S.Y * C.Z),
              C.X * C.Y, 0);

  V[3].Init(0, 0, 0, 1);
end;

method TMatrix4.GetComponent(const ARow, AColumn: Integer): Single;
{$IF USEINLINE}
{$ELSE}
require
  (ARow >= 0) and (ARow < 4);
  (AColumn >= 0) and (AColumn < 4);
{$ENDIF}

begin
  Result := V[ARow][AColumn];
end;

method TMatrix4.GetRow(const AIndex: Integer): TVector4;
{$IF USEINLINE}
{$ELSE}
require
  (AIndex >= 0) and (AIndex < 4);
{$ENDIF}
begin
  Result := V[AIndex];
end;

method TMatrix4.Init(const ARow0, ARow1, ARow2, ARow3: TVector4);
begin
  V[0] := ARow0;
  V[1] := ARow1;
  V[2] := ARow2;
  V[3] := ARow3;
end;

method TMatrix4.InitOrthoLH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  V[0].Init(2 / AWidth, 0, 0, 0);
  V[1].Init(0, 2 / AHeight, 0, 0);
  V[2].Init(0, 0, 1 / (AZFarPlane - AZNearPlane), 0);
  V[3].Init(0, AZNearPlane / (AZNearPlane - AZFarPlane), 0, 1);
end;

method TMatrix4.InitOrthoRH(const AWidth, AHeight, AZNearPlane,
  AZFarPlane: Single);
begin
  V[0].Init(2 / AWidth, 0, 0, 0);
  V[1].Init(0, 2 / AHeight, 0, 0);
  V[2].Init(0, 0, 1 / (AZNearPlane - AZFarPlane), 0);
  V[3].Init(0, AZNearPlane / (AZNearPlane - AZFarPlane), 0, 1);
end;

method TMatrix4.InitOrthoOffCenterLH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  V[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  V[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  V[2].Init(0, 0, 1 / (AZFarPlane - AZNearPlane), 0);
  V[3].Init((ALeft + ARight) / (ALeft - ARight),
            (ATop + ABottom) / (ABottom - ATop),
            AZNearPlane / (AZNearPlane - AZFarPlane), 1);
end;

method TMatrix4.InitOrthoOffCenterRH(const ALeft, ATop, ARight, ABottom,
  AZNearPlane, AZFarPlane: Single);
begin
  V[0].Init(2 / (ARight - ALeft), 0, 0, 0);
  V[1].Init(0, 2 / (ATop - ABottom), 0, 0);
  V[2].Init(0, 0, 1 / (AZNearPlane - AZFarPlane), 0);
  V[3].Init((ALeft + ARight) / (ALeft - ARight),
            (ATop + ABottom) / (ABottom - ATop),
            AZNearPlane / (AZNearPlane - AZFarPlane), 1);
end;

method TMatrix4.InitPerspectiveFovLH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / Math.Tan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / Math.Tan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  V[0].Init(XScale, 0, 0, 0);
  V[1].Init(0, YScale, 0, 0);
  V[2].Init(0, 0, AFarPlaneDistance / (AFarPlaneDistance - ANearPlaneDistance), 1);
  V[3].Init(0, 0, (-ANearPlaneDistance * AFarPlaneDistance) / (AFarPlaneDistance - ANearPlaneDistance), 0);
end;

method TMatrix4.InitPerspectiveFovRH(const AFieldOfView, AAspectRatio,
  ANearPlaneDistance, AFarPlaneDistance: Single; const AHorizontalFOV: Boolean);
var
  XScale, YScale: Single;
begin
  if (AHorizontalFOV) then
  begin
    XScale := 1 / Math.Tan(0.5 * AFieldOfView);
    YScale := XScale / AAspectRatio;
  end
  else
  begin
    YScale := 1 / Math.Tan(0.5 * AFieldOfView);
    XScale := YScale / AAspectRatio;
  end;

  V[0].Init(XScale, 0, 0, 0);
  V[1].Init(0, YScale, 0, 0);
  V[2].Init(0, 0, AFarPlaneDistance / (ANearPlaneDistance - AFarPlaneDistance), -1);
  V[3].Init(0, 0, (ANearPlaneDistance * AFarPlaneDistance) / (ANearPlaneDistance - AFarPlaneDistance), 0);
end;

method TMatrix4.SetComponent(const ARow, AColumn: Integer; const Value: Single);
{$IF USEINLINE}
{$ELSE}
require
  (ARow >= 0) and (ARow < 4);
  (AColumn >= 0) and (AColumn < 4);
{$ENDIF}
begin
    V[ARow][AColumn] := Value;
end;


method TMatrix4.SetRow(const AIndex: Integer; const Value: TVector4);
{$IF USEINLINE}
{$ELSE}
require
  (AIndex >= 0) and (AIndex < 4);
{$ENDIF}
begin
  V[AIndex] := Value;
end;


method TMatrix4.getPglMatrix4f: ^Single;
begin
 exit @V[0].X;
end;
end.