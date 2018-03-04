unit RsLogLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2016-05-20 10:45:20 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Execute\libs\RsLogLib.dll (1)
// LIBID: {2190EC6E-BF39-487D-934D-1D9BE05FC20D}
// LCID: 0
// Helpfile: 
// HelpString: RsLogLib Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// Errors:
//   Error creating palette bitmap of (TRsLogConfig) : No Server registered for this CoClass
//   Error creating palette bitmap of (TRsLog) : No Server registered for this CoClass
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  RsLogLibMajorVersion = 1;
  RsLogLibMinorVersion = 0;

  LIBID_RsLogLib: TGUID = '{2190EC6E-BF39-487D-934D-1D9BE05FC20D}';

  IID_IRsLog: TGUID = '{395D8637-98FD-467C-9691-1EB27E9A5DA4}';
  DIID_ILogEvents: TGUID = '{D74697EE-3BD8-49FC-A294-A198A4290A35}';
  IID_IRsLogListener: TGUID = '{0AB63B35-1EE5-4A7C-BB40-31D54CCBC258}';
  IID_ILogConfig: TGUID = '{225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}';
  CLASS_RsLogConfig: TGUID = '{239E3A2F-25B0-469F-879C-8DE18B365241}';
  CLASS_RsLog: TGUID = '{BFDAE114-90B2-4011-9911-635473129AF2}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TLogLevel
type
  TLogLevel = TOleEnum;
const
  llInfo = $00000000;
  llDebug = $00000001;
  llError = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsLog = interface;
  IRsLogDisp = dispinterface;
  ILogEvents = dispinterface;
  IRsLogListener = interface;
  IRsLogListenerDisp = dispinterface;
  ILogConfig = interface;
  ILogConfigDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsLogConfig = ILogConfig;
  RsLog = IRsLog;


// *********************************************************************//
// Interface: IRsLog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {395D8637-98FD-467C-9691-1EB27E9A5DA4}
// *********************************************************************//
  IRsLog = interface(IDispatch)
    ['{395D8637-98FD-467C-9691-1EB27E9A5DA4}']
    procedure WriteInfo(const Log: WideString; const Catalog: WideString); safecall;
    procedure WriteDebug(const Log: WideString; const Catalog: WideString); safecall;
    procedure WriteError(const Log: WideString; const Catalog: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsLogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {395D8637-98FD-467C-9691-1EB27E9A5DA4}
// *********************************************************************//
  IRsLogDisp = dispinterface
    ['{395D8637-98FD-467C-9691-1EB27E9A5DA4}']
    procedure WriteInfo(const Log: WideString; const Catalog: WideString); dispid 201;
    procedure WriteDebug(const Log: WideString; const Catalog: WideString); dispid 202;
    procedure WriteError(const Log: WideString; const Catalog: WideString); dispid 203;
  end;

// *********************************************************************//
// DispIntf:  ILogEvents
// Flags:     (4096) Dispatchable
// GUID:      {D74697EE-3BD8-49FC-A294-A198A4290A35}
// *********************************************************************//
  ILogEvents = dispinterface
    ['{D74697EE-3BD8-49FC-A294-A198A4290A35}']
    procedure OnLogout(const Title: WideString; const Log: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: IRsLogListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AB63B35-1EE5-4A7C-BB40-31D54CCBC258}
// *********************************************************************//
  IRsLogListener = interface(IDispatch)
    ['{0AB63B35-1EE5-4A7C-BB40-31D54CCBC258}']
    procedure InsertLog(const Title: WideString; const Log: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsLogListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AB63B35-1EE5-4A7C-BB40-31D54CCBC258}
// *********************************************************************//
  IRsLogListenerDisp = dispinterface
    ['{0AB63B35-1EE5-4A7C-BB40-31D54CCBC258}']
    procedure InsertLog(const Title: WideString; const Log: WideString); dispid 201;
  end;

// *********************************************************************//
// Interface: ILogConfig
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}
// *********************************************************************//
  ILogConfig = interface(IDispatch)
    ['{225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}']
    procedure SaveToFile(const FileName: WideString); safecall;
    procedure LoadFromFile(const FileName: WideString); safecall;
    procedure Reload; safecall;
    procedure Save; safecall;
    procedure ShowConfigForm(AppHandle: Integer; ParentHandle: Integer); safecall;
    function Get_Path: WideString; safecall;
    procedure Set_Path(const Value: WideString); safecall;
    function Get_EnableInfo: WordBool; safecall;
    procedure Set_EnableInfo(Value: WordBool); safecall;
    function Get_EnableDebug: WordBool; safecall;
    procedure Set_EnableDebug(Value: WordBool); safecall;
    function Get_EnableError: WordBool; safecall;
    procedure Set_EnableError(Value: WordBool); safecall;
    function Get_UDPPort: Integer; safecall;
    procedure Set_UDPPort(Value: Integer); safecall;
    function Get_EnableUDP: WordBool; safecall;
    procedure Set_EnableUDP(Value: WordBool); safecall;
    property Path: WideString read Get_Path write Set_Path;
    property EnableInfo: WordBool read Get_EnableInfo write Set_EnableInfo;
    property EnableDebug: WordBool read Get_EnableDebug write Set_EnableDebug;
    property EnableError: WordBool read Get_EnableError write Set_EnableError;
    property UDPPort: Integer read Get_UDPPort write Set_UDPPort;
    property EnableUDP: WordBool read Get_EnableUDP write Set_EnableUDP;
  end;

