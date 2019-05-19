namespace Anonymous_Methods;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  System.Threading;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    btnRestore: System.Windows.Forms.Button;
    txtName: System.Windows.Forms.TextBox;
    groupBox1: System.Windows.Forms.GroupBox;
    label1: System.Windows.Forms.Label;
    btnFindByName: System.Windows.Forms.Button;
    btnSort: System.Windows.Forms.Button;
    lbCustomers: System.Windows.Forms.ListBox;
    fCustomers: System.Collections.Generic.List<Customer>;
    threadSafeTextBox: Anonymous_Methods.ThreadSafeTextBox;
    btnUsingInThreads: System.Windows.Forms.Button;
    gbLog: System.Windows.Forms.GroupBox;
    components: System.ComponentModel.Container := nil;
    method InitializeComponent;
  {$ENDREGION}
  private
    method CreateThreadSafeTextBox;
    method txtName_KeyDown(sender: System.Object; e: System.Windows.Forms.KeyEventArgs);
    method btnRestore_Click(sender: System.Object; e: System.EventArgs);
    method btnFindByName_Click(sender: System.Object; e: System.EventArgs);
    method btnSort_Click(sender: System.Object; e: System.EventArgs);
    method MainForm_Load(sender: System.Object; e: System.EventArgs);
    method btnUsingInThreads_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(aDisposing: Boolean); override;
  public
    constructor;
  end;

  ThreadSafeTextBox = public class(System.Windows.Forms.TextBox)
  public
    constructor;
    method AppendLine(aText: String);
  end;

  Customer = public class
  private
    fAge: Integer;
    fName: String;
    fID: Integer;
  public
    constructor(aID: Integer; aName: String; anAge: Integer);
    method ToString: String; override;
    property ID: Integer read fID write fID;
    property Name: String read fName write fName;
    property Age: Integer read fAge write fAge;

  end;


implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //

  CreateThreadSafeTextBox;
end;

