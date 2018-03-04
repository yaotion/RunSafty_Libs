unit uMealTicketImp;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsMealTicket_TLB, StdVcl,Classes,Forms,dialogs,
  uMealTicketFacade,uDutyUser;
type
  TGrpImp = class(TInterfacedObject,IGrp)
  private
    m_Tm1: ITm;
    m_Tm2: ITm;
    m_Tm3: ITm;
    m_Tm4: ITm;
    
    function Get_Tm1: ITm; safecall;
    procedure Set_Tm1(const Value: ITm); safecall;
    function Get_Tm2: ITm; safecall;
    procedure Set_Tm2(const Value: ITm); safecall;
    function Get_Tm3: ITm; safecall;
    procedure Set_Tm3(const Value: ITm); safecall;
    function Get_Tm4: ITm; safecall;
    procedure Set_Tm4(const Value: ITm); safecall;
    function CreateTm: ITm; safecall;
  end;
  
  TPlanImp = class(TInterfacedObject,IPlan)
  private
    m_ID: WideString;
    m_GrpID: WideString;
    m_TrainNo: WideString;
    m_Section: WideString;
    m_Time: TDateTime;
    
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_GrpID: WideString; safecall;
    procedure Set_GrpID(const Value: WideString); safecall;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_Section: WideString; safecall;
    procedure Set_Section(const Value: WideString); safecall;
    function Get_Time: TDateTime; safecall;
    procedure Set_Time(Value: TDateTime); safecall;
  end;

  TTmImp = class(TInterfacedObject,ITm)
  private
    m_ID: WideString;
    m_Number: WideString;
    m_Name: WideString;

    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
  end;

  // g_TicketConn 用完需要关闭，如在退出程序时关闭会因为DLL释放问题导致失败
  TTicket = class(TAutoObject, ITicket)
  public
    destructor Destroy;override;
  protected
    m_MealTicket: TMealTicket;
    m_RsDutyUser: TRsDutyUser;
    procedure AddByGrp(const Plan: IPlan; const Grp: IGrp); safecall;
    procedure AddByTm(const Plan: IPlan; const Tm: ITm); safecall;
    procedure DelByGrp(const Plan: IPlan; const Grp: IGrp); safecall;
    procedure DelByTm(const Plan: IPlan; const Tm: ITm); safecall;
    procedure SendDialog; safecall;
    function CreateGrp: IGrp; safecall;
    function CreatePlan: IPlan; safecall;
    function CreateTm: ITm; safecall;
  public
    procedure Initialize; override;
  end;


  TQuery = class(TAutoObject,IQuery)
  protected
    procedure Log(EnableDel: WordBool); safecall;
    procedure Ticket; safecall;
  public
    procedure Initialize; override;
  end;

  TConfig = class(TAutoObject,IConfig)
  protected
    procedure ServerCfg; safecall;
    procedure TicketCfg; safecall;
    procedure TicketRule; safecall;
  public
    procedure Initialize; override;
  end;
  
implementation

uses ComServ,uGlobal, RsGlobal_TLB, uFrmMealticketServerCfg,
  uFrmMealTicketConfig, uFrmMealTicketRule, uFrmViewMealTicket,
  uFrmViewMealTicketLog,uFrmAddMealTicket,uTrainPlan,uTrainmanJiaolu,
  uTrainman;
function CreateGrpRec(const Grp: IGrp): RRsGroup;
begin
  FillChar(Result,SizeOf(Result),0);

  if Assigned(Grp.Tm1) then
  begin
    Result.Trainman1.strTrainmanGUID := Grp.Tm1.ID;
    Result.Trainman1.strTrainmanNumber := Grp.Tm1.Number;
    Result.Trainman1.strTrainmanName := Grp.Tm1.Name;
  end;

  if Assigned(Grp.Tm2) then
  begin
    Result.Trainman2.strTrainmanGUID := Grp.Tm2.ID;
    Result.Trainman2.strTrainmanNumber := Grp.Tm2.Number;
    Result.Trainman2.strTrainmanName := Grp.Tm2.Name;
  end;

  if Assigned(Grp.Tm3) then
  begin
    Result.Trainman3.strTrainmanGUID := Grp.Tm3.ID;
    Result.Trainman3.strTrainmanNumber := Grp.Tm3.Number;
    Result.Trainman3.strTrainmanName := Grp.Tm3.Name;
  end;

  if Assigned(Grp.Tm4) then
  begin
    Result.Trainman4.strTrainmanGUID := Grp.Tm4.ID;
    Result.Trainman4.strTrainmanNumber := Grp.Tm4.Number;
    Result.Trainman4.strTrainmanName := Grp.Tm4.Name;
  end;
