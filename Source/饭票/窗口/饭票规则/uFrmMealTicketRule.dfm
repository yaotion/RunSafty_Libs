object FrmMealTicketRule: TFrmMealTicketRule
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #39277#31080#21457#25918#37197#32622
  ClientHeight = 339
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 339
    Align = alClient
    BevelWidth = 5
    BorderOuter = fsNone
    TabOrder = 0
    object RzPanel3: TRzPanel
      Left = 0
      Top = 0
      Width = 596
      Height = 339
      Align = alClient
      BorderOuter = fsNone
      TabOrder = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 596
        Height = 292
        Align = alClient
        TabOrder = 0
        object lvRecord: TListView
          Left = 177
          Top = 13
          Width = 312
          Height = 274
          Columns = <
            item
              Caption = #24207#21495
            end
            item
              Caption = #21517#23383
              Width = 80
            end
            item
              Caption = #26089#39184
              Width = 70
            end
            item
              Caption = #27491#39184
              Width = 70
            end>
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnDblClick = lvRecordDblClick
        end
        object btnViewRoleDetail: TButton
          Left = 495
          Top = 13
          Width = 90
          Height = 33
          Caption = #26597#30475#21253#21547#36710#27425
          TabOrder = 2
          OnClick = btnViewRoleDetailClick
        end
        object TreeView1: TTreeView
          Left = 10
          Top = 13
          Width = 161
          Height = 274
          Align = alCustom
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          Indent = 19
          ParentFont = False
          TabOrder = 0
          OnClick = TreeView1Click
          Items.NodeData = {
            01030000001F0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
            0003B08B0D540F5F1F0000000000000000000000FFFFFFFFFFFFFFFF00000000
            00000000030553584E0F5F1F0000000000000000000000FFFFFFFFFFFFFFFF00
            00000000000000036E8F584E0F5F}
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 292
        Width = 596
        Height = 47
        Align = alBottom
        TabOrder = 1
        object btnAddRule: TButton
          Left = 177
          Top = 1
          Width = 97
          Height = 33
          Caption = #28155#21152#35268#21017
          TabOrder = 0
          OnClick = btnAddRuleClick
        end
        object btnModifyRole: TButton
          Left = 280
          Top = 1
          Width = 97
          Height = 33
          Caption = #20462#25913#35268#21017
          TabOrder = 1
          OnClick = btnModifyRoleClick
        end
        object btnDelRole: TButton
          Left = 383
          Top = 1
          Width = 105
          Height = 33
          Caption = #21024#38500#35268#21017
          TabOrder = 2
          OnClick = btnDelRoleClick
        end
      end
    end
  end
end
