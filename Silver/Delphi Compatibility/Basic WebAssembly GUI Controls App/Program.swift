import RemObjects.Elements.RTL.Delphi;

@Export
public class Program {

	var fProgress: TProgressBar? = nil

	public func HelloWorld()
	{
		CreateComponents()
	}

	public func CreateComponents()
	{
		var el = WebAssembly.GetElementById("helloWorld")
		var lForm = TForm(nil)
		lForm.Width = 800
		// el it's a div element in html file, we are using as container for our form
		lForm.Show(el)

		var lFontsPanel = TPanel(lForm)
		lFontsPanel.Height = 150
		lFontsPanel.Width = 800
		lFontsPanel.Parent = lForm

		var lFontsCombo = TComboBox(lForm)
		lFontsCombo.Left = 30
		lFontsCombo.Top = 50
		lFontsCombo.Width = 130
		// Add combo inside TPanel
		lFontsCombo.Parent = lFontsPanel

		lFontsCombo.Items.Add("Arial")
		lFontsCombo.Items.Add("Verdana")
		lFontsCombo.Items.Add("Helvetica")
		lFontsCombo.Items.Add("Times")

		var lFontSize = TComboBox(lForm)
		lFontSize.Left = 200
		lFontSize.Top = 50
		lFontSize.Width = 80
		lFontSize.Parent = lFontsPanel
		for i in stride(from: 8, to: 72, by: 4)
		{
			lFontSize.Items.Add(i.ToString())
		}

		var lLabel = TLabel(lForm)
		lLabel.Left = 320
		lLabel.Top = 50
		lLabel.Caption = "Choose font name and size!"
		lLabel.Parent = lFontsPanel

		// Assign combo events
		lFontsCombo.OnSelect = { (a) in lLabel.Font.Name = lFontsCombo.Text }
		lFontSize.OnSelect = { (a) in lLabel.Font.Size = StrToInt(lFontSize.Text) }

		var lSecondPanel = TPanel(lForm)
		lSecondPanel.Top = 220
		lSecondPanel.Height = 150
		lSecondPanel.Width = 800
		lSecondPanel.Parent = lForm

		var lCheckBox = TCheckBox(lForm)
		lCheckBox.Top = 20
		lCheckBox.Left = 30
		lCheckBox.Caption = "CheckBox control"
		lCheckBox.Parent = lSecondPanel

		var lRadioButton = TRadioButton(lForm)
		lRadioButton.Top = 80
		lRadioButton.Left = 30
		lRadioButton.Caption = "RadioButton control"
		lRadioButton.Parent = lSecondPanel

		var lChangeButton = TButton(lForm)
		lChangeButton.Left = 220
		lChangeButton.Top = 20
		lChangeButton.Caption = "Change progress bar mode"
		lChangeButton.Parent = lSecondPanel
		lChangeButton.OnClick = { (a) in
			if (self.fProgress!.Style == TProgressBarStyle.Marquee)
			{
				self.fProgress!.Style = TProgressBarStyle.Normal;
			}
			else
			{
				self.fProgress!.Style = TProgressBarStyle.Marquee;
			}
		}

		var lIncButton = TButton(lForm)
		lIncButton.Left = 220
		lIncButton.Top = 80
		lIncButton.Caption = "Increase progress bar value"
		lIncButton.Parent = lSecondPanel
		lIncButton.OnClick = { (a) in self.fProgress!.Position = self.fProgress!.Position + 5; if (self.fProgress!.Position >= self.fProgress!.Max) { self.fProgress!.Position = 0 } }

		fProgress = TProgressBar(lForm)
		fProgress!.Top = 55
		fProgress!.Left = 420
		fProgress!.Max = 100
		fProgress!.Parent = lSecondPanel
	}

}