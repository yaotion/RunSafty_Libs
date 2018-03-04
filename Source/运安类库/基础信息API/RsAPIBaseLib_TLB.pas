unit RsAPIBaseLib_TLB;

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
// File generated on 2016-11-09 16:09:03 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\运安类库\基础信息API\RsAPIBaseLib.tlb (1)
// LIBID: {F54CFCCE-2833-4FA9-A856-3D7B12D38610}
// LCID: 0
// Helpfile: 
// HelpString: RsAPIBaseLib Library
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
  RsAPIBaseLibMajorVersion = 1;
  RsAPIBaseLibMinorVersion = 0;

  LIBID_RsAPIBaseLib: TGUID = '{F54CFCCE-2833-4FA9-A856-3D7B12D38610}';

  IID_IRsAPIBase: TGUID = '{B972D3E0-6EE7-4C6F-B7B9-FAEDC67932B2}';
  CLASS_RsAPIBase: TGUID = '{485E666C-8E18-4B7A-ADBC-0B9CF4C14317}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsAPIBase = interface;
  IRsAPIBaseDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsAPIBase = IRsAPIBase;


// *********************************************************************//
// Interface: IRsAPIBase
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B972D3E0-6EE7-4C6F-B7B9-FAEDC67932B2}
// *********************************************************************//
  IRsAPIBase = interface(IDispatch)
    ['{B972D3E0-6EE7-4C6F-B7B9-FAEDC67932B2}']
  end;

// *********************************************************************//
// DispIntf:  IRsAPIBaseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B972D3E0-6EE7-4C6F-B7B9-FAEDC67932B2}
// *********************************************************************//
  IRsAPIBaseDisp = dispinterface
    ['{B972D3E0-6EE7-4C6F-B7B9-FAEDC67932B2}']
  end;

// *********************************************************************//
// The Class CoRsAPIBase provides a Create and CreateRemote method to          
// create instances of the default interface IRsAPIBase exposed by              
// the CoClass RsAPIBase. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsAPIBase = class
    class function Create: IRsAPIBase;
    class function CreateRemote(const MachineName: string): IRsAPIBase;
  end;

implementation

uses ComObj;

class function CoRsAPIBase.Create: IRsAPIBase;
begin
  Result := CreateComObject(CLASS_RsAPIBase) as IRsAPIBase;
end;

class function CoRsAPIBase.CreateRemote(const MachineName: string): IRsAPIBase;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsAPIBase) as IRsAPIBase;
end;

end.
