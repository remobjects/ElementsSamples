namespace SharedUI.Shared;

type
  AppDelegate = public partial class
  public

    property mainWindowController: MainWindowController read private write;

    method start;
    begin
      //
      //  this is the cross-platform entry point for the app
      //

      mainWindowController := new MainWindowController();
      mainWindowController.showWindow(nil);
    end;

    //
    // Add Shared code here
    //

  end;

end.