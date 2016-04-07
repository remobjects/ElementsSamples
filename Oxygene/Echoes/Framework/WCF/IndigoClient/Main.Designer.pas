namespace Indigo;

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
    label2: System.Windows.Forms.Label;
    nudA: System.Windows.Forms.NumericUpDown;
    nudB: System.Windows.Forms.NumericUpDown;
    groupBox1: System.Windows.Forms.GroupBox;
    bGetServerTime: System.Windows.Forms.Button;
    groupBox3: System.Windows.Forms.GroupBox;
    bArithm: System.Windows.Forms.Button;
    label3: System.Windows.Forms.Label;
    radioButtonPlus: System.Windows.Forms.RadioButton;
    radioButtonMinus: System.Windows.Forms.RadioButton;
    radioButtonMult: System.Windows.Forms.RadioButton;
    radioButtonDiv: System.Windows.Forms.RadioButton;
    groupBox2: System.Windows.Forms.GroupBox;
    comboBoxEndpoints: System.Windows.Forms.ComboBox;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.groupBox3 := new System.Windows.Forms.GroupBox();
  self.bGetServerTime := new System.Windows.Forms.Button();
  self.groupBox1 := new System.Windows.Forms.GroupBox();
  self.label3 := new System.Windows.Forms.Label();
  self.radioButtonDiv := new System.Windows.Forms.RadioButton();
  self.radioButtonMult := new System.Windows.Forms.RadioButton();
  self.radioButtonMinus := new System.Windows.Forms.RadioButton();
  self.radioButtonPlus := new System.Windows.Forms.RadioButton();
  self.nudB := new System.Windows.Forms.NumericUpDown();
  self.nudA := new System.Windows.Forms.NumericUpDown();
  self.bArithm := new System.Windows.Forms.Button();
  self.label2 := new System.Windows.Forms.Label();
  self.label1 := new System.Windows.Forms.Label();
  self.groupBox2 := new System.Windows.Forms.GroupBox();
  self.comboBoxEndpoints := new System.Windows.Forms.ComboBox();
  self.groupBox3.SuspendLayout();
  self.groupBox1.SuspendLayout();
  (self.nudB as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.nudA as System.ComponentModel.ISupportInitialize).BeginInit();
  self.groupBox2.SuspendLayout();
  self.SuspendLayout();
  // 
  // groupBox3
  // 
  self.groupBox3.Controls.Add(self.bGetServerTime);
  self.groupBox3.Location := new System.Drawing.Point(12, 74);
  self.groupBox3.Name := 'groupBox3';
  self.groupBox3.Size := new System.Drawing.Size(133, 58);
  self.groupBox3.TabIndex := 6;
  self.groupBox3.TabStop := false;
  self.groupBox3.Text := 'GetServerTime';
  // 
  // bGetServerTime
  // 
  self.bGetServerTime.Location := new System.Drawing.Point(7, 29);
  self.bGetServerTime.Name := 'bGetServerTime';
  self.bGetServerTime.Size := new System.Drawing.Size(120, 23);
  self.bGetServerTime.TabIndex := 0;
  self.bGetServerTime.Text := 'Get Server Time';
  self.bGetServerTime.Click += new System.EventHandler(@self.bGetServerTime_Click);
  // 
  // groupBox1
  // 
  self.groupBox1.Controls.Add(self.label3);
  self.groupBox1.Controls.Add(self.radioButtonDiv);
  self.groupBox1.Controls.Add(self.radioButtonMult);
  self.groupBox1.Controls.Add(self.radioButtonMinus);
  self.groupBox1.Controls.Add(self.radioButtonPlus);
  self.groupBox1.Controls.Add(self.nudB);
  self.groupBox1.Controls.Add(self.nudA);
  self.groupBox1.Controls.Add(self.bArithm);
  self.groupBox1.Controls.Add(self.label2);
  self.groupBox1.Controls.Add(self.label1);
  self.groupBox1.Location := new System.Drawing.Point(160, 12);
  self.groupBox1.Name := 'groupBox1';
  self.groupBox1.Size := new System.Drawing.Size(151, 120);
  self.groupBox1.TabIndex := 5;
  self.groupBox1.TabStop := false;
  self.groupBox1.Text := 'Arithmetic';
  // 
  // label3
  // 
  self.label3.AutoSize := true;
  self.label3.Location := new System.Drawing.Point(6, 47);
  self.label3.Name := 'label3';
  self.label3.Size := new System.Drawing.Size(93, 13);
  self.label3.TabIndex := 7;
  self.label3.Text := 'Choose operation:';
  // 
  // radioButtonDiv
  // 
  self.radioButtonDiv.AutoSize := true;
  self.radioButtonDiv.Location := new System.Drawing.Point(113, 68);
  self.radioButtonDiv.Name := 'radioButtonDiv';
  self.radioButtonDiv.Size := new System.Drawing.Size(30, 17);
  self.radioButtonDiv.TabIndex := 7;
  self.radioButtonDiv.Text := '/';
  self.radioButtonDiv.UseVisualStyleBackColor := true;
  // 
  // radioButtonMult
  // 
  self.radioButtonMult.AutoSize := true;
  self.radioButtonMult.Location := new System.Drawing.Point(78, 68);
  self.radioButtonMult.Name := 'radioButtonMult';
  self.radioButtonMult.Size := new System.Drawing.Size(29, 17);
  self.radioButtonMult.TabIndex := 9;
  self.radioButtonMult.Text := '*';
  self.radioButtonMult.UseVisualStyleBackColor := true;
  // 
  // radioButtonMinus
  // 
  self.radioButtonMinus.AutoSize := true;
  self.radioButtonMinus.Location := new System.Drawing.Point(46, 68);
  self.radioButtonMinus.Name := 'radioButtonMinus';
  self.radioButtonMinus.Size := new System.Drawing.Size(28, 17);
  self.radioButtonMinus.TabIndex := 8;
  self.radioButtonMinus.Text := '-';
  self.radioButtonMinus.UseVisualStyleBackColor := true;
  // 
  // radioButtonPlus
  // 
  self.radioButtonPlus.AutoSize := true;
  self.radioButtonPlus.Checked := true;
  self.radioButtonPlus.Location := new System.Drawing.Point(9, 68);
  self.radioButtonPlus.Name := 'radioButtonPlus';
  self.radioButtonPlus.Size := new System.Drawing.Size(31, 17);
  self.radioButtonPlus.TabIndex := 7;
  self.radioButtonPlus.TabStop := true;
  self.radioButtonPlus.Text := '+';
  self.radioButtonPlus.UseVisualStyleBackColor := true;
  // 
  // nudB
  // 
  self.nudB.Location := new System.Drawing.Point(95, 19);
  self.nudB.Name := 'nudB';
  self.nudB.Size := new System.Drawing.Size(48, 20);
  self.nudB.TabIndex := 6;
  self.nudB.Value := new System.Decimal(array of System.Int32([2,
      0,
      0,
      0]));
  // 
  // nudA
  // 
  self.nudA.Location := new System.Drawing.Point(24, 19);
  self.nudA.Name := 'nudA';
  self.nudA.Size := new System.Drawing.Size(48, 20);
  self.nudA.TabIndex := 5;
  self.nudA.Value := new System.Decimal(array of System.Int32([1,
      0,
      0,
      0]));
  // 
  // bArithm
  // 
  self.bArithm.Location := new System.Drawing.Point(36, 91);
  self.bArithm.Name := 'bArithm';
  self.bArithm.Size := new System.Drawing.Size(82, 23);
  self.bArithm.TabIndex := 4;
  self.bArithm.Text := 'Get Result';
  self.bArithm.Click += new System.EventHandler(@self.bArithm_Click);
  // 
  // label2
  // 
  self.label2.Location := new System.Drawing.Point(78, 21);
  self.label2.Name := 'label2';
  self.label2.Size := new System.Drawing.Size(24, 16);
  self.label2.TabIndex := 3;
  self.label2.Text := 'B:';
  // 
  // label1
  // 
  self.label1.Location := new System.Drawing.Point(6, 21);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(24, 16);
  self.label1.TabIndex := 2;
  self.label1.Text := 'A:';
  // 
  // groupBox2
  // 
  self.groupBox2.Controls.Add(self.comboBoxEndpoints);
  self.groupBox2.Location := new System.Drawing.Point(12, 12);
  self.groupBox2.Name := 'groupBox2';
  self.groupBox2.Size := new System.Drawing.Size(133, 56);
  self.groupBox2.TabIndex := 7;
  self.groupBox2.TabStop := false;
  self.groupBox2.Text := 'Endpoint';
  // 
  // comboBoxEndpoints
  // 
  self.comboBoxEndpoints.FormattingEnabled := true;
  self.comboBoxEndpoints.Items.AddRange(array of System.Object(['httpEndpoint',
      'tcpEndpoint',
      'namedPipeEndpoint']));
  self.comboBoxEndpoints.Location := new System.Drawing.Point(6, 18);
  self.comboBoxEndpoints.Name := 'comboBoxEndpoints';
  self.comboBoxEndpoints.Size := new System.Drawing.Size(121, 21);
  self.comboBoxEndpoints.TabIndex := 0;
  self.comboBoxEndpoints.SelectedIndexChanged += new System.EventHandler(@self.comboBoxEndpoints_SelectedIndexChanged);
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(323, 144);
  self.Controls.Add(self.groupBox2);
  self.Controls.Add(self.groupBox3);
  self.Controls.Add(self.groupBox1);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
  self.Text := 'IndigoClient';
  self.groupBox3.ResumeLayout(false);
  self.groupBox1.ResumeLayout(false);
  self.groupBox1.PerformLayout();
  (self.nudB as System.ComponentModel.ISupportInitialize).EndInit();
  (self.nudA as System.ComponentModel.ISupportInitialize).EndInit();
  self.groupBox2.ResumeLayout(false);
  self.ResumeLayout(false);
end;
{$ENDREGION}

end.