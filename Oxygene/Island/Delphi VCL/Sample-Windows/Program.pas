namespace Sample;

uses
  RemObjects.Elements.RTL.Delphi, 
  RemObjects.Elements.RTL.Delphi.VCL;

type
  {$IF WEBASSEMBLY}[Export]{$ENDIF}
  Program = public class
  public

    method Main; static;
    begin
      Application := new TApplication(nil);
      Application.Initialize;
      Application.CreateForm(typeOf(TForm2), var Form2);
      Application.Run;
    end;

  end;

end.