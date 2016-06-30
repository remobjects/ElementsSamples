namespace SqliteApp;

interface

uses
  Foundation, 
  UIKit;

type
  DetailViewController = public class (UIViewController, IUISplitViewControllerDelegate)
  private
    fDetailItem: id;
    method setDetailItem(newDetailItem: id);
    method configureView;
  protected
  public
    property detailItem: id read fDetailItem write setDetailItem;
    property detailDescriptionLabel: weak UILabel;

    property masterPopoverController: UIPopoverController;

    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;
    method splitViewController(splitController: UISplitViewController) willHideViewController(viewController: UIViewController) withBarButtonItem(barButtonItem: UIBarButtonItem) forPopoverController(popoverController: UIPopoverController);
    method splitViewController(splitController: UISplitViewController) willShowViewController(viewController: UIViewController) invalidatingBarButtonItem(barButtonItem: UIBarButtonItem);
  end;

implementation

method DetailViewController.viewDidLoad;
begin
  inherited.viewDidLoad;
	
  // Do any additional setup after loading the view, typically from a nib.
  configureView();
end;

method DetailViewController.setDetailItem(newDetailItem: id);
begin
  if fDetailItem ≠ newDetailItem then begin
    fDetailItem := newDetailItem;
    configureView();
  end;

  if assigned(masterPopoverController) then
    masterPopoverController.dismissPopoverAnimated(true);
end;

method DetailViewController.configureView;
begin
  // Update the user interface for the detail item.

  if assigned(detailItem) then
    //detailDescriptionLabel.text := detailItem.description; //bug: why isn't detailDescriptionLabel getting connected from storyboard? 
end;

method DetailViewController.didReceiveMemoryWarning;
begin
  inherited.didReceiveMemoryWarning;
  // Dispose of any resources that can be recreated.
end;

{$REGION Split view delegate}

method DetailViewController.splitViewController(splitController: UISplitViewController) 
                            willHideViewController(viewController: UIViewController) 
                            withBarButtonItem(barButtonItem: UIBarButtonItem) 
                            forPopoverController(popoverController: UIPopoverController);
begin
  barButtonItem:title := 'Master';
  navigationItem:setLeftBarButtonItem(barButtonItem) animated(true);
  masterPopoverController := popoverController;
end;

method DetailViewController.splitViewController(splitController: UISplitViewController)
                            willShowViewController(viewController:  UIViewController)
                            invalidatingBarButtonItem(barButtonItem:  UIBarButtonItem);
begin
  // Called when the view is shown again in the split view, invalidating the button and popover controller.
  navigationItem.setLeftBarButtonItem(nil) animated(true);
  masterPopoverController := nil;
end;

{$ENDREGION}

end.
