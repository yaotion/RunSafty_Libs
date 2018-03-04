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
// File generated on 2016-07-06 14:24:24 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\日志模块\RsLogLib.tlb (1)
// LIBID: {2190EC6E-BF39-487D-934D-1D9BE05FC20D}
// LCID: 0
// Helpfile: 
// HelpString: RsLogLib Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

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

class function CoRsLog.Create: IRsLog;
begin
  Result := CreateComObject(CLASS_RsLog) as IRsLog;
end;

class function CoRsLog.CreateRemote(const MachineName: string): IRsLog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsLog) as IRsLog;
end;

end.
