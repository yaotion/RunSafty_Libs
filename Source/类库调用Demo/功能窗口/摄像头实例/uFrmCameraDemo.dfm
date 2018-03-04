object frmCameraDemo: TfrmCameraDemo
  Left = 0
  Top = 0
  Caption = #25668#20687#22836#25511#21046
  ClientHeight = 379
  ClientWidth = 960
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
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel1: TRzPanel
    Left = 0
    Top = 338
    Width = 960
    Height = 41
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 0
    object btnRefreshDevices: TSpeedButton
      Left = 2
      Top = 4
      Width = 97
      Height = 32
      Caption = #21047#26032#35774#22791
      OnClick = btnRefreshDevicesClick
    end
    object btnClose: TSpeedButton
      Left = 749
      Top = 6
      Width = 97
      Height = 32
      Caption = #20851#38381
      OnClick = btnCloseClick
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 0
    Width = 960
    Height = 338
    Align = alClient
    BorderOuter = fsGroove
    TabOrder = 1
    object pParent: TPanel
      Left = 219
      Top = 2
      Width = 739
      Height = 334
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object imgBMP: TImage
        Left = 360
        Top = 24
        Width = 305
        Height = 281
        Stretch = True
      end
      object pnCamera: TPanel
        Left = 16
        Top = 24
        Width = 297
        Height = 281
        Caption = 'pnCamera'
        TabOrder = 0
      end
    end
    object lstCamera: TListBox
      Left = 2
      Top = 2
      Width = 217
      Height = 334
      Align = alLeft
      BorderStyle = bsNone
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 1
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 344
    object miOpenCamera: TMenuItem
      Caption = #25171#24320#25668#20687#22836
      OnClick = miOpenCameraClick
    end
    object miCloseCamera: TMenuItem
      Caption = #20851#38381#25668#20687#22836
      OnClick = miCloseCameraClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miCapture: TMenuItem
      Caption = #25235#22270
      OnClick = miCaptureClick
    end
  end
end
