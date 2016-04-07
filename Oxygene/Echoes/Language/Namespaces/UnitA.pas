namespace NameSpaces.SubNameSpaceA;

interface

uses
  NameSpaces.SubNameSpaceB;

type
  Person = class
  public
    property Name : string;
  end;
  
  { This class descends from Employee, which is declared in the file UnitB.
    Notice how this class introduces a circular reference with the file UnitB, but that
    doesn't stop Oxygene from compiling the project properly. }
  President = class(Employee)
  public
    property OwnsMercedes : boolean;
  end;
  
implementation

end.
