namespace Sequences_and_Queries;

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.Container := nil;
    label1: System.Windows.Forms.Label;
    buttonExecute: System.Windows.Forms.Button;
    dataGridViewData: System.Windows.Forms.DataGridView;
    buttonRefresh: System.Windows.Forms.Button;
    buttonNext: System.Windows.Forms.Button;
    buttonPrev: System.Windows.Forms.Button;
    listBoxQueries: System.Windows.Forms.ListBox;
    textBoxDescription: System.Windows.Forms.TextBox;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.buttonExecute := new System.Windows.Forms.Button();
  self.textBoxDescription := new System.Windows.Forms.TextBox();
  self.label1 := new System.Windows.Forms.Label();
  self.dataGridViewData := new System.Windows.Forms.DataGridView();
  self.buttonRefresh := new System.Windows.Forms.Button();
  self.buttonPrev := new System.Windows.Forms.Button();
  self.buttonNext := new System.Windows.Forms.Button();
  self.listBoxQueries := new System.Windows.Forms.ListBox();
  (self.dataGridViewData as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // buttonExecute
  // 
  self.buttonExecute.Location := new System.Drawing.Point(12, 189);
  self.buttonExecute.Name := 'buttonExecute';
  self.buttonExecute.Size := new System.Drawing.Size(75, 23);
  self.buttonExecute.TabIndex := 2;
  self.buttonExecute.Text := 'Execute';
  self.buttonExecute.UseVisualStyleBackColor := true;
  self.buttonExecute.Click += new System.EventHandler(@self.buttonExecute_Click);
  // 
  // textBoxDescription
  // 
  self.textBoxDescription.BorderStyle := System.Windows.Forms.BorderStyle.FixedSingle;
  self.textBoxDescription.Location := new System.Drawing.Point(198, 23);
  self.textBoxDescription.Multiline := true;
  self.textBoxDescription.Name := 'textBoxDescription';
  self.textBoxDescription.Size := new System.Drawing.Size(357, 159);
  self.textBoxDescription.TabIndex := 3;
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Location := new System.Drawing.Point(12, 9);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(71, 13);
  self.label1.TabIndex := 4;
  self.label1.Text := 'Select Query:';
  // 
  // dataGridViewData
  // 
  self.dataGridViewData.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom) 
        or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.dataGridViewData.ColumnHeadersHeightSizeMode := System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
  self.dataGridViewData.Location := new System.Drawing.Point(12, 217);
  self.dataGridViewData.Name := 'dataGridViewData';
  self.dataGridViewData.Size := new System.Drawing.Size(543, 183);
  self.dataGridViewData.TabIndex := 5;
  // 
  // buttonRefresh
  // 
  self.buttonRefresh.Location := new System.Drawing.Point(463, 189);
  self.buttonRefresh.Name := 'buttonRefresh';
  self.buttonRefresh.Size := new System.Drawing.Size(92, 23);
  self.buttonRefresh.TabIndex := 6;
  self.buttonRefresh.Text := 'Refresh Data';
  self.buttonRefresh.UseVisualStyleBackColor := true;
  self.buttonRefresh.Click += new System.EventHandler(@self.buttonRefresh_Click);
  // 
  // buttonPrev
  // 
  self.buttonPrev.Location := new System.Drawing.Point(208, 188);
  self.buttonPrev.Name := 'buttonPrev';
  self.buttonPrev.Size := new System.Drawing.Size(75, 23);
  self.buttonPrev.TabIndex := 7;
  self.buttonPrev.Text := '< Previous';
  self.buttonPrev.UseVisualStyleBackColor := true;
  self.buttonPrev.Visible := false;
  self.buttonPrev.Click += new System.EventHandler(@self.buttonPrev_Click);
  // 
  // buttonNext
  // 
  self.buttonNext.Location := new System.Drawing.Point(289, 188);
  self.buttonNext.Name := 'buttonNext';
  self.buttonNext.Size := new System.Drawing.Size(75, 23);
  self.buttonNext.TabIndex := 8;
  self.buttonNext.Text := 'Next >';
  self.buttonNext.UseVisualStyleBackColor := true;
  self.buttonNext.Visible := false;
  self.buttonNext.Click += new System.EventHandler(@self.buttonNext_Click);
  // 
  // listBoxQueries
  // 
  self.listBoxQueries.FormattingEnabled := true;
  self.listBoxQueries.Location := new System.Drawing.Point(12, 23);
  self.listBoxQueries.Name := 'listBoxQueries';
  self.listBoxQueries.Size := new System.Drawing.Size(180, 160);
  self.listBoxQueries.TabIndex := 9;
  self.listBoxQueries.SelectedIndexChanged += new System.EventHandler(@self.listBoxQueries_SelectedIndexChanged);
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(567, 412);
  self.Controls.Add(self.listBoxQueries);
  self.Controls.Add(self.buttonNext);
  self.Controls.Add(self.buttonPrev);
  self.Controls.Add(self.buttonRefresh);
  self.Controls.Add(self.dataGridViewData);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.textBoxDescription);
  self.Controls.Add(self.buttonExecute);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MinimumSize := new System.Drawing.Size(583, 450);
  self.Name := 'MainForm';
  self.Text := 'Sequences and Queries sample';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  (self.dataGridViewData as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.