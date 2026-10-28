#if VCL
namespace SharedUI.Shared
{
  using Vcl.Forms;

  public partial class MainWindowController
  {
    private MainWindow window;

    public this()
    {
      setup();
      Application.CreateForm(typeof(MainWindow), ref window);
      window.controller = this;
      window.ResultLabel.Caption = result;
      ((RemObjects.Elements.System.INotifyPropertyChanged)this).PropertyChanged += (sender, name) => {
        if (name == "result") window.ResultLabel.Caption = result;
      };
    }

    public void showWindow(id sender) { window.Show(); }
  }
}
#endif
