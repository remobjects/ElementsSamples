﻿namespace RegExpression;

interface

uses
	System.SysUtils,
	System.Types,
	System.UITypes,
	System.Classes,
	System.Variants,
	FMX.Types,
	FMX.Controls,
	FMX.Forms,
	FMX.Dialogs,
	FMX.Effects,
	FMX.Edit,
	FMX.Memo,
	FMX.ListBox,
	FMX.Layouts,
	System.RegularExpressions,
	FMX.StdCtrls,
	FMX.Controls.Presentation,
	FMX.ScrollBox,
	FMX.Memo.Types;

type
	TForm1 = class(TForm)
	published
		lbRegExp: TListBox;
		MemoRegEx: TMemo;
		EditText: TEdit;
		lbType: TLabel;
		SEResult: TShadowEffect;
		method FormCreate(Sender: TObject);
		method lbRegExpChange(Sender: TObject);
		method EditTextChangeTracking(Sender: TObject);
	end;

var
	Form1: TForm1;

implementation

method TForm1.EditTextChangeTracking(Sender: TObject);
begin
	if TRegEx.IsMatch(EditText.Text, MemoRegEx.Text) then
		SEResult.ShadowColor := TAlphaColors.Green
	else
		SEResult.ShadowColor := TAlphaColors.Palevioletred;
end;

method TForm1.FormCreate(Sender: TObject);
begin
	lbRegExpChange(lbRegExp);
end;

method TForm1.lbRegExpChange(Sender: TObject);
begin
	if not assigned(lbType) then
		exit;
	case lbRegExp.ItemIndex of
		0:
			begin
				lbType.Text := 'E-mail for validation';
				MemoRegEx.Text := '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
					'|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
					'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
					'#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
					'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
					'-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
					'(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
					'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
					'\\[\x01-\x7f])+)\])(?(angle)>)$';
			end;
		1:
			begin
				// Accept IP address between 0..255
				lbType.Text := 'IP address for validation (0..255)';
				MemoRegEx.Text := '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\' +
					'.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
					'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
					'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b';

			end;
		2:
			begin
				// Data interval format mm-dd-yyyy
				lbType.Text :=
					'Date in mm-dd-yyyy format from between 01-01-1900 and 12-31-2099';
				MemoRegEx.Text := '^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[' +
					'01])[- /.](19|20)\d\d$';

			end;
		3:
			begin
				// Data interval format mm-dd-yyyy
				lbType.Text :=
					'Date in dd-mm-yyyy format from between 01-01-1900 and 31-12-2099';
				MemoRegEx.Text := '^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[01' +
					'2])[- /.](19|20)\d\d$';

			end;
	end;
	EditTextChangeTracking(EditText);
end;

end.