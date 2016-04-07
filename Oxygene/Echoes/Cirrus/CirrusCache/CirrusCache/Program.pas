namespace CirrusCache;

interface


type
  ConsoleApp = class
  public
    class method Main;
  end;


implementation


class method ConsoleApp.Main;
begin
  // We create array of 100 random numbers from 0 to 40 which will be used
  // as arguments when calculating Fibonacci numbers
  // So both cached and non-cached Fibonacci number calculators will use the
  // same set of arguments
  // After this we loop thru argument array and calculate Fibonacci number for
  // each element
  // After this simple statistics is displayed
  var lRndGenerator: Random := new Random();
  var lArgumentArray: array of Int32 := new Int32[100];
  for  I: Int32  :=  0  to  Length(lArgumentArray)-1  do
     lArgumentArray[I] := lRndGenerator.Next(40);

  var lFibonacciCalculator: Calculator := new FibonacciNumberCalculator();

  Console.WriteLine('Non-cached calculations started');
  var lCalculationsStart: DateTime := DateTime.Now;
  
  for  I: Int32  :=  0  to  Length(lArgumentArray)-1  do
    lFibonacciCalculator.Calculate(lArgumentArray[I]);

  var lCalculationsEnd: DateTime := DateTime.Now;
  var lNonCachedCalculationTime: Double := (lCalculationsEnd-lCalculationsStart).TotalMilliseconds;
  Console.WriteLine('Non-cached calculations finished');
  Console.WriteLine(String.Format('Calculations took {0} ms', lNonCachedCalculationTime));

  Console.WriteLine();
  Console.WriteLine();

  lFibonacciCalculator := new CachedFibonacciNumberCalculator();

  Console.WriteLine('Cached calculations started');
  lCalculationsStart := DateTime.Now;

  for  I: Int32  :=  0  to  Length(lArgumentArray)-1  do
    lFibonacciCalculator.Calculate(lArgumentArray[I]);

  lCalculationsEnd := DateTime.Now;
  var lCachedCalculationTime: Double := (lCalculationsEnd-lCalculationsStart).TotalMilliseconds;
  Console.WriteLine('Cached calculations finished');
  Console.WriteLine(String.Format('Calculations took {0} ms', lCachedCalculationTime));
  Console.WriteLine();
  Console.WriteLine(String.Format('Cached calculations were {0:#.0} times faster', lNonCachedCalculationTime/lCachedCalculationTime));

  Console.ReadLine();
end;


end.
