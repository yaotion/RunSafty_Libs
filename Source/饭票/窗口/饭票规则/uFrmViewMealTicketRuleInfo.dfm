object FrmViewMealTicketRuleInfo: TFrmViewMealTicketRuleInfo
  Left = 0
  Top = 0
  Caption = #36710#27425#20449#24687
  ClientHeight = 377
  ClientWidth = 689
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
  object lvRecord: TListView
    Left = 16
    Top = 16
    Width = 570
    Height = 297
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #34892#36710#21306#27573
        Width = 200
      end
      item
        Caption = #36710#27425
        Width = 100
      end
      item
        Caption = #36215#27490#26102#38388
        Width = 200
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnAdd: TButton
    Left = 592
    Top = 16
    Width = 73
    Height = 33
    Caption = #28155#21152
    TabOrder = 1
    OnClick = btnAddClick
  end
  object btnModify: TButton
    Left = 592
    Top = 72
    Width = 73
    Height = 33
    Caption = #20462#25913
    TabOrder = 2
    OnClick = btnModifyClick
  end
  object btnDel: TButton
    Left = 592
    Top = 128
    Width = 73
    Height = 33
    Caption = #21024#38500
    TabOrder = 3
    OnClick = btnDelClick
  end
  object btnLoadBreakfast: TButton
    Left = 144
    Top = 319
    Width = 105
    Height = 42
    Caption = #21152#36733#26089#19978#26102#38388
    TabOrder = 4
    OnClick = btnLoadBreakfastClick
  end
  object btnLoadNormal: TButton
    Left = 304
    Top = 319
    Width = 114
    Height = 42
    Caption = #21152#36733#27491#24120#26102#38388
    TabOrder = 5
    OnClick = btnLoadNormalClick
  end
  object btnLoadAll: TButton
    Left = 472
    Top = 319
    Width = 114
    Height = 42
    Caption = #21152#36733#20840#22825#26102#38388
    TabOrder = 6
    OnClick = btnLoadAllClick
  end
end
