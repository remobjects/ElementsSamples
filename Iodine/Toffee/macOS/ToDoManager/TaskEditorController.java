package ToDoManager;

import AppKit.*;

@IBObject
public class TaskEditorController extends NSWindowController
{

	#region Outlets

	@IBOutlet
	public NSTextField subjectTextFieldOutlet;

	@IBOutlet
	public NSDatePicker dueDatePickerOutlet;

	@IBOutlet
	public NSTextField priorityTextFieldOutlet;

	@IBOutlet
	public NSButton doneCheckBoxOutlet;

	#endregion

	#region Actions

	@IBAction
	public void applyAction(id sender)
	{
		this.window.makeFirstResponder(this.window);
		NSApp.endSheet(this.window) returnCode(NSModalResponseOK);
	}

	@IBAction
	public void cancelAction(id sender)
	{
		this.window.makeFirstResponder(this.window);
		NSApp.endSheet(this.window) returnCode(NSModalResponseCancel);
	}

	private TaskModel _taskToEdit;
	public TaskModel getTaskToEdit()
	{
		return _taskToEdit;
	}
	public void setTaskToEdit(TaskModel value)
	{
		if (value != _taskToEdit)
			_taskToEdit = value;
		this.updateData(true);
	}

	public IDialogDelegate delegate;// { set; get; }

	@Override
	public id init()
	{
		this = super.initWithWindowNibName("TaskEditorController");
		if (this != null)
		{
			// Custom initialization
		}
		return this;
	}

	@Override
	public void windowDidLoad()
	{
		super.windowDidLoad();

		// Implement this method to handle any initialization after your window controller's
		// window has been loaded from its nib file.
		this.updateData(true);
	}

	public void showAsSheetForWindow(NSWindow parentWindow)
	{
		this.updateData(true);
		NSApp.beginSheet(this.window)
		  modalForWindow(parentWindow)
		   modalDelegate(this)
		  didEndSelector(NSSelectorFromString("didEndSheet:returnCode:contextInfo:"))
			 contextInfo(null);
	}

	private void didEndSheet(NSWindow sheet) returnCode(int returnCode) contextInfo(id info)
	{
		if (returnCode == 1)
		{
			this.updateData(false);
			this.delegate.onOk(_taskToEdit);
		}
		else
		 {
			this.updateData(true);
			this.delegate.onOk(_taskToEdit);
		}

		this.window.orderOut(this.window);
		NSApp.stopModal();
	}

	private void updateData(Boolean toUI)
	{
		if (toUI)
		{
			if (this.subjectTextFieldOutlet != null)
				this.subjectTextFieldOutlet.stringValue = _taskToEdit.subject;
			if (this.dueDatePickerOutlet != null)
				this.dueDatePickerOutlet.dateValue = _taskToEdit.dueDate;
			if (this.priorityTextFieldOutlet != null)
				this.priorityTextFieldOutlet.stringValue = NSString.stringWithFormat("%@", _taskToEdit.priority);
			if (this.doneCheckBoxOutlet != null)
				this.doneCheckBoxOutlet.state = _taskToEdit.done ? 1 : 0;
		}
		else
		{
			if (this.subjectTextFieldOutlet != null)
				_taskToEdit.subject = this.subjectTextFieldOutlet.stringValue;
			if (this.dueDatePickerOutlet != null)
				_taskToEdit.dueDate = this.dueDatePickerOutlet.dateValue;
			if (this.priorityTextFieldOutlet != null)
				_taskToEdit.priority =  Helpers.getSharedInstance().decimalNumberFromString(this.priorityTextFieldOutlet.stringValue);
			if (this.doneCheckBoxOutlet != null)
				_taskToEdit.done = (this.doneCheckBoxOutlet.state == NSOnState);
		}
	}
}