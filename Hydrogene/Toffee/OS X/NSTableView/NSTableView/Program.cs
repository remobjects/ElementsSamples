namespace NSTableView
{
	using AppKit;

	public static class Program
	{
		public Int32 Main(Int32 argc, AnsiChar **argv)
		{
			using (__autoreleasepool)
			{
				return NSApplicationMain(argc, argv);
			}
		}
	}
}
