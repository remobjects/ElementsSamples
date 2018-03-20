namespace InterfacesSample.SampleClasses;

interface

uses
  System,
  System.Windows.Forms;

type
  { IVersionInfo interface
      Notice how, in Oxygene, there's no need to declare setter and getter methods for
      interface properties. Their implementation and names are deferred to the class
      that implements this interface. }
  IVersionInfo = interface
    property Name: String read;
    property MajVersion: Integer read;
    property MinVersion: Integer read;
    property Description: String read;
  end;

  { VersionInfo class }
  VersionInfo = class(IVersionInfo)
  private
    fControl: Control;
  protected
    method GetName: String;

  public
    constructor(aControl: Control; aMajVersion, aMinVersion: Integer; aDescription: String);

    property Name: String read GetName;

    { The following Readonly properties can only be set inside a constructor }
    property MajVersion: Integer; readonly;
    property MinVersion: Integer; readonly;
    property Description: String; readonly;
  end;

  { SampleButton
      Notice how the VersionInfo property is initialized inline and, trough the use
      of the keyword "implements", provides an implementation for IVersionInfo to
      the class SampleButton.
  }
  SampleButton = class(System.Windows.Forms.Button, IVersionInfo)
  public
    property VersionInfo: IVersionInfo := new VersionInfo(self, 1,0,'A button with VersionInfo'); implements IVersionInfo;
  end;

  { SampleTextBox
      See comment for SampleButton. Thanks to inline instantiation of properties
      and the "implements" keyword, code-reuse and interface delegation is made
      much simpler. }
  SampleTextBox = class(System.Windows.Forms.TextBox, IVersionInfo)
  public
    property VersionInfo: IVersionInfo := new VersionInfo(self, 2,3,'A text box with VersionInfo'); implements IVersionInfo;
  end;

implementation

constructor VersionInfo(aControl: Control; aMajVersion, aMinVersion: integer; aDescription: string);
begin
  inherited constructor;

  fControl := aControl;
  MajVersion := aMajVersion;
  MinVersion := aMinVersion;
  Description := aDescription;
end;

method VersionInfo.GetName: string;
begin
  { Result is implicitly initialized to '' }
  if assigned(fControl) then
    result := fControl.Name
end;

end.