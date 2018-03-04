unit RsTMFPLib_TLB;

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
// File generated on 2016-11-19 11:55:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\人员指纹识别\RsTMFPLib.tlb (1)
// LIBID: {7E4DD3A2-828C-49FD-9B52-8A56ABDB2C33}
// LCID: 0
// Helpfile: 
// HelpString: RsTMFPLib Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
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
  RsTMFPLibMajorVersion = 1;
  RsTMFPLibMinorVersion = 0;

  LIBID_RsTMFPLib: TGUID = '{7E4DD3A2-828C-49FD-9B52-8A56ABDB2C33}';

  IID_IRsTMFP: TGUID = '{C4EE34A5-A54D-4D9F-A07C-BFDC373D8D81}';
  IID_IRsFingerTrainman: TGUID = '{A6E9AAF3-19D1-4218-8A78-5DB27216D9B6}';
  IID_IRsFingerListener: TGUID = '{D1EBD4BA-EC3F-4BA8-A1CF-9360856AD568}';
  IID_IRsFingerProxy: TGUID = '{A4AD5189-3EE1-46A2-A63E-EA38A213389E}';
  IID_IRsFingerUtils: TGUID = '{F59FFAEF-4A8B-467C-B44C-D10033D44215}';
  CLASS_RsFingerUtils: TGUID = '{764F393C-71B7-49CC-A2F5-D6D2286C8A03}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsTMFP = interface;
  IRsTMFPDisp = dispinterface;
  IRsFingerTrainman = interface;
  IRsFingerTrainmanDisp = dispinterface;
  IRsFingerListener = interface;
  IRsFingerListenerDisp = dispinterface;
  IRsFingerProxy = interface;
  IRsFingerProxyDisp = dispinterface;
  IRsFingerUtils = interface;
  IRsFingerUtilsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsFingerUtils = IRsFingerUtils;


// *********************************************************************//
// Interface: IRsTMFP
// Flags:     (320) Dual OleAutomation
// GUID:      {C4EE34A5-A54D-4D9F-A07C-BFDC373D8D81}
// *********************************************************************//
  IRsTMFP = interface(IUnknown)
    ['{C4EE34A5-A54D-4D9F-A07C-BFDC373D8D81}']
    procedure LoadLocalTrainmans(ShowProgress: WordBool); safecall;
    procedure UpdateTrainmans(ShowProgress: WordBool); safecall;
    procedure RegFinger(const TrainmanNumber: WideString); safecall;
    procedure AddListener(const Listener: IRsFingerListener); safecall;
    function Get_InitSucceed: WordBool; safecall;
    function Get_Global: IUnknown; safecall;
    procedure Set_Global(const Value: IUnknown); safecall;
    function GetTrainmanByNumber(const TrainmanNumber: WideString; out Trainman: IRsFingerTrainman): WordBool; safecall;
    procedure DelListener(const Listener: IRsFingerListener); safecall;
    procedure Init; safecall;
    function Get_LocalIdentity: WordBool; safecall;
    procedure Set_LocalIdentity(Value: WordBool); safecall;
    property InitSucceed: WordBool read Get_InitSucceed;
    property Global: IUnknown read Get_Global write Set_Global;
    property LocalIdentity: WordBool read Get_LocalIdentity write Set_LocalIdentity;
  end;

// *********************************************************************//
// DispIntf:  IRsTMFPDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {C4EE34A5-A54D-4D9F-A07C-BFDC373D8D81}
// *********************************************************************//
  IRsTMFPDisp = dispinterface
    ['{C4EE34A5-A54D-4D9F-A07C-BFDC373D8D81}']
    procedure LoadLocalTrainmans(ShowProgress: WordBool); dispid 202;
    procedure UpdateTrainmans(ShowProgress: WordBool); dispid 203;
    procedure RegFinger(const TrainmanNumber: WideString); dispid 206;
    procedure AddListener(const Listener: IRsFingerListener); dispid 207;
    property InitSucceed: WordBool readonly dispid 208;
    property Global: IUnknown dispid 201;
    function GetTrainmanByNumber(const TrainmanNumber: WideString; out Trainman: IRsFingerTrainman): WordBool; dispid 209;
    procedure DelListener(const Listener: IRsFingerListener); dispid 210;
    procedure Init; dispid 211;
    property LocalIdentity: WordBool dispid 204;
  end;

