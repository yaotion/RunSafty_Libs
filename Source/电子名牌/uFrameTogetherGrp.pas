unit uFrameTogetherGrp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameNamePlate,uTrainmanJiaolu,uScrollView,Menus,uLCNameBoardEx,
  uOrderGroupInTrainView,uTogetherTrainView,uTrainmanView, ExtCtrls, RzPanel,
  uDrinkExtls,uApparatusCommon,uDrink,uLCBeginwork;

type
  TTmMenuActions = class;
  TGrpMenuActions = class;
  TTrainMenuActions = class;
  
  TFrameTogetherGrp = class(TFrameNamePlate)
    PopupMenu_View: TPopupMenu;
    PopupMenu_Control: TPopupMenu;
    N1: TMenuItem;
    procedure PopupMenu_ViewPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    m_TmMenuActions: TTmMenuActions;
    m_GrpMenuActions: TGrpMenuActions;
    m_TrainMenuActions: TTrainMenuActions;
  protected
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);override;
    procedure OnDropMode(src,dest: TView;X,Y: integer;var Mode: TDropMode);override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure RefreshViews();override;
    function Search(Tm: PTm): Boolean;override;
    procedure ExportPlates(const FileName: string);override;
  end;


  TShareActions = class(TComponent)
  public
    constructor NewCreate(Frame: TFrameTogetherGrp);
    destructor Destroy;override;
  protected
    m_Frame: TFrameTogetherGrp;

    m_InputJl: TRsLCBoardInputJL;

    m_InputDuty: TRsLCBoardInputDuty;

    procedure AddGrp(Sender: TObject);

  public
    procedure RefreshGrpView(View: TView);
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);virtual;
    procedure ViewPlan(Sender: TObject);
    procedure RemovePlan(Sender: TObject);
  end;

  TTrainMenuActions = class(TShareActions)
  public
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);override;
    procedure Add(Sender: TObject);
    procedure Del(Sender: TObject);
    procedure Edit(Sender: TObject);
    procedure Exchange(Sender: TObject);
    procedure TurnGroup(Sender : TObject);
    procedure InsertGrp(View,Dest: TView);
  end;

  
  TGrpMenuActions = class(TShareActions)
  private
    function GrpIsNull(View: TView): Boolean;
  public
    procedure CreateMenus2(View: TView;PopMenu: TPopupMenu);
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);override;

    procedure DelGrp(Sender: TObject);
    procedure Exchange(Src,Dest: TOrderGroupInTrainView);
    procedure Insert(View,Dest: TOrderGroupInTrainView;Mode: TDropMode);
    procedure GrpTx(Sender: TObject);

    procedure EndPlan(Sender:TObject);
  end;

  TTmMenuActions = class(TShareActions)
  private

  public
    procedure CreateMenus2(View: TView;PopMenu: TPopupMenu);
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);override;
    procedure SetTM(Sender: TObject);
    procedure ViewTM(Sender: TObject);
    procedure RemoveTm(Sender: TObject);
    procedure Exchange(Src,Dest: TTrainmanView);
    procedure AskLeave(Sender: TObject);
     procedure ImportCQDrink(Sender: TObject);
    procedure ImportTQDrink(Sender: TObject);
  end;


implementation

uses
  uWebApiCollection,
  uOrderGroupView,
  uDialogsLib,
  uSaftyEnum,
  uGlobal,
  uFrmAddJiChe,
  uTFSystem,
  uValidator,
  uTrainman,
  uFrmAddUser,
  uTrainPlan,
  DateUtils,
  uFrmDrinkInfo,
  uNamePlatesExporter,
  ufrmTrainmanDetail;

{$R *.dfm}

{ TFrameTogetherGrp }

constructor TFrameTogetherGrp.Create(AOwner: TComponent);
begin
  inherited;
  m_ScrollView.DropModePopMenu.SetValidMode([dmExchange,dmCancel]);
  m_ScrollView.PopupMenu := PopupMenu_Control;  
  m_TmMenuActions := TTmMenuActions.NewCreate(self);
  m_GrpMenuActions := TGrpMenuActions.NewCreate(self);
  m_TrainMenuActions := TTrainMenuActions.NewCreate(self);
  m_ScrollView.ViewPopMenue := PopupMenu_View;
end;

procedure TFrameTogetherGrp.ExportPlates(const FileName: string);
var
  I, J: Integer;
  OrderGroup: RRsOrderGroup;
  NpLst: TNpTrainList;
  NpTrain: TNpTrain;
  NpGrp: TNpGrp;
