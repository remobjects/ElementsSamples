namespace SharedUI.Shared;
{$IF VCL}

uses Vcl.Forms;

type
  MainWindowController = public partial class
  private

    field fWindow: MainWindow;

  public

    constructor;
    begin
      setup;
      Application.CreateForm(MainWindow, var fWindow);
      fWindow.controller := self;
      fWindow.ResultLabel.Caption := &result;
      (self as RemObjects.Elements.System.INotifyPropertyChanged).PropertyChanged += (aSender, aName) -> begin
        if aName = "result" then
          fWindow.ResultLabel.Caption := &result;
      end;
    end;

    method showWindow(aSender: id);
    begin
      fWindow.Show;
    end;

  end;

{$ENDIF}
end.
