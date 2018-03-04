unit RsUtilsLib_TLB;

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
// File generated on 2016-11-04 15:43:58 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\运安类库\通用\RsUtilsLib.tlb (1)
// LIBID: {B79E979C-0516-4EEA-A219-B7CCB72AD767}
// LCID: 0
// Helpfile: 
// HelpString: RsUtilsLib Library
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
  RsUtilsLibMajorVersion = 1;
  RsUtilsLibMinorVersion = 0;

  LIBID_RsUtilsLib: TGUID = '{B79E979C-0516-4EEA-A219-B7CCB72AD767}';

  IID_IWebAPI: TGUID = '{0B512E3A-631E-4E29-9859-823C2962406D}';
  CLASS_WebAPI: TGUID = '{A25F8549-01EC-4348-B527-0D10DB00D4C3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWebAPI = interface;
  IWebAPIDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  WebAPI = IWebAPI;


// *********************************************************************//
// Interface: IWebAPI
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B512E3A-631E-4E29-9859-823C2962406D}
// *********************************************************************//
  IWebAPI = interface(IDispatch)
    ['{0B512E3A-631E-4E29-9859-823C2962406D}']
    function Post(const APIName: WideString; const InputData: WideString): WideString; safecall;
    function CheckPostSuccess(const strOutputData: WideString; var strResultText: WideString): WordBool; safecall;
    function GetHttpDataJson(const strOutputData: WideString): IUnknown; safecall;
    function Get_Host: WideString; safecall;
    procedure Set_Host(const Value: WideString); safecall;
    function Get_Port: Integer; safecall;
    procedure Set_Port(Value: Integer); safecall;
    function Get_OffsetUrl: WideString; safecall;
    procedure Set_OffsetUrl(const Value: WideString); safecall;
    property Host: WideString read Get_Host write Set_Host;
    property Port: Integer read Get_Port write Set_Port;
    property OffsetUrl: WideString read Get_OffsetUrl write Set_OffsetUrl;
  end;

// *********************************************************************//
// DispIntf:  IWebAPIDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B512E3A-631E-4E29-9859-823C2962406D}
// *********************************************************************//
  IWebAPIDisp = dispinterface
    ['{0B512E3A-631E-4E29-9859-823C2962406D}']
    function Post(const APIName: WideString; const InputData: WideString): WideString; dispid 201;
    function CheckPostSuccess(const strOutputData: WideString; var strResultText: WideString): WordBool; dispid 203;
    function GetHttpDataJson(const strOutputData: WideString): IUnknown; dispid 204;
    property Host: WideString dispid 205;
    property Port: Integer dispid 206;
    property OffsetUrl: WideString dispid 207;
  end;

// *********************************************************************//
// The Class CoWebAPI provides a Create and CreateRemote method to          
// create instances of the default interface IWebAPI exposed by              
// the CoClass WebAPI. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWebAPI = class
    class function Create: IWebAPI;
    class function CreateRemote(const MachineName: string): IWebAPI;
  end;

implementation

uses ComObj;

class function CoWebAPI.Create: IWebAPI;
begin
  Result := CreateComObject(CLASS_WebAPI) as IWebAPI;
end;

class function CoWebAPI.CreateRemote(const MachineName: string): IWebAPI;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WebAPI) as IWebAPI;
end;

end.
