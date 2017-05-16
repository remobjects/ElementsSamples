namespace QueueAndStack;

interface

uses
  System.Windows.Forms, 
  System.Drawing,
  OxygeneQueue, OxygeneStack;

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    CountStringsButton: System.Windows.Forms.Button;
    PushIntegerButton: System.Windows.Forms.Button;
    StringBox: System.Windows.Forms.TextBox;
    ListBox: System.Windows.Forms.ListBox;
    IntegerBox: System.Windows.Forms.TextBox;
    PushStringButton: System.Windows.Forms.Button;
    PopIntegerButton: System.Windows.Forms.Button;
    label2: System.Windows.Forms.Label;
    PopStringButton: System.Windows.Forms.Button;
    label1: System.Windows.Forms.Label;
    components: System.ComponentModel.Container := nil;
    method CountStringsButton_Click(sender: System.Object; e: System.EventArgs);
    method PushIntegerButton_Click(sender: System.Object; e: System.EventArgs);
    method PopIntegerButton_Click(sender: System.Object; e: System.EventArgs);
    method PopStringButton_Click(sender: System.Object; e: System.EventArgs);
    method PushStringButton_Click(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    method Dispose(aDisposing: boolean); override;
  public
    constructor;
    class method Main;
  private
  var
    StringStack: Stack<String> := new Stack<String>; 
    IntegerQueue: Queue<Integer> := new Queue<Integer>;
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
  self.label1 := new System.Windows.Forms.Label();
  self.StringBox := new System.Windows.Forms.TextBox();
  self.PopStringButton := new System.Windows.Forms.Button();
  self.PopIntegerButton := new System.Windows.Forms.Button();
  self.IntegerBox := new System.Windows.Forms.TextBox();
  self.label2 := new System.Windows.Forms.Label();
  self.PushIntegerButton := new System.Windows.Forms.Button();
  self.PushStringButton := new System.Windows.Forms.Button();
  self.ListBox := new System.Windows.Forms.ListBox();
  self.CountStringsButton := new System.Windows.Forms.Button();
  self.SuspendLayout();
  // 
  // label1
  // 
  self.label1.AutoSize := true;
  self.label1.Location := new System.Drawing.Point(32, 67);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(34, 13);
  self.label1.TabIndex := 0;
  self.label1.Text := 'String';
  // 
  // StringBox
  // 
  self.StringBox.Location := new System.Drawing.Point(115, 64);
  self.StringBox.Name := 'StringBox';
  self.StringBox.Size := new System.Drawing.Size(83, 20);
  self.StringBox.TabIndex := 1;
  self.StringBox.Text := 'new string';
  // 
  // PopStringButton
  // 
  self.PopStringButton.Location := new System.Drawing.Point(326, 62);
  self.PopStringButton.Name := 'PopStringButton';
  self.PopStringButton.Size := new System.Drawing.Size(88, 23);
  self.PopStringButton.TabIndex := 2;
  self.PopStringButton.Text := 'Pop String';
  self.PopStringButton.Click += new System.EventHandler(@self.PopStringButton_Click);
  // 
  // PopIntegerButton
  // 
  self.PopIntegerButton.Location := new System.Drawing.Point(326, 12);
  self.PopIntegerButton.Name := 'PopIntegerButton';
  self.PopIntegerButton.Size := new System.Drawing.Size(88, 23);
  self.PopIntegerButton.TabIndex := 5;
  self.PopIntegerButton.Text := 'Pop Integer';
  self.PopIntegerButton.Click += new System.EventHandler(@self.PopIntegerButton_Click);
  // 
  // IntegerBox
  // 
  self.IntegerBox.Location := new System.Drawing.Point(115, 14);
  self.IntegerBox.Name := 'IntegerBox';
  self.IntegerBox.Size := new System.Drawing.Size(83, 20);
  self.IntegerBox.TabIndex := 4;
  self.IntegerBox.Text := '999';
  self.IntegerBox.TextAlign := System.Windows.Forms.HorizontalAlignment.Right;
  // 
  // label2
  // 
  self.label2.AutoSize := true;
  self.label2.Location := new System.Drawing.Point(26, 17);
  self.label2.Name := 'label2';
  self.label2.Size := new System.Drawing.Size(40, 13);
  self.label2.TabIndex := 3;
  self.label2.Text := 'Integer';
  // 
  // PushIntegerButton
  // 
  self.PushIntegerButton.Location := new System.Drawing.Point(222, 12);
  self.PushIntegerButton.Name := 'PushIntegerButton';
  self.PushIntegerButton.Size := new System.Drawing.Size(88, 23);
  self.PushIntegerButton.TabIndex := 7;
  self.PushIntegerButton.Text := 'Push Integer';
  self.PushIntegerButton.Click += new System.EventHandler(@self.PushIntegerButton_Click);
  // 
  // PushStringButton
  // 
  self.PushStringButton.Location := new System.Drawing.Point(222, 62);
  self.PushStringButton.Name := 'PushStringButton';
  self.PushStringButton.Size := new System.Drawing.Size(88, 23);
  self.PushStringButton.TabIndex := 6;
  self.PushStringButton.Text := 'Push String';
  self.PushStringButton.Click += new System.EventHandler(@self.PushStringButton_Click);
  // 
  // ListBox
  // 
  self.ListBox.FormattingEnabled := true;
  self.ListBox.IntegralHeight := false;
  self.ListBox.Location := new System.Drawing.Point(29, 91);
  self.ListBox.Name := 'ListBox';
  self.ListBox.Size := new System.Drawing.Size(384, 243);
  self.ListBox.TabIndex := 8;
  // 
  // CountStringsButton
  // 
  self.CountStringsButton.Location := new System.Drawing.Point(29, 33);
  self.CountStringsButton.Name := 'CountStringsButton';
  self.CountStringsButton.Size := new System.Drawing.Size(75, 23);
  self.CountStringsButton.TabIndex := 11;
  self.CountStringsButton.Text := 'Counts';
  self.CountStringsButton.Click += new System.EventHandler(@self.CountStringsButton_Click);
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(429, 346);
  self.Controls.Add(self.CountStringsButton);
  self.Controls.Add(self.ListBox);
  self.Controls.Add(self.PushIntegerButton);
  self.Controls.Add(self.PushStringButton);
  self.Controls.Add(self.PopIntegerButton);
  self.Controls.Add(self.IntegerBox);
  self.Controls.Add(self.label2);
  self.Controls.Add(self.PopStringButton);
  self.Controls.Add(self.StringBox);
  self.Controls.Add(self.label1);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'QueueAndStack Sample';
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

method MainForm.PushStringButton_Click(sender: System.Object; e: System.EventArgs);
begin
  StringStack.Push(StringBox.Text);
  StringBox.Text := '';
end;

method MainForm.PopStringButton_Click(sender: System.Object; e: System.EventArgs);
begin
  ListBox.Items.Add(StringStack.Pop);
end;

method MainForm.PushIntegerButton_Click(sender: System.Object; e: System.EventArgs);
begin
  IntegerQueue.Push(Int32.Parse(IntegerBox.Text));
  IntegerBox.Text := '0';
end;

method MainForm.PopIntegerButton_Click(sender: System.Object; e: System.EventArgs);
begin
  ListBox.Items.Add(IntegerQueue.Pop.ToString);
end;

method MainForm.CountStringsButton_Click(sender: System.Object; e: System.EventArgs);
begin
  ListBox.Items.Add('StringStack Count = '+StringStack.Count.ToString);
  ListBox.Items.Add('IntegerQueue Count = '+IntegerQueue.Count.ToString);
end;

end.
