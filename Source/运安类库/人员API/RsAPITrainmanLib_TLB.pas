unit RsAPITrainmanLib_TLB;

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
// File generated on 2016-11-09 13:00:57 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\姚新\畅想\代码\项目\机务运用安全管理系统\02_开发\01_源代码\基线源码\客户端通用动态库\Source\运安类库\人员API\RsAPITrainmanLib.tlb (1)
// LIBID: {0ED89F2E-DE70-4384-8D52-4E0D985C7462}
// LCID: 0
// Helpfile: 
// HelpString: RsAPITrainmanLib Library
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
  RsAPITrainmanLibMajorVersion = 1;
  RsAPITrainmanLibMinorVersion = 0;

  LIBID_RsAPITrainmanLib: TGUID = '{0ED89F2E-DE70-4384-8D52-4E0D985C7462}';

  IID_IRsAPITrainman: TGUID = '{3D3FB608-284B-4C58-A88E-3794E1C19569}';
  CLASS_RsAPITrainman: TGUID = '{E92DB9AC-6261-42B2-B382-12012B0E4125}';
  IID_IRsTrainman: TGUID = '{5F23CA9B-FD96-415B-AC49-1ACFCEC5A006}';
  CLASS_RsTrainman: TGUID = '{D0784DFD-6EF5-4A29-AB3A-734D22C0720C}';
  IID_IRsTrainmanArray: TGUID = '{8D57F0CA-FEB2-400B-B1A7-96A0C53C158E}';
  CLASS_RsTrainmanArray: TGUID = '{30C1683B-FBFB-4F8B-91A4-3BAC4ADF26ED}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TRsPost
type
  TRsPost = TOleEnum;
const
  ptNone = $00000000;
  ptTrainman = $00000001;
  ptSubTrainman = $00000002;
  ptLearning = $00000003;

// Constants for enum TRsDriverType
type
  TRsDriverType = TOleEnum;
const
  drtNone = $00000000;
  drtNeiran = $00000001;
  drtDian = $00000002;
  drtDong = $00000003;

// Constants for enum TRsCallWorkState
type
  TRsCallWorkState = TOleEnum;
const
  cwsNil = $00000000;
  cwsNotify = $00000001;
  cwsRecv = $00000002;
  cwsFinish = $00000003;

// Constants for enum TRsKehuo
type
  TRsKehuo = TOleEnum;
const
  khNone = $00000000;
  khHuo = $00000001;
  khDiao = $00000002;

// Constants for enum TRsTrainmanState
type
  TRsTrainmanState = TOleEnum;
const
  tsUnRuning = $00000000;
  tsReady = $00000001;
  tsNormal = $00000002;
  tsPlaning = $00000003;
  tsInRoom = $00000004;
  tsOutRoom = $00000005;
  tsRuning = $00000006;
  tsNil = $00000007;

// Constants for enum TFixedGroupType
type
  TFixedGroupType = TOleEnum;
const
  Fixed_None = $00000000;
  Fixed_Fix = $00000001;
  Fixed_UnFix = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsAPITrainman = interface;
  IRsAPITrainmanDisp = dispinterface;
  IRsTrainman = interface;
  IRsTrainmanDisp = dispinterface;
  IRsTrainmanArray = interface;
  IRsTrainmanArrayDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsAPITrainman = IRsAPITrainman;
  RsTrainman = IRsTrainman;
  RsTrainmanArray = IRsTrainmanArray;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  RRsQueryTrainman = packed record
    strTrainmanNumber: WideString;
    strTrainmanName: WideString;
    strAreaGUID: WideString;
    strWorkShopGUID: WideString;
    strTrainJiaoluGUID: WideString;
    strGuideGroupGUID: WideString;
    nFingerCount: Integer;
    nPhotoCount: Integer;
  end;


