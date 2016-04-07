namespace CirrusCache;

interface

uses
  System.Collections.Generic;

type
  Calculator = abstract class
  public
    method Calculate(aNumber: Int32): Int64; virtual; empty;
  end;

  // FibonacciNumberCalculator and CachedFibonacciNumberCalculator classes calculate Fibonacci numbers
  // Note that Calculate method implementations are the same in both classes

  // The only difference between these two classes if that latter is marked by
  // CalculatorInterface attriburte declared in CirrusCalculatorInterfaceAspectLibrary
  // This aspect add interface ICalculator to target class
  FibonacciNumberCalculator = class(Calculator)
  public
    method Calculate(aNumber: Int32): Int64; override;
  end;

  [Aspect:CirrusCalculatorInterfaceAspectLibrary.CalculatorInterface]
  CachedFibonacciNumberCalculator = class(Calculator)
  public
    method Calculate(aNumber: Int32): Int64; override;
  end;


implementation


method FibonacciNumberCalculator.Calculate(aNumber: Int32): Int64;
begin
  if (aNumber <= 1)  then
   exit (0);

  if (aNumber = 2)  then
   exit (1);

 exit  (self.Calculate(aNumber-2) + self.Calculate(aNumber-1));
end;


method CachedFibonacciNumberCalculator.Calculate(aNumber: Int32): Int64;
begin
  if (aNumber <= 1)  then
   exit (0);

  if (aNumber = 2)  then
   exit (1);

 exit  (self.Calculate(aNumber-2) + self.Calculate(aNumber-1));
end;


end.
