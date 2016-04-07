namespace WinFormsApplication;

interface

{$HIDE H8}

uses
  System.Drawing,
  System.Collections,
  System.Windows.Forms,
  System.ComponentModel;

type
  AboutForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    var components: System.ComponentModel.Container := nil;
    label2: System.Windows.Forms.Label;
    label1: System.Windows.Forms.Label;
    closeButton: System.Windows.Forms.Button;
    pictureBox: System.Windows.Forms.PictureBox;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method AboutForm.InitializeComponent;
begin
  self.pictureBox := new System.Windows.Forms.PictureBox();
  self.label1 := new System.Windows.Forms.Label();
  self.label2 := new System.Windows.Forms.Label();
  self.closeButton := new System.Windows.Forms.Button();
  (self.pictureBox as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // pictureBox
  // 
  self.pictureBox.Location := new System.Drawing.Point(79, 12);
  self.pictureBox.Name := 'pictureBox';
  self.pictureBox.Size := new System.Drawing.Size(135, 135);
  self.pictureBox.TabIndex := 0;
  self.pictureBox.TabStop := false;
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Font := new System.Drawing.Font('Tahoma', 16, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (0 as System.Byte));
  self.label1.Location := new System.Drawing.Point(32, 161);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(228, 27);
  self.label1.TabIndex := 1;
  self.label1.Text := 'TreeView Demo 2.0';
  self.label1.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
  // 
  // label2
  // 
  self.label2.Font := new System.Drawing.Font('Tahoma', 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (0 as System.Byte));
  self.label2.Location := new System.Drawing.Point(58, 188);
  self.label2.Name := 'label2';
  self.label2.Size := new System.Drawing.Size(177, 36);
  self.label2.TabIndex := 2;
  self.label2.Text := 'A WinForms version of the Gtk# treeview demo';
  self.label2.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
  // 
  // closeButton
  // 
  self.closeButton.DialogResult := System.Windows.Forms.DialogResult.OK;
  self.closeButton.Location := new System.Drawing.Point(109, 227);
  self.closeButton.Name := 'closeButton';
  self.closeButton.Size := new System.Drawing.Size(75, 23);
  self.closeButton.TabIndex := 3;
  self.closeButton.Text := '&Close';
  self.closeButton.UseVisualStyleBackColor := true;
  // 
  // AboutForm
  // 
  self.ClientSize := new System.Drawing.Size(292, 272);
  self.Controls.Add(self.closeButton);
  self.Controls.Add(self.label2);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.pictureBox);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.MaximizeBox := false;
  self.Name := 'AboutForm';
  self.SizeGripStyle := System.Windows.Forms.SizeGripStyle.Hide;
  self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
  self.Text := 'About TreeView Demo';
  self.Load += new System.EventHandler(@self.AboutForm_Load);
  (self.pictureBox as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.