// *********************************************************************//
// DispIntf:  ILogConfigDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}
// *********************************************************************//
  ILogConfigDisp = dispinterface
    ['{225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}']
    procedure SaveToFile(const FileName: WideString); dispid 201;
    procedure LoadFromFile(const FileName: WideString); dispid 202;
    procedure Reload; dispid 203;
    procedure Save; dispid 204;
    procedure ShowConfigForm(AppHandle: Integer; ParentHandle: Integer); dispid 205;
    property Path: WideString dispid 206;
    property EnableInfo: WordBool dispid 207;
    property EnableDebug: WordBool dispid 208;
    property EnableError: WordBool dispid 209;
    property UDPPort: Integer dispid 210;
    property EnableUDP: WordBool dispid 211;
  end;

// *********************************************************************//
// The Class CoRsLogConfig provides a Create and CreateRemote method to          
// create instances of the default interface ILogConfig exposed by              
// the CoClass RsLogConfig. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsLogConfig = class
    class function Create: ILogConfig;
    class function CreateRemote(const MachineName: string): ILogConfig;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRsLogConfig
// Help String      : 
// Default Interface: ILogConfig
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRsLogConfigProperties= class;
{$ENDIF}
  TRsLogConfig = class(TOleServer)
  private
    FIntf: ILogConfig;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TRsLogConfigProperties;
    function GetServerProperties: TRsLogConfigProperties;
{$ENDIF}
    function GetDefaultInterface: ILogConfig;
  protected
    procedure InitServerData; override;
    function Get_Path: WideString;
    procedure Set_Path(const Value: WideString);
    function Get_EnableInfo: WordBool;
    procedure Set_EnableInfo(Value: WordBool);
    function Get_EnableDebug: WordBool;
    procedure Set_EnableDebug(Value: WordBool);
    function Get_EnableError: WordBool;
    procedure Set_EnableError(Value: WordBool);
    function Get_UDPPort: Integer;
    procedure Set_UDPPort(Value: Integer);
    function Get_EnableUDP: WordBool;
    procedure Set_EnableUDP(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ILogConfig);
    procedure Disconnect; override;
    procedure SaveToFile(const FileName: WideString);
    procedure LoadFromFile(const FileName: WideString);
    procedure Reload;
    procedure Save;
    procedure ShowConfigForm(AppHandle: Integer; ParentHandle: Integer);
    property DefaultInterface: ILogConfig read GetDefaultInterface;
    property Path: WideString read Get_Path write Set_Path;
    property EnableInfo: WordBool read Get_EnableInfo write Set_EnableInfo;
    property EnableDebug: WordBool read Get_EnableDebug write Set_EnableDebug;
    property EnableError: WordBool read Get_EnableError write Set_EnableError;
    property UDPPort: Integer read Get_UDPPort write Set_UDPPort;
    property EnableUDP: WordBool read Get_EnableUDP write Set_EnableUDP;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRsLogConfigProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRsLogConfig
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRsLogConfigProperties = class(TPersistent)
  private
    FServer:    TRsLogConfig;
    function    GetDefaultInterface: ILogConfig;
    constructor Create(AServer: TRsLogConfig);
  protected
    function Get_Path: WideString;
    procedure Set_Path(const Value: WideString);
    function Get_EnableInfo: WordBool;
    procedure Set_EnableInfo(Value: WordBool);
    function Get_EnableDebug: WordBool;
    procedure Set_EnableDebug(Value: WordBool);
    function Get_EnableError: WordBool;
    procedure Set_EnableError(Value: WordBool);
    function Get_UDPPort: Integer;
    procedure Set_UDPPort(Value: Integer);
    function Get_EnableUDP: WordBool;
    procedure Set_EnableUDP(Value: WordBool);
  public
    property DefaultInterface: ILogConfig read GetDefaultInterface;
  published
    property Path: WideString read Get_Path write Set_Path;
    property EnableInfo: WordBool read Get_EnableInfo write Set_EnableInfo;
    property EnableDebug: WordBool read Get_EnableDebug write Set_EnableDebug;
    property EnableError: WordBool read Get_EnableError write Set_EnableError;
    property UDPPort: Integer read Get_UDPPort write Set_UDPPort;
    property EnableUDP: WordBool read Get_EnableUDP write Set_EnableUDP;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoRsLog provides a Create and CreateRemote method to          
