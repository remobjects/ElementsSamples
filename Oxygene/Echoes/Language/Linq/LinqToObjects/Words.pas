namespace LinqToObjects;

interface

uses
  System.Collections.Generic,
  System.Linq,
  System.Text;

type
  Words = public class
  private
    words : Array of String := ['hello', 'Oxygene', 'wonderful', 'linq', 'beautiful', 'world' ];
  public
    method SimpleSelect;
    method ComplexSelect;
  end;

implementation

method Words.SimpleSelect;
begin
  var shortwords := From word in words
                    Where word.Length <= 5
                    Select word;


  Console.WriteLine('Simple select statment');
  Console.WriteLine;

  for each word in shortwords do begin
    Console.WriteLine(word);
  end;

end;

method Words.ComplexSelect;
begin

  var groups := From word in words
                Order by word asc
                group word by word.Length into lengthGroups
                Order by lengthGroups.Key desc
                select new class (Length:=lengthGroups.Key,Words:=lengthGroups);


  Console.WriteLine('Complex query using group and order');
  Console.WriteLine;

  for each grupo in groups do begin
    Console.WriteLine('Words of length ' + grupo.Length);
    for each word in grupo.Words do
      Console.WriteLine('   ' + word);
  end;

end;

end.
