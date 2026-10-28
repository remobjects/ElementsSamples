#if VCL
import Vcl.Forms

extension MainWindowController {
  private var window: MainWindow!

  public init() {
    setup()
    var newWindow: MainWindow! = nil
    Application.CreateForm(MainWindow, &newWindow)
    window = newWindow
    window.controller = self
    window.ResultLabel.Caption = result
    (self as! RemObjects.Elements.System.INotifyPropertyChanged).PropertyChanged += { sender, name in
      if name == "result" { self.window.ResultLabel.Caption = self.result }
    }
  }

  public func showWindow(_ sender: id!) { window.Show() }
}
#endif
