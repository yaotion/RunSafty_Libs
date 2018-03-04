unit RsBDPrint_TLB;

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
// File generated on 2016-11-18 14:23:55 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\报单\RsBDPrint.tlb (1)
// LIBID: {1B3C42C5-A1FA-48EE-B296-08E2AF2009E9}
// LCID: 0
// Helpfile: 
// HelpString: RsBDPrint Library
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
  RsBDPrintMajorVersion = 1;
  RsBDPrintMinorVersion = 0;

  LIBID_RsBDPrint: TGUID = '{1B3C42C5-A1FA-48EE-B296-08E2AF2009E9}';

  IID_IBDPrint: TGUID = '{0499FBB7-CD3F-4288-908E-8E4EA314F48C}';
  CLASS_BDPrint: TGUID = '{633D6E73-1F95-40E8-9933-202B6208A9C8}';
  IID_IParam: TGUID = '{EE14EB17-5586-4BE4-918C-048CE7643885}';
  IID_IGrp: TGUID = '{1E559A51-2F1D-4F73-8E16-64A14412AC7A}';
  IID_ITm: TGUID = '{9E688733-2F84-471A-A64B-F428C6DD87F7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IBDPrint = interface;
  IBDPrintDisp = dispinterface;
  IParam = interface;
  IParamDisp = dispinterface;
  IGrp = interface;
  IGrpDisp = dispinterface;
  ITm = interface;
  ITmDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  BDPrint = IBDPrint;


// *********************************************************************//
// Interface: IBDPrint
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0499FBB7-CD3F-4288-908E-8E4EA314F48C}
// *********************************************************************//
  IBDPrint = interface(IDispatch)
    ['{0499FBB7-CD3F-4288-908E-8E4EA314F48C}']
    procedure Print(const Param: IParam); safecall;
    procedure PrintNoPlan; safecall;
    function CreateParam: IParam; safecall;
    procedure ConfigDialog; safecall;
  end;

// *********************************************************************//
// DispIntf:  IBDPrintDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0499FBB7-CD3F-4288-908E-8E4EA314F48C}
// *********************************************************************//
  IBDPrintDisp = dispinterface
    ['{0499FBB7-CD3F-4288-908E-8E4EA314F48C}']
    procedure Print(const Param: IParam); dispid 201;
    procedure PrintNoPlan; dispid 202;
    function CreateParam: IParam; dispid 203;
    procedure ConfigDialog; dispid 204;
  end;

// *********************************************************************//
// Interface: IParam
// Flags:     (320) Dual OleAutomation
// GUID:      {EE14EB17-5586-4BE4-918C-048CE7643885}
// *********************************************************************//
  IParam = interface(IUnknown)
    ['{EE14EB17-5586-4BE4-918C-048CE7643885}']
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_TrainNumber: WideString; safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    function Get_TrainTypeName: WideString; safecall;
    procedure Set_TrainTypeName(const Value: WideString); safecall;
    function Get_RemarkType: Integer; safecall;
    procedure Set_RemarkType(Value: Integer); safecall;
    function Get_PlanTime: TDateTime; safecall;
    procedure Set_PlanTime(Value: TDateTime); safecall;
    function Get_Grp: IGrp; safecall;
    property TrainNo: WideString read Get_TrainNo write Set_TrainNo;
    property TrainNumber: WideString read Get_TrainNumber write Set_TrainNumber;
    property TrainTypeName: WideString read Get_TrainTypeName write Set_TrainTypeName;
    property RemarkType: Integer read Get_RemarkType write Set_RemarkType;
    property PlanTime: TDateTime read Get_PlanTime write Set_PlanTime;
    property Grp: IGrp read Get_Grp;
  end;

// *********************************************************************//
// DispIntf:  IParamDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {EE14EB17-5586-4BE4-918C-048CE7643885}
// *********************************************************************//
  IParamDisp = dispinterface
    ['{EE14EB17-5586-4BE4-918C-048CE7643885}']
    property TrainNo: WideString dispid 101;
    property TrainNumber: WideString dispid 102;
    property TrainTypeName: WideString dispid 103;
    property RemarkType: Integer dispid 104;
    property PlanTime: TDateTime dispid 105;
    property Grp: IGrp readonly dispid 107;
  end;

// *********************************************************************//
// Interface: IGrp
// Flags:     (320) Dual OleAutomation
// GUID:      {1E559A51-2F1D-4F73-8E16-64A14412AC7A}
// *********************************************************************//
  IGrp = interface(IUnknown)
    ['{1E559A51-2F1D-4F73-8E16-64A14412AC7A}']
    function CreateTM: ITm; safecall;
    function Get_Tm1: ITm; safecall;
    procedure Set_Tm1(const Value: ITm); safecall;
    function Get_Tm2: ITm; safecall;
    procedure Set_Tm2(const Value: ITm); safecall;
    function Get_Tm3: ITm; safecall;
    procedure Set_Tm3(const Value: ITm); safecall;
    function Get_Tm4: ITm; safecall;
    procedure Set_Tm4(const Value: ITm); safecall;
    property Tm1: ITm read Get_Tm1 write Set_Tm1;
    property Tm2: ITm read Get_Tm2 write Set_Tm2;
    property Tm3: ITm read Get_Tm3 write Set_Tm3;
    property Tm4: ITm read Get_Tm4 write Set_Tm4;
  end;

// *********************************************************************//
// DispIntf:  IGrpDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {1E559A51-2F1D-4F73-8E16-64A14412AC7A}
// *********************************************************************//
  IGrpDisp = dispinterface
    ['{1E559A51-2F1D-4F73-8E16-64A14412AC7A}']
    function CreateTM: ITm; dispid 101;
    property Tm1: ITm dispid 102;
    property Tm2: ITm dispid 103;
    property Tm3: ITm dispid 104;
    property Tm4: ITm dispid 105;
  end;

// *********************************************************************//
// Interface: ITm
// Flags:     (320) Dual OleAutomation
// GUID:      {9E688733-2F84-471A-A64B-F428C6DD87F7}
// *********************************************************************//
  ITm = interface(IUnknown)
    ['{9E688733-2F84-471A-A64B-F428C6DD87F7}']
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    property Number: WideString read Get_Number write Set_Number;
    property Name: WideString read Get_Name write Set_Name;
    property ID: WideString read Get_ID write Set_ID;
  end;

// *********************************************************************//
// DispIntf:  ITmDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {9E688733-2F84-471A-A64B-F428C6DD87F7}
// *********************************************************************//
  ITmDisp = dispinterface
    ['{9E688733-2F84-471A-A64B-F428C6DD87F7}']
    property Number: WideString dispid 101;
    property Name: WideString dispid 102;
    property ID: WideString dispid 103;
  end;

// *********************************************************************//
// The Class CoBDPrint provides a Create and CreateRemote method to          
// create instances of the default interface IBDPrint exposed by              
// the CoClass BDPrint. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBDPrint = class
    class function Create: IBDPrint;
    class function CreateRemote(const MachineName: string): IBDPrint;
  end;

implementation

uses ComObj;

class function CoBDPrint.Create: IBDPrint;
begin
  Result := CreateComObject(CLASS_BDPrint) as IBDPrint;
end;

class function CoBDPrint.CreateRemote(const MachineName: string): IBDPrint;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BDPrint) as IBDPrint;
end;

end.
