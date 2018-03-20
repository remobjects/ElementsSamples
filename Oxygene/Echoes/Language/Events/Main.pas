namespace Events;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  Events.EventClasses;

type
  { MainForm }
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    button1: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method button1_Click(sender: System.Object; e: System.EventArgs);
    method InitializeComponent;
  {$ENDREGION}
  protected
    method Dispose(aDisposing: Boolean); override;
  public
    constructor;
    class method Main;

    { The following method will be assigned to an instance of
      SimpleClassWithEvents and will provide an implementation for
      the delegate OnSetName }
    method MyCustomSetName(Sender: SimpleClassWithEvents; var aNewName: String);
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
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.button1 := new System.Windows.Forms.Button();
  self.SuspendLayout();
  //
  // button1
  //
  self.button1.Location := new System.Drawing.Point(47, 50);
  self.button1.Name := 'button1';
  self.button1.Size := new System.Drawing.Size(150, 23);
  self.button1.TabIndex := 0;
  self.button1.Text := 'Test Events';
  self.button1.Click += new System.EventHandler(@self.button1_Click);
  //
  // MainForm
  //
  self.AutoScaleBaseSize := new System.Drawing.Size(5, 13);
  self.ClientSize := new System.Drawing.Size(244, 122);
  self.Controls.Add(self.button1);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'Events Sample';
  self.ResumeLayout(false);
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

method MainForm.button1_Click(sender: System.Object; e: System.EventArgs);
var dummy : SimpleClassWithEvents;
begin
  dummy := new SimpleClassWithEvents;

  { Notice the += operator used to assign delegates. Each event can
    have multiple handler hooked up to it, and += is used to add one event
    to the list. Conversely, -= could be used to remove a particular
    handler. }
  dummy.OnSetName += MyCustomSetName;

  { If you un-comment this line, MyCustomSetName will be called twice when
    we set a value to dummy.Name. }
  //dummy.OnSetName += MyCustomSetName;

  dummy.Name := 'Jack London';
end;

method MainForm.MyCustomSetName(Sender: SimpleClassWithEvents; var aNewName: string);
begin
  MessageBox.Show('Setting Name from '+Sender.Name+' to '+aNewName);
end;

end.