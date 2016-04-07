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
  lIntegers: List<integer>;
  lStrings: List<String>;
begin
  lIntegers := new List<integer>(5);
  lIntegers := new List<integer>(7, lIntegers);
  lIntegers := new List<integer>(20, lIntegers);
  Console.WriteLine(lIntegers.ToString());
  
  lStrings := new List<string>('Oxygene');
  lStrings := new List<string>('From', lStrings);
  lStrings := new List<string>('Generics', lStrings);
  lStrings := new List<string>('Using', lStrings);

  Console.WriteLine(lStrings.ToString());
  
  Console.WriteLine('Done.');
  Console.ReadLine();
end;

end.
