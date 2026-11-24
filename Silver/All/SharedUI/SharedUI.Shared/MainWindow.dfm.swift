#if VCL
import System.Classes
import Vcl.Forms
import Vcl.Controls
import Vcl.StdCtrls

public class MainWindow: TForm {
  __published __field ValueAEdit: TEdit!
  __published __field ValueBEdit: TEdit!
  __published __field ResultLabel: TLabel!
  __published __field CalculateButton: TButton!
  __published __field ValueALabel: TLabel!
  __published __field ValueBLabel: TLabel!
  __published __field ExplanationLabel: TLabel!

  __published func ValueAChanged(_ sender: TObject!) { controller?.valueA = ValueAEdit.Text }
  __published func ValueBChanged(_ sender: TObject!) { controller?.valueB = ValueBEdit.Text }
  __published func CalculateClick(_ sender: TObject!) { controller.calculateResult(nil) }

  public var controller: MainWindowController!
}
#endif
