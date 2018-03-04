unit uMealTicketFacade;

interface
uses
  Classes,SysUtils,uMealTicketManager,uTrainman,uTrainPlan,uTrainmanJiaoLu,
  uDutyUser,SqlExpr,uMealTicket,uTFSystem,uHttpWebAPI,Forms,uLCTFMealTicket,
  uLCMealTicket, StdVcl;
type
  RTicket = record
    tmid: string;
    tmName: string;
    userid: string;
    userName: string;
    cc: string;
    iA: integer;
    iB: integer;
    dtPaiBan: TDateTime;
  end;


  TMealTicket = class
  public
    constructor Create(LogFun: TOnEventByString;RsWebApiUtils:TWebAPIUtils;workShopID: string);
    destructor Destroy;override;
  protected
    m_RsWebApiUtils:TWebAPIUtils;
    m_Active: Boolean;
    m_LogFun: TOnEventByString;
    m_WorkShopID: string;

    procedure WriteLog(log: string);

  public
    procedure AddForTM(tm:RRsTrainman;plan: RRsTrainmanPlan;user:TRsDutyUser);virtual;

    procedure AddByGrp(Group: RRsGroup;plan: RRsTrainmanPlan;user:TRsDutyUser);virtual;

    procedure DelByTM(tmid:string;plan: RRsTrainmanPlan);virtual;

    procedure DelByGrp(Group: RRsGroup;plan: RRsTrainmanPlan);virtual;

    procedure Add(Ticket: RTicket);virtual;
  end;

  TNoneTicket = class(TMealTicket);
  
  TTsMealTicket = class(TMealTicket)
  public
    constructor Create(LogFun: TOnEventByString;RsWebApiUtils:TWebAPIUtils;workShopID: string);
    destructor Destroy;override;
  protected
    m_ticketManager: TMealTicketManager;
    m_Conn: TSQLConnection;
    procedure LoadConfig();
    procedure AddByTM(tm:RRsTrainman;jl:RRsTrainmanJiaolu;
      plan: RRsTrainmanPlan;user:TRsDutyUser;out iA,iB:Integer);

    function ConnectMealDB(out ErrTxt:string):Boolean;
    function GetNumberLen: integer;
    procedure SetNumberLen(const Value: integer);
  public
    procedure AddForTM(tm:RRsTrainman;plan: RRsTrainmanPlan;user:TRsDutyUser);override;

    procedure AddByGrp(Group: RRsGroup;plan: RRsTrainmanPlan;user:TRsDutyUser);override;

    procedure DelByTM(tmid:string;plan: RRsTrainmanPlan);override;

    procedure DelByGrp(Group: RRsGroup;plan: RRsTrainmanPlan);override;

    procedure Add(Ticket: RTicket);override;

    property NumberLen: integer read GetNumberLen write SetNumberLen;
  end;


  TTFMealTicket = class(TMealTicket)
  public
    constructor Create(LogFun: TOnEventByString;RsWebApiUtils:TWebAPIUtils;workShopID: string);
    destructor Destroy;override;
  protected
    m_TicketApiUtils:TWebAPIUtils;
    m_RsLCMealTicket:TRsLCMealTicket;
    m_RsLCTFMealTicket: TRsLCTFMealTicket;
    m_ChuQinPlaceID: string;
    m_ChuQinPlaceName: string;
    procedure LoadConfig();
    function InputTicketCount(var iA,iB: integer): Boolean;
    procedure AddByTM(tm:RRsTrainman;jl:RRsTrainmanJiaolu;
      plan: RRsTrainmanPlan;user:TRsDutyUser; iA,iB:Integer);
  public
    procedure AddForTM(tm:RRsTrainman;plan: RRsTrainmanPlan;user:TRsDutyUser);override;

    procedure AddByGrp(Group: RRsGroup;plan: RRsTrainmanPlan;user:TRsDutyUser);override;

    procedure DelByTM(tmid:string;plan: RRsTrainmanPlan);override;

    procedure DelByGrp(Group: RRsGroup;plan: RRsTrainmanPlan);override;

    procedure Add(Ticket: RTicket);override;
  end;
  TMealTicketFactory = class
  public
    class function CreateTicketSender: TMealTicket;
  end;


  TMealCfg = class
  private
    class function GetManualSend(const WorkShopID: string): Boolean;static;
    class procedure SetManualSend(const WorkShopID: string;const Value: Boolean); static;
    class function GetTicketEnable(const WorkShopID: string): Boolean; static;
    class procedure SetTicketEnable(const WorkShopID: string;const Value: Boolean); static;
  public
    class property ManualSend[const WorkShopID: string]: Boolean read GetManualSend write SetManualSend;
    class property TicketEnable[const WorkShopID: string]: Boolean read GetTicketEnable write SetTicketEnable;
  end;
