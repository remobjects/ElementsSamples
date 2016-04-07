namespace OxygeneLogo;

interface

uses
  System.Windows,
  System.Windows.Controls,
  System.Windows.Data,
  System.Windows.Documents,
  System.Windows.Media,
  System.Windows.Navigation,
  System.Windows.Shapes;

type
  OxygeneWindow = public partial class(Window)
  private

    // To use Loaded event put the Loaded="WindowLoaded" attribute in root element of .xaml file.
    // method WindowLoaded(sender: Object; e: EventArgs );

    // Sample event handler:  
    // method ButtonClick(sender: Object; e: RoutedEventArgs);

  public
    constructor;

  end;
  
implementation

constructor OxygeneWindow;
begin
  InitializeComponent();
end;
  
end.