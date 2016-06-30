namespace Maps;

interface

uses
  UIKit;

type
  FlipsideViewController = public class(UIViewController)
  private
  public

    method awakeFromNib; override;
    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;
    property prefersStatusBarHidden: Boolean read true; override;

    method done(aSender: id); { IBAction }

    property &delegate: weak IFlipsideViewControllerDelegate;

  end;

  IFlipsideViewControllerDelegate = public interface
    method flipsideViewControllerDidFinish(controller: FlipsideViewController);
  end;

implementation


method FlipsideViewController.awakeFromNib;
begin
  contentSizeForViewInPopover := CGSizeMake(320.0, 480.0);
  inherited awakeFromNib;
end;

method FlipsideViewController.viewDidLoad;
begin
  inherited viewDidLoad;

  // Do any additional setup after loading the view.
end;

method FlipsideViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;

  // Dispose of any resources that can be recreated.
end;

method FlipsideViewController.done(aSender: id);
begin
  &delegate.flipsideViewControllerDidFinish(self); // ToDo: use colon!
end;

end.
