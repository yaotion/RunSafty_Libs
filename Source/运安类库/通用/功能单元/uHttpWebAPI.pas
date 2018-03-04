//**************************Web接口站操作基类*********************************//
//****************************************************************************//
unit uHttpWebAPI;

interface
uses
  Classes,uHttpCommEx,IdComponent,uTFSystem,uFrmLoading,superobject,SysUtils,
  IdURI,uwininet,windows;
type
  //事件类型转定义
  TWebAPICompleteEvent = TOnPostCompleteEvent;
  TRecieveHttpDataEvent = procedure(const data: string) of object;
  //******************************WebAPI操作类**********************************
  //***********针对本公司的Web接口网站特点和协议进行通信进行封装****************
  TWebAPIUtils = class
  public
    constructor Create;
    destructor  Destroy;override;
  public
    //功能:检查是否执行成功,成功返回True,失败返回false,失败后strResultText标示原因
    function CheckPostSuccess(strOutputData:String;var strResultText:String):Boolean;
    function GetHttpDataJson(strOutputData:String): ISuperObject;
  public
    //Post方式同步提交数据
    function  Post(APIName : string;InputData : string) : string;
    //Post方式异步提交数据{可以传递2个回调函数，一个是提交成功，一个是提交失败}
    procedure PostAsync(APIName : string;InputData : string;
        OnPostComplete: TOnPostCompleteEvent = nil;
        OnPostFailure: TOnPostCompleteEvent = nil);
    //异步阻塞模式提交数据，有等待框弹出,提交完毕后自动关闭
    procedure PostProgress(APIName : string;InputData : string;var PostResult : string);
    //同步下载文件
    procedure DownloadFile(OffsetUrl,SaveName : string;Params : TStrings;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);
     //异步下载文件
    procedure DownloadFileAsync(OffsetUrl,SaveName : string;Params : TStrings;
        OnDownloadFailure:TOnEventByString;
        OnWorkBegin : TWorkBeginEvent = nil;OnWorkEnd : TWorkEndEvent=nil;
        OnWork : TWorkEvent = nil);
  private
    //Http通信类
    m_HttpComm : THttpComm;
    m_OnRecieveHttpDataEvent: TRecieveHttpDataEvent;
  private
    //主机地址
    m_strHost : string;
    //端口号
    m_nPort : integer;
    //相对地址
    m_strOffsetUrl : string;
  public
    //主机地址
    property Host : string read m_strHost write m_strHost;
    //端口号
    property Port : integer read m_nPort write m_nPort;
    //相对地址
    property OffsetUrl : string read m_strOffsetUrl write m_strOffsetUrl;
    property OnRecieveHttpDataEvent: TRecieveHttpDataEvent read m_OnRecieveHttpDataEvent write m_OnRecieveHttpDataEvent;
  end;

  TWepApiBase = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  protected
    m_WebAPIUtils:TWebAPIUtils;
  public
    class function TimeToJSONString(Value: TDateTime): string;
    class function JSONStringToTime(Value: string): TDateTime;
    class procedure TimeToJSONObj(Owner: ISuperObject;FieldName: string;Value: TDateTime);
  end;


implementation

{ TWebAPIUtils }

function TWebAPIUtils.CheckPostSuccess(strOutputData: String;
  var strResultText:String): Boolean;
var
  JSON : ISuperObject;
begin
  try
    if Assigned(OnRecieveHttpDataEvent) then
      OnRecieveHttpDataEvent(strOutputData);

    JSON := SO(strOutputData);
    if JSON.O['result'] = nil then
    begin
      raise Exception.Create('未找到"result"值');
    end;
    Result := JSON.I['result'] = 0;
    strResultText := JSON.S['resultStr'];
  except
    on E: Exception do
    begin
      Result := False;
      strResultText := '解析失败,错误:('+E.Message+')';
    end;
  end;
  JSON := nil;

end;

constructor TWebAPIUtils.Create;
begin
  m_HttpComm := THttpComm.Create;
  m_strHost := '';
  m_nPort := 80;
  m_strOffsetUrl := '/AshxService/QueryProcess.ashx';
