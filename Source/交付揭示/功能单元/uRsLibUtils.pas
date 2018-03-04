unit uRsLibUtils;

interface
uses
  SysUtils,activex,Windows;
  
//���ض�̬���ȱʡ��⺯��������ָ��GUID�Ľӿڶ���
function LoadPlugIn(pluginFile: string;IID : TGUID ; var hlib: Cardinal): IInterface;
//ж��ָ����̬������е���
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
      Raise Exception.CreateFmt('����%s ʧ��!',[pluginFile]);
  end;

  Proc := GetProcAddress(hlib,'ReflectEntry');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('����%s����ʧ��!',['ReflectEntry']);
  end;
  Result := Proc(IID);
end;

procedure UnloadPlugIn(hlib : Cardinal);
 var
  Proc: procedure ();stdcall;
begin
  if hlib = 0 then
  begin
    Raise Exception.CreateFmt('ָ����ģ��δ�����ع���ж��ʧ��!',[]);
  end;
  Proc := GetProcAddress(hlib,'FreeEntries');
  if not Assigned(Proc) then
  begin
    Raise Exception.CreateFmt('����%s����ʧ��!',['FreeEntries']);
  end;
    Proc();
end;
end.
