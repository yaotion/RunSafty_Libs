object NoFocusBox: TNoFocusBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #25552#31034#20449#24687
  ClientHeight = 131
  ClientWidth = 576
  Color = 15197152
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  DesignSize = (
    576
    131)
  PixelsPerInch = 96
  TextHeight = 16
  object RzBorder1: TRzBorder
    AlignWithMargins = True
    Left = 1
    Top = 1
    Width = 574
    Height = 129
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    BorderHighlight = clWhite
    BorderShadow = 9539985
    BorderOuter = fsFlat
    FlatColorAdjustment = 0
    FrameController = RzFrameController1
    Align = alClient
    ExplicitLeft = -4
    ExplicitTop = -4
    ExplicitWidth = 572
    ExplicitHeight = 168
  end
  object lblMsg1: TLabel
    Left = 8
    Top = 107
    Width = 68
    Height = 16
    Caption = #23383#20307#27169#26495
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
    Visible = False
  end
  object lblClose: TLabel
    Left = 540
    Top = 6
    Width = 28
    Height = 14
    Anchors = [akTop, akRight]
    Caption = #20851#38381
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = lblCloseClick
    OnMouseEnter = lblCloseMouseEnter
    OnMouseLeave = lblCloseMouseLeave
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 536
    Top = 32
  end
  object RzFrameController1: TRzFrameController
    FrameVisible = True
    Left = 536
    Top = 64
  end
end
