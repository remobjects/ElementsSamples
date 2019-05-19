namespace SharedUI.WPF;

uses
  System.Windows,
  SharedUI.Shared;

type
  App = public partial class(Application)
  private
    var appDelegate: AppDelegate;
  protected

    method OnStartup(e: StartupEventArgs); override;
    begin
      appDelegate := new AppDelegate();
      appDelegate.start();
    end;

  end;

end.