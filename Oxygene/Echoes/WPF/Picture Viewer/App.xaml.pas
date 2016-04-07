namespace PictureViewer;

interface

uses
  System.Windows,
  System.Data,
  System.Xml,
  System.Configuration;

type
  App = public partial class(System.Windows.Application)
  public 
    method AppStartup(sender: object; args: StartupEventArgs);
  end;
  
implementation

method App.AppStartup(sender: object; args: StartupEventArgs);
begin
  var mainWindow: Window1 := new Window1();
  mainWindow.Show();

  mainWindow.Images := ((Self.Resources['Images'] as System.Windows.Data.ObjectDataProvider).Data as ImageList);
  mainWindow.Images.Path := '..\..\Images';  
end;
  
end.