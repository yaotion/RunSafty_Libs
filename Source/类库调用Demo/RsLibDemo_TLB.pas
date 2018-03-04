unit RsLibDemo_TLB;

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
// File generated on 2016-11-03 14:40:31 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\类库调用Demo\RsLibDemo.tlb (1)
// LIBID: {D79EE34F-CBA3-42BA-A6B9-F04C62178D75}
// LCID: 0
// Helpfile: 
// HelpString: RsLibDemo Library
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
  RsLibDemoMajorVersion = 1;
  RsLibDemoMinorVersion = 0;

  LIBID_RsLibDemo: TGUID = '{D79EE34F-CBA3-42BA-A6B9-F04C62178D75}';

  IID_IRsUtilsLib: TGUID = '{909DBD10-EC60-4AE8-8756-9C6B85EC4096}';
  CLASS_RsUtilsLib: TGUID = '{E87321B6-DDF9-44E3-8FD2-48D4E24DBA81}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsUtilsLib = interface;
  IRsUtilsLibDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsUtilsLib = IRsUtilsLib;


// *********************************************************************//
// Interface: IRsUtilsLib
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {909DBD10-EC60-4AE8-8756-9C6B85EC4096}
// *********************************************************************//
  IRsUtilsLib = interface(IDispatch)
    ['{909DBD10-EC60-4AE8-8756-9C6B85EC4096}']
  end;

// *********************************************************************//
// DispIntf:  IRsUtilsLibDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {909DBD10-EC60-4AE8-8756-9C6B85EC4096}
// *********************************************************************//
  IRsUtilsLibDisp = dispinterface
    ['{909DBD10-EC60-4AE8-8756-9C6B85EC4096}']
  end;

// *********************************************************************//
// The Class CoRsUtilsLib provides a Create and CreateRemote method to          
// create instances of the default interface IRsUtilsLib exposed by              
// the CoClass RsUtilsLib. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsUtilsLib = class
    class function Create: IRsUtilsLib;
    class function CreateRemote(const MachineName: string): IRsUtilsLib;
  end;

implementation

uses ComObj;

class function CoRsUtilsLib.Create: IRsUtilsLib;
begin
  Result := CreateComObject(CLASS_RsUtilsLib) as IRsUtilsLib;
end;

class function CoRsUtilsLib.CreateRemote(const MachineName: string): IRsUtilsLib;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsUtilsLib) as IRsUtilsLib;
end;

end.
