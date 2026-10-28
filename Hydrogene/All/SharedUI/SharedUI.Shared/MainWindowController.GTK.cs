#if GTK
namespace SharedUI.Shared
{
  public partial class MainWindowController
  {
    public Gtk.ApplicationWindow window { get; private set; }

    public this()
    {
      setup();
      var stream = typeof(MainWindowController).Assembly.GetManifestResourceStream("MainWindow.ui");
      if (stream == null)
        throw new System.InvalidOperationException("Embedded GTK layout MainWindow.ui was not found.");
      Gtk.Builder builder;
      using (var reader = new System.IO.StreamReader(stream))
        builder = Gtk.Builder.NewFromString(reader.ReadToEnd(), -1);
      window = (Gtk.ApplicationWindow)builder.GetObject("MainWindow");
      window.SetApplication(Program.application);

      var inputA = (Gtk.Entry)builder.GetObject("ValueAEntry");
      inputA.SetText(valueA ?? "");
      inputA.OnChanged += (sender, e) => { valueA = inputA.GetText(); };
      var inputB = (Gtk.Entry)builder.GetObject("ValueBEntry");
      inputB.SetText(valueB ?? "");
      inputB.OnChanged += (sender, e) => { valueB = inputB.GetText(); };
      var button = (Gtk.Button)builder.GetObject("CalculateButton");
      button.OnClicked += (sender, e) => calculateResult(sender);
      var resultLabel = (Gtk.Label)builder.GetObject("ResultLabel");
      resultLabel.SetText(result ?? "");
      // Forward property changes to native GTK controls; the behavior stays shared.
      ((System.ComponentModel.INotifyPropertyChanged)this).PropertyChanged += (sender, e) => {
        if (e.PropertyName == "result") resultLabel.SetText(result ?? "");
      };
    }

    public void showWindow(id sender) { window.Present(); }
  }
}
#endif
