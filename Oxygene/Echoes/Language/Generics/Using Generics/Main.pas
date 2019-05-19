namespace Main;

interface

implementation

uses
  System.Collections.ObjectModel,  // Note: this sample requires Beta 2 of the .NET Framework 2.0
  System.Collections.Generic;

method GenericMethod;
var
  x: array of Integer;
  y: ReadOnlyCollection<Integer>;
  z: IList<String>;
begin
  x := [123,43,2,11];
  y := &Array.AsReadonly<Integer>(x);

  Console.Writeline('Readonly collection:');
  for each s in y do
    Console.Writeline(s);

  z := &Array.AsReadOnly<String>(['Welcome', 'to', 'Generics']);
  for each s: String in z do
    Console.Write(s+' ');
end;

method GenericClass;
var
  ListA: List<Integer>;
  ListB: List<String>;
  o: Object;
begin
  // instantiating generic types
  ListA := new List<Integer>;
  ListB := new List<String>;

  // calling methods
  ListA.Add(123);
  ListA.Add(65);
  //ListA.Add('bla');                         // x is typesafe, so this line will not compile
  ListB.Add('Hello');
  ListB.Add('World');

  // accessing index properties
  for i: Integer := 0 to ListA.Count-1 do
    Console.WriteLine((i+ListA[i]).ToString);

  for i: Integer := 0 to ListB.Count-1 do
    Console.Write(ListB[i]+' ');

  // casting to back generic types
  o := ListA;
  ListA := List<Integer>(o);
  //y := List<Integer>(o);                // compiler error: differently typed instances are not assignment compatible.
  ListB := List<String>(o);               // will equal to nil

  Console.Writeline;
end;

method Main;
begin
  GenericClass();
  GenericMethod();
  Console.ReadKey;
end;

end.