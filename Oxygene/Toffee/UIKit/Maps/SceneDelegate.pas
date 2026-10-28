namespace Maps;

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
      var lStoryboardName := "MainStoryboard";
      window.rootViewController := UIStoryboard.storyboardWithName(lStoryboardName) bundle(nil).instantiateInitialViewController;
      window.makeKeyAndVisible;
    end;
  end;

end.
