namespace Sample;

uses
  RemObjects.Elements.RTL.Delphi,
  RemObjects.Elements.RTL.Delphi.VCL;

type
  [Export]
  Program = public class
  public

    method Main;
    begin
      Application := new TApplication(nil);
      Application.Initialize;
      Application.CreateForm(typeOf(Sample.TForm2), var Sample.Form2);
      Application.Run;
    end;

  end;

end.