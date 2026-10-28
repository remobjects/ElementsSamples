namespace TabBar;

uses
  UIKit;

type
  [IBObject]
  RootViewController = public class(UIViewController, IUITabBarDelegate)
  private

    fSelectedTab: weak UITabBarItem;
  public

    constructor;
    begin
      inherited constructor withNibName('RootViewController') bundle(nil);

      title := 'TabBar';

      // Custom initialization
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;

      label.text := 'Select a Tab';
      button.hidden := true;

      // Do any additional setup after loading the view.
    end;

    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning;

      // Dispose of any resources that can be recreated.
    end;

    {$REGION IUITabBarDelegate}
    method tabBar(aTabBar: UITabBar) didSelectItem(aItem: UITabBarItem);
    begin
      NSLog('tabbar:%@ didSelectItem:%@', aTabBar, aItem);
      fSelectedTab := aItem;

      label.text := 'Selected tab '+tabBar.items.indexOfObject(aItem);
      button.hidden := false;
    end;
    //method tabBar(aTabBar: UITabBar) willBeginCustomizingItems(aItem: NSArray);
    //method tabBar(aTabBar: UITabBar) willEndCustomizingItems(aItem: NSArray) changed(aChanged: Boolean);
    {$ENDREGION}

    [IBOutlet] property label: weak UILabel;
    [IBOutlet] property button: weak UIButton;
    [IBOutlet] property tabBar: weak UITabBar;
    [IBAction] method buttonClick(aSender: id);
    begin
      if assigned(fSelectedTab) then
        fSelectedTab.badgeValue := coalesce((fSelectedTab.badgeValue:integerValue+1):stringValue, "1");
    end;

  end;

end.
