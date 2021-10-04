using Foundation;
using UIKit;

namespace MultipleViews
{
	public class Language
	{
		public string name { get; init; }
		public string displayName { get; init; }
		public UIImage image { get { return UIImage.imageNamed(name); } }
		public NSURL URL { get { return NSURL.URLWithString($"https://www.remobjects.com/elements/{name}"); } }

		public this (string! name, string? displayname = null)
		{
			this.name = name;
			this.displayName = coalesce(name, displayName);
		}
	}

	public static class Data
	{
		public var languages { get; } = new NSArray withObjects(
			new Language("Oxygene"),
			new Language("Hydrogene", "C#"),
			new Language("Silver", "Swift"),
			new Language("Iodine", "Java"),
			new Language("Gold", "Go"),
			new Language("Mercury"),
			null
		);
	}
}