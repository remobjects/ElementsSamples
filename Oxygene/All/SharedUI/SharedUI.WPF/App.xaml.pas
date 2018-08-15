namespace SharedUI.WPF;

interface

uses
  System.Windows,
  SharedUI.Shared;

type
  App = public partial class(Application)
  private
	var appDelegate: AppDelegate;
  protected
	method OnStartup(e: StartupEventArgs); override;
  end;

implementation

method App.OnStartup(e: StartupEventArgs);
begin
  appDelegate := new AppDelegate();
  appDelegate.start();
end;

end.