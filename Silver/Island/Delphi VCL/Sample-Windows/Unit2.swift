import System.Classes
import Vcl.Forms
import Vcl.Controls
import Vcl.StdCtrls
import Vcl.Dialogs

var Form2: TForm2?

public class TForm2 : TForm {
	__published __field Button1: TButton!
	__published __field  Edit1: TEdit!
	__published __field  Label1: TLabel!
	__published __field  CheckBox1: TCheckBox!
	__published __field  RadioButton1: TRadioButton!
	__published __field  Button2: TButton!
	__published __field  Button3: TButton!
	__published __field  Edit2: TEdit!
	__published __field  ListBox1: TListBox!

	__published func Button1Click(Sender: TObject) {
		Label1.Caption = Edit1.Text
	}

	__published func Button2Click(Sender: TObject) {
		ShowMessage("Hi there!")
	}

	__published func Button3Click(Sender: TObject) {
		ListBox1.Items.Add(Edit2.Text)
	}
}