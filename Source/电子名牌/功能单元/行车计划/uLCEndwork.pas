unit uLCEndwork;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uDutyUser,uTrainPlan,
  uLCBeginWork,uJsonSerialize;
type
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCEndwork
  /// ˵��:TLCEndwork�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TLCEndwork = Class(TWepApiBase)
  public
    //����:��ȡ�ƻ���󵽴�ʱ��
    procedure GetLastArrvieTime(TrainPlanGUID : String; var ArriveTime : TDateTime);
    //����:��ȡ���ڼƻ�
    procedure GetTuiQinPlan(TuiQinPlanGUID : String;Plan : RRsTuiQinPlan);
    //��ȡָ������ʱ����ص���Ա�����ڼƻ�
    function GetEndworkPlanByTime(TrainmanNumber: string;TuiQinTime: TDateTime;
      SiteGUID: string; out Plan: RRsTuiQinPlan): Boolean;
      
    procedure RelDrink(Param: TRelDrinkParam);
  end;

implementation
uses
  uLCTrainPlan;
 
function EnGetLastArrvieTimeInputJSON(TrainPlanGUID : String):String;
//����:����(��ȡ�ƻ���󵽴�ʱ��)�ӿ��������JSON�ַ���
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure DeGetLastArrvieTimeOutputJSON(strJSON:String; var ArriveTime : TDateTime);
//����:����(��ȡ�ƻ���󵽴�ʱ��)�ӿڷ��ز���
var
  JSON : ISuperObject;
begin
  JSON := SO(strJSON);
  JSON := JSON.O['data'];
  try
    if JSON.S['ArriveTime'] <> '' then
      ArriveTime := StrToDateTime(JSON.S['ArriveTime']);
  finally
    JSON := nil;
  end;       
end;

function TLCEndwork.GetEndworkPlanByTime(TrainmanNumber: string;
  TuiQinTime: TDateTime; SiteGUID: string;out Plan: RRsTuiQinPlan): Boolean;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  JSON.S['TuiQinTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',TuiQinTime);
  JSON.S['SiteGUID'] := SiteGUID;

  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCEndwork.Plan.GetByTime',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;

  if Result then
  begin
    TRsLCTrainPlan.JsonToTuiQinData(Plan,JSON.O['Plan']);
  end;

end;

procedure TLCEndwork.GetLastArrvieTime(TrainPlanGUID : String; var ArriveTime : TDateTime);
//����:��ȡ�ƻ���󵽴�ʱ��
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnGetLastArrvieTimeInputJSON(TrainPlanGUID);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.Endwork.GetPlanLastArriveTime',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  DeGetLastArrvieTimeOutputJSON(strOutputData,ArriveTime);
end;


function EnGetTuiQinPlanInputJSON(TuiQinPlanGUID : String):String;
//����:����(��ȡ���ڼƻ�)�ӿ��������JSON�ַ���
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TuiQinPlanGUID'] := TuiQinPlanGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure DeGetTuiQinPlanOutputJSON(strJSON:String;Plan : RRsTuiQinPlan);
//����:����(��ȡ���ڼƻ�)�ӿڷ��ز���
var
  ItemJSON : ISuperObject;
  JSON : ISuperObject;
begin
  JSON := SO(strJSON);
  JSON := JSON.O['data'];
  try
    ItemJSON := JSON.O['Plan'];
    TRsLCTrainPlan.JsonToTuiQinData(Plan,ItemJson);
  finally
    JSON := nil;
  end;
end;


procedure TLCEndwork.GetTuiQinPlan(TuiQinPlanGUID : String;Plan : RRsTuiQinPlan);
//����:��ȡ���ڼƻ�
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnGetTuiQinPlanInputJSON(TuiQinPlanGUID);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.EndWork.Get',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  DeGetTuiQinPlanOutputJSON(strOutputData,Plan);
end;         
procedure TLCEndwork.RelDrink(Param: TRelDrinkParam);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Param);
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCEndwork.Union',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
end.
