namespace NameSpaces.SubNameSpaceB;

interface

uses
  NameSpaces.SubNameSpaceA;
  
type
  { This class will be used in UnitA, namespace NameSpaces.SubNameSpaceA creating a 
    circular reference. Since Oxygene's namespace implementation is correct and complete,
    such declarations are perfectly valid. }
  Employee = class(Person)
  public
    property Salary : double;
  end;

implementation

end.