// *********************************************************************//
// Interface: IRsAPITrainman
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D3FB608-284B-4C58-A88E-3794E1C19569}
// *********************************************************************//
  IRsAPITrainman = interface(IDispatch)
    ['{3D3FB608-284B-4C58-A88E-3794E1C19569}']
    procedure QueryTrainmans_blobFlag(QueryTrainman: RRsQueryTrainman; PageIndex: Integer; 
                                      out TrainmanArray: IRsTrainmanArray; out nTotalCount: Integer); safecall;
    function Get_WebAPI: IDispatch; safecall;
    procedure Set_WebAPI(const Value: IDispatch); safecall;
    procedure DeleteTrainman(const TrainmanGUID: WideString); safecall;
    function GetTrainman(const TrainmanGUID: WideString; Option: Integer; out Trainman: IRsTrainman): WordBool; safecall;
    function GetTrainmanByNumber(const TrainmanNumber: WideString; Option: Integer; 
                                 var Trainman: IRsTrainman): WordBool; safecall;
    function ExistNumber(const TrainmanGUID: WideString; const TrainmanNumber: WideString): WordBool; safecall;
    procedure AddTrainman(const Trainman: IRsTrainman); safecall;
    procedure UpdateTrainmanTel(const TrainmanGUID: WideString; const TrainmanTel: WideString; 
                                const TrainmanMobile: WideString; 
                                const TrainmanAddress: WideString; const TrainmanBrief: WideString); safecall;
    function GetPopupTrainmans(const WorkShopGUID: WideString; const KeyName: WideString; 
                               PageIndex: Integer; out TrainmanArray: RsTrainmanArray): Integer; safecall;
    property WebAPI: IDispatch read Get_WebAPI write Set_WebAPI;
  end;

// *********************************************************************//
// DispIntf:  IRsAPITrainmanDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3D3FB608-284B-4C58-A88E-3794E1C19569}
// *********************************************************************//
  IRsAPITrainmanDisp = dispinterface
    ['{3D3FB608-284B-4C58-A88E-3794E1C19569}']
    procedure QueryTrainmans_blobFlag(QueryTrainman: {??RRsQueryTrainman}OleVariant; 
                                      PageIndex: Integer; out TrainmanArray: IRsTrainmanArray; 
                                      out nTotalCount: Integer); dispid 201;
    property WebAPI: IDispatch dispid 202;
    procedure DeleteTrainman(const TrainmanGUID: WideString); dispid 203;
    function GetTrainman(const TrainmanGUID: WideString; Option: Integer; out Trainman: IRsTrainman): WordBool; dispid 204;
    function GetTrainmanByNumber(const TrainmanNumber: WideString; Option: Integer; 
                                 var Trainman: IRsTrainman): WordBool; dispid 205;
    function ExistNumber(const TrainmanGUID: WideString; const TrainmanNumber: WideString): WordBool; dispid 206;
    procedure AddTrainman(const Trainman: IRsTrainman); dispid 207;
    procedure UpdateTrainmanTel(const TrainmanGUID: WideString; const TrainmanTel: WideString; 
                                const TrainmanMobile: WideString; 
                                const TrainmanAddress: WideString; const TrainmanBrief: WideString); dispid 208;
    function GetPopupTrainmans(const WorkShopGUID: WideString; const KeyName: WideString; 
                               PageIndex: Integer; out TrainmanArray: RsTrainmanArray): Integer; dispid 209;
  end;