// create instances of the default interface IRsLog exposed by              
// the CoClass RsLog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsLog = class
    class function Create: IRsLog;
    class function CreateRemote(const MachineName: string): IRsLog;
  end;

  TRsLogOnLogout = procedure(ASender: TObject; const Title: WideString; const Log: WideString) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRsLog
// Help String      : RsLog Object
// Default Interface: IRsLog
// Def. Intf. DISP? : No
// Event   Interface: ILogEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRsLogProperties= class;
{$ENDIF}
  TRsLog = class(TOleServer)
  private
    FOnLogout: TRsLogOnLogout;
    FIntf: IRsLog;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TRsLogProperties;
    function GetServerProperties: TRsLogProperties;
{$ENDIF}
    function GetDefaultInterface: IRsLog;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IRsLog);
    procedure Disconnect; override;
    procedure WriteInfo(const Log: WideString; const Catalog: WideString);
    procedure WriteDebug(const Log: WideString; const Catalog: WideString);
    procedure WriteError(const Log: WideString; const Catalog: WideString);
    property DefaultInterface: IRsLog read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRsLogProperties read GetServerProperties;
{$ENDIF}
    property OnLogout: TRsLogOnLogout read FOnLogout write FOnLogout;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRsLog
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRsLogProperties = class(TPersistent)
  private
    FServer:    TRsLog;
    function    GetDefaultInterface: IRsLog;
    constructor Create(AServer: TRsLog);
  protected
  public
    property DefaultInterface: IRsLog read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoRsLogConfig.Create: ILogConfig;
begin
  Result := CreateComObject(CLASS_RsLogConfig) as ILogConfig;
end;

class function CoRsLogConfig.CreateRemote(const MachineName: string): ILogConfig;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsLogConfig) as ILogConfig;
end;

procedure TRsLogConfig.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{239E3A2F-25B0-469F-879C-8DE18B365241}';
    IntfIID:   '{225BB2DB-39CE-4CC8-B1CA-0BFB0B47D1F6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRsLogConfig.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ILogConfig;
  end;
end;

procedure TRsLogConfig.ConnectTo(svrIntf: ILogConfig);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRsLogConfig.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRsLogConfig.GetDefaultInterface: ILogConfig;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRsLogConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRsLogConfigProperties.Create(Self);
{$ENDIF}
end;

destructor TRsLogConfig.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRsLogConfig.GetServerProperties: TRsLogConfigProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TRsLogConfig.Get_Path: WideString;
begin
    Result := DefaultInterface.Path;
end;

