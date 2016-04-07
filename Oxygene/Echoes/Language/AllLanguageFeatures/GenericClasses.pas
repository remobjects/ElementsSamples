namespace AllLanguageFeatures;

interface

uses
  System.Collections.Generic;

type
  { a simple generic class }
  Generics1<T> = public class
  end;

  { consraints }
  Generics2<T> = public class
    where 
      T has constructor,
      T is class,
      T is IComparable;
  end;

  { 2 params, generic ancestors, methods }
  Generics2<TFoo, UBar> = public class(List<TFoo>, IEnumerable<Int32>)
    where 
      TFoo has constructor,
      UBar is record,
      UBar is IEnumerable<string>;
  public
    method GetEnumerator: IEnumerator<Int32>; empty; reintroduce;
    method Test;
  end;
  
implementation

method Generics2<TFoo, UBar>.Test;
begin
end;

end.