unit RsFingerLib_TLB;

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
// File generated on 2016-07-04 14:07:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\指纹模块\RsFingerLib.tlb (1)
// LIBID: {3CBDEECF-08F1-4E84-BAFD-A0823F9CA28B}
// LCID: 0
// Helpfile: 
// HelpString: RsFingerLib Library
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
  RsFingerLibMajorVersion = 1;
  RsFingerLibMinorVersion = 0;

  LIBID_RsFingerLib: TGUID = '{3CBDEECF-08F1-4E84-BAFD-A0823F9CA28B}';

  IID_IRsFinger: TGUID = '{C05AA246-EC15-4190-AD84-D3D7EEA4DA88}';
  CLASS_RsFinger: TGUID = '{954B2329-58EA-4201-A333-43B0CF261B55}';
  IID_IFingerListener: TGUID = '{C2945238-CCC6-4937-A8BC-D01E6EFF4494}';
  DIID_FingerTouchingEvent: TGUID = '{3565D7F3-6512-4005-BCE0-FE566AFADB1F}';
  DIID_TFingerFailureEvent: TGUID = '{C7470EBA-4982-4605-A1A7-ADF5ED650C20}';
  DIID_TFingerSuccessEvent: TGUID = '{49E52561-76E4-4404-BABC-446FF0EE54CC}';
  DIID_TFingerScrollEvent: TGUID = '{910D3894-FD3D-433E-B129-DE84C1DA0A29}';
  DIID_TFeatureInfo: TGUID = '{74494ECC-1546-4C27-AC94-9E96C0F8E395}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TListenMode
type
  TListenMode = TOleEnum;
const
  flmSignle = $00000000;
  flmBoardCast = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsFinger = interface;
  IRsFingerDisp = dispinterface;
  IFingerListener = interface;
  IFingerListenerDisp = dispinterface;
  FingerTouchingEvent = dispinterface;
  TFingerFailureEvent = dispinterface;
  TFingerSuccessEvent = dispinterface;
  TFingerScrollEvent = dispinterface;
  TFeatureInfo = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsFinger = IRsFinger;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IRsFinger
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C05AA246-EC15-4190-AD84-D3D7EEA4DA88}
// *********************************************************************//
  IRsFinger = interface(IDispatch)
    ['{C05AA246-EC15-4190-AD84-D3D7EEA4DA88}']
    procedure Open; safecall;
    procedure Close; safecall;
    procedure BeginScroll; safecall;
    procedure CancelScroll; safecall;
    procedure BeginCapture; safecall;
    procedure EndCapture; safecall;
    procedure AddFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure UpdateFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure DeleteFinger(FingerID: Integer); safecall;
    procedure ClearFingers; safecall;
    function Get_ListenMode: Integer; safecall;
    procedure Set_ListenMode(Value: Integer); safecall;
    function Get_SensorCount: Integer; safecall;
    function Get_SensorIndex: Integer; safecall;
    function Get_SensorSN: WideString; safecall;
    function Get_IsRegister: WordBool; safecall;
    function Get_EnrollIndex: Integer; safecall;
    function Get_Score: Integer; safecall;
    procedure Set_Score(Value: Integer); safecall;
    function Get_Acitve: WordBool; safecall;
    procedure AddListener(const Listener: IFingerListener); safecall;
    procedure DeleteListener(const Listener: IFingerListener); safecall;
    procedure ClearListeners; safecall;
    property ListenMode: Integer read Get_ListenMode write Set_ListenMode;
    property SensorCount: Integer read Get_SensorCount;
    property SensorIndex: Integer read Get_SensorIndex;
    property SensorSN: WideString read Get_SensorSN;
    property IsRegister: WordBool read Get_IsRegister;
    property EnrollIndex: Integer read Get_EnrollIndex;
    property Score: Integer read Get_Score write Set_Score;
    property Acitve: WordBool read Get_Acitve;
  end;

// *********************************************************************//
// DispIntf:  IRsFingerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C05AA246-EC15-4190-AD84-D3D7EEA4DA88}
// *********************************************************************//
  IRsFingerDisp = dispinterface
    ['{C05AA246-EC15-4190-AD84-D3D7EEA4DA88}']
    procedure Open; dispid 201;
    procedure Close; dispid 202;
    procedure BeginScroll; dispid 203;
    procedure CancelScroll; dispid 204;
    procedure BeginCapture; dispid 205;
    procedure EndCapture; dispid 206;
    procedure AddFinger(FingerID: Integer; FingerDatas: OleVariant); dispid 207;
    procedure UpdateFinger(FingerID: Integer; FingerDatas: OleVariant); dispid 208;
    procedure DeleteFinger(FingerID: Integer); dispid 209;
    procedure ClearFingers; dispid 210;
    property ListenMode: Integer dispid 224;
    property SensorCount: Integer readonly dispid 225;
    property SensorIndex: Integer readonly dispid 226;
    property SensorSN: WideString readonly dispid 227;
    property IsRegister: WordBool readonly dispid 228;
    property EnrollIndex: Integer readonly dispid 229;
    property Score: Integer dispid 230;
    property Acitve: WordBool readonly dispid 231;
    procedure AddListener(const Listener: IFingerListener); dispid 211;
    procedure DeleteListener(const Listener: IFingerListener); dispid 212;
    procedure ClearListeners; dispid 213;
  end;

