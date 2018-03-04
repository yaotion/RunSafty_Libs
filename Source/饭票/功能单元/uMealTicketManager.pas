unit uMealTicketManager;

interface

uses
  SysUtils,DateUtils,SqlExpr,DB,ADODB,utfsystem,uMealTicket,uTrainman,
  uTrainmanJiaolu,uTrainPlan,uDBMealTicket,uMealTicketRule,uLCMealTicket,
  uHttpWebAPI,StrUtils,uMealTicketConfig;

type
    {��Ʊ�������Ĳ�����
    ���ݽ�·���ͺ��ò����ͻ�ȡ��Ʊ}
  TMealTicketManager = class
  public
    constructor Create(ConnectionTicket:TSQLConnection;WebAPIUtils:TWebAPIUtils;WorkShopGUID:string);
    destructor Destroy();override;
  public
    {˾���������ˣ���Ա��·���г��ƻ�}
    function  GiveMealTicket(TrainmanNumber:string;TrainmanName:string;ShenHeNumber,ShenHeName:string;
      TrainmanJiaoLu:RRsTrainmanJiaolu;TrainPlan:RRsTrainPlan;out MealTicket:RRsMealTicket):Boolean;overload;
    //��������Ա��Ʊ��Ŀ���ŷ�Ʊ
    function  GiveMealTicket(TrainmanNumber:string;TrainmanName:string;ShenHeNumber,ShenHeName:string;iA,iB:Integer;CheCi:string;
      PaiBanTime:TDateTime;out Error:string):Boolean;overload;
    //ɾ��Ʊ
    procedure DeleteMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan);
    //�޸ķ�Ʊ
    function ModifyMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan;CanQuanA,CanQuanB,CanQuanC:Integer):Boolean;
    //�Ƿ�Ӧ�����Ʊ
    function  IsGivedTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan;var CanQuanA,CanQuanB,CanQuanC:Integer):Boolean;
  private
    //��������Ĳ�����Ϣ���һ����ɵ���Ϣ
    procedure GetMealTicket();
    //����Ʊ
    function WriteMealTicket(MealTicket:RRsMealTicket):Boolean;
    procedure WriteLog(const log: string);
  private
    // 1 ����ʱ��ͳ�����ɱ��ε�GUID
    function  GetPaiBanStr(StartWork:TDateTime;CheCi:string):string;
    // 2 ��ȡ˾����Ϣ
    procedure  GetDriverInfo();
    //3  ������ʱ��(������)
    procedure GetChuQinInfo();
    //4 ���ݽ�·���ͺ�ʱ���ȡ��Ʊ��Ŀ
    procedure  GetTicketInfo();
    //5 ��ȡ������Ա��Ϣ
    procedure GetShenHeInfo();
    //6 ��ȡ��ȯGUID
    procedure GetGUID();
    function GetNumber(OrgNumber: string): string;
  public
    //�Ƿ��Ƕ���
    function  IsEastLine(TrainmanJiaoLu:RRsTrainmanJiaolu):Boolean;
    //��ȡ�ò͵����� {��ͣ���ͣ����}
    function  GetMealType(DateTime:TDateTime):TRsMealType;
  private
    m_strWorkShopGUID:string;                   //����GUID
    m_RsLCMealTicket:TRsLCMealTicket;     //��Ʊ����
    m_MealTicket:RRsMealTicket ;              //��ȯ��Ϣ
    m_dbMealTicket:TRsDBMealTicket;           //��Ʊ���ݿ����
    m_dtPaiBanTime:TDateTime;                  //�ɰ�ʱ��
    m_strTrainmanNumber:string;                  //˾������
    m_strTrainmanName:string;                   //˾������
    m_strShenHeNumber:string;                    //������
    m_strShenHeName: string;
    m_strCheCi:string;                           //����
    m_TrainmanJiaoLu:RRsTrainmanJiaolu  ;     //��·��Ϣ
//    m_nJiaoluType:TRsJiaoluType;            //��Ա��·����
    m_strQuDuan:string;                     //�г�����

    m_OnLog: TOnEventByString;
    m_nNumberLen: integer;
    //ʹ�÷�Ʊϵͳ�ĳ���
    m_UseMealCheJian: Boolean;

  public
    MealServerConfig : RRsMealServerConfig ;    //��Ʊ����������
    property NumberLen: integer read m_nNumberLen write m_nNumberLen;
    property UseMealCheJian: Boolean read m_UseMealCheJian write m_UseMealCheJian;
    property OnLog: TOnEventByString read m_OnLog write m_OnLog;


  end;