end;

destructor TWebAPIUtils.Destroy;
begin
  m_HttpComm.Free;
  inherited;
end;

procedure TWebAPIUtils.DownloadFile(OffsetUrl, SaveName: string;Params : TStrings;
  OnWorkBegin: TWorkBeginEvent; OnWorkEnd: TWorkEndEvent; OnWork: TWorkEvent);
var
  httpAddress : RHttpAddress;
begin
  httpAddress.Host := m_strHost;
  httpAddress.Port := m_nPort;
  httpAddress.OffsetUrl := OffsetUrl; 
  m_HttpComm.DownloadFile(httpAddress,Params,SaveName,OnWorkBegin,OnWorkEnd,OnWork);
end;

procedure TWebAPIUtils.DownloadFileAsync(OffsetUrl, SaveName: string;Params : TStrings;
  OnDownloadFailure: TOnEventByString; OnWorkBegin: TWorkBeginEvent;
  OnWorkEnd: TWorkEndEvent; OnWork: TWorkEvent);
var
  httpAddress : RHttpAddress;
begin
  httpAddress.Host := m_strHost;
  httpAddress.Port := m_nPort;
  httpAddress.OffsetUrl := OffsetUrl; 
  m_HttpComm.DownloadFileAsync(httpAddress,Params,SaveName,OnDownloadFailure,OnWorkBegin,OnWorkEnd,OnWork);
end;




function TWebAPIUtils.GetHttpDataJson(strOutputData: String): ISuperObject;
begin
  Result := SO(strOutputData);

  Result := Result.O['data'];
end;


function TWebAPIUtils.Post(APIName, InputData: string) : string;
var
  httpAddress : RHttpAddress;
//  params : TStrings;
begin
    httpAddress.Host := m_strHost;
    httpAddress.Port := m_nPort;
    httpAddress.OffsetUrl := m_strOffsetUrl;
  Result := WebPagePost(HttpAddress.ToString(),AnsiToUtf8(Format('DataType=%s&data=%s',[APIName,InputData])));
  
//  params := TStringList.Create;
//  try
//    httpAddress.Host := m_strHost;
//    httpAddress.Port := m_nPort;
//    httpAddress.OffsetUrl := m_strOffsetUrl;
//    params.Add(AnsiToUtf8('datatype='+APIName));
//    params.Add(AnsiToUtf8('data='+InputData));
//    result := m_HttpComm.Post(httpAddress,params);
//  finally
//    params.Free;
//  end;
end;

procedure TWebAPIUtils.PostAsync(APIName, InputData: string; OnPostComplete,
  OnPostFailure: TOnPostCompleteEvent);
var
  httpAddress : RHttpAddress;
  params : TStrings;
begin
  params := TStringList.Create;
  try
    httpAddress.Host := m_strHost;
    httpAddress.Port := m_nPort;
    httpAddress.OffsetUrl := m_strOffsetUrl;
    params.Add(AnsiToUtf8('datatype='+APIName));
    params.Add(AnsiToUtf8('data='+InputData));
    m_HttpComm.PostAsync(httpAddress,params,OnPostComplete,OnPostFailure);
  finally
    params.Free;
  end;
end;

procedure TWebAPIUtils.PostProgress(APIName, InputData: string;var PostResult : string);
begin
  TfrmLoading.ShowLoading;
  try
    PostResult := Post(APIName,InputData);
  finally
    TfrmLoading.CloseLoading;
  end;
end;

{ TWepApiBase }

constructor TWepApiBase.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

class function TWepApiBase.JSONStringToTime(Value: string): TDateTime;
begin
  if Value <> '' then
    Result := StrToDateTimeDef(value,0)
  else
    Result := 0;
end;

class procedure TWepApiBase.TimeToJSONObj(Owner: ISuperObject;FieldName: string;Value: TDateTime);
begin
  if value > 1 then
    Owner.S[FieldName] := TimeToJSONString(value)
end;

class function TWepApiBase.TimeToJSONString(Value: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss',value);
end;

end.
