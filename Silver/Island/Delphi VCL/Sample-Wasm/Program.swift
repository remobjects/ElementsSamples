import RemObjects.Elements.RTL.Delphi
import RemObjects.Elements.RTL.Delphi.VCL

public class Program {

    @Export
    public func Main() {
        Application = TApplication(nil)
        Application.Initialize()
        Application.CreateForm(dynamicType(TForm2), &Form2)
        Application.Run()
    }
}