using System.SysUtils;
using System.Types;
using System.UITypes;
using System.Classes;
using System.Variants;
using FMX.Types;
using FMX.Controls;
using FMX.Forms;
using FMX.Dialogs;
using FMX.Effects;
using FMX.Edit;
using FMX.Memo;
using FMX.ListBox;
using FMX.Layouts;
using System.RegularExpressions;
using FMX.StdCtrls;
using FMX.Controls.Presentation;
using FMX.ScrollBox;
using FMX.Memo.Types;

namespace RegExpression
{
	public class TForm1 : TForm
	{
		__published TEdit EditText;
		__published TLabel lbType;
		__published TListBox lbRegExp;
		__published TShadowEffect SEResult;
		__published TMemo MemoRegEx;

		__published void EditTextChangeTracking(TObject Sender)
		{
			if (TRegEx.IsMatch(EditText.Text, MemoRegEx.Text))
				SEResult.ShadowColor = TAlphaColors.Green;
			else
				SEResult.ShadowColor = TAlphaColors.Palevioletred;
		}

		__published void FormCreate(TObject Sender)
		{
			lbRegExpChange(lbRegExp);
		}

		__published void lbRegExpChange(TObject Sender)
		{
			if (lbType == null)
				return;
			switch (lbRegExp.ItemIndex)
			{
				case 0:
				{
					lbType.Text = "Email for validation";
					MemoRegEx.Lines.Text = "^((?>[a-zA-Z\\d!#$%&'*+\\-/=?^_`{|}~]+\\x20*" +
										   "|\"((?=[\\x01-\\x7f])[^\"\\\\]|\\\\[\\x01-\\x7f])*\"\\" +
										   "x20*)*(?<angle><))?((?!\\.)(?>\\.?[a-zA-Z\\d!" +
										   "#$%&'*+\\-/=?^_`{|}~]+)+|\"((?=[\\x01-\\x7f])" +
										   "[^\"\\\\]|\\\\[\\x01-\\x7f])*\")@(((?!-)[a-zA-Z\\d\\" +
										   "-]+(?<!-)\\.)+[a-zA-Z]{2,}|\\[(((?(?<!\\[)\\.)" +
										   "(25[0-5]|2[0-4]\\d|[01]?\\d?\\d)){4}|[a-zA-Z\\" +
										   "d\\-]*[a-zA-Z\\d]:((?=[\\x01-\\x7f])[^\\\\\\[\\]]|" +
										   "\\\\[\\x01-\\x7f])+)\\])(?(angle)>)$";
					break;
				}
				case 1:
				{
					// Accept IP address between 0..255
					lbType.Text = "IP address for validation (0..255)";
					MemoRegEx.Lines.Text = "\\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\" +
										   ".(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
										   "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
										   "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
					break;
				}
				case 2:
				{
					// Data interval format mm-dd-yyyy
					lbType.Text = "Date in mm-dd-yyyy format from between 01-01-1900 and 12-31-2099";
					MemoRegEx.Lines.Text = "^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[" +
										   "01])[- /.](19|20)\\d\\d$";
					break;
				}
				case 3:
				{
					// Data interval format mm-dd-yyyy
					lbType.Text = "Date in dd-mm-yyyy format from between 01-01-1900 and 31-12-2099";
					MemoRegEx.Lines.Text = "^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[01" +
										   "2])[- /.](19|20)\\d\\d$";
					break;
				}
			}
			EditTextChangeTracking(EditText);
		}
	}

	public TForm1 Form1;
}