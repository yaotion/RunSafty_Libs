unit uGlobal;

interface
uses
  Classes,SysUtils,RsGlobal_TLB,uTFComObject,uHttpWebAPI;
type
  TConfig = class
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


initialization
  g_WebAPIUtils := TWebAPIUtils.Create;
finalization
  g_WebAPIUtils.Free;
end.
