unit uFrmTemplateTrainNoManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, StdCtrls, RzStatus, ExtCtrls, RzPanel,
  RzButton, RzRadChk, Grids, AdvObj, BaseGrid, AdvGrid, PngSpeedButton, RzTabs,
  Menus,uTemplateDayPlan, ActnList,uTFSystem, RzCmboBx,
  AdvSplitter,uLCDayPlan,RsGlobal_TLB,uHttpWebAPI;


const
  WM_Message_Refresh = WM_USER + 1024 ;

type
  TTemplateTrainNoManager = class(TForm)
    RzPanel3: TRzPanel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ActionList1: TActionList;
    actSelectDayPlan: TAction;
    actInsertGroup: TAction;
    actUpdateGroup: TAction;
    actDeleteGroup: TAction;
    Action1: TAction;
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    E1: TMenuItem;
    RzPanel1: TRzPanel;
    btnAdd: TPngSpeedButton;
    btnUpdate: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    cmbDayPlan: TRzComboBox;
    Label1: TLabel;
    btnQuery: TPngSpeedButton;
    Label2: TLabel;
    cmbDayPlanType: TRzComboBox;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    Label4: TLabel;
    lstGroup: TListBox;
    RzPanel2: TRzPanel;
    strGridTrainTrainNo: TAdvStringGrid;
    RzPanel4: TRzPanel;
    Label3: TLabel;
    strGridDaWen: TAdvStringGrid;
    AdvSplitter1: TAdvSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actSelectDayPlanExecute(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure actInsertGroupExecute(Sender: TObject);
    procedure actUpdateGroupExecute(Sender: TObject);
    procedure actDeleteGroupExecute(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure lstGroupClick(Sender: TObject);
    procedure cmbDayPlanChange(Sender: TObject);
    procedure lstGroupDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AdvSplitter1Moved(Sender: TObject);
  private
    m_LCDayTemplate: TRsLCDayTemplate;
    m_DayPlan : TRsDayPlan ;
  private
    { Private declarations }
    //ˢ�½���
    procedure WMMessageRefresh(var Message : TMessage);message WM_Message_Refresh;
    //��ȡѡ�еļƻ�
    function GetSelDayPlanID():Integer;
    //��ȡѡ�е����ε�ID
    function GetSelGroupID:Integer;
    //��ȡѡ�����ε�����
    function GetSelGroupType:Integer ;
    //��ȡѡ�еļƻ����
    function GetSelDayPlanType : Integer ;
    //��ȡѡ�еĳ��������
    procedure GetGroup(DayPlanID:Integer);
    //��ȡ��ǰ��ָ���ĳ���
    function GetSelPlanID():Integer;
    //��ʼ���ƻ���·
    procedure InitWorkShop();
    //��ʼ������
    procedure InitGroup();
    //��ʼ������
    procedure InitData();
    //��ʼ����ϸ�Ļ����ƻ�
    procedure InitTrainNo();
    //ˢ�½���
    procedure Refresh();
    procedure Init;
  public
    webAPIUtils : TWebAPIUtils;
    Global : IGlobal;
  public
    { Public declarations }
    class procedure ManageTemplateTrainNo(AppGlobal : IGlobal);
  end;

var
  TemplateTrainNoManager: TTemplateTrainNoManager;

implementation

uses
  uFrmTemeplateTrainNoGroup,
  uFrmTemeplateTrainNoItem ,uFrmTemeplateDaWenItem;

{$R *.dfm}

{ TTemplateTrainNoManager }

procedure TTemplateTrainNoManager.actDeleteGroupExecute(Sender: TObject);
var
  nSelDayPlanID: Integer ;
  nSelGroupID : Integer ;
begin
  if not TBox('ȷ��ɾ����?') then
    exit ;

  nSelDayPlanID := GetSelDayPlanID();
  if nSelDayPlanID < 0 then
    Exit ;

  nSelGroupID := GetSelGroupID;
  if nSelGroupID <= 0  then
    Exit ;

  m_LCDayTemplate.LCPlanGroup.Delete(nSelDayPlanID,nSelGroupID);

  InitGroup ;
end;

procedure TTemplateTrainNoManager.actInsertGroupExecute(Sender: TObject);
var
  nSelDayPlanID: Integer ;
  DayPlan:TRsDayPlan;
  DayPlanItemGroup:TRsDayPlanItemGroup;
begin
  nSelDayPlanID := GetSelDayPlanID();
  if nSelDayPlanID <= 0  then
    Exit ;
  DayPlan := TRsDayPlan.Create;

  DayPlanItemGroup := TRsDayPlanItemGroup.Create;
  DayPlanItemGroup.DayPlanID := nSelDayPlanID ;
  try
    DayPlan.ID := nSelDayPlanID;

    DayPlan.Name :=  cmbDayPlan.Text;

    TFrmTemeplateTrainNoGroup.Edit(Global,DayPlan,DayPlanItemGroup,True);
  finally
    DayPlan.Free ;
    DayPlanItemGroup.Free ;
    InitGroup ;
  end;
end;

procedure TTemplateTrainNoManager.actSelectDayPlanExecute(Sender: TObject);
begin
  InitData ;
end;

procedure TTemplateTrainNoManager.actUpdateGroupExecute(Sender: TObject);
var
  nSelDayPlanID: Integer ;
  nSelGroupID : Integer ;
  DayPlan:TRsDayPlan;
  DayPlanItemGroup:TRsDayPlanItemGroup;
begin
  nSelDayPlanID := GetSelDayPlanID();

  nSelGroupID := GetSelGroupID;

  if nSelDayPlanID <= 0  then
    Exit ;
  DayPlan := TRsDayPlan.Create;

  DayPlanItemGroup := TRsDayPlanItemGroup.Create;
  m_LCDayTemplate.LCPlanGroup.GetGroup(nSelDayPlanID,nSelGroupID,DayPlanItemGroup);

  try
    DayPlan.ID := nSelDayPlanID;
    DayPlan.Name := cmbDayPlan.Text;
    TFrmTemeplateTrainNoGroup.Edit(GLobal,DayPlan,DayPlanItemGroup,False);
  finally
    DayPlan.Free ;
    DayPlanItemGroup.Free ;
    InitGroup ;
  end;
end;

procedure TTemplateTrainNoManager.AdvSplitter1Moved(Sender: TObject);
begin
    lstGroup.Repaint ;
end;

procedure TTemplateTrainNoManager.btnAddClick(Sender: TObject);
var
  nSelDayPlanID: Integer ;
  nSelGroupID : Integer ;
  DayPlan:TRsDayPlan;
  DayPlanItemGroup:TRsDayPlanItemGroup;
  DayPlanItem:TRsDayPlanItem;
begin
  nSelDayPlanID := GetSelDayPlanID();
  if nSelDayPlanID <= 0  then
    Exit ;

  nSelGroupID := GetSelGroupID;
  if nSelGroupID < 0 then
    Exit  ;

  //��ȡ�ƻ�
  DayPlan := TRsDayPlan.Create;

  DayPlan.ID := nSelDayPlanID;
  DayPlan.Name := cmbDayPlan.Text;

  //��ȡ����
  DayPlanItemGroup := TRsDayPlanItemGroup.Create;

  m_LCDayTemplate.LCPlanGroup.GetGroup(nSelDayPlanID,nSelGroupID,DayPlanItemGroup);

  DayPlanItem := TRsDayPlanItem.Create;
  DayPlanItem.IsTomorrow := 0 ;
  DayPlanItem.DayPlanType := tdayplantype ( GetSelDayPlanType() ) ;
  DayPlanItem.GroupID := DayPlanItemGroup.ID;
  try
    if  DayPlanItemGroup.IsDaWen = 0 then
      TFrmTemeplateTrainNoItem.Edit(Global,DayPlan.Name,DayPlanItemGroup.Name,DayPlanItem,True)
    else
      TFrmTemeplateDaWenItem.Edit(Global, DayPlan.Name,DayPlanItemGroup.Name,DayPlanItem,True);
  finally
    DayPlan.Free ;
    DayPlanItemGroup.Free;
    DayPlanItem.Free ;
    Refresh ;
  end;
end;

procedure TTemplateTrainNoManager.btnDeleteClick(Sender: TObject);
var
  nSelPlanID: Integer ;
begin
  if not TBox('ȷ��ɾ���üƻ���?') then
    exit ;

  nSelPlanID := GetSelPlanID();
  if nSelPlanID < 0 then
    Exit ;

  m_LCDayTemplate.LCPlanModules.DeleteModule(nSelPlanID);
  Refresh ;
end;

procedure TTemplateTrainNoManager.btnQueryClick(Sender: TObject);
begin
  InitData ;
end;

procedure TTemplateTrainNoManager.btnUpdateClick(Sender: TObject);
var
  nSelDayPlanID: Integer ;
  nSelQuDuanID : Integer ;
  DayPlan:TRsDayPlan;
  DayPlanItemGroup:TRsDayPlanItemGroup;
  DayPlanItem:TRsDayPlanItem;
begin
  nSelDayPlanID := GetSelDayPlanID();
  if nSelDayPlanID <= 0  then
    Exit ;

  nSelQuDuanID := GetSelGroupID;
  if nSelQuDuanID < 0 then
    Exit  ;

  //��ȡ�ƻ�
  DayPlan := TRsDayPlan.Create;
  DayPlan.ID := nSelDayPlanID;
  DayPlan.Name := cmbDayPlan.Text;


  //��ȡ����
  DayPlanItemGroup := TRsDayPlanItemGroup.Create;
  m_LCDayTemplate.LCPlanGroup.GetGroup(nSelDayPlanID,nSelQuDuanID,DayPlanItemGroup);


  DayPlanItem := TRsDayPlanItem.Create;

  m_LCDayTemplate.LCPlanModules.GetModule(GetSelPlanID,DayPlanItem);

  try
    if  DayPlanItemGroup.IsDaWen = 0 then
      TFrmTemeplateTrainNoItem.Edit(Global,DayPlan.Name,DayPlanItemGroup.Name,DayPlanItem,False)
    else
      TFrmTemeplateDaWenItem.Edit(Global,DayPlan.Name,DayPlanItemGroup.Name,DayPlanItem,False) ;
  finally
    DayPlan.Free ;
    DayPlanItemGroup.Free;
    DayPlanItem.Free ;
    Refresh ;
  end;
end;

procedure TTemplateTrainNoManager.cmbDayPlanChange(Sender: TObject);
begin
  InitGroup ;
end;

procedure TTemplateTrainNoManager.E1Click(Sender: TObject);
begin
  Close ;
end;

procedure TTemplateTrainNoManager.FormCreate(Sender: TObject);
begin
  lstGroup.Style := lbOwnerDrawVariable ;
  lstGroup.ItemHeight := 30 ;

  strGridTrainTrainNo.Visible := True ;
  strGridDaWen.Visible := False ;

end;

procedure TTemplateTrainNoManager.FormDestroy(Sender: TObject);
begin
  m_DayPlan.Free ;
  m_LCDayTemplate.Free;
  webAPIUtils.free;
end;

procedure TTemplateTrainNoManager.GetGroup(
  DayPlanID: Integer);
begin
  m_LCDayTemplate.LCPlanGroup.QueryGroups(DayPlanID,m_DayPlan.GoupList);
end;

function TTemplateTrainNoManager.GetSelDayPlanID: Integer;
begin
  result := -1;
  if cmbDayPlan.ItemIndex < 0 then exit;
  
  Result := StrToInt(cmbDayPlan.Values[cmbDayPlan.ItemIndex]);

end;



function TTemplateTrainNoManager.GetSelDayPlanType: Integer;
begin
  Result := cmbDayPlanType.ItemIndex ;
end;

function TTemplateTrainNoManager.GetSelPlanID: Integer;
var
  strRet : string ;
begin
  Result := -1 ;
  if strGridTrainTrainNo.Visible then
    strRet :=  strGridTrainTrainNo.Cells[99, strGridTrainTrainNo.row]
  else
    strRet :=  strGridDaWen.Cells[99, strGridDaWen.row] ;
  if Trim(strRet) = '' then exit;
  Result := StrToInt( strRet ) ;
end;

function TTemplateTrainNoManager.GetSelGroupID: Integer;
var
  nIndex : Integer ;
begin
  Result := -1 ;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].ID ;
end;

function TTemplateTrainNoManager.GetSelGroupType: Integer;
var
  nIndex : Integer ;
begin
  Result:=-1;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].IsDaWen ;
