unit RsMealTicket_TLB;

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
// File generated on 2016-11-18 12:42:49 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\工作\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\饭票\RsMealTicket.tlb (1)
// LIBID: {65A4B8C0-FA69-46F9-9E87-C02F4591DD73}
// LCID: 0
// Helpfile: 
// HelpString: RsMealTicket Library
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
  RsMealTicketMajorVersion = 1;
  RsMealTicketMinorVersion = 0;

  LIBID_RsMealTicket: TGUID = '{65A4B8C0-FA69-46F9-9E87-C02F4591DD73}';

  IID_ITicket: TGUID = '{162EDA7E-B750-448E-8B27-4CC52CF0B0AE}';
  CLASS_Ticket: TGUID = '{2EBC7D4E-3A99-457B-B489-0114D86CCD17}';
  IID_IConfig: TGUID = '{07AD5FB4-D053-48EB-9735-7D86FA6CD43A}';
  IID_IQuery: TGUID = '{47FD5363-07CF-4EF0-BE7C-E96EF33125B2}';
  IID_IGrp: TGUID = '{F2B88E39-A109-4D7C-969F-6AF5657A0508}';
  IID_ITm: TGUID = '{E280CA75-8996-4818-BD43-CB6FC3E72F58}';
  CLASS_Config: TGUID = '{0E84E512-EA5E-4017-8EA1-744E500D38B5}';
  CLASS_Query: TGUID = '{8277CC65-CB3C-44BE-8DF4-E6AA0082D745}';
  IID_IPlan: TGUID = '{C2AE1B0F-9782-461B-927C-24CE8B41B6C7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITicket = interface;
  ITicketDisp = dispinterface;
  IConfig = interface;
  IConfigDisp = dispinterface;
  IQuery = interface;
  IQueryDisp = dispinterface;
  IGrp = interface;
  IGrpDisp = dispinterface;
  ITm = interface;
  ITmDisp = dispinterface;
  IPlan = interface;
  IPlanDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Ticket = ITicket;
  Config = IConfig;
  Query = IQuery;


// *********************************************************************//
// Interface: ITicket
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {162EDA7E-B750-448E-8B27-4CC52CF0B0AE}
// *********************************************************************//
  ITicket = interface(IDispatch)
    ['{162EDA7E-B750-448E-8B27-4CC52CF0B0AE}']
    procedure AddByGrp(const Plan: IPlan; const Grp: IGrp); safecall;
    procedure AddByTm(const Plan: IPlan; const Tm: ITm); safecall;
    procedure DelByGrp(const Plan: IPlan; const Grp: IGrp); safecall;
    procedure DelByTm(const Plan: IPlan; const Tm: ITm); safecall;
    procedure SendDialog; safecall;
    function CreatePlan: IPlan; safecall;
    function CreateTm: ITm; safecall;
    function CreateGrp: IGrp; safecall;
  end;

// *********************************************************************//
// DispIntf:  ITicketDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {162EDA7E-B750-448E-8B27-4CC52CF0B0AE}
// *********************************************************************//
  ITicketDisp = dispinterface
    ['{162EDA7E-B750-448E-8B27-4CC52CF0B0AE}']
    procedure AddByGrp(const Plan: IPlan; const Grp: IGrp); dispid 201;
    procedure AddByTm(const Plan: IPlan; const Tm: ITm); dispid 202;
    procedure DelByGrp(const Plan: IPlan; const Grp: IGrp); dispid 203;
    procedure DelByTm(const Plan: IPlan; const Tm: ITm); dispid 204;
    procedure SendDialog; dispid 205;
    function CreatePlan: IPlan; dispid 206;
    function CreateTm: ITm; dispid 207;
    function CreateGrp: IGrp; dispid 208;
  end;

// *********************************************************************//
// Interface: IConfig
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07AD5FB4-D053-48EB-9735-7D86FA6CD43A}
// *********************************************************************//
  IConfig = interface(IDispatch)
    ['{07AD5FB4-D053-48EB-9735-7D86FA6CD43A}']
    procedure ServerCfg; safecall;
    procedure TicketCfg; safecall;
    procedure TicketRule; safecall;
  end;

// *********************************************************************//
// DispIntf:  IConfigDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {07AD5FB4-D053-48EB-9735-7D86FA6CD43A}
// *********************************************************************//
  IConfigDisp = dispinterface
    ['{07AD5FB4-D053-48EB-9735-7D86FA6CD43A}']
    procedure ServerCfg; dispid 201;
    procedure TicketCfg; dispid 202;
    procedure TicketRule; dispid 203;
  end;

