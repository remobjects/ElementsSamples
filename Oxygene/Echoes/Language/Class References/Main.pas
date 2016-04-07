namespace ClassRefs;

interface

type
  Class1 = public class
  public
    constructor; virtual;
    class method TestIt; virtual;
  end;

  Class2 = assembly class(Class1)
  public
    constructor; override;
    class method TestIt; override;
  end;
  
  AClass = class of Class1;

implementation

method ClassReferenceTest(var aClassToUse: AClass);
var
  instance: Class1;
begin
  { The following line shows how you can invoke methods marked as "class" without an instance
    of the class. Class methods allow you to create objects such as the standard Convert, which
    basically are repository of quick methods that don't require state or an object instance. 
    This is the preferred approach to write equivalents of functions in old Delphi libraries
    such as SysUtils or Math. }

  aClassToUse.TestIt;
  Console.WriteLine('Actual Type: '+aClassToUse.ActualType.Name);

  Console.WriteLine('');
  
  { The following code shows how you can use a class type to create an instance of an object
    of the type held by "aClassToUse". This mimics old Delphi myvar := myclass.Create kind
    of code. If the constrctor of Class1 had parameters, you could have specified them this way:
       cls := aClassToUse.New('A String', 123, <etc>); }
  instance := aClassToUse.New;

  Console.WriteLine('Created instance of type: '+instance.ActualType.Name);
end;

{ The "Main" global method is the application entry point. 
  Its code will be executed automatically when the application is run. }
method Main;
var
  cls: AClass;
begin
  Console.WriteLine('Class Reference Sample');
  Console.WriteLine('');

  cls := Class1;
  ClassReferenceTest(var cls);
  
  cls := Class2;
  ClassReferenceTest(var cls);
  
  Console.ReadLine;
end;

constructor Class2;
begin
  inherited; // Virtual constructors can call the inheried constructor.
  Console.WriteLine('Constructing a Class2. This constructor overrides and calls the anchestor''s.');
end;

class method Class2.TestIt;
begin
  inherited; // Class methods can call the inherited implementation.
  Console.WriteLine('Calling the class method TestIt from Class2. This method overrides and calls the anchestor''s.');
end;

constructor Class1;
begin
  Console.WriteLine('Constructing a Class1');
end;

class method Class1.TestIt;
begin
  Console.WriteLine('Calling the class method TestIt from Class1');
end;

end.
