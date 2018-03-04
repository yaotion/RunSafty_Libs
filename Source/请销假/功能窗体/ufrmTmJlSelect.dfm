object frmTmjlSelect: TfrmTmjlSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20132#36335#36873#25321
  ClientHeight = 224
  ClientWidth = 223
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
  object Bevel1: TBevel
    Left = 8
    Top = 175
    Width = 202
    Height = 2
  end
  object cbbTMJiaolu: TRzComboBox
    Left = 8
    Top = 8
    Width = 202
    Height = 21
    Ctl3D = False
    ItemHeight = 0
    ParentCtl3D = False
    TabOrder = 0
    OnChange = cbbTMJiaoluChange
  end
  object Button1: TButton
    Left = 53
    Top = 183
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 134
    Top = 183
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
  object RzPageControl1: TRzPageControl
    Left = 8
    Top = 35
    Width = 205
    Height = 134
    ActivePage = TabSheet3
    TabOrder = 3
    FixedDimension = 0
    object TabSheet1: TRzTabSheet
      TabVisible = False
      Caption = #36718#20056
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 3
        Top = 27
        Width = 40
        Height = 13
        Caption = #20986#21220#28857':'
      end
      object cbbDutyPlace: TRzComboBox
        Left = 49
        Top = 24
        Width = 141
        Height = 21
        Ctl3D = False
        Enabled = False
        ItemHeight = 0
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object TabSheet2: TRzTabSheet
      TabVisible = False
      Caption = #21253#20056
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 9
        Top = 27
        Width = 28
        Height = 13
        Caption = #26426#36710':'
      end
      object cbbTrains: TRzComboBox
        Left = 49
        Top = 24
        Width = 141
        Height = 21
        Ctl3D = False
        ItemHeight = 0
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object TabSheet3: TRzTabSheet
      TabVisible = False
      Caption = #35760#21517
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 8
        Top = 27
        Width = 34
        Height = 13
        Caption = #36710#27425'1:'
      end
      object Label4: TLabel
        Left = 8
        Top = 54
        Width = 34
        Height = 13
        Caption = #36710#27425'2:'
      end
      object edtCheCi1: TRzEdit
        Left = 49
        Top = 24
        Width = 141
        Height = 21
        TabOrder = 0
      end
      object edtCheCi2: TRzEdit
        Left = 49
        Top = 51
        Width = 141
        Height = 21
        TabOrder = 1
      end
    end
  end
end
