namespace SharedUI.Shared;

type
  Program = public static class
  private

    class field fDelegate: AppDelegate;

  public

    class property application: Gtk.Application read private write;

    class method Main(aArgs: array of System.String): Integer;
    begin
      application := Gtk.Application.New("com.remobjects.samples.sharedui", Gio.ApplicationFlags.FlagsNone);
      application.OnActivate += (aSender, aEvent) -> begin
        if not assigned(fDelegate) then begin
          fDelegate := new AppDelegate;
          fDelegate.start;
        end
        else begin
          fDelegate.mainWindowController.showWindow(nil);
        end;
      end;
      result := application.RunWithSynchronizationContext(aArgs);
    end;

  end;

end.
