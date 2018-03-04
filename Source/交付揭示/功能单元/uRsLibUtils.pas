unit uRsLibUtils;

interface
uses
  SysUtils,activex,Windows;
  
//加载动态库的缺省入库函数并返回指定GUID的接口对象
function LoadPlugIn(pluginFile: string;IID : TGUID ; var hlib: Cardinal): IInterface;
//卸载指定动态库的所有调用
procedure UnloadPlugIn(hlib: Cardinal);

implementation

function LoadPlugIn(pluginFile: string;IID : TGUID ;var hlib: Cardinal): IInterface;
var
  Proc: function (IID : TGUID): IInterface;stdcall;
begin
  if hlib = 0 then
  begin
    hlib := LoadLibrary(pchar(pluginFile));
    if hlib = 0 then
      Raise Exception.CreateFmt('加载%s 失败!',[pluginFile]);
  end;

  Proc := GetProcAddress(hlib,'ReflectEntry');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('加载%s方法失败!',['ReflectEntry']);
  end;
  Result := Proc(IID);
end;

procedure UnloadPlugIn(hlib : Cardinal);
 var
  Proc: procedure ();stdcall;
begin
  if hlib = 0 then
  begin
    Raise Exception.CreateFmt('指定的模块未曾加载过，卸载失败!',[]);
  end;
  Proc := GetProcAddress(hlib,'FreeEntries');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('加载%s方法失败!',['FreeEntries']);
  end;
    Proc();
end;
end.
