import RemObjects.Elements.RTL.Delphi
import RemObjects.Elements.RTL.Delphi.VCL

var Form2: TForm2?

public class TForm2 : TForm {
	public __field Button1: TButton!
	public __field  Edit1: TEdit!
	public __field  Label1: TLabel!
	public __field  CheckBox1: TCheckBox!
	public __field  RadioButton1: TRadioButton!
	public __field  Button2: TButton!
	public __field  Button3: TButton!
	public __field  Edit2: TEdit!
	public __field  ListBox1: TListBox!

	public func Button1Click(Sender: TObject) {
		Label1.Caption = Edit1.Text
	}

	public func Button2Click(Sender: TObject) {
		ShowMessage("Hi there!")
	}

	public func Button3Click(Sender: TObject) {
		ListBox1.Items.Add(Edit2.Text)
	}
}