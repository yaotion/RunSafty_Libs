unit uLib_PubJsCtl;

interface
uses
  Classes,SysUtils,Windows,uRsLibUtils;

type
  IParam = interface
  ['{AB499F1E-EB0A-4116-A458-67786E9C952A}']
    procedure ClearTms();stdcall;
    procedure AddTM(tmid: WideString;tmName: WideString);stdcall;
    procedure ClearSections();stdcall;
    procedure AddSection(JWD,YYQD: integer);stdcall;

    procedure SetCC(CC: WideString);stdcall;
    procedure SetJCH(JCH: WideString);stdcall;
    procedure SetCQTime(cqTime: TDateTime);stdcall;
    function AsJson: WideString;stdcall;
  end;

  
  
  IPubJsCtl = interface
  ['{7C41BB8D-BD3F-48D2-95A0-FDF5F62E93D2}']
    function Print(): Boolean;stdcall;
    function GetParam(): IParam;stdcall;

    property Param: IParam read GetParam;
  end;

    
  
  CoPubJsCtl = class
  public
    class function DefaultIntf(): IPubJsCtl;
    class procedure FreeLib();
  end;  
implementation
var
  _HLib: Cardinal = 0;
  _DllPath : string = '';
{ CoHttpAPI }

class function CoPubJsCtl.DefaultIntf: IPubJsCtl;
var
  path : string;
begin
  path :=  ExtractFilePath(ParamStr(0)) + 'libs\';
  if _DllPath <> '' then
  begin
    path := _DllPath;
  end;
  Result := LoadPlugin(path + 'RsPubJsCtl.dll',IPubJsCtl,_HLib) as IPubJsCtl;
end;


class procedure CoPubJsCtl.FreeLib;
begin
  if _HLib <> 0 then
  begin
    UnloadPlugIn(_HLib);
    FreeLibrary(_HLib);
    _HLib := 0;
  end;
end;


initialization

finalization
  CoPubJsCtl.FreeLib;
end.
