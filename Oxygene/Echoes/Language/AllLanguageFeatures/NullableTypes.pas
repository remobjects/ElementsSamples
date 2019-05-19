namespace AllLanguageFeatures;

interface

type
  NullableTypes = public class
  private
    x: nullable Int32;
    //#2340 y: array of nullable Int32 := new nullable Int32[50]; // Error	1	(PE2) Identifier expected	R:\Oxygene\Samples\Language\AllLanguageFeatures\AllLanguageFeatures\NullableTypes.pas	9	
    z: array of nullable Int32;
  protected
  public
    method Foo(j: nullable Int32);
  end;
  
implementation

method NullableTypes.Foo(j: nullable Int32); 
var
  a: nullable integer;
  b: integer;
begin
  a := 15;
  a := new nullable integer(15);
  a := nullable integer(15);
  b := integer(a);
  if assigned(a) then ;
  if a = nil then;
  if a <> nil then;
end;

end.