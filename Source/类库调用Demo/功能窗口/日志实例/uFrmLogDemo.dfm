object frmLogDemo: TfrmLogDemo
  Left = 0
  Top = 0
  Caption = #26085#24535#35843#29992#23454#20363
  ClientHeight = 501
  ClientWidth = 1172
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1172
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 13
      Width = 60
      Height = 13
      Caption = #26085#24535#20869#23481#65306
    end
    object btnMessage: TButton
      Left = 539
      Top = 6
      Width = 75
      Height = 25
      Caption = #28040#24687
      TabOrder = 0
      OnClick = btnMessageClick
    end
    object btnDebug: TButton
      Left = 620
      Top = 6
      Width = 75
      Height = 25
      Caption = #35843#35797
      TabOrder = 1
      OnClick = btnDebugClick
    end
    object btnError: TButton
      Left = 701
      Top = 6
      Width = 75
      Height = 25
      Caption = #38169#35823
      TabOrder = 2
      OnClick = btnErrorClick
    end
    object btnConfig: TButton
      Left = 782
      Top = 6
      Width = 75
      Height = 25
      Caption = #37197#32622
      TabOrder = 3
      OnClick = btnConfigClick
    end
    object edtMsg: TEdit
      Left = 72
      Top = 9
      Width = 461
      Height = 21
      TabOrder = 4
      Text = #36825#26159#19968#26465#26085#24535#20449#24687
    end
  end
  object memoLog: TMemo
    Left = 0
    Top = 37
    Width = 1172
    Height = 228
    Align = alTop
    TabOrder = 1
  end
  object pLogParent: TPanel
    Left = 0
    Top = 265
    Width = 1172
    Height = 236
    Align = alClient
    Caption = 'pLogParent'
    TabOrder = 2
  end
  object btnShowConfig: TButton
    Left = 863
    Top = 6
    Width = 75
    Height = 25
    Caption = #24377#20986#37197#32622
    TabOrder = 3
    OnClick = btnShowConfigClick
  end
end
