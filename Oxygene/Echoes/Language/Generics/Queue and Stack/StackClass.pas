namespace OxygeneStack;

interface

type
  StackItem<T> = class
  public
    property Data: T;
    property Prev: StackItem<T>;    
  end;  

  Stack<T> = public class
  private
    property Top: StackItem<T>;    
  public  
    method Count: integer;
    method Pop: T;
    method Push(aData: T);
  end;

implementation
  
method Stack<T>.Pop: T;
begin
  if Top=nil then 
    raise new Exception('Empty Stack');
    
  Result := Top.Data;
  Top := Top.Prev;
end;
  
method Stack<T>.Push(aData: T);
var last: StackItem<T>;
begin
  last := Top;  // may be nil
  Top := new StackItem<T>;
  Top.Data := aData;
  Top.Prev := last;
end;

method Stack<T>.Count: integer; 
var last: StackItem<T>;
begin
  if Top = nil then exit(0);
  
  last := Top;
  repeat
    inc(Result);
    last := last.Prev;
  until last = nil;  
end;

end.
