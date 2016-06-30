namespace SqliteApp
{
	using UIKit;

	public static class Program
	{
		public Int32 Main(Int32 argc, AnsiChar **argv)
		{
			using (__autoreleasepool)
			{
				return UIApplicationMain(argc, argv, null, NSStringFromClass(AppDelegate.@class()));
			}
		}
	}
}
