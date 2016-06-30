namespace CSharpiOSTableViewDemo
{
	using UIKit;

	[IBObject]
	class RootViewController : UIViewController, IUITableViewDelegate, IUITableViewDataSource
	{


		private string[] dataArray;

		public override id init()
		{
			this = base.initWithNibName("RootViewController") bundle(null);
			if (this != null)
			{
				title = "TableView Demo";
				this.dataArray =  new string[] {"Athens" , "Paris",	 "St. Louis" , "Athens", "London", "Stockholm", "Berlin",  "Antwerp", "Chamonix",	"St. Moritz",	"Amsterdam"	, "Los Angeles", "Lake Placid",
				"Garmisch-Partenkirchen", "Tokyo", "Sapporo", "Cortina d'Ampezzo", "Oslo", "Helsinki",	"Melbourne", "Stockholm", "Squaw Valley", "Rome",
				"Innsbruck"	, "Mexico City", "Grenoble"	,"Sapporo" ,"Munich", "Montreal", "Moscow", "Lake Placid", "Sarajevo", "Seoul", "Calgary", "Barcelona", "Albertville",
				"Lillehammer", "Atlanta", "Nagano", "Sydney", "Salt Lake City", "Turin", "Beijing", "Vancouver", "Sochi","Rio de Janero", "Pyeongchang"};
			}
			return this;
		}

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			// Do any additional setup after loading the view.
		}


		//IUITableViewDataSource Methods
		private UITableViewCell! tableView(UITableView! tableView) cellForRowAtIndexPath(NSIndexPath! indexPath)
		{
			UITableViewCell cell = tableView.dequeueReusableCellWithIdentifier("SimpleTableCell");
			if (cell == null)
				cell = new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier("SimpleTableCell");

			cell.textLabel.text = this.dataArray[indexPath.row];

			return cell!;   
		}

		private NSInteger tableView(UITableView! tableView) numberOfRowsInSection(NSInteger section)
		{
			return this.dataArray.length;
		}

		private NSInteger numberOfSectionsInTableView(UITableView tableView)
		{
			return 1;
		}

		//IUITableViewDelegate Methods
		private void tableView(UITableView tableView) didSelectRowAtIndexPath(NSIndexPath indexPath)
		{
			string text = tableView.cellForRowAtIndexPath(indexPath).textLabel.text;
			UIAlertView message = new UIAlertView withTitle("City Selected") message(text) @delegate(null) cancelButtonTitle("OK") otherButtonTitles(null);
			message.show();
		}
	}
}