begin
  NpLst := TNpTrainList.Create;
  try
    for I := 0 to m_ScrollView.Views.Count - 1 do
    begin

      with (m_ScrollView.Views[i] as TTogetherTrainView) do
      begin
        NpTrain := TNpTrain.Create;
        NpLst.Add(NpTrain);
        NpTrain.TypeName := TogetherTrain.strTrainTypeName;
        NpTrain.Number := TogetherTrain.strTrainNumber;

        for J := 0 to Items.Count - 1 do
        begin
          NpGrp := TNpGrp.Create;
          NpTrain.GrpList.Add(NpGrp);
          OrderGroup := (Items[J] as TOrderGroupInTrainView).OrderGroup;
           
          NpGrp.Tm1.Number := OrderGroup.Group.Trainman1.strTrainmanNumber;
          NpGrp.Tm1.Name := OrderGroup.Group.Trainman1.strTrainmanName;
          NpGrp.Tm2.Number := OrderGroup.Group.Trainman2.strTrainmanNumber;
          NpGrp.Tm2.Name := OrderGroup.Group.Trainman2.strTrainmanName;
          NpGrp.Tm3.Number := OrderGroup.Group.Trainman3.strTrainmanNumber;
          NpGrp.Tm3.Name := OrderGroup.Group.Trainman3.strTrainmanName;
        end;
      end;

    end;
    
    TNamePlatesExport.ExportPlates(FileName,TmJl.Name,NpLst);
  finally
    NpLst.Free;
  end;
end;
procedure TFrameTogetherGrp.N1Click(Sender: TObject);
begin
  m_TrainMenuActions.Add(Sender);
end;

procedure TFrameTogetherGrp.OnDragViewOver(src, dest: TView;
  var Accept: Boolean);
begin
  Accept := src.ClassType = dest.ClassType;
  if (dest is TTogetherTrainView) and not Accept then
    Accept := src is TOrderGroupInTrainView;
end;
procedure TFrameTogetherGrp.OnDropMode(src, dest: TView; X, Y: integer;
  var Mode: TDropMode);
var
  pt: TPoint;
begin
  if (src is TTrainmanView) and (dest is TTrainmanView) then
  begin
    Mode := dmExchange;
    m_TmMenuActions.Exchange(src as TTrainmanView,dest as TTrainmanView);
    Exit;
  end;

  GetCursorPos(pt);
  if (src is TOrderGroupInTrainView) and (dest is TOrderGroupInTrainView) then
  begin
    Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
    case Mode of
      dmInsertLeft: ;
      dmInsertRight: ;
      dmInsertChild: ;
      dmExchange: m_GrpMenuActions.Exchange(src as TOrderGroupInTrainView,dest as TOrderGroupInTrainView);
      dmCancel: Exit;
    end;
  end;
  
  if dest is TTogetherTrainView then
  begin
    if src is TTogetherTrainView then
    begin
      Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
    end
    else
    begin
      Mode := dmInsertChild;
      m_TrainMenuActions.InsertGrp(src,dest);
    end;
  end;
end;


procedure TFrameTogetherGrp.PopupMenu_ViewPopup(Sender: TObject);
begin
  if m_ScrollView.PopupView is TTrainmanView then
    m_TmMenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View)
  else
  if m_ScrollView.PopupView is TOrderGroupInTrainView then
    m_GrpMenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View)
  else
  if m_ScrollView.PopupView is TTogetherTrainView then  
    m_TrainMenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View)

end;

procedure TFrameTogetherGrp.RefreshViews;
var
  GrpArray : TRsTogetherTrainArray;
  View : TTogetherTrainView;
  Err: string;
  i: integer;
begin

  if not LCWebAPI.LCNameBoard.GetTogetherGroup(m_TmJl.ID,GrpArray,Err) then
  begin
    TMessageBox.Err(Err);
    Exit;
  end;

  m_ScrollView.Views.BeginUpdate;
  try
    m_ScrollView.Views.Clear;
    for i := 0 to length(GrpArray) - 1 do
    begin
      View := TTogetherTrainView.Create();
      View.TogetherTrain := GrpArray[i];
      m_ScrollView.Views.AddView(View);
    end;
  finally
    m_ScrollView.Views.EndUpdate;
  end;
  
end;

function TFrameTogetherGrp.Search(Tm: PTm): Boolean;
var
  i,j,k: Integer;
  grpView: TView;
