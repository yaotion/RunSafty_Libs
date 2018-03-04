object FrmMainTemeplateTrainNo: TFrmMainTemeplateTrainNo
  Left = 0
  Top = 0
  Caption = #26426#36710#35745#21010
  ClientHeight = 540
  ClientWidth = 1215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 1215
    Height = 57
    Align = alTop
    Caption = #29677#27425#36873#25321
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 72
      Height = 16
      Caption = #36873#25321#26085#26399':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object btnLoadPlan: TPngSpeedButton
      Left = 646
      Top = 15
      Width = 131
      Height = 30
      Hint = #20174#27169#26495#36710#27425#34920#37324#38754#21152#36733#26426#36710#35745#21010
      Caption = #20174#27169#26495#36710#27425#34920#21152#36733
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnLoadPlanClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000017A4944415478DAA5D34D2804611CC7F1D9EC9613510E8A
        F27243382D2E7B929CE4A49452520EEB220EA8F576409492224A28392CC54DA2
        142749717176F01637D958617C1FFB1BA6B1BB174F7D9A67A69DDFF37FFECFAC
        CFB66DEB3FC3170C069D7900C5A8C72D765083321CE10A1FA902FC68C210AAB0
        820EDD8FE20C930A7DF706F835AFC51CAA318F30FA3181070C624D55D8EE8036
        AE6F8822846E2C634FF7116C61515BCAC131624E809964A015DB69FA55A9A05C
        055F3A01A69CB8CA0B7BF7E81A63DA8659AC4561B6099865F2A2D54FD254D080
        55E46344CDFDAE2093EBA7FAE01D196A6E394A74327938540571131051050738
        F7049813EAD511261B4F4E0FCCD14C6320C98F4CD3C6D1E579FE8C4E27E011ED
        D84DB192297F1D75AE6733A63A13D0C3E41A9B56E2336EC63E4E7167FD7E3421
        9D541136B4B57B13E033CDD4D14CA1502F2E69EFAFAE55CD4B8DE8C385730AE6
        1AD0168651A01F47D5F5982B205B6ED4B79F005341162A74DEA556E20FB4E0A9
        E0CFF802F5B86237D8C9E3FD0000000049454E44AE426082}
    end
    object btnRefreshPaln: TPngSpeedButton
      Left = 431
      Top = 15
      Width = 90
      Height = 30
      Hint = #21333#20987#21047#26032#19968#19979#30028#38754
      Caption = #21047#26032#35745#21010
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnRefreshPalnClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000016D4944415478DA95933F28C55114C7EFD3AF37480683DE
        20C9A048CAF25264900CA478912CCAF092C5C06233582C6233F8B31824CBF367
        906478615332480649261924935EF239BDEFE376FB21A73EF5FBDD7BCFF79C7B
        CEB989743AED62AC126AA00E2278807B78D1FE96FEE7128140398CC10434CBD9
        AC00B7B00A1BB00E03D0EF0B54C3267443999CDEB59794D8079C6AAF0B864B02
        15B0AB45DB3C50B44B8935401686BCAC9C2F30054B8A300F0B5E74CBA84A8E93
        D0110A58C1CE74E71C8C78CE4E0EDB9052362E1468E1E3420B834A3FB44E458F
        82F5451348298AA57F046FEE1F96F8610E7E332B788FAE933781363E66824305
        75E12446A0571D336B35016BCD4E70C8AEF30CA38148A48266E01ADAE304CE61
        459D788543CF79DA15DB1C29EBE538017F90AEF4DFE48AE39D91731EFAACE0BE
        C0B152FF6B94CDD966E5A9D405ABE83EECC1B82B3EA6ACA226BD9ADC28AB35BF
        D526608766A151452BB5AA16EA95CD23DCB9EFE7FC659F5B535D594C0F12B400
        00000049454E44AE426082}
    end
    object Label1: TLabel
      Left = 213
      Top = 23
      Width = 72
      Height = 16
      Caption = #29677#27425#36873#25321':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object btnAddPlan: TPngSpeedButton
      Left = 783
      Top = 15
      Width = 105
      Height = 30
      Hint = #26032#22686#21152#19968#26465#35745#21010
      Caption = #22686#21152#35745#21010
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnAddPlanClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000000794944415478DA6334333363C0022481B813886192A780
        B81C889FA32B64C461800210EF00627528FF26107B00F103520CD80FA519A01A
        1D07AF01A00063C762C07C340312B118F00364C022686863330419A06BFE09C4
        274106DC400A6D52C14DAA1840B117280E446C4E03691C4209099701146526A2
        B3330058393B53EBA48D220000000049454E44AE426082}
    end
    object btnDeletePlan: TPngSpeedButton
      Left = 899
      Top = 15
      Width = 90
      Height = 30
      Hint = #21024#38500#24403#21069#36873#20013#30340#35745#21010
      Caption = #21024#38500#35745#21010
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnDeletePlanClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000000A84944415478DA633433336380820420BE05C4C718F003
        1B205602E245200E23D4805E202E02E21F401C08C43B7068F602E2B540CC01C4
        3D405C0A320064F37C2445B80C41D60C03F12003EC808CDD40CC86C7106C9A41
        6A9C615EF0812AC06608130ECDC140BC8D1129107119C2804B337220E2338401
        97666C06E033046BE052DD0062BC8062083181C8C480278A298946B021544948
        090C1426651083A2CC049304B984E4EC0C00A7374B61197C9576000000004945
        4E44AE426082}
    end
    object btnImportPlan: TPngSpeedButton
      Left = 532
      Top = 15
      Width = 90
      Height = 30
      Hint = #23548#20986#24403#21069#30340#35745#21010#20026#19968#20010'EXCEL'#25991#20214
      Caption = #23548#20986#35745#21010
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnImportPlanClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
        EA000000097048597300000B1300000B1301009A9C1800000319694343505068
        6F746F73686F70204943432070726F66696C65000078DA6360609EE0E8E2E4CA
        24C0C050505452E41EE418191119A5C07E9E818D819981818181812131B9B8C0
        3120C087818181212F3F2F9501037CBBC6C0C8C0C0C07059D7D1C5C9958134C0
        9A5C5054C2C0C070808181C12825B538998181E10B0303437A79494109030363
        0C03038348527641090303630103038348764890330303630B0303134F496A45
        0903030383737E416551667A468982A1A5A5A582634A7E52AA42706571496A6E
        B182675E727E51417E5162496A0A030303D40E060606065E97FC1205F7C4CC3C
        05435355062A8388C82805F4F0418821407269511984C5C8C0C0C020C0A0C5E0
        C750C9B08AE101A3346314E33CC6A74C864C0D4C979835981B99EFB2D8B0CC63
        6566CD66BDCAE6C4B6895D857D2687004727272B67331733571B3737F7441E29
        9EA5BCC6BC87F882F99EF1570B0809AC1674137C24D428AC287C58245D945774
        AB589C38A7F85689144961C9A35215D2BAD24F64E6C886CA09CA9D95EF51F051
        E455BCA03445394A4549E5B5EA56B546753F0D598DB79AFBB4266AA7EA58EB0A
        E9BED23BA23FDFA0C630CAC8D258D2F8B7C93DD3C3662BCCFB2D2A2C13AD7CAC
        2D6C546D45EC58ECBEDA3F77B8ED78C1E998F35E97ADAEEBDD56BA2FF558E4B9
        D06B81F7429FC5BECBFC56F9AF0FD81AB837E858F0F9905BA1CFC2BE4430450A
        4629451BC7B8C546C5E5C5B724CC4EDC9C7436F9792A539A5CBA4D46546655D6
        ACEC3D39F7F298F2D50B7C0A8B8B66171F2E795B2651EE52515839AFEA6CF5DF
        5ABDBAF8FA490DC71A7F371BB4A4B7CE6BBBDE21D8E9DDD5DE7DB897A1CFBEBF
        6EC2BE89FF273B4E699D7A623AEF8CE099B3663D9AA335B764DEBE055C0BC316
        2D5EFC71A9C3B209CB1FAE345ED5BAFAE65ADD754DEB6F6E34D8D4B1F9C156AB
        6D53B77FD8E9BB6BD51E8EBDE9FB8E1F503FD879E8F511BFA39B8F8B9FA83DF9
        E4B4F7992DE764CFB75FF87429EEF2A9AB16D796DD10BDD97AEBEB9DF4BB37EF
        FB3C38F0C8F4F1EAA78ACF66BE107CD9F59AF94DDDDB9FEF4B3F7CFA54F0F9DD
        D7BC6FEF7EE4FFFCF0BBF8CFB77F55FFFF03002ABF1D8AF36F515B0000010349
        44415478DA8D91314842511486BF8BC39B121ACCE5ED8290D0E6E0D06A53A408
        D1F204DD42507413820673696A684D5141288842779DC4D9351C5C92A0416B48
        8AD7B9BE17BD48B20377B8E77CE7FEFF3D47D9FC1D6A2D60AECAEEB1CD39EF0E
        B0811F1B85C194571738E0866B0A4C34D02722651F4D4ACCD86457BAA3C4057B
        204757992F3CD2E1990B39FB5409FD10AB2873418DECF292A42142B010496399
        9950D4400B4B2E5B0C257DC940D271B1085D8E197F03790E49685B1229DA9C52
        E14D9BFC02CADC3272956304E51FEE1C1CC04740CC7A2340989E03D4C9FC1A95
        C13D4F1C69602E9D77F282F2943F641E1657A435306467E5126C4E38FBCFB2D6
        019FC9834438A85DFB340000000049454E44AE426082}
    end
    object btnSendPlan: TPngSpeedButton
      Left = 995
      Top = 15
      Width = 83
      Height = 30
      Hint = #19979#21457#35745#21010#21040#27966#29677#31471
      Caption = #19979#21457#35745#21010
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSendPlanClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000000E04944415478DA9D933D0EC2300C461318E0086141B000
        27E80294B2700DC435400CFC893BB0208EC1D66BB065A35760822FE054AE0B12
        A9A527AB69FC1A3BAA8EA2482134E8832B68030BA6945D18B00563D0542CF49F
        8216D883216854117849A1385460C4F16D88C0CF2066A7E886CE6007465505DF
        6610D48214E4EB555A70310815F02196041D12F4C08909164C60C535165A3823
        27A046C54A6C4AC1063CE8F9CEF6BC05096D8855397CF10DAC68EDC0254EE0BE
        3C034BF5F95964714AC777EF9FE0083239C43AB5B1061351ECC350CED85A2EF0
        37E18AE7E0228A7FC60BB1014C0F51D2433B0000000049454E44AE426082}
    end
    object dtpPlanStartDate: TRzDateTimePicker
      Left = 86
      Top = 21
      Width = 113
      Height = 21
      Date = 42117.426077638890000000
      Format = 'yyyy-MM-dd'
      Time = 42117.426077638890000000
      TabOrder = 0
      FramingPreference = fpCustomFraming
    end
    object cmbDayPlanType: TRzComboBox
      Left = 291
      Top = 21
      Width = 98
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnDrawItem = cmbDayPlanTypeDrawItem
      Items.Strings = (
        #30333#29677
        #22812#29677
        #20840#22825)
    end
    object Panel2: TPanel
      Left = 633
      Top = 15
      Width = 2
      Height = 31
      BevelOuter = bvLowered
      TabOrder = 2
    end
  end
  object RzPanel3: TRzPanel
    Left = 0
    Top = 57
    Width = 1215
    Height = 464
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
    object AdvSplitter1: TAdvSplitter
      Left = 239
      Top = 0
      Height = 464
      OnMoved = AdvSplitter1Moved
      Appearance.BorderColor = clNone
      Appearance.BorderColorHot = clNone
      Appearance.Color = clWhite
      Appearance.ColorTo = clSilver
      Appearance.ColorHot = clWhite
      Appearance.ColorHotTo = clGray
      GripStyle = sgDots
      ExplicitLeft = 240
      ExplicitTop = 200
      ExplicitHeight = 100
    end
    object RzPanel5: TRzPanel
      Left = 0
      Top = 0
      Width = 239
      Height = 464
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
          Left = 75
          Top = 10
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
        Height = 423
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
        OnClick = lstGroupClick
        OnDrawItem = lstGroupDrawItem
        OnMeasureItem = lstGroupMeasureItem
      end
    end
    object RzPanel1: TRzPanel
      Left = 242
      Top = 0
      Width = 973
      Height = 464
      Align = alClient
      BorderOuter = fsNone
      TabOrder = 1
      object strGridTrainPlan: TAdvStringGrid
        Left = 0
        Top = 41
        Width = 973
        Height = 423
        Cursor = crDefault
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clWhite
        ColCount = 9
        Constraints.MinHeight = 180
        Ctl3D = False
        RowCount = 2
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyPress = strGridTrainPlanKeyPress
        OnMouseUp = strGridTrainPlanMouseUp
        ActiveRowColor = clWhite
        HoverRowColor = clWhite
        OnGetCellColor = strGridTrainPlanGetCellColor
        OnGetAlignment = strGridTrainPlanGetAlignment
        OnCanEditCell = strGridTrainPlanCanEditCell
        OnCellValidate = strGridTrainPlanCellValidate
        OnGetEditorType = strGridTrainPlanGetEditorType
        OnEditCellDone = strGridTrainPlanEditCellDone
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          #24207#21495
          #29366#24577
          #36710#27425'1'
          #26426#36710#20449#24687
          #36710#22411
          #36710#21495
          #36710#27425
          #27966#29677#36710#27425
          #22791#27880)
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
        FixedFont.Color = 3355443
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
        ScrollType = ssFlat
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
        SelectionTextColor = clHighlightText
        ShowModified.Color = clWhite
        ShowDesignHelper = False
        SortSettings.AutoSortForGrouping = False
        SortSettings.AutoFormat = False
        SortSettings.SortOnVirtualCells = False
        Version = '5.6.0.0'
        ColWidths = (
          40
          122
          129
          84
          103
          111
          203
          64
          64)
        RowHeights = (
          25
          27)
      end
      object RzPanel2: TRzPanel
        Left = 0
        Top = 0
        Width = 973
        Height = 41
        Align = alTop
        BorderInner = fsFlatRounded
        BorderOuter = fsButtonUp
        TabOrder = 1
        object Label3: TLabel
          Left = 447
          Top = 10
          Width = 88
          Height = 21
          Caption = #26426#36710#20449#24687
          Font.Charset = GB2312_CHARSET
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
        Width = 973
        Height = 423
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
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
        OnMouseUp = strGridDaWenMouseUp
        ActiveRowColor = clWhite
        HoverRowColor = clWhite
        OnGetCellColor = strGridDaWenGetCellColor
        OnGetAlignment = strGridDaWenGetAlignment
        OnCanEditCell = strGridDaWenCanEditCell
        OnCellValidate = strGridDaWenCellValidate
        OnEditCellDone = strGridDaWenEditCellDone
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ColumnHeaders.Strings = (
          #24207#21495
          #29366#24577
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
        ScrollType = ssFlat
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
        SelectionTextColor = clHighlightText
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
          183
          64)
        RowHeights = (
          25
          27)
      end
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 521
    Width = 1215
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 2
    object statuspanelSum: TRzStatusPane
      Left = 0
      Top = 0
      Width = 97
      Height = 19
      Align = alLeft
      Caption = #35831#26597#35810#25968#25454
    end
    object RzStatusPane1: TRzStatusPane
      Left = 97
      Top = 0
      Width = 68
      Height = 19
      Align = alLeft
      Caption = #36827#24230':'
      ExplicitLeft = 153
    end
    object ProgressStatus1: TRzProgressStatus
      Left = 165
      Top = 0
      Width = 1050
      Height = 19
      Align = alClient
      ParentShowHint = False
      PartsComplete = 0
      Percent = 0
      ShowPercent = True
      TotalParts = 0
      ExplicitLeft = 898
      ExplicitWidth = 100
      ExplicitHeight = 20
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.xls'
    Filter = '*.xls|*.xls|*.xlsx|*.xlsx'
    Left = 584
    Top = 208
  end
  object PopupMenu1: TPopupMenu
    Left = 784
    Top = 200
    object N1: TMenuItem
      Action = actCopyCell
      Visible = False
    end
    object N2: TMenuItem
      Action = actPasteCell
      Visible = False
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = actInsert
    end
    object N5: TMenuItem
      Action = actRemove
    end
  end
  object ActionList1: TActionList
    Left = 728
    Top = 208
    object actCopyCell: TAction
      Caption = #22797#21046
      OnExecute = actCopyCellExecute
    end
    object actPasteCell: TAction
      Caption = #31896#36148
      OnExecute = actPasteCellExecute
    end
    object actInsert: TAction
      Caption = #22686#21152#35745#21010
      OnExecute = actInsertExecute
    end
    object actRemove: TAction
      Caption = #21024#38500#35745#21010
      OnExecute = actRemoveExecute
    end
  end
end
