package CollectionViews;

import UIKit.*;

class RootViewController extends UICollectionViewController
{
	private final static String CELL_IDENTIFIER = "RootViewController_Cell";
	private final static String HEADER_IDENTIFIER = "RootViewController_Header";

	private NSArray data;

	private UICollectionViewFlowLayout collectionViewFlowLayout()
	{
		return (UICollectionViewFlowLayout)collectionView.collectionViewLayout;
	}

	@Override
	public id init()
	{
		this = super.initWithCollectionViewLayout(new UICollectionViewFlowLayout());
		if (this != null)
		{
			title = "Collection View Sample";
			collectionView.registerClass(UICollectionViewCell.class) forCellWithReuseIdentifier(CELL_IDENTIFIER);
			collectionView.registerClass(UICollectionReusableView.class) forSupplementaryViewOfKind(UICollectionElementKindSectionHeader) withReuseIdentifier(HEADER_IDENTIFIER);
			collectionViewFlowLayout().sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
			collectionViewFlowLayout().headerReferenceSize = CGSizeMake(40, 40); // only one dimension is used at a time
		}
		return this;
	}

	@Override
	public void viewDidLoad()
	{
		super.viewDidLoad();

		// set up the (random) data to display in the collection view.

		// to avoid blocking the main thread and application startup, we do this in a block on a
		// background thread. Once done, we dispatch mach to the main thread to trigger a reload.

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), () => {

			var lArray = new NSMutableArray();
			for (Int32 i; i <= arc4random_uniform(5)+5; i++)
			{

				var lSection = new NSMutableArray();
				for (Int32 j; j <= arc4random_uniform(50)+5; j++)
				{

				  var lSize = arc4random_uniform(100) + 100;
				  lSection.addObject(lSize);

				}
				lArray.addObject(lSection);

			}

			data = lArray;
			dispatch_async(dispatch_get_main_queue(), () => collectionView.reloadData());

		});
	}

	@Override
	public void didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning();
	   // Dispose of any resources that can be recreated.
	}

	#region Collection view data source}
	public NSInteger numberOfSectionsInCollectionView(UICollectionView collectionView)
	{
		if (data != null) return data.count;
		return 0;
	}

	public NSInteger collectionView(UICollectionView collectionView) numberOfItemsInSection(NSInteger section)
	{
		if (data != null) return data[section].count;
		return 0;
	}

	public UICollectionViewCell collectionView(UICollectionView collectionView) cellForItemAtIndexPath(NSIndexPath indexPath)
	{
		var result = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER) forIndexPath(indexPath);

		// remove any existing sub-views, in case we are reusing an existing cell
		result.subviews.makeObjectsPerformSelector(NSSelectorFromString("removeFromSuperview"));

		// and then add a label to the cell showing the current item number.
		var lLabel = new UILabel();
		lLabel.text = NSNumber.numberWithInt(indexPath.row).stringValue;
		lLabel.frame = result.bounds;
		lLabel.textColor = UIColor.whiteColor;
		lLabel.backgroundColor = UIColor.darkGrayColor;
		lLabel.font = UIFont.systemFontOfSize(30);
		lLabel.textAlignment = NSTextAlignment.NSTextAlignmentCenter;
		result.addSubview(lLabel);

		return result;
	}

	public CGSize collectionView(UICollectionView collectionView) layout(UICollectionViewLayout aCollectionViewLayout) sizeForItemAtIndexPath(NSIndexPath indexPath)
	{
		// each cell will have a random size
		var lInfo = data[indexPath.section][indexPath.row];
		return CGSizeMake(lInfo.floatValue, lInfo.floatValue);
	}

	public UICollectionReusableView collectionView(UICollectionView collectionView) viewForSupplementaryElementOfKind(String kind) atIndexPath(NSIndexPath indexPath)
	{
		var result = collectionView.dequeueReusableSupplementaryViewOfKind(kind) withReuseIdentifier(HEADER_IDENTIFIER) forIndexPath(indexPath);

		// remove any existing sub-views, in case we are reusing an existing cell
		if (result.subviews != null)
			result.subviews.makeObjectsPerformSelector(NSSelectorFromString("removeFromSuperview"));

		// and then add a label to the cell showing the current section.
		var lLabel = new UILabel();
		lLabel.text = NSString.stringWithFormat("Section %ld", indexPath.section);
		lLabel.frame = result.bounds;
		lLabel.textColor = UIColor.blackColor;
		lLabel.backgroundColor = UIColor.lightGrayColor;
		lLabel.font = UIFont.boldSystemFontOfSize(20);
		lLabel.textAlignment = NSTextAlignment.NSTextAlignmentCenter;
		lLabel.contentMode = UIViewContentMode.UIViewContentModeRedraw;
		result.addSubview(lLabel);

		return result;
	}
	#endregion

	#region Collection view delegate
	public void collectionView(UICollectionView collectionView) didSelectItemAtIndexPath(NSIndexPath indexPath)
	{
		// add code here to handle when a cell gets selected.
	}
	#endregion



}