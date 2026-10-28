namespace SqliteApp
{
  using UIKit;

  [IBObject]
  class DetailViewController : UIViewController, IUISplitViewControllerDelegate
  {
    private id _detailItem;
    [IBOutlet] public __weak UILabel detailDescriptionLabel { get; set; }

    public id detailItem
    {
      get { return _detailItem; }
      set { _detailItem = value; configureView(); }
    }

    private void configureView()
    {
      if (detailDescriptionLabel != null)
        detailDescriptionLabel.text = _detailItem != null ? _detailItem.description : "Select an item";
    }

    public override void viewDidLoad()
    {
      base.viewDidLoad();
      if (splitViewController != null)
      {
        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        navigationItem.leftItemsSupplementBackButton = true;
      }
      configureView();
    }

    public bool splitViewController(UISplitViewController split) collapseSecondaryViewController(UIViewController secondary) ontoPrimaryViewController(UIViewController primary)
    {
      // An empty detail should not cover the master when the window narrows.
      return _detailItem == null;
    }
  }
}
