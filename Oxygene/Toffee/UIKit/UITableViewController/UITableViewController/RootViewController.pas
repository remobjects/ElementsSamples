namespace OxygeneiOSUITableViewControllerDemo;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UITableViewController)
  private
    //Data for the table
    dataArray: array of String;
    //IUITableViewDataSource
    method tableView(tableView: UIKit.UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
    method tableView(tableView: UIKit.UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    method numberOfSectionsInTableView(tableView: UITableView): NSInteger;
    //IUITabkeViewDelegate
    method tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
  public
    method init: id; override;
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited init;
  if assigned(self) then begin
    title := 'Oxygene UITableViewController Demo';
    dataArray := ['Athens' , 'Paris',	 'St. Louis' , 'Athens', 'London', 'Stockholm', 'Berlin',  'Antwerp', 'Chamonix',	'St. Moritz',	'Amsterdam'	, 'Los Angeles', 'Lake Placid',
                 'Garmisch-Partenkirchen', 'Tokyo', 'Sapporo', "Cortina d'Ampezzo", 'Oslo', 'Helsinki',	'Melbourne', 'Stockholm', 'Squaw Valley', 'Rome',
                 'Innsbruck'	, 'Mexico City', 'Grenoble'	,'Sapporo' ,'Munich', 'Montreal', 'Moscow', 'Lake Placid', 'Sarajevo', 'Seoul', 'Calgary', 'Barcelona', 'Albertville',
                 'Lillehammer', 'Atlanta', 'Nagano', 'Sydney', 'Salt Lake City', 'Turin', 'Beijing', 'Vancouver', 'Sochi','Rio de Janero', 'Pyeongchang'];
  end;
  result := self;
end;

method RootViewController.tableView(tableView: UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
begin
  var cell : UITableViewCell := tableView.dequeueReusableCellWithIdentifier("SimpleTableCell");

  if (cell = nil) then
    cell := new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier("SimpleTableCell");

  cell.textLabel.text := dataArray[indexPath.row];
  result :=  cell;
end;

method RootViewController.tableView(tableView: UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
begin
  result := dataArray.length;
end;

method RootViewController.numberOfSectionsInTableView(tableView: UITableView): NSInteger;
begin
 result := 1;
end;

method RootViewController.tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
begin
 var text := tableView.cellForRowAtIndexPath(indexPath).textLabel.text;
 var message := new UIAlertView withTitle("City Selected") message(text) &delegate(nil) cancelButtonTitle("OK") otherButtonTitles(nil);
  message.show();
end;

end.
