from UIKit import IUIWindowSceneDelegate, UIColor, UILabel, NSTextAlignment, UIScene, UISceneConnectionOptions, UISceneSession, UIViewAutoresizing, UIViewController, UIWindow, UIWindowScene


@attribute(IBObject)
class SceneDelegate(IUIWindowSceneDelegate):
    _window: UIWindow

    @property
    def window(self) -> UIWindow:
        return self._window

    @window.setter
    def window(self, value: UIWindow) -> None:
        self._window = value

    @selector("scene:willConnectToSession:options:")
    def scene(self, scene: UIScene, willConnectToSession: UISceneSession, options: UISceneConnectionOptions) -> None:
        window_scene: UIWindowScene = cast[UIWindowScene](scene)
        controller: UIViewController = UIViewController()
        controller.view.backgroundColor = UIColor.systemBackgroundColor

        label: UILabel = UILabel(frame=controller.view.bounds)
        label.text = "Hello from Promethium!"
        label.textAlignment = NSTextAlignment.Center
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        controller.view.addSubview(label)

        window: UIWindow = UIWindow(windowScene=window_scene)
        window.rootViewController = controller
        self.window = window
        window.makeKeyAndVisible()
