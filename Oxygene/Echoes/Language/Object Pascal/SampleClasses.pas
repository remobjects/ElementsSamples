namespace Oxygene.Samples.SampleClasses;

interface

uses
  System,
  System.Collections;

type
  Gender = (Male, Female);
  MaritalStatus = (Single, Married, Divorced, Widdowed);
  
  Person = class
  private
    fSpouse: Person;
    fMaritalStatus: MaritalStatus;
    fNickName: string;
    
    method set_Spouse(aValue: Person);
    method set_MaritalStatus(aValue: MaritalStatus);
    method set_NickName(aValue: string);
    
  public
    constructor (aName: string; aAge: integer; aGender: Gender); virtual;

    method GenerateSSN: string;
    
    { Notice how Oxygene doesn't require the declaration of private fields to 
      store property values, thus making the code more compact and easier to read }
    property Name: string;
    property Age: integer;
    property Gender: Gender;
    property NickName: string read fNickName write set_NickName;
    property Address: PersonAddress := new PersonAddress();

    property MaritalStatus: MaritalStatus read fMaritalStatus write set_MaritalStatus;
    property Spouse: Person read fSpouse write set_Spouse;
        
  public invariants
    { These conditions are guaranteed to always be respected at the end of
      the execution of a non-private method of the Person class }
    Age >= 0;
    length(Name) > 0;
    (fMaritalStatus = MaritalStatus.Married) implies assigned(Spouse);
  end;
  
  PersonClass = class of Person;
  
  Employee = class(Person)
  private
  protected
    method get_Salary: Double;
    
  public
    property Salary: Double read get_Salary; 
  end;
  
  PersonCollection = class(CollectionBase)
  private
  protected
    { Type checking events }
    procedure OnInsert(aIndex: integer; aValue: Object); override;
    procedure OnValidate(aValue: Object); override;
    
    { Other methods }
    function GetPersonsByIndex(aIndex: integer): Person;
    function GetPersonsByName(aName: string): Person;
     
  public
    constructor;
    
    method Add(aName: string; aAge: integer; aGender: Gender): Person;
    method Add(aPerson: Person): integer;
    
    method IndexOf(aPerson: Person): integer;
    
    procedure Remove(aPerson: Person);
    
    { Notice the use of overloaded array properties }
    property Persons[anIndex: integer]: Person read GetPersonsByIndex; default;
    property Persons[aName: string]: Person read GetPersonsByName; default;
  end;
  
  PersonAddress = class
  public
    property City: string;
    property Street: string;
    property Zip: string; 
  end;
  
  { ECustomException }
  ECustomException = class(Exception);

implementation

{ Person }

constructor Person(aName: string; aAge: integer; aGender: Gender); 
begin
  inherited constructor;

  Name := aName;
  Age := aAge;
  Gender := aGender;
end;

method Person.GenerateSSN: string; 
var 
  lHashValue: integer;
begin
  { Generates a complex string with all the information we have and outputs a fake SSN
    using the String.Format method }
    
  lHashValue := (Age.ToString+'S'+Gender.ToString[2]+Name.GetHashCode.ToString).GetHashCode;
  if lHashValue < 0 then lHashValue := -lHashValue;
  
  result := String.Format('{0:000-00-0000}', lHashValue);
end;

method Person.set_NickName(aValue: string);
require
  aValue <> '';
begin
  fNickName := aValue;
ensure
  fNickName <> '';
end;

method Person.set_MaritalStatus(aValue: MaritalStatus);
begin
  if aValue <> fMaritalStatus then begin
    fMaritalStatus := aValue;
    if fMaritalStatus <> MaritalStatus.Married then Spouse := nil;
  end;
end;

method Person.set_Spouse(aValue: Person);
begin
  if aValue <> fSpouse then begin
    fSpouse := aValue;
    if Assigned(fSpouse) then 
      MaritalStatus := MaritalStatus.Married 
    else
      MaritalStatus := MaritalStatus.Single;
  end;
end;

{ PersonCollection }

constructor PersonCollection; 
begin
  inherited;
end;

method PersonCollection.Add(aName: string; aAge: integer; aGender: Gender): Person;
begin
  result := new Person(aName, aAge, aGender);
  List.Add(result);
end;

method PersonCollection.Add(aPerson: Person): integer; 
begin
  result := List.Add(aPerson);
end;

method PersonCollection.IndexOf(aPerson: Person): integer; 
begin
  result := List.IndexOf(aPerson);
end;

procedure PersonCollection.Remove(aPerson: Person); 
begin
  List.Remove(aPerson);
end;

function PersonCollection.GetPersonsByIndex(aIndex: integer): Person; 
begin
  result := List[aIndex] as Person;
end;

function PersonCollection.GetPersonsByName(aName: string): Person;
begin
  for each somebody: Person in List do
    if String.Compare(aName, somebody.Name, true) = 0 then 
      exit(somebody);
end;

procedure PersonCollection.OnInsert(aIndex: integer; aValue: Object); 
begin
  OnValidate(aValue);
end;

procedure PersonCollection.OnValidate(aValue: Object); 
begin
  { Notice the use of the "is not" syntax }
  if (aValue is not Person) then 
    raise new Exception('Not a Person');
end;

{ Employee }

method Employee.get_Salary: Double; 
begin
  case Age of
    0..15: Exit(0);
    16..24: Exit(15000);
    25..45: Exit(55000);
    else exit(75000);
  end;
end;

end.
