unit uWebApiCollection;

interface
uses
  classes,
  StrUtils,
  SysUtils,
  Contnrs,
  superobject,
  uJsonSerialize,
  uBaseWebInterface,
  uHttpWebAPI,
  uLCDutyUser;
type
  TWebApiCollection = class
  public
    constructor Create(APIUtils: TWebAPIUtils);
    destructor Destroy;override;
  private
    m_LCDutyUser: TRsLCDutyUser;
  public
    property LCDutyUser: TRsLCDutyUser read m_LCDutyUser;
    
  end;
function LCWebAPI: TWebApiCollection;

implementation
uses
  uGlobal, RsGlobal_TLB;
var
  _LCWebAPI: TWebApiCollection;


function GetURLHost(url: string): string;
var
  nIndex: integer;
begin
  url := LowerCase(Trim(url));
  nIndex := Pos('http://',url);
  if nIndex > 0 then
  begin
    Result := Copy(url,nIndex + 7,Length(url) - nIndex - 6);

    nIndex := Pos(':',Result);
    if nIndex > 0 then
    begin
      Result := Copy(Result,1,nIndex - 1 );
    end;
  end
  else
    Result := '';
end;


function GetUrlPort(url: string): integer;
var
  nIndex: integer;
begin
  url := LowerCase(Trim(url));
  nIndex := Pos('http://',url);
  if nIndex > 0 then
  begin
    url := Copy(url,nIndex + 7,Length(url) - nIndex - 6);
    nIndex := Pos(':',url);
    if nIndex > 0 then
    begin
      url := Copy(url,nIndex + 1,length(url) - nIndex);
      nIndex := Pos('/',url);
      if nIndex > 0 then
        Result := StrToIntDef(LeftStr(url,nIndex - 1),80)
      else
        Result := StrToIntDef(url,80);
    end
    else
      Result := 80;

  end
  else
    Result := 80;
end;

function LCWebAPI: TWebApiCollection;

begin
  if not Assigned(_LCWebAPI) then
  begin
    g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
    g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;

    _LCWebAPI := TWebApiCollection.Create(g_WebAPIUtils);
  end;

  Result := _LCWebAPI;
end;
{ TLCWebAPI }

constructor TWebApiCollection.Create(APIUtils: TWebAPIUtils);
begin

  m_LCDutyUser := TRsLCDutyUser.Create(APIUtils);

end;

destructor TWebApiCollection.Destroy;
begin

  m_LCDutyUser.Free;
 
  inherited;
end;

initialization
finalization
  if Assigned(_LCWebAPI) then
    FreeAndNil(_LCWebAPI);
end.

