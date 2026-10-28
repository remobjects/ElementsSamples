namespace Maps;

uses
  UIKit;

type
  SearchResultsViewController = public class(UIViewController)
  public

    constructor;
    begin
      inherited constructor;

      // Custom initialization

    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;

      // Do any additional setup after loading the view.
    end;

    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning;

      // Dispose of any resources that can be recreated.
    end;

    property tableView: weak UITableView;

  end;

end.
