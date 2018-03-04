unit uFrameNamedGrp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameNamePlate,uTrainmanJiaolu,uScrollView,uLCNameBoardEx, Menus,
  uTrainmanView,uNamedGroupView, Buttons, PngSpeedButton, ExtCtrls, RzPanel;

type
  TGrpMenuActions = class;
  TTmMenuActions = class;
  
  TFrameNamedGrp = class(TFrameNamePlate)
    PopupMenu_Control: TPopupMenu;
    PopupMenu_View: TPopupMenu;
    btnToLeft: TPngSpeedButton;
    btnToRight: TPngSpeedButton;
    N1: TMenuItem;
    procedure PopupMenu_ViewPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure btnToLeftClick(Sender: TObject);
    procedure btnToRightClick(Sender: TObject);
  private
    { Private declarations }
    m_GrpArray: TRsNamedGroupArray;
    m_GrpMenuActions: TGrpMenuActions;
    m_TmMenuActions: TTmMenuActions;
  protected
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);override;
    procedure OnDropMode(src,dest: TView;X,Y: integer;var Mode: TDropMode);override;
    function CreateView(const Grp: RRsNamedGroup): TNamedGroupView;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure RefreshViews();override;
    function Search(Tm: PTm): Boolean;override;
    procedure ExportPlates(const FileName: string);override;
  end;

  TShareActions = class(TComponent)
  public
    constructor NewCreate(Frame: TFrameNamedGrp);
    destructor Destroy;override;
  protected
    m_Frame: TFrameNamedGrp;

    m_InputJl: TRsLCBoardInputJL;

    m_InputDuty: TRsLCBoardInputDuty;
  public
    procedure RefreshGrpView(View: TView);
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);virtual;
    procedure ViewPlan(Sender: TObject);
    procedure RemovePlan(Sender: TObject);
  end;

  TGrpMenuActions = class(TShareActions)
  public
    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);override;
    procedure AddGrp(Sender: TObject);
    procedure DelGrp(Sender: TObject);
    procedure EdtGrp(Sender: TObject);
    procedure Exchange(Src,Dest: TNamedGroupView);
    procedure Move(View,Dest: TNamedGroupView;Mode: TDropMode);
    procedure GrpTx(Sender: TObject);
  end;

  TTmMenuActions = class(TShareActions)
  public

    procedure CreateMenus(View: TView;PopMenu: TPopupMenu);override;
    procedure SetTM(Sender: TObject);
    procedure RemoveTm(Sender: TObject);
    procedure Exchange(Src,Dest: TTrainmanView);
    procedure AskLeave(Sender: TObject);
  end;


implementation

uses
  uWebApiCollection,
  uDialogsLib,
  uSaftyEnum,
  uGlobal,
  uValidator,
  uFrmAddCheCi,
  uTFSystem,
  uGroupXlsExporter,
  uNamePlatesExporter,
  uTrainman;

{$R *.dfm}

{ TFrameNamedGrp }

procedure TFrameNamedGrp.btnToLeftClick(Sender: TObject);
begin
  if TBox('您确定要翻牌吗?') then
  begin
    LCWebAPI.LCNamedGroup.Turn(TmJl.ID,1);
    RefreshViews();
  end;

end;

procedure TFrameNamedGrp.btnToRightClick(Sender: TObject);
begin
  if TBox('您确定要翻牌吗?') then
  begin
    LCWebAPI.LCNamedGroup.Turn(TmJl.ID,2);
    RefreshViews();
  end;
end;


constructor TFrameNamedGrp.Create(AOwner: TComponent);
begin
  inherited;
  m_GrpMenuActions := TGrpMenuActions.NewCreate(self);
  m_TmMenuActions := TTmMenuActions.NewCreate(Self);
  m_ScrollView.PopupMenu := PopupMenu_Control;
  m_ScrollView.ViewPopMenue := PopupMenu_View;
end;

function TFrameNamedGrp.CreateView(const Grp: RRsNamedGroup): TNamedGroupView;
begin
  Result := TNamedGroupView.Create();
  Result.Margin.Top := 1;
  Result.Margin.Bottom := 3;
  Result.NamedGroup := Grp;
