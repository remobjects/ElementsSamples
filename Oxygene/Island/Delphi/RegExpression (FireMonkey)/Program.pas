namespace RegExpression;

uses
  System.StartUpCopy,
  FMX.Forms;

type
  Program = class
  public

    class method Main(args: array of String): Int32;
    begin
      Application.Initialize;
      Application.CreateForm(TForm1, var Form1);
      Application.Run;
    end;

  end;

end.