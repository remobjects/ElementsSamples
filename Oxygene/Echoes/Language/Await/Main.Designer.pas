namespace AwaitSample;

interface

{$HIDE H7}

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.Container := nil;
      textBoxPath: System.Windows.Forms.TextBox;
      label2: System.Windows.Forms.Label;
      labelFilesCount: System.Windows.Forms.Label;
      label1: System.Windows.Forms.Label;
      buttonCount: System.Windows.Forms.Button;
      buttonChoosePath: System.Windows.Forms.Button;
      progressBarCounting: System.Windows.Forms.ProgressBar;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.textBoxPath := new System.Windows.Forms.TextBox();
  self.progressBarCounting := new System.Windows.Forms.ProgressBar();
  self.buttonChoosePath := new System.Windows.Forms.Button();
  self.buttonCount := new System.Windows.Forms.Button();
  self.label1 := new System.Windows.Forms.Label();
  self.labelFilesCount := new System.Windows.Forms.Label();
  self.label2 := new System.Windows.Forms.Label();
  self.SuspendLayout();
  // 
  // textBoxPath
  // 
  self.textBoxPath.Location := new System.Drawing.Point(12, 34);
  self.textBoxPath.Name := 'textBoxPath';
  self.textBoxPath.Size := new System.Drawing.Size(250, 20);
  self.textBoxPath.TabIndex := 0;
  // 
  // progressBarCounting
  // 
  self.progressBarCounting.Location := new System.Drawing.Point(12, 60);
  self.progressBarCounting.MarqueeAnimationSpeed := 30;
  self.progressBarCounting.Name := 'progressBarCounting';
  self.progressBarCounting.Size := new System.Drawing.Size(359, 23);
  self.progressBarCounting.Style := System.Windows.Forms.ProgressBarStyle.Continuous;
  self.progressBarCounting.TabIndex := 1;
  // 
  // buttonChoosePath
  // 
  self.buttonChoosePath.Font := new System.Drawing.Font('Microsoft Sans Serif', 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (204 as System.Byte));
  self.buttonChoosePath.Location := new System.Drawing.Point(266, 34);
  self.buttonChoosePath.Name := 'buttonChoosePath';
  self.buttonChoosePath.Size := new System.Drawing.Size(24, 20);
  self.buttonChoosePath.TabIndex := 2;
  self.buttonChoosePath.Text := '...';
  self.buttonChoosePath.UseVisualStyleBackColor := true;
  self.buttonChoosePath.Click += new System.EventHandler(@self.buttonChoosePath_Click);
  // 
  // buttonCount
  // 
  self.buttonCount.Location := new System.Drawing.Point(296, 33);
  self.buttonCount.Name := 'buttonCount';
  self.buttonCount.Size := new System.Drawing.Size(75, 23);
  self.buttonCount.TabIndex := 3;
  self.buttonCount.Text := 'Count!';
  self.buttonCount.UseVisualStyleBackColor := true;
  self.buttonCount.Click += new System.EventHandler(@self.buttonCount_Click);
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Location := new System.Drawing.Point(9, 92);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(61, 13);
  self.label1.TabIndex := 4;
  self.label1.Text := 'Files count:';
  // 
  // labelFilesCount
  // 
  self.labelFilesCount.AutoSize := true;
  self.labelFilesCount.ForeColor := System.Drawing.Color.Red;
  self.labelFilesCount.Location := new System.Drawing.Point(70, 92);
  self.labelFilesCount.Name := 'labelFilesCount';
  self.labelFilesCount.Size := new System.Drawing.Size(0, 13);
  self.labelFilesCount.TabIndex := 5;
  // 
  // label2
  // 
  self.label2.AutoSize := true;
  self.label2.Location := new System.Drawing.Point(12, 9);
  self.label2.Name := 'label2';
  self.label2.Size := new System.Drawing.Size(77, 13);
  self.label2.TabIndex := 6;
  self.label2.Text := 'Specify Folder:';
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(385, 114);
  self.Controls.Add(self.label2);
  self.Controls.Add(self.labelFilesCount);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.buttonCount);
  self.Controls.Add(self.buttonChoosePath);
  self.Controls.Add(self.progressBarCounting);
  self.Controls.Add(self.textBoxPath);
  self.Font := new System.Drawing.Font('Microsoft Sans Serif', 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (204 as System.Byte));
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.Text := 'Files Counter';
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.
