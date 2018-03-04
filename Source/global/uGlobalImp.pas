unit uGlobalImp;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsGlobal_TLB, StdVcl,Classes,uVariantDict,SysUtils,
  IniFiles;

type
  TDictImp = class(TInterfacedObject)
  public
    constructor Create;
    destructor Destroy;override;
  protected
    m_Dict: TVariantDict;
  end;
  
  TSiteImp = class(TDictImp,ISite)
  protected
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
  end;

  
  TUserImp = class(TDictImp,IUser)
  protected
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
  end;


  TWorkShopImp = class(TDictImp,IWorkShop)
  protected
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
  end;

  TWebAPIImp = class(TInterfacedObject,IWebAPI)
  private
    m_URL: WideString;
    function Get_Host: WideString; safecall;
    function Get_Port: SYSINT; safecall;
    function Get_URL: WideString; safecall;
    procedure Set_URL(const Value: WideString); safecall;
  end;


  TGlobalProxyImp = class(TInterfacedObject,IGlobalProxy)
  public
    constructor Create;
    destructor Destroy;override;
  protected
    m_Site: ISite;
    m_User: IUser;
    m_WorkShop: IWorkShop;
    m_WebAPI: IWebAPI;
    m_OleVariantDict: TOleVariantDict;
    m_AppHandle: SYSUINT;
    function IniFileName(): string;
    function Get_Site: ISite; safecall;
    function Get_User: IUser; safecall;
    function Get_WorkShop: IWorkShop; safecall;
    
    function ReadIniConfig(const Section, Ident: WideString): WideString; safecall;
    procedure WriteIniConfig(const Section, Ident, Value: WideString); safecall;
    function ReadServerConfig(const Section, Ident: WideString): WideString;
      safecall;
    procedure WriteServerConfig(const Section, Ident, Value: WideString); safecall;
    function Get_WebAPI: IWebAPI; safecall;

    function Get_Value(const Key: WideString): OleVariant; safecall;
    procedure Set_Value(const Key: WideString; Value: OleVariant); safecall;

    function Get_AppHandle: SYSUINT; safecall;
    procedure Set_AppHandle(Value: SYSUINT); safecall;

    function Get_PlaceID: WideString; safecall;
    
    function Now: TDateTime; safecall;
  end;

  TGlobal = class(TAutoObject, IGlobal)
  protected
    function GetProxy: IGlobalProxy; safecall;
  end;

implementation

uses ComServ,uLCCommon;

var
  _GlobalProxy: IGlobalProxy = nil;
{ TSiteImp }

function TSiteImp.Get_ID: WideString;
begin
  Result := m_Dict.ValueAsString('ID');
end;

function TSiteImp.Get_Name: WideString;
begin
  Result := m_Dict.ValueAsString('Name');
end;

function TSiteImp.Get_Number: WideString;
begin
  Result := m_Dict.ValueAsString('Number');
end;

procedure TSiteImp.Set_ID(const Value: WideString);
begin
  m_Dict.Values['ID'] := Value;
end;

procedure TSiteImp.Set_Name(const Value: WideString);
begin
  m_Dict.Values['Name'] := Value;
end;

procedure TSiteImp.Set_Number(const Value: WideString);
begin
  m_Dict.Values['Number'] := Value;
end;

{ TUserImp }

function TUserImp.Get_ID: WideString;
begin
  Result := m_Dict.ValueAsString('ID');
end;

function TUserImp.Get_Name: WideString;
begin
  Result := m_Dict.ValueAsString('Name');
end;

function TUserImp.Get_Number: WideString;
begin
  Result := m_Dict.ValueAsString('Number');
end;

procedure TUserImp.Set_ID(const Value: WideString);
begin
  m_Dict.Values['ID'] := Value;
end;

procedure TUserImp.Set_Name(const Value: WideString);
begin
  m_Dict.Values['Name'] := Value;
end;

procedure TUserImp.Set_Number(const Value: WideString);
begin
  m_Dict.Values['Number'] := Value;
end;

{ TWorkShopImp }

function TWorkShopImp.Get_ID: WideString;
begin
  Result := m_Dict.ValueAsString('ID');
end;

function TWorkShopImp.Get_Name: WideString;
begin
  Result := m_Dict.ValueAsString('Name');
end;

procedure TWorkShopImp.Set_ID(const Value: WideString);
begin
  m_Dict.Values['ID'] := Value;
end;

procedure TWorkShopImp.Set_Name(const Value: WideString);
begin
  m_Dict.Values['Name'] := Value;
end;

{ TDictImp }

constructor TDictImp.Create;
begin
  m_Dict := TVariantDict.Create;
end;

destructor TDictImp.Destroy;
begin
  m_Dict.Free;
  inherited;
end;

{ TWebAPIImp }

function TWebAPIImp.Get_Host: WideString;
var
  nIndex: integer;
  sUrl: string;
begin
  sUrl := m_URL;
  sUrl := LowerCase(Trim(sUrl));
  nIndex := Pos('http://',sUrl);
  if nIndex > 0 then
  begin
    Result := Copy(sUrl,nIndex + 7,Length(sUrl) - nIndex - 6);

    nIndex := Pos(':',Result);
    if nIndex > 0 then
    begin
      Result := Copy(Result,1,nIndex - 1 );
    end;
  end
  else
    Result := '';
