unit uGlobal;

interface
uses
  Classes,uMealTicketConfig,SysUtils,RsGlobal_TLB,uTFComObject,uHttpWebAPI;
type
  TConfig = class
  private
    class function GetPrintModuleFile(): string; static;
    class function GetRemeberPrintModule(): Boolean; static;

    class procedure SetPrintModuleFile(const Value: string); static;
    class procedure SetRemeberPrintModule(const Value: Boolean); static;
  public
    class property RemeberPrintModule: Boolean read GetRemeberPrintModule write SetRemeberPrintModule;
    class property PrintModuleFile: string read GetPrintModuleFile write SetPrintModuleFile;
  end;
var
  g_WebAPIUtils: TWebAPIUtils;
function GlobalDM: IGlobalProxy;
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

{ TConfig }

class function TConfig.GetPrintModuleFile: string;
begin
  Result := GlobalDM.ReadIniConfig('UserData','PrintModuleFile');
end;

class function TConfig.GetRemeberPrintModule: Boolean;
begin
  Result := StrToBoolDef(GlobalDM.ReadIniConfig('UserData','SelectPrintModule'),False);
end;
class procedure TConfig.SetPrintModuleFile(const Value: string);
begin
  GlobalDM.WriteIniConfig('UserData','PrintModuleFile',Value);
end;

class procedure TConfig.SetRemeberPrintModule(const Value: Boolean);
begin
  GlobalDM.WriteIniConfig('UserData','SelectPrintModule',BoolToStr(Value));
end;

initialization
  g_WebAPIUtils := TWebAPIUtils.Create;
finalization
  g_WebAPIUtils.Free;
end.
