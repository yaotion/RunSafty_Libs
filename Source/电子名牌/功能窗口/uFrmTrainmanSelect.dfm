object FrmTrainmanSelect: TFrmTrainmanSelect
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #20154#21592#36873#25321
  ClientHeight = 262
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbGroup: TLabel
    Left = 24
    Top = 24
    Width = 216
    Height = 13
    Caption = #35831#36873#25321#19968#20010#21496#26426#20316#20026#26426#32452#30340#26368#36817#21040#36798#26102#38388
  end
  object btnOk: TButton
    Left = 149
    Top = 215
    Width = 73
    Height = 30
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 232
    Top = 215
    Width = 73
    Height = 30
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object lstSelTrainman: TCheckListBox
    Left = 24
    Top = 48
    Width = 281
    Height = 161
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ItemHeight = 16
    Items.Strings = (
      '1111'
      '2222'
      '3333')
    ParentFont = False
    TabOrder = 2
    OnClick = lstSelTrainmanClick
  end
end
