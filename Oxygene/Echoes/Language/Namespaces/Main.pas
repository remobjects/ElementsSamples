namespace NameSpaces;

interface

uses
  { Notice the use of the wildcard "*" below, which results in the automatic
    inclusion of all children of the namespaces "System" and "Namespaces" }
  System.*,
  Namespaces.*;

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
    method Dispose(aDisposing: boolean); override;
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
  self.button1.Location := new System.Drawing.Point(47, 50);
  self.button1.Name := 'button1';
  self.button1.Size := new System.Drawing.Size(150, 23);
  self.button1.TabIndex := 0;
  self.button1.Text := 'Test Classes';
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
  self.Text := 'Namespaces Sample';
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
  lEmployee  : Employee;
  lPresident : President;
begin
  lPresident  := new President;
  lEmployee   := new Employee;
  
  { The following code will perform a few type tests to verify everything works as expected }
  if (lPresident is Employee) 
    then MessageBox.Show('President is an Employee');
    
  if (lEmployee is Person) 
    then MessageBox.Show('Employee is a Person');
  
  if (lEmployee is not President) 
    then MessageBox.Show('Employee is not a President');  
end;

end.
