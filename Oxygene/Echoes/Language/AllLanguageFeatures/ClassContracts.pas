namespace AllLanguageFeatures;

interface

type
  ClassContracts = public class
  private
    var a,b,c,d: integer;
    class var x,y,z: string;
  public
    method bar; 
  private invariants
    a > b;
    a+b < c;
  public invariants
    a+b+c < d;
  private class invariants
    //assigned(z);
    //length(z) > 35;
  public class invariants
    //x+y = z;
  assembly 
    method foo; 
  end;
  
implementation

method ClassContracts.foo; 
require
  a > b < c;
begin
  bar();
end;

method ClassContracts.bar; 
begin
  foo();
ensure
  length(z) = old length(z)+5;
end;

end.