implementation




{ TMealTicketManager }

procedure TMealTicketManager.DeleteMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan);
var
  strPaiBan:string;
begin
  TrainmanNumber := GetNumber(TrainmanNumber);
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  m_dbMealTicket.Delete(strPaiBan,TrainmanNumber);
end;

destructor TMealTicketManager.Destroy;
begin
    //��Ʊ�ͷ�
  m_dbMealTicket.Free;
  m_RsLCMealTicket.Free;
  inherited;
end;

procedure TMealTicketManager.GetMealTicket;
begin
  GetGUID;
  GetDriverInfo;
  GetChuQinInfo();
  GetTicketInfo;
  GetShenHeInfo;
end;

procedure TMealTicketManager.GetGUID;
begin
  m_MealTicket.PAIBAN_STR := GetPaiBanStr(m_dtPaiBanTime,m_strCheCi );
end;

procedure TMealTicketManager.GetChuQinInfo();
var
  strDriverName:string;
  strCheJian:string;
begin
  m_dbMealTicket.GetDriverInfo(m_strTrainmanNumber,strDriverName,strCheJian);

  m_MealTicket.PAIBAN_CHECI := m_strCheCi ;
  m_MealTicket.CHUQIN_TIME :=  FormatDateTime('yyyy-mm:dd HH:MM:SS',m_dtPaiBanTime);
  m_MealTicket.CHUQIN_YEAR := YearOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_MONTH := MonthOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_DAY := DayOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_YMD := StrToInt(FormatDateTime('yyyymmdd',m_dtPaiBanTime));
  if m_UseMealCheJian then
    m_MealTicket.CHUQIN_DEPART := strCheJian
  else
    m_MealTicket.CHUQIN_DEPART := MealServerConfig.strCheJian;
end;

procedure TMealTicketManager.GetDriverInfo;
var
  strDriverName:string;
  strCheJian:string;
begin
  if m_dbMealTicket.GetDriverInfo(m_strTrainmanNumber,strDriverName,strCheJian)then
  begin
    m_MealTicket.DRIVER_CODE := m_strTrainmanNumber ;
    m_MealTicket.DRIVER_NAME := strDriverName ;
    if m_UseMealCheJian then
      m_MealTicket.CHEJIAN_NAME := strCheJian
    else
      m_MealTicket.CHEJIAN_NAME := MealServerConfig.strCheJian ;
  end
  else
  begin
    m_MealTicket.DRIVER_CODE := m_strTrainmanNumber ;
    m_MealTicket.DRIVER_NAME := m_strTrainmanName ;
    m_MealTicket.CHEJIAN_NAME := MealServerConfig.strCheJian ;
  end;
end;

procedure TMealTicketManager.GetShenHeInfo;
//var
//  strName:string;
begin
  //��ȡ����������
//  m_dbMealTicket.GetAdminInfo(m_strShenHeNumber,strName);

  m_MealTicket.SHENHEREN_CODE := m_strShenHeNumber ;
  m_MealTicket.SHENHEREN_NAME := m_strShenHeName ;
  m_MealTicket.CHECK_FLAG := 1 ;

  m_MealTicket.REC_TIME :=  FormatDateTime('yyyy-mm:dd HH:MM:SS',Now) ;
end;

function TMealTicketManager.GetMealType(DateTime: TDateTime): TRsMealType;
var
  wHour:Word;
begin
  Result := mtLunch ;
  wHour := HourOf(DateTime);
  if ( wHour >= BREAKFAST_MIN_HOUR ) and ( wHour < BREAKFAST_MAX_HOUR ) then
    Result := mtBreakFast ;
  {
  else if ( wHour >= LUNCH_MIN_HOUR ) and ( wHour <= LUNCH_MAX_HOUR ) then
    Result := mtLunch ;
  else if ( wHour >= DINNER_MIN_HOUR ) and ( wHour <= DINNER_MAX_HOUR ) then
    Result := mtDinner
  else
    Result := mtOther ;
  }
end;