end;

procedure TFrameNamedGrp.ExportPlates(const FileName: string);
var
  I: Integer;
  NamedGroup: RRsNamedGroup;
  NpLst: TNpNamedList;
  NpNamed: TNpNamed;
begin
  NpLst := TNpNamedList.Create;
  try
    for I := 0 to m_ScrollView.Views.Count - 1 do
    begin
      NamedGroup := (m_ScrollView.Views[i] as TNamedGroupView).NamedGroup;
      NpNamed := TNpNamed.Create;
      NpLst.Add(NpNamed);
      NpNamed.Cc1 := NamedGroup.strCheci1;
      NpNamed.Cc2 := NamedGroup.strCheci2;
      NpNamed.NeedRest := NamedGroup.nCheciType = cctRest;
      NpNamed.Grp.Tm1.Number := NamedGroup.Group.Trainman1.strTrainmanNumber;
      NpNamed.Grp.Tm1.Name := NamedGroup.Group.Trainman1.strTrainmanName;
      NpNamed.Grp.Tm2.Number := NamedGroup.Group.Trainman2.strTrainmanNumber;
      NpNamed.Grp.Tm2.Name := NamedGroup.Group.Trainman2.strTrainmanName;
      NpNamed.Grp.Tm3.Number := NamedGroup.Group.Trainman3.strTrainmanNumber;
      NpNamed.Grp.Tm3.Name := NamedGroup.Group.Trainman3.strTrainmanName;
    end;
    TNamePlatesExport.ExportPlates(FileName,TmJl.Name,NpLst);
  finally
    NpLst.Free;
  end;
end;

procedure TFrameNamedGrp.N1Click(Sender: TObject);
begin
  m_GrpMenuActions.AddGrp(nil);
end;

procedure TFrameNamedGrp.OnDragViewOver(src, dest: TView; var Accept: Boolean);
begin
  Accept := src.ClassType = dest.ClassType;
end;

procedure TFrameNamedGrp.OnDropMode(src, dest: TView; X, Y: integer;
  var Mode: TDropMode);
var
  pt: TPoint;
begin
  if src is TTrainmanView then
  begin
    Mode := dmExchange;
    m_TmMenuActions.Exchange(src as TTrainmanView,dest as TTrainmanView);
  end
  else
  if src is TNamedGroupView then
  begin
    GetCursorPos(pt);
    Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
    case Mode of
      dmInsertLeft,dmInsertRight:
        m_GrpMenuActions.Move(src as TNamedGroupView, dest as TNamedGroupView,Mode);
        
      dmExchange:
        m_GrpMenuActions.Exchange(src as TNamedGroupView,dest as TNamedGroupView);
    end;
  end
  else
    Mode := dmCancel;
end;


procedure TFrameNamedGrp.PopupMenu_ViewPopup(Sender: TObject);
begin
  if m_ScrollView.PopupView is TTrainmanView then
    m_TmMenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View)
  else
    m_GrpMenuActions.CreateMenus(m_ScrollView.PopupView,PopupMenu_View);
end;


procedure TFrameNamedGrp.RefreshViews;
var
  Err: string;
  GrpArray: TRsNamedGroupArray;
  i: integer;
  View: TNamedGroupView;
begin
  if not LCWebAPI.LCNameBoard.GetNamedGroup(m_TmJl.ID,GrpArray,Err) then
  begin
    TMessageBox.Err(Err);
    Exit;
  end;

  m_GrpArray := GrpArray;
  m_ScrollView.Views.BeginUpdate;
  try
    m_ScrollView.Views.Clear;

    for i := 0 to length(m_GrpArray) - 1 do
    begin
      m_GrpArray[i].nCheciOrder := i + 1;
      View := CreateView(m_GrpArray[i]);
      m_ScrollView.Views.AddView(View);
    end;
    
  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

function TFrameNamedGrp.Search(Tm: PTm): Boolean;
var
  i,j: Integer;
