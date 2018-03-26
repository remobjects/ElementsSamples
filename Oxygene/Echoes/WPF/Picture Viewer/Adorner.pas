namespace PictureViewer;

interface

uses
  System,
  System.IO,
  System.Windows,
  System.Windows.Input,
  System.Windows.Media,
  System.Windows.Documents;

type
  RubberbandAdorner = public class(Adorner)
  const
    RUBBERBAND_MIN_SIZE: Integer = 3;
    RUBBERBAND_THICKNESS: Integer = 1;

  private
    fWindow: Window1;
    fGeometry: RectangleGeometry;
    fRubberband: System.Windows.Shapes.Path;
    fAdornedElement: UIElement;
    fSelectRect: Rect;
    fVisualChildrenCount: Integer := 1;
    fAnchorPoint: Point;
    method DrawSelection(sender: Object; e: MouseEventArgs);
    method EndSelection(sender: Object; e: MouseButtonEventArgs);
  protected
    method ArrangeOverride(aSize: Size): Size; override;
    method GetVisualChild(&index: Integer): Visual; override;
    property VisualChildrenCount: Integer read fVisualChildrenCount; override;
  public
    constructor (anAdornedElement: UIElement);
    method StartSelection(anAnchorPoint: Point);
    property SelectRect: Rect read fSelectRect;
    property Rubberband: System.Windows.Shapes.Path read fRubberband;
    property Window: Window1 write fWindow;
  end;


implementation

constructor RubberbandAdorner(anAdornedElement: UIElement);
begin
  inherited constructor(anAdornedElement);

  fAdornedElement := anAdornedElement;
  fSelectRect := new Rect(new Size(0.0, 0.0));
  fGeometry := new RectangleGeometry();
  fRubberband := new System.Windows.Shapes.Path();
  fRubberband.Data := fGeometry;
  fRubberband.StrokeThickness := RUBBERBAND_THICKNESS;
  fRubberband.Stroke := Brushes.Red;
  fRubberband.Opacity := .6;
  fRubberband.Visibility := Visibility.Hidden;
  AddVisualChild(fRubberband);

  MouseMove += new MouseEventHandler(DrawSelection);
  MouseUp += new MouseButtonEventHandler(EndSelection);
end;

method RubberbandAdorner.ArrangeOverride(aSize: Size): Size;
begin
  var lFinalSize: Size := inherited ArrangeOverride(aSize);
  ((GetVisualChild(0) as UIElement).Arrange(new Rect(new Point(0.0, 0.0), lFinalSize)));
  exit(lFinalSize);
end;

method RubberbandAdorner.StartSelection(anAnchorPoint: Point);
begin
  fAnchorPoint := anAnchorPoint;
  fSelectRect.Size := new Size(10, 10);
  fSelectRect.Location := fAnchorPoint;
  fGeometry.Rect := fSelectRect;
  if Visibility.Visible <> fRubberband.Visibility then
    fRubberband.Visibility := Visibility.Visible;
end;

method RubberbandAdorner.DrawSelection(sender: object; e: MouseEventArgs);
begin
  if e.LeftButton = MouseButtonState.Pressed then begin
     var mousePosition: Point := e.GetPosition(fAdornedElement);
     if mousePosition.X < fAnchorPoint.X then
        fSelectRect.X := mousePosition.X
     else
        fSelectRect.X := fAnchorPoint.X;
     if mousePosition.Y < fAnchorPoint.Y then
        fSelectRect.Y := mousePosition.Y
     else
        fSelectRect.Y := fAnchorPoint.Y;

     fSelectRect.Width := Math.Abs(mousePosition.X - fAnchorPoint.X);
     fSelectRect.Height := Math.Abs(mousePosition.Y - fAnchorPoint.Y);
     fGeometry.Rect := fSelectRect;
     AdornerLayer.GetAdornerLayer(fAdornedElement).InvalidateArrange();
  end;
end;

method RubberbandAdorner.EndSelection(sender: object; e: MouseButtonEventArgs);
begin
  if (RUBBERBAND_MIN_SIZE >= fSelectRect.Width) OR
     (RUBBERBAND_MIN_SIZE >= fSelectRect.Height) then
      fRubberband.Visibility := Visibility.Hidden
  else
     fWindow.CropButton.IsEnabled := true;
  ReleaseMouseCapture();
end;

method RubberbandAdorner.GetVisualChild(&index: integer): Visual;
begin
  exit(fRubberband);
end;

end.