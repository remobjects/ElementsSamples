namespace SharedUI.Shared;

uses Vcl.Forms;

type
  Program = public static class
  private

    // Retain the shared controller while the Delphi-owned form is alive.
    class field fDelegate: AppDelegate;

  public

    class method Main;
    begin
      Application.Initialize;
      Application.MainFormOnTaskBar := true;
      fDelegate := new AppDelegate;
      fDelegate.start;
      Application.Run;
    end;

  end;

end.
