namespace RegExpression;

uses
  VCL.Forms;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      Application.Initialize;
      Application.MainFormOnTaskBar := True;
      Application.CreateForm(TForm1, var Form1);
      Application.Run;
    end;

  end;

end.