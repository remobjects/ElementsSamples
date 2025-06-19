namespace NSTableView;

interface

uses
  AppKit,
  Foundation;

type
  [IBObject]
  MainWindowController = public class(NSWindowController, INSTableViewDelegate,INSTableViewDataSource)
  private
    people : NSMutableArray;
  protected
  public
    [IBOutlet] tableView : NSTableView;
    [IBOutlet] messageLabel : NSTextField;

    method init: id; override;

    [IBAction] method addPerson(sender : id);
    [IBAction] method removePerson(sender : id);
    method updateMessageLabel();
   

    //INSTableViewDataSource
    method tableView(tblView : NSTableView) objectValueForTableColumn(tableColumn: NSTableColumn) row(row : NSInteger): id;
    method tableView(tblView : NSTableView) setObjectValue(obj: id) forTableColumn(tableColumn : NSTableColumn) row(row: NSInteger);
    method numberOfRowsInTableView(tblView : NSTableView): NSInteger;

    //iNSTableViewDelegate
    method tableViewSelectionDidChange(aNotification : NSNotification);
  end;

implementation

method MainWindowController.init: id;
begin
  self := inherited initWithWindowNibName('MainWindowController');
  if assigned(self) then begin
    self.people := new NSMutableArray();
  end;
  result := self;
end;


method MainWindowController.addPerson(sender: id);
begin
   var person := new Person();
   person.name :=  "New Person";
   person.age := 21;
   self.people.addObject(person);
   self.tableView.reloadData();
   self.updateMessageLabel();
end;

method MainWindowController.removePerson(sender: id);
begin
   var row := self.tableView.selectedRow();
   if (row > -1) and (row < self.people.count()) then begin
     self.tableView.abortEditing();
     self.people.removeObjectAtIndex(row);
     self.tableView.reloadData();
     self.updateMessageLabel();
   end;
end;

method MainWindowController.updateMessageLabel();
begin
   var row := self.tableView.selectedRow();
   if (row > -1) and (row < self.people.count()) then begin
     var person := self.people.objectAtIndex(row);
     self.messageLabel.stringValue := person.name;
   end else begin
     self.messageLabel.stringValue := "";
   end;
end;

method MainWindowController.tableView(tblView: NSTableView) objectValueForTableColumn(tableColumn: NSTableColumn) row(row: NSInteger): id;
begin
  var person := self.people.objectAtIndex(row);
  case tableColumn.identifier of 
    "name": 
      result := person.name;
    "age": 
      result := person.age;
    else 
      result := "Unknown";
  end;
end;

method MainWindowController.tableView(tblView: NSTableView) setObjectValue(obj: id) forTableColumn(tableColumn: NSTableColumn) row(row: NSInteger);
begin
  var person : Person := self.people.objectAtIndex(row);
  case tableColumn.identifier of 
    "name": 
      person.name := obj;
    "age": 
      person.age := obj.intValue;
  end;
  self.updateMessageLabel();
end;

method MainWindowController.numberOfRowsInTableView(tblView: NSTableView): NSInteger;
begin
  result := self.people.count();
end;

method MainWindowController.tableViewSelectionDidChange(aNotification: NSNotification);
begin
  self.updateMessageLabel();
end;

end.
