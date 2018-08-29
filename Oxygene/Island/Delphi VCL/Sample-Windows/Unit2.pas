namespace Sample;

interface

uses
  RemObjects.Elements.RTL.Delphi, 
  RemObjects.Elements.RTL.Delphi.VCL;

type
  TForm2 = public class(TForm)
  public
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    Button2: TButton;
    Button3: TButton;
    Edit2: TEdit;
    ListBox1: TListBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

procedure TForm2.Button1Click(Sender: TObject);
begin
  Label1.Caption := Edit1.Text;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  ShowMessage('Hi there!');
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  ListBox1.Items.Add(Edit2.Text);
end;

end.