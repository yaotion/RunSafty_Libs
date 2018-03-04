object FrmAddJiChe: TFrmAddJiChe
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #26426#36710#20449#24687
  ClientHeight = 128
  ClientWidth = 262
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 80
    Height = 16
    Caption = #26426#36710#31867#22411#65306
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 64
    Height = 16
    Caption = #26426#36710#21495#65306
  end
  object Bevel1: TBevel
    Left = 8
    Top = 81
    Width = 249
    Height = 2
  end
  object edtTrainNumber: TRzEdit
    Left = 81
    Top = 51
    Width = 156
    Height = 24
    FrameVisible = True
    TabOrder = 0
  end
  object ComboTrainType: TRzComboBox
    Left = 81
    Top = 21
    Width = 156
    Height = 24
    Ctl3D = False
    FrameVisible = True
    ItemHeight = 16
    ParentCtl3D = False
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 81
    Top = 89
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 162
    Top = 89
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 240
    Top = 16
  end
end
