object FrmMealTicketConfig: TFrmMealTicketConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #39277#31080#35774#32622
  ClientHeight = 214
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 160
    Top = 175
    Width = 73
    Height = 25
    Caption = #20445#23384
    Default = True
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 245
    Top = 175
    Width = 73
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object RzPageControl1: TRzPageControl
    Left = 8
    Top = 8
    Width = 313
    Height = 161
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    FixedDimension = 19
    object TabSheet1: TRzTabSheet
      Caption = #26087#39277#31080#31995#32479
      object Label1: TLabel
        Left = 24
        Top = 21
        Width = 46
        Height = 26
        Caption = #26381#21153#22120':'#13#10
      end
      object Label2: TLabel
        Left = 24
        Top = 75
        Width = 46
        Height = 13
        Caption = #29992#25143#21517':'
      end
      object Label3: TLabel
        Left = 24
        Top = 102
        Width = 33
        Height = 13
        Caption = #23494#30721':'
      end
      object Label4: TLabel
        Left = 24
        Top = 48
        Width = 46
        Height = 13
        Caption = #25968#25454#28304':'
      end
      object edtServerIP: TRzEdit
        Left = 76
        Top = 18
        Width = 205
        Height = 21
        FrameVisible = True
        TabOrder = 0
      end
      object edtLocation: TRzEdit
        Left = 76
        Top = 45
        Width = 205
        Height = 21
        FrameVisible = True
        TabOrder = 1
      end
      object edtUser: TRzEdit
        Left = 76
        Top = 72
        Width = 205
        Height = 21
        FrameVisible = True
        TabOrder = 2
      end
      object edtPass: TRzEdit
        Left = 76
        Top = 99
        Width = 205
        Height = 21
        FrameVisible = True
        TabOrder = 3
      end
    end
    object TabSheet2: TRzTabSheet
      Caption = #26032#39277#31080#31995#32479
      object Label5: TLabel
        Left = 16
        Top = 19
        Width = 59
        Height = 13
        Caption = #25509#21475#22320#22336':'
      end
      object Label6: TLabel
        Left = 16
        Top = 46
        Width = 59
        Height = 13
        Caption = #25509#21475#31471#21475':'
      end
      object Label7: TLabel
        Left = 16
        Top = 73
        Width = 47
        Height = 13
        Caption = #22320#28857'ID:'
      end
      object Label8: TLabel
        Left = 16
        Top = 100
        Width = 59
        Height = 13
        Caption = #22320#28857#21517#31216':'
      end
      object edtTFHost: TRzEdit
        Left = 81
        Top = 16
        Width = 200
        Height = 21
        FrameVisible = True
        TabOrder = 0
      end
      object edtTFPort: TRzEdit
        Left = 81
        Top = 43
        Width = 200
        Height = 21
        FrameVisible = True
        TabOrder = 1
      end
      object edtPlaceID: TRzEdit
        Left = 81
        Top = 70
        Width = 200
        Height = 21
        FrameVisible = True
        TabOrder = 2
      end
      object edtPlaceName: TRzEdit
        Left = 81
        Top = 97
        Width = 200
        Height = 21
        FrameVisible = True
        TabOrder = 3
      end
    end
  end
end
