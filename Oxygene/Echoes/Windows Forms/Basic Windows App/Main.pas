namespace BasicWindowsApp;

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = class(System.Windows.Forms.Form)
  private
  {$REGION Windows Form Designer generated fields}
    bHelloWorld: System.Windows.Forms.Button;
    components: System.ComponentModel.Container := nil;
    method bHelloWorld_Click(sender: System.Object; e: System.EventArgs);
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
  self.bHelloWorld := new System.Windows.Forms.Button();
  self.SuspendLayout();
  //
  // bHelloWorld
  //
  self.bHelloWorld.Location := new System.Drawing.Point(47, 50);
  self.bHelloWorld.Name := 'bHelloWorld';
  self.bHelloWorld.Size := new System.Drawing.Size(150, 23);
  self.bHelloWorld.TabIndex := 0;
  self.bHelloWorld.Text := 'Say HelloWorld!';
  self.bHelloWorld.Click += new System.EventHandler(@self.bHelloWorld_Click);
  //
  // MainForm
  //
  self.AutoScaleBaseSize := new System.Drawing.Size(5, 13);
  self.ClientSize := new System.Drawing.Size(244, 122);
  self.Controls.Add(self.bHelloWorld);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'BasicWindowsApp Sample';
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

method MainForm.bHelloWorld_Click(sender: System.Object; e: System.EventArgs);
var s : String;
begin
  { This method doesn't do much, but you can set a break point here and
    watch the value of the string "s" }
  s := 'Hello World!';

  { Try code completion by pressing CTRL+SPACE after "Message." }
  MessageBox.Show(s);
end;

end.