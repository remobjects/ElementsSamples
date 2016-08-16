using AppKit;

namespace NSTableView
{
	[IBObject]
	public class MainWindowController : NSWindowController, INSTableViewDataSource, INSTableViewDelegate
	{

		[IBOutlet]
		public NSTableView tableView;

		[IBOutlet]
		public NSTextField messageLabel;

		private NSMutableArray people;


		public override id init()
		{
			this = base.initWithWindowNibName("MainWindowController");
			if (this != null)
			{
				this.people = new NSMutableArray();
			}
			return this;
		}

		public override void windowDidLoad()
		{
			base.windowDidLoad();

			// Implement this method to handle any initialization after your window controller's
			// window has been loaded from its nib file.
		}

		[IBAction]
		public void addPerson(id  sender)
		{
			Person person = new Person();
			person.name = "New Person";
			person.age = 21;
			this.people.addObject(person);
			this.tableView.reloadData();
			self.updateMessageLabel();  
		}

		[IBAction]
		public void removePerson(id  sender)
		{
			this.tableView.abortEditing();
			int row = this.tableView.selectedRow();
			if (row > -1 && row < this.people.count())
			{
				this.people.removeObjectAtIndex(row);
				this.tableView.reloadData();
				self.updateMessageLabel();
			}
		}

		public void updateMessageLabel()
		{
			int row = this.tableView.selectedRow();
			if (row > -1 && row < this.people.count()) {
				Person person = this.people.objectAtIndex(row);
				this.messageLabel.stringValue = person.name;
			}
			else
			{
				this.messageLabel.stringValue = "";
			}
		}
	  
		#region ITableViewDataSource

		public NSInteger numberOfRowsInTableView(NSTableView tableView)
		{
			return this.people.count();
		}

		public id tableView(NSTableView tableView) objectValueForTableColumn(NSTableColumn tableColumn) row(NSInteger row)
		{
			Person person = this.people.objectAtIndex(row);
			if (tableColumn.identifier == "name")
			{
				return person.name;
			}
			else if (tableColumn.identifier == "age")
			{
				return person.age;
			} else {
				return "Unkown";
			}
		}
	
		public void tableView(NSTableView tableView) setObjectValue(id obj) forTableColumn(NSTableColumn tableColumn) row(NSInteger row)
		{
			Person person = this.people.objectAtIndex(row);
			if (tableColumn.identifier == "name")
			{
				person.name = obj;
			}
			else if (tableColumn.identifier == "age")
			{
				person.age = obj.intValue;
			}
			self.updateMessageLabel();
		}

		#endregion

		#region ITableViewDelegate

		public void tableViewSelectionDidChange(NSNotification aNotification)
		{
			self.updateMessageLabel();
		}

		#endregion

	}
}
