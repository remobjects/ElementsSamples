package SharedUI.Shared;
#if GTK
  public __partial class MainWindowController
  {
    public Gtk.ApplicationWindow window { __get; private __set; }

    public this()
    {
      setup();
      var stream = MainWindowController.class.Assembly.GetManifestResourceStream("MainWindow.ui");
      if (stream == null)
        throw new System.InvalidOperationException("Embedded GTK layout MainWindow.ui was not found.");
      Gtk.Builder builder;
      var reader = new System.IO.StreamReader(stream);
      try {
        builder = Gtk.Builder.NewFromString(reader.ReadToEnd(), -1);
      } finally {
        reader.Close();
      }
      window = (Gtk.ApplicationWindow)builder.GetObject("MainWindow");
      window.SetApplication(Program.application);

      var inputA = (Gtk.Entry)builder.GetObject("ValueAEntry");
      inputA.SetText(valueA != null ? valueA : "");
      inputA.OnChanged += (sender, e) -> { valueA = inputA.GetText(); };
      var inputB = (Gtk.Entry)builder.GetObject("ValueBEntry");
      inputB.SetText(valueB != null ? valueB : "");
      inputB.OnChanged += (sender, e) -> { valueB = inputB.GetText(); };
      var button = (Gtk.Button)builder.GetObject("CalculateButton");
      button.OnClicked += (sender, e) -> calculateResult(sender);
      var resultLabel = (Gtk.Label)builder.GetObject("ResultLabel");
      resultLabel.SetText(result != null ? result : "");
      // Forward property changes to native GTK controls; the behavior stays shared.
      ((System.ComponentModel.INotifyPropertyChanged)this).PropertyChanged += (sender, e) -> {
        if (e.PropertyName == "result") resultLabel.SetText(result != null ? result : "");
      };
    }

    public void showWindow(Object sender) { window.Present(); }
  }
#endif
