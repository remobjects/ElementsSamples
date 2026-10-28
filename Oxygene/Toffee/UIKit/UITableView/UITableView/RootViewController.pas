namespace OxygeneiOSUITableViewDemo;

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
    begin
      var cell : UITableViewCell := tableView.dequeueReusableCellWithIdentifier("SimpleTableCell");

      if (cell = nil) then
        cell := new UITableViewCell withStyle(UITableViewCellStyle.UITableViewCellStyleDefault) reuseIdentifier("SimpleTableCell");

      cell.textLabel.text := dataArray[indexPath.row];
      result :=  cell as not nullable;
    end;

    method tableView(tableView: not nullable UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    begin
      result := dataArray.length;
    end;

    method numberOfSectionsInTableView(tableView: UITableView): NSInteger;
    begin
     result := 1;
    end;
    //IUITabkeViewDelegate
    method tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
    begin
     var text := tableView.cellForRowAtIndexPath(indexPath).textLabel.text;
     var message := UIAlertController.alertControllerWithTitle("City Selected") message(text) preferredStyle(UIAlertControllerStyle.Alert);
     message.addAction(UIAlertAction.actionWithTitle("OK") style(UIAlertActionStyle.Default) handler(nil));
     presentViewController(message) animated(true) completion(nil);
    end;
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);
      title := 'Oxygene UITableView Demo';
      dataArray := ['Athens' , 'Paris',   'St. Louis' , 'Athens', 'London', 'Stockholm', 'Berlin',  'Antwerp', 'Chamonix',  'St. Moritz',  'Amsterdam'  , 'Los Angeles', 'Lake Placid',
                   'Garmisch-Partenkirchen', 'Tokyo', 'Sapporo', "Cortina d'Ampezzo", 'Oslo', 'Helsinki',  'Melbourne', 'Stockholm', 'Squaw Valley', 'Rome',
                   'Innsbruck'  , 'Mexico City', 'Grenoble'  ,'Sapporo' ,'Munich', 'Montreal', 'Moscow', 'Lake Placid', 'Sarajevo', 'Seoul', 'Calgary', 'Barcelona', 'Albertville',
                   'Lillehammer', 'Atlanta', 'Nagano', 'Sydney', 'Salt Lake City', 'Turin', 'Beijing', 'Vancouver', 'Sochi','Rio de Janero', 'Pyeongchang'];
    end;

  end;

end.
