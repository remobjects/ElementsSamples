using UIKit;

namespace CSharpiOSUIAlertViewDemo
{
[IBObject]
public class SceneDelegate : IUIWindowSceneDelegate
{
  public UIWindow window { get; set; }

  public void scene(UIScene scene) willConnectToSession(UISceneSession session) options(UISceneConnectionOptions options)
  {
    if (!(scene is UIWindowScene))
      return;

    window = new UIWindow withWindowScene((UIWindowScene)scene);
    window.rootViewController = new UINavigationController withRootViewController(new RootViewController());
    window.makeKeyAndVisible();
  }
}
}
