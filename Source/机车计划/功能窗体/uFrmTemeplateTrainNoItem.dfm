object FrmTemeplateTrainNoItem: TFrmTemeplateTrainNoItem
  Left = 0
  Top = 0
  Caption = #36710#27425#35814#32454#20449#24687
  ClientHeight = 421
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 198
    Top = 375
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 306
    Top = 375
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 369
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 24
      Top = 24
      Width = 353
      Height = 329
      Caption = #36710#27425#20449#24687
      TabOrder = 0
      object Label1: TLabel
        Left = 32
        Top = 59
        Width = 39
        Height = 13
        Caption = #21306#27573#65306
      end
      object lbDayPlanGroup: TLabel
        Left = 96
        Top = 59
        Width = 14
        Height = 13
        Caption = '[]'
      end
      object Label2: TLabel
        Left = 32
        Top = 96
        Width = 46
        Height = 13
        Caption = #36710#27425'1'#65306
      end
      object Label3: TLabel
        Left = 32
        Top = 129
        Width = 46
        Height = 13
        Caption = #36710#27425'2'#65306
      end
      object Label4: TLabel
        Left = 32
        Top = 204
        Width = 39
        Height = 13
        Caption = #22791#27880#65306
      end
      object Label5: TLabel
        Left = 32
        Top = 27
        Width = 39
        Height = 13
        Caption = #35745#21010#65306
      end
      object lbDayPlan: TLabel
        Left = 96
        Top = 27
        Width = 14
        Height = 13
        Caption = '[]'
      end
      object Label6: TLabel
        Left = 32
        Top = 164
        Width = 39
        Height = 13
        Caption = #36710#27425#65306
      end
      object Label7: TLabel
        Left = 287
        Top = 164
        Width = 53
        Height = 13
        Caption = '('#27966#29677#29992')'
      end
      object edtCheCi2: TEdit
        Left = 96
        Top = 129
        Width = 185
        Height = 21
        TabOrder = 1
        OnExit = edtCheCi2Exit
      end
      object edtCheCi1: TEdit
        Left = 96
        Top = 93
        Width = 185
        Height = 21
        TabOrder = 0
      end
      object mmoRemark: TMemo
        Left = 96
        Top = 201
        Width = 185
        Height = 63
        TabOrder = 3
      end
      object chkIsTomorrow: TCheckBox
        Left = 96
        Top = 280
        Width = 97
        Height = 17
        Caption = #26159#21542#27425#26085#36710#27425
        TabOrder = 4
      end
      object edtCheCi: TEdit
        Left = 96
        Top = 159
        Width = 185
        Height = 21
        TabOrder = 2
      end
    end
  end
end
