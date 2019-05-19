namespace Anonymous_Methods;

interface

uses
  System.Threading,
  System.Windows.Forms;

type
  Program = assembly static class
  public
    class method Main;
  end;

implementation

/// <summary>
/// The main entry point for the application.
/// </summary>
//[STAThread]
class method Program.Main;
begin
  Application.EnableVisualStyles();
  Application.SetCompatibleTextRenderingDefault(false);

  // Default exception handler - using an anonymous method.
  Application.ThreadException += method (sender: Object; e: ThreadExceptionEventArgs);
    begin
      MessageBox.Show(e.Exception.Message);
    end;

  using lMainForm := new MainForm do
    Application.Run(lMainForm);
end;

end.