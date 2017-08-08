package ToDoManager;

import AppKit.*;

public interface IDialogDelegate
{
	void onOk(id data);
	void onCancel(id data);
}

@IBObject
public class MainWindowController extends NSWindowController implements IDialogDelegate, INSTableViewDataSource, INSTableViewDelegate
{
	private TaskEditorController _editor;
	@IBOutlet
	public NSTableView tableViewOutlet;

	@IBAction
	public void loadDataAction(id sender)
	{
		this.tableViewOutlet.reloadData();
	}

	@IBAction
	public void addTaskAction(id sender)
	{
		NSDate tommorow = new NSDate().dateByAddingTimeInterval( 60 * 60 * 24 * 1);
		TaskModel task =
			DataLayer.newTaskWithSubject("New TODO?")
				andPriority(5)
				datedBy(tommorow);
		this.showEditorSheetForTask(task);
	}

	@IBAction
	public void editTaskAction(id sender)
	{
		NSInteger row = this.tableViewOutlet.selectedRow();
		if (row < 0)
			return;

		TaskModel task = DataLayer.getSharedInstance().getTasks()[row];
		this.showEditorSheetForTask(task);
	}

	@IBAction
	public void removeTaskAction(id sender)
	{
		NSInteger row = this.tableViewOutlet.selectedRow();
		if (row < 0)
			return;
		NSAlert a = NSAlert.alertWithMessageText("Remove task?") defaultButton("Remove") alternateButton("Cancel") otherButton(null) informativeTextWithFormat("Do you really want to delete task?");
		a.beginSheetModalForWindow(this.window) modalDelegate(this) didEndSelector(NSSelectorFromString("deleteAlert:result:context:")) contextInfo(null);
	}

	private void deleteAlert(NSAlert alert) result(NSInteger res) context(id ctx)
	{
		if (res != 1)
			return;
		NSInteger index = this.tableViewOutlet.selectedRow();
		DataLayer.getSharedInstance().getTasks().removeObjectAtIndex(index);
		this.loadDataAction(this);
	}

	@Override
	public id init()
	{
		this = super.initWithWindowNibName("MainWindowController");
		if (this != null)
		{
			// Custom initialization
			_editor = new TaskEditorController().init();
			_editor.delegate = this;
		}
		return this;
	}

	@Override
	public void windowDidLoad()
	{
		super.windowDidLoad();

		// Implement this method to handle any initialization after your window controller's
		// window has been loaded from its nib file.
		this.tableViewOutlet.doubleAction = NSSelectorFromString("tableViewDidDoubleClick:");
	}

	private void tableViewDidDoubleClick(id sender)
	{
		NSInteger index = this.tableViewOutlet.clickedRow;
		if (index == -1) {
			this.addTaskAction(sender);
			return;
		}

		TaskModel task = DataLayer.getSharedInstance().getTasks()[index];
		this.showEditorSheetForTask(task);
	}

	 public NSInteger numberOfRowsInTableView(NSTableView tableView)
	{
		return DataLayer.getSharedInstance().getTasks().count();
	}

	public id tableView(NSTableView tableView) objectValueForTableColumn(NSTableColumn tableColumn) row(NSInteger row)
	{
		NSString columnName = tableColumn.identifier;
		TaskModel task = DataLayer.getSharedInstance().getTasks()[row];

		if ("Subject" == columnName)
			return task.subject;

		if ("Priority" == columnName)
			return NSString.stringWithFormat("%@", task.priority);

		if ("DueDate" == columnName)
			return Helpers.getSharedInstance().stringFromDate(task.dueDate);

		return "nothing?";
	}

	public boolean tableView(NSTableView tableView) isGroupRow(NSInteger row)
	{
		return false;
	}

	public void tableView(NSTableView tableView) willDisplayCell(id cell) forTableColumn(NSTableColumn tableColumn) row(NSInteger row)
	{
		TaskModel task = DataLayer.getSharedInstance().getTasks()[row];

		if (task.done)
			cell.textColor = NSColor.grayColor;
		else
			cell.textColor = NSColor.blackColor;
	}

	public void onOk(id data)
	{
		NSLog("Edit dialog has been approved.");
		if (DataLayer.getSharedInstance().getTasks().indexOfObject(data) == NSNotFound)
		{
			DataLayer.getSharedInstance().getTasks().addObject(data);
			NSLog("New entry has been added.");
		}
		this.loadDataAction(this);
	}

	public void onCancel(id data)
	{
		NSLog("Edit dialog has been canceled.");
	}

	private void showEditorSheetForTask(TaskModel task)
	{
		_editor.setTaskToEdit(task);
		_editor.showAsSheetForWindow(this.window);
	}
}