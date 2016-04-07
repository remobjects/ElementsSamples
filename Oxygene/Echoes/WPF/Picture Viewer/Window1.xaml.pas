namespace PictureViewer;

interface

uses
  System.Windows,
  System.Windows.Controls,
  System.Windows.Data,
  System.Windows.Documents,
  System.Windows.Media,
  System.Windows.Media.Imaging,
  System.Windows.Media.Animation,
  System.Windows.Navigation,
  System.Windows.Input,
  System.Collections,
  System.Windows.Shapes;
  
  
type
  Window1 = public partial class(System.Windows.Window)
  private
    UndoStack: Stack;
    CropSelector: RubberbandAdorner;
    method WindowLoaded(sender: object; e: EventArgs);
    method ImageListSelection(sender: object; e: RoutedEventArgs);
    method Rotate(sender: object; e: RoutedEventArgs);
    method BlackAndWhite(sender: object; e: RoutedEventArgs);
    method Crop(sender: object; e: RoutedEventArgs);
    method Undo(sender: object; e: RoutedEventArgs);
    method OnMouseDown(sender: object; e: MouseButtonEventArgs);
    method ClearUndoStack();
  public
    Images: ImageList;
    constructor;
  end;

implementation

constructor Window1;
begin
  InitializeComponent();
  UndoStack := new Stack();
end;

method Window1.WindowLoaded(sender: object; e: EventArgs);
begin
  var layer: AdornerLayer := AdornerLayer.GetAdornerLayer(Self.CurrentImage);
  CropSelector := new RubberbandAdorner(CurrentImage);
  CropSelector.Window := Self;
  layer.Add(CropSelector);
  CropSelector.Rubberband.Visibility := Visibility.Hidden;
end;

method Window1.ImageListSelection(sender: object; e: RoutedEventArgs);
begin
  if not Assigned(CurrentImage) then exit;
  var path: String := ((sender as ListBox).SelectedItem.ToString());
  var img: BitmapSource := BitmapFrame.Create(new Uri(path));
  CurrentImage.Source := img;
  ClearUndoStack();
  if Assigned(CropSelector) then begin
    if Visibility.Visible = CropSelector.Rubberband.Visibility then 
      CropSelector.Rubberband.Visibility := Visibility.Hidden;
  end;
  CropButton.IsEnabled := false;
end;

method Window1.Rotate(sender: object; e: RoutedEventArgs);
begin
  if Assigned(CurrentImage.Source) then begin
    var img: BitmapSource := (CurrentImage.Source as BitmapSource);
    UndoStack.Push(img);
    var cache: CachedBitmap := new CachedBitmap(img, BitmapCreateOptions.None, BitmapCacheOption.OnLoad);
    CurrentImage.Source := new TransformedBitmap(cache, new RotateTransform(90.0));
    if not UndoButton.IsEnabled then UndoButton.IsEnabled := true;
    if Assigned(CropSelector) then begin
      if Visibility.Visible = CropSelector.Rubberband.Visibility then 
        CropSelector.Rubberband.Visibility := Visibility.Hidden;
    end;
    CropButton.IsEnabled := false;
  end;
end;

method Window1.BlackAndWhite(sender: object; e: RoutedEventArgs);
begin
  if Assigned(CurrentImage.Source) then begin
    var img: BitmapSource := (CurrentImage.Source as BitmapSource);
    UndoStack.Push(img);                
    CurrentImage.Source := new FormatConvertedBitmap(img, PixelFormats.Gray8, BitmapPalettes.Gray256, 1.0);
    if not UndoButton.IsEnabled then UndoButton.IsEnabled := true;
    if Assigned(CropSelector) then begin
      if Visibility.Visible = CropSelector.Rubberband.Visibility then 
        CropSelector.Rubberband.Visibility := Visibility.Hidden;
    end;
    CropButton.IsEnabled := false;
  end;
end;

method Window1.OnMouseDown(sender: object; e: MouseButtonEventArgs);
begin
  var anchor: Point := e.GetPosition(CurrentImage);
  CropSelector.CaptureMouse();
  CropSelector.StartSelection(anchor);
  CropButton.IsEnabled := true;
end;

method Window1.Crop(sender: object; e: RoutedEventArgs);
begin
  if  (not assigned(CurrentImage.Source))  then
    exit;
    
  var img: BitmapSource := (CurrentImage.Source as BitmapSource);
  UndoStack.Push(img);


  var  lSelectedX: Double := Math.Max(0, CropSelector.SelectRect.X);
  var  lSelectedY: Double := Math.Max(0, CropSelector.SelectRect.Y);
  var  lSelectedWidth: Double := Math.Min(CurrentImage.ActualWidth-lSelectedX, CropSelector.SelectRect.Width);
  var  lSelectedHeight: Double := Math.Min(CurrentImage.ActualHeight-lSelectedY, CropSelector.SelectRect.Height);

  var rect: Int32Rect := new Int32Rect(0,0,0,0);
  rect.X := Convert.ToInt32(lSelectedX * img.PixelWidth / CurrentImage.ActualWidth);
  rect.Y := Convert.ToInt32(lSelectedY * img.PixelHeight / CurrentImage.ActualHeight);
  rect.Width := Convert.ToInt32(lSelectedWidth * img.PixelWidth / CurrentImage.ActualWidth);
  rect.Height := Convert.ToInt32(lSelectedHeight * img.PixelHeight / CurrentImage.ActualHeight);

  try
    CurrentImage.Source := new CroppedBitmap(img, rect);
    if Visibility.Visible = CropSelector.Rubberband.Visibility then 
      CropSelector.Rubberband.Visibility := Visibility.Hidden;
    CropButton.IsEnabled := false;
    if  (not UndoButton.IsEnabled)  then
      UndoButton.IsEnabled := true;
  except
  end;
end;

method Window1.Undo(sender: object; e: RoutedEventArgs);
begin
  if UndoStack.Count > 0 then
    CurrentImage.Source := (UndoStack.Pop() as BitmapSource);
    if UndoStack.Count = 0 then UndoButton.IsEnabled := false;
    if Visibility.Visible = CropSelector.Rubberband.Visibility then 
      CropSelector.Rubberband.Visibility := Visibility.Hidden;
end;

method Window1.ClearUndoStack();
begin
  UndoStack.Clear();
  UndoButton.IsEnabled := false;
end;
  
end.