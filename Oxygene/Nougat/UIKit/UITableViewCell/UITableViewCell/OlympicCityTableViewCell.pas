namespace OxygeneiOSUITableViewCellDemo;

interface

uses
  UIKit;

type
  [IBObject]
  OlympicCityTableViewCell = public class(UITableViewCell )
  private
  public
    [IBOutlet] city : UILabel;
    [IBOutlet] country : UILabel;
    [IBOutlet] gamesType : UILabel;
    [IBOutlet] year : UILabel;
    [IBOutlet] notes : UILabel;

    method awakeFromNib; override;
  end;

implementation

method OlympicCityTableViewCell.awakeFromNib;
begin
  inherited;
  NSLog("Cell Created");
end;



end.
