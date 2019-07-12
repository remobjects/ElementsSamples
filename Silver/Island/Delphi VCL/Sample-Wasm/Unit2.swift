import RemObjects.Elements.RTL.Delphi
import RemObjects.Elements.RTL.Delphi.VCL

__field Form2: TForm2?

public class TForm2 : TForm {
	@Published public __field Button1: TButton!
	@Published public __field  Edit1: TEdit!
	@Published public __field  Label1: TLabel!
	@Published public __field  CheckBox1: TCheckBox!
	@Published public __field  RadioButton1: TRadioButton!
	@Published public __field  Button2: TButton!
	@Published public __field  Button3: TButton!
	@Published public __field  Edit2: TEdit!
	@Published public __field  ListBox1: TListBox!

	@Published public func Button1Click(Sender: TObject) {
		Label1.Caption = Edit1.Text
	}

	@Published public func Button2Click(Sender: TObject) {
		ShowMessage("Hi there!")
	}

	@Published public func Button3Click(Sender: TObject) {
		ListBox1.Items.Add(Edit2.Text)
	}
}