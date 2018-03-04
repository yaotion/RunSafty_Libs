object frmLogLibConfig: TfrmLogLibConfig
  Left = 0
  Top = 0
  Caption = #37197#32622
  ClientHeight = 306
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 326
    Top = 255
    Width = 75
    Height = 25
    Caption = #20445#23384
    Default = True
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object GroupBox1: TGroupBox
    Left = 32
    Top = 104
    Width = 369
    Height = 65
    Caption = #26085#24535#32423#21035#24320#20851'('#21246#36873#21518#23558#19981#22312#20445#23384#25351#23450#32423#21035#26085#24535')'
    TabOrder = 1
    object checkEnableInfo: TCheckBox
      Left = 74
      Top = 32
      Width = 97
      Height = 17
      Caption = #25552#31034#31867#26085#24535
      TabOrder = 0
    end
    object checkEnableWarn: TCheckBox
      Left = 169
      Top = 32
      Width = 97
      Height = 17
      Caption = #35686#21578#31867#26085#24535
      TabOrder = 1
    end
    object checkEnableError: TCheckBox
      Left = 264
      Top = 32
      Width = 81
      Height = 17
      Caption = #38169#35823#31867#26085#24535
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 32
    Top = 24
    Width = 369
    Height = 65
    Caption = #26085#24535#30446#24405
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 29
      Width = 52
      Height = 13
      Caption = #30456#23545#36335#24452':'
    end
    object edtLogPath: TEdit
      Left = 74
      Top = 26
      Width = 271
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 32
    Top = 184
    Width = 369
    Height = 65
    Caption = #26085#24535#24191#25773
    TabOrder = 3
    object Label2: TLabel
      Left = 169
      Top = 33
      Width = 28
      Height = 13
      Caption = #31471#21475':'
    end
    object checkEnableUDP: TCheckBox
      Left = 74
      Top = 32
      Width = 71
      Height = 17
      Caption = #21551#29992#24191#25773
      TabOrder = 0
    end
    object edtUDPPort: TEdit
      Left = 203
      Top = 29
      Width = 43
      Height = 21
      TabOrder = 1
    end
  end
end