// *********************************************************************//
// Interface: IRsTrainman
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5F23CA9B-FD96-415B-AC49-1ACFCEC5A006}
// *********************************************************************//
  IRsTrainman = interface(IDispatch)
    ['{5F23CA9B-FD96-415B-AC49-1ACFCEC5A006}']
    function Get_strTrainmanGUID: WideString; safecall;
    procedure Set_strTrainmanGUID(const Value: WideString); safecall;
    function Get_strTrainmanName: WideString; safecall;
    procedure Set_strTrainmanName(const Value: WideString); safecall;
    function Get_strTrainmanNumber: WideString; safecall;
    procedure Set_strTrainmanNumber(const Value: WideString); safecall;
    function Get_nPostID: TRsPost; safecall;
    procedure Set_nPostID(Value: TRsPost); safecall;
    function Get_strPostName: WideString; safecall;
    procedure Set_strPostName(const Value: WideString); safecall;
    function Get_strWorkShopGUID: WideString; safecall;
    procedure Set_strWorkShopGUID(const Value: WideString); safecall;
    function Get_strWorkShopName: WideString; safecall;
    procedure Set_strWorkShopName(const Value: WideString); safecall;
    function Get_FingerPrint1: OleVariant; safecall;
    procedure Set_FingerPrint1(Value: OleVariant); safecall;
    function Get_nFingerPrint1_Null: Integer; safecall;
    procedure Set_nFingerPrint1_Null(Value: Integer); safecall;
    function Get_FingerPrint2: OleVariant; safecall;
    procedure Set_FingerPrint2(Value: OleVariant); safecall;
    function Get_nFingerPrint2_Null: Integer; safecall;
    procedure Set_nFingerPrint2_Null(Value: Integer); safecall;
    function Get_Picture: OleVariant; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    function Get_nPicture_Null: Integer; safecall;
    procedure Set_nPicture_Null(Value: Integer); safecall;
    function Get_strGuideGroupGUID: WideString; safecall;
    procedure Set_strGuideGroupGUID(const Value: WideString); safecall;
    function Get_strGuideGroupName: WideString; safecall;
    procedure Set_strGuideGroupName(const Value: WideString); safecall;
    function Get_strTelNumber: WideString; safecall;
    procedure Set_strTelNumber(const Value: WideString); safecall;
    function Get_strMobileNumber: WideString; safecall;
    procedure Set_strMobileNumber(const Value: WideString); safecall;
    function Get_strAdddress: WideString; safecall;
    procedure Set_strAdddress(const Value: WideString); safecall;
    function Get_nDriverType: TRsDriverType; safecall;
    procedure Set_nDriverType(Value: TRsDriverType); safecall;
    function Get_strDriverTypeName: WideString; safecall;
    procedure Set_strDriverTypeName(const Value: WideString); safecall;
    function Get_nCallWorkState: TRsCallWorkState; safecall;
    procedure Set_nCallWorkState(Value: TRsCallWorkState); safecall;
    function Get_strCallWorkGUID: WideString; safecall;
    procedure Set_strCallWorkGUID(const Value: WideString); safecall;
    function Get_bIsKey: Integer; safecall;
    procedure Set_bIsKey(Value: Integer); safecall;
    function Get_dtRuZhiTime: TDateTime; safecall;
    procedure Set_dtRuZhiTime(Value: TDateTime); safecall;
    function Get_dtJiuZhiTime: TDateTime; safecall;
    procedure Set_dtJiuZhiTime(Value: TDateTime); safecall;
    function Get_nDriverLevel: Integer; safecall;
    procedure Set_nDriverLevel(Value: Integer); safecall;
    function Get_strABCD: WideString; safecall;
    procedure Set_strABCD(const Value: WideString); safecall;
    function Get_strRemark: WideString; safecall;
    procedure Set_strRemark(const Value: WideString); safecall;
    function Get_nKeHuoID: TRsDriverType; safecall;
    procedure Set_nKeHuoID(Value: TRsDriverType); safecall;
    function Get_strKeHuoName: WideString; safecall;
    procedure Set_strKeHuoName(const Value: WideString); safecall;
    function Get_strTrainJiaoluGUID: WideString; safecall;
    procedure Set_strTrainJiaoluGUID(const Value: WideString); safecall;
    function Get_strTrainmanJiaoluGUID: WideString; safecall;
    procedure Set_strTrainmanJiaoluGUID(const Value: WideString); safecall;
    function Get_strTrainJiaoluName: WideString; safecall;
    procedure Set_strTrainJiaoluName(const Value: WideString); safecall;
    function Get_dtLastEndworkTime: TDateTime; safecall;
    procedure Set_dtLastEndworkTime(Value: TDateTime); safecall;
    function Get_strAreaGUID: WideString; safecall;
    procedure Set_strAreaGUID(const Value: WideString); safecall;
    function Get_nID: Integer; safecall;
    procedure Set_nID(Value: Integer); safecall;
    function Get_dtCreateTime: TDateTime; safecall;
    procedure Set_dtCreateTime(Value: TDateTime); safecall;
    function Get_nTrainmanState: TRsTrainmanState; safecall;
    procedure Set_nTrainmanState(Value: TRsTrainmanState); safecall;
    function Get_strJP: WideString; safecall;
    procedure Set_strJP(const Value: WideString); safecall;
    function Get_dtLastInRoomTime: TDateTime; safecall;
    procedure Set_dtLastInRoomTime(Value: TDateTime); safecall;
    function Get_dtLastOutRoomTime: TDateTime; safecall;
    procedure Set_dtLastOutRoomTime(Value: TDateTime); safecall;
    function Get_strFixedGroupGUID: WideString; safecall;
    procedure Set_strFixedGroupGUID(const Value: WideString); safecall;
    function Get_nFixedGroupIndex: Integer; safecall;
    procedure Set_nFixedGroupIndex(Value: Integer); safecall;
    function Get_strFixedGroupName: WideString; safecall;
    procedure Set_strFixedGroupName(const Value: WideString); safecall;
    function Get_eFixGroupType: TFixedGroupType; safecall;
    procedure Set_eFixGroupType(Value: TFixedGroupType); safecall;
    procedure AssignTo(const Trainman: IRsTrainman); safecall;
    property strTrainmanGUID: WideString read Get_strTrainmanGUID write Set_strTrainmanGUID;
    property strTrainmanName: WideString read Get_strTrainmanName write Set_strTrainmanName;
    property strTrainmanNumber: WideString read Get_strTrainmanNumber write Set_strTrainmanNumber;
    property nPostID: TRsPost read Get_nPostID write Set_nPostID;
    property strPostName: WideString read Get_strPostName write Set_strPostName;
    property strWorkShopGUID: WideString read Get_strWorkShopGUID write Set_strWorkShopGUID;
    property strWorkShopName: WideString read Get_strWorkShopName write Set_strWorkShopName;
    property FingerPrint1: OleVariant read Get_FingerPrint1 write Set_FingerPrint1;
    property nFingerPrint1_Null: Integer read Get_nFingerPrint1_Null write Set_nFingerPrint1_Null;
    property FingerPrint2: OleVariant read Get_FingerPrint2 write Set_FingerPrint2;
    property nFingerPrint2_Null: Integer read Get_nFingerPrint2_Null write Set_nFingerPrint2_Null;
    property Picture: OleVariant read Get_Picture write Set_Picture;
    property nPicture_Null: Integer read Get_nPicture_Null write Set_nPicture_Null;
    property strGuideGroupGUID: WideString read Get_strGuideGroupGUID write Set_strGuideGroupGUID;
    property strGuideGroupName: WideString read Get_strGuideGroupName write Set_strGuideGroupName;
    property strTelNumber: WideString read Get_strTelNumber write Set_strTelNumber;
    property strMobileNumber: WideString read Get_strMobileNumber write Set_strMobileNumber;
    property strAdddress: WideString read Get_strAdddress write Set_strAdddress;
    property nDriverType: TRsDriverType read Get_nDriverType write Set_nDriverType;
    property strDriverTypeName: WideString read Get_strDriverTypeName write Set_strDriverTypeName;
    property nCallWorkState: TRsCallWorkState read Get_nCallWorkState write Set_nCallWorkState;
    property strCallWorkGUID: WideString read Get_strCallWorkGUID write Set_strCallWorkGUID;
    property bIsKey: Integer read Get_bIsKey write Set_bIsKey;
    property dtRuZhiTime: TDateTime read Get_dtRuZhiTime write Set_dtRuZhiTime;
    property dtJiuZhiTime: TDateTime read Get_dtJiuZhiTime write Set_dtJiuZhiTime;
    property nDriverLevel: Integer read Get_nDriverLevel write Set_nDriverLevel;
    property strABCD: WideString read Get_strABCD write Set_strABCD;
    property strRemark: WideString read Get_strRemark write Set_strRemark;
    property nKeHuoID: TRsDriverType read Get_nKeHuoID write Set_nKeHuoID;
    property strKeHuoName: WideString read Get_strKeHuoName write Set_strKeHuoName;
    property strTrainJiaoluGUID: WideString read Get_strTrainJiaoluGUID write Set_strTrainJiaoluGUID;
    property strTrainmanJiaoluGUID: WideString read Get_strTrainmanJiaoluGUID write Set_strTrainmanJiaoluGUID;
    property strTrainJiaoluName: WideString read Get_strTrainJiaoluName write Set_strTrainJiaoluName;
    property dtLastEndworkTime: TDateTime read Get_dtLastEndworkTime write Set_dtLastEndworkTime;
    property strAreaGUID: WideString read Get_strAreaGUID write Set_strAreaGUID;
    property nID: Integer read Get_nID write Set_nID;
    property dtCreateTime: TDateTime read Get_dtCreateTime write Set_dtCreateTime;
    property nTrainmanState: TRsTrainmanState read Get_nTrainmanState write Set_nTrainmanState;
    property strJP: WideString read Get_strJP write Set_strJP;
    property dtLastInRoomTime: TDateTime read Get_dtLastInRoomTime write Set_dtLastInRoomTime;
    property dtLastOutRoomTime: TDateTime read Get_dtLastOutRoomTime write Set_dtLastOutRoomTime;
    property strFixedGroupGUID: WideString read Get_strFixedGroupGUID write Set_strFixedGroupGUID;
    property nFixedGroupIndex: Integer read Get_nFixedGroupIndex write Set_nFixedGroupIndex;
    property strFixedGroupName: WideString read Get_strFixedGroupName write Set_strFixedGroupName;
    property eFixGroupType: TFixedGroupType read Get_eFixGroupType write Set_eFixGroupType;
  end;

