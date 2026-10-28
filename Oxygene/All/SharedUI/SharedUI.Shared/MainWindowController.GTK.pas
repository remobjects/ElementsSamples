namespace SharedUI.Shared;
{$IF GTK}

uses System.ComponentModel;

type
  MainWindowController = public partial class
  public

    property window: Gtk.ApplicationWindow; readonly;

    constructor;
    begin
      setup;
      var lStream := typeOf(MainWindowController).Assembly.GetManifestResourceStream("MainWindow.ui");
      if not assigned(lStream) then
        raise new System.InvalidOperationException("Embedded GTK layout MainWindow.ui was not found.");
      var lBuilder: Gtk.Builder;
      using lReader := new System.IO.StreamReader(lStream) do
        lBuilder := Gtk.Builder.NewFromString(lReader.ReadToEnd, -1);
      window := Gtk.ApplicationWindow(lBuilder.GetObject("MainWindow"));
      window.SetApplication(Program.application);

      var lValueA := Gtk.Entry(lBuilder.GetObject("ValueAEntry"));
      lValueA.SetText(coalesce(valueA, ""));
      lValueA.OnChanged += (aSender, aEvent) -> begin
        valueA := lValueA.GetText;
      end;
      var lValueB := Gtk.Entry(lBuilder.GetObject("ValueBEntry"));
      lValueB.SetText(coalesce(valueB, ""));
      lValueB.OnChanged += (aSender, aEvent) -> begin
        valueB := lValueB.GetText;
      end;
      var lButton := Gtk.Button(lBuilder.GetObject("CalculateButton"));
      lButton.OnClicked += (aSender, aEvent) -> calculateResult(aSender);
      var lResult := Gtk.Label(lBuilder.GetObject("ResultLabel"));
      lResult.SetText(coalesce(&result, ""));

      // GTK signals adapt native controls to the same Notify properties used by Cocoa/WPF.
      (self as INotifyPropertyChanged).PropertyChanged += (aSender, aEvent) -> begin
        if aEvent.PropertyName = "result" then
          lResult.SetText(coalesce(&result, ""));
      end;
    end;

    method showWindow(aSender: id);
    begin
      window.Present;
    end;

  end;

{$ENDIF}
end.
