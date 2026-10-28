package SharedUI.Shared;
#if VCL
import System.Classes.*;
import Vcl.Forms.*;
import Vcl.Controls.*;
import Vcl.StdCtrls.*;

  public class MainWindow extends TForm
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

    public MainWindowController controller { __get; __set; }
  }
#endif
