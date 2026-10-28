namespace TicTacToe;

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
      var n := new UINavigationController withRootViewController(new RootViewController);
      n.navigationBar.tintColor := UIColor.darkGrayColor;
      window.rootViewController := n;
      window.makeKeyAndVisible;
    end;
  end;

end.