implementation

uses uDialogsLib,uLCWebAPI,uMealTicketConfig,uMealTicketRule,
  ufrmTicketCountInput,uGlobal;

{ TMealTicket }

procedure TTsMealTicket.Add(Ticket: RTicket);
var
  strError: string;
begin
  if not ConnectMealDB(strError) then
  begin
    TNoFocusBox.ShowBox('发放饭票错误: '+strError,2000);
    exit;
  end;

  
    if m_ticketManager.GiveMealTicket(Ticket.tmid,Ticket.tmName,
    Ticket.userid,Ticket.userName,Ticket.iA,Ticket.iB,Ticket.cc,Ticket.dtPaiBan,strError)   then
  begin
    box('发放成功');
  end
  else
    BoxErr(strError);
end;

procedure TTsMealTicket.AddByGrp(Group: RRsGroup; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
var
  trainmanJiaoLu :RRsTrainmanJiaolu ;
  strTxt:string;
  iA,iB:integer;
begin
  if not m_Active   then
    Exit;

  iA := 0;
  iB := 0 ;
  if not ConnectMealDB(strTxt) then
  begin
    TNoFocusBox.ShowBox('发放饭票错误: '+strTxt,2000);
    exit;
  end;
  //发放饭票
  LCWebAPI.LCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(Group.strGroupGUID,trainmanJiaoLu);

  { TODO : GiveTicketByTrainman }
  AddByTM(Group.Trainman1,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman2,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman3,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman4,trainmanJiaoLu,
    plan,user,iA,iB);


  strTxt := Format('早餐券:%d , 正餐券:%d',[iA,iB]);
  TNoFocusBox.ShowBox(strTxt,2000);
end;

procedure TTsMealTicket.AddByTM(tm: RRsTrainman; jl: RRsTrainmanJiaolu;
  plan: RRsTrainmanPlan; user: TRsDutyUser; out iA, iB: Integer);
var
  strTxt:string;
  MealTicket:RRsMealTicket;
  bRet : boolean;
begin
  if not m_Active   then
    Exit;

  //发放饭票
  try
    if tm.strTrainmanNumber <> '' then
    begin
      
      bRet := m_ticketManager.GiveMealTicket(tm.strTrainmanNumber,
      tm.strTrainmanName,user.strDutyNumber,
      user.strDutyName,
        jl,plan.TrainPlan,MealTicket);

      if bRet then
      begin
        iA := MealTicket.CANQUAN_A ;
        iB := MealTicket.CANQUAN_B ;

        strTxt := Format('{饭票}：司机:[%s]%s <餐券数目:A[%d],B[%d]>,发放人:[%s] ,交路GUID:[%s] , 计划GUID:[%s] ,发放时间:%s ',[
          tm.strTrainmanName,tm.strTrainmanNumber,
          MealTicket.CANQUAN_A,MealTicket.CANQUAN_B,user.strDutyNumber,
          jl.strTrainmanJiaoluGUID,plan.TrainPlan.strTrainPlanGUID, FormatDateTime('yyyy-MM-dd HH:nn:ss',Now)]);
        WriteLog(strTxt);
      end
      else
        BoxErr(tm.strTrainmanName + ' 发放饭票失败!');
    end;
  except
    on e:Exception do
    begin
      BoxErr('发放饭票失败:'+e.Message);
    end;
  end;

end;

procedure TTsMealTicket.AddForTM(tm: RRsTrainman; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
var
  dtRec:TDateTime ;
  trainmanJiaoLu :RRsTrainmanJiaolu ;
  strTxt:string;
  MealTicket:RRsMealTicket;
  bRet : Boolean;
begin

  if not m_Active  then
    Exit;

  if not ConnectMealDB(strTxt) then
  begin
    TNoFocusBox.ShowBox('发放饭票错误: '+strTxt,2000);
    exit;
  end;

  try
    dtRec := Now ;
    //发放饭票
    LCWebAPI.LCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(plan.Group.strGroupGUID,trainmanJiaoLu);

    //发放饭票
    if tm.strTrainmanNumber <> '' then
    begin
      bRet := m_ticketManager.GiveMealTicket(tm.strTrainmanNumber,tm.strTrainmanName,
      user.strDutyNumber,user.strDutyName,
        trainmanJiaoLu,plan.TrainPlan,MealTicket);

      if bRet then
      begin
        strTxt := Format('{饭票}：司机:[%s]%s <餐券数目:A[%d],B[%d]>,发放人:[%s] ,交路GUID:[%s] , 计划GUID:[%s] ,发放时间:%s ',[
          tm.strTrainmanName,tm.strTrainmanNumber,MealTicket.CANQUAN_A,MealTicket.CANQUAN_B,user.strDutyNumber,
          trainmanJiaoLu.strTrainmanJiaoluGUID,plan.TrainPlan.strTrainPlanGUID, FormatDateTime('yyyy-MM-dd HH:nn:ss',dtRec)]);
        WriteLog(strTxt);

        strTxt := Format('司机:[%s]%s ,早餐券:%d , 正餐券:%d',[tm.strTrainmanName,tm.strTrainmanNumber,MealTicket.CANQUAN_A,MealTicket.CANQUAN_B]);
        TNoFocusBox.ShowBox(strTxt);
      end;
    end;
  except
    on e:Exception do
    begin
      BoxErr('发放饭票失败:'+e.Message);
    end;
  end;
end;

function TTsMealTicket.ConnectMealDB(out ErrTxt: string): Boolean;
var
  mealTicketConfigOper:TRsMealConfigOper;
  ServerConfig:RRsMealServerConfig;
  strFile:string;
  strDataBase:string;
begin
  Result := True ;
  strFile := Format('%sconfig.ini',[ExtractFilePath(ParamStr(0))]) ;
  mealTicketConfigOper := TRsMealConfigOper.Create(strFile);
  try
    try
      mealTicketConfigOper.ReadMealServerConfig(ServerConfig);
      with m_Conn do
      begin
        if Connected then
          Connected := False ;
        //连接方法
        //192.168.1.105/3050:D:\CJGL\CJGL.DAT
        //'172.17.2.10:c:\db\myDb.fdb'
        strDataBase := format('%s:%s',[ServerConfig.strServerIp,ServerConfig.strDataLocation]);
        Params.Values['Database']:= strDataBase ;
        Params.Values['User_Name']:= ServerConfig.strServerUser;
        Params.Values['Password']:= ServerConfig.strServerPass;
        Connected := True ;
      end;
    except
      on e:Exception do
      begin
        Result := False;
        ErrTxt := e.Message;

      end;
    end;
  finally
    mealTicketConfigOper.Free;
  end;
end;

constructor TTsMealTicket.Create(LogFun: TOnEventByString;RsWebApiUtils:TWebAPIUtils;
  workShopID: string);
begin
  Inherited;
  m_Conn := TSQLConnection.Create(nil);


  
  m_Conn.DriverName := 'Interbase';
  m_Conn.ConnectionName := 'IBCONNECTION';
  m_Conn.GetDriverFunc :=  'getSQLDriverINTERBASE';
  m_Conn.LibraryName := 'dbxint30.dll';
  m_Conn.VendorLib := 'GDS32.DLL';

  m_Conn.Params.Values['BlobSize'] := '-1';
  m_Conn.Params.Values['CommitRetain'] := 'False';
  m_Conn.Params.Values['ErrorResourceFile'] := '';
  m_Conn.Params.Values['LocaleCode'] := '0000';
  m_Conn.Params.Values['ServerCharSet'] := '';
  m_Conn.Params.Values['DriverName'] := 'Interbase';


  m_Conn.Params.Values['Database'] := 'database.gdb';
  m_Conn.Params.Values['WaitOnLocks'] := 'True';
  m_Conn.Params.Values['SQLDialect'] := '3';
  m_Conn.Params.Values['Interbase TransIsolation'] := 'ReadCommited';
  m_Conn.Params.Values['RoleName'] := 'RoleName';

  m_Conn.LoginPrompt := False;


  m_ticketManager := TMealTicketManager.Create(m_Conn,RsWebApiUtils,workShopID);
  m_ticketManager.OnLog := WriteLog;
  LoadConfig();
end;

procedure TTsMealTicket.DelByGrp(Group: RRsGroup; plan: RRsTrainmanPlan);
var
  strTxt:string;
begin

  if not m_Active   then
    Exit;

  if not ConnectMealDB(strTxt) then
  begin
    Box('删除饭票错误: '+strTxt);
    exit;
  end;

  if Group.strGroupGUID = '' then
    Exit ;


  if Group.Trainman1.strTrainmanGUID <> '' then
  begin
    m_ticketManager.DeleteMealTicket(Group.Trainman1.strTrainmanNumber,
    plan);
  end;

  if Group.Trainman2.strTrainmanGUID <> '' then
  begin
    m_ticketManager.DeleteMealTicket(Group.Trainman2.strTrainmanNumber,
    plan);
  end;

  if Group.Trainman3.strTrainmanGUID <> '' then
  begin
    m_ticketManager.DeleteMealTicket(Group.Trainman3.strTrainmanNumber,
    plan);
  end;

  if Group.Trainman4.strTrainmanGUID <> '' then
  begin
    m_ticketManager.DeleteMealTicket(Group.Trainman4.strTrainmanNumber,
    plan);
  end;
end;
procedure TTsMealTicket.DelByTM(tmid: string; plan: RRsTrainmanPlan);
var
  strTxt:string;
begin
  if not m_Active   then
    Exit;

  if not ConnectMealDB(strTxt) then
  begin
    Box('删除饭票错误: '+strTxt);
    exit;
  end;
  m_ticketManager.DeleteMealTicket(tmid,plan);
end;

destructor TTsMealTicket.Destroy;
begin
  m_ticketManager.Free;
  m_Conn.Free;
  inherited;
end;

function TTsMealTicket.GetNumberLen: integer;
begin
  Result := m_ticketManager.NumberLen;
end;

procedure TTsMealTicket.LoadConfig;
var
  RsMealConfigOper: TRsMealConfigOper;
  MealServerConfig: RRsMealServerConfig;
begin
  RsMealConfigOper := TRsMealConfigOper.Create(ExtractFilePath(ParamStr(0)) + 'Config.ini');
  
  RsMealConfigOper.ReadMealServerConfig(MealServerConfig);

  m_ticketManager.MealServerConfig := MealServerConfig;

  RsMealConfigOper.Free;
end;

procedure TTsMealTicket.SetNumberLen(const Value: integer);
begin
  m_ticketManager.NumberLen := Value;
end;


{ TMealTicket }

procedure TMealTicket.Add(Ticket: RTicket);
begin

end;

procedure TMealTicket.AddByGrp(Group: RRsGroup; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
begin

end;


procedure TMealTicket.AddForTM(tm: RRsTrainman; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
begin

end;

constructor TMealTicket.Create(LogFun: TOnEventByString;
  RsWebApiUtils: TWebAPIUtils; workShopID: string);
begin
  m_LogFun := LogFun;
  m_RsWebApiUtils := RsWebApiUtils;
  m_WorkShopID := workShopID;
end;

procedure TMealTicket.DelByGrp(Group: RRsGroup; plan: RRsTrainmanPlan);
begin

end;

procedure TMealTicket.DelByTM(tmid: string; plan: RRsTrainmanPlan);
begin

end;

destructor TMealTicket.Destroy;
begin

  inherited;
end;

procedure TMealTicket.WriteLog(log: string);
begin
  if Assigned(m_LogFun) then
    m_LogFun(log);
end;

{ TMealTicketFactory }

class function TMealTicketFactory.CreateTicketSender: TMealTicket;
var
  TicketVersion: string;
begin

  { TODO : 需要加入日志回调 }

  if not TMealCfg.TicketEnable[GlobalDM.WorkShop.ID] then
  begin
    Result := TNoneTicket.Create(nil,nil,'')
  end
  else
  begin
    TicketVersion := GlobalDM.ReadServerConfig('SysConfig','TicketVersion');
    if TicketVersion = 'TFMEALTICKET' then
    begin
      Result := TTFMealTicket.Create(nil,g_WebAPIUtils,
      GlobalDM.WorkShop.ID);

      Result.m_Active := UsesMealTicket;
    end
    else
    begin
      Result := TTsMealTicket.Create(nil,g_WebAPIUtils,
      GlobalDM.WorkShop.ID);
      Result.m_Active := UsesMealTicket;
      (Result as TTsMealTicket).NumberLen := TicketNumberLen;

      (Result as TTsMealTicket).m_ticketManager.UseMealCheJian :=
          GlobalDM.ReadServerConfig('MealTicket','UseMealCheJian') = '1';
    end;
  end;

end;

{ TTFMealTicket }

procedure TTFMealTicket.Add(Ticket: RTicket);
var
  entity: TTFMealTicketEntity;
begin
  entity := TTFMealTicketEntity.Create;
  try
    entity.strTicketGUID := NewGUID;
    entity.strTrainmanNumber := Ticket.tmid;
    entity.strTrainmanName := Ticket.tmName;
    entity.strShenHeNumber := Ticket.userid;
    entity.strShenHeName := Ticket.userName;
    entity.strTrainNo := Ticket.cc;
    entity.nCanQuanA := Ticket.iA;
    entity.nCanQuanB := Ticket.iB;
    entity.dtChuQinTime := Ticket.dtPaiBan;
    entity.strChuQinPlaceID := m_ChuQinPlaceID;
    entity.strChuQinPlaceName := m_ChuQinPlaceName;
    entity.dtCreateTime := Now;
    entity.dtShenHeTime := Now;
    m_RsLCTFMealTicket.Add(entity);
  finally
    entity.Free;
  end;

end;

procedure TTFMealTicket.AddByGrp(Group: RRsGroup; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
  function GetTMNumber(): string;
  begin
    Result := Group.Trainman1.strTrainmanNumber;

    if Result = '' then
      Result := Group.Trainman2.strTrainmanNumber;

    if Result = '' then
      Result := Group.Trainman3.strTrainmanNumber;

    if Result = '' then
      Result := Group.Trainman4.strTrainmanNumber;
  end;
var
  trainmanJiaoLu :RRsTrainmanJiaolu ;
  strTxt:string;
  iA,iB:integer;
  tmNumber: string;
  personInfo:RRsMealTicketPersonInfo;
begin
  if not m_Active   then
    Exit;

  iA := 0;
  iB := 0 ;

  //发放饭票
  LCWebAPI.LCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(Group.strGroupGUID,trainmanJiaoLu);

  tmNumber := GetTMNumber();
  if tmNumber = '' then Exit;

  personInfo.strTrainmanNumber := tmNumber;
  personInfo.strWorkShopGUID := m_WorkShopID;
  personInfo.strQuDuan := plan.TrainPlan.strTrainJiaoluName;
  personInfo.strCheCi := plan.TrainPlan.strTrainNo;
  personInfo.dtPaiBan := plan.TrainPlan.dtStartTime;
      

  if not m_RsLCMealTicket.GetTicket(personInfo,iA,iB) then
  begin
    if not InputTicketCount(iA,iB) then Exit;
  end;
  
  AddByTM(Group.Trainman1,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman2,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman3,trainmanJiaoLu,
    plan,user,iA,iB);

  AddByTM(Group.Trainman4,trainmanJiaoLu,
    plan,user,iA,iB);


  strTxt := Format('早餐券:%d , 正餐券:%d',[iA,iB]);
  TNoFocusBox.ShowBox(strTxt,2000);
end;

procedure TTFMealTicket.AddByTM(tm: RRsTrainman; jl: RRsTrainmanJiaolu;
  plan: RRsTrainmanPlan; user: TRsDutyUser;iA, iB: Integer);
var
  strTxt:string;
  TicketEntity: TTFMealTicketEntity;
begin
  if not m_Active   then
    Exit;

  TicketEntity := TTFMealTicketEntity.Create;
  //发放饭票
  try
    if tm.strTrainmanNumber <> '' then
    begin

      TicketEntity.strTicketGUID := NewGUID;
      TicketEntity.dtChuQinTime := plan.TrainPlan.dtStartTime;
      TicketEntity.strTrainNo := plan.TrainPlan.strTrainNo;
      TicketEntity.strTrainmanName := tm.strTrainmanName;
      TicketEntity.strTrainmanNumber := tm.strTrainmanNumber;
      TicketEntity.strWorkShopGUID := '';
      TicketEntity.strShenHeNumber := user.strDutyNumber;
      TicketEntity.strShenHeName := user.strDutyName;
      TicketEntity.dtCreateTime := Now;
      TicketEntity.strChuQinPlaceID := m_ChuQinPlaceID;
      TicketEntity.strChuQinPlaceName := m_ChuQinPlaceName;
      TicketEntity.nCanQuanA := iA;
      TicketEntity.nCanQuanB := iB;
      TicketEntity.dtShenHeTime := Now;

      m_RsLCTFMealTicket.Add(TicketEntity);


      strTxt := Format('{饭票}：司机:[%s]%s <餐券数目:A[%d],B[%d]>,发放人:[%s] ,交路GUID:[%s] , 计划GUID:[%s] ,发放时间:%s ',[
          tm.strTrainmanName,tm.strTrainmanNumber,TicketEntity.nCanQuanA,TicketEntity.nCanQuanB,user.strDutyNumber,
          jl.strTrainmanJiaoluGUID,plan.TrainPlan.strTrainPlanGUID, FormatDateTime('yyyy-MM-dd HH:nn:ss',Now)]);
      WriteLog(strTxt);


    end;
  except
    on e:Exception do
    begin
      BoxErr('发放饭票失败:'+e.Message);
    end;
  end;
  TicketEntity.Free;

end;
procedure TTFMealTicket.AddForTM(tm: RRsTrainman; plan: RRsTrainmanPlan;
  user: TRsDutyUser);
var
  trainmanJiaoLu :RRsTrainmanJiaolu ;
  strTxt:string;
  personInfo:RRsMealTicketPersonInfo;
  iA,iB: integer;
  TicketEntity: TTFMealTicketEntity;
begin
  if not m_Active  then
    Exit;

  TicketEntity := TTFMealTicketEntity.Create;
  try
    try
      //发放饭票
      LCWebAPI.LCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(plan.Group.strGroupGUID,trainmanJiaoLu);


      TicketEntity.strTicketGUID := NewGUID;
      TicketEntity.dtChuQinTime := plan.TrainPlan.dtStartTime;
      TicketEntity.strTrainNo := plan.TrainPlan.strTrainNo;
      TicketEntity.strTrainmanName := tm.strTrainmanName;
      TicketEntity.strTrainmanNumber := tm.strTrainmanNumber;
      TicketEntity.strWorkShopGUID := '';
      TicketEntity.strShenHeNumber := user.strDutyNumber;
      TicketEntity.strShenHeName := user.strDutyName;
      TicketEntity.dtCreateTime := Now;
      TicketEntity.strChuQinPlaceID := m_ChuQinPlaceID;
      TicketEntity.strChuQinPlaceName := m_ChuQinPlaceName;
      TicketEntity.dtShenHeTime := Now;


      personInfo.strTrainmanNumber := tm.strTrainmanNumber;
      personInfo.strWorkShopGUID := m_WorkShopID;
      personInfo.strQuDuan := plan.TrainPlan.strTrainJiaoluName;
      personInfo.strCheCi := plan.TrainPlan.strTrainNo;
      personInfo.dtPaiBan := plan.TrainPlan.dtStartTime;
      

      if m_RsLCMealTicket.GetTicket(personInfo,iA,iB) then
      begin
        TicketEntity.nCanQuanA := iA;
        TicketEntity.nCanQuanB := iB;
      end
      else
      begin
        if not InputTicketCount(iA,iB) then Exit;
        TicketEntity.nCanQuanA := iA;
        TicketEntity.nCanQuanB := iB;
      end;


      WriteLog(Format('饭票A:%d  饭票B:%d',[iA,iB]));



      //发放饭票
      if tm.strTrainmanNumber <> '' then
      begin
        m_RsLCTFMealTicket.Add(TicketEntity);


        strTxt := Format('{饭票}：司机:[%s]%s <餐券数目:A[%d],B[%d]>,发放人:[%s] ,交路GUID:[%s] , 计划GUID:[%s] ,发放时间:%s ',[
            tm.strTrainmanName,tm.strTrainmanNumber,TicketEntity.nCanQuanA,TicketEntity.nCanQuanB,user.strDutyNumber,
            trainmanJiaoLu.strTrainmanJiaoluGUID,plan.TrainPlan.strTrainPlanGUID, FormatDateTime('yyyy-MM-dd HH:nn:ss',Now)]);
        WriteLog(strTxt);

        strTxt := Format('司机:[%s]%s ,早餐券:%d , 正餐券:%d',[tm.strTrainmanName,tm.strTrainmanNumber,TicketEntity.nCanQuanA,TicketEntity.nCanQuanB]);
        TNoFocusBox.ShowBox(strTxt);
      end;
    except
      on e:Exception do
      begin
        BoxErr('发放饭票失败:'+e.Message);
      end;
    end;
  finally
    TicketEntity.Free;
  end;

end;

constructor TTFMealTicket.Create(LogFun: TOnEventByString;
  RsWebApiUtils: TWebAPIUtils; workShopID: string);
begin
  Inherited;
  m_TicketApiUtils := TWebAPIUtils.Create;
  m_RsLCTFMealTicket := TRsLCTFMealTicket.Create(m_TicketApiUtils);
  m_RsLCMealTicket := TRsLCMealTicket.Create(RsWebApiUtils);
  LoadConfig();
end;

procedure TTFMealTicket.DelByGrp(Group: RRsGroup; plan: RRsTrainmanPlan);
var
  tempGrp: RRsGroup;
begin
  if not m_Active   then
    Exit;
  if Group.strGroupGUID = '' then
    Exit ;


  LCWebAPI.LCNameBoardEx.Group.GetGroup(Group.strGroupGUID,tempGrp);

  if tempGrp.Trainman1.strTrainmanGUID <> '' then
  begin
    DelByTM(tempGrp.Trainman1.strTrainmanNumber,plan);
  end;

  if tempGrp.Trainman2.strTrainmanGUID <> '' then
  begin
    DelByTM(tempGrp.Trainman2.strTrainmanNumber,plan);
  end;

  if tempGrp.Trainman3.strTrainmanGUID <> '' then
  begin
    DelByTM(tempGrp.Trainman3.strTrainmanNumber,plan);
  end;

  if tempGrp.Trainman4.strTrainmanGUID <> '' then
  begin
    DelByTM(tempGrp.Trainman4.strTrainmanNumber,plan);
  end;
end;

procedure TTFMealTicket.DelByTM(tmid: string; plan: RRsTrainmanPlan);
var
  entity: TTFMealTicketEntity;
begin
  if not m_Active   then
    Exit;

  entity := TTFMealTicketEntity.Create;
  try
    if m_RsLCTFMealTicket.Get(tmid,entity) then
      m_RsLCTFMealTicket.Del(entity.strTicketGUID);
  finally
    entity.Free;
  end;

end;

destructor TTFMealTicket.Destroy;
begin
  m_RsLCTFMealTicket.Free;
  m_RsLCMealTicket.Free;
  m_TicketApiUtils.Free;
  inherited;
end;

function TTFMealTicket.InputTicketCount(var iA, iB: integer): Boolean;
begin
  Result := TFrmTicketCountInput.Input(iA,iB)
end;

procedure TTFMealTicket.LoadConfig;
var
  cfg: string;
begin
  cfg := ExtractFilePath(ParamStr(0)) + 'Config.ini';

  m_ChuQinPlaceID := ReadIniFile(cfg,'MealTicketConfig','ChuQinPlaceID');
  m_ChuQinPlaceName :=  ReadIniFile(cfg,'MealTicketConfig','ChuQinPlaceName');

  m_TicketApiUtils.Host := ReadIniFile(cfg,'MealTicketConfig','TFApiHost');
  m_TicketApiUtils.Port := StrToIntDef(ReadIniFile(cfg,'MealTicketConfig','TFApiPort'),80);
end;

{ TMealCfg }

class function TMealCfg.GetManualSend(const WorkShopID: string): Boolean;
begin
  Result :=
    GlobalDM.ReadServerConfig('MealTicket','ManualSend_' + WorkShopID) <> '0';
end;

class function TMealCfg.GetTicketEnable(const WorkShopID: string): Boolean;
begin
  Result := GlobalDM.ReadServerConfig('MealTicket','TicketEnable_' + WorkShopID) <> '0';
end;

class procedure TMealCfg.SetManualSend(const WorkShopID: string;const Value: Boolean);
begin
  if Value then
    GlobalDM.WriteServerConfig('MealTicket','ManualSend_' + WorkShopID,'1')
  else
    GlobalDM.WriteServerConfig('MealTicket','ManualSend_' + WorkShopID,'0');
end;


class procedure TMealCfg.SetTicketEnable(const WorkShopID: string;
  const Value: Boolean);
begin
  if Value then
    GlobalDM.WriteServerConfig('MealTicket','TicketEnable_' + WorkShopID,'1')
  else
    GlobalDM.WriteServerConfig('MealTicket','TicketEnable_' + WorkShopID,'0');
end;

end.