end;

function CreateTrainmanPlan(const Plan: IPlan): RRsTrainmanPlan;
begin
  FillChar(Result,sizeof(Result),0);

  Result.TrainPlan.strTrainPlanGUID := Plan.ID;
  Result.Group.strGroupGUID := Plan.GrpID;
  Result.TrainPlan.strTrainNo := Plan.TrainNo;
  Result.TrainPlan.strTrainJiaoluName := Plan.Section;
  Result.TrainPlan.dtStartTime := Plan.Time;
end;

procedure FilleDutyUser(User: TRsDutyUser);
begin
  User.strDutyGUID := GlobalDM.User.ID;
  User.strDutyNumber := GlobalDM.User.Number;
  User.strDutyName := GlobalDM.User.Name;
end;
function CreateTrainman(tm: ITm): RRsTrainman;
begin
  FillChar(Result,SizeOf(Result),0);

  Result.strTrainmanGUID := tm.ID;
  Result.strTrainmanNumber := tm.Number;
  Result.strTrainmanName := tm.Name;
end;

procedure TTicket.AddByGrp(const Plan: IPlan; const Grp: IGrp);
var
  Group: RRsGroup;
  TrainmanPlan: RRsTrainmanPlan;
begin
  Group := CreateGrpRec(Grp);
  TrainmanPlan := CreateTrainmanPlan(Plan);
  FilleDutyUser(m_RsDutyUser);
  Group.strGroupGUID := Plan.GrpID;
  m_MealTicket.AddByGrp(Group,TrainmanPlan,m_RsDutyUser);
  if g_TicketConn.Connected then
      g_TicketConn.Close;
end;

procedure TTicket.AddByTm(const Plan: IPlan; const Tm: ITm);
VAR
  Trainman: RRsTrainman;
  TrainmanPlan: RRsTrainmanPlan;
begin
  Trainman := CreateTrainman(Tm);
  TrainmanPlan := CreateTrainmanPlan(Plan);
  FilleDutyUser(m_RsDutyUser);

  m_MealTicket.AddForTM(Trainman,TrainmanPlan,m_RsDutyUser);
  if g_TicketConn.Connected then
      g_TicketConn.Close;
end;

procedure TTicket.DelByGrp(const Plan: IPlan; const Grp: IGrp);
var
  Group: RRsGroup;
  TrainmanPlan: RRsTrainmanPlan;
begin
  Group := CreateGrpRec(Grp);
  TrainmanPlan := CreateTrainmanPlan(Plan);
  Group.strGroupGUID := Plan.GrpID;
  m_MealTicket.DelByGrp(Group,TrainmanPlan);
  if g_TicketConn.Connected then
      g_TicketConn.Close;
end;

procedure TTicket.DelByTm(const Plan: IPlan; const Tm: ITm);
VAR
  TrainmanPlan: RRsTrainmanPlan;
begin
  TrainmanPlan := CreateTrainmanPlan(Plan);
  m_MealTicket.DelByTM(Tm.Number,TrainmanPlan);
  if g_TicketConn.Connected then
      g_TicketConn.Close;
end;

destructor TTicket.Destroy;
begin
  m_MealTicket.Free;
  inherited;
end;

procedure TTicket.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;

  m_MealTicket := TMealTicketFactory.CreateTicketSender;
  m_RsDutyUser := TRsDutyUser.Create;
end;

procedure TTicket.SendDialog;
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmAddMealTicket.GiveTicket;
  Application.Handle := 0;
  if g_TicketConn.Connected then
      g_TicketConn.Close;
