namespace Maps;

interface

uses
  UIKit;

type
  SearchResultsViewController = public class(UIViewController)
  private
  public
    method init: id; override;

    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;

    property tableView: weak UITableView;
 
  end;
 
implementation
 
method SearchResultsViewController.init: id;
begin
  self := inherited init;
  if assigned(self) then begin
    
    // Custom initialization
 
  end;
  result := self;
end;
 
method SearchResultsViewController.viewDidLoad;
begin
  inherited viewDidLoad;
 
  // Do any additional setup after loading the view.
end;
 
method SearchResultsViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;
 
  // Dispose of any resources that can be recreated.
end;
 
end.
