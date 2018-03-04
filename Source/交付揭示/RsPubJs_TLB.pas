unit RsPubJs_TLB;

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
// File generated on 2016-11-15 16:01:07 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\交付揭示\RsPubJs.tlb (1)
// LIBID: {E74DD5E1-3806-45EC-AD3F-1717EAC83F71}
// LCID: 0
// Helpfile: 
// HelpString: RsPubJs Library
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
  RsPubJsMajorVersion = 1;
  RsPubJsMinorVersion = 0;

  LIBID_RsPubJs: TGUID = '{E74DD5E1-3806-45EC-AD3F-1717EAC83F71}';

  IID_IPubJs: TGUID = '{7E7362F6-CE08-4BF1-91E7-BE3F45977134}';
  CLASS_PubJs: TGUID = '{FD41F55E-2F11-43B7-B423-85C08AC079D8}';
  IID_IParam: TGUID = '{DBC2F946-B2DB-4991-B29A-BC85212C3417}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPubJs = interface;
  IPubJsDisp = dispinterface;
  IParam = interface;
  IParamDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PubJs = IPubJs;


// *********************************************************************//
// Interface: IPubJs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E7362F6-CE08-4BF1-91E7-BE3F45977134}
// *********************************************************************//
  IPubJs = interface(IDispatch)
    ['{7E7362F6-CE08-4BF1-91E7-BE3F45977134}']
    procedure Print(const Param: IParam); safecall;
    function CreateParam: IParam; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPubJsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7E7362F6-CE08-4BF1-91E7-BE3F45977134}
// *********************************************************************//
  IPubJsDisp = dispinterface
    ['{7E7362F6-CE08-4BF1-91E7-BE3F45977134}']
    procedure Print(const Param: IParam); dispid 201;
    function CreateParam: IParam; dispid 202;
  end;

// *********************************************************************//
// Interface: IParam
// Flags:     (320) Dual OleAutomation
// GUID:      {DBC2F946-B2DB-4991-B29A-BC85212C3417}
// *********************************************************************//
  IParam = interface(IUnknown)
    ['{DBC2F946-B2DB-4991-B29A-BC85212C3417}']
    function Get_PlanID: WideString; safecall;
    procedure Set_PlanID(const Value: WideString); safecall;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_TrainNumber: WideString; safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    function Get_PlanTime: TDateTime; safecall;
    procedure Set_PlanTime(Value: TDateTime); safecall;
    function Get_TmNumber1: WideString; safecall;
    procedure Set_TmNumber1(const Value: WideString); safecall;
    function Get_TmName1: WideString; safecall;
    procedure Set_TmName1(const Value: WideString); safecall;
    function Get_TmNumber2: WideString; safecall;
    procedure Set_TmNumber2(const Value: WideString); safecall;
    function Get_TmName2: WideString; safecall;
    procedure Set_TmName2(const Value: WideString); safecall;
    property PlanID: WideString read Get_PlanID write Set_PlanID;
    property TrainNo: WideString read Get_TrainNo write Set_TrainNo;
    property TrainNumber: WideString read Get_TrainNumber write Set_TrainNumber;
    property PlanTime: TDateTime read Get_PlanTime write Set_PlanTime;
    property TmNumber1: WideString read Get_TmNumber1 write Set_TmNumber1;
    property TmName1: WideString read Get_TmName1 write Set_TmName1;
    property TmNumber2: WideString read Get_TmNumber2 write Set_TmNumber2;
    property TmName2: WideString read Get_TmName2 write Set_TmName2;
  end;

// *********************************************************************//
// DispIntf:  IParamDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {DBC2F946-B2DB-4991-B29A-BC85212C3417}
// *********************************************************************//
  IParamDisp = dispinterface
    ['{DBC2F946-B2DB-4991-B29A-BC85212C3417}']
    property PlanID: WideString dispid 201;
    property TrainNo: WideString dispid 202;
    property TrainNumber: WideString dispid 203;
    property PlanTime: TDateTime dispid 204;
    property TmNumber1: WideString dispid 205;
    property TmName1: WideString dispid 206;
    property TmNumber2: WideString dispid 207;
    property TmName2: WideString dispid 208;
  end;

// *********************************************************************//
// The Class CoPubJs provides a Create and CreateRemote method to          
// create instances of the default interface IPubJs exposed by              
// the CoClass PubJs. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPubJs = class
    class function Create: IPubJs;
    class function CreateRemote(const MachineName: string): IPubJs;
  end;

implementation

uses ComObj;

class function CoPubJs.Create: IPubJs;
begin
  Result := CreateComObject(CLASS_PubJs) as IPubJs;
end;

class function CoPubJs.CreateRemote(const MachineName: string): IPubJs;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PubJs) as IPubJs;
end;

end.
