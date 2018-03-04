unit EventSink;

interface

uses
  Windows, Messages, SysUtils, Classes,Graphics, Controls, Forms, Dialogs,ActiveX;

type
  TInvokeEvent = procedure(Sender: TObject; DispID: Integer; const IID: TGUID;
    LocaleID: Integer; Flags: Word; Params: TDispParams;
    VarResult, ExcepInfo, ArgErr: Pointer) of object;

  TAbstractEventSink = class(TObject, IUnknown, IDispatch)
  private
    FDispatch: IDispatch;
    FDispIntfIID: TGUID;
    FConnection: LongInt;
    FOwner: TComponent;
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo)
      : HRESULT; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer)
      : HRESULT; stdcall;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Connect(AnAppDispatch: IDispatch; const AnAppDispIntfIID: TGUID);
    procedure Disconnect;
  end;

  TEventSink = class(TComponent)
  private
    { Private declarations }
    FSink: TAbstractEventSink;
    FOnInvoke: TInvokeEvent;
  protected
    { Protected declarations }
    procedure DoInvoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer); virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect(AnAppDispatch: IDispatch; const AnAppDispIntfIID: TGUID);
  published
    { Published declarations }
    property OnInvoke: TInvokeEvent read FOnInvoke write FOnInvoke;
  end;

implementation

uses
  ComObj;

procedure InterfaceConnect(const Source: IUnknown; const IID: TIID;
  const Sink: IUnknown; var Connection: LongInt);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  Connection := 0;
  if Succeeded(Source.QueryInterface(IConnectionPointContainer, CPC)) then
    if Succeeded(CPC.FindConnectionPoint(IID, CP)) then
      CP.Advise(Sink, Connection);
end;

procedure InterfaceDisconnect(const Source: IUnknown; const IID: TIID;
  var Connection: LongInt);
var
  CPC: IConnectionPointContainer;
  CP: IConnectionPoint;
begin
  if Connection <> 0 then
    if Succeeded(Source.QueryInterface(IConnectionPointContainer, CPC)) then
      if Succeeded(CPC.FindConnectionPoint(IID, CP)) then
        if Succeeded(CP.Unadvise(Connection)) then
          Connection := 0;
end;

{ TAbstractEventSink }
function TAbstractEventSink._AddRef: Integer; stdcall;
begin
  Result := 2;
end;

function TAbstractEventSink._Release: Integer; stdcall;
begin
  Result := 1;
end;

constructor TAbstractEventSink.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TAbstractEventSink.Destroy;
begin
  Disconnect;

  inherited Destroy;
end;

function TAbstractEventSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TAbstractEventSink.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo)
  : HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TAbstractEventSink.GetTypeInfoCount(out Count: Integer)
  : HRESULT; stdcall;
begin
  Count := 0;
  Result := S_OK;
end;

function TAbstractEventSink.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer): HRESULT; stdcall;
begin
  (FOwner as TEventSink).DoInvoke(DispID, IID, LocaleID, Flags, Params,
    VarResult, ExcepInfo, ArgErr);
  Result := S_OK;
end;

function TAbstractEventSink.QueryInterface(const IID: TGUID; out Obj)
  : HRESULT; stdcall;
begin
  // We need to return the event interface when it's asked for
  Result := E_NOINTERFACE;
  if GetInterface(IID, Obj) then
    Result := S_OK;
  if IsEqualGUID(IID, FDispIntfIID) and GetInterface(IDispatch, Obj) then
    Result := S_OK;
end;

procedure TAbstractEventSink.Connect(AnAppDispatch: IDispatch;
  const AnAppDispIntfIID: TGUID);
begin
  FDispIntfIID := AnAppDispIntfIID;
  FDispatch := AnAppDispatch;
  // Hook the sink up to the automation server
  InterfaceConnect(FDispatch, FDispIntfIID, Self, FConnection);
end;

procedure TAbstractEventSink.Disconnect;
begin
  if Assigned(FDispatch) then
  begin
    // Unhook the sink from the automation server
    InterfaceDisconnect(FDispatch, FDispIntfIID, FConnection);
    FDispatch := nil;
    FConnection := 0;
  end;
end;

{ TEventSink }

procedure TEventSink.Connect(AnAppDispatch: IDispatch;
  const AnAppDispIntfIID: TGUID);
begin
  FSink.Connect(AnAppDispatch, AnAppDispIntfIID);
end;

constructor TEventSink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSink := TAbstractEventSink.Create(Self);
end;

destructor TEventSink.Destroy;
begin
  FSink.Free;

  inherited Destroy;
end;

procedure TEventSink.DoInvoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  if Assigned(FOnInvoke) then
    FOnInvoke(Self, DispID, IID, LocaleID, Flags, TDispParams(Params),
      VarResult, ExcepInfo, ArgErr);
end;

end.
