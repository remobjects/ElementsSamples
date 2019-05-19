namespace LinqToObjects;

interface

uses
  System.Linq;

type
  ConsoleApp = class
  public
    class method Main;
  end;

implementation

class method ConsoleApp.Main;
begin

  var words := new Words;

  words.SimpleSelect;

  Console.WriteLine;
  Console.WriteLine;
  Console.WriteLine;

  words.ComplexSelect;

  Console.WriteLine;
  Console.WriteLine;
  Console.WriteLine;

  Console.Read
end;

end.