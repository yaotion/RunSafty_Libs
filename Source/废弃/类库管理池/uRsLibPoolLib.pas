unit uRsLibPoolLib;

interface

type
  IRsLibPool = interface
    ['{C3E17D15-A04C-4C5E-9E28-D20CF693DC52}']
    //加载所有类库
     procedure LoadLibs(XMLConfig : WideString;AppHandle : Cardinal); stdcall;
     //添加接口
    procedure AddEntry(Entry : IInterface);
    //卸载所有类库
    procedure UnloadLibs;stdcall;
    //取出接口池中已有的接口
    function  PullFromPool(IID : TGUID; out Entry : IInterface):  boolean;stdcall;
    //获取指定的接口
    function FindEntry(IID : TGUID; var Entry : IInterface) :  boolean;stdcall;
  end;
  CoRsLibPool = class
  public
      //自定义设置dll文件所在路径
    class procedure SetPath(DllPath : string);
    
    class function RsLibPool : IRsLibPool;
  end;
implementation
uses
  SysUtils,Windows;
var
  _HLib: Cardinal = 0;
  _DllPath : string = '';  
{ CoRsLibPool }

class function CoRsLibPool.RsLibPool: IRsLibPool;
var
  path : string;
  Proc : function : IRsLibPool;
begin
  path :=  ExtractFilePath(ParamStr(0))+ 'Libs\';
  if _DllPath <> '' then
  begin
    path := _DllPath;
  end;

  if _HLib = 0 then
  begin
    _HLib := LoadLibrary(pchar(path + 'RsLibPool.dll'));
    if _HLib = 0 then
      Raise Exception.CreateFmt('加载%s 失败!',[path + 'RsLibPool.dll']);
  end;

  Proc := GetProcAddress(_HLib,'ReflectPool');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('加载%s方法失败!',['ReflectPool']);
  end;
  Result := Proc();
end;

class procedure CoRsLibPool.SetPath(DllPath: string);
begin
  _DllPath := DllPath;
end;

end.