begin
  Result := False;
  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin
    with m_ScrollView.Views[i] as TTogetherTrainView do
    begin
      for j := 0 to Items.Count - 1 do
      begin
        grpView := Items[j];
        with TOrderGroupView(Items[j]) as TOrderGroupView do
        begin
          for k := 0 to Items.Count - 1 do
          begin
            if (Items[k] as TTrainmanView).Trainman.strTrainmanNumber = Tm.strTrainmanNumber then
            begin
              Result := True;
              m_ScrollView.MakeVisible(grpView,true);
              Exit;
            end;

          end;
        end;
      end;
    end;
  end;
end;


{ TTrainMenuActions }

procedure TTrainMenuActions.Add(Sender: TObject);
var
  Train : RRsTogetherTrain;
  View: TTogetherTrainView;
begin
  FillChar(Train,SizeOf(Train),0);
  if not TFrmAddJiChe.InputTrainInfo(Train.strTrainTypeName,
    Train.strTrainNumber) then Exit;

  if LCWebAPI.LCNameBoardEx.Together.ExistTrain(Train.strTrainTypeName,Train.strTrainNumber) then
  begin
    BoxErr(Format('%s - %s  机车已经存在!',[Train.strTrainTypeName,Train.strTrainNumber]));
    Exit ;
  end;

  with Train do
  begin
    strTrainGUID := NewGUID;
    strTrainmanJiaoluGUID := m_Frame.m_TmJl.ID;

    LCWebAPI.LCNameBoardEx.Together.AddTrain(
      strTrainmanJiaoluGUID,
      strTrainGUID,
      strTrainTypeName,
      strTrainNumber);
  end;


  View := TTogetherTrainView.Create();
  View.TogetherTrain := Train;
  m_Frame.m_ScrollView.Views.AddView(View);
end;

procedure TTrainMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;
  with View as TTogetherTrainView do
  begin
    AddMenuItem('添加机车',Add,PopMenu);
      
    AddMenuItem('修改机车',Edit,PopMenu);

    AddMenuItem('-',nil,PopMenu);
    
    AddMenuItem('删除机车',Del,PopMenu).Enabled := View.Items.Count = 0;

    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('添加机组',AddGrp,PopMenu);
    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('翻牌',TurnGroup,PopMenu);
  end;

end;

procedure TTrainMenuActions.Del(Sender: TObject);
var
  Train : RRsTogetherTrain;
begin
  Train := (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).TogetherTrain;

  if not TBox('您确定要删除此包乘机车吗？') then Exit;
  
  LCWebAPI.LCNameBoardEx.Together.DeleteTrain(Train.strTrainGUID);

  m_Frame.m_ScrollView.PopupView.Owner.Remove(m_Frame.m_ScrollView.PopupView);
end;

procedure TTrainMenuActions.Edit(Sender: TObject);
var
  Train : RRsTogetherTrain;
begin
  Train := (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).TogetherTrain;

  if not TFrmAddJiChe.InputTrainInfo(Train.strTrainTypeName,
    Train.strTrainNumber) then Exit;

  if LCWebAPI.LCNameBoardEx.Together.ExistTrain(Train.strTrainTypeName,Train.strTrainNumber) then
  begin
    BoxErr(Format('%s - %s  机车已经存在!',[Train.strTrainTypeName,Train.strTrainNumber]));
    Exit ;
  end;


  LCWebAPI.LCNameBoardEx.Together.UpdateTrain(Train.strTrainGUID,
  Train.strTrainTypeName,Train.strTrainNumber);

  (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).TogetherTrain := Train;
  (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).Invalidate;
end;


procedure TTrainMenuActions.Exchange(Sender: TObject);
begin

end;

procedure TTrainMenuActions.InsertGrp(View,Dest: TView);
begin
  if (not (View is TOrderGroupInTrainView)) or (not (Dest is TTogetherTrainView)) then
    Exit;

  with (Dest as TTogetherTrainView),(View as TOrderGroupInTrainView) do
  begin
    LCWebAPI.LCNameBoardEx.Together.Group.ChangeTrain(TogetherTrain.strTrainGUID,
    OrderGroupInTrain.Group.strGroupGUID);
  end;


end;

procedure TTrainMenuActions.TurnGroup(Sender: TObject);
var
  Train,trainNew : RRsTogetherTrain;
begin
  Train := (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).TogetherTrain;

  LCWebAPI.LCNameBoardEx.Together.TurnTogetherTrainGroup(Train.strTrainGUID);

  LCWebAPI.LCNameBoardEx.Together.GetTrain(Train.strTrainGUID,trainNew);

  (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).TogetherTrain := trainNew;
  (m_Frame.m_ScrollView.PopupView as TTogetherTrainView).Invalidate;

