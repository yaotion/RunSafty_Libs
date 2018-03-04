unit uLCWebAPI;

interface
uses
  classes,
  StrUtils,
  SysUtils,
  uBaseWebInterface,
  uHttpWebAPI,
  uLCDrink,
  uLCDutyUser,
  uLCTrainPlan,
  uLCTrainmanMgr,
  uLCBeginwork,
  uLCNameBoardEx,
  uLCWorkFlowAPI;
type
  TLCWebAPI = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_WebAPIUtils: TWebAPIUtils;
    m_LCDrink: TRsLCDrink;
    m_LCDutyUser: TRsLCDutyUser;
    m_LCTrainPlan: TRsLCTrainPlan;
    m_LCTrainmanMgr: TRsLCTrainmanMgr;
    m_LCBeginwork: TLCBeginwork;
    m_LCNameBoardEx: TRsLCNameBoardEx;
    m_LCWorkFlow: TLCWorkFlowAPI;
  public
    procedure SetConnConfig(ConnConfig: RInterConnConfig);
    property LCDrink: TRsLCDrink read m_LCDrink;
    property LCDutyUser: TRsLCDutyUser read m_LCDutyUser;
    property LCTrainPlan: TRsLCTrainPlan read m_LCTrainPlan;
    property LCTrainmanMgr: TRsLCTrainmanMgr read m_LCTrainmanMgr;
    property LCBeginwork: TLCBeginwork read m_LCBeginwork;
    property LCNameBoardEx: TRsLCNameBoardEx read m_LCNameBoardEx;
    property LCWorkFlow: TLCWorkFlowAPI read m_LCWorkFlow;
  end;
function LCWebAPI: TLCWebAPI;

implementation
uses
  uGlobalDM;
var
  g_LCWebAPI: TLCWebAPI;


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

function LCWebAPI: TLCWebAPI;
begin
  if not Assigned(g_LCWebAPI) then
    g_LCWebAPI := TLCWebAPI.Create;

  g_LCWebAPI.SetConnConfig(GlobalDM.HttpConnConfig);
  Result := g_LCWebAPI;
end;
{ TLCWebAPI }

constructor TLCWebAPI.Create;
begin
  m_WebAPIUtils := TWebAPIUtils.Create;
  m_LCDrink := TRsLCDrink.Create(m_WebAPIUtils);
  m_LCDutyUser := TRsLCDutyUser.Create(m_WebAPIUtils);
  m_LCTrainPlan := TRsLCTrainPlan.Create('','','');
  m_LCTrainmanMgr := TRsLCTrainmanMgr.Create(m_WebAPIUtils);
  m_LCBeginwork := TLCBeginwork.Create(m_WebAPIUtils);
  m_LCNameBoardEx := TRsLCNameBoardEx.Create(m_WebAPIUtils);
  m_LCWorkFlow := TLCWorkFlowAPI.Create(m_WebAPIUtils);
end;

destructor TLCWebAPI.Destroy;
begin
  m_LCDrink.Free;
  m_LCDutyUser.Free;
  m_LCTrainPlan.Free;
  m_LCTrainmanMgr.Free;
  m_LCBeginwork.Free;
  m_LCNameBoardEx.Free;
  m_LCWorkFlow.Free;
  m_WebAPIUtils.Free;
  inherited;
end;

procedure TLCWebAPI.SetConnConfig(ConnConfig: RInterConnConfig);
begin
  m_LCTrainPlan.SetConnConfig(ConnConfig);
  m_WebAPIUtils.Host := GetURLHost(ConnConfig.URL);
  m_WebAPIUtils.Port := GetUrlPort(ConnConfig.URL);
end;
initialization
finalization
  if Assigned(g_LCWebAPI) then
    FreeAndNil(g_LCWebAPI);
end.
