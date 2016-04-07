namespace SnapTileSample;

interface

uses
  System.Threading.Tasks,
  Windows.ApplicationModel.Activation,
  Windows.ApplicationModel,
  Windows.UI.Xaml;

// The Blank Application template is documented at http://go.microsoft.com/fwlink/?LinkId=234227

/// <summary>
/// Provides application-specific behavior to supplement the default Application class.
/// </summary>
type
  App = partial class(Application)
  private
    /// <summary>
    /// Invoked when application execution is being suspended.  Application state is saved
    /// without knowing whether the application will be terminated or resumed with the contents
    /// of memory still intact.
    /// </summary>
    /// <param name="sender">The source of the suspend request.</param>
    /// <param name="e">Details about the suspend request.</param>
    method OnSuspending(sender: System.Object; args: SuspendingEventArgs);
  protected
    /// <summary>
    /// Invoked when the application is launched normally by the end user.  Other entry points
    /// will be used when the application is launched to open a specific file, to display
    /// search results, and so forth.
    /// </summary>
    /// <param name="args">Details about the launch request and process.</param>
    method OnLaunched(args: LaunchActivatedEventArgs); override;
  public
    /// <summary>
    /// Initializes the singleton application object.  This is the first line of authored code
    /// executed, and as such is the logical equivalent of main() or WinMain().
    /// </summary>
    constructor;
  end;
  
implementation

constructor App;
begin
  self.InitializeComponent();
  self.Suspending += OnSuspending;
end;

method App.OnLaunched(args: LaunchActivatedEventArgs); 
begin
  await SuspensionManager.RestoreAsync;

  Window.Current.Content := new MainPage();
  Window.Current.Activate();
end;

method App.OnSuspending(sender: Object; args: SuspendingEventArgs);
begin
  var deferral := args.SuspendingOperation.GetDeferral();
  await SuspensionManager.SaveAsync();
  deferral.Complete();
end;

end.
