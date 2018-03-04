object frmFingerDemo: TfrmFingerDemo
  Left = 0
  Top = 0
  Caption = #25351#32441#20202#23454#20363
  ClientHeight = 478
  ClientWidth = 847
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel2: TRzPanel
    Left = 0
    Top = 0
    Width = 847
    Height = 459
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 0
    object RzGroupBox1: TRzGroupBox
      Left = 24
      Top = 24
      Width = 377
      Height = 121
      Caption = #21021#22987#21270#25351#32441#20202
      TabOrder = 0
      object btnOpenFinger: TSpeedButton
        Left = 100
        Top = 75
        Width = 100
        Height = 25
        Caption = #25171#24320#35774#22791
        OnClick = btnOpenFingerClick
      end
      object btnCloseFinger: TSpeedButton
        Left = 251
        Top = 75
        Width = 100
        Height = 25
        Caption = #20851#38381#35774#22791
        OnClick = btnCloseFingerClick
      end
      object Label1: TLabel
        Left = 25
        Top = 24
        Width = 53
        Height = 13
        Caption = 'Sensor Cnt'
      end
      object Label2: TLabel
        Left = 230
        Top = 25
        Width = 37
        Height = 13
        Caption = 'Current'
      end
      object Label3: TLabel
        Left = 25
        Top = 53
        Width = 50
        Height = 13
        Caption = 'Serial Num'
      end
      object edtSensorNum: TEdit
        Left = 100
        Top = 21
        Width = 60
        Height = 21
        Color = clBtnFace
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        ReadOnly = True
        TabOrder = 0
      end
      object edtSensorIndex: TEdit
        Left = 291
        Top = 21
        Width = 60
        Height = 21
        Color = clBtnFace
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        ReadOnly = True
        TabOrder = 1
      end
      object edtSensorSN: TEdit
        Left = 100
        Top = 48
        Width = 253
        Height = 21
        Color = clBtnFace
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        ReadOnly = True
        TabOrder = 2
      end
    end
    object RzGroupBox2: TRzGroupBox
      Left = 417
      Top = 24
      Width = 394
      Height = 417
      Caption = #25351#32441#29031#29255
      TabOrder = 1
      object RzPanel1: TRzPanel
        Left = 16
        Top = 23
        Width = 353
        Height = 386
        BorderInner = fsFlat
        BorderOuter = fsNone
        Color = clWhite
        TabOrder = 0
        object Image1: TImage
          Left = 12
          Top = 15
          Width = 328
          Height = 356
        end
      end
    end
    object RzGroupBox3: TRzGroupBox
      Left = 24
      Top = 172
      Width = 377
      Height = 269
      Caption = #30331#35760#39564#35777
      TabOrder = 2
      object btnBeginScroll: TSpeedButton
        Left = 100
        Top = 46
        Width = 85
        Height = 25
        Caption = #24320#22987#30331#35760
        OnClick = btnBeginScrollClick
      end
      object btnCancelScroll: TSpeedButton
        Left = 251
        Top = 46
        Width = 100
        Height = 25
        Caption = #21462#28040#30331#35760
        OnClick = btnCancelScrollClick
      end
      object Label5: TLabel
        Left = 61
        Top = 23
        Width = 24
        Height = 13
        Caption = #22995#21517
      end
      object Label7: TLabel
        Left = 34
        Top = 80
        Width = 60
        Height = 13
        Caption = #24050#30331#35760#20154#21592
      end
      object btnBeginCapture: TSpeedButton
        Left = 100
        Top = 235
        Width = 100
        Height = 25
        Caption = #24320#22987#39564#35777
        OnClick = btnBeginCaptureClick
      end
      object btnEndCapture: TSpeedButton
        Left = 251
        Top = 235
        Width = 100
        Height = 25
        Caption = #21462#28040#39564#35777
        OnClick = btnEndCaptureClick
      end
      object Label8: TLabel
        Left = 220
        Top = 23
        Width = 24
        Height = 13
        Caption = #24207#21495
      end
      object edtRegName: TEdit
        Left = 100
        Top = 20
        Width = 100
        Height = 21
        Color = clWhite
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        TabOrder = 0
      end
      object memoRegList: TRzMemo
        Left = 100
        Top = 77
        Width = 253
        Height = 152
        Color = clInfoBk
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object edtRegID: TEdit
        Left = 251
        Top = 20
        Width = 100
        Height = 21
        Color = clWhite
        ImeName = #20013#25991' ('#31616#20307') - '#24494#36719#25340#38899
        TabOrder = 2
      end
      object CheckBox1: TCheckBox
        Left = 191
        Top = 56
        Width = 51
        Height = 15
        Caption = #20462#25913
        TabOrder = 3
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 459
    Width = 847
    Height = 19
    Panels = <
      item
        Text = #25351#32441#20202#65306#26410#21021#22987#21270
        Width = 120
      end
      item
        Width = 250
      end
      item
        Width = 50
      end>
  end
end
