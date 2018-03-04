object frmRsAPITrainman: TfrmRsAPITrainman
  Left = 0
  Top = 0
  Caption = #20154#21592#31649#29702'WebAPI'
  ClientHeight = 499
  ClientWidth = 902
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
  object PageControl1: TPageControl
    Left = 0
    Top = 46
    Width = 902
    Height = 453
    ActivePage = tabUI
    Align = alClient
    TabOrder = 0
    object tabAPI: TTabSheet
      Caption = #20154#21592#31649#29702'API'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 894
        Height = 425
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object memoResponse: TMemo
          Left = 0
          Top = 33
          Width = 894
          Height = 392
          Align = alClient
          TabOrder = 0
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 894
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          object btnRequest: TButton
            Left = 14
            Top = 2
            Width = 99
            Height = 25
            Caption = #33719#21462#20154#21592#21015#34920
            TabOrder = 0
            OnClick = btnRequestClick
          end
        end
      end
    end
    object tabUI: TTabSheet
      Caption = #20154#21592#31649#29702#31867#24211
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 41
        Width = 894
        Height = 384
        Align = alClient
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 894
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Button1: TButton
          Left = 12
          Top = 10
          Width = 101
          Height = 25
          Caption = #20154#21592#36755#20837#31383#21475
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 143
          Top = 10
          Width = 101
          Height = 25
          Caption = #25351#32441#39564#35777#31383#21475
          TabOrder = 1
          OnClick = Button2Click
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 902
    Height = 46
    Align = alTop
    BevelOuter = bvNone
    Caption = #20154#21592#31649#29702'API'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Host:'
    end
    object Label2: TLabel
      Left = 224
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object Label3: TLabel
      Left = 352
      Top = 16
      Width = 48
      Height = 13
      Caption = 'OffsetUrl:'
    end
    object edtHost: TEdit
      Left = 56
      Top = 13
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '192.168.1.166'
    end
    object edtPort: TEdit
      Left = 254
      Top = 13
      Width = 67
      Height = 21
      TabOrder = 1
      Text = '12304'
    end
    object edtOffsetUrl: TEdit
      Left = 406
      Top = 13
      Width = 211
      Height = 21
      TabOrder = 2
      Text = '/AshxService/QueryProcess.ashx'
    end
  end
end
