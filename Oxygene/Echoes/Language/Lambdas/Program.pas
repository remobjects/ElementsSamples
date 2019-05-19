namespace Lambdas;

interface
uses System.Collections.Generic,
     System.Linq;


type
  ConsoleApp = class
  public
    class method Main;
    method FillPersons();
    method Test();
    method SumAge(): Integer;
    var persons: List<Person>;
  end;

type
 Person = public class
    public
      property Name: String;
      property Age: Integer;

      constructor (setName: String; setAge: Integer);
    end;


implementation

class method ConsoleApp.Main;
begin
  Console.WriteLine('Lambdas example');
  Console.WriteLine;

  with lMyConsoleApp := new ConsoleApp() do begin
     lMyConsoleApp.FillPersons;
     lMyConsoleApp.Test;
  end;

  Console.ReadLine;
end;

method ConsoleApp.Test;
begin

  {Lambda expressions may not to return result and be used as actions}
  var printOut : Action<String> := s -> Console.WriteLine(s);

  {Multi-parameter Lambda}
  var printTwoStrings : Action<String, String> := (s1, s2) -> Console.WriteLine(s1 + s2);

  persons.Sort((p1, p2) -> p1.Name.CompareTo(p2.Name));

  {The result is sequence of values such as "John Smith (35)"}
  var personsNameAge := persons.Select(p -> p.Name + ' ('+p.Age.ToString+')');

  printOut('People:');
  for each p in personsNameAge do
     printOut(p.ToString);

  {Lambda expressions without parameters}
  var averageAge: future Integer := -> SumAge / persons.Count;

  printOut('');
  printTwoStrings('The average age is: ', averageAge.ToString);

  {Lambda expressions are most notable used with the Query Operators}
  var youngPersons := persons.Where(p -> p.Age < 30).OrderBy(p -> p.Age);

  printOut('');
  printOut('People, younger then 30, sorted by age:');

  for each p in youngPersons do
     printTwoStrings(p.Name, ' ('+p.Age.ToString+')');
end;

method ConsoleApp.SumAge: Integer;
begin
  var sum : Integer :=0;
  for each p in persons do
     sum := sum + p.Age;
  result := sum;
end;

constructor Person(setName: String; setAge: Integer);
begin
  self.Name := setName;
  self.Age := setAge;
end;

method ConsoleApp.FillPersons;
begin
  persons := new List<Person>;
  persons.AddRange([new Person('John Smith', 35), new Person('Lara Croft', 33), new Person ('Nancy Davolio', 22),
                    new Person ('Andrew Fuller', 30), new Person ('Janet Leverling', 26), new Person ('Margareth Peacock', 18),
                    new Person ('Steven Buchanan', 19), new Person ('Laura Callahan', 55), new Person ('James Bond', 29)]);
end;

end.