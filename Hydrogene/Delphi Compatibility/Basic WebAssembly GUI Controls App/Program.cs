using RemObjects.Elements.RTL.Delphi;
using RemObjects.Elements.RTL.Delphi.VCL;

namespace BasicWebAssemblyGUIControlsApp
{
	[Export]
	public class Program
	{
		private TProgressBar fProgress;

		public void HelloWorld()
		{
			CreateComponents();
		}

		public void CreateComponents()
		{
			Application = new TApplication(null);
			Application.Initialize();
			Application.Run();

			var el = Browser.GetElementById("helloWorld");
			var lForm = new TForm(null);
			lForm.Width = 800;
			// el it's a div element in html file, we are using as container for our form
			lForm.Show(el);

			var lFontsPanel = new TPanel(lForm);
			lFontsPanel.Height = 150;
			lFontsPanel.Width = 800;
			lFontsPanel.Parent = lForm;

			var lFontsCombo = new TComboBox(lForm);
			lFontsCombo.Left = 30;
			lFontsCombo.Top = 50;
			lFontsCombo.Width = 130;
			// Add combo inside TPanel
			lFontsCombo.Parent = lFontsPanel;

			lFontsCombo.Items.Add("Arial");
			lFontsCombo.Items.Add("Verdana");
			lFontsCombo.Items.Add("Helvetica");
			lFontsCombo.Items.Add("Times");

			var lFontSize = new TComboBox(lForm);
			lFontSize.Left = 200;
			lFontSize.Top = 50;
			lFontSize.Width = 80;
			lFontSize.Parent = lFontsPanel;
			for (var i = 8; i <= 72; i+= 4)
				lFontSize.Items.Add(i.ToString());

			var lLabel = new TLabel(lForm);
			lLabel.Left = 320;
			lLabel.Top = 50;
			lLabel.Caption = "Choose font name and size!";
			lLabel.Parent = lFontsPanel;

			// Assign combo events
			lFontsCombo.OnSelect = (a) => { lLabel.Font.Name = lFontsCombo.Text; };
			lFontSize.OnSelect = (a) => { lLabel.Font.Size = StrToInt(lFontSize.Text); };

			var lSecondPanel = new TPanel(lForm);
			lSecondPanel.Top = 220;
			lSecondPanel.Height = 150;
			lSecondPanel.Width = 800;
			lSecondPanel.Parent = lForm;

			var lCheckBox = new TCheckBox(lForm);
			lCheckBox.Top = 20;
			lCheckBox.Left = 30;
			lCheckBox.Caption = "CheckBox control";
			lCheckBox.Parent = lSecondPanel;

			var lRadioButton = new TRadioButton(lForm);
			lRadioButton.Top = 80;
			lRadioButton.Left = 30;
			lRadioButton.Caption = "RadioButton control";
			lRadioButton.Parent = lSecondPanel;

			var lChangeButton = new TButton(lForm);
			lChangeButton.Left = 220;
			lChangeButton.Top = 20;
			lChangeButton.Caption = "Change progress bar mode";
			lChangeButton.Parent = lSecondPanel;
			lChangeButton.OnClick = @ChangeButtonClick;

			var lIncButton = new TButton(lForm);
			lIncButton.Left = 220;
			lIncButton.Top = 80;
			lIncButton.Caption = "Increase progress bar value";
			lIncButton.Parent = lSecondPanel;
			lIncButton.OnClick = (a) => { fProgress.Position = fProgress.Position + 5; if (fProgress.Position >= fProgress.Max) fProgress.Position = 0; };

			fProgress = new TProgressBar(lForm);
			fProgress.Top = 55;
			fProgress.Left = 420;
			fProgress.Max = 100;
			fProgress.Parent = lSecondPanel;
		}

		public void ChangeButtonClick(TObject Sender)
		{
			if (fProgress.Style == TProgressBarStyle.Marquee)
				fProgress.Style = TProgressBarStyle.Normal;
			else
				fProgress.Style = TProgressBarStyle.Marquee;
		}
	}
}