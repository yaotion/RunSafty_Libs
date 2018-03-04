unit RsGlobal_TLB;

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
// File generated on 2016-11-16 16:31:13 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\global\RsGlobal.tlb (1)
// LIBID: {A24C49EE-0623-4B82-BF56-198B9AEF3B4A}
// LCID: 0
// Helpfile: 
// HelpString: RsGlobal Library
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
  RsGlobalMajorVersion = 1;
  RsGlobalMinorVersion = 0;

  LIBID_RsGlobal: TGUID = '{A24C49EE-0623-4B82-BF56-198B9AEF3B4A}';

  IID_IGlobal: TGUID = '{BBEEEA94-0BDA-4793-9928-19037322D5F2}';
  IID_ISite: TGUID = '{F50CBF78-5173-4A97-BC47-16E0DFDC60A6}';
  IID_IUser: TGUID = '{33F46E1F-2CD2-4BCC-AAB9-585E1FED1CEF}';
  IID_IWorkShop: TGUID = '{A67AB555-C80F-42F5-914C-A03D3AA1077A}';
  CLASS_Global: TGUID = '{57305F3B-35F6-4E05-902D-EA917D1E890E}';
  IID_IWebAPI: TGUID = '{7DCD7A7F-5FAE-4E15-BF28-17CC78C59C9B}';
  IID_IGlobalProxy: TGUID = '{64C8627C-DA89-4A27-BE16-77E6A85BCC31}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGlobal = interface;
  IGlobalDisp = dispinterface;
  ISite = interface;
  ISiteDisp = dispinterface;
  IUser = interface;
  IUserDisp = dispinterface;
  IWorkShop = interface;
  IWorkShopDisp = dispinterface;
  IWebAPI = interface;
  IWebAPIDisp = dispinterface;
  IGlobalProxy = interface;
  IGlobalProxyDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Global = IGlobal;


// *********************************************************************//
// Interface: IGlobal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BBEEEA94-0BDA-4793-9928-19037322D5F2}
// *********************************************************************//
  IGlobal = interface(IDispatch)
    ['{BBEEEA94-0BDA-4793-9928-19037322D5F2}']
    function GetProxy: IGlobalProxy; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGlobalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BBEEEA94-0BDA-4793-9928-19037322D5F2}
// *********************************************************************//
  IGlobalDisp = dispinterface
    ['{BBEEEA94-0BDA-4793-9928-19037322D5F2}']
    function GetProxy: IGlobalProxy; dispid 201;
  end;

