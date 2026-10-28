using UIKit;

namespace SqliteApp
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
    var storyboardName = "MainStoryboard~iPhone";
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
      storyboardName = "MainStoryboard~iPad";
    window.rootViewController = UIStoryboard.storyboardWithName(storyboardName) bundle(null).instantiateInitialViewController();
    if (window.rootViewController is UISplitViewController) {
      var split = (UISplitViewController)window.rootViewController;
      var navigation = (UINavigationController)split.viewControllers.lastObject();
      split.@delegate = (IUISplitViewControllerDelegate)navigation.topViewController;
    }
    window.makeKeyAndVisible();
  }
}
}