function TMealTicketManager.GetNumber(OrgNumber: string): string;
begin
  if (m_nNumberLen < 7) and (Length(OrgNumber) >= m_nNumberLen) then
    Result := RightStr(OrgNumber,m_nNumberLen)
  else
    Result := OrgNumber;
end;

procedure TMealTicketManager.WriteLog(const log: string);
begin
  if Assigned(m_OnLog) then
    m_OnLog(log);
end;

function TMealTicketManager.WriteMealTicket(MealTicket: RRsMealTicket):Boolean;
begin
  m_dbMealTicket.OnLog := m_OnLog;
  Result := m_dbMealTicket.Insert(m_MealTicket);
end;

constructor TMealTicketManager.Create(ConnectionTicket:TSQLConnection;WebAPIUtils:TWebAPIUtils;WorkShopGUID:string);
begin
  inherited Create();
  m_nNumberLen := 7;
  m_dbMealTicket := TRsDBMealTicket.Create(ConnectionTicket);
  m_RsLCMealTicket := TRsLCMealTicket.Create(WebAPIUtils);
  m_strWorkShopGUID := WorkShopGUID ;
end;

function TMealTicketManager.GiveMealTicket(TrainmanNumber,TrainmanName,
  ShenHeNumber,ShenHeName: string; TrainmanJiaoLu: RRsTrainmanJiaolu;
  TrainPlan:RRsTrainPlan;out MealTicket:RRsMealTicket): Boolean;
var
  dtGive:TDateTime;
  nMinutes: integer;
begin
  Result := False ;
  dtGive := 0 ;

  WriteLog(Format('Enter_GiveMealTicket:Number:%s ShenHeNumber:%s JiaoLu:%s Plan:%s',[
  TrainmanNumber,ShenHeNumber,TrainmanJiaoLu.strTrainmanJiaoluGUID,
  TrainPlan.strTrainPlanGUID
  ]));
  m_strTrainmanNumber := GetNumber(TrainmanNumber); 
  m_strTrainmanName := TrainmanName ;
  m_strShenHeNumber := GetNumber(ShenHeNumber) ;
  m_strShenHeName := ShenHeName;
  m_strCheCi := TrainPlan.strTrainNo ;
  m_TrainmanJiaoLu := TrainmanJiaoLu ;
  m_dtPaiBanTime := TrainPlan.dtStartTime ;
  m_strQuDuan := TrainPlan.strTrainJiaoluName ;



  WriteLog(Format('dtStartTime:%s strTrainJiaoluName:%s strTrainNo:%s m_strTrainmanName:%s',[
  datetimetostr(m_dtPaiBanTime),m_strQuDuan,m_strCheCi,m_strTrainmanNumber
  ]));



  GetMealTicket();
                       

  //���ŷ�Ʊ��ʱ����
  if MealServerConfig.nInterval <> 0 then
  begin
    if m_dbMealTicket.GetCanQuanLastTime(TrainmanNumber,dtGive) then
    begin
      nMinutes := MinutesBetween(m_dtPaiBanTime , dtGive);
      if nMinutes < MealServerConfig.nInterval then
      begin
        WriteLog('����ʱ��������');
        Exit;
      end;

    end;
  end;

  if not WriteMealTicket(m_MealTicket)  then
  begin
    WriteLog('WriteMealTicket  = False');
    Exit;
  end;

    
  MealTicket := m_MealTicket ;
  Result := True ;
end;

function TMealTicketManager.GetPaiBanStr(StartWork:TDateTime;CheCi:string): string;
var
  strTime:string;
begin
  Result := '' ;
  strTime := FormatDateTime('yyyymmddHHMMSS',StartWork);
  Result := Format('%s%s',[strTime,CheCi]);
end;

procedure TMealTicketManager.GetTicketInfo();
var
  iA,iB:Integer;
  operMealTicket : TMealTicketOperate ;
  MealType:TRsMealType;
  bIsEast : Boolean ;
  personInfo:RRsMealTicketPersonInfo;