end;

function TWebAPIImp.Get_Port: SYSINT;
var
  nIndex,nindex1: integer;
  surl: string;
begin
  surl := m_URL;
  surl := LowerCase(Trim(surl));
  nIndex := Pos('http://',surl);
  if nIndex > 0 then
  begin
    surl := Copy(surl,nIndex + 7,Length(surl) - nIndex - 6);
    nIndex := Pos(':',surl);
    if nIndex > 0 then
    begin
      surl := Copy(surl,nIndex + 1,length(surl) - nIndex);
      
      nindex1 := Pos('/',surl);
      if nindex1 > 0 then
      begin
        surl := Copy(surl,1,nindex1 - 1)
      end;

        Result := StrToIntDef(surl,80);
    end
    else
      Result := 80;

  end
  else
    Result := 80;
end;

function TWebAPIImp.Get_URL: WideString;
begin
  Result := m_URL;
end;


procedure TWebAPIImp.Set_URL(const Value: WideString);
begin
  m_URL := Value;
end;

{ TGlobalProxyImp }

constructor TGlobalProxyImp.Create;
begin
  m_Site := TSiteImp.Create;
  m_User := TUserImp.Create;
  m_WorkShop := TWorkShopImp.Create;
  m_WebAPI := TWebAPIImp.Create;
  m_OleVariantDict := TOleVariantDict.Create;

  m_WebAPI.URL := ReadIniConfig('WebApi','URL') + '/AshxService/QueryProcess.ashx?';;
end;

destructor TGlobalProxyImp.Destroy;
begin
  m_OleVariantDict.Free;
  m_User := nil;
  m_Site := nil;
  m_WorkShop := nil;
  m_WebAPI := nil;
  inherited;
end;

function TGlobalProxyImp.Get_AppHandle: SYSUINT;
begin
  Result := m_AppHandle;
end;

function TGlobalProxyImp.Get_PlaceID: WideString;
begin
  Result := ReadIniConfig('UserData','PlanDutyPlaceID');
end;

function TGlobalProxyImp.Get_Site: ISite;
begin
  Result := m_Site;
end;

function TGlobalProxyImp.Get_User: IUser;
begin
  Result := m_User;
end;

function TGlobalProxyImp.Get_Value(const Key: WideString): OleVariant;
begin
  Result := m_OleVariantDict.Values[key]; 
end;

function TGlobalProxyImp.Get_WebAPI: IWebAPI;
begin
  Result := m_WebAPI;
end;

function TGlobalProxyImp.Get_WorkShop: IWorkShop;
begin
  Result := m_WorkShop;
end;

function TGlobalProxyImp.IniFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'Config.ini';
end;

function TGlobalProxyImp.Now: TDateTime;
var
  RsLCCommon: TRsLCCommon;
  ErrInfo: string;
begin
  RsLCCommon := TRsLCCommon.Create(m_WebAPI.URL,m_Site.Number,m_Site.ID);
  try
    Result := RsLCCommon.GetNow(ErrInfo);
  finally
    RsLCCommon.Free;
  end;
end;


function TGlobalProxyImp.ReadIniConfig(const Section,
  Ident: WideString): WideString;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(IniFileName);
  try
    result := ini.ReadString(Section, Ident, '');
  finally
    Ini.Free;
  end;
end;

function TGlobalProxyImp.ReadServerConfig(const Section,
  Ident: WideString): WideString;
var
  RsLCCommon: TRsLCCommon;
  ErrInfo: string;
begin
  RsLCCommon := TRsLCCommon.Create(m_WebAPI.URL,m_Site.Number,m_Site.ID);
  try
    Result := RsLCCommon.GetDBSysConfig(Section, Ident, ErrInfo);
  finally
    RsLCCommon.Free;
  end;
end;
procedure TGlobalProxyImp.Set_AppHandle(Value: SYSUINT);
begin
  m_AppHandle := Value;
end;

procedure TGlobalProxyImp.Set_Value(const Key: WideString; Value: OleVariant);
begin
  m_OleVariantDict.Values[key] := Value;
end;

procedure TGlobalProxyImp.WriteIniConfig(const Section, Ident,
  Value: WideString);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(IniFileName);
  try
    ini.WriteString(Section, Ident, Value);
  finally
    Ini.Free;
  end;
end;

procedure TGlobalProxyImp.WriteServerConfig(const Section, Ident,
  Value: WideString);
var
  RsLCCommon: TRsLCCommon;
  ErrInfo: string;
begin
  RsLCCommon := TRsLCCommon.Create(m_WebAPI.URL,m_Site.Number,m_Site.ID);
  try
    RsLCCommon.SetDBSysConfig(Section, Ident, Value, ErrInfo);
  finally
    RsLCCommon.Free;
  end;
end;

function TGlobal.GetProxy: IGlobalProxy;
begin
  if not Assigned(_GlobalProxy) then
    _GlobalProxy := TGlobalProxyImp.Create;

  Result := _GlobalProxy;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGlobal, CLASS_Global,
    ciSingleInstance, tmApartment);

finalization
  _GlobalProxy := nil;
end.