end;

{ TGrpMenuActions }
procedure TGrpMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;
  with View as TOrderGroupView do
  begin
    if DebugHook = 0 then
    begin
      AddMenuItem('添加机组',AddGrp,PopMenu);
      AddMenuItem('-',nil,PopMenu);
    end;
    AddMenuItem('查看计划...',ViewPlan,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning,tsRuning];
    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('删除机组',DelGrp,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsNormal];

    AddMenuItem('-',nil,PopMenu);
            
    AddMenuItem('移除计划',RemovePlan,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning];
    AddMenuItem('-',nil,PopMenu);


    AddMenuItem('异常终止',EndPlan,PopMenu).Enabled :=
       OrderGroup.Group.GroupState in [tsPlaning,tsRuning];
  end;
end;

procedure TGrpMenuActions.CreateMenus2(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;

  with View as TOrderGroupInTrainView do
  begin
    AddMenuItem('添加机组',AddGrp,PopMenu);
    AddMenuItem('删除机组',DelGrp,PopMenu).Enabled :=
      (not (OrderGroupInTrain.Group.GroupState in [tsPlaning,tsRuning]))
      and GrpIsNull(View);

    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('查看计划...',ViewPlan,PopMenu).Enabled :=
      OrderGroupInTrain.Group.GroupState in [tsPlaning,tsRuning];

    AddMenuItem('移除计划',RemovePlan,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning];

    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('调休',GrpTx,PopMenu).Enabled :=
      not (OrderGroupInTrain.Group.GroupState in [tsPlaning,tsRuning]);
  end;
end;


procedure TGrpMenuActions.DelGrp(Sender: TObject);
begin
  m_Frame.DoFillParam(m_InputJL,m_InputDuty);
  if not (m_Frame.m_ScrollView.PopupView is TOrderGroupInTrainView) then Exit;

  with m_Frame.m_ScrollView.PopupView as TOrderGroupInTrainView do
  begin
    LCWebAPI.LCNameBoardEx.Group.Delete(m_InputJL,OrderGroupInTrain.Group.strGroupGUID,m_InputDuty);
  end;

  m_Frame.m_ScrollView.PopupView.Owner.Remove(m_Frame.m_ScrollView.PopupView);

end;

procedure TGrpMenuActions.EndPlan(Sender: TObject);
var
  strError :string;
  strPlanIDs : TStrings;
begin
 if not TBox('您确认要终止该名牌值乘的计划吗，此操作仅适合异常情况操作') then
   exit;
 with m_Frame.m_ScrollView do
  begin
    with PopupView as TOrderGroupInTrainView do
    begin
      strPlanIDs := TStringList.Create;
      try
        strPlanIDs.Add(OrderGroup.Group.strTrainPlanGUID);
        if not LCWebAPI.LCTrainPlan.CancelTrainPlan(strPlanIDs,GlobalDM.User.ID,true,strError) then
        begin
          Box('终止计划操作失败:' + strError);
        end;
        m_Frame.RefreshViews;
      finally
        strPlanIDs.Free;
      end;
    end;
  end;
end;

procedure TGrpMenuActions.Exchange(Src, Dest: TOrderGroupInTrainView);
var
  srcGrp: string;
  destGrp: string;
  GroupInTrain1,GroupInTrain2,GroupInTrain3: RRsOrderGroupInTrain;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);

  srcGrp := Src.OrderGroupInTrain.Group.strGroupGUID;

  destGrp := Dest.OrderGroupInTrain.Group.strGroupGUID;


  //由于WEB接口交换机组只是交换了Group的部分，在界面上需要把OrderGroupInTrain的数据重新还原
  LCWebAPI.LCNameBoardEx.Group.Swap(m_InputJL,m_InputDuty,srcGrp,destGrp);


  {$region '间把整个机组视图都交换了位置，需要把机车ID、序号等信息还原'}
  GroupInTrain1 := Src.OrderGroupInTrain;
  GroupInTrain2 := Dest.OrderGroupInTrain;

  GroupInTrain3 := GroupInTrain1;

  GroupInTrain1.strOrderGUID := GroupInTrain2.strOrderGUID;
  GroupInTrain1.strTrainGUID := GroupInTrain2.strTrainGUID;
  GroupInTrain1.nOrder := GroupInTrain2.nOrder;
  GroupInTrain1.dtLastArriveTime := GroupInTrain2.dtLastArriveTime;


  GroupInTrain2.strOrderGUID := GroupInTrain3.strOrderGUID;
  GroupInTrain2.strTrainGUID := GroupInTrain3.strTrainGUID;
  GroupInTrain2.nOrder := GroupInTrain3.nOrder;
  GroupInTrain2.dtLastArriveTime := GroupInTrain3.dtLastArriveTime;

  Src.OrderGroupInTrain := GroupInTrain1;
  Dest.OrderGroupInTrain := GroupInTrain2;

  {$endregion}

