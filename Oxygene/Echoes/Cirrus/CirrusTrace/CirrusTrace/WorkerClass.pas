namespace CirrusTrace;

interface

type
  // Aspect declared in CirrusTraceAspectLibrary is applied to this class
  // Build and start the application to see how it will affect the behaviour of
  // Sum and Multiply methods
  [CirrusTraceAspectLibrary.Trace]
  WorkerClass = class
  public
    method Sum(aValueA: Int32; aValueB: Int32): Int32; virtual;
    method Multiply(aValueA: Int32; aValueB: Int32; aValueC: Int32): Int32; virtual;
  end;


implementation


method WorkerClass.Sum(aValueA: Int32; aValueB: Int32): Int32;
begin
  Console.WriteLine('Sum method is processing data');
  exit (aValueA + aValueB);
end;


method WorkerClass.Multiply(aValueA: Int32; aValueB: Int32; aValueC: Int32): Int32;
begin
  Console.WriteLine('Multiply method is processing data');
  exit (aValueA * aValueB * aValueC);
end;


end.