// *********************************************************************//
// DispIntf:  IRsTrainmanDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5F23CA9B-FD96-415B-AC49-1ACFCEC5A006}
// *********************************************************************//
  IRsTrainmanDisp = dispinterface
    ['{5F23CA9B-FD96-415B-AC49-1ACFCEC5A006}']
    property strTrainmanGUID: WideString dispid 201;
    property strTrainmanName: WideString dispid 202;
    property strTrainmanNumber: WideString dispid 203;
    property nPostID: TRsPost dispid 204;
    property strPostName: WideString dispid 205;
    property strWorkShopGUID: WideString dispid 206;
    property strWorkShopName: WideString dispid 207;
    property FingerPrint1: OleVariant dispid 208;
    property nFingerPrint1_Null: Integer dispid 209;
    property FingerPrint2: OleVariant dispid 210;
    property nFingerPrint2_Null: Integer dispid 211;
    property Picture: OleVariant dispid 212;
    property nPicture_Null: Integer dispid 213;
    property strGuideGroupGUID: WideString dispid 214;
    property strGuideGroupName: WideString dispid 215;
    property strTelNumber: WideString dispid 216;
    property strMobileNumber: WideString dispid 217;
    property strAdddress: WideString dispid 218;
    property nDriverType: TRsDriverType dispid 219;
    property strDriverTypeName: WideString dispid 220;
    property nCallWorkState: TRsCallWorkState dispid 221;
    property strCallWorkGUID: WideString dispid 222;
    property bIsKey: Integer dispid 223;
    property dtRuZhiTime: TDateTime dispid 224;
    property dtJiuZhiTime: TDateTime dispid 225;
    property nDriverLevel: Integer dispid 226;
    property strABCD: WideString dispid 227;
    property strRemark: WideString dispid 228;
    property nKeHuoID: TRsDriverType dispid 229;
    property strKeHuoName: WideString dispid 230;
    property strTrainJiaoluGUID: WideString dispid 231;
    property strTrainmanJiaoluGUID: WideString dispid 232;
    property strTrainJiaoluName: WideString dispid 233;
    property dtLastEndworkTime: TDateTime dispid 234;
    property strAreaGUID: WideString dispid 235;
    property nID: Integer dispid 236;
    property dtCreateTime: TDateTime dispid 237;
    property nTrainmanState: TRsTrainmanState dispid 238;
    property strJP: WideString dispid 239;
    property dtLastInRoomTime: TDateTime dispid 240;
    property dtLastOutRoomTime: TDateTime dispid 241;
    property strFixedGroupGUID: WideString dispid 242;
    property nFixedGroupIndex: Integer dispid 243;
    property strFixedGroupName: WideString dispid 244;
    property eFixGroupType: TFixedGroupType dispid 245;
    procedure AssignTo(const Trainman: IRsTrainman); dispid 246;
  end;

