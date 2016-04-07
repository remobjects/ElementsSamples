namespace ToDoManager
{
	using AppKit;
	
	public interface IDialogDelegate
	{
		void onOk(id data);
		void onCancel(id data);
	}
	
	[IBObject]
	public class MainWindowController : NSWindowController, IDialogDelegate, INSTableViewDataSource, INSTableViewDelegate
	{
		#region Properties
		private TaskEditorController _editor;
		
		[IBOutlet]
		public NSTableView tableViewOutlet;
		
		#endregion
		
		#region Actions
		
		[IBAction]
		public void loadDataAction(id sender)
		{
			this.tableViewOutlet.reloadData();
		}
		
		[IBAction]
		public void addTaskAction(id sender)
		{
			NSDate tommorow = new NSDate().dateByAddingTimeInterval( 60 * 60 * 24 * 1);
			TaskModel task = 
				DataLayer.newTaskWithSubject("New TODO?") 
					andPriority(5) 
					datedBy(tommorow);
			this.showEditorSheetForTask(task);
		}
		
		[IBAction]
		public void editTaskAction(id sender)
		{
			NSInteger row = this.tableViewOutlet.selectedRow();
			if (row < 0)
				return;
				
			TaskModel task = DataLayer.sharedInstance.tasks[row];
			this.showEditorSheetForTask(task);
		}
		
		[IBAction]
		public void removeTaskAction(id sender)
		{
			NSInteger row = this.tableViewOutlet.selectedRow();
			if (row < 0)
				return;
			NSAlert a = NSAlert.alertWithMessageText("Remove task?") defaultButton("Remove") alternateButton("Cancel") otherButton(null) informativeTextWithFormat("Do you really want to delete task?"); 
			a.beginSheetModalForWindow(this.window) modalDelegate(this) didEndSelector(__selector(deleteAlert:result:context:)) contextInfo(null); 
		}
		
		private void deleteAlert(NSAlert alert) result(NSInteger res) context(id ctx)
		{
			if (res != 1) 
				return;
			NSInteger index = this.tableViewOutlet.selectedRow();
			DataLayer.sharedInstance.tasks.removeObjectAtIndex(index);
			this.loadDataAction(this);
		}
		
		#endregion
		
		public override id init()
		{
			this = base.initWithWindowNibName("MainWindowController");
			if (this != null)
			{
				// Custom initialization
				_editor = new TaskEditorController().init();
				_editor.@delegate = this;
			}
			return this;
		}
		
		public override void windowDidLoad()
		{
			base.windowDidLoad();
			
			// Implement this method to handle any initialization after your window controller's
			// window has been loaded from its nib file.
			this.tableViewOutlet.doubleAction = __selector(tableViewDidDoubleClick:);
		}
		
		private void tableViewDidDoubleClick(id sender) 
		{
			NSInteger index = this.tableViewOutlet.clickedRow;
			if (index == -1) {
				this.addTaskAction(sender);
				return;
			}
			
			TaskModel task = DataLayer.sharedInstance.tasks[index];			
			this.showEditorSheetForTask(task);
		}
		
		#region INSTableViewDataSource implementation
		
 		public NSInteger numberOfRowsInTableView(NSTableView tableView)
		{
			return DataLayer.sharedInstance.tasks.count();
		}
		
		public id tableView(NSTableView tableView) objectValueForTableColumn(NSTableColumn tableColumn) row(NSInteger row)
		{
			NSString columnName = tableColumn.identifier;
			TaskModel task = DataLayer.sharedInstance.tasks[row];
			
			if ("Subject" == columnName)
				return task.subject;
			
			if ("Priority" == columnName)
				return NSString.stringWithFormat("%@", task.priority);
			
			if ("DueDate" == columnName)
				return Helpers.sharedInstance.stringFromDate(task.dueDate);
			
			return "nothing?";
		}
		
		#endregion
		
		#region INSTableViewDelegate implementation
		
		public BOOL tableView(NSTableView tableView) isGroupRow(NSInteger row)
		{
			return false;
		}
		
		public void tableView(NSTableView tableView) willDisplayCell(id cell) forTableColumn(NSTableColumn tableColumn) row(NSInteger row)
		{
			TaskModel task = DataLayer.sharedInstance.tasks[row];
			
			if (task.done)
				cell.textColor = NSColor.grayColor; 
			else
				cell.textColor = NSColor.blackColor;
		}
		
		#endregion
		
		#region IDialogDelegate implementation
		public void onOk(id data)
		{
			NSLog("Edit dialog has been approved.");
			if (DataLayer.sharedInstance.tasks.indexOfObject(data) == NSNotFound)
			{
				DataLayer.sharedInstance.tasks.addObject(data);
				NSLog("New entry has been added.");
			}
			this.loadDataAction(this);
		}
		
		public void onCancel(id data)
		{
			NSLog("Edit dialog has been canceled.");
		}
		
		#endregion
		
		#region Helper methods
		
		private void showEditorSheetForTask(TaskModel task)
		{
			_editor.TaskToEdit = task;
			_editor.showAsSheetForWindow(this.window);	
		}
		
		#endregion
		
	}
}
