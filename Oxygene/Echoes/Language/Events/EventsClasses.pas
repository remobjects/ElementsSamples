namespace Events.EventClasses;

interface

type
  OnSetNameDelegate = delegate(SimpleClassWithEvents: SimpleClassWithEvents; var aNewName: string);
  
  SimpleClassWithEvents = class
  private
    fOnSetName : OnSetNameDelegate;
    fName : string := 'NoName';
    
  protected
    procedure SetName(Value : string);
    
  public
    property Name: string read fName write SetName;
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