// *********************************************************************//
// Interface: IRsTrainmanArray
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D57F0CA-FEB2-400B-B1A7-96A0C53C158E}
// *********************************************************************//
  IRsTrainmanArray = interface(IDispatch)
    ['{8D57F0CA-FEB2-400B-B1A7-96A0C53C158E}']
    procedure Add(const Trainman: IRsTrainman); safecall;
    function Get_Count: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure GetItem(Index: Integer; out Result: IRsTrainman); safecall;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IRsTrainmanArrayDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D57F0CA-FEB2-400B-B1A7-96A0C53C158E}
// *********************************************************************//
  IRsTrainmanArrayDisp = dispinterface
    ['{8D57F0CA-FEB2-400B-B1A7-96A0C53C158E}']
    procedure Add(const Trainman: IRsTrainman); dispid 201;
    property Count: Integer readonly dispid 202;
    procedure Delete(Index: Integer); dispid 203;
    procedure GetItem(Index: Integer; out Result: IRsTrainman); dispid 204;
  end;

// *********************************************************************//
// The Class CoRsAPITrainman provides a Create and CreateRemote method to          
// create instances of the default interface IRsAPITrainman exposed by              
// the CoClass RsAPITrainman. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsAPITrainman = class
    class function Create: IRsAPITrainman;
    class function CreateRemote(const MachineName: string): IRsAPITrainman;
  end;

