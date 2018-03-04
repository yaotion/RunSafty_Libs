object DateTimeInput: TDateTimeInput
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26102#38388#36755#20837
  ClientHeight = 79
  ClientWidth = 217
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
    Top = 35
    Width = 202
    Height = 2
  end
  object btnOk: TButton
    Left = 52
    Top = 43
    Width = 75
    Height = 25
    Caption = #30830#35748
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 133
    Top = 43
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 3
  end
  object dtDate: TRzDateTimePicker
    Left = 8
    Top = 8
    Width = 97
    Height = 21
    Date = 42699.359525474540000000
    Time = 42699.359525474540000000
    TabOrder = 0
    FrameVisible = True
  end
  object dtTime: TRzDateTimePicker
    Left = 111
    Top = 8
    Width = 97
    Height = 21
    Date = 42699.359525474540000000
    Time = 42699.359525474540000000
    Kind = dtkTime
    TabOrder = 1
    FrameVisible = True
  end
end
