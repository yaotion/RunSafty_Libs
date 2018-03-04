unit uLCBeginwork;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uDutyUser,uTrainPlan,uDrink,
  uLCDrink,uLCTrainPlan,uCheckRecord,uJsonSerialize;
type
   //允许出勤信息
   RRsTrainplanBeginworkFlow = record
    strTrainPlanGUID : string;
    strWorkShopGUID : string;
    dtCreateTime : TDateTime;
    nFlowState : integer;
    strDutyUserName : string;
    strDutyUserGUID : string;
    strDutyUserNumber : string;
    dtConfirmTime : TDateTime;
    strBrief : string;
  end;

   RRsBeginworkFlow = record
    nid : integer;
    strWorkShopGUID : string;
    nStepID : integer;
    nStepIndex : integer;
    strStepName : string;
    nStepType : integer;
  end;
   TRsBeginworkFlowArray = array of RRsBeginworkFlow;

   RRsTrainmanBeginworkStep = record
    strTrainPlanGUID : string;
    nStepID : integer;
    strTrainmanGUID : string;
    strTrainmanNumber : string;
    strTrainmanName : string;
    nStepResultID : integer;
    strStepResultText : string;
    dtCreateTime : TDateTime;
    dtEventTime : TDateTime;
  end;
   TRsTrainmanBeginworkStepArray = array of RRsTrainmanBeginworkStep;

  TRelDrinkParam = class(TPersistent)
  private
    m_TmGUID: string;
    m_TmNumber: string;
    m_PlanGUID: string;
    m_DrinkGUID: string;
    m_DutyGUID: string;
    m_SiteGUID: string;
  published
    property TmGUID: string read m_TmGUID write m_TmGUID;
    property TmNumber: string read m_TmNumber write m_TmNumber;
    property PlanGUID: string read m_PlanGUID write m_PlanGUID;
    property DrinkGUID: string read m_DrinkGUID write m_DrinkGUID;
    property DutyGUID: string read m_DutyGUID write m_DutyGUID;
    property SiteGUID: string read m_SiteGUID write m_SiteGUID;
  end;                   
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLCBeginwork
  /// 说明:TLCBeginwork接口类
  /////////////////////////////////////////////////////////////////////////////
  TLCBeginwork = Class                                            
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:上传出勤记录                                               
    procedure Submit(TrainmanGUID : String;TrainPlanGUID : String;DrinkInfo : RRsDrink);
    //功能:清除指定人员的出勤记录
    procedure Clear(PlanGUID : String;TrainmanNumber : String);
    //乘务员是否已经出勤
    function IsBeginWorking(TrainmanGUID,TrainPlanGUID: string): Boolean;
    //关联已有测酒记录
    procedure ImportBeginWork(TrainmanGUID,TrainPlanGUID: string;Drink: RRsDrink;VerifyID: integer;Remark: string);
    //获取指定出勤时间相关的人员的出勤计划
    function GetBeginworkPlanByTime(TrainmanNumber: string;ChuQinTime: TDateTime;SiteGUID: string;
      out Plan: RRsChuQinPlan): Boolean;
    // 执行允许出勤操作
    procedure AllowBeginwork(AllowInfo: RRsTrainplanBeginworkFlow);

    //获取乘务员出勤卡空结果信息
    procedure GetTrainmanCheckRecord(TrainNumber:string;CheckTime : TDateTime;out CheckRecordArray : TRsCheckRecordArray);

    procedure RelDrink(Param: TRelDrinkParam);
    
    //获取计划的出勤步骤信息
    procedure GetPlanBeginworkFlow(TrainPlanGUID : string;WorkShopGUID : string;
      out FlowArray : TRsBeginworkFlowArray; out StepArray : TRsTrainmanBeginworkStepArray;
      out TrainFlow : RRsTrainplanBeginworkFlow);
  Private
    m_WebAPIUtils:TWebAPIUtils;
    function JsonToCheckRecord(iJson: ISuperObject): RRsCheckRecord;
    function JsonToFlow(iJson: ISuperObject): RRsBeginworkFlow;
    function JsonToStep(iJson: ISuperObject): RRsTrainmanBeginworkStep;
    function JsonToTrainFlow(iJson: ISuperObject): RRsTrainplanBeginworkFlow;
  end;

