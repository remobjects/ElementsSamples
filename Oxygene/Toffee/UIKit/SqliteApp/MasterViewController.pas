namespace SqliteApp;

interface

uses
  Foundation, 
  UIKit,
  libsqlite3;
  

type
  MasterViewController = public class (UITableViewController)
  private
    fObjects: NSMutableArray;
  protected
  public
    property detailViewController: DetailViewController;

    method awakeFromNib; override;
    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;
    method prepareForSegue(segue: not nullable UIStoryboardSegue) sender(sender: id); override;

    {$REGION Table view data source}
    method numberOfSectionsInTableView(tableView: UITableView): Integer;
    method tableView(tableView: UITableView) canMoveRowAtIndexPath(indexPath: NSIndexPath): RemObjects.Oxygene.System.Boolean;
    method tableView(tableView: UITableView) moveRowAtIndexPath(fromIndexPath: NSIndexPath) toIndexPath(toIndexPath: NSIndexPath);
    method tableView(tableView: UITableView) commitEditingStyle(editingStyle: UITableViewCellEditingStyle) forRowAtIndexPath(indexPath: NSIndexPath);
    method tableView(tableView: UITableView) canEditRowAtIndexPath(indexPath: NSIndexPath): RemObjects.Oxygene.System.Boolean;
    method tableView(tableView: UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
    method tableView(tableView: UITableView) numberOfRowsInSection(section: Integer): Integer;
    {$ENDREGION}

    {$REGION Table view delegate}
    method tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
    {$ENDREGION}
  end;

implementation

method MasterViewController.awakeFromNib;
begin
  if UIDevice.currentDevice.userInterfaceIdiom = UIUserInterfaceIdiom.UIUserInterfaceIdiomPad then begin
    clearsSelectionOnViewWillAppear := true;
    //contentSizeForViewInPopover := CGSizeMake(320.0, 600.0); //59091: Toffee: Linker error on CGSizeMake - we dont have inline functions yet
  end;
  inherited awakeFromNib;
end;


method MasterViewController.viewDidLoad;
begin
  inherited viewDidLoad;

  detailViewController := splitViewController:viewControllers:lastObject:topViewController as DetailViewController;

  fObjects := new NSMutableArray();

  var lDatabaseName := NSBundle.mainBundle.pathForResource('PCTrade.sqlite') ofType('db');
  NSLog('%@', lDatabaseName);

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), method begin
      NSLog('async!');
      NSLog('self: %@', self);
    
    end);

  var lDatabase: ^sqlite3_ := nil;
  if sqlite3_open(lDatabaseName.cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding), @lDatabase) = SQLITE_OK then begin

    var lStatement: ^sqlite3_stmt;
    if sqlite3_prepare_v2(lDatabase, 'select * from Customers', -1, @lStatement, nil) = SQLITE_OK then begin
      
      while sqlite3_step(lStatement) = SQLITE_ROW do begin

        var lName := ^AnsiChar(sqlite3_column_text(lStatement, 1));
        fObjects.addObject(NSString.stringWithUTF8String(lName));


        NSLog('row: %s', lName);
      end;

    end;
    sqlite3_close(lDatabase);
  end;
  tableView.reloadData();


end;

method MasterViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;
  // Dispose of any resources that can be recreated.
end;

{$REGION Table view data source}

method MasterViewController.numberOfSectionsInTableView(tableView: UITableView): Integer;
begin
  result := 1;
end;

method MasterViewController.tableView(tableView: UITableView) numberOfRowsInSection(section: Integer): Integer;
begin
  //result := fObjects:count;
  result := if assigned(fObjects) then fObjects.count else 0; //59096: Toffee: Compiler NRE when jusing ":" on a simple type
end;

method MasterViewController.tableView(tableView: UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
begin
  var CellIdentifier := "Cell";
  result := tableView.dequeueReusableCellWithIdentifier(CellIdentifier);
  
  // this is required if you are targetting iOS 5.1 or lower, only
  if not assigned(result) then
    result := new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier(CellIdentifier);

  //var lObject := fObjects[indexPath.row]; // 59210: Toffee: object subscripting support on older deployment targets
  var lObject := fObjects.objectAtIndex(indexPath.row);
  result.textLabel.text := lObject.description;
end;

// Override to support conditional editing of the table view.
method MasterViewController.tableView(tableView: UITableView) canEditRowAtIndexPath(indexPath: NSIndexPath): RemObjects.Oxygene.System.Boolean;
begin
  // Return FALSE if you do not want the specified item to be editable.
  result := true;
end;

// Override to support editing the table view.
method MasterViewController.tableView(tableView: UITableView) commitEditingStyle(editingStyle: UITableViewCellEditingStyle) forRowAtIndexPath(indexPath: NSIndexPath);
begin
  if (editingStyle = UITableViewCellEditingStyle.UITableViewCellEditingStyleDelete) then begin
    // Delete the row from the data source
    fObjects.removeObjectAtIndex(indexPath.row);
    //tableView.deleteRowsAtIndexPaths([indexPath]) withRowAnimation(UITableViewRowAnimation.UITableViewRowAnimationFade);  // we dont have inline arrays yet
    tableView.deleteRowsAtIndexPaths(NSArray.arrayWithObject(indexPath)) withRowAnimation(UITableViewRowAnimation.UITableViewRowAnimationFade);
  end
  else if (editingStyle = UITableViewCellEditingStyle.UITableViewCellEditingStyleInsert) then begin
    // Create a new instance of the appropriabte class, insert it into the array, and add a new row to the table view
  end;
end;

method MasterViewController.tableView(tableView: UITableView) moveRowAtIndexPath(fromIndexPath: NSIndexPath) toIndexPath(toIndexPath: NSIndexPath);
begin
end;

// Override to support conditional rearranging of the table view.
method MasterViewController.tableView(tableView: UITableView) canMoveRowAtIndexPath(indexPath: NSIndexPath): RemObjects.Oxygene.System.Boolean;
begin
    // Return NO if you do not want the item to be re-orderable.
    result := true;
end;

{$ENDREGION}

{$REGION  Table view delegate}

method MasterViewController.tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
begin
  if UIDevice.currentDevice.userInterfaceIdiom = UIUserInterfaceIdiom.UIUserInterfaceIdiomPad then begin
    //var lObject := fObjects[indexPath.row]; // 59210: Toffee: object subscripting support on older deployment targets
    var lObject := fObjects.objectAtIndex(indexPath.row);
      detailViewController.detailItem := lObject;
  end;
end;

{$ENDREGION}

method MasterViewController.prepareForSegue(segue: not nullable UIStoryboardSegue) sender(sender: id);
begin
  if segue.identifier.isEqualToString('showDetail') then begin
    var lIndexPath := tableView.indexPathForSelectedRow;

    //var lObject := fObjects[lIndexPath.row]; // 59210: Toffee: object subscripting support on older deployment targets
    var lObject := fObjects.objectAtIndex(lIndexPath.row);
    
   // segue.destinationViewController.setDetailItem(lObject); //59090: Toffee: cannot access members defined in project, on "id"
    (segue.destinationViewController as  DetailViewController).setDetailItem(lObject);
  end;
end;

end.
