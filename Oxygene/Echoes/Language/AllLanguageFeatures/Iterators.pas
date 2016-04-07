namespace AllLanguageFeatures;

interface

uses
  System.Collections,
  System.Collections.Generic;

type
  Iterators = public class
  private
  protected
  public
    method Foo: IEnumerator; iterator;
    method Bar: IEnumerator<Int32>; iterator;
  end;
  
implementation

method Iterators.Foo: IEnumerator; 
begin
end;

method Iterators.Bar: IEnumerator<Int32>; 
var
  i := 1;
begin
  loop begin
    yield(i);
    inc(i);  
    if i < 0 then break;
  end;
end;

end.