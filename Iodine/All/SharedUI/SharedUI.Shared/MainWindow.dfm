object MainWindow: MainWindow
  Left = 0
  Top = 0
  Caption = 'Shared UI'
  ClientHeight = 236
  ClientWidth = 420
  Position = poScreenCenter
  object ExplanationLabel: TLabel
    Left = 20
    Top = 16
    Width = 380
    Height = 17
    Caption = 'Add two numbers, or join two pieces of text.'
  end
  object ValueALabel: TLabel
    Left = 20
    Top = 48
    Width = 90
    Height = 17
    Caption = 'Value A'
  end
  object ValueAEdit: TEdit
    Left = 120
    Top = 44
    Width = 280
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = ValueAChanged
  end
  object ValueBLabel: TLabel
    Left = 20
    Top = 88
    Width = 90
    Height = 17
    Caption = 'Value B'
  end
  object ValueBEdit: TEdit
    Left = 120
    Top = 84
    Width = 280
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    OnChange = ValueBChanged
  end
  object CalculateButton: TButton
    Left = 120
    Top = 128
    Width = 160
    Height = 32
    Caption = 'Calculate'
    Default = True
    TabOrder = 2
    OnClick = CalculateClick
  end
  object ResultLabel: TLabel
    Left = 20
    Top = 184
    Width = 380
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'N/A'
    WordWrap = True
  end
end
