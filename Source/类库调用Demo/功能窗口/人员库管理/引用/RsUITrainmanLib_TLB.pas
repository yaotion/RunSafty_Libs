unit RsUITrainmanLib_TLB;

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
// File generated on 2016-11-09 13:33:16 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\运安界面类库\人员模块\RsUITrainmanLib.tlb (1)
// LIBID: {45D91A6A-463F-41BF-AC86-59431C578112}
// LCID: 0
// Helpfile: 
// HelpString: RsUITrainmanLib Library
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
  RsUITrainmanLibMajorVersion = 1;
  RsUITrainmanLibMinorVersion = 0;

  LIBID_RsUITrainmanLib: TGUID = '{45D91A6A-463F-41BF-AC86-59431C578112}';

  IID_IRsUITrainman: TGUID = '{A88A505B-5468-4117-8EEE-E66111758866}';
  CLASS_RsUITrainman: TGUID = '{643AD34D-3AAB-4D9F-A4D3-5F59FBB3ABEF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsUITrainman = interface;
  IRsUITrainmanDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsUITrainman = IRsUITrainman;


// *********************************************************************//
// Interface: IRsUITrainman
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A88A505B-5468-4117-8EEE-E66111758866}
// *********************************************************************//
  IRsUITrainman = interface(IDispatch)
    ['{A88A505B-5468-4117-8EEE-E66111758866}']
    function InputTrainman(const WorkShopGUID: WideString; out Trainman: IDispatch): WordBool; safecall;
    function Get_APITrainman: IDispatch; safecall;
    procedure Set_APITrainman(const Value: IDispatch); safecall;
    property APITrainman: IDispatch read Get_APITrainman write Set_APITrainman;
  end;

// *********************************************************************//
// DispIntf:  IRsUITrainmanDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A88A505B-5468-4117-8EEE-E66111758866}
// *********************************************************************//
  IRsUITrainmanDisp = dispinterface
    ['{A88A505B-5468-4117-8EEE-E66111758866}']
    function InputTrainman(const WorkShopGUID: WideString; out Trainman: IDispatch): WordBool; dispid 201;
    property APITrainman: IDispatch dispid 202;
  end;

// *********************************************************************//
// The Class CoRsUITrainman provides a Create and CreateRemote method to          
// create instances of the default interface IRsUITrainman exposed by              
// the CoClass RsUITrainman. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsUITrainman = class
    class function Create: IRsUITrainman;
    class function CreateRemote(const MachineName: string): IRsUITrainman;
  end;

implementation

uses ComObj;

class function CoRsUITrainman.Create: IRsUITrainman;
begin
  Result := CreateComObject(CLASS_RsUITrainman) as IRsUITrainman;
end;

class function CoRsUITrainman.CreateRemote(const MachineName: string): IRsUITrainman;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsUITrainman) as IRsUITrainman;
end;

end.
