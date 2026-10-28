#if VCL
namespace SharedUI.Shared
{
  using System.Classes;
  using Vcl.Forms;
  using Vcl.Controls;
  using Vcl.StdCtrls;

  public class MainWindow : TForm
  {
    __published TEdit ValueAEdit;
    __published TEdit ValueBEdit;
    __published TLabel ResultLabel;
    __published TButton CalculateButton;
    __published TLabel ValueALabel;
    __published TLabel ValueBLabel;
    __published TLabel ExplanationLabel;

    __published void ValueAChanged(TObject sender) { if (controller != null) controller.valueA = ValueAEdit.Text; }
    __published void ValueBChanged(TObject sender) { if (controller != null) controller.valueB = ValueBEdit.Text; }
    __published void CalculateClick(TObject sender) { controller.calculateResult(null); }

    public MainWindowController controller { get; set; }
  }
}
#endif
