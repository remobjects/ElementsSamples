namespace WinFormsApplication;

interface

{$HIDE H8}

uses
  System.Drawing,
  System.Collections,
  System.Windows.Forms,
  System.ComponentModel;

type
  UpdateDialog = partial class
  {$REGION Windows Form Designer generated fields}
  private
    var 
    components: System.ComponentModel.IContainer;
    dialogLabel: System.Windows.Forms.Label;
    pictureBox: System.Windows.Forms.PictureBox;
    quitButton: System.Windows.Forms.Button;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method UpdateDialog.InitializeComponent;
begin
  self.dialogLabel := new System.Windows.Forms.Label();
  self.pictureBox := new System.Windows.Forms.PictureBox();
  self.quitButton := new System.Windows.Forms.Button();
  (self.pictureBox as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // dialogLabel
  // 
  self.dialogLabel.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.dialogLabel.Location := new System.Drawing.Point(66, 13);
  self.dialogLabel.Name := 'dialogLabel';
  self.dialogLabel.Size := new System.Drawing.Size(570, 47);
  self.dialogLabel.TabIndex := 0;
  // 
  // pictureBox
  // 
  self.pictureBox.Location := new System.Drawing.Point(12, 12);
  self.pictureBox.Name := 'pictureBox';
  self.pictureBox.Size := new System.Drawing.Size(48, 48);
  self.pictureBox.TabIndex := 1;
  self.pictureBox.TabStop := false;
  // 
  // quitButton
  // 
  self.quitButton.Anchor := ((System.Windows.Forms.AnchorStyles.Bottom or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.quitButton.Location := new System.Drawing.Point(561, 73);
  self.quitButton.Name := 'quitButton';
  self.quitButton.Size := new System.Drawing.Size(75, 23);
  self.quitButton.TabIndex := 0;
  self.quitButton.Text := '&Quit';
  self.quitButton.UseVisualStyleBackColor := true;
  self.quitButton.Click += new System.EventHandler(@self.quitButton_Click);
  // 
  // UpdateDialog
  // 
  self.ClientSize := new System.Drawing.Size(648, 108);
  self.Controls.Add(self.quitButton);
  self.Controls.Add(self.pictureBox);
  self.Controls.Add(self.dialogLabel);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.MaximizeBox := false;
  self.Name := 'UpdateDialog';
  self.SizeGripStyle := System.Windows.Forms.SizeGripStyle.Hide;
  self.Text := 'Loading data from assemblies...';
  self.Load += new System.EventHandler(@self.UpdateDialog_Load);
  (self.pictureBox as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
end;
{$ENDREGION}

end.