// *********************************************************************//
// Interface: IRsFingerTrainman
// Flags:     (320) Dual OleAutomation
// GUID:      {A6E9AAF3-19D1-4218-8A78-5DB27216D9B6}
// *********************************************************************//
  IRsFingerTrainman = interface(IUnknown)
    ['{A6E9AAF3-19D1-4218-8A78-5DB27216D9B6}']
    function Get_TrainmanGUID: WideString; safecall;
    procedure Set_TrainmanGUID(const Value: WideString); safecall;
    function Get_TrainmanID: Integer; safecall;
    procedure Set_TrainmanID(Value: Integer); safecall;
    function Get_TrainmanNumber: WideString; safecall;
    procedure Set_TrainmanNumber(const Value: WideString); safecall;
    function Get_TrainmanName: WideString; safecall;
    procedure Set_TrainmanName(const Value: WideString); safecall;
    function Get_FingerPrint1: OleVariant; safecall;
    procedure Set_FingerPrint1(Value: OleVariant); safecall;
    function Get_FingerPrint2: OleVariant; safecall;
    procedure Set_FingerPrint2(Value: OleVariant); safecall;
    function Get_Picture: OleVariant; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    property TrainmanGUID: WideString read Get_TrainmanGUID write Set_TrainmanGUID;
    property TrainmanID: Integer read Get_TrainmanID write Set_TrainmanID;
    property TrainmanNumber: WideString read Get_TrainmanNumber write Set_TrainmanNumber;
    property TrainmanName: WideString read Get_TrainmanName write Set_TrainmanName;
    property FingerPrint1: OleVariant read Get_FingerPrint1 write Set_FingerPrint1;
    property FingerPrint2: OleVariant read Get_FingerPrint2 write Set_FingerPrint2;
    property Picture: OleVariant read Get_Picture write Set_Picture;
  end;

// *********************************************************************//
// DispIntf:  IRsFingerTrainmanDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {A6E9AAF3-19D1-4218-8A78-5DB27216D9B6}
// *********************************************************************//
  IRsFingerTrainmanDisp = dispinterface
    ['{A6E9AAF3-19D1-4218-8A78-5DB27216D9B6}']
    property TrainmanGUID: WideString dispid 101;
    property TrainmanID: Integer dispid 102;
    property TrainmanNumber: WideString dispid 103;
    property TrainmanName: WideString dispid 104;
    property FingerPrint1: OleVariant dispid 105;
    property FingerPrint2: OleVariant dispid 106;
    property Picture: OleVariant dispid 107;
  end;

// *********************************************************************//
// Interface: IRsFingerListener
// Flags:     (320) Dual OleAutomation
// GUID:      {D1EBD4BA-EC3F-4BA8-A1CF-9360856AD568}
// *********************************************************************//
  IRsFingerListener = interface(IUnknown)
    ['{D1EBD4BA-EC3F-4BA8-A1CF-9360856AD568}']
    procedure CaptureTrainman(const Trainman: IRsFingerTrainman); safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsFingerListenerDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {D1EBD4BA-EC3F-4BA8-A1CF-9360856AD568}
// *********************************************************************//
  IRsFingerListenerDisp = dispinterface
    ['{D1EBD4BA-EC3F-4BA8-A1CF-9360856AD568}']
    procedure CaptureTrainman(const Trainman: IRsFingerTrainman); dispid 101;
  end;

// *********************************************************************//
// Interface: IRsFingerProxy
// Flags:     (320) Dual OleAutomation
// GUID:      {A4AD5189-3EE1-46A2-A63E-EA38A213389E}
// *********************************************************************//
  IRsFingerProxy = interface(IUnknown)
    ['{A4AD5189-3EE1-46A2-A63E-EA38A213389E}']
    function Get_RsTrainmanFP: IRsTMFP; safecall;
    procedure Set_RsTrainmanFP(const Value: IRsTMFP); safecall;
    property RsTrainmanFP: IRsTMFP read Get_RsTrainmanFP write Set_RsTrainmanFP;
  end;

// *********************************************************************//
// DispIntf:  IRsFingerProxyDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {A4AD5189-3EE1-46A2-A63E-EA38A213389E}
// *********************************************************************//
  IRsFingerProxyDisp = dispinterface
    ['{A4AD5189-3EE1-46A2-A63E-EA38A213389E}']
    property RsTrainmanFP: IRsTMFP dispid 201;
  end;

// *********************************************************************//
// Interface: IRsFingerUtils
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F59FFAEF-4A8B-467C-B44C-D10033D44215}
// *********************************************************************//
  IRsFingerUtils = interface(IDispatch)
    ['{F59FFAEF-4A8B-467C-B44C-D10033D44215}']
    function GetProxy: IRsFingerProxy; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsFingerUtilsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F59FFAEF-4A8B-467C-B44C-D10033D44215}
// *********************************************************************//
  IRsFingerUtilsDisp = dispinterface
    ['{F59FFAEF-4A8B-467C-B44C-D10033D44215}']
    function GetProxy: IRsFingerProxy; dispid 201;
  end;

// *********************************************************************//
// The Class CoRsFingerUtils provides a Create and CreateRemote method to          
// create instances of the default interface IRsFingerUtils exposed by              
// the CoClass RsFingerUtils. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsFingerUtils = class
    class function Create: IRsFingerUtils;
    class function CreateRemote(const MachineName: string): IRsFingerUtils;
  end;

implementation

uses ComObj;

class function CoRsFingerUtils.Create: IRsFingerUtils;
begin
  Result := CreateComObject(CLASS_RsFingerUtils) as IRsFingerUtils;
end;

class function CoRsFingerUtils.CreateRemote(const MachineName: string): IRsFingerUtils;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsFingerUtils) as IRsFingerUtils;
end;

end.
