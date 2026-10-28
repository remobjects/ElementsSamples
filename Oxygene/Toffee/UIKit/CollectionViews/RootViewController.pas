namespace CollectionViews;

uses
  UIKit;

type
  RootViewController = public class(UICollectionViewController)
  private

    const CELL_IDENTIFIER = 'RootViewController_Cell';
    const HEADER_IDENTIFIER = 'RootViewController_Header';

    var fData: NSArray;

    // quick access to the layout
    property collectionViewFlowLayout: UICollectionViewFlowLayout read collectionView.collectionViewLayout as UICollectionViewFlowLayout;

  protected

    {$REGION Collection view data source}
    method numberOfSectionsInCollectionView(collectionView: UICollectionView): NSInteger;
    begin
      if assigned(fData) then result := fData.count;
    end;

    method collectionView(collectionView: UICollectionView) numberOfItemsInSection(section: NSInteger): NSInteger;
    begin
      if assigned(fData) then result := fData[section].count;
    end;

    method collectionView(collectionView: UICollectionView) cellForItemAtIndexPath(indexPath: NSIndexPath): UICollectionViewCell;
    begin
      result := collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER) forIndexPath(indexPath);

      // remove any existing sub-views, in case we are reusing an existing cell
      result.contentView.subviews.makeObjectsPerformSelector(selector(removeFromSuperview));

      // and then add a label to the cell showing the current item number.
      var lLabel := new UILabel;
      lLabel.text := NSNumber.numberWithInt(indexPath.row).stringValue;
      lLabel.frame := result.contentView.bounds;
      lLabel.textColor := UIColor.whiteColor;
      lLabel.backgroundColor := UIColor.darkGrayColor;
      lLabel.font := UIFont.systemFontOfSize(30);
      lLabel.textAlignment := NSTextAlignment.Center;
      result.contentView.addSubview(lLabel);
    end;

    method collectionView(collectionView: UICollectionView) layout(aCollectionViewLayout: UICollectionViewLayout) sizeForItemAtIndexPath(indexPath: NSIndexPath): CGSize;
    begin
      // each cell will have a random size
      var lInfo := fData[indexPath.section][indexPath.row];
      result := CGSizeMake(lInfo.floatValue, lInfo.floatValue);
    end;

    method collectionView(collectionView: UICollectionView) viewForSupplementaryElementOfKind(kind:  NSString) atIndexPath(indexPath: NSIndexPath): UICollectionReusableView;
    begin
      result := collectionView.dequeueReusableSupplementaryViewOfKind(kind) withReuseIdentifier(HEADER_IDENTIFIER) forIndexPath(indexPath);

      // remove any existing sub-views, in case we are reusing an existing cell
      result.subviews:makeObjectsPerformSelector(selector(removeFromSuperview));

      // and then add a label to the cell showing the current section.
      var lLabel := new UILabel;
      lLabel.text := NSString.stringWithFormat('Section %ld', indexPath.section);
      lLabel.frame := result.bounds;
      lLabel.textColor := UIColor.blackColor;
      lLabel.backgroundColor := UIColor.lightGrayColor;
      lLabel.font := UIFont.boldSystemFontOfSize(20);
      lLabel.textAlignment := NSTextAlignment.Center;
      lLabel.contentMode := UIViewContentMode.UIViewContentModeRedraw;
      result.addSubview(lLabel);
    end;
    {$ENDREGION}

    {$REGION Collection view delegate}
    method collectionView(collectionView: UICollectionView) didSelectItemAtIndexPath(indexPath: NSIndexPath);
    begin
      // add code here to handle when a cell gets selected.
    end;
    {$ENDREGION}

  public

    constructor;
    begin
      inherited constructor withCollectionViewLayout(new UICollectionViewFlowLayout);

      collectionView.registerClass(UICollectionViewCell.class) forCellWithReuseIdentifier(CELL_IDENTIFIER);
      collectionView.registerClass(UICollectionReusableView.class) forSupplementaryViewOfKind(UICollectionElementKindSectionHeader) withReuseIdentifier(HEADER_IDENTIFIER);
      collectionViewFlowLayout.sectionInset := UIEdgeInsetsMake(10, 10, 10, 10);
      collectionViewFlowLayout.headerReferenceSize := CGSizeMake(40, 40); // only one dimension is used at a time
    end;

    method viewDidLoad; override;
    begin
      inherited viewDidLoad;

      title := 'Collection View Sample';

      // set up the (random) data to display in the collection view.

      // to avoid blocking the main thread and application startup, we do this in a block on a
      // background thread. Once done, we dispatch back to the main thread to trigger a reload.

      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), method begin

          var lArray := new NSMutableArray;
          for i: Int32 := 0 to arc4random_uniform(5)+5 do begin

            var lSection := new NSMutableArray;
            for j: Int32 := 0 to arc4random_uniform(50)+5 do begin

              var lSize := arc4random_uniform(100) + 100;
              lSection.addObject(lSize);

            end;
            lArray.addObject(lSection);

          end;

          dispatch_async(dispatch_get_main_queue(), method begin
            fData := lArray;
            collectionView.reloadData;
          end);

        end);
    end;

    method didReceiveMemoryWarning; override;
    begin
      inherited didReceiveMemoryWarning;

      // Dispose of any resources that can be recreated.
    end;

  end;

end.
