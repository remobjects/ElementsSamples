namespace ListBox;

interface

uses
  System.Windows.Forms, System.Drawing;

type
  MainForm = class(System.Windows.Forms.Form)
  {$REGION Windows Form Designer generated fields}
  private
    btn_Add: System.Windows.Forms.Button;
    method btn_Add_Click(sender: System.Object; e: System.EventArgs);
    ed_Text: System.Windows.Forms.TextBox;
    lb_List: System.Windows.Forms.ListBox;
    var components: System.ComponentModel.Container := nil;
    method InitializeComponent;
  {$ENDREGION}
  protected
    method Dispose(aDisposing: boolean); override;
  public
    constructor;
    class method Main;
  end;

implementation

{$REGION Construction and Disposal}
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
  self.btn_Add := new System.Windows.Forms.Button();
  self.ed_Text := new System.Windows.Forms.TextBox();
  self.lb_List := new System.Windows.Forms.ListBox();
  self.SuspendLayout();
  // 
  // btn_Add
  // 
  self.btn_Add.Location := new System.Drawing.Point(208, 8);
  self.btn_Add.Name := 'btn_Add';
  self.btn_Add.Size := new System.Drawing.Size(75, 23);
  self.btn_Add.TabIndex := 0;
  self.btn_Add.Text := '&Add';
  self.btn_Add.Click += new System.EventHandler(@self.btn_Add_Click);
  // 
  // ed_Text
  // 
  self.ed_Text.Location := new System.Drawing.Point(8, 10);
  self.ed_Text.Name := 'ed_Text';
  self.ed_Text.Size := new System.Drawing.Size(192, 20);
  self.ed_Text.TabIndex := 1;
  self.ed_Text.Text := 'Oxygene Bubbles';
  // 
  // lb_List
  // 
  self.lb_List.Location := new System.Drawing.Point(8, 40);
  self.lb_List.Name := 'lb_List';
  self.lb_List.Size := new System.Drawing.Size(275, 251);
  self.lb_List.TabIndex := 2;
  // 
  // MainForm
  // 
  self.AutoScaleBaseSize := new System.Drawing.Size(5, 13);
  self.ClientSize := new System.Drawing.Size(292, 300);
  self.Controls.Add(self.lb_List);
  self.Controls.Add(self.ed_Text);
  self.Controls.Add(self.btn_Add);
  self.FormBorderStyle := System.Windows.Forms.FormBorderStyle.FixedDialog;
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.MaximizeBox := false;
  self.Name := 'MainForm';
  self.Text := 'That Famous List Sample';
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

{$REGION Application Entry Point}
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

method MainForm.btn_Add_Click(sender: System.Object; e: System.EventArgs);
begin
  lb_List.Items.Add(ed_Text.Text);
end;

end.
