unit RsBJTrainPlanLib_TLB;

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
// File generated on 2016-11-15 16:55:47 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\机车计划\RsBJTrainPlanLib.tlb (1)
// LIBID: {5014E738-4F4C-4A1C-A864-E47140CD0FE7}
// LCID: 0
// Helpfile: 
// HelpString: RsBJTrainPlanLib Library
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
  RsBJTrainPlanLibMajorVersion = 1;
  RsBJTrainPlanLibMinorVersion = 0;

  LIBID_RsBJTrainPlanLib: TGUID = '{5014E738-4F4C-4A1C-A864-E47140CD0FE7}';

  IID_IRsBJTrainPlan: TGUID = '{B8485DB6-3D0F-4943-8FA2-5BF1475AF6A7}';
  CLASS_RsBJTrainPlan: TGUID = '{2819D30C-ECC1-4FFF-9184-180210B475EB}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsBJTrainPlan = interface;
  IRsBJTrainPlanDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsBJTrainPlan = IRsBJTrainPlan;


// *********************************************************************//
// Interface: IRsBJTrainPlan
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8485DB6-3D0F-4943-8FA2-5BF1475AF6A7}
// *********************************************************************//
  IRsBJTrainPlan = interface(IDispatch)
    ['{B8485DB6-3D0F-4943-8FA2-5BF1475AF6A7}']
    function Get_Global: IDispatch; safecall;
    procedure Set_Global(const Value: IDispatch); safecall;
    procedure ShowForm(Readonly: WordBool); safecall;
    property Global: IDispatch read Get_Global write Set_Global;
  end;

// *********************************************************************//
// DispIntf:  IRsBJTrainPlanDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8485DB6-3D0F-4943-8FA2-5BF1475AF6A7}
// *********************************************************************//
  IRsBJTrainPlanDisp = dispinterface
    ['{B8485DB6-3D0F-4943-8FA2-5BF1475AF6A7}']
    property Global: IDispatch dispid 201;
    procedure ShowForm(Readonly: WordBool); dispid 202;
  end;

// *********************************************************************//
// The Class CoRsBJTrainPlan provides a Create and CreateRemote method to          
// create instances of the default interface IRsBJTrainPlan exposed by              
// the CoClass RsBJTrainPlan. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsBJTrainPlan = class
    class function Create: IRsBJTrainPlan;
    class function CreateRemote(const MachineName: string): IRsBJTrainPlan;
  end;

implementation

uses ComObj;

class function CoRsBJTrainPlan.Create: IRsBJTrainPlan;
begin
  Result := CreateComObject(CLASS_RsBJTrainPlan) as IRsBJTrainPlan;
end;

class function CoRsBJTrainPlan.CreateRemote(const MachineName: string): IRsBJTrainPlan;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsBJTrainPlan) as IRsBJTrainPlan;
end;

end.
