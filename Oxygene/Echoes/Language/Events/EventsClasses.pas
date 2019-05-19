namespace Events.EventClasses;

interface

type
  OnSetNameDelegate = delegate(SimpleClassWithEvents: SimpleClassWithEvents; var aNewName: String);

  SimpleClassWithEvents = class
  private
    fOnSetName : OnSetNameDelegate;
    fName : String := 'NoName';

  protected
    procedure SetName(Value : String);

  public
    property Name: String read fName write SetName;
    event OnSetName: OnSetNameDelegate delegate fOnSetName;
  end;

implementation

procedure SimpleClassWithEvents.SetName(Value : string);
begin
  if Value = fName then Exit;

  if assigned(OnSetName) then
    OnSetName(self, var Value); // Triggers the event

  fName := Value;
end;

end.