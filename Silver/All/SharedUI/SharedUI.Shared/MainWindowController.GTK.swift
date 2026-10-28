#if GTK
import System.ComponentModel

extension MainWindowController {
  public var window: Gtk.ApplicationWindow!

  public init() {
    setup()
    let stream = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceStream("MainWindow.ui")
    if stream == nil {
      throw System.InvalidOperationException("Embedded GTK layout MainWindow.ui was not found.")
    }
    let reader = System.IO.StreamReader(stream)
    defer { reader.Close() }
    let builder = Gtk.Builder.NewFromString(reader.ReadToEnd(), -1)
    window = builder.GetObject("MainWindow") as! Gtk.ApplicationWindow
    window.SetApplication(Program.application)

    let inputA = builder.GetObject("ValueAEntry") as! Gtk.Entry
    inputA.SetText(valueA ?? "")
    inputA.OnChanged += { sender, e in self.valueA = inputA.GetText() }
    let inputB = builder.GetObject("ValueBEntry") as! Gtk.Entry
    inputB.SetText(valueB ?? "")
    inputB.OnChanged += { sender, e in self.valueB = inputB.GetText() }
    let button = builder.GetObject("CalculateButton") as! Gtk.Button
    button.OnClicked += { sender, e in self.calculateResult(sender) }
    let resultLabel = builder.GetObject("ResultLabel") as! Gtk.Label
    resultLabel.SetText(result ?? "")
    (self as! INotifyPropertyChanged).PropertyChanged += { sender, e in
      if e.PropertyName == "result" { resultLabel.SetText(self.result ?? "") }
    }
  }

  public func showWindow(_ sender: id!) { window.Present() }
}
#endif
