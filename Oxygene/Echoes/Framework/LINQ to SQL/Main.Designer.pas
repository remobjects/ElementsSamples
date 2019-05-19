namespace WindowsApplication2;

interface

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.Container := nil;
    method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
var
  resources: System.Resources.ResourceManager := new System.Resources.ResourceManager(typeof(MainForm));
begin
  //
  // MainForm
  //
  self.ClientSize := new System.Drawing.Size(292, 273);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.Text := 'New Oxygene Windows Forms App';
end;
{$ENDREGION}

end.