begin
  Result := False;
  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin

    for j := 0 to m_ScrollView.Views[i].Items.Count - 1 do
    begin
      if (m_ScrollView.Views[i].Items[j] as TTrainmanView).Trainman.strTrainmanNumber = Tm.strTrainmanNumber then
      begin
        Result := True;
        m_ScrollView.MakeVisible(m_ScrollView.Views[i],true);
        Exit;
      end;
    end;
  end;
end;

{ TGrpMenuActions }

procedure TGrpMenuActions.AddGrp(Sender: TObject);
var
  ccID,cc1,cc2: string;
  bRest: Boolean;
  nOrder: integer;
  ccType: integer;
  NamedGroup: RRsNamedGroup;
begin
  if not TFrmAddCheCi.GetCheCiInfo(cc1,cc2,bRest) then exit;

  if Sender = nil then
  begin
    nOrder := m_Frame.m_ScrollView.Views.Count + 1;
  end
  else
  begin
    nOrder := m_Frame.m_ScrollView.Views.IndexOf(m_Frame.m_ScrollView.PopupView) + 2;
  end;

  if bRest then
    ccType := Ord(cctRest)
  else
    ccType := Ord(cctCheci);

  ccID := NewGUID;
  LCWebAPI.LCNameBoardEx.Named.GroupV2.Insert(ccID,cc1,cc2,ccType,nOrder);

  //需要增加通过车次ID获取机组的接口
  LCWebAPI.LCNameBoardEx.Named.GroupV2.Get(ccID,NamedGroup);

  NamedGroup.nCheciOrder := nOrder;

  m_Frame.m_ScrollView.Views.Insert(nOrder - 1,m_Frame.CreateView(NamedGroup));

  m_Frame.m_ScrollView.Invalidate();
end;

procedure TGrpMenuActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin
  PopMenu.Items.Clear;

  with View as TNamedGroupView do
  begin
    AddMenuItem('添加机组',AddGrp,PopMenu);
    AddMenuItem('删除机组',DelGrp,PopMenu).Enabled :=
      (not (NamedGroup.Group.GroupState in [tsPlaning,tsRuning]))
      and (TNullViewChecker.IsNull(View as TNamedGroupView));
    AddMenuItem('修改车次',EdtGrp,PopMenu);
    AddMenuItem('-',nil,PopMenu);
    AddMenuItem('查看计划...',ViewPlan,PopMenu).Enabled :=
      NamedGroup.Group.GroupState in [tsPlaning,tsRuning];

    AddMenuItem('移除计划',RemovePlan,PopMenu).Enabled :=
      NamedGroup.Group.GroupState in [tsPlaning];

    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('调休',GrpTx,PopMenu).Enabled :=
      not (NamedGroup.Group.GroupState in [tsPlaning,tsRuning]);
  end;
end;
procedure TGrpMenuActions.DelGrp(Sender: TObject);
var
  GrpID: string;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);

  GrpID := (m_Frame.m_ScrollView.PopupView as TNamedGroupView).NamedGroup.Group.strGroupGUID;
  LCWebAPI.LCNameBoardEx.Named.Group.Delete(m_InputJl,GrpID,m_InputDuty);
  m_Frame.m_ScrollView.Views.Remove(m_Frame.m_ScrollView.PopupView);
  m_Frame.m_ScrollView.Invalidate();
end;

procedure TGrpMenuActions.EdtGrp(Sender: TObject);
var
  ccID,cc1,cc2: string;
  bRest: Boolean;
  ccType: integer;
  Group: RRsNamedGroup;
begin
  with (m_Frame.m_ScrollView.PopupView as TNamedGroupView) do
  begin
    cc1 := NamedGroup.strCheci1;
    cc2 := NamedGroup.strCheci2;
    bRest := NamedGroup.nCheciType = cctRest;
    ccID := NamedGroup.strCheciGUID;
  end;

  if not TFrmAddCheCi.GetCheCiInfo(cc1,cc2,bRest) then exit;

  if bRest then
    ccType := Ord(cctRest)
  else
    ccType := Ord(cctCheci);

  LCWebAPI.LCNameBoardEx.Named.Group.UpdateCC(cc1,cc2,ccID,ccType);
  
  LCWebAPI.LCNameBoardEx.Named.GroupV2.Get(ccID,Group);

  (m_Frame.m_ScrollView.PopupView as TNamedGroupView).NamedGroup := Group;

  m_Frame.m_ScrollView.PopupView.Invalidate;
