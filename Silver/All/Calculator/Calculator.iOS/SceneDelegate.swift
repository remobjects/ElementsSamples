import UIKit

@IBObject public class SceneDelegate: IUIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectToSession session: UISceneSession, options connectionOptions: UISceneConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let sceneWindow = UIWindow(windowScene: windowScene)
        sceneWindow.rootViewController = UINavigationController(rootViewController: RootViewController())
        window = sceneWindow
        sceneWindow.makeKeyAndVisible()
    }
}
