unit RsAlcoholLib_TLB;

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
// File generated on 2016-07-08 13:37:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\测酒COM模块\RsAlcoholLib.tlb (1)
// LIBID: {54844EF3-8796-4F65-BC2B-05D5B7C970E2}
// LCID: 0
// Helpfile: 
// HelpString: RsAlcoholLib Library
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
  RsAlcoholLibMajorVersion = 1;
  RsAlcoholLibMinorVersion = 0;

  LIBID_RsAlcoholLib: TGUID = '{54844EF3-8796-4F65-BC2B-05D5B7C970E2}';

  IID_IAlcoholOption: TGUID = '{0E4C9860-2001-4217-95F8-372259D05EE9}';
  CLASS_AlcoholOption: TGUID = '{085C9E72-CBF6-4387-9445-42E935DE6E46}';
  IID_IAlcoholUI: TGUID = '{17216A32-27AC-461F-A282-88FA863AA1A2}';
  CLASS_AlcoholUI: TGUID = '{B723A569-558D-41D2-8BDF-FC5417F2FB1F}';
  IID_IAlcoholResult: TGUID = '{637F4D91-ECB8-4220-9990-02C6DE119C09}';
  CLASS_AlcoholResult: TGUID = '{D7F5C005-4D21-4F5A-866E-2887DDE6D47C}';
  IID_IAlcoholCtl: TGUID = '{BF6175CD-3654-4577-82D8-EE11042217EE}';
  CLASS_AlcoholCtl: TGUID = '{DE61A092-8D51-43E0-A6E8-1A07198BD0C8}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TPositionOp
type
  TPositionOp = TOleEnum;
const
  ptNormal = $00000000;
  ptRightBottom = $00000001;

// Constants for enum TAlcoholMode
type
  TAlcoholMode = TOleEnum;
const
  amPC = $00000000;
  amZiZhu = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAlcoholOption = interface;
  IAlcoholOptionDisp = dispinterface;
  IAlcoholUI = interface;
  IAlcoholUIDisp = dispinterface;
  IAlcoholResult = interface;
  IAlcoholResultDisp = dispinterface;
  IAlcoholCtl = interface;
  IAlcoholCtlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  AlcoholOption = IAlcoholOption;
  AlcoholUI = IAlcoholUI;
  AlcoholResult = IAlcoholResult;
  AlcoholCtl = IAlcoholCtl;


// *********************************************************************//
// Interface: IAlcoholOption
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E4C9860-2001-4217-95F8-372259D05EE9}
// *********************************************************************//
  IAlcoholOption = interface(IDispatch)
    ['{0E4C9860-2001-4217-95F8-372259D05EE9}']
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function Get_LocalSound: WordBool; safecall;
    procedure Set_LocalSound(Value: WordBool); safecall;
    function Get_AppHandle: Integer; safecall;
    procedure Set_AppHandle(Value: Integer); safecall;
    property Position: Integer read Get_Position write Set_Position;
    property LocalSound: WordBool read Get_LocalSound write Set_LocalSound;
    property AppHandle: Integer read Get_AppHandle write Set_AppHandle;
  end;

// *********************************************************************//
// DispIntf:  IAlcoholOptionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0E4C9860-2001-4217-95F8-372259D05EE9}
// *********************************************************************//
  IAlcoholOptionDisp = dispinterface
    ['{0E4C9860-2001-4217-95F8-372259D05EE9}']
    property Position: Integer dispid 201;
    property LocalSound: WordBool dispid 202;
    property AppHandle: Integer dispid 203;
  end;

// *********************************************************************//
// Interface: IAlcoholUI
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {17216A32-27AC-461F-A282-88FA863AA1A2}
// *********************************************************************//
  IAlcoholUI = interface(IDispatch)
    ['{17216A32-27AC-461F-A282-88FA863AA1A2}']
    function Get_TrainmanNumber: WideString; safecall;
    procedure Set_TrainmanNumber(const Value: WideString); safecall;
    function Get_TrainmanName: WideString; safecall;
    procedure Set_TrainmanName(const Value: WideString); safecall;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_TrainTypeName: WideString; safecall;
    procedure Set_TrainTypeName(const Value: WideString); safecall;
    function Get_TrainNumber: WideString; safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    function Get_TestTime: TDateTime; safecall;
    procedure Set_TestTime(Value: TDateTime); safecall;
    function Get_Picture: OleVariant; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    property TrainmanNumber: WideString read Get_TrainmanNumber write Set_TrainmanNumber;
    property TrainmanName: WideString read Get_TrainmanName write Set_TrainmanName;
    property TrainNo: WideString read Get_TrainNo write Set_TrainNo;
    property TrainTypeName: WideString read Get_TrainTypeName write Set_TrainTypeName;
    property TrainNumber: WideString read Get_TrainNumber write Set_TrainNumber;
    property TestTime: TDateTime read Get_TestTime write Set_TestTime;
    property Picture: OleVariant read Get_Picture write Set_Picture;
  end;

// *********************************************************************//
// DispIntf:  IAlcoholUIDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {17216A32-27AC-461F-A282-88FA863AA1A2}
// *********************************************************************//
  IAlcoholUIDisp = dispinterface
    ['{17216A32-27AC-461F-A282-88FA863AA1A2}']
    property TrainmanNumber: WideString dispid 201;
    property TrainmanName: WideString dispid 202;
    property TrainNo: WideString dispid 203;
    property TrainTypeName: WideString dispid 204;
    property TrainNumber: WideString dispid 205;
    property TestTime: TDateTime dispid 206;
    property Picture: OleVariant dispid 207;
  end;

