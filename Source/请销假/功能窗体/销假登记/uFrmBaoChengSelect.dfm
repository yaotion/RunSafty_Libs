object FrmBaoChengSelect: TFrmBaoChengSelect
  Left = 0
  Top = 0
  Caption = #21253#20056#26426#36710#36873#25321
  ClientHeight = 134
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 52
    Height = 13
    Caption = #21253#25104#26426#36710':'
  end
  object btnOk: TButton
    Left = 120
    Top = 80
    Width = 65
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 80
    Width = 65
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object cmbBaoCheng: TRzComboBox
    Left = 104
    Top = 34
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
  end
end
