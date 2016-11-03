using UIKit;

namespace CSharpiOSUITableViewControllerDemo
{
	[IBObject]
	public class RootViewController: UITableViewController
	{


		private string[] dataArray;
		
		public override id init()
		{
			this = base.init;
			if (this != null)
			{
				title = "CSharp UITableViewController Demo";
				this.dataArray =  new string[] {"Athens" , "Paris",	 "St. Louis" , "Athens", "London", "Stockholm", "Berlin",  "Antwerp", "Chamonix",	"St. Moritz",	"Amsterdam"	, "Los Angeles", "Lake Placid",
				"Garmisch-Partenkirchen", "Tokyo", "Sapporo", "Cortina d'Ampezzo", "Oslo", "Helsinki",	"Melbourne", "Stockholm", "Squaw Valley", "Rome",
				"Innsbruck"	, "Mexico City", "Grenoble"	,"Sapporo" ,"Munich", "Montreal", "Moscow", "Lake Placid", "Sarajevo", "Seoul", "Calgary", "Barcelona", "Albertville",
				"Lillehammer", "Atlanta", "Nagano", "Sydney", "Salt Lake City", "Turin", "Beijing", "Vancouver", "Sochi","Rio de Janero", "Pyeongchang"};
			}
			
			return this;
		}


		#region Table view data source
		protected NSInteger numberOfSectionsInTableView(UITableView tableView)
		{
			// Return the number of sections.
			return 1;
		}
		
		protected int tableView(UITableView tableView) numberOfRowsInSection(Integer section)
		{
			return dataArray.length;
		}
		
		protected UITableViewCell tableView(UITableView tableView) cellForRowAtIndexPath(NSIndexPath indexPath)
		{
			UITableViewCell cell = tableView.dequeueReusableCellWithIdentifier("SimpleTableCell");
			if (cell == null)
				cell = new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier("SimpleTableCell");

			cell.textLabel.text = this.dataArray[indexPath.row];

			return cell; 
		}
	
		#endregion
		
		#region Table view delegate
		protected void tableView(UITableView tableView) didSelectRowAtIndexPath(NSIndexPath indexPath)
		{
			string text = tableView.cellForRowAtIndexPath(indexPath).textLabel.text;
			UIAlertView message = new UIAlertView withTitle("City Selected") message(text) @delegate(null) cancelButtonTitle("OK") otherButtonTitles(null);
			message.show();
		}

		#endregion
		
	
		
	}
}