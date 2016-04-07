namespace AdrenoCF;

interface

type
  TMain = class
    class method Main;
  end;

implementation

uses
  Mono.Security.Cryptography;

class method TMain.Main;
var
  lMD4: MD4;
  lHash: array of byte;
begin
  Console.WriteLine('Hello from Oxygene on Mono');
  
  lMD4 := new MD4Managed(); 
  lHash := lMD4.ComputeHash(System.Text.Encoding.ASCII.GetBytes('My Secret String'));
  Console.WriteLine(lHash.Length.ToString+' bytes of hash generated:'#13#10+BitConverter.ToString(lHash));
end;

end.
