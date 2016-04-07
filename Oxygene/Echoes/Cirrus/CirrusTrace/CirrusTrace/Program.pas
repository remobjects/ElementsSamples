namespace CirrusTrace;

interface


type
  ConsoleApp = class
  public
    class method Main;
  end;


implementation

// Here several methods of WorkerClass will be called to show how
// its implementation was changed
class method ConsoleApp.Main;
begin
  var lWorker: WorkerClass := new WorkerClass();
  Console.WriteLine();

  Console.WriteLine(String.Format('Result of Sum({0}, {1}) is {2}', 5, 7, lWorker.Sum(5,7)));
  Console.WriteLine();

  Console.WriteLine(String.Format('Result of Multiply({0}, {1}, {2}) is {3}', 5, 7, 2, lWorker.Multiply(5,7,2)));

  Console.ReadLine();
end;


end.