end;

function TGrpMenuActions.GrpIsNull(View: TView): Boolean;
var
  I: Integer;
begin
  Result := True;

  if View is TOrderGroupInTrainView then
  begin
    for I := 0 to View.Items.Count - 1 do
    begin
      if (View.Items[i] as TTrainmanView).Trainman.strTrainmanGUID <> '' then
      begin
        Result := False;
        Break;
      end;
    end;
  end
  else
    raise Exception.Create('View 不是机组类型!');
end;

procedure TGrpMenuActions.GrpTx(Sender: TObject);
begin
  m_Frame.DoFillParam(m_InputJL,m_InputDuty);
  if not (m_Frame.m_ScrollView.PopupView is TOrderGroupInTrainView) then Exit;

  with m_Frame.m_ScrollView.PopupView as TOrderGroupInTrainView do
  begin
    TNPCommonLogic.GrpTX(m_InputJl,m_InputDuty,OrderGroupInTrain.Group.strGroupGUID);
  end;

  m_Frame.m_ScrollView.PopupView.Owner.Remove(m_Frame.m_ScrollView.PopupView);

end;

procedure TGrpMenuActions.Insert(View, Dest: TOrderGroupInTrainView;
  Mode: TDropMode);
begin

end;

{ TTmMenuActions }

procedure TTmMenuActions.AskLeave(Sender: TObject);
begin
  with m_Frame.m_ScrollView.PopupView as TTrainmanView do
  begin
    if LeaveLib.Askfor(Trainman.strTrainmanNumber) then
    begin
      RefreshGrpView(Parent);
    end;
  end;
end;

procedure TTmMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;
  with View.Parent as TOrderGroupView do
  begin
    AddMenuItem('人员信息',ViewTM,PopMenu);
    AddMenuItem('-',nil,PopMenu);
  
    AddMenuItem('设置人员',SetTM,PopMenu).Enabled :=
        not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning]);
      AddMenuItem('-',nil,PopMenu);  
    AddMenuItem('移除人员',RemoveTm,PopMenu).Enabled :=
      not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID <> '');
    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('导入出勤测酒',ImportCQDrink,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning];
    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('导入退勤勤测酒',ImportTQDrink,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsRuning];
    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('请假',AskLeave,PopMenu).Enabled :=
      not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID <> '');
  end;
end;

procedure TTmMenuActions.CreateMenus2(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;
  with View.Parent as TOrderGroupView do
  begin
    AddMenuItem('设置人员',SetTM,PopMenu).Enabled :=
      not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID = '');
      
    AddMenuItem('移除人员',RemoveTm,PopMenu).Enabled :=
      not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID <> '');

    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('查看计划...',ViewPlan,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning,tsRuning];

    AddMenuItem('移除计划',RemovePlan,PopMenu).Enabled :=
      OrderGroup.Group.GroupState in [tsPlaning];

    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('请假',AskLeave,PopMenu).Enabled :=
      not (OrderGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID <> '');
  end;

end;

procedure TTmMenuActions.Exchange(Src, Dest: TTrainmanView);
var
  srcGrp, srcTm: string; srcPos: integer;
  destGrp, destTm: string; destPos: integer;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);

  srcTm := Src.Trainman.strTrainmanGUID;

  srcGrp := (Src.Parent as TOrderGroupInTrainView).OrderGroupInTrain.Group.strGroupGUID;

  srcPos := Src.Parent.Items.IndexOf(Src) + 1;


  destTm := Dest.Trainman.strTrainmanGUID;

  destGrp := (Dest.Parent as TOrderGroupInTrainView).OrderGroupInTrain.Group.strGroupGUID;

  destPos := Dest.Parent.Items.IndexOf(Dest) + 1;

  LCWebAPI.LCNameBoardEx.Group.ExchangeTm(m_InputJl,m_InputDuty,
    srcGrp,srcTm,srcPos,
    destGrp,destTm,destPos);

end;



