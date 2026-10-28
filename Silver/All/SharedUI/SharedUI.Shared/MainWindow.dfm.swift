#if VCL
import System.Classes
import Vcl.Forms
import Vcl.Controls
import Vcl.StdCtrls

public class MainWindow: TForm {
  __published var ValueAEdit: TEdit!
  __published var ValueBEdit: TEdit!
  __published var ResultLabel: TLabel!
  __published var CalculateButton: TButton!
  __published var ValueALabel: TLabel!
  __published var ValueBLabel: TLabel!
  __published var ExplanationLabel: TLabel!

  __published func ValueAChanged(_ sender: TObject!) { controller?.valueA = ValueAEdit.Text }
  __published func ValueBChanged(_ sender: TObject!) { controller?.valueB = ValueBEdit.Text }
  __published func CalculateClick(_ sender: TObject!) { controller.calculateResult(nil) }

  public var controller: MainWindowController!
}
#endif
