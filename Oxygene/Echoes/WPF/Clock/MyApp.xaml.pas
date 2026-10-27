namespace AvalonApplication4;

interface

uses
  System.Windows,
  System.Data,
  System.Xml,
  System.Configuration;

type
  MyApp = public partial class(Application)
  private
    method AppStartingUp(sender: Object; e: StartupEventArgs);

  end;
  
implementation

method MyApp.AppStartingUp(sender: Object; e: StartupEventArgs);
begin
  var lMainWindow := new OxygeneWindow();
  
  //
  lMainWindow.Show();
end;
 
end.