procedure TTmMenuActions.ImportCQDrink(Sender: TObject);
var
  DrinkQuery: RRsDrinkQuery;
  tmView: TTrainmanView;
  groupView : TOrderGroupInTrainView;
  Verify: TRsRegisterFlag;
  tmPlan,trainmanPlan : RRsTrainmanPlan;
  Trainman: RRsTrainman;
  strTrainPlanGUID,strError : string;
  DrinkInfo: RRsDrinkInfo;
  TestResult: RTestAlcoholInfo;
  RDrink: RRsDrink;
begin
  if not (m_Frame.m_ScrollView.PopupView is TTrainmanView) then
    exit;
  tmView := m_Frame.m_ScrollView.PopupView as TTrainmanView;
  if tmView.Trainman.strTrainmanNumber = '' then
  begin
    box('不能导入空人员的测酒记录');
    exit;
  end;
  groupView := tmView.Parent as TOrderGroupInTrainView;
  strTrainPlanGUID := groupView.OrderGroupInTrain.Group.strTrainPlanGUID;
  if not LCWebAPI.LCTrainPlan.GetTrainmanPlanByGUID(strTrainPlanGUID,tmPlan,strError) then
  begin
     Box('机组值乘的计划不存在，不能导入测酒记录:' + strError);
     exit;
  end;

  DrinkQuery.nWorkTypeID := DRINK_TEST_CHU_QIN ;
  DrinkQuery.strTrainmanNumber := tmView.Trainman.strTrainmanNumber;
  DrinkQuery.dtBeginTime := IncHour(tmPlan.TrainPlan.dtStartTime, -6); //出勤计划前6小时
  DrinkQuery.dtEndTime := IncHour(tmPlan.TrainPlan.dtStartTime, 6); //出勤计划后3小时
  if TFrmDrinkInfo.ShowForm(dfServer, DrinkQuery, DrinkInfo) <> mrOK then exit;

  TestResult.dtTestTime := DrinkInfo.dtCreateTime;
  TestResult.taTestAlcoholResult := TTestAlcoholResult(DrinkInfo.nDrinkResult);
  TestResult.Picture := DrinkInfo.DrinkImage;
  TestResult.nAlcoholicity := DrinkInfo.dwAlcoholicity;

  trainmanPlan.Group := tmPlan.Group;
  trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
  trainmanPlan.TrainPlan := tmPlan.TrainPlan;
  trainmanPlan.dtBeginWorkTime := tmPlan.dtBeginWorkTime;

  LCWebAPI.LCTrainmanMgr.GetTrainmanByNumber(DrinkInfo.strTrainmanNumber, Trainman);
  Verify := TRsRegisterFlag(DrinkInfo.nVerifyID);
  if not TBox(Format('您确认要导入“%s[%s]”的测酒记录吗？', [Trainman.strTrainmanName, Trainman.strTrainmanNumber])) then exit;

  //人员信息
  RDrink.bLocalAreaTrainman := true;
  RDrink.strTrainmanGUID := Trainman.strTrainmanGUID ;
  RDrink.strTrainmanName := Trainman.strTrainmanName ;
  RDrink.strTrainmanNumber := Trainman.strTrainmanNumber;
  //车次信息
  RDrink.strTrainNo :=  trainmanPlan.TrainPlan.strTrainNo ;
  RDrink.strTrainNumber :=  trainmanPlan.TrainPlan.strTrainNumber ;
  RDrink.strTrainTypeName :=  trainmanPlan.TrainPlan.strTrainTypeName ;
  //出勤点信息
  RDrink.strPlaceID := '' ;
  RDrink.strPlaceName := '';
  RDrink.strSiteIp := GlobalDM.Site.Number;
  RDrink.strSiteGUID := GlobalDM.Site.ID;
  RDrink.strSiteName := GlobalDM.Site.Name;

  RDrink.strDutyGUID := GlobalDM.User.ID;
  RDrink.strDutyNumber := GlobalDM.User.Number;
  RDrink.strDutyName := GlobalDM.User.Name;

  RDrink.strAreaGUID := Trainman.strAreaGUID;
  

  //车间
  RDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
  RDrink.strWorkShopName := Trainman.strWorkShopName ;

  RDrink.strGUID := DrinkInfo.strGUID ;
  RDrink.AssignFromTestAlcoholInfo(TestResult);
  RDrink.nVerifyID :=  DrinkInfo.nVerifyID ;
  RDrink.strPictureURL := DrinkInfo.strPictureURL;


  LCWebAPI.LCBeginwork.ImportBeginWork(Trainman.strTrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,
  RDrink,Ord(Verify),'手工导入');

  m_Frame.RefreshViews;
