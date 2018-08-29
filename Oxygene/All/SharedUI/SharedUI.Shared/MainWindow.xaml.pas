namespace SharedUI.Shared;
{$IF ECHOES}

uses
  System.Windows,
  System.Windows.Controls;

type
  MainWindow = public partial class(System.Windows.Window)
  public

    constructor withController(aController: MainWindowController);
    begin
      DataContext := aController;
      InitializeComponent();
    end;

  private
    property controller: MainWindowController read DataContext as MainWindowController;

    //
    // Forward actions to the controller
    //

    method CalculateResult_Click(aSender: Object; e: RoutedEventArgs);
    begin
      controller.calculateResult(aSender);
    end;

  end;

{$ENDIF}
end.