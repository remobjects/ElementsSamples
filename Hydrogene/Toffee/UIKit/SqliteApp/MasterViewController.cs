namespace SqliteApp
{
	using UIKit;
	using libsqlite3;

	[IBObject]
	class MasterViewController : UITableViewController
	{
		private NSMutableArray _objects;
		public DetailViewController detailViewController { get; set; }

		public override void awakeFromNib()
		{
			if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiom.UIUserInterfaceIdiomPad)
			{
				clearsSelectionOnViewWillAppear = true;
				contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
			}
			base.awakeFromNib();
		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			
			if (splitViewController != null)
				detailViewController = (DetailViewController)(splitViewController.viewControllers().lastObject().topViewController);
				
			_objects = new NSMutableArray();

			string lDatabaseName = NSBundle.mainBundle.pathForResource("PCTrade.sqlite") ofType("db");
			NSLog("%@", lDatabaseName);
	
			sqlite3_ *lDatabase = null;
			if (sqlite3_open(lDatabaseName.cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding), &lDatabase) == SQLITE_OK)
			{
	
				sqlite3_stmt *lStatement;
				if (sqlite3_prepare_v2(lDatabase, "select * from Customers", -1, &lStatement, null) == SQLITE_OK)
				{
		  
					while (sqlite3_step(lStatement) == SQLITE_ROW)
					{
	
						var lName = (AnsiChar *)(sqlite3_column_text(lStatement, 1));
						_objects.addObject(NSString.stringWithUTF8String(lName));
						NSLog("row: %s", lName);
					}
	
				}
				sqlite3_close(lDatabase);
			}
			tableView.reloadData();

		}  

		public override void didReceiveMemoryWarning()
		{
			 base.didReceiveMemoryWarning();
			 // Dispose of any resources that can be recreated.
		}

		public override void prepareForSegue(UIStoryboardSegue! segue) sender(id sender)
		{
			 if (segue.identifier.isEqualToString("showDetail"))
			 {
				 var indexPath = tableView.indexPathForSelectedRow;
				 var obj = _objects[indexPath.row];

				 segue.destinationViewController.setDetailItem(obj);
				 ((DetailViewController)segue.destinationViewController).setDetailItem(obj);
			 }
		}

		#region Table view data source
		public Integer numberOfSectionsInTableView(UITableView tableView)
		{
			return 1;
		}

		public Integer tableView(UITableView tableView) numberOfRowsInSection(NSInteger section)
		{
			 return _objects != null ? _objects.count : 0;
		}

		public UITableViewCell tableView(UITableView tableView) cellForRowAtIndexPath(NSIndexPath indexPath)
		{
			var cellIdentifier = "MasterCell";
			var result = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
			
			if (result == null)
				result = new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier(cellIdentifier);
			
			var obj = _objects[indexPath.row];
			result.textLabel.text = obj.description;

			return result;
		}

		public Boolean tableView(UITableView tableView) canEditRowAtIndexPath(NSIndexPath indexPath)
		{
			return true;
		}

		public void tableView(UITableView tableView) commitEditingStyle(UITableViewCellEditingStyle editingStyle) forRowAtIndexPath(NSIndexPath indexPath)
		{
			if (editingStyle == UITableViewCellEditingStyle.UITableViewCellEditingStyleDelete)
			{
				// Delete the row from the data source
				_objects.removeObjectAtIndex(indexPath.row);
				tableView.deleteRowsAtIndexPaths(new [] {indexPath}) withRowAnimation(UITableViewRowAnimation.UITableViewRowAnimationFade);
			}
			else if (editingStyle == UITableViewCellEditingStyle.UITableViewCellEditingStyleInsert)
			{
			  // Create a new instance of the appropriabte class, insert it into the array, and add a new row to the table view
			}
		}

		public Boolean tableView(UITableView tableView) canMoveRowAtIndexPath(NSIndexPath indexPath)
		{
			return true;
		}

		public void tableView(UITableView tableView) moveRowAtIndexPath(NSIndexPath fromIndexPath) toIndexPath(NSIndexPath toIndexPath)
		{
		}

		#endregion

		#region Table view delegate
		public void tableView(UITableView tableView) didSelectRowAtIndexPath(NSIndexPath indexPath)
		{
			if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiom.UIUserInterfaceIdiomPad)
			{
				var obj = _objects[indexPath.row];
				detailViewController.detailItem = obj;
			}
		}
		#endregion

	}
}
