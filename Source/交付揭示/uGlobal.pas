unit uGlobal;

interface
uses
  Classes,uMealTicketConfig,SysUtils,SqlExpr,RsGlobal_TLB,uTFComObject,uHttpWebAPI,
  uTFSystem;

type
  TPubJsConfig = class
  private
    class procedure SetDlUpdateTime(value: TDateTime);static;
    class function GetDlUpdateTime(): TDateTime;static;
    class function GetDLFTPConfig: RFTPConfig; static;
    class procedure SetDLFTPConfig(const Value: RFTPConfig); static;
  public
    class property DlUpdateTime: TDateTime read GetDlUpdateTime write SetDlUpdateTime;
    class property DLFTPConfig:RFTPConfig read GetDLFTPConfig write SetDLFTPConfig;
  end;
function GlobalDM: IGlobalProxy;

var
  g_WebAPIUtils: TWebAPIUtils;
implementation

function GlobalDM: IGlobalProxy;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\RsGlobal.dll',CLASS_Global,IUnKnown);
    Result := (ifObj.DefaultInterface  as IGLObal).GetProxy;
  finally
    ifObj.Free;
  end;
end;

{ TPubJsConfig }

class function TPubJsConfig.GetDLFTPConfig: RFTPConfig;
var
  strTemp:string;
begin
  result.strHost := GlobalDM.ReadIniConfig('DLFTP','strHost');
  strTemp:= GlobalDM.ReadIniConfig('DLFTP','nPort');
  if TryStrToInt(strTemp,Result.nPort) = False then
    result.nPort := 21;
  result.strDir := GlobalDM.ReadIniConfig('DLFTP','strDir');
  result.strUserName := GlobalDM.ReadIniConfig('DLFTP','strUserName');
  Result.strPassWord := GlobalDM.ReadIniConfig('DLFTP','strPassWord');
end;


class function TPubJsConfig.GetDlUpdateTime: TDateTime;
var
  strTime:string;
begin
  GlobalDM.ReadIniConfig('SysConfig','DDMLRARUpdateTime');
  Result := StrToDateTimeDef(strTime,0);
end;

class procedure TPubJsConfig.SetDLFTPConfig(const Value: RFTPConfig);
begin
  GlobalDM.WriteIniConfig('DLFTP','strHost',Value.strHost);
  GlobalDM.WriteIniConfig('DLFTP','nPort',IntToStr(Value.nPort));
  GlobalDM.WriteIniConfig('DLFTP','strDir',Value.strDir);
  GlobalDM.WriteIniConfig('DLFTP','strUserName',Value.strUserName);
  GlobalDM.WriteIniConfig('DLFTP','strPassWord',Value.strPassWord);
end;

class procedure TPubJsConfig.SetDlUpdateTime(value: TDateTime);
begin
  GlobalDM.WriteIniConfig('SysConfig','DDMLRARUpdateTime',FormatDateTime('yyyy-mm-dd HH:nn:ss', Value));
end;
initialization
  g_WebAPIUtils := TWebAPIUtils.Create;
finalization
  g_WebAPIUtils.Free;
end.
