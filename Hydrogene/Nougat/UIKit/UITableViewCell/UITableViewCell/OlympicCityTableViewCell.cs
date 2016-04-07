using UIKit;

namespace CSharpiOSTableViewCellDemo
{
    [IBObject]
    public class OlympicCityTableViewCell : UITableViewCell
    {
        [IBOutlet]
        public UILabel city;
        [IBOutlet]
        public UILabel country;
        [IBOutlet]
        public UILabel gamesType;
        [IBOutlet]
        public UILabel year;
        [IBOutlet]
        public UILabel notes;

    }
}
