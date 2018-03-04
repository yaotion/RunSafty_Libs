unit uGlobal;

interface
uses
  Classes,uMealTicketConfig,SysUtils,RsGlobal_TLB,uTFComObject,uHttpWebAPI,
  Forms,RsLeaveLib_TLB;
type
  TConfig = class
  end;
var
  g_WebAPIUtils: TWebAPIUtils;
function GlobalDM: IGlobalProxy;
function LeaveLib: IRsUILeave;
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
function LeaveLib: IRsUILeave;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\RsLeaveLib.dll',CLASS_RsUILeave,IUnKnown);
    Result := ifObj.DefaultInterface  as IRsUILeave;
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
