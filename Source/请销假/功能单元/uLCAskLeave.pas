unit uLCAskLeave;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uLeaveListInfo,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,windows;
type
   /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLeaveApplyEntity
  /// 说明:请假申请信息
  /////////////////////////////////////////////////////////////////////////////
  TLeaveApplyEntity = Class(TPersistent)
  Protected
    //人员ID
    m_strTrainmanGUID : string;
    //人员工号
    m_strTrainmanNumber : string;
    //开始时间
    m_dtBeginTime : TDateTime;
    //请假类型ID
    m_strTypeGUID : string;
    //请假类型名称
    m_strTypeName : string;
    //备注
    m_strRemark : string;
    //批准人ID
    m_strProverID : string;
    //批准人姓名
    m_strProverName : string;
    //值班员ID
    m_strDutyUserID : string;
    //值班员姓名
    m_strDutyUserName : string;
    //客户端ID
    m_strSiteID : string;
    //客户端名称
    m_strSiteName : string;
    //验证方式
    m_Verify : integer;
  published
    //人员ID
    property strTrainmanGUID : string read m_strTrainmanGUID write m_strTrainmanGUID;
    //人员工号
    property strTrainmanNumber : string read m_strTrainmanNumber write m_strTrainmanNumber;
    //开始时间
    property dtBeginTime : TDateTime read m_dtBeginTime write m_dtBeginTime;
    //请假类型ID
    property strTypeGUID : string read m_strTypeGUID write m_strTypeGUID;
    //请假类型名称
    property strTypeName : string read m_strTypeName write m_strTypeName;
    //备注
    property strRemark : string read m_strRemark write m_strRemark;
    //批准人ID
    property strProverID : string read m_strProverID write m_strProverID;
    //批准人姓名
    property strProverName : string read m_strProverName write m_strProverName;
    //值班员ID
    property strDutyUserID : string read m_strDutyUserID write m_strDutyUserID;
    //值班员姓名
    property strDutyUserName : string read m_strDutyUserName write m_strDutyUserName;
    //客户端ID
    property strSiteID : string read m_strSiteID write m_strSiteID;
    //客户端名称
    property strSiteName : string read m_strSiteName write m_strSiteName;
    //验证方式
    property Verify : integer read m_Verify write m_Verify;
  end;

  
  TRsLCLeaveType = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);  
  public
    //查询所有请假类型
    function QueryLeaveTypes(out LeaveTypeArray: TRsLeaveTypeArray; out ErrMsg: string): boolean;
    
    //通过指定的请假类型名称获取请假类型信息
    function GetLeaveType(strTypeName: string; out LeaveType: RRsLeaveType; out bExist: boolean; out ErrMsg: string): boolean;

    //获取全部请假类别
    function GetLeaveClasses(out LeaveClassArray: TRsLeaveClassArray; out ErrMsg: string): boolean;

    //添加请假类型
    function AddLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;

    //判断是否存在某种请假类型组合
    function ExistLeaveType(LeaveType: RRsLeaveType): boolean;

    //判断是否存在某种请假类型组合，在编辑请假类型时使用
    function ExistLeaveTypeWhenEdit(LeaveType: RRsLeaveType): boolean;

    //删除请假类型
    function DeleteLeaveType(LeaveID: string; out ErrMsg: string): boolean;

    //更新请假类型
    function UpdateLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;

  private
    m_WebAPIUtils:TWebAPIUtils;
    //JSON转请假类型数组    
    procedure JsonToLeaveTypArray(iJson: ISuperObject;out LeaveTypeArray: TRsLeaveTypeArray);
    //请假类型转JSON
    procedure LeaveTypeToJson(const LeaveType: RRsLeaveType;iJson: ISuperObject);
    //JSON转请假类型
    function JsonToLeaveType(iJson: ISuperObject): RRsLeaveType;
    //JSON转请假类别
    function JsonToLeaveClass(iJson: ISuperObject): RRsLeaveClass;
  end;


  TRsLCAskLeave = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override; 
  public
    //给定一个工号，判断该职工是否有未销假的记录
    function CheckWhetherAskLeaveByID(strTrainManID: string; out bExist: boolean; out ErrMsg: string): boolean;

    //请假
    function AskLeave(AskLeave: TLeaveApplyEntity; out ErrMsg: string): Boolean;

    //撤销请假记录
    procedure CancelLeave(AskLeaveGUID : string);

    //传入查询条件，该函数返回相应的请假记录
    procedure GetLeaves(strBeginDateTime: string;strEndDateTime: string;strNumber: string;strType: string;
      strStatus: string; strWorkShopGUID: string; strPost: string; strGroup: string;ShowAllUnEnd: Boolean; out AskLeaveWithTypeArray: TRsAskLeaveWithTypeArray);

    //给定一个工号，返回该职工的请假信息以及所请假的请假类型名称
    function GetValidAskLeaveInfoByID(strTrainManID: string; out AskLeave: RRsAskLeave; out strTypeName: string; out bExist: boolean; out ErrMsg: string): boolean;

    //获取清假详细
    function GetAskLeaveDetail(strAskLeaveGUID: string; out AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;

    //获取销假详细
    function GetCancelLeaveDetail(strAskLeaveGUID: string; out CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;

    //添加销假详情
    function AddCancelLeaveDetail(CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;
  private
    m_WebAPIUtils:TWebAPIUtils;
    m_LCLeaveType: TRsLCLeaveType;

    function JsonToAskLeaveInfo(ijson: ISuperObject): RRsAskLeave;
    function JsonToAskLeaveDetail(ijson: ISuperObject): RRsAskLeaveDetail;
    function JsonToAskLeaveWithType(ijson : ISuperObject) : RRsAskLeaveWithType;
    function JsonToCancelLeaveDetail(ijson: ISuperObject): RRsCancelLeaveDetail;
    function CancelLeaveDetailToJson(CancelLeaveDetail: RRsCancelLeaveDetail): ISuperObject;


  public
    property LCLeaveType: TRsLCLeaveType read m_LCLeaveType; 
  end;
implementation

{ TRsLCLeaveType }

function TRsLCLeaveType.AddLeaveType(LeaveType: RRsLeaveType;
  out ErrMsg: string): boolean;
var
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.O['leaveType'] := SO();
    LeaveTypeToJson(leaveType,JSON.O['leaveType']);
    strInputData := JSON.AsString;
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.AddLeaveType',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message
    end;

  end;
end;


constructor TRsLCLeaveType.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCLeaveType.DeleteLeaveType(LeaveID: string;
  out ErrMsg: string): boolean;
var
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO;
    JSON.S['LeaveID'] := LeaveID;
    strInputData := JSON.AsString;
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.DeleteLeaveType',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;

end;

function TRsLCLeaveType.ExistLeaveType(LeaveType: RRsLeaveType): boolean;var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['leaveType'] := SO();
  LeaveTypeToJson(LeaveType,JSON.O['leaveType']);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.ExistLeaveType',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Result := m_WebAPIUtils.GetHttpDataJson(strOutputData).B['result'];
end;


function TRsLCLeaveType.ExistLeaveTypeWhenEdit(
  LeaveType: RRsLeaveType): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['leaveType'] := SO();
  LeaveTypeToJson(LeaveType,JSON.O['leaveType']);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.ExistLeaveTypeWhenEdit',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Result := m_WebAPIUtils.GetHttpDataJson(strOutputData).B['result'];
end;


function TRsLCLeaveType.GetLeaveClasses(out LeaveClassArray: TRsLeaveClassArray;
  out ErrMsg: string): boolean;
var
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  Result := False;
  try
    strInputData := '';
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.GetLeaveClasses',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

    JSON := JSON.O['leaveClassArray'];


    SetLength(LeaveClassArray,JSON.AsArray.Length);
    for I := 0 to JSON.AsArray.Length - 1 do
    begin
      LeaveClassArray[i] := JsonToLeaveClass(JSON.AsArray[i]);
    end;

    Result := True; 
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;

end;


function TRsLCLeaveType.GetLeaveType(strTypeName: string;
  out LeaveType: RRsLeaveType; out bExist: boolean;
  out ErrMsg: string): boolean;
var                                                                   
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  JSON := SO();
  try
    JSON.S['strTypeName'] := strTypeName;
    strInputData := JSON.AsString;
  
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.GetLeaveType',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

    JSON := JSON.O['leaveTypeArray'];
    
    bExist := JSON.AsArray.Length > 0;

    if bExist then
      LeaveType := JsonToLeaveType(JSON.AsArray[0]);

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;

end;

function TRsLCLeaveType.JsonToLeaveClass(iJson: ISuperObject): RRsLeaveClass;
begin
  Result.nClassID := iJson.I['nClassID'];
  Result.strClassName := iJson.S['strClassName'];
end;

procedure TRsLCLeaveType.JsonToLeaveTypArray(iJson: ISuperObject;
  out LeaveTypeArray: TRsLeaveTypeArray);
var
  I: Integer;
begin
  SetLength(LeaveTypeArray,iJson.AsArray.Length);
  for I := 0 to iJson.AsArray.Length - 1 do
  begin
    LeaveTypeArray[i] := JsonToLeaveType(iJson.AsArray[i]);
  end;
end;

function TRsLCLeaveType.JsonToLeaveType(iJson: ISuperObject): RRsLeaveType;
begin
  Result.strTypeGUID := iJson.S['strTypeGUID'];
  Result.strTypeName := iJson.S['strTypeName'];
  Result.nClassID := iJson.I['nClassID'];
  Result.strClassName := iJson.S['strClassName'];
end;

procedure TRsLCLeaveType.LeaveTypeToJson(const LeaveType: RRsLeaveType;
  iJson: ISuperObject);
begin
  iJson.S['strTypeGUID'] := LeaveType.strTypeGUID;
  iJson.S['strTypeName'] := LeaveType.strTypeName;
  iJson.I['nClassID'] := LeaveType.nClassID;
  iJson.S['strClassName'] := LeaveType.strClassName;    
end;

function TRsLCLeaveType.QueryLeaveTypes(out LeaveTypeArray: TRsLeaveTypeArray;
  out ErrMsg: string): boolean;
var
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  strInputData := '';
  try
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.QueryLeaveTypes',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

    JsonToLeaveTypArray(JSON.O['leaveTypeArray'],leaveTypeArray);
    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;

end;


function TRsLCLeaveType.UpdateLeaveType(LeaveType: RRsLeaveType;
  out ErrMsg: string): boolean;
var
  strInputData,strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := so;
    JSON.O['leaveType'] := SO();
    LeaveTypeToJson(LeaveType,JSON.O['leaveType']);
    strInputData := JSON.AsString;
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCLeaveType.UpdateLeaveType',strInputData);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    result := true;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;

end;


{ TRsLCAskLeave }

function TRsLCAskLeave.AskLeave(AskLeave: TLeaveApplyEntity;
  out ErrMsg: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.O['LeaveApply'] := TJsonSerialize.Serialize(AskLeave);

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.AskLeave',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;


function TRsLCAskLeave.AddCancelLeaveDetail(
  CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.O['CancelLeaveDetail'] := CancelLeaveDetailToJson(CancelLeaveDetail);

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.AddCancelLeaveDetail',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;

procedure TRsLCAskLeave.CancelLeave(AskLeaveGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['AskLeaveGUID'] := AskLeaveGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.CancelLeave',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCAskLeave.CancelLeaveDetailToJson(
  CancelLeaveDetail: RRsCancelLeaveDetail): ISuperObject;
begin
  Result := SO();
  Result.S['strCancelLeaveGUID'] := CancelLeaveDetail.strCancelLeaveGUID;
  Result.S['strAskLeaveGUID'] := CancelLeaveDetail.strAskLeaveGUID;
  Result.S['strTrainmanID'] := CancelLeaveDetail.strTrainmanID;
  Result.S['strProverID'] := CancelLeaveDetail.strProverID;
  Result.S['strProverName'] := CancelLeaveDetail.strProverName;
  Result.S['dtCancelTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',CancelLeaveDetail.dtCancelTime);

  Result.S['dtCreateTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',CancelLeaveDetail.dtCreateTime);


  Result.S['strDutyUserID'] := CancelLeaveDetail.strDutyUserID;
  Result.S['strDutyUserName'] := CancelLeaveDetail.strDutyUserName;
  Result.S['strSiteID'] := CancelLeaveDetail.strSiteID;
  Result.S['strSiteName'] := CancelLeaveDetail.strSiteName;
  Result.I['Verify'] := Ord(CancelLeaveDetail.Verify);
end;

function TRsLCAskLeave.CheckWhetherAskLeaveByID(strTrainManID: string;
  out bExist: boolean; out ErrMsg: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['strTrainManID'] := strTrainManID;

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.CheckWhetherAskLeaveByID',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    bExist := m_WebAPIUtils.GetHttpDataJson(strOutputData).B['result'];

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;


constructor TRsLCAskLeave.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
  m_LCLeaveType := TRsLCLeaveType.Create(WebAPIUtils);
end;

destructor TRsLCAskLeave.Destroy;
begin
  m_LCLeaveType.Free;
  inherited;
end;

function TRsLCAskLeave.GetAskLeaveDetail(strAskLeaveGUID: string;
  out AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['strAskLeaveGUID'] := strAskLeaveGUID;

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.GetAskLeaveDetail',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

    if JSON.B['bExist'] then    
      AskLeaveDetail := JsonToAskLeaveDetail(JSON.O['AskLeaveDetail'])
    else
      ZeroMemory(@AskLeaveDetail,SizeOf(AskLeaveDetail));

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;


function TRsLCAskLeave.GetCancelLeaveDetail(strAskLeaveGUID: string;
  out CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['strAskLeaveGUID'] := strAskLeaveGUID;

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.GetCancelLeaveDetail',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

    if JSON.B['bExist'] then
      CancelLeaveDetail := JsonToCancelLeaveDetail(JSON.O['CancelLeaveDetail'])
    else
      ZeroMemory(@CancelLeaveDetail,SizeOf(CancelLeaveDetail));

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;

procedure TRsLCAskLeave.GetLeaves(strBeginDateTime, strEndDateTime, strNumber,
  strType, strStatus, strWorkShopGUID, strPost, strGroup: string;
  ShowAllUnEnd: Boolean;
  out AskLeaveWithTypeArray: TRsAskLeaveWithTypeArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  i: Integer;
  leave : RRsAskLeaveWithType;
begin
  JSON := SO();
  JSON.S['strBeginDateTime'] := strBeginDateTime;
  JSON.S['strEndDateTime'] := strEndDateTime;
  JSON.S['strLeaveTypeGUID'] := strType;
  JSON.S['strStatus'] := strStatus;
  JSON.S['strWorkShopGUID'] := strWorkShopGUID;
  JSON.S['strPost'] := strPost;
  JSON.S['strGroupGUID'] := strGroup;
  JSON.S['strNumber'] := strNumber;
  JSON.B['ShowAllUnEnd'] := ShowAllUnEnd;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.GetLeaves',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['leavesArray'] ;
  setlength(AskLeaveWithTypeArray,Json.asarray.length);
  for i := 0 to Json.AsArray.length - 1 do
  begin
    leave := JsonToAskLeaveWithType(Json.AsArray.O[i]);
    AskLeaveWithTypeArray[i] := leave;
  end;

end;
function TRsLCAskLeave.GetValidAskLeaveInfoByID(strTrainManID: string;
  out AskLeave: RRsAskLeave; out strTypeName: string; out bExist: boolean;
  out ErrMsg: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['strTrainManID'] := strTrainManID;

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAskLeave.GetValidAskLeaveInfoByID',JSON.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);


    bExist := JSON.B['bExist'];

    strTypeName := TJsonParse.ToString(JSON.O['strTypeName']);
    
    if bExist then
    begin
      JSON := JSON.O['leaveInfo'];
      AskLeave := JsonToAskLeaveInfo(JSON);
    end;

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
    end;
  end;
end;

function TRsLCAskLeave.JsonToAskLeaveDetail(
  ijson: ISuperObject): RRsAskLeaveDetail;
begin
  Result.strAskLeaveDetailGUID := ijson.S['strAskLeaveDetailGUID'];
  Result.strAskLeaveGUID := ijson.S['strAskLeaveGUID'];
  Result.strMemo := ijson.S['strMemo'];
  if ijson.S['dtBeginTime'] <> '' then
    Result.dtBeginTime := StrToDateTime(ijson.S['dtBeginTime']);
  if ijson.S['dtEndTime'] <> '' then
    Result.dtEndTime := StrToDateTime(ijson.S['dtEndTime']);
  Result.strProverID := ijson.S['strProverID'];
  Result.strProverName := ijson.S['strProverName'];
  if ijson.S['dtCreateTime'] <> '' then
    Result.dtCreateTime := StrToDateTime(ijson.S['dtCreateTime']);
  Result.strDutyUserID := ijson.S['strDutyUserID'];
  Result.strDutyUserName := ijson.S['strDutyUserName'];
  Result.strSiteID := ijson.S['strSiteID'];
  Result.strSiteName := ijson.S['strSiteName'];
  Result.Verify := TRsRegisterFlag(ijson.I['Verify']);
end;

function TRsLCAskLeave.JsonToAskLeaveInfo(ijson: ISuperObject): RRsAskLeave;
begin
  Result.strAskLeaveGUID := ijson.S['strAskLeaveGUID'];
  Result.strTrainManID := ijson.S['strTrainManID'];
  Result.strTrainmanName := ijson.S['strTrainmanName'];
  Result.dtBeginTime := StrToDateTimeDef(ijson.S['dtBeginTime'],0);
  Result.dtEndTime := StrToDateTimeDef(ijson.S['dtEndTime'],0);
  Result.strLeaveTypeGUID := ijson.S['strLeaveTypeGUID'];
  Result.nStatus := ijson.I['nStatus'];
  Result.strAskProverID := ijson.S['strAskProverID'];
  Result.strAskProverName := ijson.S['strAskProverName'];
  Result.dtAskCreateTime := StrToDateTimeDef(ijson.S['dtAskCreateTime'],0);
  Result.strAskDutyUserName := ijson.S['strAskDutyUserName'];
  Result.strMemo := ijson.S['strMemo'];
  Result.nPostID := TRsPost(ijson.I['nPostID']);
  Result.strGuideGroupName := ijson.S['strGuideGroupName'];
end;

function TRsLCAskLeave.JsonToAskLeaveWithType(
  ijson: ISuperObject): RRsAskLeaveWithType;
begin
  result.AskLeave :=  JsonToAskLeaveInfo(ijson.O['AskLeave']);
  result.strTypeName := iJson.S['strTypeName'];
end;

function TRsLCAskLeave.JsonToCancelLeaveDetail(
  ijson: ISuperObject): RRsCancelLeaveDetail;
begin
  Result.strCancelLeaveGUID := ijson.S['strCancelLeaveGUID'];
  Result.strAskLeaveGUID := ijson.S['strAskLeaveGUID'];
  Result.strTrainmanID := ijson.S['strTrainmanID'];
  Result.strProverID := ijson.S['strProverID'];
  Result.strProverName := ijson.S['strProverName'];
  if ijson.S['dtCancelTime'] <> '' then
    Result.dtCancelTime := StrToDateTime(ijson.S['dtCancelTime'])
  else
    Result.dtCancelTime := 0;

  if ijson.S['dtCreateTime'] <> '' then
    Result.dtCreateTime := StrToDateTime(ijson.S['dtCreateTime'])
  else
    Result.dtCreateTime := 0;

  Result.strDutyUserID := ijson.S['strDutyUserID'];
  Result.strDutyUserName := ijson.S['strDutyUserName'];
  Result.strSiteID := ijson.S['strSiteID'];
  Result.strSiteName := ijson.S['strSiteName'];
  Result.Verify := TRsRegisterFlag(ijson.I['Verify']);
end;

end.
