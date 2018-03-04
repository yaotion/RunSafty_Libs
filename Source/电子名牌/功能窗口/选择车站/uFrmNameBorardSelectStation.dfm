object FrmNameBorardSelectStation: TFrmNameBorardSelectStation
  Left = 0
  Top = 0
  Caption = #36873#25321#36710#31449
  ClientHeight = 267
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbGroup: TLabel
    Left = 24
    Top = 24
    Width = 84
    Height = 26
    Caption = #35831#36873#25321#19968#20010#36710#31449#13#10
  end
  object chklstSelStation: TCheckListBox
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
    TabOrder = 0
    OnClick = chklstSelStationClick
  end
  object btnOk: TButton
    Left = 149
    Top = 215
    Width = 73
    Height = 30
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 232
    Top = 215
    Width = 73
    Height = 30
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
