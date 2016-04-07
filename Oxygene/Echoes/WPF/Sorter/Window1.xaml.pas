namespace Sorter;

interface

uses
  System.Threading,
  System.Windows,
  System.Windows.Controls,
  System.Windows.Data,
  System.Windows.Documents,
  System.Windows.Media,
  System.Windows.Media.Animation,
  System.Windows.Navigation,
  System.Windows.Shapes;

type
  Window1 = public partial class(System.Windows.Window)
  private
    method Switch(aOne, aTwo, aDelay: Integer);
    method Randomize(aSender: Object; aArgs: RoutedEventArgs);
    method Sort(aSender: Object; aArgs: RoutedEventArgs);
    method FillGrid;
    method Sort(aLeft, aRight: Integer; var aDelay: Integer);
    fRectangles: array of Rectangle;
    fPositions: array of Double;
    fRandom: Random := new Random();
    fLoColor: array of Color := [Colors.Blue, Colors.Green, Colors.Yellow, Colors.Pink, Colors.Coral, Colors.Cyan, Colors.Salmon];
    fHiColor: array of Color := [Colors.LightBlue, Colors.LightGreen, Colors.LightYellow, Colors.LightPink , Colors.LightCoral, Colors.LightCyan, Colors.LightSalmon];
  public
    constructor;
  end;
  
implementation

constructor Window1;
begin
  InitializeComponent();
  FillGrid;
end;
  
method Window1.Sort(aSender: Object; aArgs: RoutedEventArgs); 
var
  lDelay: Integer := 0;
begin
  Sort(0, fRectangles.Length -1, var lDelay);
end;

method Window1.Switch(aOne, aTwo, aDelay: Integer);
begin
  var lDuration := new Duration(new TimeSpan(0,0,0,0,200)); // 0.5 second
  var lStartDelay := new TimeSpan(0,0,0,aDelay / 4,(aDelay mod 4) * 250); // 0.5 second

  var lAnim1 := new DoubleAnimation();
  lAnim1.Duration := lDuration;
  lAnim1.BeginTime := lStartDelay;
  lAnim1.To := fPositions[aTwo];

  var lAnim2 := new DoubleAnimation();
  lAnim2.Duration := lDuration;
  lAnim2.BeginTime := lStartDelay;
  lAnim2.To := fPositions[aOne];
  
  fRectangles[aOne].BeginAnimation(Canvas.LeftProperty, lAnim1, HandoffBehavior.Compose);
  fRectangles[aTwo].BeginAnimation(Canvas.LeftProperty, lAnim2, HandoffBehavior.Compose);
  
  var r: Rectangle := fRectangles[aOne];
  fRectangles[aOne] := fRectangles[aTwo];
  fRectangles[aTwo] := r;
end;

method Window1.FillGrid;
begin
  MainCanvas.Children.Clear;
  fRectangles := new Rectangle[50];
  fPositions := new Double[50];
  var lWidth: Double := Width / 52.0;
  for i: Int32 := 0 to 49 do begin
    
    //MainGrid.ColumnDefinitions.Add(new ColumnDefinition());
    var r := new Rectangle();
    r.HorizontalAlignment := HorizontalAlignment.Stretch;
    r.VerticalAlignment := VerticalAlignment.Bottom;
    r.Fill := new LinearGradientBrush(fLoColor[i mod fLoColor.Length], fHiColor[i mod fHiColor.Length], 20);
    r.Height := fRandom.NextDouble()*(Height -80) +10;
    r.Width := lWidth;
    Canvas.SetLeft(r, i*r.Width);
    Canvas.SetTop(r, -r.Height);
    r.Opacity := 0.75;
    Grid.SetColumn(r, i);

    fRectangles[i] := r;
    fPositions[i] := i*r.Width;

    MainCanvas.Children.Add(r);
  end;
  
end;

method Window1.Randomize(aSender: Object; aArgs: RoutedEventArgs); 
begin
  FillGrid;
end;

method Window1.Sort(aLeft, aRight: Integer; var aDelay: Integer); 
begin
  while aLeft < aRight do begin
    var L: Integer := aLeft - 1;
    var R: Integer := aRight + 1;
    var Pivot: Double := fRectangles[(aLeft + aRight) div 2].Height;
      
    loop begin
      repeat 
        Dec(R);
      until fRectangles[R].Height <= Pivot;
      
      repeat
        Inc(L);
      until fRectangles[L].Height >= Pivot;
      
      if L < R then begin
        Switch(L, R, aDelay);
        aDelay := aDelay + 1;
      end else break;
    end;
    
    if aLeft < R then Sort(aLeft, R, var aDelay);
    aLeft := R + 1;
  end;
end;

end.