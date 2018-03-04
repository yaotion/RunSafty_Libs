unit RsCameraLib_TLB;

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
// File generated on 2016-07-08 10:45:51 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\摄像头Com模块\RsCameraLib.tlb (1)
// LIBID: {6C56B478-87ED-4F3B-A9CE-3FBD0A427C18}
// LCID: 0
// Helpfile: 
// HelpString: RsCameraLib Library
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
  RsCameraLibMajorVersion = 1;
  RsCameraLibMinorVersion = 0;

  LIBID_RsCameraLib: TGUID = '{6C56B478-87ED-4F3B-A9CE-3FBD0A427C18}';

  IID_ICamera: TGUID = '{90B0AFC0-CB4A-4E64-BA67-7369941469D2}';
  CLASS_Camera: TGUID = '{CEACE42D-BFE3-4D38-B6A0-B48A928992EC}';
  IID_ImgReciever: TGUID = '{62081C01-EFBC-4544-B6F1-A95010885763}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICamera = interface;
  ICameraDisp = dispinterface;
  ImgReciever = interface;
  ImgRecieverDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Camera = ICamera;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: ICamera
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90B0AFC0-CB4A-4E64-BA67-7369941469D2}
// *********************************************************************//
  ICamera = interface(IDispatch)
    ['{90B0AFC0-CB4A-4E64-BA67-7369941469D2}']
    function Open: WordBool; safecall;
    procedure Close; safecall;
    function CaptureBitmap(var Stream: OleVariant): WordBool; safecall;
    function Get_ImgReciever: ImgReciever; safecall;
    procedure Set_ImgReciever(const Value: ImgReciever); safecall;
    function Get_CountFilters: Integer; safecall;
    function Get_Names(Index: Integer): WideString; safecall;
    procedure Refresh; safecall;
    function Get_CameraName: WideString; safecall;
    procedure Set_CameraName(const Value: WideString); safecall;
    function Get_CameraIndex: Integer; safecall;
    procedure Set_CameraIndex(Value: Integer); safecall;
    function Get_TargetHandle: Integer; safecall;
    procedure Set_TargetHandle(Value: Integer); safecall;
    property ImgReciever: ImgReciever read Get_ImgReciever write Set_ImgReciever;
    property CountFilters: Integer read Get_CountFilters;
    property Names[Index: Integer]: WideString read Get_Names;
    property CameraName: WideString read Get_CameraName write Set_CameraName;
    property CameraIndex: Integer read Get_CameraIndex write Set_CameraIndex;
    property TargetHandle: Integer read Get_TargetHandle write Set_TargetHandle;
  end;

// *********************************************************************//
// DispIntf:  ICameraDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {90B0AFC0-CB4A-4E64-BA67-7369941469D2}
// *********************************************************************//
  ICameraDisp = dispinterface
    ['{90B0AFC0-CB4A-4E64-BA67-7369941469D2}']
    function Open: WordBool; dispid 204;
    procedure Close; dispid 205;
    function CaptureBitmap(var Stream: OleVariant): WordBool; dispid 206;
    property ImgReciever: ImgReciever dispid 201;
    property CountFilters: Integer readonly dispid 203;
    property Names[Index: Integer]: WideString readonly dispid 207;
    procedure Refresh; dispid 208;
    property CameraName: WideString dispid 209;
    property CameraIndex: Integer dispid 210;
    property TargetHandle: Integer dispid 211;
  end;

// *********************************************************************//
// Interface: ImgReciever
// Flags:     (320) Dual OleAutomation
// GUID:      {62081C01-EFBC-4544-B6F1-A95010885763}
// *********************************************************************//
  ImgReciever = interface(IUnknown)
    ['{62081C01-EFBC-4544-B6F1-A95010885763}']
    procedure RecieveBMP(RecieveBMP: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  ImgRecieverDisp
// Flags:     (320) Dual OleAutomation
// GUID:      {62081C01-EFBC-4544-B6F1-A95010885763}
// *********************************************************************//
  ImgRecieverDisp = dispinterface
    ['{62081C01-EFBC-4544-B6F1-A95010885763}']
    procedure RecieveBMP(RecieveBMP: Integer); dispid 101;
  end;

// *********************************************************************//
// The Class CoCamera provides a Create and CreateRemote method to          
// create instances of the default interface ICamera exposed by              
// the CoClass Camera. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCamera = class
    class function Create: ICamera;
    class function CreateRemote(const MachineName: string): ICamera;
  end;

implementation

uses ComObj;

class function CoCamera.Create: ICamera;
begin
  Result := CreateComObject(CLASS_Camera) as ICamera;
end;

class function CoCamera.CreateRemote(const MachineName: string): ICamera;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Camera) as ICamera;
end;

end.
