using UIKit;

namespace MultipleViews
{
	[IBObject]
	public class DetailViewController: UIViewController
	{
		public this withLanguage(Language! language) : base withNibName("DetailView") bundle(null)
		{
			this.language = language;
		}

		private Language! language;

		public override void viewDidLoad()
		{
			base.viewDidLoad();
			imageView.image = language.image;
			title = language.displayName;
		}

		public override void didReceiveMemoryWarning()
		{
			base.didReceiveMemoryWarning();

			// Dispose of any resources that can be recreated.
		}

		[IBOutlet] public UIImageView imageView { get; set; }

		[IBAction]
		public void learnMore(id sender)
		{
			// using  a new UINavigationController forces the popuo
			var popover = new UINavigationController withRootViewController(new SafariServices.SFSafariViewController withURL(language.URL));
			presentViewController(popover) animated(true) completion(null);
		}
	}
}