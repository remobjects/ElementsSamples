namespace LinkedList;

interface

type
  ConsoleApp = class
  public
    class method Main;
  end;

implementation

class method ConsoleApp.Main;
var
  lIntegers: List<Integer>;
  lStrings: List<String>;
begin
  lIntegers := new List<Integer>(5);
  lIntegers := new List<Integer>(7, lIntegers);
  lIntegers := new List<Integer>(20, lIntegers);
  Console.WriteLine(lIntegers.ToString());

  lStrings := new List<String>('Oxygene');
  lStrings := new List<String>('From', lStrings);
  lStrings := new List<String>('Generics', lStrings);
  lStrings := new List<String>('Using', lStrings);

  Console.WriteLine(lStrings.ToString());

  Console.WriteLine('Done.');
  Console.ReadLine();
end;

end.