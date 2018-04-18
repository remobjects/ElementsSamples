using RemObjects.Elements.RTL.Delphi;

namespace BasicWebAssemblyGUIApp
{
	[Export]
	public class Program
	{
		public void HelloWorld()
		{
			// Create form
			var lForm = new TForm(null);
			lForm.Width = 800;
			// we can display the form in an existing div element. If Show parameter is nil, a new div is created
			lForm.Show(null);

			var lTopLabel = new TLabel(lForm);
			lTopLabel.Left = 1;
			lTopLabel.Parent = lForm;
			lTopLabel.Caption = "Write the item caption on the edit and press Add New button to add to ListBox:";

			var lButton = new TButton(lForm);
			lButton.Left = 50;
			lButton.Top = 50;
			lButton.Caption = "Add New";
			lButton.Parent = lForm;

			var lEdit = new TEdit(lForm);
			lEdit.Left = 150;
			lEdit.Top = 50;
			lEdit.Parent = lForm;

			var lListBox = new TListBox(lForm);
			lListBox.Left = 350;
			lListBox.Top = 50;
			lListBox.Parent = lForm;
			lListBox.Width = 250;
			lListBox.MultiSelect = true;

			lButton.OnClick = (s) => { lListBox.Items.Add(lEdit.Text); };

			var lChangeLabel = new TLabel(lForm);
			lChangeLabel.Top = 165;
			lChangeLabel.Parent = lForm;
			lChangeLabel.Caption = "Press button to change label font:";

			var lChangeButton = new TButton(lForm);
			lChangeButton.Left = 50;
			lChangeButton.Top = 200;
			lChangeButton.Caption = "Change font";
			lChangeButton.Parent = lForm;

			var lLabel = new TLabel(lForm);
			lLabel.Left = 150;
			lLabel.Top = 200;
			lLabel.Caption = "Sample text!";
			lLabel.Parent = lForm;

			lChangeButton.OnClick = (s) => { lLabel.Font.Name = "Verdana"; lLabel.Font.Size = 24; };

			var lMemo = new TMemo(lForm);
			lMemo.Left = 50;
			lMemo.Top = 300;
			lMemo.Width = 250;
			lMemo.Height = 150;
			lMemo.Parent = lForm;

			var lMemoButton = new TButton(lForm);
			lMemoButton.Left = 350;
			lMemoButton.Top = 325;
			lMemoButton.Caption = "Add text";
			lMemoButton.Parent = lForm;
			var lList = TStringList.Create();
			lList.Add("one line");
			lList.Add("another one");
			lMemoButton.OnClick = (s) => { lMemo.Lines.AddStrings(lList); };

			var lDisplayButton = new TButton(lForm);
			lDisplayButton.Top = lMemoButton.Top;
			lDisplayButton.Left = 450;
			lDisplayButton.Caption = "Show memo text";
			lDisplayButton.Parent = lForm;
			lDisplayButton.OnClick = (s) => { ShowMessage(lMemo.Lines.Text); };
		}
	}
}