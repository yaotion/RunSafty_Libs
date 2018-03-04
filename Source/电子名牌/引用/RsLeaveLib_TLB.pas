unit RsLeaveLib_TLB;

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
// File generated on 2017-03-01 15:34:23 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\请销假\RsLeaveLib.tlb (1)
// LIBID: {BACB2E2B-4FB2-4909-9015-837F1AE77064}
// LCID: 0
// Helpfile: 
// HelpString: RsLeaveLib Library
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
  RsLeaveLibMajorVersion = 1;
  RsLeaveLibMinorVersion = 0;

  LIBID_RsLeaveLib: TGUID = '{BACB2E2B-4FB2-4909-9015-837F1AE77064}';

  IID_IRsUILeave: TGUID = '{A79657D4-D03E-482A-BD58-25BE9FB5C50B}';
  CLASS_RsUILeave: TGUID = '{E61C51F8-BAA5-48A3-806D-04175F60F7BA}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsUILeave = interface;
  IRsUILeaveDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsUILeave = IRsUILeave;


// *********************************************************************//
// Interface: IRsUILeave
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A79657D4-D03E-482A-BD58-25BE9FB5C50B}
// *********************************************************************//
  IRsUILeave = interface(IDispatch)
    ['{A79657D4-D03E-482A-BD58-25BE9FB5C50B}']
    procedure TypeShowQuery; safecall;
    procedure ShowQuery(EditEnable: WordBool); safecall;
    function Askfor(const TrainmanNumber: WideString): WordBool; safecall;
    function Cancel(const TrainmanNumber: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsUILeaveDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A79657D4-D03E-482A-BD58-25BE9FB5C50B}
// *********************************************************************//
  IRsUILeaveDisp = dispinterface
    ['{A79657D4-D03E-482A-BD58-25BE9FB5C50B}']
    procedure TypeShowQuery; dispid 201;
    procedure ShowQuery(EditEnable: WordBool); dispid 202;
    function Askfor(const TrainmanNumber: WideString): WordBool; dispid 203;
    function Cancel(const TrainmanNumber: WideString): WordBool; dispid 204;
  end;

// *********************************************************************//
// The Class CoRsUILeave provides a Create and CreateRemote method to          
// create instances of the default interface IRsUILeave exposed by              
// the CoClass RsUILeave. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsUILeave = class
    class function Create: IRsUILeave;
    class function CreateRemote(const MachineName: string): IRsUILeave;
  end;

implementation

uses ComObj;

class function CoRsUILeave.Create: IRsUILeave;
begin
  Result := CreateComObject(CLASS_RsUILeave) as IRsUILeave;
end;

class function CoRsUILeave.CreateRemote(const MachineName: string): IRsUILeave;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsUILeave) as IRsUILeave;
end;

end.
