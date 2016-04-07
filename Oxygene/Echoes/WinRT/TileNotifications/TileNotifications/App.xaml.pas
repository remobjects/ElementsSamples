namespace TileNotifications;

interface

uses
  System.Threading.Tasks,
  Windows.ApplicationModel.Activation,
  Windows.UI.Xaml;

type
  App = partial class
  private
  protected
    method OnLaunched(args: LaunchActivatedEventArgs); override;
  public
    constructor;
  end;
  
implementation

constructor App;
begin
  InitializeComponent();
end;

method App.OnLaunched(args: LaunchActivatedEventArgs); 
begin
  Window.Current.Content := new MainPage();
  Window.Current.Activate();
end;

end.
