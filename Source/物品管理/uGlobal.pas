unit uGlobal;

interface
uses
  Classes,uMealTicketConfig,SysUtils,RsGlobal_TLB,uTFComObject,uHttpWebAPI,
  RsTMFPLib_TLB;
type
  TConfig = class
  private
    class procedure SetUsesGoodsRange(const Value: Boolean); static;
    class function GetUsesGoodsRange(): Boolean; static;
  public
    class property UsesGoodsRange: Boolean read GetUsesGoodsRange write SetUsesGoodsRange;
  end;
var
  g_WebAPIUtils: TWebAPIUtils;
function GlobalDM: IGlobalProxy;
function FingerCtl: IRsTMFP;
implementation

function FingerCtl: IRsTMFP;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\RsTMFPLib.dll',CLASS_RsFingerUtils,IUnKnown);
    Result := (ifObj.DefaultInterface  as IRsFingerUtils).GetProxy.RsTrainmanFP;
  finally
    ifObj.Free;
  end;
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

{ TConfig }

class function TConfig.GetUsesGoodsRange(): Boolean;
begin
  Result := GlobalDM.ReadIniConfig('GoodsRangeConfig','UsesGoodsRange') = '1';
end;

class procedure TConfig.SetUsesGoodsRange(const Value: Boolean);
var
  strUses:string;
begin
  if Value then
    strUses := '1'
  else
    strUses := '0';
  GlobalDM.WriteIniConfig('GoodsRangeConfig','UsesGoodsRange',strUses);
end;

initialization
  g_WebAPIUtils := TWebAPIUtils.Create;
finalization
  g_WebAPIUtils.Free;
end.