end;

procedure TConfig.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TConfig.ServerCfg;
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmMealTicketServerCfg.ShowCfg;
  Application.Handle := 0;
end;

procedure TConfig.TicketCfg;
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmMealTicketConfig.Config;
  Application.Handle := 0;
end;

procedure TQuery.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TQuery.Log(EnableDel: WordBool);
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmViewMealTicketLog.showForm(EnableDel);
  Application.Handle := 0;
end;

procedure TQuery.Ticket;
begin
  if UsesMealTicket then
  begin
    Application.Handle := GlobalDM.AppHandle;
    TFrmViewMealTicket.ShowForm;
    Application.Handle := 0;
  end;

end;


procedure TConfig.TicketRule;
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmMealTicketRule.ShowForm;
  Application.Handle := 0;
end;

function TTicket.CreateGrp: IGrp;
begin
  Result := TGrpImp.Create;
end;

function TTicket.CreatePlan: IPlan;
begin
  Result := TPlanImp.Create;
end;

function TTicket.CreateTm: ITm;
begin
  Result := TTmImp.Create;
end;

{ TGrpImp }

function TGrpImp.CreateTm: ITm;
begin
  Result := TTmImp.Create;
end;

function TGrpImp.Get_Tm1: ITm;
begin
  Result := m_Tm1;
end;

function TGrpImp.Get_Tm2: ITm;
begin
  Result := m_Tm2;
end;

function TGrpImp.Get_Tm3: ITm;
begin
  Result := m_Tm3;
end;

function TGrpImp.Get_Tm4: ITm;
begin
  Result := m_Tm4;
end;

procedure TGrpImp.Set_Tm1(const Value: ITm);
begin
  m_Tm1 := Value;
end;

procedure TGrpImp.Set_Tm2(const Value: ITm);
begin
  m_Tm2 := Value;
end;

procedure TGrpImp.Set_Tm3(const Value: ITm);
begin
  m_Tm3 := Value;
end;

procedure TGrpImp.Set_Tm4(const Value: ITm);
begin
  m_Tm4 := Value;
end;

{ TPlanImp }

function TPlanImp.Get_GrpID: WideString;
begin
  Result := m_GrpID;
end;

function TPlanImp.Get_ID: WideString;
begin
  Result := m_ID;
end;

function TPlanImp.Get_Section: WideString;
begin
  Result := m_Section;
end;

function TPlanImp.Get_Time: TDateTime;
begin
  Result := m_Time;
end;

function TPlanImp.Get_TrainNo: WideString;
begin
  Result := m_TrainNo;
end;

procedure TPlanImp.Set_GrpID(const Value: WideString);
begin
  m_GrpID := Value;
end;

procedure TPlanImp.Set_ID(const Value: WideString);
begin
  m_ID := Value;
end;

procedure TPlanImp.Set_Section(const Value: WideString);
begin
  m_Section := Value;
end;

procedure TPlanImp.Set_Time(Value: TDateTime);
begin
  m_Time := Value;
end;

procedure TPlanImp.Set_TrainNo(const Value: WideString);
begin
  m_TrainNo := Value;
end;

{ TTmImp }

function TTmImp.Get_ID: WideString;
begin
  Result := m_ID;  
end;

function TTmImp.Get_Name: WideString;
begin
  Result := m_Name;
end;

function TTmImp.Get_Number: WideString;
begin
  Result := m_Number;
end;

procedure TTmImp.Set_ID(const Value: WideString);
begin
  m_ID := Value;
end;

procedure TTmImp.Set_Name(const Value: WideString);
begin
  m_Name := Value;
end;

procedure TTmImp.Set_Number(const Value: WideString);
begin
  m_Number := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTicket, Class_Ticket,
    ciMultiInstance, tmApartment);

  TAutoObjectFactory.Create(ComServer, TQuery, CLASS_Query,
    ciMultiInstance, tmApartment);

  TAutoObjectFactory.Create(ComServer, TConfig, CLASS_Config,
    ciMultiInstance, tmApartment);
end.
