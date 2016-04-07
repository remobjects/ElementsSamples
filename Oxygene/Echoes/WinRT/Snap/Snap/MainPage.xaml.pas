namespace SnapTileSample;

interface

uses
  System,
  System.Collections.Generic,
  System.Linq,
  System.Threading.Tasks,
  Windows.Foundation,
  Windows.UI.Core,
  Windows.UI.Popups,
  Windows.UI.ViewManagement,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Navigation,
  Windows.UI.Xaml.Data;

type
  MainPage = partial class
  private
    const ItemKey: String = "CurrentItem";
    var programmaticUnsnapSucceeded: Boolean := false;
    method UnsnapButton_Click(sender: Object; e: RoutedEventArgs);
    method HyperlinkButton_Click(sender: Object; e: RoutedEventArgs);
    method Data_ItemClick(sender: Object; e: ItemClickEventArgs);
    method UpdateTextViewState;
    method UpdateItemDisplay;
    method OnWindowSizeChanged(sender: Object; args: WindowSizeChangedEventArgs);
  protected
  public
    constructor;
    CurrentItem: Item;
    Data: DataSource;
  end;
  
implementation

constructor MainPage;
begin
  InitializeComponent;
  
  Window.Current.SizeChanged += OnWindowSizeChanged;

  Data := new DataSource;

  var query := Data.Collection.OrderBy(item -> item.Category);

  DataGridView.ItemsSource := query.ToList;
  DataListView.ItemsSource := query.ToList;

  if SuspensionManager.SessionState.ContainsKey(ItemKey) then begin
    var selectedLink := SuspensionManager.SessionState[ItemKey] as String;
    CurrentItem := (from i in query
                   where i.Link = selectedLink
                   select i).FirstOrDefault;
    UpdateItemDisplay;
  end;  
  
end;

method MainPage.UnsnapButton_Click(sender: Object; e: RoutedEventArgs);
begin
  programmaticUnsnapSucceeded := ApplicationView.TryUnsnap();

  if not self.programmaticUnsnapSucceeded then begin
    TextViewState.Text := 'Programmatic unsnap did not work.'
  end else begin
    UpdateTextViewState;
  end;   
end;

method MainPage.OnWindowSizeChanged(sender: Object; args: WindowSizeChangedEventArgs);
begin
  case ApplicationView.Value of 
    Windows.UI.ViewManagement.ApplicationViewState.Filled:  begin
      VisualStateManager.GoToState(self, 'Fill', false);
    end;
    Windows.UI.ViewManagement.ApplicationViewState.FullScreenLandscape:  begin
      VisualStateManager.GoToState(self, 'Full', false);
    end;
    Windows.UI.ViewManagement.ApplicationViewState.Snapped:  begin
      VisualStateManager.GoToState(self, 'Snapped', false);
    end;
    Windows.UI.ViewManagement.ApplicationViewState.FullScreenPortrait:  begin
      VisualStateManager.GoToState(self, 'Portrait', false);
    end
  end;

  UpdateTextViewState;
end;

method MainPage.UpdateTextViewState;
begin
  var currentState: ApplicationViewState := Windows.UI.ViewManagement.ApplicationView.Value;

  if currentState = ApplicationViewState.Snapped then begin
    TextViewState.Text := 'This app is snapped';
  end
  else if currentState = ApplicationViewState.Filled then begin
    TextViewState.Text := 'This app is in the fill state';
  end
  else if currentState = ApplicationViewState.FullScreenLandscape then begin
    TextViewState.Text := 'This app is full-screen landscape';
  end
  else if currentState = ApplicationViewState.FullScreenPortrait then begin
    TextViewState.Text := 'This app is full-screen portrait';
  end;

  if self.programmaticUnsnapSucceeded then begin
    TextViewState.Text := TextViewState.Text + ' and this app was programmatically unsnapped.';
    programmaticUnsnapSucceeded := false
  end
  else begin
    TextViewState.Text := TextViewState.Text + '.'
  end;
end;

method MainPage.Data_ItemClick(sender: Object; e: Windows.UI.Xaml.Controls.ItemClickEventArgs);
begin
  CurrentItem := e.ClickedItem as Item;
  UpdateItemDisplay;
  SuspensionManager.SessionState[ItemKey] := CurrentItem.Link;
end;

method MainPage.UpdateItemDisplay;
begin
  DetailsText.Text := CurrentItem.Subtitle;  
  DetailsImage.Source := CurrentItem.Image;
  DetailsDescription.Text := CurrentItem.Description;
  DetailsLink.Content := 'Click for more info';
end;

method MainPage.HyperlinkButton_Click(sender: Object; e: RoutedEventArgs);
begin
  Windows.System.Launcher.LaunchUriAsync(new System.Uri(CurrentItem.Link));
end;

end.