end;

procedure TTmMenuActions.ImportTQDrink(Sender: TObject);
var  
  DrinkQuery: RRsDrinkQuery;
  DrinkInfo: RRsDrinkInfo;
  Param: TRelDrinkParam;
  tmView: TTrainmanView;
  groupView : TOrderGroupInTrainView;
  tmPlan : RRsTrainmanPlan;
  strTrainPlanGUID,strError : string;
begin
 if not (m_Frame.m_ScrollView.PopupView is TTrainmanView) then
    exit;
  tmView := m_Frame.m_ScrollView.PopupView as TTrainmanView;
  if tmView.Trainman.strTrainmanNumber = '' then
  begin
    box('不能导入空人员的测酒记录');
    exit;
  end;
  groupView := tmView.Parent as TOrderGroupInTrainView;
  strTrainPlanGUID := groupView.OrderGroupInTrain.Group.strTrainPlanGUID;
  if not LCWebAPI.LCTrainPlan.GetTrainmanPlanByGUID(strTrainPlanGUID,tmPlan,strError) then
  begin
     Box('机组值乘的计划不存在，不能导入测酒记录:' + strError);
     exit;
  end;

  DrinkQuery.nWorkTypeID := DRINK_TEST_TUI_QIN ;
  DrinkQuery.strTrainmanNumber := tmView.Trainman.strTrainmanNumber;
  DrinkQuery.dtBeginTime := tmPlan.TrainPlan.dtStartTime; //出勤计划时间
  DrinkQuery.dtEndTime := IncDay(tmPlan.TrainPlan.dtStartTime, 10); //出勤计划后10天
  if TFrmDrinkInfo.ShowForm(dfServer, DrinkQuery, DrinkInfo) <> mrOK then exit;


  Param := TRelDrinkParam.Create;
  try
    Param.TmGUID := tmView.Trainman.strTrainmanGUID;
    Param.TmNumber := tmView.Trainman.strTrainmanNumber;
    Param.PlanGUID := tmPlan.TrainPlan.strTrainPlanGUID;
    Param.DrinkGUID := DrinkInfo.strGUID;
    Param.DutyGUID := GlobalDM.User.ID;
    Param.SiteGUID := GlobalDM.Site.ID;
    LCWebAPI.LCEndwork.RelDrink(Param);
    m_Frame.RefreshViews;
  finally
    Param.Free;
  end;

end;

procedure TTmMenuActions.RemoveTm(Sender: TObject);
var
  AddInput: TRsLCTrainmanAddInput;
begin
  with m_Frame.m_ScrollView do
  begin
    with PopupView.Parent as TOrderGroupInTrainView do
    begin
      AddInput := TRsLCTrainmanAddInput.Create;
      try
        m_Frame.DoFillParam(AddInput.TrainmanJiaolu,AddInput.DutyUser);
        AddInput.TrainmanNumber := (PopupView as TTrainmanView).Trainman.strTrainmanNumber;
        AddInput.TrainmanIndex := Items.IndexOf(PopupView) + 1;
        AddInput.GroupGUID := OrderGroupInTrain.Group.strGroupGUID;

        if TNPCommonLogic.RemoveTm(AddInput,OrderGroupInTrain.Group) then
          RefreshGrpView(PopupView.Parent);
      finally
        AddInput.Free;
      end;
    end;
  end;
end;

procedure TTmMenuActions.SetTM(Sender: TObject);
var
  AddInput: TRsLCTrainmanAddInput;
begin
  with m_Frame.m_ScrollView do
  begin
    with PopupView.Parent as TOrderGroupInTrainView do
    begin
      if TLocalValidator.IsBusy(PopupView.Parent as TOrderGroupInTrainView) then
      begin
        TMessageBox.Box(TLocalValidator.Reason);
        Exit;
      end;

      AddInput := TRsLCTrainmanAddInput.Create;
      try
        m_Frame.DoFillParam(AddInput.TrainmanJiaolu,AddInput.DutyUser);
        AddInput.TrainmanIndex := PopupView.Parent.Items.IndexOf(PopupView) + 1;;
        AddInput.GroupGUID := OrderGroupInTrain.Group.strGroupGUID;

        if TNPCommonLogic.AddTmToGrp(AddInput) then
        begin
          RefreshGrpView(PopupView.Parent);
        end;
      finally
        AddInput.Free;
      end;
    end;


  end;