procedure TRsLogConfig.Set_Path(const Value: WideString);
  { Warning: The property Path has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Path := Value;
end;

function TRsLogConfig.Get_EnableInfo: WordBool;
begin
    Result := DefaultInterface.EnableInfo;
end;

procedure TRsLogConfig.Set_EnableInfo(Value: WordBool);
begin
  DefaultInterface.Set_EnableInfo(Value);
end;

function TRsLogConfig.Get_EnableDebug: WordBool;
begin
    Result := DefaultInterface.EnableDebug;
end;

procedure TRsLogConfig.Set_EnableDebug(Value: WordBool);
begin
  DefaultInterface.Set_EnableDebug(Value);
end;

function TRsLogConfig.Get_EnableError: WordBool;
begin
    Result := DefaultInterface.EnableError;
end;

procedure TRsLogConfig.Set_EnableError(Value: WordBool);
begin
  DefaultInterface.Set_EnableError(Value);
end;

function TRsLogConfig.Get_UDPPort: Integer;
begin
    Result := DefaultInterface.UDPPort;
end;

procedure TRsLogConfig.Set_UDPPort(Value: Integer);
begin
  DefaultInterface.Set_UDPPort(Value);
end;

function TRsLogConfig.Get_EnableUDP: WordBool;
begin
    Result := DefaultInterface.EnableUDP;
end;

procedure TRsLogConfig.Set_EnableUDP(Value: WordBool);
begin
  DefaultInterface.Set_EnableUDP(Value);
end;

procedure TRsLogConfig.SaveToFile(const FileName: WideString);
begin
  DefaultInterface.SaveToFile(FileName);
end;

procedure TRsLogConfig.LoadFromFile(const FileName: WideString);
begin
  DefaultInterface.LoadFromFile(FileName);
end;

procedure TRsLogConfig.Reload;
begin
  DefaultInterface.Reload;
end;

procedure TRsLogConfig.Save;
begin
  DefaultInterface.Save;
end;

procedure TRsLogConfig.ShowConfigForm(AppHandle: Integer; ParentHandle: Integer);
begin
  DefaultInterface.ShowConfigForm(AppHandle, ParentHandle);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRsLogConfigProperties.Create(AServer: TRsLogConfig);
begin
  inherited Create;
  FServer := AServer;
end;

function TRsLogConfigProperties.GetDefaultInterface: ILogConfig;
begin
  Result := FServer.DefaultInterface;
end;

function TRsLogConfigProperties.Get_Path: WideString;
begin
    Result := DefaultInterface.Path;
end;

procedure TRsLogConfigProperties.Set_Path(const Value: WideString);
  { Warning: The property Path has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Path := Value;
end;

function TRsLogConfigProperties.Get_EnableInfo: WordBool;
begin
    Result := DefaultInterface.EnableInfo;
end;

procedure TRsLogConfigProperties.Set_EnableInfo(Value: WordBool);
begin
  DefaultInterface.Set_EnableInfo(Value);
end;

function TRsLogConfigProperties.Get_EnableDebug: WordBool;
begin
    Result := DefaultInterface.EnableDebug;
end;

procedure TRsLogConfigProperties.Set_EnableDebug(Value: WordBool);
begin
  DefaultInterface.Set_EnableDebug(Value);
end;

function TRsLogConfigProperties.Get_EnableError: WordBool;
begin
    Result := DefaultInterface.EnableError;
end;

procedure TRsLogConfigProperties.Set_EnableError(Value: WordBool);
begin
  DefaultInterface.Set_EnableError(Value);
end;

function TRsLogConfigProperties.Get_UDPPort: Integer;
begin
    Result := DefaultInterface.UDPPort;
end;

procedure TRsLogConfigProperties.Set_UDPPort(Value: Integer);
begin
  DefaultInterface.Set_UDPPort(Value);
end;

function TRsLogConfigProperties.Get_EnableUDP: WordBool;
begin
    Result := DefaultInterface.EnableUDP;
end;

procedure TRsLogConfigProperties.Set_EnableUDP(Value: WordBool);
begin
  DefaultInterface.Set_EnableUDP(Value);
end;

{$ENDIF}

class function CoRsLog.Create: IRsLog;
begin
  Result := CreateComObject(CLASS_RsLog) as IRsLog;
end;

class function CoRsLog.CreateRemote(const MachineName: string): IRsLog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsLog) as IRsLog;
end;

procedure TRsLog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{BFDAE114-90B2-4011-9911-635473129AF2}';
    IntfIID:   '{395D8637-98FD-467C-9691-1EB27E9A5DA4}';
    EventIID:  '{D74697EE-3BD8-49FC-A294-A198A4290A35}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRsLog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IRsLog;
  end;
end;

procedure TRsLog.ConnectTo(svrIntf: IRsLog);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TRsLog.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TRsLog.GetDefaultInterface: IRsLog;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRsLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRsLogProperties.Create(Self);
{$ENDIF}
end;

destructor TRsLog.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRsLog.GetServerProperties: TRsLogProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TRsLog.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    201: if Assigned(FOnLogout) then
         FOnLogout(Self,
                   Params[0] {const WideString},
                   Params[1] {const WideString});
  end; {case DispID}
end;

procedure TRsLog.WriteInfo(const Log: WideString; const Catalog: WideString);
begin
  DefaultInterface.WriteInfo(Log, Catalog);
end;

procedure TRsLog.WriteDebug(const Log: WideString; const Catalog: WideString);
begin
  DefaultInterface.WriteDebug(Log, Catalog);
end;

procedure TRsLog.WriteError(const Log: WideString; const Catalog: WideString);
begin
  DefaultInterface.WriteError(Log, Catalog);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRsLogProperties.Create(AServer: TRsLog);
begin
  inherited Create;
  FServer := AServer;
end;

function TRsLogProperties.GetDefaultInterface: IRsLog;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TRsLogConfig, TRsLog]);
end;

end.
