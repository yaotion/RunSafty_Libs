object FrmTicketModify: TFrmTicketModify
  Left = 0
  Top = 0
  Caption = #39277#31080#20462#25913
  ClientHeight = 149
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 24
    Width = 28
    Height = 13
    Caption = #26089#39184':'
  end
  object Label2: TLabel
    Left = 40
    Top = 64
    Width = 28
    Height = 13
    Caption = #27491#39184':'
  end
  object edtBreakFast: TEdit
    Left = 96
    Top = 21
    Width = 129
    Height = 21
    TabOrder = 0
  end
  object edtDinner: TEdit
    Left = 96
    Top = 61
    Width = 129
    Height = 21
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 96
    Top = 104
    Width = 65
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 167
    Top = 104
    Width = 65
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