method MainForm.Dispose(aDisposing: boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.gbLog := new System.Windows.Forms.GroupBox();
  self.label1 := new System.Windows.Forms.Label();
  self.btnUsingInThreads := new System.Windows.Forms.Button();
  self.lbCustomers := new System.Windows.Forms.ListBox();
  self.btnSort := new System.Windows.Forms.Button();
  self.btnFindByName := new System.Windows.Forms.Button();
  self.groupBox1 := new System.Windows.Forms.GroupBox();
  self.txtName := new System.Windows.Forms.TextBox();
  self.btnRestore := new System.Windows.Forms.Button();
  self.gbLog.SuspendLayout();
  self.groupBox1.SuspendLayout();
  self.SuspendLayout();
  //
  // gbLog
  //
  self.gbLog.Controls.Add(self.label1);
  self.gbLog.Controls.Add(self.btnUsingInThreads);
  self.gbLog.Location := new System.Drawing.Point(12, 12);
  self.gbLog.Name := 'gbLog';
  self.gbLog.Size := new System.Drawing.Size(208, 235);
  self.gbLog.TabIndex := 0;
  self.gbLog.TabStop := false;
  self.gbLog.Text := 'Using with Threads';
  //
  // label1
  //
  self.label1.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom)
        or System.Windows.Forms.AnchorStyles.Left)
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.label1.Location := new System.Drawing.Point(6, 50);
  self.label1.Name := 'label1';
  self.label1.Size := new System.Drawing.Size(196, 32);
  self.label1.TabIndex := 1;
  self.label1.Text := 'TextBox below provides AppendLine method that is thread-safe';
  self.label1.TextAlign := System.Drawing.ContentAlignment.MiddleCenter;
  //
  // btnUsingInThreads
  //
  self.btnUsingInThreads.Location := new System.Drawing.Point(6, 19);
  self.btnUsingInThreads.Name := 'btnUsingInThreads';
  self.btnUsingInThreads.Size := new System.Drawing.Size(196, 23);
  self.btnUsingInThreads.TabIndex := 0;
  self.btnUsingInThreads.Text := 'Run Threads';
  self.btnUsingInThreads.UseVisualStyleBackColor := true;
  self.btnUsingInThreads.Click += new System.EventHandler(@self.btnUsingInThreads_Click);
  //
  // lbCustomers
  //
  self.lbCustomers.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom)
        or System.Windows.Forms.AnchorStyles.Left)
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.lbCustomers.FormattingEnabled := true;
  self.lbCustomers.Location := new System.Drawing.Point(6, 19);
  self.lbCustomers.Name := 'lbCustomers';
  self.lbCustomers.Size := new System.Drawing.Size(222, 121);
  self.lbCustomers.TabIndex := 0;
  //
  // btnSort
  //
  self.btnSort.Location := new System.Drawing.Point(6, 148);
  self.btnSort.Name := 'btnSort';
  self.btnSort.Size := new System.Drawing.Size(222, 23);
  self.btnSort.TabIndex := 1;
  self.btnSort.Text := 'Sort Customers by Age';
  self.btnSort.UseVisualStyleBackColor := true;
  self.btnSort.Click += new System.EventHandler(@self.btnSort_Click);
  //
  // btnFindByName
  //
  self.btnFindByName.Location := new System.Drawing.Point(145, 177);
  self.btnFindByName.Name := 'btnFindByName';
  self.btnFindByName.Size := new System.Drawing.Size(83, 23);
  self.btnFindByName.TabIndex := 3;
  self.btnFindByName.Text := 'Find By Name';
  self.btnFindByName.UseVisualStyleBackColor := true;
  self.btnFindByName.Click += new System.EventHandler(@self.btnFindByName_Click);
  //
  // groupBox1
  //
  self.groupBox1.Controls.Add(self.txtName);
  self.groupBox1.Controls.Add(self.btnRestore);
  self.groupBox1.Controls.Add(self.lbCustomers);
  self.groupBox1.Controls.Add(self.btnFindByName);
  self.groupBox1.Controls.Add(self.btnSort);
  self.groupBox1.Location := new System.Drawing.Point(226, 12);
  self.groupBox1.Name := 'groupBox1';
  self.groupBox1.Size := new System.Drawing.Size(234, 235);
  self.groupBox1.TabIndex := 1;
  self.groupBox1.TabStop := false;
  self.groupBox1.Text := 'Working with Collections';
  //
  // txtName
  //
  self.txtName.Location := new System.Drawing.Point(6, 179);
  self.txtName.Name := 'txtName';
  self.txtName.Size := new System.Drawing.Size(133, 20);
  self.txtName.TabIndex := 2;
  self.txtName.Text := 'Alex';
  self.txtName.KeyDown += new System.Windows.Forms.KeyEventHandler(@self.txtName_KeyDown);
  //
  // btnRestore
  //
  self.btnRestore.Location := new System.Drawing.Point(6, 206);
  self.btnRestore.Name := 'btnRestore';
  self.btnRestore.Size := new System.Drawing.Size(222, 23);
  self.btnRestore.TabIndex := 4;
  self.btnRestore.Text := 'Restore List';
  self.btnRestore.UseVisualStyleBackColor := true;
  self.btnRestore.Click += new System.EventHandler(@self.btnRestore_Click);
  //
  // MainForm
  //
  self.ClientSize := new System.Drawing.Size(483, 271);
  self.Controls.Add(self.groupBox1);
  self.Controls.Add(self.gbLog);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.MaximumSize := new System.Drawing.Size(489, 299);
  self.MinimumSize := new System.Drawing.Size(489, 299);
  self.Name := 'MainForm';
  self.Text := 'Anonymous Methods';
  self.Load += new System.EventHandler(@self.MainForm_Load);
  self.gbLog.ResumeLayout(false);
  self.groupBox1.ResumeLayout(false);
  self.groupBox1.PerformLayout();
  self.ResumeLayout(false);
end;
{$ENDREGION}