end;

procedure TTemplateTrainNoManager.Init;
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=Global.GetProxy.WebAPI.Host;
  webAPIUtils.Port := Global.GetProxy.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  
  m_LCDayTemplate := TRsLCDayTemplate.Create(WebAPIUtils);
  m_DayPlan := TRsDayPlan.Create();
end;

procedure TTemplateTrainNoManager.InitData;
begin
  InitTrainNo ;
end;

procedure TTemplateTrainNoManager.InitGroup;
var
  nSelDayPlanID: Integer ;
  i : Integer ;
begin
  nSelDayPlanID := GetSelDayPlanID();
  if nSelDayPlanID <= 0  then
    Exit ;

  m_DayPlan.GoupList.Clear ;
  GetGroup(nSelDayPlanID);

  lstGroup.Clear ;
  for I := 0 to m_DayPlan.GoupList.Count - 1 do
  begin
    lstGroup.AddItem(m_DayPlan.GoupList.Items[i].Name,m_DayPlan.GoupList.Items[i]);
  end;
end;

procedure TTemplateTrainNoManager.InitTrainNo;
var
  DayPlanItemList: TRsDayPlanItemList ;
  i : Integer ;
  nSelGroupID,nSelGroupType : Integer ;
  nSelDayPlanType : Integer ;
  index : Integer ;
  strTemp : string;
