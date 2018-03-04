unit uRsLibClass;

interface
uses
  Classes,Windows,Forms,SysUtils,Contnrs,activex,uRsLibPoolLib;
type
  TRegClassItem = class
    RegClass : TClass;
    SingleInstance : boolean;
  end;
  //��̬���װ������
  TRsLibEntryClass = class of TRsLibEntry;
  //��̬���װ�������
  TRsLibEntry = class(TInterfacedObject)
  public
    constructor Create;virtual;abstract;
  end;
  //��ʼ��Ӧ�ó������
  procedure InitEntryPool(EntryPool : IRsLibPool;AppHandle : Cardinal);stdcall;
  //����IID�����ָ���Ķ������
  function  ReflectEntry(IID : TGUID): IInterface;stdcall;
  //ע���ⲿ���ö�������,ASingleInstanceΪtrueʱΪ��ʵ��
  procedure RegEntryClass(AEntryClass: TRsLibEntryClass;ASingleInstance: Boolean);
  //
  function ReflectEntryEx(IID : TGUID): IInterface;stdcall;

implementation
var
  //�ⲿ�ӿڳ�
  _EntryPool : IRsLibPool;
  //ϵͳע����
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
