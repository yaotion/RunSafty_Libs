object TemplateTrainNoManager: TTemplateTrainNoManager
  Left = 0
  Top = 0
  Caption = #27169#26495#36710#27425#34920#31649#29702
  ClientHeight = 722
  ClientWidth = 1059
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel3: TRzPanel
    Left = 0
    Top = 51
    Width = 1059
    Height = 671
    Align = alClient
    BorderOuter = fsGroove
    TabOrder = 0
    object AdvSplitter1: TAdvSplitter
      Left = 241
      Top = 2
      Height = 667
      OnMoved = AdvSplitter1Moved
      Appearance.BorderColor = clNone
      Appearance.BorderColorHot = clNone
      Appearance.Color = clWhite
      Appearance.ColorTo = clSilver
      Appearance.ColorHot = clWhite
      Appearance.ColorHotTo = clGray
      GripStyle = sgDots
      ExplicitLeft = 248
      ExplicitTop = 240
      ExplicitHeight = 100
    end
    object RzPanel5: TRzPanel
      Left = 2
      Top = 2
      Width = 239
      Height = 667
      Align = alLeft
      BorderOuter = fsNone
      TabOrder = 0
      object RzPanel6: TRzPanel
        Left = 0
        Top = 0
        Width = 239
        Height = 41
        Align = alTop
        BorderInner = fsFlatRounded
        BorderOuter = fsButtonUp
        TabOrder = 0
        object Label4: TLabel
          Left = 76
          Top = 9
          Width = 66
          Height = 21
          Alignment = taCenter
          Caption = #26426#36710#32452
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object lstGroup: TListBox
        Left = 0
        Top = 41
        Width = 239
        Height = 626
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnClick = lstGroupClick
        OnDrawItem = lstGroupDrawItem
      end
    end
    object RzPanel2: TRzPanel
      Left = 244
      Top = 2
      Width = 813
      Height = 667
      Align = alClient
      BorderOuter = fsNone
      TabOrder = 1
      object strGridTrainTrainNo: TAdvStringGrid
        Left = 0
        Top = 41
        Width = 813
        Height = 626
        Cursor = crDefault
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clWhite
        ColCount = 6
        Constraints.MinHeight = 180
        Ctl3D = False
        RowCount = 2
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goTabs, goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ActiveRowColor = clWhite
        HoverRowColor = clWhite
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          #24207#21495
          #36710#27425'1'
          #36710#27425'2'
          #27966#29677#36710#27425
          #22791#27880
          #26159#21542#27425#26085#36710#27425)
        ColumnSize.Location = clIniFile
        ControlLook.FixedGradientHoverFrom = 15000287
        ControlLook.FixedGradientHoverTo = 14406605
        ControlLook.FixedGradientHoverMirrorFrom = 14406605
        ControlLook.FixedGradientHoverMirrorTo = 13813180
        ControlLook.FixedGradientHoverBorder = 12033927
        ControlLook.FixedGradientDownFrom = 14991773
        ControlLook.FixedGradientDownTo = 14991773
        ControlLook.FixedGradientDownMirrorFrom = 14991773
        ControlLook.FixedGradientDownMirrorTo = 14991773
        ControlLook.FixedGradientDownBorder = 14991773
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'Tahoma'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        EnableHTML = False
        EnhRowColMove = False
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDownClear = '(All)'
        FixedColWidth = 40
        FixedRowHeight = 25
        FixedRowAlways = True
        FixedFont.Charset = GB2312_CHARSET
        FixedFont.Color = 4079911
        FixedFont.Height = -16
        FixedFont.Name = #23435#20307
        FixedFont.Style = [fsBold]
        Flat = True
        FloatFormat = '%.2f'
        Look = glClassic
        Multilinecells = True
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        ScrollWidth = 16
        SearchFooter.Color = clBtnFace
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SelectionColor = clHighlight
        SelectionRectangle = True
        SelectionTextColor = clHighlightText
        ShowSelection = False
        ShowModified.Color = clWhite
        ShowDesignHelper = False
        SortSettings.Show = True
        Version = '5.6.0.0'
        ColWidths = (
          40
          125
          86
          275
          0
          271)
        RowHeights = (
          25
          27)
      end
      object RzPanel4: TRzPanel
        Left = 0
        Top = 0
        Width = 813
        Height = 41
        Align = alTop
        BorderInner = fsFlatRounded
        BorderOuter = fsButtonUp
        TabOrder = 1
        object Label3: TLabel
          Left = 322
          Top = 9
          Width = 132
          Height = 21
          Caption = #35814#32454#35745#21010#20449#24687
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object strGridDaWen: TAdvStringGrid
        Left = 0
        Top = 41
        Width = 813
        Height = 626
        Cursor = crDefault
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clWhite
        Constraints.MinHeight = 180
        Ctl3D = False
        RowCount = 2
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
        ActiveRowColor = clWhite
        HoverRowColor = clWhite
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          #24207#21495
          #36710#22411
          #26426#36710
          #26426#36710
          #38468#27880)
        ColumnSize.Location = clIniFile
        ControlLook.FixedGradientHoverFrom = 15000287
        ControlLook.FixedGradientHoverTo = 14406605
        ControlLook.FixedGradientHoverMirrorFrom = 14406605
        ControlLook.FixedGradientHoverMirrorTo = 13813180
        ControlLook.FixedGradientHoverBorder = 12033927
        ControlLook.FixedGradientDownFrom = 14991773
        ControlLook.FixedGradientDownTo = 14991773
        ControlLook.FixedGradientDownMirrorFrom = 14991773
        ControlLook.FixedGradientDownMirrorTo = 14991773
        ControlLook.FixedGradientDownBorder = 14991773
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'Tahoma'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        EnableHTML = False
        EnhRowColMove = False
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDownClear = '(All)'
        FixedColWidth = 40
        FixedRowHeight = 25
        FixedRowAlways = True
        FixedFont.Charset = GB2312_CHARSET
        FixedFont.Color = 4079911
        FixedFont.Height = -16
        FixedFont.Name = #23435#20307
        FixedFont.Style = [fsBold]
        Flat = True
        FloatFormat = '%.2f'
        Look = glClassic
        Multilinecells = True
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        ScrollWidth = 16
        SearchFooter.Color = clBtnFace
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SelectionColor = clHighlight
        SelectionRectangle = True
        SelectionTextColor = clHighlightText
        ShowSelection = False
        ShowModified.Color = clWhite
        ShowDesignHelper = False
        SortSettings.AutoSortForGrouping = False
        SortSettings.AutoFormat = False
        SortSettings.SortOnVirtualCells = False
        Version = '5.6.0.0'
        ColWidths = (
          40
          125
          104
          163
          365)
        RowHeights = (
          25
          27)
      end
    end
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 1059
    Height = 51
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 1
    object btnAdd: TPngSpeedButton
      Left = 572
      Top = 11
      Width = 80
      Height = 25
      Caption = #28155#21152
      Flat = True
      OnClick = btnAddClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000008E4944415478DA63FCFFFF3F032580717019C0C8C808674B6C664431
        F985EF7FAC96E135E08A0F444E670B23D800101BDD10BC066C7783C879EE22D2
        00C92D4C28B2B3EC21DCB4838C289A9EFBFC63C469408D25FE406D39CE88DF80
        3863FC062C3A4BC00064C58E3A10EEFE2B447A013D1095D52072776F91190B6C
        F210B95F0FC9340059215109891C30F0060000DE2D81E1F453FC270000000049
        454E44AE426082}
    end
    object btnUpdate: TPngSpeedButton
      Left = 658
      Top = 11
      Width = 80
      Height = 25
      Caption = #20462#25913
      Flat = True
      OnClick = btnUpdateClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000018D4944415478DA63644000EB8EAED6230C84816B4559F51E188711C6
        006AFE5F565289A1FAEFDFBF60FAF7EFDF0CACACAC0CBDFD5D28866018F0EEDD
        3B86FFFFFF3330801104DEBB7397E1F9ABA70C66A6960CE262E228866018F0F6
        ED5BB00140FD5083C02C86ADDB3733040584327CFDF615AC7EC9D2850C400318
        310C78F3FA0DC3BC85B351BC111793C870F8C821862F5F3F317CFBF68DE1EB57
        8821580D78F5EA15C452881B18FE815C03C4208D8F1E3D6460636363E099690F
        D3168B61C0CB972F19162E9E87330ADC2E5533A8573030B0DFB663B8B4F61066
        20BE78F1021A06D0808438070C5E57CAC235FF3C7588E1E6632CB1F0FCD93386
        C5CB16E2B519A61908EA300C78FAF42986666C36DF11776608EBDDCB88D580A5
        CB1761D8AE178CD02C97BE8861CEF1C7A0586022E80290ED464B1818B2C3CD18
        92594F3108E46C655030F364E8EA69C76D00B20B808A18CEC5308035B24AEB81
        C5A4A5A5193ABBDB182ACB6B18890A0374003200EA02468299091700AA67A8AA
        A84531603F907220DA040686034017380200B9D904A1FE5353B7000000004945
        4E44AE426082}
    end
    object btnDelete: TPngSpeedButton
      Left = 744
      Top = 11
      Width = 80
      Height = 25
      Caption = #21024#38500
      Flat = True
      OnClick = btnDeleteClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000005D4944415478DAED92C10A00200843F3CBD52F2F0A065692D22D6827
        03F7A621958344A49A9ABC1E3A99AD697DBB009B1809B0298199B3FEA2AA0332
        01D26E33C5B642660AA4BB7FD001BD0120AFFE802700D7770048E6025153D41C
        A9015F8F9D11F961E86F0000000049454E44AE426082}
    end
    object Label1: TLabel
      Left = 10
      Top = 18
      Width = 76
      Height = 13
      Caption = #26426#36710#35745#21010#36873#25321':'
    end
    object btnQuery: TPngSpeedButton
      Left = 470
      Top = 11
      Width = 91
      Height = 25
      Caption = #26597#35810
      Flat = True
      OnClick = btnQueryClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002E64944415478DA95926D4893611486EF77DBBBCDCD8F04
        97B1D9621586591315914D9BCE393F4A0AFCA390DA8F0651922888486A588A49
        140A1195E50F8B90CCFC238ADADC52FB50D4B0403191669A96DA4C9BDB9C6E7B
        7B67386745D0811B9EE73C9C8BC3FDDC043C6AF8B6B28272D80B4139B8EE26C1
        5C2398AC1B91B9FA32FC56144581D8BA0CD42A660324878512D971100291EB95
        1E26402DCCC2D0DF8E6F86B1B9E8FC5ED15F016F6AE26625510942EFD014DCEA
        F7C3C0171E4892008B64422EB2E2ACD48895F7ED981AD2CFC90A7A443B002F6B
        541502F1FE52617C0E34AD413871C41F72090FABEB0E2C5A1CF860B463727903
        D7A2C631DDDD80C51943656C4177991BA0BF1EB7A6C8D070AE8F4620285004E5
        411EBE9AEDF86E736065DD89452B8519138560EF1564EDEA45DFD37A9BB2A887
        EB06E8AA8F51CADC42A43747E26A6A00D69D4E186D4E981C147ED05AB251D870
        10348C44D5A14EE8EEDE84AAB88F7003BAAA1494FAFC0564B42B50A2F2C782D5
        4E0F0216DA9E555AB48FBF006B244A84CDE8AABB83E44BBDDB808ECA782AF99C
        06A77549C88AE0C3E2B46F0E5A984C70BD989B46DA6CC092958522DF47E87850
        8FD4D29E6D405B85D296989EC6AE5B50C3C2DE0B5F3E606530C0E3B3C0F36183
        C361C16405765BA791686AC2F39636D3A9F217BE6EC0BD7CF9FDC8308926244E
        8DB2C934707924FCBC5D007A032E098264C16107B2371AF04EDB09B3711E89C5
        3AC23307C267971346C2228205A2D0703C598EC10482C177ADCF61208461809A
        D0C2303C8C996923929203F14A3B86D87C3DE199446953994A2B160B04D2F003
        F0F2F7A6F14E578E615E3263E4ED4798E63F2325260808C90456BA31A01D45F4
        452D417824535A9B1B9BB7C79F934DA3D9D456DA409868277D328306019207EC
        53004773F0FA7135E479BA1D0057096905D26278F4E84F05B3F1CAC9A14CF110
        E0EB874F3C59CBDCC44CBA2CAFEB0FC0BF2AB2B13C6D88DE0E2C86139D835367
        EA5AC71EFE0F6013E2711EA74D34FF04D99336F021FF0CC50000000049454E44
        AE426082}
    end
    object Label2: TLabel
      Left = 245
      Top = 18
      Width = 52
      Height = 13
      Caption = #29677#27425#36873#25321':'
    end
    object cmbDayPlan: TRzComboBox
      Left = 92
      Top = 15
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
      OnChange = cmbDayPlanChange
    end
    object cmbDayPlanType: TRzComboBox
      Left = 311
      Top = 15
      Width = 98
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Text = #30333#29677
      Items.Strings = (
        #30333#29677
        #22812#29677
        #20840#22825)
      ItemIndex = 0
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 512
    Top = 208
    object N1: TMenuItem
      Action = actInsertGroup
    end
    object N2: TMenuItem
      Action = actUpdateGroup
    end
    object N3: TMenuItem
      Action = actDeleteGroup
    end
  end
  object ActionList1: TActionList
    Left = 784
    Top = 240
    object actSelectDayPlan: TAction
      Caption = 'actSelectDayPlan'
      OnExecute = actSelectDayPlanExecute
    end
    object actInsertGroup: TAction
      Caption = #28155#21152#26426#36710#32452
      OnExecute = actInsertGroupExecute
    end
    object actUpdateGroup: TAction
      Caption = #20462#25913#26426#36710#32452
      OnExecute = actUpdateGroupExecute
    end
    object actDeleteGroup: TAction
      Caption = #21024#38500#26426#36710#32452
      OnExecute = actDeleteGroupExecute
    end
    object Action1: TAction
      Caption = 'Action1'
    end
  end
  object MainMenu1: TMainMenu
    Left = 704
    Top = 256
    object N8: TMenuItem
      Caption = #31995#32479
      object E1: TMenuItem
        Caption = #36864#20986'(&E)'
        OnClick = E1Click
      end
    end
    object N4: TMenuItem
      Caption = #34892#36710#21306#27573
      object N5: TMenuItem
        Action = actInsertGroup
      end
      object N6: TMenuItem
        Action = actUpdateGroup
      end
      object N7: TMenuItem
        Action = actDeleteGroup
      end
    end
  end
end