// *********************************************************************//
// Interface: IQuery
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {47FD5363-07CF-4EF0-BE7C-E96EF33125B2}
// *********************************************************************//
  IQuery = interface(IDispatch)
    ['{47FD5363-07CF-4EF0-BE7C-E96EF33125B2}']
    procedure Ticket; safecall;
    procedure Log(EnableDel: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IQueryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {47FD5363-07CF-4EF0-BE7C-E96EF33125B2}
// *********************************************************************//
  IQueryDisp = dispinterface
    ['{47FD5363-07CF-4EF0-BE7C-E96EF33125B2}']
    procedure Ticket; dispid 201;
    procedure Log(EnableDel: WordBool); dispid 202;
  end;

// *********************************************************************//
// Interface: IGrp
// Flags:     (320) Dual OleAutomation
// GUID:      {F2B88E39-A109-4D7C-969F-6AF5657A0508}
// *********************************************************************//
  IGrp = interface(IUnknown)
    ['{F2B88E39-A109-4D7C-969F-6AF5657A0508}']
    function Get_Tm1: ITm; safecall;
    procedure Set_Tm1(const Value: ITm); safecall;
    function Get_Tm2: ITm; safecall;
    procedure Set_Tm2(const Value: ITm); safecall;
    function Get_Tm3: ITm; safecall;
    procedure Set_Tm3(const Value: ITm); safecall;
    function Get_Tm4: ITm; safecall;
    procedure Set_Tm4(const Value: ITm); safecall;
    function CreateTm: ITm; safecall;
    property Tm1: ITm read Get_Tm1 write Set_Tm1;
    property Tm2: ITm read Get_Tm2 write Set_Tm2;
    property Tm3: ITm read Get_Tm3 write Set_Tm3;
    property Tm4: ITm read Get_Tm4 write Set_Tm4;
  end;

// *********************************************************************//
// DispIntf:  IGrpDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {F2B88E39-A109-4D7C-969F-6AF5657A0508}
// *********************************************************************//
  IGrpDisp = dispinterface
    ['{F2B88E39-A109-4D7C-969F-6AF5657A0508}']
    property Tm1: ITm dispid 101;
    property Tm2: ITm dispid 102;
    property Tm3: ITm dispid 103;
    property Tm4: ITm dispid 104;
    function CreateTm: ITm; dispid 105;
  end;

// *********************************************************************//
// Interface: ITm
// Flags:     (320) Dual OleAutomation
// GUID:      {E280CA75-8996-4818-BD43-CB6FC3E72F58}
// *********************************************************************//
  ITm = interface(IUnknown)
    ['{E280CA75-8996-4818-BD43-CB6FC3E72F58}']
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
// DispIntf:  ITmDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {E280CA75-8996-4818-BD43-CB6FC3E72F58}
// *********************************************************************//
  ITmDisp = dispinterface
    ['{E280CA75-8996-4818-BD43-CB6FC3E72F58}']
    property ID: WideString dispid 201;
    property Number: WideString dispid 202;
    property Name: WideString dispid 203;
  end;

// *********************************************************************//
// Interface: IPlan
// Flags:     (320) Dual OleAutomation
// GUID:      {C2AE1B0F-9782-461B-927C-24CE8B41B6C7}
// *********************************************************************//
  IPlan = interface(IUnknown)
    ['{C2AE1B0F-9782-461B-927C-24CE8B41B6C7}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_GrpID: WideString; safecall;
    procedure Set_GrpID(const Value: WideString); safecall;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_Section: WideString; safecall;
    procedure Set_Section(const Value: WideString); safecall;
    function Get_Time: TDateTime; safecall;
    procedure Set_Time(Value: TDateTime); safecall;
    property ID: WideString read Get_ID write Set_ID;
    property GrpID: WideString read Get_GrpID write Set_GrpID;
    property TrainNo: WideString read Get_TrainNo write Set_TrainNo;
    property Section: WideString read Get_Section write Set_Section;
    property Time: TDateTime read Get_Time write Set_Time;
  end;

// *********************************************************************//
// DispIntf:  IPlanDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {C2AE1B0F-9782-461B-927C-24CE8B41B6C7}
// *********************************************************************//
  IPlanDisp = dispinterface
    ['{C2AE1B0F-9782-461B-927C-24CE8B41B6C7}']
    property ID: WideString dispid 201;
    property GrpID: WideString dispid 202;
    property TrainNo: WideString dispid 203;
    property Section: WideString dispid 204;
    property Time: TDateTime dispid 205;
  end;

// *********************************************************************//
// The Class CoTicket provides a Create and CreateRemote method to          
// create instances of the default interface ITicket exposed by              
// the CoClass Ticket. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTicket = class
    class function Create: ITicket;
    class function CreateRemote(const MachineName: string): ITicket;
  end;

// *********************************************************************//
// The Class CoConfig provides a Create and CreateRemote method to          
// create instances of the default interface IConfig exposed by              
// the CoClass Config. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoConfig = class
    class function Create: IConfig;
    class function CreateRemote(const MachineName: string): IConfig;
  end;

// *********************************************************************//
// The Class CoQuery provides a Create and CreateRemote method to          
// create instances of the default interface IQuery exposed by              
// the CoClass Query. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoQuery = class
    class function Create: IQuery;
    class function CreateRemote(const MachineName: string): IQuery;
  end;

implementation

uses ComObj;

class function CoTicket.Create: ITicket;
begin
  Result := CreateComObject(CLASS_Ticket) as ITicket;
end;

class function CoTicket.CreateRemote(const MachineName: string): ITicket;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Ticket) as ITicket;
end;

class function CoConfig.Create: IConfig;
begin
  Result := CreateComObject(CLASS_Config) as IConfig;
end;

class function CoConfig.CreateRemote(const MachineName: string): IConfig;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Config) as IConfig;
end;

class function CoQuery.Create: IQuery;
begin
  Result := CreateComObject(CLASS_Query) as IQuery;
end;

class function CoQuery.CreateRemote(const MachineName: string): IQuery;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Query) as IQuery;
end;

end.
