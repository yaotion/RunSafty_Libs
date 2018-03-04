unit RsUILoginLib_TLB;

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
// File generated on 2017-03-24 16:49:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\登录窗口\RsUILoginLib.tlb (1)
// LIBID: {E061985D-AD78-4040-AA01-1760F461359B}
// LCID: 0
// Helpfile: 
// HelpString: RsUILoginLib Library
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
  RsUILoginLibMajorVersion = 1;
  RsUILoginLibMinorVersion = 0;

  LIBID_RsUILoginLib: TGUID = '{E061985D-AD78-4040-AA01-1760F461359B}';

  IID_IRsUILogin: TGUID = '{6707BA2D-8800-4669-87C9-A00A367F10CB}';
  CLASS_RsUILogin: TGUID = '{CD8C6603-D35F-40A6-813C-DD9AED3C7A92}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsUILogin = interface;
  IRsUILoginDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsUILogin = IRsUILogin;


// *********************************************************************//
// Interface: IRsUILogin
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6707BA2D-8800-4669-87C9-A00A367F10CB}
// *********************************************************************//
  IRsUILogin = interface(IDispatch)
    ['{6707BA2D-8800-4669-87C9-A00A367F10CB}']
    function Login(out TokenString: WideString): WordBool; safecall;
    function Get_WebAPI: IDispatch; safecall;
    procedure Set_WebAPI(const Value: IDispatch); safecall;
    procedure OpenSetup; safecall;
    property WebAPI: IDispatch read Get_WebAPI write Set_WebAPI;
  end;

// *********************************************************************//
// DispIntf:  IRsUILoginDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6707BA2D-8800-4669-87C9-A00A367F10CB}
// *********************************************************************//
  IRsUILoginDisp = dispinterface
    ['{6707BA2D-8800-4669-87C9-A00A367F10CB}']
    function Login(out TokenString: WideString): WordBool; dispid 201;
    property WebAPI: IDispatch dispid 202;
    procedure OpenSetup; dispid 203;
  end;

// *********************************************************************//
// The Class CoRsUILogin provides a Create and CreateRemote method to          
// create instances of the default interface IRsUILogin exposed by              
// the CoClass RsUILogin. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsUILogin = class
    class function Create: IRsUILogin;
    class function CreateRemote(const MachineName: string): IRsUILogin;
  end;

implementation

uses ComObj;

class function CoRsUILogin.Create: IRsUILogin;
begin
  Result := CreateComObject(CLASS_RsUILogin) as IRsUILogin;
end;

class function CoRsUILogin.CreateRemote(const MachineName: string): IRsUILogin;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsUILogin) as IRsUILogin;
end;

end.
