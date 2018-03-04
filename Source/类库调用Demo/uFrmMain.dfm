object frmMainDemo: TfrmMainDemo
  Left = 0
  Top = 0
  Caption = #25509#21475#24211#35843#29992'Demo'
  ClientHeight = 506
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 121
    Top = 89
    object N1: TMenuItem
      Caption = #27979#35797#25509#21475
      object miCamera: TMenuItem
        Caption = #25668#20687#22836#25511#21046
        OnClick = miCameraClick
      end
      object miAlcohol: TMenuItem
        Caption = #27979#37202#20202#25511#21046
        OnClick = miAlcoholClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Caption = #26085#24535#31649#29702#22120
        Enabled = False
        OnClick = N3Click
      end
      object miLog: TMenuItem
        Caption = #26085#24535#25511#21046
        OnClick = miLogClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miFinger: TMenuItem
        Caption = #25351#32441#20202#25511#21046
        OnClick = miFingerClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Caption = #20154#21592#24211#31649#29702
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Caption = #36816#23433#21160#24577#24211
        OnClick = N8Click
      end
      object miLoginLib: TMenuItem
        Caption = #30331#24405#31383#21475
        OnClick = miLoginLibClick
      end
    end
  end
end