implementation


function EnSubmitInputJSON(TrainmanGUID : String;TrainPlanGUID : String;DrinkInfo : RRsDrink):String;
//功能:生成(上传出勤记录)接口输入参数JSON字符串
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainmanGUID'] := TrainmanGUID;
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    JSON.I['VerifyID'] := DrinkInfo.nVerifyID;
    ItemJSON := SO('{}');
    ItemJSON.I['nid'] := 0;
    ItemJSON.S['strGUID'] := DrinkInfo.strGUID;
    ItemJSON.S['trainmanID'] := DrinkInfo.strTrainmanGUID;
    ItemJSON.I['drinkResult'] := DrinkInfo.nDrinkResult;
    ItemJSON.S['strAreaGUID'] := DrinkInfo.strAreaGUID;
    ItemJSON.B['bLocalAreaTrainman'] := DrinkInfo.bLocalAreaTrainman;
    ItemJSON.S['createTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',DrinkInfo.dtCreateTime);
    ItemJSON.S['imagePath'] := DrinkInfo.strPictureURL;    
    ItemJSON.S['strTrainmanName'] := DrinkInfo.strTrainmanName;
    ItemJSON.S['strTrainmanNumber'] := DrinkInfo.strTrainmanNumber;
    ItemJSON.S['strTrainNo'] := DrinkInfo.strTrainNo;
    ItemJSON.S['strTrainNumber'] := DrinkInfo.strTrainNumber;
    ItemJSON.S['strTrainTypeName'] := DrinkInfo.strTrainTypeName;
    ItemJSON.S['strWorkShopGUID'] := DrinkInfo.strWorkShopGUID;
    ItemJSON.S['strWorkShopName'] := DrinkInfo.strWorkShopName;
    ItemJSON.S['strPlaceID'] := DrinkInfo.strPlaceID;
    ItemJSON.S['strPlaceName'] := DrinkInfo.strPlaceName;
    ItemJSON.S['strSiteGUID'] := DrinkInfo.strSiteGUID;
    ItemJSON.S['strSiteName'] := DrinkInfo.strSiteName;
    ItemJSON.I['dwAlcoholicity'] := DrinkInfo.dwAlcoholicity;
    ItemJSON.I['nWorkTypeID'] := DrinkInfo.nWorkTypeID;
    JSON.O['DrinkInfo'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

function EnClearInputJSON(PlanGUID : String;TrainmanNumber : String):String;
//功能:生成(清除指定人员的出勤记录)接口输入参数JSON字符串
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['PlanGUID'] := PlanGUID;
    JSON.S['TrainmanNumber'] := TrainmanNumber;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;
constructor TLCBeginwork.Create(WebAPIUtils:TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TLCBeginwork.GetBeginworkPlanByTime(TrainmanNumber: string;
  ChuQinTime: TDateTime; SiteGUID: string; out Plan: RRsChuQinPlan): Boolean;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  JSON.S['ChuQinTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',ChuQinTime);
  JSON.S['SiteGUID'] := SiteGUID;

  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.Plan.GetByTime',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;

  if Result then
  begin
    TRsLCTrainPlan.JsonToChuQinData(Plan,JSON.O['Plan']);
  end;

end;

procedure TLCBeginwork.GetPlanBeginworkFlow(TrainPlanGUID, WorkShopGUID: string;
  out FlowArray: TRsBeginworkFlowArray;
  out StepArray: TRsTrainmanBeginworkStepArray;
  out TrainFlow: RRsTrainplanBeginworkFlow);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  i : integer;
begin
  JSON := SO;
  JSON.S['TrainPlanGUID'] := TrainPlanGUID;
  JSON.S['WorkShopGUID'] := WorkShopGUID;

  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.Plan.GetPlanFlow',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(FlowArray,JSON.O['FlowArray'].AsArray.Length);
  for I := 0 to Length(FlowArray) - 1 do
  begin
    FlowArray[i] := JsonToFlow(JSON.O['FlowArray'].AsArray[i]);
  end;

  SetLength(StepArray,JSON.O['StepArray'].AsArray.Length);
  for I := 0 to Length(StepArray) - 1 do
  begin
    StepArray[i] := JsonToStep(JSON.O['StepArray'].AsArray[i]);
  end;

  TrainFlow := JsonToTrainFlow(JSON.O['TrainFlow']);

end;

procedure TLCBeginwork.GetTrainmanCheckRecord(TrainNumber: string;
  CheckTime: TDateTime; out CheckRecordArray: TRsCheckRecordArray);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['TrainNumber'] := TrainNumber;
  JSON.S['CheckTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',CheckTime);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.CheckRecords.Query',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(CheckRecordArray,JSON.O['CheckRecords'].AsArray.Length);
  for I := 0 to Length(CheckRecordArray) - 1 do
  begin
    CheckRecordArray[i] := JsonToCheckRecord(JSON.O['CheckRecords'].AsArray[i]);
  end;



  
end;
procedure TLCBeginwork.ImportBeginWork(TrainmanGUID, TrainPlanGUID: string;
  Drink: RRsDrink; VerifyID: integer; Remark: string);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  ItemJSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  JSON.S['TrainPlanGUID'] := TrainPlanGUID;
  JSON.I['VerifyID'] := VerifyID;
  JSON.S['Remark'] := Remark;


  //测酒信息序列化，和测酒接口不一致，暂时先写到这，后期再统一
  ItemJSON := SO('{}');
  ItemJSON.I['nid'] := 0;
  ItemJSON.S['strGUID'] := Drink.strGUID;
  ItemJSON.S['trainmanID'] := Drink.strTrainmanGUID;
  ItemJSON.I['drinkResult'] := Drink.nDrinkResult;
  ItemJSON.S['strAreaGUID'] := Drink.strAreaGUID;
  ItemJSON.B['bLocalAreaTrainman'] := Drink.bLocalAreaTrainman;
  ItemJSON.S['createTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',Drink.dtCreateTime);
  ItemJSON.S['imagePath'] := Drink.strPictureURL;    
  ItemJSON.S['strTrainmanName'] := Drink.strTrainmanName;
  ItemJSON.S['strTrainmanNumber'] := Drink.strTrainmanNumber;
  ItemJSON.S['strTrainNo'] := Drink.strTrainNo;
  ItemJSON.S['strTrainNumber'] := Drink.strTrainNumber;
  ItemJSON.S['strTrainTypeName'] := Drink.strTrainTypeName;
  ItemJSON.S['strWorkShopGUID'] := Drink.strWorkShopGUID;
  ItemJSON.S['strWorkShopName'] := Drink.strWorkShopName;
  ItemJSON.S['strPlaceID'] := Drink.strPlaceID;
  ItemJSON.S['strPlaceName'] := Drink.strPlaceName;
  ItemJSON.S['strSiteGUID'] := Drink.strSiteGUID;
  ItemJSON.S['strSiteName'] := Drink.strSiteName;
  ItemJSON.I['dwAlcoholicity'] := Drink.dwAlcoholicity;
  ItemJSON.I['nWorkTypeID'] := Drink.nWorkTypeID;
  JSON.O['DrinkInfo'] := ItemJSON;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.Union',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TLCBeginwork.IsBeginWorking(TrainmanGUID,
  TrainPlanGUID: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  JSON.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.TrainmanIsBeginwork',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;
end;

function TLCBeginwork.JsonToCheckRecord(iJson: ISuperObject): RRsCheckRecord;
begin
  Result.nPointID := iJson.I['nPointID'];
  Result.strPointName := iJson.S['strPointName'];
  Result.nIsHold := iJson.I['nIsHold'];
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  Result.strItemContent := iJson.S['strItemContent'];
  Result.nCheckResult := iJson.I['nCheckResult'];
  Result.dtCheckTime := StrToDateTime(iJson.S['dtCheckTime']);
  Result.dtCreateTime := StrToDateTime(iJson.S['dtCreateTime']); 
end;

function TLCBeginwork.JsonToFlow(iJson: ISuperObject): RRsBeginworkFlow;
begin

  result.nid := iJson.I['nid'];
  result.strWorkShopGUID := iJson.s['strWorkShopGUID'];
  result.nStepID := iJson.I['nStepID'];
  result.nStepIndex := iJson.I['nStepIndex'];
  result.strStepName := iJson.S['strStepName'];
  result.nStepType := iJson.I['nStepType'];
end;

function TLCBeginwork.JsonToStep(iJson: ISuperObject): RRsTrainmanBeginworkStep;
begin
  result.strTrainPlanGUID  := iJson.S['strTrainPlanGUID'];
  result.nStepID  := iJson.I['nStepID'];
  result.strTrainmanGUID  := iJson.S['strTrainmanGUID'];
  result.strTrainmanNumber  := iJson.S['strTrainmanNumber'];
  result.strTrainmanName  := iJson.S['strTrainmanName'];
  result.nStepResultID  := iJson.I['nStepResultID'];
  result.strStepResultText  := iJson.S['strStepResultText'];
  result.dtCreateTime  := StrToDateTime(iJson.S['dtCreateTime']);
  result.dtEventTime  := StrToDateTime(iJson.S['dtEventTime']);
end;

function TLCBeginwork.JsonToTrainFlow(
  iJson: ISuperObject): RRsTrainplanBeginworkFlow;
begin
  result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
  result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  result.dtCreateTime := StrToDateTime(iJson.S['dtCreateTime']);
  result.nFlowState := iJson.I['nFlowState'];
  result.strDutyUserName := iJson.S['strDutyUserName'];
  result.strDutyUserGUID := iJson.S['strDutyUserGUID'];
  result.strDutyUserNumber := iJson.S['strDutyUserNumber'];
  result.dtConfirmTime := StrToDateTime(iJson.S['dtConfirmTime']);
  result.strBrief := iJson.S['strBrief'];
end;

procedure TLCBeginwork.RelDrink(Param: TRelDrinkParam);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Param);
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.Union',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
procedure TLCBeginwork.Submit(TrainmanGUID : String;TrainPlanGUID : String;DrinkInfo : RRsDrink);
//功能:上传出勤记录
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnSubmitInputJSON(TrainmanGUID,TrainPlanGUID,DrinkInfo);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.BeginWork.Submit',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TLCBeginwork.AllowBeginwork(AllowInfo: RRsTrainplanBeginworkFlow);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;

  JSON.S['AllowData.strTrainPlanGUID']  := AllowInfo.strTrainPlanGUID;
  JSON.S['AllowData.strWorkShopGUID']  := AllowInfo.strWorkShopGUID;
  JSON.S['AllowData.dtCreateTime']  := FormatDateTime('yyyy-mm-dd hh:nn:ss',AllowInfo.dtCreateTime);
  JSON.I['AllowData.nFlowState']  := AllowInfo.nFlowState;
  JSON.S['AllowData.strDutyUserName']  := AllowInfo.strDutyUserName;
  JSON.S['AllowData.strDutyUserGUID']  := AllowInfo.strDutyUserGUID;
  JSON.S['AllowData.strDutyUserNumber']  := AllowInfo.strDutyUserNumber;
  JSON.S['AllowData.dtConfirmTime']  := FormatDateTime('yyyy-mm-dd hh:nn:ss',AllowInfo.dtConfirmTime);
  JSON.S['AllowData.strBrief']  := AllowInfo.strBrief;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCBeginwork.AllowBeginwork',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TLCBeginwork.Clear(PlanGUID : String;TrainmanNumber : String);
//功能:清除指定人员的出勤记录
var
  strInputData,strOutputData,strResultText : String;

begin
  strInputData := EnClearInputJSON(PlanGUID,TrainmanNumber);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.BeginWork.Clear',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

end.
