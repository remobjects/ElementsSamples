namespace SharedUI.Shared;
{$IF COCOA}

type
  [NSApplicationMain, IBObject]
  AppDelegate = public partial class(INSApplicationDelegate)
  public

    method applicationDidFinishLaunching(notification: NSNotification);
     begin
      start();
    end;

    //
    // Add Cocoa-specific code here
    //

  end;

{$ENDIF}
end.