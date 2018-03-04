unit uRsLibClass;

interface
uses
  Classes,Windows,Forms,SysUtils,Contnrs,activex,uRsLibPoolLib;
type
  TRegClassItem = class
    RegClass : TClass;
    SingleInstance : boolean;
  end;
  //动态库封装对象类
  TRsLibEntryClass = class of TRsLibEntry;
  //动态库封装对象基类
  TRsLibEntry = class(TInterfacedObject)
  public
    constructor Create;virtual;abstract;
  end;
  //初始化应用程序池子
  procedure InitEntryPool(EntryPool : IRsLibPool;AppHandle : Cardinal);stdcall;
  //根据IID反射出指定的对象入口
  function  ReflectEntry(IID : TGUID): IInterface;stdcall;
  //注册外部调用对象类型,ASingleInstance为true时为单实例
  procedure RegEntryClass(AEntryClass: TRsLibEntryClass;ASingleInstance: Boolean);
  //
  function ReflectEntryEx(IID : TGUID): IInterface;stdcall;

implementation
var
  //外部接口池
  _EntryPool : IRsLibPool;
  //系统注册类
  _RegClassPool : TObjectList;
   //
function ReflectEntryEx(IID : TGUID): IInterface;stdcall;
begin
  _EntryPool.FindEntry(IID,result)
end;
procedure InitEntryPool(EntryPool : IRsLibPool;AppHandle : Cardinal);stdcall;
begin
  _EntryPool := EntryPool;
//  Application.Initialize;
//  if Application.Handle = 0 then
//    begin
//      Application.CreateHandle;
//    end;
  Application.Handle:= AppHandle;
  //Application.Run;
  
end;
procedure RegEntryClass(AEntryClass: TRsLibEntryClass;ASingleInstance: Boolean);
var
  item : TRegClassItem;
begin
  item := TRegClassItem.Create;
  item.RegClass := AEntryClass;
  item.SingleInstance := ASingleInstance;
  _RegClassPool.Add(item);  
end;

function ReflectEntry(IID : TGUID): IInterface;stdcall;
var
  i: Integer;
  pluginClass : TRsLibEntryClass;
  singleInstance : boolean;
begin
  pluginClass := nil;
  singleInstance := false;
  for i := 0 to _RegClassPool.Count - 1 do
  begin
    if (TRegClassItem(_RegClassPool[i]).RegClass.GetInterfaceEntry(IID) <> nil) then
    begin
      pluginClass := TRsLibEntryClass(TRegClassItem(_RegClassPool[i]).RegClass);
      singleInstance := TRegClassItem(_RegClassPool[i]).SingleInstance;
    end;
  end;
  if pluginClass = nil then
  begin
    exit;
  end;
  if singleInstance then
  begin
    if _EntryPool.PullFromPool(IID,Result) then
    begin
      exit;
    end;
    Result := pluginClass.Create;
    _EntryPool.AddEntry(result);
  end else begin
    Result := pluginClass.Create;
  end;
end;

initialization
  _RegClassPool := TObjectList.Create;
finalization
  _RegClassPool.Free;
  _RegClassPool := nil;
end.
