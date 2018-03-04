unit RsLibUtils;



interface
uses
  Windows,StdCtrls, ComObj, ActiveX,SysUtils,Dialogs;
  
function CreateComObjectFromDll(CLSID: TGUID; DllHandle: THandle): IUnknown;


implementation
 
function CreateComObjectFromDll(CLSID: TGUID; DllHandle: THandle): IUnknown;
var
  Factory: IClassFactory;
  DllGetClassObject: function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
  hr: HRESULT;
begin
  DllGetClassObject := GetProcAddress(DllHandle, 'DllGetClassObject');
  if Assigned(DllGetClassObject) then
  begin
    hr := DllGetClassObject(CLSID, IClassFactory, Factory);
    if hr = S_OK then
    try
      hr := Factory.CreateInstance(nil, IUnknown, Result);
      if hr<> S_OK then begin
        raise exception.Create('创建对象失败：' + Inttostr(hr));
      end;
    except on e :Exception do
      begin
        raise exception.Create('创建对象异常：' + IntToStr(GetLastError));
      end;
    end;
  end;
end;
end.
