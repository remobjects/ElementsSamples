namespace RemotingSample.Server;

interface

uses
  System.Reflection,
  System.Runtime.Remoting,
  System.Runtime.Remoting.Channels,
  System.Runtime.Remoting.Channels.HTTP,
  RemotingSample.Implementation;

type
  ConsoleApp = class
  class var
    fChannel: HttpChannel;
    
  public
  
    class method Main;
  end;    

implementation

class method ConsoleApp.Main;
const
  DefaultPort = 8033;
begin  
  // Initializes the server to listen for HTTP requests on a specific port
  fChannel := new HttpChannel(DefaultPort);
  ChannelServices.RegisterChannel(fChannel, false);
  
  // Registers the TRemoteService service
  RemotingConfiguration.RegisterWellKnownServiceType(
    typeOf(RemoteService),
    'RemoteService.soap',
    WellKnownObjectMode.Singleton);
    
  // Starts accepting requests 
  Console.WriteLine('HTTP channel created. Listening on port '+DefaultPort.ToString);    
  Console.ReadLine;
end;

end.