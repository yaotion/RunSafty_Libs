unit uGlobal;

interface
uses
  Classes,SysUtils,RsGlobal_TLB,uTFComObject,uHttpWebAPI,
  Forms;
type
  TConfig = class
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Load;
    procedure Save;  
  public
    HostUrl : string;
    AllowOffline : boolean;
    Autologin : boolean;
    KeepPassword : boolean;
    UserNumber : string;
    Password : string;
  end;
var
  g_WebAPIUtils: TWebAPIUtils;
  g_GlobalConfig : TConfig;
function GlobalDM: IGlobalProxy;
function GlobalConfig : TConfig;
implementation

function SplitString(const Source,ch:String):TStringList;
var
temp:String;
i:Integer;
begin
Result:=TStringList.Create;
//如果是空自符串则返回空列表
if Source=''
then exit;
temp:=Source;
i:=pos(ch,Source);
while i<>0 do
begin
Result.add(copy(temp,0,i-1));
Delete(temp,1,i);
i:=pos(ch,temp);
end;
Result.add(temp);
end;

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
function GlobalConfig : TConfig;
begin
  result := g_GlobalConfig;
end;

{ TConfig }

constructor TConfig.Create;
begin

end;

destructor TConfig.Destroy;
begin

  inherited;
end;

procedure TConfig.Load;
begin
  //服务器地址
  HostUrl := GlobalDM.ReadIniConfig('WebApi','URL') ;
  //自动登录
  TryStrToBool(GlobalDM.ReadIniConfig('Setup','Autologin'),Autologin);
  //允许断网模式
  TryStrToBool(GlobalDM.ReadIniConfig('Setup','AllowOffline'),AllowOffline);
  //保存密码
  TryStrToBool(GlobalDM.ReadIniConfig('Setup','KeepPassword'),KeepPassword);
  //用户名
  UserNumber := GlobalDM.ReadIniConfig('UserInfo','UserNumber');
  //密码
  Password := GlobalDM.ReadIniConfig('UserInfo','Password');
end;

procedure TConfig.Save;
begin
//   //服务器地址
  GlobalDM.WriteIniConfig('WebApi','URL',HostUrl);
  //允许断网模式
  GlobalDM.WriteIniConfig('Setup','AllowOffline',BoolToStr(AllowOffline));
  //自动登录
  GlobalDM.WriteIniConfig('Setup','Autologin',BoolToStr(Autologin));
  //保存密码
  GlobalDM.WriteIniConfig('Setup','KeepPassword',BoolToStr(KeepPassword));

  //用户名
  GlobalDM.WriteIniConfig('UserInfo','UserNumber',UserNumber);
  //密码
  GlobalDM.writeIniConfig('UserInfo','Password',Password);
end;

initialization
  g_WebAPIUtils := TWebAPIUtils.Create;
  g_GlobalConfig := TConfig.Create;
finalization
  g_WebAPIUtils.Free;
  g_GlobalConfig.Free;
end.
