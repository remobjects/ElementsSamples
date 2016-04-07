namespace VirtualProperties.VirtualPropertiesClasses;

interface

uses
  System.Windows.Forms;

type
  { This class is abstract and only serves as a base for descendants. 
    Notice how clean the Oxygene syntax is, compared to classic object pascal,
    where you'd need to declare two virtual abstract methods to set and get Name. }
  BaseClass = abstract class
  public
    property Name: string read write; abstract;
  end;
  
  { Provides an implementation for the Name getter and setter by using a field. }
  FirstDescendant = class(BaseClass)
  private
    fName: string;
  public
    property Name: string read fName write fName; override;
  end;
  
  { This interface has the same syntax that saved us from the redundant code in 
    the declaration of BaseClass as it works on interfaces as well. 
    Interface methods are implicitly virtual abstract. }
  IHasName = interface
    property Name: string read write;
  end;

  { Overrides the implementation of the getter and setter provided by FirstDescendant by
    introducing two methods to do the job. }
  SecondDescendant = class(FirstDescendant, IHasName)
  private
    method SetName(Value: string);
    method GetName: string;
  public
    property Name: string read GetName write SetName; override;
  end;
  
implementation

{ SecondDescendant }

method SecondDescendant.SetName(Value : string); 
begin
  MessageBox.Show('Setting Name to '+Value);
  inherited Name := Value;
end;

method SecondDescendant.GetName: string; 
begin
  result := inherited Name; 
end;

end.
