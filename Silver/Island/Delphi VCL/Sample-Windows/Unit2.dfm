object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Test'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 352
    Top = 37
    Width = 110
    Height = 13
    Caption = 'Sample Label'
  end
  object Button1: TButton
    Left = 64
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 192
    Top = 34
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Go go!'
  end
  object CheckBox1: TCheckBox
    Left = 64
    Top = 200
    Width = 97
    Height = 17
    Caption = 'A CheckBox'
    TabOrder = 2
  end
  object RadioButton1: TRadioButton
    Left = 167
    Top = 200
    Width = 113
    Height = 17
    Caption = 'A RadioButton'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 48
    Top = 152
    Width = 113
    Height = 25
    Caption = 'ShowMessage'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 64
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Add to list'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit2: TEdit
    Left = 192
    Top = 98
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'Item 1'
  end
  object ListBox1: TListBox
    Left = 352
    Top = 98
    Width = 193
    Height = 119
    ItemHeight = 13
    TabOrder = 7
  end
end