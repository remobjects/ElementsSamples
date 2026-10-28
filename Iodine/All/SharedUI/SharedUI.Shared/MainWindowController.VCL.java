package SharedUI.Shared;
#if VCL
import Vcl.Forms.*;

  public __partial class MainWindowController
  {
    private MainWindow window;

    public this()
    {
      setup();
      Application.CreateForm(MainWindow.class, __ref window);
      window.controller = this;
      window.ResultLabel.Caption = result;
      ((RemObjects.Elements.System.INotifyPropertyChanged)this).PropertyChanged += (sender, name) -> {
        if (name == "result") window.ResultLabel.Caption = result;
      };
    }

    public void showWindow(Object sender) { window.Show(); }
  }
#endif
