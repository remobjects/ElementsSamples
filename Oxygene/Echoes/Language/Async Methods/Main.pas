namespace Project2;

interface

type
  ConsoleApp = class
  private
  public
    class method Main;
    method Test(aIdentifier: integer); async;
  end;

implementation

class method ConsoleApp.Main;
begin
  Console.WriteLine('Asynch method example');
  with lMyConsoleApp := new ConsoleApp() do begin

    { The following loop will start 5 threads that will execute asynchronously }
    for i: integer := 0 to 4 do 
      lMyConsoleApp.Test(i);

    { This code will be executed BEFORE all the Test methods have completed their execution }
    Console.WriteLine('All 5 threads have been spawned!');
    Console.ReadLine();
  end;
end;

method ConsoleApp.Test(aIdentifier: integer); 
begin
  for i: integer := 0 to 4 do begin
    Console.WriteLine('Thread '+aIdentifier.ToString+': '+i.ToString);
    System.Threading.Thread.Sleep(100);
  end;
  Console.WriteLine('Thread '+aIdentifier.ToString+' is done.');
end;

end.
