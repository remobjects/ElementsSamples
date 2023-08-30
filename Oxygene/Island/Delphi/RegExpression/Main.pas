namespace RegExpression;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  System.RegularExpressions;

type
  TForm1 = class(TForm)
  published
    EditText: TEdit;
    Button1: TButton;
    lbType: TLabel;
    Label1: TLabel;
    lbRegExp: TListBox;
    MemoRegEx: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure lbRegExpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

procedure TForm1.Button1Click(Sender: TObject);
begin
  if TRegEx.IsMatch(EditText.Text, MemoRegEx.Lines.Text) then
    ShowMessage('Text DOES match the regular expression')
  else
    ShowMessage('Text DOES NOT match the regular expression');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  lbRegExp.ItemIndex := 0;
  lbRegExpClick(lbRegExp);
end;

procedure TForm1.lbRegExpClick(Sender: TObject);
begin
  case lbRegExp.ItemIndex of
    0: begin
        lbType.Caption := 'Email for validation';
        MemoRegEx.Lines.Text := '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
          '|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
          'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
          '#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
          '[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
          '-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
          '(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
          'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
          '\\[\x01-\x7f])+)\])(?(angle)>)$';
      end;
    1: begin
        // Accept IP address between 0..255
        lbType.Caption := 'IP address for validation (0..255)';
        MemoRegEx.Lines.Text := '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\' +
          '.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
          '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
          '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';
      end;
    2: begin
        // Data interval format mm-dd-yyyy
        lbType.Caption :=
          'Date in mm-dd-yyyy format from between 01-01-1900 and 12-31-2099';
        MemoRegEx.Lines.Text := '^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[' +
          '01])[- /.](19|20)\d\d$';
      end;
    3: begin
        // Data interval format mm-dd-yyyy
        lbType.Caption :=
          'Date in dd-mm-yyyy format from between 01-01-1900 and 31-12-2099';
        MemoRegEx.Lines.Text := '^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[01' +
          '2])[- /.](19|20)\d\d$';
      end;
  end;
end;

end.