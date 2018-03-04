object frmMealTicketQuery: TfrmMealTicketQuery
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #39277#31080#26597#35810
  ClientHeight = 430
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 695
    Height = 51
    Align = alTop
    BorderOuter = fsFlat
    BorderHighlight = clWhite
    BorderShadow = 13290186
    Color = clWhite
    FlatColor = 7960953
    FlatColorAdjustment = 0
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 17
      Width = 28
      Height = 13
      Caption = #24037#21495':'
    end
    object btnQuery: TSpeedButton
      Left = 193
      Top = 13
      Width = 49
      Height = 22
      Caption = #26597#35810
      OnClick = btnQueryClick
    end
    object edtNumber: TRzEdit
      Left = 66
      Top = 14
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 411
    Width = 695
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
  end
  object RzListView1: TRzListView
    Left = 0
    Top = 51
    Width = 695
    Height = 360
    Align = alClient
    Columns = <
      item
        Caption = #24037#21495
        Width = 80
      end
      item
        Caption = #22995#21517
        Width = 80
      end
      item
        Caption = #36710#38388
        Width = 100
      end
      item
        Caption = #26089#39184
      end
      item
        Caption = #21320#39184
      end
      item
        Caption = #26202#39184
      end
      item
        Caption = #36710#27425
        Width = 100
      end
      item
        Caption = #20986#21220#26102#38388
        Width = 164
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    Left = 200
    Top = 224
  end
end
