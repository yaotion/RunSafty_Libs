unit RsUtils_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsUtilsLib_TLB,SuperObject, StdVcl;

type
  TWebAPI = class(TAutoObject, IWebAPI)
  protected
    function Post(const APIName, InputData: WideString): WideString; safecall;
    function CheckPostSuccess(const strOutputData: WideString;
      var strResultText: WideString): WordBool; safecall;
    function GetHttpDataJson(const strOutputData: WideString): IUnknown; safecall;
    function Get_Host: WideString; safecall;
    function Get_OffsetUrl: WideString; safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Host(const Value: WideString); safecall;
    procedure Set_OffsetUrl(const Value: WideString); safecall;
    procedure Set_Port(Value: Integer); safecall;
  private
     //主机地址
    m_strHost : string;
    //端口号
    m_nPort : integer;
    //相对地址
    m_strOffsetUrl : string;
  end;
  RHttpAddress = record
    //主机地址
    Host : string;
    //端口号
    Port : integer;
    //提交页面的相对Url
    OffsetUrl : string;
    //转化为字符串格式
    function ToString() : string;
  end;
implementation

uses ComServ,uWiniNet,SysUtils;



{ TWebAPI }

function TWebAPI.Post(const APIName, InputData: WideString): WideString;
var
  httpAddress : RHttpAddress;
begin
  httpAddress.Host := m_strHost;
  httpAddress.Port := m_nPort;
  httpAddress.OffsetUrl := m_strOffsetUrl;
  Result := WebPagePost(HttpAddress.ToString(),AnsiToUtf8(Format('DataType=%s&data=%s',[APIName,InputData])));
end;

function TWebAPI.CheckPostSuccess(const strOutputData: WideString;
  var strResultText: WideString): WordBool;
var
  JSON : ISuperObject;
begin
  try
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

function TWebAPI.GetHttpDataJson(const strOutputData: WideString): IUnknown;
begin
  Result := SO(strOutputData)  ;
  Result := (Result as ISuperObject).O['data'];
end;

function TWebAPI.Get_Host: WideString;
begin
  result := m_strHost;
end;

function TWebAPI.Get_OffsetUrl: WideString;
begin
  result := m_strOffsetUrl;
end;

function TWebAPI.Get_Port: Integer;
begin
  result := m_nPort;
end;

procedure TWebAPI.Set_Host(const Value: WideString);
begin
  m_strHost := value;
end;

procedure TWebAPI.Set_OffsetUrl(const Value: WideString);
begin
  m_strOffsetUrl := Value;
end;

procedure TWebAPI.Set_Port(Value: Integer);
begin
  m_nPort := Value;
end;

{ RHttpAddress }

function RHttpAddress.ToString: string;
begin
  result := Format('http://%s:%d%s',[Host,Port,OffsetUrl]);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWebAPI, Class_WebAPI,
    ciMultiInstance, tmApartment);
end.
