object frmMQDemo: TfrmMQDemo
  AlignWithMargins = True
  Left = 0
  Top = 0
  Margins.Left = 10
  Margins.Top = 10
  Margins.Right = 10
  Margins.Bottom = 10
  Caption = 'MQ'#36890#35759#23454#20363
  ClientHeight = 462
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel1: TRzPanel
    Left = 0
    Top = 421
    Width = 784
    Height = 41
    Align = alBottom
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    TabOrder = 0
    DesignSize = (
      784
      41)
    object Button2: TButton
      Left = 694
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #20851#38381
      TabOrder = 0
      OnClick = Button2Click
    end
    object btnSend: TButton
      Left = 613
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #21457#36865
      TabOrder = 1
      OnClick = btnSendClick
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 764
    Height = 411
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 764
      Height = 411
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #28040#24687
        object Label1: TLabel
          Left = 30
          Top = 10
          Width = 112
          Height = 13
          Caption = #35831#36755#20837#35201#21457#36865#30340#28040#24687':'
        end
        object memoRec: TMemo
          Left = 30
          Top = 61
          Width = 699
          Height = 312
          Color = 15395562
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object edtSend: TEdit
          Left = 30
          Top = 34
          Width = 699
          Height = 21
          TabOrder = 1
          Text = 'this is a test message'
        end
      end
      object TabSheet2: TTabSheet
        Caption = #35774#32622
        ImageIndex = 1
        object GroupBox1: TGroupBox
          Left = 24
          Top = 32
          Width = 377
          Height = 84
          Caption = #36830#25509#20449#24687
          TabOrder = 0
          object Label3: TLabel
            Left = 16
            Top = 26
            Width = 36
            Height = 13
            Caption = #22320#22336#65306
          end
          object Label4: TLabel
            Left = 165
            Top = 25
            Width = 36
            Height = 13
            Caption = #31471#21475#65306
          end
          object Label5: TLabel
            Left = 16
            Top = 56
            Width = 48
            Height = 13
            Caption = #29992#25143#21517#65306
          end
          object Label6: TLabel
            Left = 165
            Top = 56
            Width = 36
            Height = 13
            Caption = #23494#30721#65306
          end
          object btnOpen: TSpeedButton
            Left = 287
            Top = 21
            Width = 75
            Height = 25
            Caption = #25171#24320
            OnClick = btnOpenClick
          end
          object edtIP: TEdit
            Left = 65
            Top = 23
            Width = 80
            Height = 21
            TabOrder = 0
            Text = '192.168.1.166'
          end
          object edtPort: TEdit
            Left = 200
            Top = 22
            Width = 80
            Height = 21
            TabOrder = 1
            Text = '61613'
          end
          object edtUsername: TEdit
            Left = 65
            Top = 54
            Width = 80
            Height = 21
            TabOrder = 2
            Text = 'admin'
          end
          object edtPassword: TEdit
            Left = 200
            Top = 53
            Width = 80
            Height = 21
            TabOrder = 3
            Text = 'admin'
          end
        end
        object GroupBox2: TGroupBox
          Left = 24
          Top = 143
          Width = 377
          Height = 122
          Caption = #22522#30784#20449#24687
          TabOrder = 1
          object Label7: TLabel
            Left = 16
            Top = 61
            Width = 36
            Height = 13
            Caption = #38431#21015#65306
          end
          object Label8: TLabel
            Left = 145
            Top = 63
            Width = 16
            Height = 13
            Caption = '-->'
          end
          object Label10: TLabel
            Left = 16
            Top = 29
            Width = 36
            Height = 13
            Caption = #32534#21495#65306
          end
          object Label11: TLabel
            Left = 258
            Top = 30
            Width = 36
            Height = 13
            Caption = #27169#24335#65306
          end
          object Label9: TLabel
            Left = 16
            Top = 91
            Width = 36
            Height = 13
            Caption = #20027#39064#65306
          end
          object edtSendQueue: TEdit
            Left = 65
            Top = 59
            Width = 80
            Height = 21
            TabOrder = 0
            Text = 'TF_Site_Send'
          end
          object edtRecQueue: TEdit
            Left = 165
            Top = 60
            Width = 80
            Height = 21
            TabOrder = 1
            Text = 'TF_Rs_Send'
          end
          object edtClientID: TEdit
            Left = 65
            Top = 25
            Width = 80
            Height = 21
            TabOrder = 2
            Text = '90001'
          end
          object comboMode: TComboBox
            Left = 291
            Top = 27
            Width = 80
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = #38431#21015
            OnChange = comboModeChange
            Items.Strings = (
              #38431#21015
              #24191#25773)
          end
          object checkPersistent: TCheckBox
            Left = 165
            Top = 29
            Width = 83
            Height = 17
            Caption = #28040#24687#25345#20037#21270
            TabOrder = 4
          end
          object edtTopic: TEdit
            Left = 65
            Top = 88
            Width = 80
            Height = 21
            TabOrder = 5
            Text = 'TF_Site'
          end
        end
      end
    end
  end
end
