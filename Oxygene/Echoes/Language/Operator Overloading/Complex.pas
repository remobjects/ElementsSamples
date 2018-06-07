namespace ComplexNumbers;

interface

type
  Complex = public class
  private
    property Size: Double read Real*Imaginary;
  protected
  public
    constructor; empty;
    constructor (aReal, aImaginary: Double);

    property Real: Double;
    property Imaginary: Double;

    method ToString: String; override;

    class operator Add(aOperand1: Complex; aOperand2: Complex): Complex;
    class operator Subtract(aOperand1: Complex; aOperand2: Complex): Complex;
    class operator Multiply(aOperand1: Complex; aOperand2: Complex): Complex;
    class operator Divide(aOperand1: Complex; aOperand2: Complex): Complex;

    class operator Equal(aOperand1: Complex; aOperand2: Complex): Boolean;

    class operator Less(aOperand1: Complex; aOperand2: Complex): Boolean;
    class operator LessOrEqual(aOperand1: Complex; aOperand2: Complex): Boolean;
    class operator Greater(aOperand1: Complex; aOperand2: Complex): Boolean;
    class operator GreaterOrEqual(aOperand1: Complex; aOperand2: Complex): Boolean;

    class operator Minus(aOperand: Complex): Complex;
    class operator Plus(aOperand: Complex) : Complex;

    class operator Explicit(aValue: Complex): Double;
    class operator Implicit(aValue: Double): Complex;
    class operator Implicit(aValue: Int32): Complex;
  end;

implementation

constructor Complex(aReal, aImaginary: Double);
begin
  Real := aReal;
  Imaginary := aImaginary;
end;

class operator Complex.Add(aOperand1 : Complex; aOperand2 : Complex) : Complex;
begin
  result := new Complex(aOperand1.Real+aOperand2.Real, aOperand1.Imaginary+aOperand2.Imaginary);
end;

class operator Complex.Subtract(aOperand1 : Complex; aOperand2 : Complex) : Complex;
begin
  result := new Complex(aOperand1.Real-aOperand2.Real, aOperand1.Imaginary-aOperand2.Imaginary);
end;

class operator Complex.Multiply(aOperand1 : Complex; aOperand2 : Complex) : Complex;
var
  lReal, lImaginary: Double;
begin
  //
  // (a + ib)(c + id) = (ac - bd) + i(bc + ad)
  //
  lReal := aOperand1.Real*aOperand2.Real - aOperand1.Imaginary*aOperand2.Imaginary;
  lImaginary := aOperand1.Imaginary*aOperand2.Real + aOperand1.Real*aOperand2.Imaginary;
  result := new Complex(lReal, lImaginary);
end;

class operator Complex.Divide(aOperand1 : Complex; aOperand2 : Complex) : Complex;
var
  lReal, lImaginary, lDivisor: Double;
begin
  //
  // (a + ib)(c + id) = (ac + bd)/(c�+d�) + i(bc - ad)/(c�+d�)
  //
  lDivisor := (aOperand2.Real*aOperand2.Real + aOperand2.Imaginary*aOperand2.Imaginary);

  lReal := (aOperand1.Real*aOperand2.Real + aOperand1.Imaginary*aOperand2.Imaginary) / lDivisor;
  lImaginary := (aOperand1.Imaginary*aOperand2.Real - aOperand1.Real*aOperand2.Imaginary) / lDivisor;
  result := new Complex(lReal, lImaginary);
end;

{ Unary Operators }

class operator Complex.Minus(aOperand: Complex): Complex;
begin
  result := new Complex(-aOperand.Real, -aOperand.Imaginary);
end;

class operator Complex.Plus(aOperand: Complex) : Complex;
begin
  result := aOperand;
end;

{ Comparison operators }

class operator Complex.Equal(aOperand1 : Complex; aOperand2 : Complex): boolean;
begin
  result := (aOperand1.Real = aOperand2.Real) and (aOperand1.Imaginary = aOperand2.Imaginary);
end;

class operator Complex.Less(aOperand1: Complex; aOperand2: Complex): boolean;
begin
  result := aOperand1.Size < aOperand2.Size;
end;

class operator Complex.LessOrEqual(aOperand1: Complex; aOperand2: Complex): boolean;
begin
  result := aOperand1.Size <= aOperand2.Size;
end;

class operator Complex.Greater(aOperand1: Complex; aOperand2: Complex): boolean;
begin
  result := aOperand1.Size > aOperand2.Size;
end;

class operator Complex.GreaterOrEqual(aOperand1: Complex; aOperand2: Complex): boolean;
begin
  result := aOperand1.Size >= aOperand2.Size;
end;


{ Cast Operators }

class operator Complex.Explicit(aValue: Complex): Double;
begin
  result := aValue.Real;
end;

class operator Complex.Implicit(aValue: Double): Complex;
begin
  result := new Complex(aValue, 0)
end;

class operator Complex.Implicit(aValue: Int32): Complex;
begin
  result := new Complex(aValue, 0)
end;

method Complex.ToString: string;
begin
  if (Real = 0) and (Imaginary = 0) then
    result := '0'//'.ToString
  else if (Imaginary = 0) then
    result := Real.ToString
  else if (Real = 0) then
    result := Imaginary.ToString+'i'
  else if (Imaginary < 0) then
    result := Real.ToString+Imaginary.ToString+'i'
  else
    result := Real.ToString+'+'+Imaginary.ToString+'i';
end;

end.