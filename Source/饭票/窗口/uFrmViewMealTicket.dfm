object FrmViewMealTicket: TFrmViewMealTicket
  Left = 0
  Top = 0
  Caption = #39277#31080#26597#30475
  ClientHeight = 548
  ClientWidth = 1063
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 1063
    Height = 89
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 0
    object btnRefresh: TPngSpeedButton
      Left = 644
      Top = 16
      Width = 93
      Height = 59
      Caption = #26597#25214
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnRefreshClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000003684944415478DA4D935D685C4514C7CFCCDC99B97B93FD
        48369F8D6BD36D366DB36D4142F4C10A822F3E58D00769E983D60A5289542905
        1151518AFA542B55CC4385826FD287BC0A8AF8265685602D769B266B633E5837
        DBEEBDBBD9FB311F9E9BBE7861B833CC99DFFCCF39FF21E7179E84871F01CE28
        18431E0E0D4F4841AB16C0C689F98352F815B731CC80B50627E9C200F93F8011
        0A94D267878AF495C1419815C264D39D28A2EDED16DCD8DE36578D313F925D08
        85F48F8063186201A1C581027FB73265DFCA7811313A026DCC2E9AE1F594B9D0
        0984B9B30C1F0681BE2E259B51895E24E7BE7C1CCF53182AF2AFAB87CC196DBA
        10740CF8BEA37B3DBA960232AE29E5F309CBF63BA8A6AF1774D87DA56D58ABE9
        E364FEF359F03C7EF6B1A3F42B423AE00700EB9BF2E7C077DE4699370849B3B3
        73B9ACBA3836163E95CF52C8780EACADD1FAED1A3D495EBF3C7BF860455C7F64
        223C107435ACD4C5EFAD6DF69CE06C33AD8B310A9449402B7AAC3C49BE1B1D09
        3D0442E35FB97277959CC414669F1E19261F099EEC8B62D26E34E93CB1ECA7B4
        4094303C1C23C4CEEC2DB9D7CA65980B7B3BE03080CD2D7EEF56CD9C480110C7
        3A6B2C0C50026DCA745B69855D322098030C07A6F1D2C4B87359EB8425CA6887
        11D9D9A1A8D49E26AF7D7630172BDD8F05B7A88C5A0B02BB99B82EDB481B2D1C
        8E4A08DD89743F465063514FDA196663F44D48DE5CA82E96C6BDA352E2FD60AC
        E3101A4606EEAC74DF43D8371A6BC0A8832DB5A0B406A5B487CDE58293085309
        C985AB335BD57261D4CDA02998018D86A8AD844BFF6C842F5B304BC66A889204
        F36620397FE150A5702523D940B315FF595F0FCEA182E9D5F2687E52080DDCB5
        B0D18CC25BCBC1712CE2F7CC4168EAC424352EAD54A707168F1CE89BD109859B
        CBC1D2723D3841DEF8A2B23A355E9C94120138A4E7D8D58DCE6F77FFF63F8962
        753375812BF991FD7B731F4C4FF61DEEFA096C3595BD5D6F9FC1AD6B64FE4A65
        BD3458DCD3085AF591A21CDB33E2BAFD7907BA918207ED783D9550C8CA893E41
        21F015349A0AFEBAD7FA384AF4FB581B4D5EBDF4E8023EA229BFD73D2BB978BE
        349C7B6774C81B2CE43848810DA716EDABD1DA316C36C3FB6B0DFF529CA88B9C
        F3F4F90139F5E970169F122E68606D3AB3731ECFBC987533CF604C9920402953
        F777A21FBA71F82D01F24B6AB05D7F20E03F5E1C9FB0A0304695000000004945
        4E44AE426082}
    end
    object lb1: TLabel
      Left = 18
      Top = 16
      Width = 91
      Height = 19
      Caption = #24320#22987#26102#38388':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lb2: TLabel
      Left = 16
      Top = 48
      Width = 91
      Height = 19
      Caption = #25130#27490#26102#38388':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 354
      Top = 16
      Width = 105
      Height = 19
      Caption = #39046#21462#20154#24037#21495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object dtpStartDate: TDateTimePicker
      Left = 115
      Top = 16
      Width = 113
      Height = 24
      Date = 41810.618773842590000000
      Time = 41810.618773842590000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object dtpEndDate: TDateTimePicker
      Left = 113
      Top = 46
      Width = 115
      Height = 24
      Date = 41810.618773842590000000
      Time = 41810.618773842590000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object dtpStartTime: TDateTimePicker
      Left = 236
      Top = 16
      Width = 98
      Height = 24
      Date = 41810.000000000000000000
      Time = 41810.000000000000000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      Kind = dtkTime
      ParentFont = False
      TabOrder = 2
    end
    object dtpEndTime: TDateTimePicker
      Left = 236
      Top = 46
      Width = 98
      Height = 24
      Date = 41810.999988425920000000
      Time = 41810.999988425920000000
      DateMode = dmUpDown
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      Kind = dtkTime
      ParentFont = False
      TabOrder = 3
    end
    object edtDriver: TEdit
      Left = 480
      Top = 17
      Width = 145
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object lvRecord: TListView
    Left = 0
    Top = 89
    Width = 1063
    Height = 459
    Align = alClient
    Columns = <
      item
        Caption = #24207#21495
        Width = 80
      end
      item
        Caption = #39046#21462#20154
        Width = 150
      end
      item
        Caption = #26089#39184
      end
      item
        Caption = #27491#39184
      end
      item
        Caption = #35745#21010#26102#38388
        Width = 220
      end
      item
        Caption = #36710#27425
        Width = 100
      end
      item
        Caption = #21457#25918#20154
        Width = 150
      end
      item
        Caption = #21457#25918#26102#38388
        Width = 220
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
    TabOrder = 1
    ViewStyle = vsReport
  end
  object actlst1: TActionList
    Left = 600
    Top = 152
    object actInspect: TAction
      Caption = 'actInspect'
    end
  end
end
