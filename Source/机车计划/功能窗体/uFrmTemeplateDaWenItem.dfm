object FrmTemeplateDaWenItem: TFrmTemeplateDaWenItem
  Left = 0
  Top = 0
  Caption = #25171#28201#26426#36710#20449#24687
  ClientHeight = 328
  ClientWidth = 396
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
  object btnOk: TButton
    Left = 166
    Top = 277
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 274
    Top = 277
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 396
    Height = 271
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 24
      Top = 24
      Width = 325
      Height = 233
      Caption = #36710#27425#20449#24687
      TabOrder = 0
      object Label1: TLabel
        Left = 32
        Top = 59
        Width = 36
        Height = 13
        Caption = #21306#27573#65306
      end
      object lbDayPlanGroup: TLabel
        Left = 96
        Top = 59
        Width = 8
        Height = 13
        Caption = '[]'
      end
      object Label2: TLabel
        Left = 32
        Top = 96
        Width = 36
        Height = 13
        Caption = #36710#22411#65306
      end
      object Label3: TLabel
        Left = 32
        Top = 129
        Width = 42
        Height = 13
        Caption = #36710#21495'1'#65306
      end
      object Label5: TLabel
        Left = 32
        Top = 27
        Width = 36
        Height = 13
        Caption = #35745#21010#65306
      end
      object lbDayPlan: TLabel
        Left = 96
        Top = 27
        Width = 8
        Height = 13
        Caption = '[]'
      end
      object Label6: TLabel
        Left = 33
        Top = 165
        Width = 42
        Height = 13
        Caption = #36710#21495'2'#65306
      end
      object Label4: TLabel
        Left = 32
        Top = 201
        Width = 42
        Height = 13
        Caption = #36710#21495'3'#65306
      end
      object edtCheHao1: TEdit
        Left = 96
        Top = 129
        Width = 185
        Height = 21
        TabOrder = 1
      end
      object edtCheXing: TEdit
        Left = 96
        Top = 93
        Width = 185
        Height = 21
        TabOrder = 0
      end
      object edtCheHao2: TEdit
        Left = 96
        Top = 163
        Width = 185
        Height = 21
        TabOrder = 2
      end
      object edtCheHao3: TEdit
        Left = 96
        Top = 199
        Width = 185
        Height = 21
        TabOrder = 3
      end
    end
  end
end
