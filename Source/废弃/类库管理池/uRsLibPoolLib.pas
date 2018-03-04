unit uRsLibPoolLib;

interface

type
  IRsLibPool = interface
    ['{C3E17D15-A04C-4C5E-9E28-D20CF693DC52}']
    //�����������
     procedure LoadLibs(XMLConfig : WideString;AppHandle : Cardinal); stdcall;
     //��ӽӿ�
    procedure AddEntry(Entry : IInterface);
    //ж���������
    procedure UnloadLibs;stdcall;
    //ȡ���ӿڳ������еĽӿ�
    function  PullFromPool(IID : TGUID; out Entry : IInterface):  boolean;stdcall;
    //��ȡָ���Ľӿ�
    function FindEntry(IID : TGUID; var Entry : IInterface) :  boolean;stdcall;
  end;
  CoRsLibPool = class
  public
      //�Զ�������dll�ļ�����·��
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
      Raise Exception.CreateFmt('����%s ʧ��!',[path + 'RsLibPool.dll']);
  end;

  Proc := GetProcAddress(_HLib,'ReflectPool');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('����%s����ʧ��!',['ReflectPool']);
  end;
  Result := Proc();
end;

class procedure CoRsLibPool.SetPath(DllPath: string);
begin
  _DllPath := DllPath;
end;

end.
