namespace CSharpiOSTableViewDemo
{
	using UIKit;

	[IBObject]
	class AppDelegate : IUIApplicationDelegate
	{
		public UIWindow window { get; set; }

		public BOOL application(UIApplication application) didFinishLaunchingWithOptions(NSDictionary launchOptions)
		{
			window = new UIWindow withFrame(UIScreen.mainScreen().bounds);
			window.rootViewController = new UINavigationController withRootViewController(new RootViewController());
			window.makeKeyAndVisible();
			return true;
		}

	}
}
