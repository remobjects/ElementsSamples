namespace VirtualProperties;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  VirtualProperties.VirtualPropertiesClasses;

type
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
  self.button1.Location := new System.Drawing.Point(42, 45);
  self.button1.Name := 'button1';
  self.button1.Size := new System.Drawing.Size(150, 23);
  self.button1.TabIndex := 0;
  self.button1.Text := 'Test Virtual Property';
  self.button1.Click += new System.EventHandler(@self.button1_Click);
  //
  // MainForm
  //
  self.ClientSize := new System.Drawing.Size(234, 112);
  self.Controls.Add(self.button1);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'VirtualProperties Sample';
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
var
  //base: BaseClass;
  first: FirstDescendant;
  second: SecondDescendant;
begin
  { Cannot create this class because it has abstract properties }
  //base := new BaseClass;
  //base.Name := 'Jack';

  first := new FirstDescendant;
  first.Name := 'John';

  MessageBox.Show('first.Name is '+first.Name);

  second := new SecondDescendant;
  second.Name := 'Claire';

  MessageBox.Show('second.Name is '+(second as IHasName).Name);
end;


end.