method MainForm.CreateThreadSafeTextBox;
begin
  self.threadSafeTextBox := new Anonymous_Methods.ThreadSafeTextBox();
  self.threadSafeTextBox.Anchor := ((((System.Windows.Forms.AnchorStyles.Top or System.Windows.Forms.AnchorStyles.Bottom)
        or System.Windows.Forms.AnchorStyles.Left)
        or System.Windows.Forms.AnchorStyles.Right) as System.Windows.Forms.AnchorStyles);
  self.threadSafeTextBox.Location := new System.Drawing.Point(6, 80);
  self.threadSafeTextBox.Multiline := true;
  self.threadSafeTextBox.Name := 'threadSafeTextBox';
  self.threadSafeTextBox.Size := new System.Drawing.Size(196, 149);
  self.threadSafeTextBox.TabIndex := 2;
  self.threadSafeTextBox.ScrollBars := ScrollBars.Both;
  self.gbLog.Controls.Add(self.threadSafeTextBox);
end;



constructor Customer(aID: Integer; aName: String; anAge: Integer);
begin
  fID := aID;
  fName := aName;
  fAge := anAge;
end;

method Customer.ToString: String;
begin
  exit(String.Format('Id:{0}; Name:{1}; Age:{2}', fID, fName, fAge));
end;

constructor ThreadSafeTextBox;
begin
  Multiline := true;
end;


method ThreadSafeTextBox.AppendLine(aText: String);
begin
  if(Self.InvokeRequired) then begin
    Invoke(
      method;
      begin
        Self.Text := Self.Text + aText + Environment.NewLine;
        Self.SelectionStart := Self.Text.Length;
        Self.ScrollToCaret();
      end
    );
  end else
    inherited Text := inherited Text + aText;
end;








method MainForm.btnUsingInThreads_Click(sender: System.Object; e: System.EventArgs);
var
  lThreadCount: Integer := 5;
begin
  var lMyParam: String := 'Hello from thread #{0}. i={1}';

  for i: Integer := 0 to lThreadCount - 1 do begin
       new Thread(
           method();
           begin
             var lThreadID: Int32 := Thread.CurrentThread.ManagedThreadId;
             threadSafeTextBox.AppendLine(String.Format(lMyParam, lThreadID, i));
           end
       ).Start();
   end;
end;

method MainForm.MainForm_Load(sender: System.Object; e: System.EventArgs);
begin
   fCustomers := new System.Collections.Generic.List<Customer>;
   btnRestore_Click(nil, nil);
end;

method MainForm.btnSort_Click(sender: System.Object; e: System.EventArgs);
begin
  lbCustomers.DataSource :=  nil;
  fCustomers.Sort(
     method(c1: Customer; c2: Customer): Integer;
     begin
      exit(c1.Age.CompareTo(c2.Age));
     end
   );
  lbCustomers.DataSource :=  fCustomers;
end;

method MainForm.btnFindByName_Click(sender: System.Object; e: System.EventArgs);
begin
  var lPattern: String := txtName.Text;
  lbCustomers.DataSource :=
  fCustomers.FindAll(
    method(c: Customer): Boolean;
    begin
      exit(c.Name.ToLower.Contains(lPattern.ToLower()));
    end
  );

end;

method MainForm.btnRestore_Click(sender: System.Object; e: System.EventArgs);
begin
  lbCustomers.DataSource :=  nil;
  fCustomers.Clear();
  fCustomers.Add(new Customer(1, 'Antonio Moreno', 32));
  fCustomers.Add(new Customer(2, 'Elizabeth Lincoln', 41));
  fCustomers.Add(new Customer(3, 'Aria Cruz', 37));
  fCustomers.Add(new Customer(4, 'Helena Doe', 28));
  fCustomers.Add(new Customer(5, 'Philip Cramer', 34));
  fCustomers.Add(new Customer(6, 'Alexander Feuer', 30));
  fCustomers.Add(new Customer(7, 'Michael Holz', 45));

  lbCustomers.DataSource := fCustomers;
end;


method MainForm.txtName_KeyDown(sender: System.Object; e: System.Windows.Forms.KeyEventArgs);
begin
  if e.KeyCode = Keys.Return then btnFindByName_Click(sender, nil);
end;


end.