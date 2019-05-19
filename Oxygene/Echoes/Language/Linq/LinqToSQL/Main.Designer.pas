namespace LinqToSQL;

{$HIDE H8}

interface

uses
  System.Drawing,
  System.Collections,
  System.Windows.Forms,
  System.ComponentModel;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    var 
    components: System.ComponentModel.IContainer;
    tbDatabase: System.Windows.Forms.TextBox;
    label1: System.Windows.Forms.Label;
    openFileDialog: System.Windows.Forms.OpenFileDialog;
    btnSelectDBFile: System.Windows.Forms.Button;
    dataGridView: System.Windows.Forms.DataGridView;
    btnExecuteJOIN: System.Windows.Forms.Button;
    btnExecuteSELECT: System.Windows.Forms.Button;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.btnExecuteSELECT := new System.Windows.Forms.Button();
  self.dataGridView := new System.Windows.Forms.DataGridView();
  self.label1 := new System.Windows.Forms.Label();
  self.tbDatabase := new System.Windows.Forms.TextBox();
  self.btnExecuteJOIN := new System.Windows.Forms.Button();
  self.btnSelectDBFile := new System.Windows.Forms.Button();
  self.openFileDialog := new System.Windows.Forms.OpenFileDialog();
  (self.dataGridView as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // btnExecuteSELECT
  // 
  self.btnExecuteSELECT.Anchor := ((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.btnExecuteSELECT.Location := new System.Drawing.Point(224, 51);
  self.btnExecuteSELECT.Name := 'btnExecuteSELECT';
  self.btnExecuteSELECT.Size := new System.Drawing.Size(135, 23);
  self.btnExecuteSELECT.TabIndex := 0;
  self.btnExecuteSELECT.Text := 'Execute SELECT query';
  self.btnExecuteSELECT.UseVisualStyleBackColor := true;
  self.btnExecuteSELECT.Click += new System.EventHandler(@self.btnExecuteSELECT_Click);
  // 
  // dataGridView
  // 
  self.dataGridView.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom) 
        or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.dataGridView.ColumnHeadersHeightSizeMode := System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
  self.dataGridView.Location := new System.Drawing.Point(13, 80);
  self.dataGridView.Name := 'dataGridView';
  self.dataGridView.Size := new System.Drawing.Size(487, 425);
  self.dataGridView.TabIndex := 1;
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Location := new System.Drawing.Point(10, 9);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(216, 13);
  self.label1.TabIndex := 2;
  self.label1.Text := 'AdventureWorks SQL Server database path';
  // 
  // tbDatabase
  // 
  self.tbDatabase.Anchor := (((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Left) 
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.tbDatabase.Location := new System.Drawing.Point(12, 25);
  self.tbDatabase.Name := 'tbDatabase';
  self.tbDatabase.Size := new System.Drawing.Size(456, 20);
  self.tbDatabase.TabIndex := 3;
  self.tbDatabase.Text := 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\AdventureWorks_Data.mdf';
  // 
  // btnExecuteJOIN
  // 
  self.btnExecuteJOIN.Anchor := ((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.btnExecuteJOIN.Location := new System.Drawing.Point(365, 51);
  self.btnExecuteJOIN.Name := 'btnExecuteJOIN';
  self.btnExecuteJOIN.Size := new System.Drawing.Size(135, 23);
  self.btnExecuteJOIN.TabIndex := 5;
  self.btnExecuteJOIN.Text := 'Execute JOIN query';
  self.btnExecuteJOIN.UseVisualStyleBackColor := true;
  self.btnExecuteJOIN.Click += new System.EventHandler(@self.btnExecuteJOIN_Click);
  // 
  // btnSelectDBFile
  // 
  self.btnSelectDBFile.Anchor := ((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.btnSelectDBFile.Location := new System.Drawing.Point(474, 23);
  self.btnSelectDBFile.Name := 'btnSelectDBFile';
  self.btnSelectDBFile.Size := new System.Drawing.Size(26, 23);
  self.btnSelectDBFile.TabIndex := 6;
  self.btnSelectDBFile.Text := '...';
  self.btnSelectDBFile.UseVisualStyleBackColor := true;
  self.btnSelectDBFile.Click += new System.EventHandler(@self.btnSelectDBFile_Click);
  // 
  // openFileDialog
  // 
  self.openFileDialog.DefaultExt := '*.mdf';
  self.openFileDialog.Filter := ' "AdventureWorks database|AdventureWorks_Data.mdf|All files (*.*)|*.*"';
  self.openFileDialog.InitialDirectory := 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\';
  self.openFileDialog.Title := 'Please select AdventureWorks sample database';
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(514, 517);
  self.Controls.Add(self.btnSelectDBFile);
  self.Controls.Add(self.btnExecuteJOIN);
  self.Controls.Add(self.tbDatabase);
  self.Controls.Add(self.label1);
  self.Controls.Add(self.dataGridView);
  self.Controls.Add(self.btnExecuteSELECT);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MinimumSize := new System.Drawing.Size(400, 300);
  self.Name := 'MainForm';
  self.Text := 'Linq to SQL Sample';
  (self.dataGridView as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.