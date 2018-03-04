object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = #26085#24535#27983#35272
  ClientHeight = 553
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 534
    Width = 737
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 0
    object RzStatusPane: TRzStatusPane
      Left = 0
      Top = 0
      Width = 265
      Height = 19
      Align = alLeft
    end
    object RzProgressStatus: TRzProgressStatus
      Left = 265
      Top = 0
      Width = 472
      Height = 19
      Align = alClient
      ParentShowHint = False
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
      ExplicitLeft = 737
      ExplicitWidth = 100
      ExplicitHeight = 20
    end
  end
  object MainMenu1: TMainMenu
    Left = 352
    Top = 24
    object N1: TMenuItem
      Caption = '&File'
      object N3: TMenuItem
        Caption = '&Open...'
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = '&Exit'
        OnClick = N2Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object miFind: TMenuItem
        Caption = '&Find...'
        ShortCut = 16454
        OnClick = miFindClick
      end
      object miGoto: TMenuItem
        Caption = '&Goto...'
        ShortCut = 16455
        OnClick = miGotoClick
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      object Cascade1: TMenuItem
        Caption = '&Cascade'
        OnClick = Cascade1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object LogListener1: TMenuItem
        Caption = 'LogListener'
        OnClick = LogListener1Click
      end
    end
    object Option1: TMenuItem
      Caption = '&Option'
      object Config1: TMenuItem
        Caption = '&Config...'
        OnClick = Config1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.log|*.log|*.*|*.*'
    Left = 488
    Top = 40
  end
  object RzFrameController1: TRzFrameController
    FrameVisible = True
    Left = 392
    Top = 32
  end
end
