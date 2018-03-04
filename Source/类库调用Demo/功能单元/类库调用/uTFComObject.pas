unit uTFComObject;

interface
uses
  ComObj,ActiveX,SysUtils,Windows,EventSink;
type

  TTFComObject = class
  public
    constructor Create;virtual;
    destructor  Destroy;override;
  private
    m_Events : TEventSink;
    m_DefaultInterface : IDispatch;
  private
    function GetDefaultInterface: IDispatch;
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);virtual;
  public
    procedure Init(LibFile:string;IID,IIDEvents : TGUID);overload;
    procedure Init(LibFile:string;IID : TGUID);overload;
    function  CreateInstance(CLSID,IID: TGUID;out pv):boolean;
  public
    property DefaultInterface : IDispatch read GetDefaultInterface;
  end;
implementation

{ TTFComObject }
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
      if hr <> S_OK then begin
        raise Exception.Create('Error');
      end;
    except
      raise Exception.Create(IntToStr(GetLastError));
    end;
  end;
end;

function GetClassObject(DllHandle: THandle;CLSID,IID: TGUID): IUnknown;
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
      hr := Factory.CreateInstance(nil, IID, Result);
      if hr <> S_OK then begin
        raise Exception.Create('Error');
      end;
    except
      raise Exception.Create(IntToStr(GetLastError));
    end;
  end;
end;




constructor TTFComObject.Create;
begin

end;

function TTFComObject.CreateInstance(CLSID,IID: TGUID;out pv): boolean;
var
  hr : HRESULT ;
begin
  result := false ;
  hr := CoCreateInstance(CLSID,nil,
    CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
    IID,pv);
  if Succeeded(hr) then
  begin
    result := true ;
  end
end;

destructor TTFComObject.Destroy;
begin
  m_Events.Free;
  inherited;
end;


procedure TTFComObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin

end;

procedure TTFComObject.Init(LibFile:string;IID,IIDEvents : TGUID);
var
  hDll : THandle;
begin
  hDll := LoadLibrary(PChar(LibFile));
  if hDll = 0 then
  begin
    raise Exception.Create('未找到指定的类库');
  end;
  m_DefaultInterface  := CreateComObjectFromDll(IID, hDll) as IDispatch;

  m_Events := TEventSink.Create(nil);
  m_Events.Connect(m_DefaultInterface,IIDEvents);
  m_Events.OnInvoke := EventSinkInvoke;

end;

function TTFComObject.GetDefaultInterface: IDispatch;
begin
  result := m_DefaultInterface;
end;

procedure TTFComObject.Init(LibFile: string; IID: TGUID);
var
  hDll : THandle;
begin
  hDll := LoadLibrary(PChar(LibFile));
  m_DefaultInterface  := CreateComObjectFromDll(IID, hDll) as IDispatch;
end;

end.
