using UIKit;

namespace MultipleViews
{
	[IBObject]
	public class RootViewController: UITableViewController
	{
		public this()
		{
			// Custom initialization
		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			title = "Elements";
		}

		public override void didReceiveMemoryWarning()
		{
			base.didReceiveMemoryWarning();

			// Dispose of any resources that can be recreated.
		}

		protected NSInteger numberOfSectionsInTableView(UITableView tableView)
		{
			return 1;
		}

		protected NSInteger tableView(UITableView tableView) numberOfRowsInSection(NSInteger section)
		{
			return Data.languages.count;
		}

		protected UITableViewCell tableView(UITableView tableView) cellForRowAtIndexPath(NSIndexPath indexPath)
		{
			string cellIdentifier = "RootViewControllerCell";

			UITableViewCell cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
			if (cell == null)
			{
				cell = new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier(cellIdentifier);
			}

			cell.textLabel.text = Data.languages[indexPath.row].displayName;
			cell.imageView.image = Data.languages[indexPath.row].image;
			return cell;
		}

		protected void tableView(UITableView tableView) didSelectRowAtIndexPath(NSIndexPath indexPath)
		{
			var detailViewController = new DetailViewController withLanguage(Data.languages[indexPath.row]);
			navigationController.pushViewController(detailViewController) animated(true);
			tableView.deselectRowAtIndexPath(indexPath) animated(true);
		}
	}
}