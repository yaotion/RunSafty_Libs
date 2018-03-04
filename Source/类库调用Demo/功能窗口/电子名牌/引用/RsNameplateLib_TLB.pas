unit RsNameplateLib_TLB;

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
// File generated on 2017-03-10 13:34:53 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\����\�������ð�ȫ����ϵͳ\02_����\01_Դ����\����Դ��\�ͻ���ͨ�ö�̬��\Source\��������\RsNameplateLib.tlb (1)
// LIBID: {2C54041B-79D6-441A-AFE0-C2A84D49989A}
// LCID: 0
// Helpfile: 
// HelpString: RsNameplateLib Library
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
  RsNameplateLibMajorVersion = 1;
  RsNameplateLibMinorVersion = 0;

  LIBID_RsNameplateLib: TGUID = '{2C54041B-79D6-441A-AFE0-C2A84D49989A}';

  IID_IRsNameplate: TGUID = '{3944950A-DAD5-47CA-AAB1-C53F5EE5B11B}';
  CLASS_RsNameplate: TGUID = '{CF6685A5-8242-4105-B3C3-5418B4F549F7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRsNameplate = interface;
  IRsNameplateDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RsNameplate = IRsNameplate;


// *********************************************************************//
// Interface: IRsNameplate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3944950A-DAD5-47CA-AAB1-C53F5EE5B11B}
// *********************************************************************//
  IRsNameplate = interface(IDispatch)
    ['{3944950A-DAD5-47CA-AAB1-C53F5EE5B11B}']
    procedure ShowNameplate(EditEnable: WordBool; CanDel: WordBool); safecall;
  end;

// *********************************************************************//
// DispIntf:  IRsNameplateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3944950A-DAD5-47CA-AAB1-C53F5EE5B11B}
// *********************************************************************//
  IRsNameplateDisp = dispinterface
    ['{3944950A-DAD5-47CA-AAB1-C53F5EE5B11B}']
    procedure ShowNameplate(EditEnable: WordBool; CanDel: WordBool); dispid 202;
  end;

// *********************************************************************//
// The Class CoRsNameplate provides a Create and CreateRemote method to          
// create instances of the default interface IRsNameplate exposed by              
// the CoClass RsNameplate. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRsNameplate = class
    class function Create: IRsNameplate;
    class function CreateRemote(const MachineName: string): IRsNameplate;
  end;

implementation

uses ComObj;

class function CoRsNameplate.Create: IRsNameplate;
begin
  Result := CreateComObject(CLASS_RsNameplate) as IRsNameplate;
end;

class function CoRsNameplate.CreateRemote(const MachineName: string): IRsNameplate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RsNameplate) as IRsNameplate;
end;

end.
