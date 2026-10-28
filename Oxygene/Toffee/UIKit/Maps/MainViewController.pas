// Positive sample guard: configure the application delegate on the segue destination class, not another framework delegate.
namespace Maps;

uses
  MapKit,
  UIKit;

type
  [IBObject]
  MainViewController = public class(UIViewController, IFlipsideViewControllerDelegate, IUISearchBarDelegate, IUITableViewDataSource, IUITableViewDelegate)
  private

    {$REGION IFlipsideViewControllerDelegate}
    method flipsideViewControllerDidFinish(aController: FlipsideViewController);
    begin
      dismissViewControllerAnimated(true) completion(nil);
    end;
    {$ENDREGION}

    method doSearch(aGoToFirst: Boolean);
    begin
      var lRequest := new MKLocalSearchRequest;
      lRequest.naturalLanguageQuery := searchBar.text;

      fSearch:cancel;
      var lSearch := new MKLocalSearch withRequest(lRequest);
      fSearch := lSearch;
      lSearch.startWithCompletionHandler(method (aResponse: MKLocalSearchResponse; aError: NSError)  begin

          // Ignore completion from an older search or one cancelled by the user.
          if fSearch ≠ lSearch then
            exit;
          fSearch := nil;
          if assigned(aError) then
            NSLog("Map search failed: %@", aError.localizedDescription);
          fResults := aResponse:mapItems;

          tableView.hidden := not assigned(fResults);
          tableView.reloadData();

          if aGoToFirst and assigned(fResults) and (fResults.count > 0) then
            goToMapItem(fResults[0]);

        end);

    end;
    method goToMapItem(aMapItem: MKMapItem);
    begin
      var lRegion := new MKCoordinateRegion;
      lRegion.center := aMapItem.placemark.location.coordinate;
      lRegion.span := MKCoordinateSpanMake(0.005, 0.005);
      map.setRegion(lRegion) animated(true);

      tableView.hidden := true;
    end;
    field fResults: NSArray;
    field fSearch: MKLocalSearch;

  public

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;
    end;
    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning;
    end;
    property prefersStatusBarHidden: Boolean read true; override;

    method prepareForSegue(aSegue: not nullable UIStoryboardSegue) sender(aSender: id); override;
    begin
      if aSegue.identifier.isEqualToString('showAlternate') then begin

        (aSegue.destinationViewController as FlipsideViewController).delegate := self;
        var lDestination := aSegue.destinationViewController;
        lDestination.modalPresentationStyle := UIModalPresentationStyle.Popover;
        var lPopover := lDestination.popoverPresentationController;
        if aSender is var lButton: UIBarButtonItem then
          lPopover.barButtonItem := lButton
        else begin
          lPopover.sourceView := view;
          lPopover.sourceRect := view.bounds;
        end;
      end;
    end;

    [IBAction] method togglePopover(aSender: id);
    begin
      if assigned(presentedViewController) then
        dismissViewControllerAnimated(true) completion(nil)
      else
        performSegueWithIdentifier("showAlternate") sender(aSender);
    end;

    {$REGION IUISearchBarDelegate}
    method searchBarShouldBeginEditing(aSearchBar: UISearchBar): Boolean;
    begin
      result := true;
    end;
    method searchBarTextDidBeginEditing(aSearchBar: UISearchBar);
    begin
    end;
    method searchBarShouldEndEditing(aSearchBar: UISearchBar): Boolean;
    begin
      result := true;
    end;
    method searchBarTextDidEndEditing(aSearchBar: UISearchBar);
    begin
    end;
    method searchBar(aSearchBar: UISearchBar) textDidChange(searchText: NSString);
    begin
      if length(searchBar.text) = 0 then begin
        fSearch:cancel;
        fSearch := nil;
        tableView.hidden := true;
      end
      else begin
        doSearch(false);
      end;
    end;
    method searchBar(aSearchBar: UISearchBar) shouldChangeTextInRange(range: NSRange) replacementText(text: NSString): Boolean;
    begin
      result := true;
    end;
    method searchBarSearchButtonClicked(aSearchBar: UISearchBar);
    begin
      doSearch(true);
      searchBar.resignFirstResponder();
    end;
    method searchBarBookmarkButtonClicked(aSearchBar: UISearchBar);
    begin
    end;
    method searchBarCancelButtonClicked(aSearchBar: UISearchBar);
    begin
      fSearch:cancel;
      fSearch := nil;
      tableView.hidden := true;
    end;
    method searchBarResultsListButtonClicked(aSearchBar: UISearchBar);
    begin
    end;
    method searchBar(aSearchBar: UISearchBar) selectedScopeButtonIndexDidChange(selectedScope: NSInteger);
    begin
    end;

    {$REGION IUITableViewDataSource}
    method numberOfSectionsInTableView(aTableView: not nullable UITableView): NSInteger;
    begin
      result := 1;
    end;
    method tableView(aTableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    begin
      result := if assigned(fResults) then fResults.count else 0; // todo: use colon
    end;
    method tableView(aTableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
    begin
      result := aTableView.dequeueReusableCellWithIdentifier("CELL");
      if not assigned(result) then
        result := new UITableViewCell withStyle(UITableViewCellStyle.Subtitle) reuseIdentifier("CELL");

      var m := fResults[indexPath.row] as MKMapItem;
      result.textLabel.text := m.name;
    end;
    method tableView(aTableView: not nullable UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
    begin
      tableView.deselectRowAtIndexPath(indexPath) animated(true);
      goToMapItem( fResults[indexPath.row]);
      searchBar.resignFirstResponder();
    end;
    {$ENDREGION}

    [IBOutlet] property map: weak MKMapView;
    [IBOutlet] property searchBar: weak UISearchBar;
    [IBOutlet] property tableView: weak UITableView;
  end;

end.