end;

procedure TTmMenuActions.ViewTM(Sender: TObject);
var
  TMView : TTrainmanView;
begin
  with m_Frame.m_ScrollView do
  begin
    if PopupView is TTrainmanView then
    begin
      TMView := (PopupView as TTrainmanView);
      if (TMView.Trainman.strTrainmanNumber <> '') then
      begin
        TfrmTrainmanDetail.ViewTrainmanDetail(TMVIEW.Trainman.strTrainmanGUID)
      end;
    end;
  end;
end;

{ TShareActions }

procedure TShareActions.AddGrp(Sender: TObject);
var
  AddParam: TRsLCTogetherGrpInputParam;
  TrainView: TTogetherTrainView;
  Train: RRsTogetherTrain;
begin
  AddParam := TRsLCTogetherGrpInputParam.Create;
  try
    TrainView := nil;
    if m_Frame.m_ScrollView.PopupView is TOrderGroupInTrainView then
    begin
      TrainView := m_Frame.m_ScrollView.PopupView.Parent as TTogetherTrainView;
    end
    else
    if m_Frame.m_ScrollView.PopupView is TTogetherTrainView then
    begin
      TrainView := m_Frame.m_ScrollView.PopupView as TTogetherTrainView;
    end;
    
    if TrainView = nil then Exit;
    
    m_Frame.DoFillParam(AddParam.TrainmanJiaolu,AddParam.DutyUser);

    AddParam.OrderGUID := NewGUID;

    AddParam.Order := 0;
    AddParam.TrainGUID := TrainView.TogetherTrain.strTrainGUID;
//
    LCWebAPI.LCNameBoardEx.Together.Group.Add(AddParam);

    LCWebAPI.LCNameBoardEx.Together.GetTrain(AddParam.TrainGUID,Train);

    TrainView.TogetherTrain := Train;
    TrainView.Invalidate;
  finally
    AddParam.Free;
  end;

end;


procedure TShareActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin

end;

destructor TShareActions.Destroy;
begin
  m_InputDuty.Free;
  m_InputJl.Free;
  inherited;
end;

constructor TShareActions.NewCreate(Frame: TFrameTogetherGrp);
begin
  inherited Create(Frame);
  m_Frame := Frame;
  m_InputJl := TRsLCBoardInputJL.Create();
  m_InputDuty := TRsLCBoardInputDuty.Create;
end;

procedure TShareActions.RefreshGrpView(View: TView);
var
  Grp: RRsOrderGroupInTrain;
  OrgGrp: RRsGroup;
begin
  if not (View is TOrderGroupInTrainView) then raise Exception.Create('View类型错误');

  Grp := (View as TOrderGroupInTrainView).OrderGroupInTrain;

  if LCWebAPI.LCNameBoardEx.Together.Group.GetGroup(Grp.Group.strGroupGUID,OrgGrp) then
  begin
    Grp.Group := OrgGrp;
    (View as TOrderGroupInTrainView).OrderGroupInTrain := Grp;
    View.Invalidate();
  end;
end;

procedure TShareActions.RemovePlan(Sender: TObject);
var
  GroupView: TOrderGroupInTrainView;
begin
  GroupView := nil;
  if m_Frame.m_ScrollView.PopupView is TTrainmanView then
  begin
    GroupView := m_Frame.m_ScrollView.PopupView.Parent as TOrderGroupInTrainView;
  end
  else
  if m_Frame.m_ScrollView.PopupView is TOrderGroupInTrainView then
  begin
    GroupView := m_Frame.m_ScrollView.PopupView as TOrderGroupInTrainView;
  end;

  if GroupView <> nil then
  begin
    if TNPCommonLogic.RemovePlan(GroupView.OrderGroupInTrain.Group.strGroupGUID) then
      RefreshGrpView(GroupView);
  end;

end;

procedure TShareActions.ViewPlan(Sender: TObject);
var
  View: TOrderGroupInTrainView;
begin
  if m_Frame.m_ScrollView.PopupView is TTrainmanView then
  begin
    View := m_Frame.m_ScrollView.PopupView.Parent as TOrderGroupInTrainView;
  end
  else
  if m_Frame.m_ScrollView.PopupView is TOrderGroupInTrainView then
  begin
    View := m_Frame.m_ScrollView.PopupView as TOrderGroupInTrainView;
  end
  else
    Exit;

  TNPCommonLogic.ShowGprPlan(View.OrderGroupInTrain.Group.strGroupGUID);
end;

end.
