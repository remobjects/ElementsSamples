namespace OxygeneiOSUITableViewDemo;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController, IUITableViewDataSource, IUITableViewDelegate)
  private
    //Data the Table
    dataArray: array of NSString;
    //IUITableViewDataSource
    method tableView(tableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
    method tableView(tableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    method numberOfSectionsInTableView(tableView: UITableView): NSInteger;
    //IUITabkeViewDelegate
    method tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
  public
    method init: id; override;
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin
    title := 'Oxygene UITableView Demo';
    dataArray := ['Athens' , 'Paris',   'St. Louis' , 'Athens', 'London', 'Stockholm', 'Berlin',  'Antwerp', 'Chamonix',  'St. Moritz',  'Amsterdam'  , 'Los Angeles', 'Lake Placid',
                 'Garmisch-Partenkirchen', 'Tokyo', 'Sapporo', "Cortina d'Ampezzo", 'Oslo', 'Helsinki',  'Melbourne', 'Stockholm', 'Squaw Valley', 'Rome',
                 'Innsbruck'  , 'Mexico City', 'Grenoble'  ,'Sapporo' ,'Munich', 'Montreal', 'Moscow', 'Lake Placid', 'Sarajevo', 'Seoul', 'Calgary', 'Barcelona', 'Albertville',
                 'Lillehammer', 'Atlanta', 'Nagano', 'Sydney', 'Salt Lake City', 'Turin', 'Beijing', 'Vancouver', 'Sochi','Rio de Janero', 'Pyeongchang'];
  end;
  result := self;
end;

method RootViewController.tableView(tableView: not nullable UITableView) cellForRowAtIndexPath(indexPath: not nullable NSIndexPath): not nullable UITableViewCell;
begin
  var cell : UITableViewCell := tableView.dequeueReusableCellWithIdentifier("SimpleTableCell");

  if (cell = nil) then
    cell := new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier("SimpleTableCell");

  cell.textLabel.text := dataArray[indexPath.row];
  result :=  cell as not nullable;
end;

method RootViewController.tableView(tableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
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
