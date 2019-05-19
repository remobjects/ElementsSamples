namespace AvalonApplication4;

// This example is made by Weyert de Boer of TeamRo as an Avalon example for 
// the RemObjects Oxygene (Floorshow) compiler. You are free the reuse the code and/or graphics.

interface

uses
  System.Windows,
  System.Windows.Controls,
  System.Windows.Data,
  System.Windows.Documents,
  System.Windows.Media,
  System.Windows.Navigation,
  System.Windows.Shapes,
  System.Windows.Forms;
  
type
  OxygeneWindow = public partial class(Window)
  private
    fTimer: System.Windows.Threading.DispatcherTimer;

    method ElapsedEventHandler(sender: Object; e:	EventArgs);
  public
    constructor;
		method updateClock();
  end;
  
implementation

constructor OxygeneWindow;
begin
  InitializeComponent();

  ( SecondsPointer.RenderTransform as RotateTransform ).Center := new Point( 72, 71 );
  ( MinutesPointer.RenderTransform as RotateTransform ).Center := new Point( 72, 72 );
  ( HoursPointer.RenderTransform as RotateTransform ).Center := new Point( 72, 72 );

	// The updateClock() method will update the pointers to the apporiate time,
	// we trigger the method at creation to let it be update accordinly at run time.
  updateClock();
  
  fTimer := new System.Windows.Threading.DispatcherTimer();
  //fTimer.Interval := 2000;
  fTimer.Tick += ElapsedEventHandler;
  fTimer.Start();
end;

method OxygeneWindow.updateClock();
begin
	var lTime := DateTime.Now;
	var lHour := lTime.Hour;
	
	// update the pointers of the clock to the apporiate time
  ( SecondsPointer.RenderTransform as RotateTransform ).Angle := lTime.Second * 6 - 90;
  ( MinutesPointer.RenderTransform as RotateTransform ).Angle := lTime.Minute * 6;
  ( HoursPointer.RenderTransform as RotateTransform ).Angle 	:= iif( lHour < 12, lHour, lHour - 12 ) * 30 - 180;
  Text := 'World Clock (' + DateTime.Now.ToString() + ')';
end;

method OxygeneWindow.ElapsedEventHandler(sender: Object; e: EventArgs); 
begin
  updateClock();
end;

end.