// *********************************************************************//
// The Class CoRsTrainman provides a Create and CreateRemote method to          
// create instances of the default interface IRsTrainman exposed by              
// the CoClass RsTrainman. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsTrainman = class
    class function Create: IRsTrainman;
    class function CreateRemote(const MachineName: string): IRsTrainman;
  end;

// *********************************************************************//
// The Class CoRsTrainmanArray provides a Create and CreateRemote method to          
// create instances of the default interface IRsTrainmanArray exposed by              
// the CoClass RsTrainmanArray. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsTrainmanArray = class
    class function Create: IRsTrainmanArray;
    class function CreateRemote(const MachineName: string): IRsTrainmanArray;
  end;

implementation

uses ComObj;

class function CoRsAPITrainman.Create: IRsAPITrainman;
begin
  Result := CreateComObject(CLASS_RsAPITrainman) as IRsAPITrainman;
end;

class function CoRsAPITrainman.CreateRemote(const MachineName: string): IRsAPITrainman;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsAPITrainman) as IRsAPITrainman;
end;

class function CoRsTrainman.Create: IRsTrainman;
begin
  Result := CreateComObject(CLASS_RsTrainman) as IRsTrainman;
end;

class function CoRsTrainman.CreateRemote(const MachineName: string): IRsTrainman;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsTrainman) as IRsTrainman;
end;

class function CoRsTrainmanArray.Create: IRsTrainmanArray;
begin
  Result := CreateComObject(CLASS_RsTrainmanArray) as IRsTrainmanArray;
end;

class function CoRsTrainmanArray.CreateRemote(const MachineName: string): IRsTrainmanArray;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsTrainmanArray) as IRsTrainmanArray;
end;

end.
