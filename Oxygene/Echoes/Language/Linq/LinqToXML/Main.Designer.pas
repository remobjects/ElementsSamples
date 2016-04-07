namespace LinqToXML;

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.Container := nil;
    button1: System.Windows.Forms.Button;
    tbXML: System.Windows.Forms.TextBox;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.button1 := new System.Windows.Forms.Button();
  self.tbXML := new System.Windows.Forms.TextBox();
  self.SuspendLayout();
  // 
  // button1
  // 
  self.button1.Location := new System.Drawing.Point(12, 12);
  self.button1.Name := 'button1';
  self.button1.Size := new System.Drawing.Size(75, 25);
  self.button1.TabIndex := 0;
  self.button1.Text := 'Execute';
  self.button1.UseVisualStyleBackColor := true;
  self.button1.Click += new System.EventHandler(@self.button1_Click);
  // 
  // tbXML
  // 
  self.tbXML.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom) 
        or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.tbXML.Font := new System.Drawing.Font('Courier New', 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (204 as System.Byte));
  self.tbXML.Location := new System.Drawing.Point(12, 43);
  self.tbXML.Multiline := true;
  self.tbXML.Name := 'tbXML';
  self.tbXML.ScrollBars := System.Windows.Forms.ScrollBars.Horizontal;
  self.tbXML.Size := new System.Drawing.Size(686, 116);
  self.tbXML.TabIndex := 1;
  self.tbXML.WordWrap := false;
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(710, 171);
  self.Controls.Add(self.tbXML);
  self.Controls.Add(self.button1);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MinimumSize := new System.Drawing.Size(600, 180);
  self.Name := 'MainForm';
  self.Text := 'Using Linq to generate a XML';
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.