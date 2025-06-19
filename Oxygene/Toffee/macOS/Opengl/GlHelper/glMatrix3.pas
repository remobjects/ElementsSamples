
namespace GlHelper;

interface



type
  { A 3x3 matrix in row-major order (M[Row, Column]).
    You can access the elements directly using M[0,0]..M[2,2] or m11..m33.
    You can also access the matrix using its three rows R[0]..R[2] (which map
    directly to the elements M[]).

}
  TMatrix3 = public record

  private

    method GetComponent(const ARow, AColumn: Integer): Single; inline;
    method SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    method GetRow(const AIndex: Integer): TVector3;
    method SetRow(const AIndex: Integer; const Value: TVector3);

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


    { Initializes the matrix using three row vectors.

      Parameters:
        ARow0: the first row of the matrix.
        ARow1: the second row of the matrix.
        ARow2: the third row of the matrix. }
    method Init(const ARow0, ARow1, ARow2: TVector3);

{ Initializes the matrix using a Tmatrix4.

      Parameters:
        ARow0: the Matrix.
        ARow1: the second row of the matrix.
        ARow2: the third row of the matrix. }
    method Init(const AMatrix : TMatrix4);

    { Initializes the matrix with explicit values.

      Parameters:
        A11-A33: the values of the matrix elements, in row-major order. }
    method Init(const A11, A12, A13, A21, A22, A23, A31, A32, A33: Single);


    { Creates a scaling matrix that scales uniformly.

      Parameters:
        AScale: the uniform scale factor }
    method InitScaling(const AScale: Single);

    { Creates a scaling matrix.

      Parameters:
        AScaleX: the value to scale by on the X axis
        AScaleY: the value to scale by on the Y axis }
    method InitScaling(const AScaleX, AScaleY: Single);

    { Creates a scaling matrix.

      Parameters:
        AScale: the scale factors }
    method InitScaling(const AScale: TVector2);

    { Creates a translation matrix.

      Parameters:
        ADeltaX: translation in the X direction
        ADeltaY: translation in the Y direction }
    method InitTranslation(const ADeltaX, ADeltaY: Single);

    { Creates a translation matrix.

      Parameters:
        ADelta: translation vector }
    method InitTranslation(const ADelta: TVector2);

    { Creates a rotation the matrix using a rotation angle in radians.

      Parameters:
        AAngle: the rotation angle in radians }
    method InitRotation(const AAngle: Single);


    { Checks two matrices for equality.

      Returns:
        True if the two matrices match each other exactly. }
    class operator Equal(const A, B: TMatrix3): Boolean; inline;

    { Checks two matrices for inequality.

      Returns:
        True if the two matrices are not equal. }
    class operator NotEqual(const A, B: TMatrix3): Boolean; inline;

    { Negates a matrix.

      Returns:
        The negative value of the matrix (with all elements negated). }
    class operator Minus(const A: TMatrix3): TMatrix3; inline;

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: TMatrix3; const B: Single): TMatrix3; inline;

    { Adds a scalar value to each element of a matrix. }
    class operator Add(const A: Single; const B: TMatrix3): TMatrix3; inline;

    { Adds two matrices component-wise. }
    class operator Add(const A, B: TMatrix3): TMatrix3; inline;

    { Subtracts a scalar value from each element of a matrix. }
    class operator Subtract(const A: TMatrix3; const B: Single): TMatrix3; inline;

    { Subtracts a matrix from a scalar value. }
    class operator Subtract(const A: Single; const B: TMatrix3): TMatrix3; inline;

    { Subtracts two matrices component-wise. }
    class operator Subtract(const A, B: TMatrix3): TMatrix3; inline;

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: TMatrix3; const B: Single): TMatrix3; inline;

    { Multiplies a matrix with a scalar value. }
    class operator Multiply(const A: Single; const B: TMatrix3): TMatrix3; inline;

    { Performs a matrix * row vector linear algebraic multiplication. }
    class operator Multiply(const A: TMatrix3; const B: TVector3): TVector3; inline;

    { Performs a column vector * matrix linear algebraic multiplication. }
    class operator Multiply(const A: TVector3; const B: TMatrix3): TVector3; inline;

    { Multiplies two matrices using linear algebraic multiplication. }
    class operator Multiply(const A, B: TMatrix3): TMatrix3; inline;

    { Divides a matrix by a scalar value. }
    class operator Divide(const A: TMatrix3; const B: Single): TMatrix3; inline;

    { Divides a scalar value by a matrix. }
    class operator Divide(const A: Single; const B: TMatrix3): TMatrix3; inline;

    { Divides a matrix by a vector. This is equivalent to multiplying the
      inverse of the matrix with a row vector using linear algebraic
      multiplication. }
    class operator Divide(const A: TMatrix3; const B: TVector3): TVector3; inline;

    { Divides a vector by a matrix. This is equivalent to multiplying a column
      vector with the inverse of the matrix using linear algebraic
      multiplication. }
    class operator Divide(const A: TVector3; const B: TMatrix3): TVector3; inline;

    { Divides two matrices. This is equivalent to multiplying the first matrix
      with the inverse of the second matrix using linear algebraic
      multiplication. }
    class operator Divide(const A, B: TMatrix3): TMatrix3; inline;

    { Multiplies this matrix with another matrix component-wise.

      Parameters:
        AOther: the other matrix.

      Returns:
        This matrix multiplied by AOther component-wise.
        That is, Result.M[I,J] := M[I,J] * AOther.M[I,J].

      @bold(Note): For linear algebraic matrix multiplication, use the multiply
      (*) operator instead. }
    method CompMult(const AOther: TMatrix3): TMatrix3; inline;

    { Creates a transposed version of this matrix.

      Returns:
        The transposed version of this matrix.

      @bold(Note): Does not change this matrix. To update this itself, use
      SetTransposed. }
    method Transpose: TMatrix3; inline;

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
    method Inverse: TMatrix3; inline;

    { Inverts this matrix.

      @bold(Note): If you do not want to change this matrix, but get an
      inversed version instead, then use Inverse.

      @bold(Note): The values in the inversed matrix are undefined if this
      matrix is singular or poorly conditioned (nearly singular). }
    method SetInversed;

        { Returns the rows of the matrix. This is identical to accessing the
      V-field.

      Parameters:
        AIndex: index of the row to return (0-2). Range is checked with
          an assertion. }
    property Rows[const AIndex: Integer]: TVector3 read GetRow write SetRow;
    property M[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;


    { The determinant of this matrix. }
    property Determinant: Single read GetDeterminant;
     method getPglMatrix3f : ^Single;
  public

      { Row  vectors}
      V: array [0..2] of TVector3;
     
     
      property m11 : Single read GetComponent(0,0);
      property m12 : Single read GetComponent(0,1);
      property m13 : Single read GetComponent(0,2);

      property m21 : Single read GetComponent(1,0);
      property m22 : Single read GetComponent(1,1);
      property m23 : Single read GetComponent(1,2);

      property m31 : Single read GetComponent(2,0);
      property m32 : Single read GetComponent(2,1);
      property m33 : Single read GetComponent(2,2);

  end;

implementation

{ TMatrix3 }

class operator TMatrix3.Add(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
end;

class operator TMatrix3.Add(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A + B.V[0];
  Result.V[1] := A + B.V[1];
  Result.V[2] := A + B.V[2];
end;

class operator TMatrix3.Add(const A, B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
end;

method TMatrix3.CompMult(const AOther: TMatrix3): TMatrix3;
var
  I: Integer;
begin
  for I := 0 to 2 do
    Result.V[I] := V[I] * AOther.V[I];
end;

class operator TMatrix3.Divide(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A / B.V[0];
  Result.V[1] := A / B.V[1];
  Result.V[2] := A / B.V[2];
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: Single): TMatrix3;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
end;

class operator TMatrix3.Multiply(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A * B.V[0];
  Result.V[1] := A * B.V[1];
  Result.V[2] := A * B.V[2];
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
end;

class operator TMatrix3.Multiply(const A: TMatrix3; const B: TVector3): TVector3;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]);
end;

class operator TMatrix3.Multiply(const A: TVector3; const B: TMatrix3): TVector3;
begin
  Result.X := (B.M[0,0] * A.X) + (B.M[1,0] * A.Y) + (B.M[2,0] * A.Z);
  Result.Y := (B.M[0,1] * A.X) + (B.M[1,1] * A.Y) + (B.M[2,1] * A.Z);
  Result.Z := (B.M[0,2] * A.X) + (B.M[1,2] * A.Y) + (B.M[2,2] * A.Z);
end;

class operator TMatrix3.Multiply(const A, B: TMatrix3): TMatrix3;
var
  A00, A01, A02, A10, A11, A12, A20, A21, A22: Single;
  B00, B01, B02, B10, B11, B12, B20, B21, B22: Single;
begin
  A00 := A.M[0,0];
  A01 := A.M[0,1];
  A02 := A.M[0,2];
  A10 := A.M[1,0];
  A11 := A.M[1,1];
  A12 := A.M[1,2];
  A20 := A.M[2,0];
  A21 := A.M[2,1];
  A22 := A.M[2,2];

  B00 := B.M[0,0];
  B01 := B.M[0,1];
  B02 := B.M[0,2];
  B10 := B.M[1,0];
  B11 := B.M[1,1];
  B12 := B.M[1,2];
  B20 := B.M[2,0];
  B21 := B.M[2,1];
  B22 := B.M[2,2];


  Result.M[0,0] := (A00 * B00) + (A01 * B10) + (A02 * B20);
  Result.M[0,1] := (A00 * B01) + (A01 * B11) + (A02 * B21);
  Result.M[0,2] := (A00 * B02) + (A01 * B12) + (A02 * B22);
  Result.M[1,0] := (A10 * B00) + (A11 * B10) + (A12 * B20);
  Result.M[1,1] := (A10 * B01) + (A11 * B11) + (A12 * B21);
  Result.M[1,2] := (A10 * B02) + (A11 * B12) + (A12 * B22);
  Result.M[2,0] := (A20 * B00) + (A21 * B10) + (A22 * B20);
  Result.M[2,1] := (A20 * B01) + (A21 * B11) + (A22 * B21);
  Result.M[2,2] := (A20 * B02) + (A21 * B12) + (A22 * B22);

end;

class operator TMatrix3.Minus(const A: TMatrix3): TMatrix3;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
end;

method TMatrix3.SetTransposed;
begin
  Self := Transpose;
end;

class operator TMatrix3.Subtract(const A: TMatrix3; const B: Single): TMatrix3;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
end;

class operator TMatrix3.Subtract(const A, B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
end;

class operator TMatrix3.Subtract(const A: Single; const B: TMatrix3): TMatrix3;
begin
  Result.V[0] := A - B.V[0];
  Result.V[1] := A - B.V[1];
  Result.V[2] := A - B.V[2];
end;

method TMatrix3.Transpose: TMatrix3;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
end;

class operator TMatrix3.Divide(const A, B: TMatrix3): TMatrix3;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix3.Divide(const A: TVector3; const B: TMatrix3): TVector3;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix3.Divide(const A: TMatrix3; const B: TVector3): TVector3;
begin
  Result := A.Inverse * B;
end;

method TMatrix3.GetDeterminant: Single;
begin
  Result :=
    + (M[0,0] * ((M[1,1] * M[2,2]) - (M[2,1] * M[1,2])))
    - (M[0,1] * ((M[1,0] * M[2,2]) - (M[2,0] * M[1,2])))
    + (M[0,2] * ((M[1,0] * M[2,1]) - (M[2,0] * M[1,1])));
end;

method TMatrix3.Inverse: TMatrix3;
var
  OneOverDeterminant: Single;
begin
  OneOverDeterminant := 1 / Determinant;
  Result.M[0,0] := + ((M[1,1] * M[2,2]) - (M[2,1] * M[1,2])) * OneOverDeterminant;
  Result.M[1,0] := - ((M[1,0] * M[2,2]) - (M[2,0] * M[1,2])) * OneOverDeterminant;
  Result.M[2,0] := + ((M[1,0] * M[2,1]) - (M[2,0] * M[1,1])) * OneOverDeterminant;
  Result.M[0,1] := - ((M[0,1] * M[2,2]) - (M[2,1] * M[0,2])) * OneOverDeterminant;
  Result.M[1,1] := + ((M[0,0] * M[2,2]) - (M[2,0] * M[0,2])) * OneOverDeterminant;
  Result.M[2,1] := - ((M[0,0] * M[2,1]) - (M[2,0] * M[0,1])) * OneOverDeterminant;
  Result.M[0,2] := + ((M[0,1] * M[1,2]) - (M[1,1] * M[0,2])) * OneOverDeterminant;
  Result.M[1,2] := - ((M[0,0] * M[1,2]) - (M[1,0] * M[0,2])) * OneOverDeterminant;
  Result.M[2,2] := + ((M[0,0] * M[1,1]) - (M[1,0] * M[0,1])) * OneOverDeterminant;
end;

method TMatrix3.SetInversed;
begin
  Self := Inverse;
end;

class operator TMatrix3.Equal(const A, B: TMatrix3): Boolean;
begin
  Result := (A.V[0] = B.V[0]) and (A.V[1] = B.V[1]) and (A.V[2] = B.V[2]);
end;

method TMatrix3.Init(const ADiagonal: Single);
begin
  V[0].Init(ADiagonal, 0, 0);
  V[1].Init(0, ADiagonal, 0);
  V[2].Init(0, 0, ADiagonal);
end;

method TMatrix3.Init;
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(0, 0, 1);
end;

method TMatrix3.Init(const AMatrix : TMatrix4);
begin
 V[0].Init(AMatrix.V[0].X, AMatrix.V[0].Y, AMatrix.V[0].Z);
 V[1].Init(AMatrix.V[1].X, AMatrix.V[1].Y, AMatrix.V[1].Z);
 V[2].Init(AMatrix.V[2].X, AMatrix.V[2].Y, AMatrix.V[2].Z);
end;

method TMatrix3.Init(const A11, A12, A13, A21, A22, A23, A31, A32,
  A33: Single);
begin
  V[0].Init(A11, A12, A13);
  V[1].Init(A21, A22, A23);
  V[2].Init(A31, A32, A33);
end;

method TMatrix3.InitScaling(const AScale: Single);
begin
  V[0].Init(AScale, 0, 0);
  V[1].Init(0, AScale, 0);
  V[2].Init(0, 0, 1);
end;

method TMatrix3.InitScaling(const AScaleX, AScaleY: Single);
begin
  V[0].Init(AScaleX, 0, 0);
  V[1].Init(0, AScaleY, 0);
  V[2].Init(0, 0, 1);
end;

method TMatrix3.InitScaling(const AScale: TVector2);
begin
  V[0].Init(AScale.X, 0, 0);
  V[1].Init(0, AScale.Y, 0);
  V[2].Init(0, 0, 1);
end;

method TMatrix3.InitTranslation(const ADeltaX, ADeltaY: Single);
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(ADeltaX, ADeltaY, 1);
end;

method TMatrix3.InitTranslation(const ADelta: TVector2);
begin
  V[0].Init(1, 0, 0);
  V[1].Init(0, 1, 0);
  V[2].Init(ADelta.X, ADelta.Y, 1);
end;

class operator TMatrix3.NotEqual(const A, B: TMatrix3): Boolean;
begin
  Result := (A.V[0] <> B.V[0]) or (A.V[1] <> B.V[1]) or (A.V[2] <> B.V[2]);
end;

method TMatrix3.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := V[ARow][AColumn];
end;

method TMatrix3.GetRow(const AIndex: Integer): TVector3;
begin
  Result := V[AIndex];
end;

method TMatrix3.Init(const ARow0, ARow1, ARow2: TVector3);
begin
  V[0] := ARow0;
  V[1] := ARow1;
  V[2] := ARow2;
end;

method TMatrix3.InitRotation(const AAngle: Single);
var
  S, C: Single;
begin
  SinCos(AAngle, out S, out C);
  V[0].Init(C, S, 0);
  V[1].Init(-S, C, 0);
  V[2].Init(0, 0, 1);
end;

method TMatrix3.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  V[ARow][ AColumn] := Value;
end;

method TMatrix3.SetRow(const AIndex: Integer; const Value: TVector3);
begin
  V[AIndex] := Value;
end;




method TMatrix3.getPglMatrix3f: ^Single;
begin
 exit @V[0].X;
end;

end.