unit RsGoodsManage_TLB;

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
// File generated on 2016-11-21 17:50:00 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\物品管理\RsGoodsManage.tlb (1)
// LIBID: {4935A731-18DB-4678-8EE8-46F64A1484E9}
// LCID: 0
// Helpfile: 
// HelpString: RsGoodsManage Library
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
  RsGoodsManageMajorVersion = 1;
  RsGoodsManageMinorVersion = 0;

  LIBID_RsGoodsManage: TGUID = '{4935A731-18DB-4678-8EE8-46F64A1484E9}';

  IID_IGoodsManage: TGUID = '{5A62BD85-20E9-46B4-934F-795B28240C8A}';
  CLASS_GoodsManage: TGUID = '{853E3F1D-2DBD-47FB-85DD-643E990BE45D}';
  IID_ITm: TGUID = '{BBC9C37E-84D9-4303-A4C1-8588056A387D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGoodsManage = interface;
  IGoodsManageDisp = dispinterface;
  ITm = interface;
  ITmDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  GoodsManage = IGoodsManage;


// *********************************************************************//
// Interface: IGoodsManage
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A62BD85-20E9-46B4-934F-795B28240C8A}
// *********************************************************************//
  IGoodsManage = interface(IDispatch)
    ['{5A62BD85-20E9-46B4-934F-795B28240C8A}']
    procedure CodeRangeMgr; safecall;
    procedure GoodsMgr; safecall;
    procedure SendGoods(const Tm: ITm); safecall;
    function CreateTm: ITm; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGoodsManageDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5A62BD85-20E9-46B4-934F-795B28240C8A}
// *********************************************************************//
  IGoodsManageDisp = dispinterface
    ['{5A62BD85-20E9-46B4-934F-795B28240C8A}']
    procedure CodeRangeMgr; dispid 201;
    procedure GoodsMgr; dispid 202;
    procedure SendGoods(const Tm: ITm); dispid 203;
    function CreateTm: ITm; dispid 204;
  end;

// *********************************************************************//
// Interface: ITm
// Flags:     (320) Dual OleAutomation
// GUID:      {BBC9C37E-84D9-4303-A4C1-8588056A387D}
// *********************************************************************//
  ITm = interface(IUnknown)
    ['{BBC9C37E-84D9-4303-A4C1-8588056A387D}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Verify: Integer; safecall;
    procedure Set_Verify(Value: Integer); safecall;
    property ID: WideString read Get_ID write Set_ID;
    property Number: WideString read Get_Number write Set_Number;
    property Name: WideString read Get_Name write Set_Name;
    property Verify: Integer read Get_Verify write Set_Verify;
  end;

// *********************************************************************//
// DispIntf:  ITmDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {BBC9C37E-84D9-4303-A4C1-8588056A387D}
// *********************************************************************//
  ITmDisp = dispinterface
    ['{BBC9C37E-84D9-4303-A4C1-8588056A387D}']
    property ID: WideString dispid 101;
    property Number: WideString dispid 102;
    property Name: WideString dispid 103;
    property Verify: Integer dispid 104;
  end;

// *********************************************************************//
// The Class CoGoodsManage provides a Create and CreateRemote method to          
// create instances of the default interface IGoodsManage exposed by              
// the CoClass GoodsManage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGoodsManage = class
    class function Create: IGoodsManage;
    class function CreateRemote(const MachineName: string): IGoodsManage;
  end;

implementation

uses ComObj;

class function CoGoodsManage.Create: IGoodsManage;
begin
  Result := CreateComObject(CLASS_GoodsManage) as IGoodsManage;
end;

class function CoGoodsManage.CreateRemote(const MachineName: string): IGoodsManage;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GoodsManage) as IGoodsManage;
end;

end.
