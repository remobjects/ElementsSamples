namespace SqliteApp;

uses Foundation, UIKit;

type
  [IBObject]
  DetailViewController = public class(UIViewController, IUISplitViewControllerDelegate)
  private

    field fDetailItem: id;

    method configureView;
    begin
      if assigned(detailDescriptionLabel) then
        detailDescriptionLabel.text := if assigned(fDetailItem) then fDetailItem.description else "Select an item";
    end;

  public

    [IBOutlet] property detailDescriptionLabel: weak UILabel;
    property detailItem: id read fDetailItem write setDetailItem;

    method setDetailItem(aValue: id);
    begin
      fDetailItem := aValue;
      configureView;
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;
      if assigned(splitViewController) then begin
        navigationItem.leftBarButtonItem := splitViewController.displayModeButtonItem;
        navigationItem.leftItemsSupplementBackButton := true;
      end;
      configureView;
    end;

    method splitViewController(aSplit: UISplitViewController) collapseSecondaryViewController(aSecondary: UIViewController) ontoPrimaryViewController(aPrimary: UIViewController): Boolean;
    begin
      // An empty detail should not cover the master when the window narrows.
      result := not assigned(fDetailItem);
    end;

  end;

end.