begin
  iA := 0 ;
  iB := 0 ;

  personInfo.strWorkShopGUID := m_strWorkShopGUID;
  personInfo.strTrainmanNumber := m_strTrainmanNumber ;
  personInfo.dtPaiBan := TimeOf(m_dtPaiBanTime) ;
  personInfo.strQuDuan := m_strQuDuan;
  personInfo.strCheCi := m_strCheCi;
  WriteLog('��ȡ���򡭡�');
  //����в��� ��ִ�в������������
  if m_RsLCMealTicket.GetTicket(personInfo,iA,iB) then
  begin
    m_MealTicket.CANQUAN_A := iA ;
    m_MealTicket.CANQUAN_B := iB ;
    m_MealTicket.CANQUAN_C := 0 ;
    WriteLog(Format('��ƱA:%d  ��ƱB:%d',[iA,iB]));
    Exit ;
  end
  else
    WriteLog('û�й���');

  bIsEast := False ;
  //��ȡ��·����
  case m_TrainmanJiaoLu.nJiaoluType of
  jltNamed :
    begin
      operMealTicket := TKeCheMealTicketOperate.Create;
    end;
  jltOrder :
    begin
      if bIsEast then
        operMealTicket := TEastHuoCheMealTicketOperate.Create
      else
        operMealTicket := TWeastHuoCheMealTicketOperate.Create;
    end;
  jltTogether :
    begin
      operMealTicket := TDiaoCheMealTicketOperate.Create;
    end;
  else
    Exit;
  end;




  try
    //��ȡ�ò�����
    MealType := GetMealType(m_dtPaiBanTime) ;
      //��ȡƱ��
    operMealTicket.GetTicket(MealType,m_MealTicket);
  finally
    operMealTicket.Free;
  end;
end;

function TMealTicketManager.GiveMealTicket(TrainmanNumber, TrainmanName,
  ShenHeNumber,ShenHeName: string; iA, iB: Integer; CheCi: string;
  PaiBanTime: TDateTime;out Error:string): Boolean;
var
  dtGive:TDateTime;
  nMinutes: integer;
begin
  Result := False ;
  dtGive := 0 ;
  m_strTrainmanNumber := GetNumber(TrainmanNumber); ;
  m_strTrainmanName := TrainmanName ;
  m_strShenHeNumber := ShenHeNumber ;
  m_strShenHeName := ShenHeName;
  m_dtPaiBanTime := PaiBanTime ;
  m_strCheCi := CheCi ;

  GetGUID;
  GetDriverInfo;
  GetChuQinInfo;
  m_MealTicket.CANQUAN_A := iA ;
  m_MealTicket.CANQUAN_B := iB ;
  GetShenHeInfo;


  
  //���ŷ�Ʊ��ʱ����
  if MealServerConfig.nInterval <> 0 then
  begin
    if m_dbMealTicket.GetCanQuanLastTime(TrainmanNumber,dtGive) then
    begin
      nMinutes := MinutesBetween(m_dtPaiBanTime , dtGive);
      if nMinutes < MealServerConfig.nInterval then
      begin
        Error := '����ʱ��������'; 
        WriteLog(Error);
        Exit;
      end;

    end;
  end;


  if not WriteMealTicket(m_MealTicket)  then
  begin
    Error := '���ŷ�Ʊʧ��';
    Exit;
  end;

  m_RsLCMealTicket.LogMealTicket(m_MealTicket);


  Result := True ;
end;

function TMealTicketManager.IsEastLine(
  TrainmanJiaoLu: RRsTrainmanJiaolu): Boolean;
begin
  if TrainmanJiaoLu.strTrainmanJiaoluName = '��ɽ����ɽ���أ�����' then
    Result := True
  else
    Result := False ;
end;

function TMealTicketManager.IsGivedTicket(TrainmanNumber: string;
  TrainmanPlan: RRsTrainmanPlan;var CanQuanA,CanQuanB,CanQuanC:Integer): Boolean;
var
  strPaiBan:string;
begin
  TrainmanNumber := GetNumber(TrainmanNumber);
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  Result := m_dbMealTicket.IsGivedTicket(strPaiBan,TrainmanNumber,CanQuanA,CanQuanB,CanQuanC)
end;

function TMealTicketManager.ModifyMealTicket(TrainmanNumber: string;
  TrainmanPlan: RRsTrainmanPlan; CanQuanA, CanQuanB, CanQuanC: Integer):Boolean;
var
  strPaiBan:string;
begin
  TrainmanNumber := GetNumber(TrainmanNumber);
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  Result := m_dbMealTicket.Update(strPaiBan,TrainmanNumber,CanQuanA, CanQuanB, CanQuanC);
end;

end.
