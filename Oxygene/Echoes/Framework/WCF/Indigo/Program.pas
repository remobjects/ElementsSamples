namespace Indigo;

interface

uses
  System.Linq, System.ServiceModel;


type
  ConsoleApp = class
  public
    class method Main;
  end;

implementation

class method ConsoleApp.Main;
begin
   // Creating base address
   var baseHttpAddress : Uri := new Uri(System.Configuration.ConfigurationManager.AppSettings["baseAddress"]);

    //Creating service
   var host : ServiceHost := new ServiceHost(typeOf(IndigoService), [baseHttpAddress]);

   host.Open(); // Open fails unless running as a Local Administrator; Start Visual Studio as administrator to run this.
   Console.WriteLine("Service is running. Press ENTER to exit...");

   Console.ReadLine();
end;

end.