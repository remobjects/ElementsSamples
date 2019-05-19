namespace InterfacesSample;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  InterfacesSample.SampleClasses;

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    textBox1: System.Windows.Forms.TextBox;
    button2: System.Windows.Forms.Button;
    button1: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method button1_Click(sender: System.Object; e: System.EventArgs);
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    fButtonWithInfo: SampleButton;
    fTextBoxWithInfo: SampleTextBox;

    method Dispose(aDisposing: Boolean); override;

    method GetVersionInfoString(aVersionInfo: IVersionInfo): String;
  public
    constructor;
    class method Main;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  InitializeComponent();
end;

method MainForm.Dispose(aDisposing: boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.button1 := new System.Windows.Forms.Button();
  self.button2 := new System.Windows.Forms.Button();
  self.textBox1 := new System.Windows.Forms.TextBox();
  self.SuspendLayout();
  //
  // button1
  //
  self.button1.Location := new System.Drawing.Point(8, 12);
  self.button1.Name := 'button1';
  self.button1.Size := new System.Drawing.Size(136, 23);
  self.button1.TabIndex := 0;
  self.button1.Text := 'Display Version Info';
  self.button1.Click += new System.EventHandler(@self.button1_Click);
  //
  // button2
  //
  self.button2.Location := new System.Drawing.Point(8, 41);
  self.button2.Name := 'button2';
  self.button2.Size := new System.Drawing.Size(136, 23);
  self.button2.TabIndex := 1;
  self.button2.Text := 'Regular Button';
  //
  // textBox1
  //
  self.textBox1.Location := new System.Drawing.Point(150, 43);
  self.textBox1.Name := 'textBox1';
  self.textBox1.Size := new System.Drawing.Size(130, 20);
  self.textBox1.TabIndex := 2;
  self.textBox1.Text := 'Regular TextBox';
  //
  // MainForm
  //
  self.AutoScaleBaseSize := new System.Drawing.Size(5, 13);
  self.ClientSize := new System.Drawing.Size(292, 79);
  self.Controls.Add(self.textBox1);
  self.Controls.Add(self.button2);
  self.Controls.Add(self.button1);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'Interfaces Sample';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

{$REGION Application Entry Point}
[STAThread]
class method MainForm.Main;
begin
  Application.EnableVisualStyles();
  try
    with lForm := new MainForm() do
      Application.Run(lForm);
  except
    on E: Exception do begin
      MessageBox.Show(E.Message);
    end;
  end;
end;
{$ENDREGION}

method MainForm.MainForm_Load(sender: System.Object; e: System.EventArgs);
begin
  { Creates the button and textbox that support IVersionInfo }
  SuspendLayout();
  try
    fButtonWithInfo := new SampleButton();
    fButtonWithInfo.Location := new System.Drawing.Point(70, 80);
    fButtonWithInfo.Name := 'ButtonWithInfo';
    fButtonWithInfo.Text := 'Button with VersionInfo';
    fButtonWithInfo.Width := 150;
    Controls.Add(fButtonWithInfo);

    fTextBoxWithInfo := new SampleTextBox();
    fTextBoxWithInfo.Location := new System.Drawing.Point(70, 120);
    fTextBoxWithInfo.Name := 'TextBoxWithInfo';
    fTextBoxWithInfo.Text := 'TextBox with VersionInfo';
    fTextBoxWithInfo.Width := 150;
    Controls.Add(fTextBoxWithInfo);
 finally
    ResumeLayout();
  end;
end;

method MainForm.button1_Click(sender: System.Object; e: System.EventArgs);
const
  CRLF = #13#10;
var
  lInfo: String := 'The following controls support IVersionInfo:'+CRLF;
begin
  { Iterates through all the controls in the form that support IVersionInfo
    and calls GetVersionInfoString on each of them.

    Notice how the regular Button and TextBox are not included in this for each loop,
    as they don't implement IVersionInfo. }
  for each matching lVersionInfo: IVersionInfo in Controls do
    lInfo := lInfo+GetVersionInfoString(lVersionInfo)+CRLF;

  MessageBox.Show(lInfo);
end;

method MainForm.GetVersionInfoString(aVersionInfo: IVersionInfo): string;
begin
  { This method is a key example why the use of interfaces is essential in OO programming.

    Without the use of interfaces, we could not have treated Button and TextBox descendants
    as a unique type (IVersionInfo in this case) and we would have needed to write code such as:

    method GetVersionInfoString(aControl : Control) : string;
    begin
      if (aControl is SampleControl)
        then <use property (aControl as SampleControl).VersionInfo>
      else if (aControl is SampleTextBox)
        then <use property (aControl as SampleTextBox).VersionInfo>
      etc.
    end;

    Interfaces break the dependencies with ancestors and allow us to treat objects as if they
    were of the same type, regardless of their position in the class hierarchy.
  }
  result := String.Format('{0}: {1}, Version {2}.{3}',
              [aVersionInfo.Name,
               aVersionInfo.Description,
               aVersionInfo.MajVersion.ToString,
               aVersionInfo.MinVersion.ToString]);
end;

end.