namespace Sample;

uses
  Vcl.Forms,
  System.Classes;

type
  {$IF WEBASSEMBLY}[Export]{$ENDIF}
  Program = public class
  public

    method Main; static;
    begin
      Application.Initialize;
      Application.MainFormOnTaskBar := true;
      Application.CreateForm(TForm2, var Form2);
      Application.Run;
    end;

  end;

end.