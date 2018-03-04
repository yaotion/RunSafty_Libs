object FrmSelectDutyPlace: TFrmSelectDutyPlace
  Left = 0
  Top = 0
  Caption = #36873#25321#20986#21220#28857
  ClientHeight = 121
  ClientWidth = 276
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
    Top = 35
    Width = 36
    Height = 13
    Caption = #20986#21220#28857
  end
  object cmbDutyPlace: TRzComboBox
    Left = 88
    Top = 32
    Width = 156
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 88
    Top = 80
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 169
    Top = 80
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
