namespace MetroSearchApplication;

interface

uses
  System,
  System.Collections.Generic,
  System.IO,
  System.Linq,
  Windows.ApplicationModel,
  Windows.ApplicationModel.Activation,
  Windows.Foundation,
  Windows.Foundation.Collections,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Controls.Primitives,
  Windows.UI.Xaml.Data,
  Windows.UI.Xaml.Input,
  Windows.UI.Xaml.Media,
  Windows.UI.Xaml.Navigation;

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
    method OnSuspending(sender: System.Object; e: SuspendingEventArgs);
    method EnsureMainPage(args: IActivatedEventArgs);
  protected
    /// <summary>
    /// Invoked when the application is launched normally by the end user.  Other entry points
    /// will be used when the application is launched to open a specific file, to display
    /// search results, and so forth.
    /// </summary>
    /// <param name="args">Details about the launch request and process.</param>
    method OnLaunched(args: LaunchActivatedEventArgs); override;
    method OnSearchActivated(args: SearchActivatedEventArgs); override;
  public
    /// <summary>
    /// Initializes the singleton application object.  This is the first line of authored code
    /// executed, and as such is the logical equivalent of main() or WinMain().
    /// </summary>
    constructor ;
  end;
  
implementation

constructor App;
begin
  InitializeComponent();
  Suspending += OnSuspending;
end;

method App.OnLaunched(args: LaunchActivatedEventArgs); 
begin
  EnsureMainPage(args);
end;

method App.EnsureMainPage(args: IActivatedEventArgs); 
begin
  if Window.Current.Content = nil then begin
    Window.Current.Content := new MainPage();
    Window.Current.Activate()
  end
end;

/// <summary>
/// This is the handler for Search activation. 
/// </summary>
/// <param name="args">This is the list of arguments for search activation, including QueryText and Language</param>
method App.OnSearchActivated(args: SearchActivatedEventArgs);
begin
  inherited OnSearchActivated(args);

  EnsureMainPage(args);

  MainPage(Window.Current.Content).UpdateSearchQuery(args.QueryText);
end;

method App.OnSuspending(sender: System.Object; e: SuspendingEventArgs);
begin
  var deferral := e.SuspendingOperation.GetDeferral();
  //TODO: Save application state and stop any background activity
  deferral.Complete()
end;

end.