// *********************************************************************//
// Interface: IFingerListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C2945238-CCC6-4937-A8BC-D01E6EFF4494}
// *********************************************************************//
  IFingerListener = interface(IDispatch)
    ['{C2945238-CCC6-4937-A8BC-D01E6EFF4494}']
    procedure FingerTouching(FingerImage: OleVariant); safecall;
    procedure FingerFailure; safecall;
    procedure FingerSuccess(FingerID: SYSUINT); safecall;
    procedure FingerScroll(ActionResult: WordBool; ATemplate: OleVariant); safecall;
    procedure FeatureInfo(AQuality: SYSINT); safecall;
  end;

// *********************************************************************//
// DispIntf:  IFingerListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C2945238-CCC6-4937-A8BC-D01E6EFF4494}
// *********************************************************************//
  IFingerListenerDisp = dispinterface
    ['{C2945238-CCC6-4937-A8BC-D01E6EFF4494}']
    procedure FingerTouching(FingerImage: OleVariant); dispid 201;
    procedure FingerFailure; dispid 202;
    procedure FingerSuccess(FingerID: SYSUINT); dispid 203;
    procedure FingerScroll(ActionResult: WordBool; ATemplate: OleVariant); dispid 204;
    procedure FeatureInfo(AQuality: SYSINT); dispid 205;
  end;

// *********************************************************************//
// DispIntf:  FingerTouchingEvent
// Flags:     (4096) Dispatchable
// GUID:      {3565D7F3-6512-4005-BCE0-FE566AFADB1F}
// *********************************************************************//
  FingerTouchingEvent = dispinterface
    ['{3565D7F3-6512-4005-BCE0-FE566AFADB1F}']
    procedure OnTouchingEvent(FingerImage: OleVariant); dispid 201;
  end;

// *********************************************************************//
// DispIntf:  TFingerFailureEvent
// Flags:     (4096) Dispatchable
// GUID:      {C7470EBA-4982-4605-A1A7-ADF5ED650C20}
// *********************************************************************//
  TFingerFailureEvent = dispinterface
    ['{C7470EBA-4982-4605-A1A7-ADF5ED650C20}']
    procedure OnFailureEvent; dispid 201;
  end;

// *********************************************************************//
// DispIntf:  TFingerSuccessEvent
// Flags:     (4096) Dispatchable
// GUID:      {49E52561-76E4-4404-BABC-446FF0EE54CC}
// *********************************************************************//
  TFingerSuccessEvent = dispinterface
    ['{49E52561-76E4-4404-BABC-446FF0EE54CC}']
    procedure OnSuccessEvent(FingerID: SYSUINT); dispid 201;
  end;

// *********************************************************************//
// DispIntf:  TFingerScrollEvent
// Flags:     (4096) Dispatchable
// GUID:      {910D3894-FD3D-433E-B129-DE84C1DA0A29}
// *********************************************************************//
  TFingerScrollEvent = dispinterface
    ['{910D3894-FD3D-433E-B129-DE84C1DA0A29}']
    procedure OnScrollEvent(ActionResult: WordBool; ATemplate: OleVariant); dispid 201;
  end;

// *********************************************************************//
// DispIntf:  TFeatureInfo
// Flags:     (4096) Dispatchable
// GUID:      {74494ECC-1546-4C27-AC94-9E96C0F8E395}
// *********************************************************************//
  TFeatureInfo = dispinterface
    ['{74494ECC-1546-4C27-AC94-9E96C0F8E395}']
    procedure OnFeatureInfo(AQuality: SYSINT); dispid 201;
  end;

// *********************************************************************//
// The Class CoRsFinger provides a Create and CreateRemote method to          
// create instances of the default interface IRsFinger exposed by              
// the CoClass RsFinger. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsFinger = class
    class function Create: IRsFinger;
    class function CreateRemote(const MachineName: string): IRsFinger;
  end;

implementation

uses ComObj;

class function CoRsFinger.Create: IRsFinger;
begin
  Result := CreateComObject(CLASS_RsFinger) as IRsFinger;
end;

class function CoRsFinger.CreateRemote(const MachineName: string): IRsFinger;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsFinger) as IRsFinger;
end;

end.
