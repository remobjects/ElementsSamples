namespace NSTableView;

interface

uses
  Foundation;

type
  Person = public class
  private
    fName: String;
    fAge: Integer;
  protected
  public
    property name : String read fName write fName;
    property age : Integer read fAge write fAge;
  end;

implementation

end.
