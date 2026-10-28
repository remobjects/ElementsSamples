package CollectionViews;

import UIKit.*;

@IBObject
public class SceneDelegate implements IUIWindowSceneDelegate
{
  public UIWindow window { __get; __set; }

  public void scene(UIScene scene) willConnectToSession(UISceneSession session) options(UISceneConnectionOptions options)
  {
    if (!(scene instanceof UIWindowScene))
      return;

    window = new UIWindow withWindowScene((UIWindowScene)scene);
    window.rootViewController = new UINavigationController withRootViewController(new RootViewController());
    window.makeKeyAndVisible();
  }
}