end;

procedure TGrpMenuActions.Exchange(Src, Dest: TNamedGroupView);
var
  nOrder1,nOrder2: integer;
begin
  nOrder1 := m_Frame.m_ScrollView.Views.IndexOf(Src) + 1;
  nOrder2 := m_Frame.m_ScrollView.Views.IndexOf(Dest) + 1;

  LCWebAPI.LCNameBoardEx.Named.GroupV2.Move(Src.NamedGroup.strCheciGUID,nOrder2);
  LCWebAPI.LCNameBoardEx.Named.GroupV2.Move(Dest.NamedGroup.strCheciGUID,nOrder1);

  m_Frame.m_ScrollView.Invalidate();
end;

procedure TGrpMenuActions.GrpTx(Sender: TObject);
var
  GrpID: string;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);
  GrpID := (m_Frame.m_ScrollView.PopupView as TNamedGroupView).NamedGroup.Group.strGroupGUID;
  TNPCommonLogic.GrpTX(m_InputJl,m_InputDuty,GrpID);
  m_Frame.m_ScrollView.Views.Remove(m_Frame.m_ScrollView.PopupView);
  m_Frame.m_ScrollView.Invalidate();
end;

procedure TGrpMenuActions.Move(View, Dest: TNamedGroupView; Mode: TDropMode);
var
  nOrder,nOrder1: integer;
begin
  nOrder := m_Frame.m_ScrollView.Views.IndexOf(Dest) + 1;
  nOrder1 := m_Frame.m_ScrollView.Views.IndexOf(View) + 1;

  if nOrder1 < nOrder then
    nOrder := nOrder - 1;

  case Mode of
    dmInsertLeft:
      begin
        LCWebAPI.LCNameBoardEx.Named.GroupV2.Move(View.NamedGroup.strCheciGUID,nOrder);
      end;
    dmInsertRight:
      begin
        Inc(nOrder);
        LCWebAPI.LCNameBoardEx.Named.GroupV2.Move(View.NamedGroup.strCheciGUID,nOrder);
      end;
  end;

  m_Frame.m_ScrollView.Invalidate();
end;


{ TShareActions }

procedure TShareActions.CreateMenus(View: TView; PopMenu: TPopupMenu);
begin

end;

destructor TShareActions.Destroy;
begin
  m_InputDuty.Free;
  m_InputJl.Free;
  inherited;
end;

constructor TShareActions.NewCreate(Frame: TFrameNamedGrp);
begin
  inherited Create(Frame);
  m_Frame := Frame;
  m_InputJl := TRsLCBoardInputJL.Create();
  m_InputDuty := TRsLCBoardInputDuty.Create;
end;

procedure TShareActions.RefreshGrpView(View: TView);
var
  Grp: RRsNamedGroup;
begin
  if not (View is TNamedGroupView) then raise Exception.Create('View类型错误');

  if LCWebAPI.LCNameBoardEx.Named.Group.GetNamedGroup((View as TNamedGroupView).NamedGroup.Group.strGroupGUID,Grp) then
  begin
    (View as TNamedGroupView).NamedGroup := Grp;
    View.Invalidate();
  end;
end;

procedure TShareActions.RemovePlan(Sender: TObject);
var
  GroupView: TNamedGroupView;
begin
  GroupView := nil;
  
  if m_Frame.m_ScrollView.PopupView is TTrainmanView then
  begin
    GroupView := m_Frame.m_ScrollView.PopupView.Parent as TNamedGroupView;
  end
  else
  if m_Frame.m_ScrollView.PopupView is TNamedGroupView then
  begin
    GroupView := m_Frame.m_ScrollView.PopupView as TNamedGroupView;
  end;

  if GroupView <> nil then
  begin
    if TNPCommonLogic.RemovePlan(GroupView.NamedGroup.Group.strGroupGUID) then
      RefreshGrpView(GroupView);
  end;

