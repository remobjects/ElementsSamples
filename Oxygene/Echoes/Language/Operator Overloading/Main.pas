namespace ComplexNumbers;

interface

type
  ConsoleApp = class
  public
    class method Main; 
  end;   

implementation

class method ConsoleApp.Main;
var
  x: Double;
  a,b: Complex;
begin
  a := 5.0;                 // operator Implicit
  a.Imaginary := -3;        
  Console.WriteLine(a.ToString);
  
  b := new Complex(2,9);
  Console.WriteLine(b);     
  Console.WriteLine(-b);    // operator Minus
  Console.WriteLine(a-b);   // operator Subtract
  
  x := Double(a);           // operator Explicit
  Console.WriteLine(x);   
  
  a := new Complex(3, 2);
  b := new Complex(4, 5);
  Console.WriteLine('a*b='+a*b);   
  Console.WriteLine('a/b='+a/b);   

  Console.ReadLine();
end;

end.
