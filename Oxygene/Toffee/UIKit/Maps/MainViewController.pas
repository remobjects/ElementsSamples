namespace Maps;

interface

uses
  MapKit,
  UIKit;

type
  [IBObject] 
  MainViewController = public class(UIViewController, IUIPopoverControllerDelegate, IFlipsideViewControllerDelegate, IUISearchBarDelegate, IUITableViewDataSource, IUITableViewDelegate)
  private
    {$REGION IUIPopoverControllerDelegate}
    method popoverControllerShouldDismissPopover(aPopoverController: UIPopoverController): Boolean;
    method popoverControllerDidDismissPopover(aPopoverController: UIPopoverController);
    {$ENDREGION}
    {$REGION IFlipsideViewControllerDelegate}
    method flipsideViewControllerDidFinish(aController: FlipsideViewController);
    {$ENDREGION}

    method doSearch(aGoToFirst: Boolean);
    method goToMapItem(aMapItem: MKMapItem);
    var fResults: NSArray;

  public
    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;
    property prefersStatusBarHidden: Boolean read true; override;

    method prepareForSegue(aSegue: not nullable UIStoryboardSegue) sender(aSender: id); override;

    [IBAction] method togglePopover(aSender: id);

    {$REGION IUISearchBarDelegate}
    method searchBarShouldBeginEditing(aSearchBar: UISearchBar): Boolean;
    method searchBarTextDidBeginEditing(aSearchBar: UISearchBar);
    method searchBarShouldEndEditing(aSearchBar: UISearchBar): Boolean;
    method searchBarTextDidEndEditing(aSearchBar: UISearchBar);
    method searchBar(aSearchBar: UISearchBar) textDidChange(searchText: NSString);
    method searchBar(aSearchBar: UISearchBar) shouldChangeTextInRange(range: NSRange) replacementText(text: NSString): Boolean;
    method searchBarSearchButtonClicked(aSearchBar: UISearchBar);
    method searchBarBookmarkButtonClicked(aSearchBar: UISearchBar);
    method searchBarCancelButtonClicked(aSearchBar: UISearchBar);
    method searchBarResultsListButtonClicked(aSearchBar: UISearchBar);
    method searchBar(aSearchBar: UISearchBar) selectedScopeButtonIndexDidChange(selectedScope: NSInteger);

    {$REGION IUITableViewDataSource}
    method numberOfSectionsInTableView(aTableView: not nullable UITableView): NSInteger;
    method tableView(aTableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    method tableView(aTableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
    method tableView(aTableView: not nullable UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
    {$ENDREGION}

    [IBOutlet] property flipsidePopoverController: UIPopoverController;

    [IBOutlet] property map: weak MKMapView;
    [IBOutlet] property searchBar: weak UISearchBar;
    [IBOutlet] property tableView: weak UITableView;
  end;

implementation

method MainViewController.viewDidLoad;
begin
  inherited viewDidLoad;
end;

method MainViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;
end;

{$REGION IUIPopoverControllerDelegate}
method MainViewController.popoverControllerShouldDismissPopover(aPopoverController: UIPopoverController):Boolean;
begin
end;

method MainViewController.popoverControllerDidDismissPopover(aPopoverController: UIPopoverController);
begin
  flipsidePopoverController := nil;
end;
{$ENDREGION}

{$REGION IFlipsideViewControllerDelegate}
method MainViewController.flipsideViewControllerDidFinish(aController: FlipsideViewController);
begin
  dismissViewControllerAnimated(true) completion(nil);
end;
{$ENDREGION}

method MainViewController.prepareForSegue(aSegue: not nullable UIStoryboardSegue) sender(aSender: id);
begin
  if aSegue.identifier.isEqualToString('showAlternate') then begin

    aSegue.destinationViewController.delegate := self;
    if UIDevice.currentDevice.userInterfaceIdiom = UIUserInterfaceIdiom.UIUserInterfaceIdiomPad then begin
      var lPopoverController := (aSegue as UIStoryboardPopoverSegue).popoverController;
      flipsidePopoverController := lPopoverController;
      lPopoverController.delegate := self;
    end;
  end;
end;

method MainViewController.togglePopover(aSender: id);
begin
  if assigned(flipsidePopoverController) then begin
    flipsidePopoverController.dismissPopoverAnimated(true);
    flipsidePopoverController := nil;
  end
  else begin
    performSegueWithIdentifier('showAlternate') sender(aSender);
  end;
end;

{$REGION IUISearchBarDelegate}
method MainViewController.searchBarShouldBeginEditing(aSearchBar: UISearchBar): Boolean;
begin
  result := true;
end;

method MainViewController.searchBarTextDidBeginEditing(aSearchBar: UISearchBar);
begin
end;

method MainViewController.searchBarShouldEndEditing(aSearchBar: UISearchBar): Boolean;
begin
  result := true;
end;

method MainViewController.searchBarTextDidEndEditing(aSearchBar: UISearchBar);
begin
end;

method MainViewController.searchBar(aSearchBar: UISearchBar) textDidChange(searchText: NSString);
begin
  if length(searchBar.text) = 0 then begin
    tableView.hidden := true;
  end
  else begin
    doSearch(false);
  end;
end;

method MainViewController.searchBar(aSearchBar: UISearchBar) shouldChangeTextInRange(range: NSRange) replacementText(text: NSString): Boolean;
begin
  result := true;
end;

method MainViewController.searchBarSearchButtonClicked(aSearchBar: UISearchBar);
begin
  doSearch(true);
  searchBar.resignFirstResponder();
end;

method MainViewController.searchBarBookmarkButtonClicked(aSearchBar: UISearchBar);
begin
end;

method MainViewController.searchBarCancelButtonClicked(aSearchBar: UISearchBar);
begin
  tableView.hidden := true;
end;

method MainViewController.searchBarResultsListButtonClicked(aSearchBar: UISearchBar);
begin
end;

method MainViewController.searchBar(aSearchBar: UISearchBar) selectedScopeButtonIndexDidChange(selectedScope: NSInteger);
begin
end;
{$ENDREGION}

{$REGION IUITableViewDataSource}
method MainViewController.numberOfSectionsInTableView(aTableView: not nullable UITableView): NSInteger;
begin
  result := 1;
end;

method MainViewController.tableView(aTableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
begin
  result := if assigned(fResults) then fResults.count else 0; // todo: use colon
end;

method MainViewController.tableView(aTableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
begin
  result := new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleSubtitle) reuseIdentifier('CELL');

  var m := fResults[indexPath.row] as MKMapItem;
  result.textLabel.text := m.name;
end;

method MainViewController.tableView(aTableView: not nullable UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
begin
  tableView.deselectRowAtIndexPath(indexPath) animated(true);
  goToMapItem( fResults[indexPath.row]);
  searchBar.resignFirstResponder();
end;
{$ENDREGION}

method MainViewController.doSearch(aGoToFirst: Boolean);
begin
  var lRequest := new MKLocalSearchRequest;
  lRequest.naturalLanguageQuery := searchBar.text;
  
  var lSearch := new MKLocalSearch withRequest(lRequest);
  lSearch.startWithCompletionHandler(method (aResponse: MKLocalSearchResponse; aError: NSError)  begin

      fResults := aResponse:mapItems;

      tableView.hidden := not assigned(fResults);
      tableView.reloadData();

      if aGoToFirst and assigned(fResults) and (fResults.count > 0) then
        goToMapItem(fResults[0]);

    end);

end;

method MainViewController.goToMapItem(aMapItem: MKMapItem);
begin
  var lRegion := new MKCoordinateRegion;
  lRegion.center := aMapItem.placemark.location.coordinate;
  lRegion.span := MKCoordinateSpanMake(0.005, 0.005); 
  map.setRegion(lRegion) animated(true); 

  tableView.hidden := true;
end;

end.
