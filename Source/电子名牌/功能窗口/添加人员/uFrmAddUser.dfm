object FrmAddUser: TFrmAddUser
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #20154#21592
  ClientHeight = 106
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 40
    Height = 16
    Caption = #21496#26426':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 54
    Width = 218
    Height = 2
  end
  object edtTrainman1: TtfLookupEdit
    Left = 56
    Top = 24
    Width = 156
    Height = 24
    Columns = <>
    PopStyle.ShowColumn = True
    PopStyle.ShowFooter = True
    PopStyle.PageCount = 0
    PopStyle.PageIndex = 0
    PopStyle.BGColor = clWhite
    PopStyle.ColHeight = 20
    PopStyle.FooterHeight = 25
    PopStyle.RowHeight = 25
    PopStyle.PopBorderColor = clGray
    PopStyle.BorderWidth = 2
    PopStyle.CellMargins.Left = 2
    PopStyle.CellMargins.Top = 2
    PopStyle.CellMargins.Right = 2
    PopStyle.CellMargins.Bottom = 2
    PopStyle.SelectedBGColor = cl3DDkShadow
    PopStyle.NormalCellFont.Charset = DEFAULT_CHARSET
    PopStyle.NormalCellFont.Color = clBlack
    PopStyle.NormalCellFont.Height = -12
    PopStyle.NormalCellFont.Name = #23435#20307
    PopStyle.NormalCellFont.Style = []
    PopStyle.SelectedCellFont.Charset = DEFAULT_CHARSET
    PopStyle.SelectedCellFont.Color = clWhite
    PopStyle.SelectedCellFont.Height = -12
    PopStyle.SelectedCellFont.Name = #23435#20307
    PopStyle.SelectedCellFont.Style = []
    PopStyle.MaxViewCol = 10
    OnSelected = edtTrainman1Selected
    OnPrevPage = edtTrainman1PrevPage
    OnNextPage = edtTrainman1NextPage
    IsAutoPopup = True
    HideSelection = False
    TabOrder = 0
    OnChange = edtTrainman1Change
  end
  object btnOk: TButton
    Left = 56
    Top = 62
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 137
    Top = 62
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
