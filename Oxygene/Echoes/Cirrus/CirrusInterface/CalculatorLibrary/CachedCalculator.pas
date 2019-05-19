namespace CalculatorLibrary;

interface

type
  ICalculator = public interface
    method Calculate(const aArgument: Int32): Int64;
  end;

  // Very simple cached calculator declaration that uses object
  // of type ICalculator to perform calculations
  CachedCalculator = public sealed class
  private
    var fCalculator: ICalculator;
    var fCache: System.Collections.Generic.IDictionary<Int32,Int64>;
  public
    constructor(aCalculator: ICalculator);
    method Calculate(const aArgument: Int32): Int64;
    method ClearCache();
  end;
  

implementation


constructor CachedCalculator(aCalculator: ICalculator);
begin
  self.fCalculator := aCalculator;
  self.fCache := new System.Collections.Generic.Dictionary<Int32,Int64>();
end;


method CachedCalculator.Calculate(const aArgument: Int32): Int64;
begin
  if  (self.fCache.ContainsKey(aArgument))  then
    exit  (self.fCache[aArgument]);

  var lMethodResult: Int64 := self.fCalculator.Calculate(aArgument);

  self.fCache.Add(aArgument, lMethodResult);

  exit  (lMethodResult);
end;


method CachedCalculator.ClearCache();
begin
  self.fCache.Clear();
end;


end.
