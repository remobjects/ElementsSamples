namespace OxygeneiOSUITableViewCellDemo;

interface

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UITableViewController)
  private
    //Data for the table
    dataArray: array of array of String;
    //IUITableViewDataSource
    method tableView(tableView: UIKit.UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
    method tableView(tableView: UIKit.UITableView) numberOfRowsInSection(section: NSInteger): NSInteger;
    method numberOfSectionsInTableView(tableView: UITableView): NSInteger;
    //IUITabkeViewDelegate
    method tableView(tableView: UITableView) didSelectRowAtIndexPath(indexPath: NSIndexPath);
    method tableView(tableView: UITableView) heightForRowAtIndexPath(indexPath: NSIndexPath): CGFloat;
  public
    method init: id; override;
    method viewDidLoad; override;
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited init;
  if assigned(self) then begin
    title := 'Oxygene UITableViewCell Demo';
    dataArray := [['Athens','Greece','Summer','1896','April 6 to April 15'],
		['Paris','France','Summer','1900','May 14 to October 28'],
		['St. Louis','United States','Summer','1904','July 1 to November 23'],
		['Athens','Greece','Summer','1906','April 22 to May 2'],
		['London','United Kingdom','Summer','1908','April 27 to October 31'],
		['Stockholm','Sweden','Summer','1912','May 5 to July 22'],
		['Berlin','Germany','Summer','1916','Cancelled due to WWI'],
		['Antwerp','Belgium','Summer','1920','April 20 to September 12'],
		['Chamonix','France','Winter','1924','January 25 to February 4'],
		['Paris','France','Summer','1924','May 4 to July 27'],
		['St. Moritz','Switzerland','Winter','1928','February 11 to February 19'],
		['Amsterdam','Netherlands','Summer','1928','May 17 to August 12'],
		['Lake Placid','United States','Winter','1932','February 4 to February 15'],
		['Los Angeles','United States','Summer','1932','July 30 to August 14'],
		['Garmisch-Partenkirchen','Germany','Winter','1936','February 6 to February 16'],
		['Berlin','Germany','Summer','1936','August 1 to August 16'],
		['Sapporo','Japan','Winter','1940','Cancelled due to WWII'],
		['Tokyo','Japan','Summer','1940','Cancelled due to WWII'],
		["Cortina d'Ampezzo",'Italy','Winter','1944','Cancelled due to WWII'],
		['London','United Kingdom','Summer','1944','Cancelled due to WWII'],
		['St. Moritz','Switzerland','Winter','1948','January 30 to February 8'],
		['London','United Kingdom','Summer','1948','July 29 to August 14'],
		['Oslo','Norway','Winter','1952','February 14 to February 25'],
		['Helsinki','Finland','Summer','1952','July 19 to August 3'],
		["Cortina d'Ampezzo",'Italy','Winter','1956','January 26 to February 5'],
		['Melbourne','Australia','Summer','1956','November 22 to December 8'],
		['Stockholm','Sweden','Summer',' 1956','June 10 to June 17'],
		['Squaw Valley','United States','Winter','1960','February 18 to February 28'],
		['Rome','Italy','Summer','1960','August 25 to September 11'],
		['Innsbruck','Austria','Winter','1964','January 29 to February 9'],
		['Tokyo','Japan','Summer','1964','October 10 to October 24'],
		['Grenoble','France','Winter','1968','February 6 to February 18'],
		['Mexico City','Mexico','Summer','1968','October 12 to October 27'],
		['Sapporo','Japan','Winter','1972','February 3 to February 13'],
		['Munich','West Germany','Summer','1972','August 26 to September 11'],
		['Innsbruck','Austria','Winter','1976','February 4 to February 15'],
		['Montreal','Canada','Summer','1976','July 17 to August 1'],
		['Lake Placid','United States','Winter','1980','February 12 to February 24'],
		['Moscow','Soviet Union','Summer','1980','July 19 to August 3'],
		['Sarajevo','Yugoslavia','Winter','1984','February 7 to February 19'],
		['Los Angeles','United States','Summer','1984','July 28 to August 12'],
		['Calgary','Canada','Winter','1988','February 13 to February 28'],
		['Seoul','South Korea','Summer','1988','September 17 to October 2'],
		['Albertville','France','Winter','1992','February 8 to February 23'],
		['Barcelona','Spain','Summer','1992','July 25 to August 9'],
		['Lillehammer','Norway','Winter','1994','February 12 to February 27'],
		['Atlanta','United States','Summer','1996','July 19 to August 4'],
		['Nagano','Japan','Winter','1998','February 7 to February 22'],
		['Sydney','Australia','Summer','2000','September 15 to October 1'],
		['Salt Lake City','United States','Winter','2002','February 8 to February 24'],
		['Athens','Greece','Summer','2004','August 13 to August 29'],
		['Turin','Italy','Winter','2006','February 10 to February 26'],
		['Beijing','China','Summer','2008','August 8 to August 24'],
		['Vancouver','Canada','Winter','2010','February 12 to February 28'],
		['London','United Kingdom','Summer','2012','July 27 to August 12'],
		['Sochi','Russia','Winter','2014','February 7 to February 23'],
		['Rio de Janeiro','Brazil','Summer','2016','August 5 to August 21'],
		['Pyeongchang','South Korea','Winter','2018','February 9 to February 25'],
		['Tokyo','Japan','Summer','2020','July 24 to August 9']];
  end;
  result := self;
end;

method RootViewController.viewDidLoad;
begin
  inherited viewDidLoad;
  self.tableView.registerNib(UINib.nibWithNibName("OlympicCityTableViewCell") bundle(NSBundle.mainBundle)) forCellReuseIdentifier("OlympicCityCell");
end;

method RootViewController.tableView(tableView: UITableView) cellForRowAtIndexPath(indexPath: NSIndexPath): UITableViewCell;
begin
  var cell : OlympicCityTableViewCell := tableView.dequeueReusableCellWithIdentifier("OlympicCityCell"); // as OlympicCityTableViewCell;

 cell.city.text := dataArray[indexPath.row][0];
 cell.country.text := dataArray[indexPath.row][1];
 cell.gamesType.text := dataArray[indexPath.row][2];
 cell.year.text := dataArray[indexPath.row][3];
 cell.notes.text := dataArray[indexPath.row][4];
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
 var cell : OlympicCityTableViewCell := tableView.cellForRowAtIndexPath(indexPath) as OlympicCityTableViewCell;
 var text := cell.city.text;
 var message := new UIAlertView withTitle("City Selected") message(text) &delegate(nil) cancelButtonTitle("OK") otherButtonTitles(nil);
  message.show();
end;


method RootViewController.tableView(tableView: UITableView) heightForRowAtIndexPath(indexPath: NSIndexPath): CGFloat;
begin
    result :=  143;
end;


end.