end;

procedure TShareActions.ViewPlan(Sender: TObject);
var
  View: TNamedGroupView;
begin
  with m_Frame.m_ScrollView do
  begin
    if PopupView is TTrainmanView then
      View := PopupView.Parent as TNamedGroupView
    else
      View := PopupView as TNamedGroupView;
  end;

  TNPCommonLogic.ShowGprPlan(View.NamedGroup.Group.strGroupGUID);
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

  with View.Parent as TNamedGroupView do
  begin
    AddMenuItem('设置人员',SetTM,PopMenu).Enabled :=
      not (NamedGroup.Group.GroupState in [tsPlaning,tsRuning]);

    AddMenuItem('移除人员',RemoveTm,PopMenu).Enabled :=
      not (NamedGroup.Group.GroupState in [tsPlaning,tsRuning])
      and ((View as TTrainmanView).Trainman.strTrainmanGUID <> '');

    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('查看计划...',ViewPlan,PopMenu).Enabled :=
      NamedGroup.Group.GroupState in [tsPlaning,tsRuning];

    AddMenuItem('移除计划',RemovePlan,PopMenu).Enabled :=
      NamedGroup.Group.GroupState in [tsPlaning];
      
    AddMenuItem('-',nil,PopMenu);

    AddMenuItem('请假',AskLeave,PopMenu).Enabled :=
      not (NamedGroup.Group.GroupState in [tsPlaning,tsRuning]);
  end;
end;

procedure TTmMenuActions.Exchange(Src, Dest: TTrainmanView);
var
  srcGrp, srcTm: string; srcPos: integer;
  destGrp, destTm: string; destPos: integer;
begin
  m_Frame.DoFillParam(m_InputJl,m_InputDuty);

  srcTm := Src.Trainman.strTrainmanGUID;

  srcGrp := (Src.Parent as TNamedGroupView).NamedGroup.Group.strGroupGUID;

  srcPos := Src.Parent.Items.IndexOf(Src) + 1;


  destTm := Dest.Trainman.strTrainmanGUID;

  destGrp := (Dest.Parent as TNamedGroupView).NamedGroup.Group.strGroupGUID;

  destPos := Dest.Parent.Items.IndexOf(Dest) + 1;

  LCWebAPI.LCNameBoardEx.Group.ExchangeTm(m_InputJl,m_InputDuty,
    srcGrp,srcTm,srcPos,
    destGrp,destTm,destPos);

end;



procedure TTmMenuActions.RemoveTm(Sender: TObject);
var
  AddInput: TRsLCTrainmanAddInput;
begin
  with m_Frame.m_ScrollView do
  begin
    with PopupView.Parent as TNamedGroupView do
    begin
      AddInput := TRsLCTrainmanAddInput.Create;
      try
        m_Frame.DoFillParam(AddInput.TrainmanJiaolu,AddInput.DutyUser);
        AddInput.TrainmanNumber := (PopupView as TTrainmanView).Trainman.strTrainmanNumber;
        AddInput.TrainmanIndex := Items.IndexOf(PopupView) + 1;
        AddInput.GroupGUID := NamedGroup.Group.strGroupGUID;

        if TNPCommonLogic.RemoveTm(AddInput,NamedGroup.Group) then
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
    with PopupView.Parent as TNamedGroupView do
    begin
      if TLocalValidator.IsBusy(PopupView.Parent as TNamedGroupView) then
      begin
        TMessageBox.Box(TLocalValidator.Reason);
        Exit;
      end;


      AddInput := TRsLCTrainmanAddInput.Create;
      try
        m_Frame.DoFillParam(AddInput.TrainmanJiaolu,AddInput.DutyUser);

        AddInput.GroupGUID := NamedGroup.Group.strGroupGUID;

        AddInput.TrainmanIndex := PopupView.Parent.Items.IndexOf(PopupView) + 1;

        if not TNPCommonLogic.AddTmToGrp(AddInput) then Exit;
        
      finally
        AddInput.Free;
      end;
    end;
    RefreshGrpView(m_Frame.m_ScrollView.PopupView.Parent);
  end;
end;

end.