// *********************************************************************//
// Interface: ISite
// Flags:     (320) Dual OleAutomation
// GUID:      {F50CBF78-5173-4A97-BC47-16E0DFDC60A6}
// *********************************************************************//
  ISite = interface(IUnknown)
    ['{F50CBF78-5173-4A97-BC47-16E0DFDC60A6}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    property ID: WideString read Get_ID write Set_ID;
    property Number: WideString read Get_Number write Set_Number;
    property Name: WideString read Get_Name write Set_Name;
  end;

// *********************************************************************//
// DispIntf:  ISiteDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {F50CBF78-5173-4A97-BC47-16E0DFDC60A6}
// *********************************************************************//
  ISiteDisp = dispinterface
    ['{F50CBF78-5173-4A97-BC47-16E0DFDC60A6}']
    property ID: WideString dispid 201;
    property Number: WideString dispid 202;
    property Name: WideString dispid 203;
  end;

// *********************************************************************//
// Interface: IUser
// Flags:     (320) Dual OleAutomation
// GUID:      {33F46E1F-2CD2-4BCC-AAB9-585E1FED1CEF}
// *********************************************************************//
  IUser = interface(IUnknown)
    ['{33F46E1F-2CD2-4BCC-AAB9-585E1FED1CEF}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    property ID: WideString read Get_ID write Set_ID;
    property Number: WideString read Get_Number write Set_Number;
    property Name: WideString read Get_Name write Set_Name;
  end;

// *********************************************************************//
// DispIntf:  IUserDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {33F46E1F-2CD2-4BCC-AAB9-585E1FED1CEF}
// *********************************************************************//
  IUserDisp = dispinterface
    ['{33F46E1F-2CD2-4BCC-AAB9-585E1FED1CEF}']
    property ID: WideString dispid 201;
    property Number: WideString dispid 202;
    property Name: WideString dispid 203;
  end;

// *********************************************************************//
// Interface: IWorkShop
// Flags:     (320) Dual OleAutomation
// GUID:      {A67AB555-C80F-42F5-914C-A03D3AA1077A}
// *********************************************************************//
  IWorkShop = interface(IUnknown)
    ['{A67AB555-C80F-42F5-914C-A03D3AA1077A}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    property ID: WideString read Get_ID write Set_ID;
    property Name: WideString read Get_Name write Set_Name;
  end;

// *********************************************************************//
// DispIntf:  IWorkShopDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {A67AB555-C80F-42F5-914C-A03D3AA1077A}
// *********************************************************************//
  IWorkShopDisp = dispinterface
    ['{A67AB555-C80F-42F5-914C-A03D3AA1077A}']
    property ID: WideString dispid 201;
    property Name: WideString dispid 202;
  end;

// *********************************************************************//
// Interface: IWebAPI
// Flags:     (320) Dual OleAutomation
// GUID:      {7DCD7A7F-5FAE-4E15-BF28-17CC78C59C9B}
// *********************************************************************//
  IWebAPI = interface(IUnknown)
    ['{7DCD7A7F-5FAE-4E15-BF28-17CC78C59C9B}']
    function Get_Host: WideString; safecall;
    function Get_Port: SYSINT; safecall;
    function Get_URL: WideString; safecall;
    procedure Set_URL(const Value: WideString); safecall;
    property Host: WideString read Get_Host;
    property Port: SYSINT read Get_Port;
    property URL: WideString read Get_URL write Set_URL;
  end;

// *********************************************************************//
// DispIntf:  IWebAPIDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {7DCD7A7F-5FAE-4E15-BF28-17CC78C59C9B}
// *********************************************************************//
  IWebAPIDisp = dispinterface
    ['{7DCD7A7F-5FAE-4E15-BF28-17CC78C59C9B}']
    property Host: WideString readonly dispid 201;
    property Port: SYSINT readonly dispid 202;
    property URL: WideString dispid 101;
  end;

// *********************************************************************//
// Interface: IGlobalProxy
// Flags:     (320) Dual OleAutomation
// GUID:      {64C8627C-DA89-4A27-BE16-77E6A85BCC31}
// *********************************************************************//
  IGlobalProxy = interface(IUnknown)
    ['{64C8627C-DA89-4A27-BE16-77E6A85BCC31}']
    function Get_Site: ISite; safecall;
    function Get_User: IUser; safecall;
    function Get_WorkShop: IWorkShop; safecall;
    function ReadIniConfig(const Section: WideString; const Ident: WideString): WideString; safecall;
    procedure WriteIniConfig(const Section: WideString; const Ident: WideString; 
                             const Value: WideString); safecall;
    function ReadServerConfig(const Section: WideString; const Ident: WideString): WideString; safecall;
    procedure WriteServerConfig(const Section: WideString; const Ident: WideString; 
                                const Value: WideString); safecall;
    function Get_WebAPI: IWebAPI; safecall;
    function Get_Value(const Key: WideString): OleVariant; safecall;
    procedure Set_Value(const Key: WideString; Value: OleVariant); safecall;
    function Get_AppHandle: SYSUINT; safecall;
    procedure Set_AppHandle(Value: SYSUINT); safecall;
    function Now: TDateTime; safecall;
    function Get_PlaceID: WideString; safecall;
    property Site: ISite read Get_Site;
    property User: IUser read Get_User;
    property WorkShop: IWorkShop read Get_WorkShop;
    property WebAPI: IWebAPI read Get_WebAPI;
    property Value[const Key: WideString]: OleVariant read Get_Value write Set_Value;
    property AppHandle: SYSUINT read Get_AppHandle write Set_AppHandle;
    property PlaceID: WideString read Get_PlaceID;
  end;

// *********************************************************************//
// DispIntf:  IGlobalProxyDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {64C8627C-DA89-4A27-BE16-77E6A85BCC31}
// *********************************************************************//
  IGlobalProxyDisp = dispinterface
    ['{64C8627C-DA89-4A27-BE16-77E6A85BCC31}']
    property Site: ISite readonly dispid 201;
    property User: IUser readonly dispid 202;
    property WorkShop: IWorkShop readonly dispid 203;
    function ReadIniConfig(const Section: WideString; const Ident: WideString): WideString; dispid 204;
    procedure WriteIniConfig(const Section: WideString; const Ident: WideString; 
                             const Value: WideString); dispid 205;
    function ReadServerConfig(const Section: WideString; const Ident: WideString): WideString; dispid 206;
    procedure WriteServerConfig(const Section: WideString; const Ident: WideString; 
                                const Value: WideString); dispid 207;
    property WebAPI: IWebAPI readonly dispid 208;
    property Value[const Key: WideString]: OleVariant dispid 101;
    property AppHandle: SYSUINT dispid 102;
    function Now: TDateTime; dispid 103;
    property PlaceID: WideString readonly dispid 104;
  end;

// *********************************************************************//
// The Class CoGlobal provides a Create and CreateRemote method to          
// create instances of the default interface IGlobal exposed by              
// the CoClass Global. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGlobal = class
    class function Create: IGlobal;
    class function CreateRemote(const MachineName: string): IGlobal;
  end;

implementation

uses ComObj;

class function CoGlobal.Create: IGlobal;
begin
  Result := CreateComObject(CLASS_Global) as IGlobal;
end;

class function CoGlobal.CreateRemote(const MachineName: string): IGlobal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Global) as IGlobal;
end;

end.
