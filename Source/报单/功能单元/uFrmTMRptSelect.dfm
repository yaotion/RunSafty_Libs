object frmTMRptSelect: TfrmTMRptSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35831#36873#25321#21496#26426#25253#21333#27169#29256
  ClientHeight = 300
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 29
    Width = 124
    Height = 13
    Caption = #26412#22320#21496#26426#25253#21333#27169#29256#21015#34920':'
  end
  object btnOK: TButton
    Left = 218
    Top = 256
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 299
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object lstboxModules: TListBox
    Left = 27
    Top = 53
    Width = 347
    Height = 193
    ItemHeight = 13
    TabOrder = 2
  end
  object checkRemeber: TCheckBox
    Left = 27
    Top = 260
    Width = 150
    Height = 17
    Caption = #35760#20303#36873#25321','#19981#20877#25552#31034'.'
    TabOrder = 3
  end
end
