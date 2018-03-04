object FrmGoodsRangeView: TFrmGoodsRangeView
  Left = 0
  Top = 0
  Caption = #29289#21697#32534#21495#31649#29702' :  '
  ClientHeight = 186
  ClientWidth = 290
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
    Left = 51
    Top = 25
    Width = 52
    Height = 13
    Caption = #29289#21697#31181#31867':'
  end
  object Label2: TLabel
    Left = 51
    Top = 61
    Width = 52
    Height = 13
    Caption = #24320#22987#32534#21495':'
  end
  object Label3: TLabel
    Left = 51
    Top = 96
    Width = 52
    Height = 13
    Caption = #25130#27490#32534#21495':'
  end
  object Bevel1: TBevel
    Left = 51
    Top = 136
    Width = 190
    Height = 2
  end
  object cmbGoodsType: TRzComboBox
    Left = 120
    Top = 22
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object edtStartCode: TEdit
    Left = 120
    Top = 61
    Width = 121
    Height = 21
    TabOrder = 1
    OnKeyPress = edtStartCodeKeyPress
  end
  object edtEndCode: TEdit
    Left = 120
    Top = 93
    Width = 121
    Height = 21
    TabOrder = 2
    OnKeyPress = edtEndCodeKeyPress
  end
  object btnSave: TButton
    Left = 80
    Top = 144
    Width = 75
    Height = 25
    Caption = #20445#23384
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 166
    Top = 144
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 4
    OnClick = btnCancelClick
  end
end
