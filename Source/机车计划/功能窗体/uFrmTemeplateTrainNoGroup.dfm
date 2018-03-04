object FrmTemeplateTrainNoGroup: TFrmTemeplateTrainNoGroup
  Left = 0
  Top = 0
  Caption = #21306#27573#20449#24687
  ClientHeight = 331
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object btnOk: TButton
    Left = 254
    Top = 280
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 358
    Top = 280
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object grpQuDuan: TGroupBox
    Left = 8
    Top = 8
    Width = 425
    Height = 257
    Caption = #21306#27573#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 40
      Width = 72
      Height = 16
      Caption = #26426#36710#35745#21010':'
    end
    object Label2: TLabel
      Left = 32
      Top = 93
      Width = 72
      Height = 16
      Caption = #21306#27573#21517#23383':'
    end
    object lbDayPlan: TLabel
      Left = 136
      Top = 40
      Width = 16
      Height = 16
      Caption = '[]'
    end
    object Label3: TLabel
      Left = 32
      Top = 165
      Width = 80
      Height = 16
      Caption = 'EXCEL'#20301#32622':'
    end
    object Label4: TLabel
      Left = 32
      Top = 203
      Width = 80
      Height = 16
      Caption = 'EXCEL'#24207#21495':'
    end
    object Label5: TLabel
      Left = 327
      Top = 165
      Width = 88
      Height = 16
      Caption = '('#24038#36793'/'#21491#36793')'
    end
    object Label6: TLabel
      Left = 32
      Top = 125
      Width = 72
      Height = 16
      Caption = #26159#21542#25171#28201':'
    end
    object edtQuDuanName: TEdit
      Left = 136
      Top = 90
      Width = 185
      Height = 24
      TabOrder = 0
    end
    object cmbExcelSide: TRzComboBox
      Left = 136
      Top = 165
      Width = 185
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      Items.Strings = (
        #24038#20391
        #21491#20391)
    end
    object cmbDaWen: TRzComboBox
      Left = 136
      Top = 125
      Width = 185
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
      Items.Strings = (
        #21542
        #26159)
    end
  end
  object edtExcelPos: TEdit
    Left = 144
    Top = 208
    Width = 185
    Height = 24
    TabOrder = 3
  end
end