// *********************************************************************//
// Interface: IAlcoholResult
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {637F4D91-ECB8-4220-9990-02C6DE119C09}
// *********************************************************************//
  IAlcoholResult = interface(IDispatch)
    ['{637F4D91-ECB8-4220-9990-02C6DE119C09}']
    function Get_TestResult: Integer; safecall;
    procedure Set_TestResult(Value: Integer); safecall;
    function Get_Alcoholity: Integer; safecall;
    procedure Set_Alcoholity(Value: Integer); safecall;
    function Get_TestTime: TDateTime; safecall;
    procedure Set_TestTime(Value: TDateTime); safecall;
    function Get_Picture: OleVariant; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    property TestResult: Integer read Get_TestResult write Set_TestResult;
    property Alcoholity: Integer read Get_Alcoholity write Set_Alcoholity;
    property TestTime: TDateTime read Get_TestTime write Set_TestTime;
    property Picture: OleVariant read Get_Picture write Set_Picture;
  end;

// *********************************************************************//
// DispIntf:  IAlcoholResultDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {637F4D91-ECB8-4220-9990-02C6DE119C09}
// *********************************************************************//
  IAlcoholResultDisp = dispinterface
    ['{637F4D91-ECB8-4220-9990-02C6DE119C09}']
    property TestResult: Integer dispid 201;
    property Alcoholity: Integer dispid 202;
    property TestTime: TDateTime dispid 203;
    property Picture: OleVariant dispid 204;
  end;

// *********************************************************************//
// Interface: IAlcoholCtl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF6175CD-3654-4577-82D8-EE11042217EE}
// *********************************************************************//
  IAlcoholCtl = interface(IDispatch)
    ['{BF6175CD-3654-4577-82D8-EE11042217EE}']
    function Get_Option: IAlcoholOption; safecall;
    function Get_UI: IAlcoholUI; safecall;
    function Get_TestResult: IAlcoholResult; safecall;
    procedure StartTest; safecall;
    function Get_Camera: IDispatch; safecall;
    procedure Set_Camera(const Value: IDispatch); safecall;
    function Get_Mode: TAlcoholMode; safecall;
    procedure Set_Mode(Value: TAlcoholMode); safecall;
    property Option: IAlcoholOption read Get_Option;
    property UI: IAlcoholUI read Get_UI;
    property TestResult: IAlcoholResult read Get_TestResult;
    property Camera: IDispatch read Get_Camera write Set_Camera;
    property Mode: TAlcoholMode read Get_Mode write Set_Mode;
  end;

// *********************************************************************//
// DispIntf:  IAlcoholCtlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF6175CD-3654-4577-82D8-EE11042217EE}
// *********************************************************************//
  IAlcoholCtlDisp = dispinterface
    ['{BF6175CD-3654-4577-82D8-EE11042217EE}']
    property Option: IAlcoholOption readonly dispid 201;
    property UI: IAlcoholUI readonly dispid 202;
    property TestResult: IAlcoholResult readonly dispid 203;
    procedure StartTest; dispid 204;
    property Camera: IDispatch dispid 205;
    property Mode: TAlcoholMode dispid 206;
  end;

// *********************************************************************//
// The Class CoAlcoholOption provides a Create and CreateRemote method to          
// create instances of the default interface IAlcoholOption exposed by              
// the CoClass AlcoholOption. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAlcoholOption = class
    class function Create: IAlcoholOption;
    class function CreateRemote(const MachineName: string): IAlcoholOption;
  end;

// *********************************************************************//
// The Class CoAlcoholUI provides a Create and CreateRemote method to          
// create instances of the default interface IAlcoholUI exposed by              
// the CoClass AlcoholUI. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAlcoholUI = class
    class function Create: IAlcoholUI;
    class function CreateRemote(const MachineName: string): IAlcoholUI;
  end;

// *********************************************************************//
// The Class CoAlcoholResult provides a Create and CreateRemote method to          
// create instances of the default interface IAlcoholResult exposed by              
// the CoClass AlcoholResult. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAlcoholResult = class
    class function Create: IAlcoholResult;
    class function CreateRemote(const MachineName: string): IAlcoholResult;
  end;

// *********************************************************************//
// The Class CoAlcoholCtl provides a Create and CreateRemote method to          
// create instances of the default interface IAlcoholCtl exposed by              
// the CoClass AlcoholCtl. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoAlcoholCtl = class
    class function Create: IAlcoholCtl;
    class function CreateRemote(const MachineName: string): IAlcoholCtl;
  end;

implementation

uses ComObj;

class function CoAlcoholOption.Create: IAlcoholOption;
begin
  Result := CreateComObject(CLASS_AlcoholOption) as IAlcoholOption;
end;

class function CoAlcoholOption.CreateRemote(const MachineName: string): IAlcoholOption;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AlcoholOption) as IAlcoholOption;
end;

class function CoAlcoholUI.Create: IAlcoholUI;
begin
  Result := CreateComObject(CLASS_AlcoholUI) as IAlcoholUI;
end;

class function CoAlcoholUI.CreateRemote(const MachineName: string): IAlcoholUI;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AlcoholUI) as IAlcoholUI;
end;

class function CoAlcoholResult.Create: IAlcoholResult;
begin
  Result := CreateComObject(CLASS_AlcoholResult) as IAlcoholResult;
end;

class function CoAlcoholResult.CreateRemote(const MachineName: string): IAlcoholResult;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AlcoholResult) as IAlcoholResult;
end;

class function CoAlcoholCtl.Create: IAlcoholCtl;
begin
  Result := CreateComObject(CLASS_AlcoholCtl) as IAlcoholCtl;
end;

class function CoAlcoholCtl.CreateRemote(const MachineName: string): IAlcoholCtl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_AlcoholCtl) as IAlcoholCtl;
end;

end.
