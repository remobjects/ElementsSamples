namespace SharedUI.Shared;
{$IF COCOA}

type
  [IBObject]
  MainWindowController = public partial class(NSWindowController)
  public

    constructor;
    begin
      inherited constructor withWindowNibName('MainWindow');
      setup();
    end;

    method windowDidLoad; override;
    begin
      inherited windowDidLoad();

      //  Implement this method to handle any initialization after your window controller's
      //  window has been loaded from its nib file.
    end;

    //
    // Add Cocoa-specific code here
    //

  end;

{$ENDIF}
end.