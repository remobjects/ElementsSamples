namespace SharedUI.Shared;
{$IF ECHOES}

uses
  System.Windows,
  System.Windows.Controls;

type
  MainWindowController = public partial class
  public

    property window: Window; readonly;

    constructor;
    begin
      window := new MainWindow withController(self);
      setup();
    end;

    //
    // Compatibility Helpers. These could/should be in a shared base class, in a real app with many window/views
    //

    method showWindow(sender: id);
    begin
      window.Show();
    end;

    //
    // Add WPF-specific code here
    //

  end;

{$ENDIF}
end.