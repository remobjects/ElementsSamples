namespace Extension_Methods;

interface

uses  
  System.Runtime.CompilerServices, 
  System.Collections.Generic, 
  System.Text;

type
  ConsoleApp = class
  public
    class method Main;
  end;

//Old Extension Methods Syntax
//Interface Extension
//Now each object of class derived from IEnumerable will have an Implode method regardless of it's elements type
type 
  [Extension]
  EnumerableExtender = public static class

  private
  public
    [Extension]
    class method Implode<T>(parts : IEnumerable<T>; glue : String) : String;
  end;

//New Extension Methods Syntax
//Defining an extension method is done by defining the method outside of any class and prefixing it with extension
//Extension of class Integer:
extension method Integer.IterateTo(endWith : Int32; interval: Int32; action: Action<Int32> );

implementation

class method ConsoleApp.Main;
begin
  //sequence implemets IEnumerable
  var numbers : sequence of Int32 := [1, 2, 3, 4, 5];
  Console.WriteLine("Integer sequence:");
  Console.WriteLine(numbers.Implode(', '));
  Console.WriteLine();

  //Queue implemets IEnumerable
  var dates : Queue<DateTime> := new Queue<DateTime>;
  dates.Enqueue(DateTime.Now.Date.AddDays(-1)); dates.Enqueue(DateTime.Now.Date); dates.Enqueue(DateTime.Now.Date.AddDays(1));
  Console.WriteLine("DateTime queue:");
  Console.WriteLine(dates.Implode(', then '));

  Console.WriteLine();

  var two: Int32 :=2; 
  //Iterate from 2 to 10 with interval 1
  two.IterateTo(10, 1, i -> Console.WriteLine(i));
  
  Console.WriteLine();

  var negativeTen: Int32 := -10;
  //Iterate from -10 to -30 with interval 5
  negativeTen.IterateTo(-30, 5, c -> Console.Write(c+" "));

  Console.ReadLine();
end;

class method EnumerableExtender.Implode<T>(parts: IEnumerable<T>; glue: String): String;
begin
  var sb := new StringBuilder;
  for p in parts do
  begin
    sb.Append(p);
    sb.Append(glue);
  end;
  sb.Remove(sb.Length-glue.Length, glue.Length);
  result := sb.ToString;
end;

extension method Integer.IterateTo(endWith, interval: Int32; action: Action<Int32>);
begin
  var prefix : Int32;

  var modify : Func<Int32, Int32> := x -> x + interval;

  if (endWith < self) then prefix := -1 else prefix := 1;
   
  var i : Int32 := prefix * self;
  while i <= prefix * endWith do 
    begin
      action(prefix * i);
      i := modify(i);
    end;
end;

end.