namespace CallingWin32DLL;

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    label1: System.Windows.Forms.Label;
    tbFrequency: System.Windows.Forms.TrackBar;
    btnSoundRenamed: System.Windows.Forms.Button;
    btnSoundStandard: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.btnSoundStandard := new System.Windows.Forms.Button();
  self.btnSoundRenamed := new System.Windows.Forms.Button();
  self.tbFrequency := new System.Windows.Forms.TrackBar();
  self.label1 := new System.Windows.Forms.Label();
  (self.tbFrequency as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // btnSoundStandard
  // 
  self.btnSoundStandard.Location := new System.Drawing.Point(12, 105);
  self.btnSoundStandard.Name := 'btnSoundStandard';
  self.btnSoundStandard.Size := new System.Drawing.Size(82, 42);
  self.btnSoundStandard.TabIndex := 0;
  self.btnSoundStandard.Text := 'Make Sound';
  self.btnSoundStandard.UseVisualStyleBackColor := true;
  self.btnSoundStandard.Click += new System.EventHandler(@self.btnSoundStandard_Click);
  // 
  // btnSoundRenamed
  // 
  self.btnSoundRenamed.Location := new System.Drawing.Point(129, 105);
  self.btnSoundRenamed.Name := 'btnSoundRenamed';
  self.btnSoundRenamed.Size := new System.Drawing.Size(82, 46);
  self.btnSoundRenamed.TabIndex := 1;
  self.btnSoundRenamed.Text := 'Also Make Sound';
  self.btnSoundRenamed.UseVisualStyleBackColor := true;
  self.btnSoundRenamed.Click += new System.EventHandler(@self.btnSoundRenamed_Click);
  // 
  // tbFrequency
  // 
  self.tbFrequency.Location := new System.Drawing.Point(12, 28);
  self.tbFrequency.Maximum := 5000;
  self.tbFrequency.Minimum := 200;
  self.tbFrequency.Name := 'tbFrequency';
  self.tbFrequency.Size := new System.Drawing.Size(199, 45);
  self.tbFrequency.TabIndex := 2;
  self.tbFrequency.Value := 200;
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Location := new System.Drawing.Point(81, 12);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(57, 13);
  self.label1.TabIndex := 3;
  self.label1.Text := 'Frequency';
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(224, 181);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.tbFrequency);
  self.Controls.Add(self.btnSoundRenamed);
  self.Controls.Add(self.btnSoundStandard);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'PInvoke Sample';
  (self.tbFrequency as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.