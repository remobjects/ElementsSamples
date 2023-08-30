using Winapi.Windows;
using Winapi.Messages;
using System.SysUtils;
using System.Variants;
using System.Classes;
using Vcl.Graphics;
using Vcl.Controls;
using Vcl.Forms;
using Vcl.Dialogs;
using Vcl.StdCtrls;
using System.RegularExpressions;

namespace RegExpression
{
    public class TForm1 : TForm
    {
        __published TEdit EditText;
        __published TButton Button1;
        __published TLabel lbType;
        __published TLabel Label1;
        __published TListBox lbRegExp;
        __published TMemo MemoRegEx;

        __published void Button1Click(TObject Sender)
        {
            if (TRegEx.IsMatch(EditText.Text, MemoRegEx.Lines.Text))
                ShowMessage("Text DOES match the regular expression");
            else
                ShowMessage("Text DOES NOT match the regular expression");
        }

        __published void lbRegExpClick(TObject Sender)
        {
            lbRegExp.ItemIndex = 0;
            lbRegExpClick(lbRegExp);
        }

        __published void FormCreate(TObject Sender)
        {
            switch (lbRegExp.ItemIndex)
            {
                case 0:
                {
                    lbType.Caption = "Email for validation";
                    MemoRegEx.Lines.Text = "^((?>[a-zA-Z\\d!#$%&'*+\\-/=?^_`{|}~]+\\x20*" +
                                           "|\"((?=[\\x01-\\x7f])[^\"\\\\]|\\\\[\\x01-\\x7f])*\"\\" +
                                           "x20*)*(?<angle><))?((?!\\.)(?>\\.?[a-zA-Z\\d!" +
                                           "#$%&'*+\\-/=?^_`{|}~]+)+|\"((?=[\\x01-\\x7f])" +
                                           "[^\"\\\\]|\\\\[\\x01-\\x7f])*\")@(((?!-)[a-zA-Z\\d\\" +
                                           "-]+(?<!-)\\.)+[a-zA-Z]{2,}|\\[(((?(?<!\\[)\\.)" +
                                           "(25[0-5]|2[0-4]\\d|[01]?\\d?\\d)){4}|[a-zA-Z\\" +
                                           "d\\-]*[a-zA-Z\\d]:((?=[\\x01-\\x7f])[^\\\\\\[\\]]|" +
                                           "\\\\[\\x01-\\x7f])+)\\])(?(angle)>)$";
                }
                case 1:
                {
                    // Accept IP address between 0..255
                    lbType.Caption = "IP address for validation (0..255)";
                    MemoRegEx.Lines.Text = "\\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\" +
                                           ".(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                                           "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
                                           "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
                }
                case 2:
                {
                    // Data interval format mm-dd-yyyy
                    lbType.Caption = "Date in mm-dd-yyyy format from between 01-01-1900 and 12-31-2099";
                    MemoRegEx.Lines.Text = "^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[" +
                                           "01])[- /.](19|20)\\d\\d$";
                }
                case 3:
                {
                    // Data interval format mm-dd-yyyy
                    lbType.Caption = "Date in dd-mm-yyyy format from between 01-01-1900 and 31-12-2099";
                    MemoRegEx.Lines.Text = "^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[01" +
                                           "2])[- /.](19|20)\\d\\d$";
                }
            }
        }
    }

    public TForm1 Form1;
}