begin
  DayPlanItemList := TRsDayPlanItemList.Create ;
  try
    nSelGroupID := GetSelGroupID;
    if nSelGroupID < 0 then
      Exit ;


    nSelGroupType := GetSelGroupType;
    nSelDayPlanType := GetSelDayPlanType ;

    m_LCDayTemplate.LCPlanModules.QueryModules(nSelGroupID,nSelDayPlanType,DayPlanItemList);

    if nSelGroupType = 0 then
    begin
      strGridTrainTrainNo.Visible := True ;
      strGridDaWen.Visible := False ;

      with strGridTrainTrainNo do
      begin
        ClearRows(1, 10000);
        RowCount := DayPlanItemList.Count + 2;
        for i := 0 to DayPlanItemList.Count - 1 do
        begin
          index := 0 ;
          Cells[index, i + 1] := IntToStr(i + 1);
          Inc(index);

          with  DayPlanItemList.Items[i] do
          begin
            Cells[index, i + 1] := TrainNo1;
            Inc(index);

            Cells[index, i + 1] :=  TrainNo2;
            Inc(index);

            Cells[index, i + 1] :=  TrainNo;
            Inc(index);

            Cells[index, i + 1] :=  Remark;
            Inc(index);

            if IsTomorrow  > 0 then
              strTemp := '��'
            else
              strTemp := '��' ;

            Cells[index, i + 1] :=  strTemp;


            Cells[99, i + 1] := IntToStr(DayPlanItemList.Items[i].id );
          end;
        end;
      end;
    end
    else
    begin
      strGridTrainTrainNo.Visible := False ;
      strGridDaWen.Visible := True ;
      with strGridDaWen do
      begin
        ClearRows(1, 10000);
        RowCount := DayPlanItemList.Count + 2;
        for i := 0 to DayPlanItemList.Count - 1 do
        begin
          index := 0 ;
          Cells[index, i + 1] := IntToStr(i + 1);
          Inc(index);

          with  DayPlanItemList.Items[i] do
          begin
            Cells[index, i + 1] := DaWenCheXing;
            Inc(index);

            Cells[index, i + 1] :=  DaWenCheHao1;
            Inc(index);

            Cells[index, i + 1] :=  DaWenCheHao2;
            Inc(index);

            Cells[index, i + 1] :=  DaWenCheHao3;


            Cells[99, i + 1] := IntToStr(DayPlanItemList.Items[i].id );
          end;
        end;
      end;
    end;
  finally
    DayPlanItemList.Free ;
  end;
