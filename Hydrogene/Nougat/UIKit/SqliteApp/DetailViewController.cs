namespace SqliteApp
{
	using UIKit;

	[IBObject]
	class DetailViewController: UIViewController, IUISplitViewControllerDelegate
	{
		private id _detailItem;
		public id detailItem 
		{ 
			get 
			{ 
				return _detailItem; 
			} 
			set 
			{
				if (_detailItem != value)
				{
					_detailItem = value;
					configureView();
				}

				if (masterPopoverController != null)
					masterPopoverController.dismissPopoverAnimated(true);
			}
		}

		[IBOutlet] public /*__weak*/ UILabel detailDescriptionLabel { get; set; }
		[IBOutlet] public UIPopoverController masterPopoverController { get; set; }

		public override void viewDidLoad()
		{
			base.viewDidLoad();

			// Do any additional setup after loading the view, typically from a nib.
			configureView();
		}
		
		public override void didReceiveMemoryWarning()
		{
			base.didReceiveMemoryWarning();
			// Dispose of any resources that can be recreated.
		}
		
		private void configureView()
		{
			// Update the user interface for the detail item.

			if (detailItem != null) 
			  ;//detailDescriptionLabel.text = detailItem.description; //bug: why isn't detailDescriptionLabel getting connected from storyboard?
		}
		
		#region Split view delegate
		public void splitViewController(UISplitViewController splitController) willHideViewController(UIViewController viewController) withBarButtonItem(UIBarButtonItem barButtonItem) forPopoverController(UIPopoverController popoverController)
		{
			if (barButtonItem != null) barButtonItem.title = "Master";
			if (navigationItem != null) navigationItem.setLeftBarButtonItem(barButtonItem) animated(true);
			masterPopoverController = popoverController;
		}
		
		public void splitViewController(UISplitViewController splitController) willShowViewController(UIViewController viewController) invalidatingBarButtonItem(UIBarButtonItem barButtonItem)
		{
			// Called when the view is shown again in the split view, invalidating the button and popover controller.
			if (navigationItem != null) navigationItem.setLeftBarButtonItem(null) animated(true);
			masterPopoverController = null;
		}
		#endregion
	}
}
