unit uGlobal;

interface
uses
  Classes,uMealTicketConfig,SysUtils,SqlExpr,RsGlobal_TLB,uTFComObject,uHttpWebAPI;

function ConnectMealDB(TicketConnection: TSQLConnection;out ErrTxt:string):Boolean;
function TicketNumberLen: integer;
function GlobalDM: IGlobalProxy;
function UsesMealTicket: Boolean;
var
  g_TicketConn: TSQLConnection;
  g_WebAPIUtils: TWebAPIUtils;
  
implementation
function UsesMealTicket: Boolean;
begin
  Result := GlobalDM.ReadIniConfig('MealTicketConfig','UsesMealTicket') = '1';
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

function TicketNumberLen: integer;
begin
  Result := StrToIntDef(GlobalDM.ReadServerConfig('SysConfig','TicketNumberLen'),7);
end;
function ConnectMealDB(TicketConnection: TSQLConnection;out ErrTxt:string):Boolean;
var
  mealTicketConfigOper:TRsMealConfigOper;
  ServerConfig:RRsMealServerConfig;
  strFile:string;
  strDataBase:string;
begin
  Result := True ;
  strFile := Format('%sconfig.ini',[ExtractFilePath(ParamStr(0))]) ;
  mealTicketConfigOper := TRsMealConfigOper.Create(strFile);
  try
    try
      mealTicketConfigOper.ReadMealServerConfig(ServerConfig);
      with TicketConnection do
      begin
        LoginPrompt := False;
        DriverName := 'Interbase';
        GetDriverFunc := 'getSQLDriverINTERBASE';
        LibraryName := 'dbxint30.dll';
        VendorLib := 'GDS32.DLL';
        
        if Connected then
          Connected := False ;
        //连接方法
        //192.168.1.105/3050:D:\CJGL\CJGL.DAT
        //'172.17.2.10:c:\db\myDb.fdb'
        Params.Clear;
        Params.Add('BlobSize=-1');
        Params.Add('CommitRetain=False');
        Params.Add('DriverName=Interbase');
        Params.Add('ErrorResourceFile=');
        Params.Add('LocaleCode=0000');
        Params.Add('RoleName=RoleName');
        Params.Add('ServerCharSet=');
        Params.Add('Interbase TransIsolation=ReadCommited');
        Params.Add('WaitOnLocks=True');
        Params.Add('SQLDialect=3');
        
        strDataBase := format('%s:%s',[ServerConfig.strServerIp,ServerConfig.strDataLocation]);
        Params.Values['Database']:= strDataBase ;
        Params.Values['User_Name']:= ServerConfig.strServerUser;
        Params.Values['Password']:= ServerConfig.strServerPass;
        Connected := True ;
      end;
    except
      on e:Exception do
      begin
        Result := False;
        ErrTxt := e.Message;
      end;
    end;
  finally
    mealTicketConfigOper.Free;
  end;
end;

initialization
  g_TicketConn := TSQLConnection.Create(nil);

  g_WebAPIUtils := TWebAPIUtils.Create;
finalization
  g_TicketConn.Free;
  g_WebAPIUtils.Free;
end.