end;

procedure TTemplateTrainNoManager.InitWorkShop;
var
  DayPlanList: TRsDayPlanList ;
  i : Integer ;
begin
  DayPlanList := TRsDayPlanList.Create;
  try
    m_LCDayTemplate.LCPlanPlace.QueryPlace(DayPlanList);
    cmbDayPlan.ClearItems;
    for I := 0 to DayPlanList.Count - 1 do
    begin
      cmbDayPlan.AddItemValue(DayPlanList.Items[i].Name,IntToStr(DayPlanList.Items[i].id));
    end;

    cmbDayPlan.ItemIndex := 0;
  finally
    DayPlanList.Free;
  end;
end;

procedure TTemplateTrainNoManager.lstGroupClick(Sender: TObject);
begin
  InitTrainNo ;
end;

procedure TTemplateTrainNoManager.lstGroupDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  strTemp: String;
  rectText : TRect ;
begin
  //�ֱ���������
  strTemp := m_DayPlan.GoupList.Items[Index].Name;
  with lstGroup do
  begin
    //���ñ�����ɫ����䱳��
    lstGroup.Canvas.Brush.Color := clWhite;
    lstGroup.Canvas.FillRect (Rect);

    //����Բ�Ǿ�����ɫ������Բ�Ǿ���
    lstGroup.Canvas.Brush.Color := TColor($00FFF7F7);
    lstGroup.Canvas.Pen.Color := TColor($00131315);

    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 2, Rect.Bottom - 2, 8, 8);
    //�Բ�ͬ�Ŀ�Ⱥ͸߶��ٻ�һ�Σ�ʵ������Ч��
    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //������ɫ
    lstGroup.Canvas.Font.Color := clBlack;
    CopyRect(rectText,Rect);
    //����ǵ�ǰѡ����
    if(odSelected in State) then
    begin
        //�Բ�ͬ�ı���ɫ����ѡ�����Բ�Ǿ���
        lstGroup.Canvas.Brush.Color := TColor($00FFB2B5);
        lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //ѡ�����������ɫ
        lstGroup.Canvas.Font.Color := clBlue;
        //�����ǰ��ӵ�н��㣬��������򣬵�ϵͳ�ٻ���ʱ���XOR����Ӷ��ﵽ������������Ŀ��
        if(odFocused in State) then
        begin
          DrawFocusRect(lstGroup.Canvas.Handle, Rect);
          OffsetRect(rectText,0,1);
        end;
    end;

    lstGroup.Canvas.TextRect(rectText,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  end;
end;

class procedure TTemplateTrainNoManager.ManageTemplateTrainNo(AppGlobal : IGlobal);
var
  TemplateTrainNoManager : TTemplateTrainNoManager ;
begin
  TemplateTrainNoManager:= TTemplateTrainNoManager.Create(nil);
  try
    TemplateTrainNoManager.Global := AppGlobal;
    TemplateTrainNoManager.Init;
    TemplateTrainNoManager.InitWorkShop;
    TemplateTrainNoManager.InitGroup;
    //TemplateTrainNoManager.InitData;
    TemplateTrainNoManager.ShowModal ;
  finally
    TemplateTrainNoManager.Free;
  end;
end;


procedure TTemplateTrainNoManager.Refresh;
begin
  PostMessage(Handle,WM_Message_Refresh,0,0);
end;


procedure TTemplateTrainNoManager.WMMessageRefresh(var Message: TMessage);
begin
  InitData ;
end;

end.
