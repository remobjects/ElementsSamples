namespace AppBarExample;

interface

uses
  System,
  System.Collections.Generic,
  System.Linq,
  System.Threading.Tasks,
  Windows.Foundation,
  Windows.UI.Popups,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Data,
  
  Windows.UI.Xaml.Navigation;

type
  MainPage = partial class
  private
    method AppBar_Click(sender: Object; e: RoutedEventArgs);
    method Sticky_Click(sender: Object; e: RoutedEventArgs);
  protected
  public
    constructor ;

  /// <summary>
  /// Invoked when this page is about to be displayed in a Frame.
  /// </summary>
  /// <param name="e">Event data that describes how this page was reached.  The Parameter
  /// property is typically used to configure the page.</param>
  protected
    method OnNavigatedTo(e: NavigationEventArgs); override;
  end;
  
implementation

constructor MainPage;
begin
  System.Diagnostics.Debug.WriteLine("MainPage Constructor");
  InitializeComponent();
end;

method MainPage.OnNavigatedTo(e: NavigationEventArgs);
begin
end;

method MainPage.AppBar_Click(sender: Object; e: RoutedEventArgs);
begin
  var msg := new MessageDialog("App Bar Button '" + String((sender as Button).Tag) + "' clicked.");
  msg.Commands.Add(new UICommand("OK", nil, "ok"));
  msg.Commands.Add(new UICommand("Again", nil, "again"));
  var cmd := await msg.ShowAsync;

  if String(cmd.Id) = "again" then
    new MessageDialog("You like MessageDialogs - here is another one!").ShowAsync;
end;

method MainPage.Sticky_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
begin
  // Toggle Sticky property
  TopAppBar1.IsSticky := Boolean((sender as CheckBox).IsChecked);

  // Syncronize AppBars for aesthetics
  if not TopAppBar1.IsSticky then
    TopAppBar.IsOpen := self.BottomAppBar.IsOpen;

end;

end.
