object FrmTicketCountInput: TFrmTicketCountInput
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #39277#31080#24352#25968
  ClientHeight = 102
  ClientWidth = 223
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
  object Bevel1: TBevel
    Left = 8
    Top = 62
    Width = 209
    Height = 2
  end
  object Label1: TLabel
    Left = 26
    Top = 11
    Width = 40
    Height = 13
    Caption = #26089#39184#21048':'
  end
  object Label2: TLabel
    Left = 26
    Top = 38
    Width = 40
    Height = 13
    Caption = #27491#39184#21048':'
  end
  object edtA: TRzEdit
    Left = 72
    Top = 8
    Width = 121
    Height = 21
    Text = '0'
    FrameVisible = True
    TabOrder = 0
    OnKeyPress = edtAKeyPress
  end
  object edtB: TRzEdit
    Left = 72
    Top = 35
    Width = 121
    Height = 21
    Text = '3'
    FrameVisible = True
    TabOrder = 1
    OnKeyPress = edtAKeyPress
  end
  object Button1: TButton
    Left = 37
    Top = 69
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 118
    Top = 69
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
    OnClick = Button2Click
  end
end
