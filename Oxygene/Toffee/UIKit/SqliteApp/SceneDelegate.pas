namespace SqliteApp;

uses UIKit;

type
  [IBObject]
  SceneDelegate = public class(IUIWindowSceneDelegate)
  public
    property window: UIWindow;

    method scene(aScene: UIScene) willConnectToSession(aSession: UISceneSession) options(aOptions: UISceneConnectionOptions);
    begin
      if not (aScene is UIWindowScene) then
        exit;

      window := new UIWindow withWindowScene(UIWindowScene(aScene));
      var lStoryboardName := "MainStoryboard~iPhone";
      if UIDevice.currentDevice.userInterfaceIdiom = UIUserInterfaceIdiom.Pad then
        lStoryboardName := "MainStoryboard~iPad";
      window.rootViewController := UIStoryboard.storyboardWithName(lStoryboardName) bundle(nil).instantiateInitialViewController;
      if window.rootViewController is var lSplit: UISplitViewController then begin
        var lNavigation := lSplit.viewControllers.lastObject as UINavigationController;
        lSplit.delegate := lNavigation.topViewController as IUISplitViewControllerDelegate;
      end;
      window.makeKeyAndVisible;
    end;
  end;

end.
