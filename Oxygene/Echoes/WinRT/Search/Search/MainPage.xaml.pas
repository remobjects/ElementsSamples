namespace MetroSearchApplication;

interface

uses
  System,
  System.Collections.Generic,
  System.IO,
  System.Linq,
  Windows.Foundation,
  Windows.Foundation.Collections,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Controls.Primitives,
  Windows.UI.Xaml.Data,
  Windows.UI.Xaml.Input,
  Windows.UI.Xaml.Media,
  Windows.UI.Xaml.Navigation,
  
  Windows.ApplicationModel.Search;

type
  MainPage = partial class(Page)
  private
    _searchPane: SearchPane;
    suggestionList: array of System.String := ['Oxygene for .NET', 'Oxygene for Java', 'Data Abstract for .NET', 'Data Abstract for Delphi', 'Data Abstract for Xcode', 'Data Abstract for Java', 'RemObjects SDK for Java', 'RemObjects SDK for Delphi', 'RemObjects SDK for .NET', 'RemObjects SDK for Xcode'];
  protected
  public
    constructor;
    method UpdateSearchQuery(queryText: String);
    method OnQuerySubmitted(sender: Object; args: SearchPaneQuerySubmittedEventArgs);
    method OnQueryChanged(sender: Object; args: SearchPaneQueryChangedEventArgs);
    method OnSearchPaneSuggestionsRequested(sender: Object; args: SearchPaneSuggestionsRequestedEventArgs);
    method OnSearchPaneResultSuggestionChosen(sender: Object; args: SearchPaneResultSuggestionChosenEventArgs);
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
  InitializeComponent();

  _searchPane := SearchPane.GetForCurrentView;
  _searchPane.QuerySubmitted += new TypedEventHandler<SearchPane, SearchPaneQuerySubmittedEventArgs>(OnQuerySubmitted);
  _searchPane.QueryChanged += new TypedEventHandler<SearchPane, SearchPaneQueryChangedEventArgs>(OnQueryChanged);
  _searchPane.SuggestionsRequested += new TypedEventHandler<SearchPane, SearchPaneSuggestionsRequestedEventArgs>(OnSearchPaneSuggestionsRequested);
  _searchPane.ResultSuggestionChosen += new TypedEventHandler<SearchPane, SearchPaneResultSuggestionChosenEventArgs>(OnSearchPaneResultSuggestionChosen);
end;

method MainPage.OnNavigatedTo(e: NavigationEventArgs);
begin
end;

method MainPage.UpdateSearchQuery(queryText: String);
begin
  SearchQuery.Text := "Search Activation: " + queryText;
end;

/// <summary>
/// Search pane query to local app is submitted and displays query results
/// </summary>
/// <param name="sender">This is the UI object sender</param>
/// <param name="args">This is the argument for QuerySubbmitted event. Contains QueryText, Language, etc.</param>
method MainPage.OnQuerySubmitted(sender: Object; args: SearchPaneQuerySubmittedEventArgs);
begin
  SearchQuery.Text := "Query submitted: " + args.QueryText;
end;

/// <summary>
/// Search pane query to local app is changing to give app an opportunity to display realtime results
/// </summary>
/// <param name="sender">This is the UI object sender</param>
/// <param name="args">This is the argument for QueryChanged event. Contains QueryText, Language, etc.</param>
method MainPage.OnQueryChanged(sender: Object; args: SearchPaneQueryChangedEventArgs);
begin
  SearchQuery.Text := "Current query text: " + args.QueryText;
end;

/// <summary>
/// Search pane displays suggestions from a static local list
/// </summary>
/// <param name="sender">This is the UI object sender</param>
/// <param name="args">This is the argument for OnSearchPaneSuggestionsRequested event</param>
method MainPage.OnSearchPaneSuggestionsRequested(sender: Object; args: SearchPaneSuggestionsRequestedEventArgs);
begin
  for each suggestion: String in suggestionList do
  begin
    if (suggestion.IndexOf(args.QueryText, StringComparison.CurrentCultureIgnoreCase) > -1) then 
      args.Request.SearchSuggestionCollection.AppendQuerySuggestion(suggestion);
    if (args.Request.SearchSuggestionCollection.Size >= 5) then
      break;
  end;
end;

/// <summary>
/// Rich suggestion is selected in search pane
/// </summary>
/// <param name="sender">This is the UI object sender</param>
/// <param name="args">This is the argument for ResultSuggestionChosen event</param>
method MainPage.OnSearchPaneResultSuggestionChosen(sender: Object; args: SearchPaneResultSuggestionChosenEventArgs);
begin
  SearchQuery.Text := "Result Suggestion Selected: " + args.Tag;
end;

end.
