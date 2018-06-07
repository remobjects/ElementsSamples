namespace RemotingSample.Implementation;

interface

uses
  System,
  RemotingSample.Interfaces;

type
  { RemoteService }
  RemoteService = public class(MarshalByRefObject, IRemoteService)
  private
  protected
    method Sum(A, B : Integer) : Integer;
  public
  end;

implementation

method RemoteService.Sum(A, B : integer) : integer;
begin
  Console.WriteLine('Serving a remote request: Sum '+A.ToString+'+'+B.ToString+'...');
  result := A+B;
end;

end.