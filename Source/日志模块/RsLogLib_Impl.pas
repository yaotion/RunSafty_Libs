unit RsLogLib_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX,AxCtrls, RsLogLib_TLB, StdVcl,Classes,SysUtils,Windows,inifiles,
  IdBaseComponent, IdComponent,IdUDPBase, IdUDPClient, IdUDPServer,
  Dialogs;

type
  TRsLog = class(TAutoObject, IRsLog,IConnectionPointContainer)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: ILogEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    destructor Destroy();override;
  private
    //配置类
    m_LogConfig: ILogConfig;
    m_IdUDPClient: TIdUDPClient;
    {互斥对象}
    m_CriticalSection : TRTLCriticalSection;
    //应用程序根路径
    m_AppPath: string;
    m_LastLoadTick: Cardinal;

    procedure RefreshConfig();
    
    //生成日志文件名称
    function CreateFileName: string;
    //
    function CreateLog(log: string): string;
    //创建日志说明信息
    function CreateTitle(logLevel: TLogLevel;catalog: string): string;
     {功能:插入日志}
    procedure InsertLog(const FileName: string;const title: string;const log : String);
  protected
     { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
  protected
    procedure WriteDebug(const Log, Catalog: WideString); safecall;
    procedure WriteError(const Log, Catalog: WideString); safecall;
    procedure WriteInfo(const Log, Catalog: WideString); safecall;
    function OnLogout(const Title, Log: WideString): HResult; stdcall;
  public
    procedure Initialize; override;
    { TODO: Change all instances of type [ILogEvent] to [ILogEvents].}
 { Delphi was not able to update this file to reflect
   The change of the name of your event interface
   because of the presence of instance variables. 
   The type library was updated but you must update 
   this implementation file by hand. }
end;
  TRsLogConfig  = class(TAutoObject, ILogConfig)
  private
    m_Path: string;
    m_EnableDebug: Boolean;
    m_EnableInfo: Boolean;
    m_EnableError: Boolean;
    m_UDPPort: integer;
    m_EnableUDP: Boolean;
    m_ConfigFile: string;
  public
    procedure Initialize; override;  
  public
    procedure SaveToFile(const FileName: WideString); safecall;
    procedure LoadFromFile(const FileName: WideString); safecall;
    procedure Reload; safecall;
    procedure Save; safecall;
    procedure ShowConfigForm(AppHandle: Integer; ParentHandle: Integer); safecall;
    function Get_Path: WideString; safecall;
    procedure Set_Path(const Value: WideString); safecall;
    function Get_EnableInfo: WordBool; safecall;
    procedure Set_EnableInfo(Value: WordBool); safecall;
    function Get_EnableDebug: WordBool; safecall;
    procedure Set_EnableDebug(Value: WordBool); safecall;
    function Get_EnableError: WordBool; safecall;
    procedure Set_EnableError(Value: WordBool); safecall;
    function Get_UDPPort: Integer; safecall;
    procedure Set_UDPPort(Value: Integer); safecall;
    function Get_EnableUDP: WordBool; safecall;
    procedure Set_EnableUDP(Value: WordBool); safecall;
    property Path: WideString read Get_Path write Set_Path;
    property EnableInfo: WordBool read Get_EnableInfo write Set_EnableInfo;
    property EnableDebug: WordBool read Get_EnableDebug write Set_EnableDebug;
    property EnableError: WordBool read Get_EnableError write Set_EnableError;
    property UDPPort: Integer read Get_UDPPort write Set_UDPPort;
    property EnableUDP: WordBool read Get_EnableUDP write Set_EnableUDP;
  end;
implementation

uses ComServ,uRsfrmLogLibConfig;

function AddDirSuffix(const Dir: string): string;
{功能:目录尾加'\'修正}
begin
  Result := Trim(Dir);
  if Result = '' then Exit;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF};
end;

procedure TRsLog.WriteDebug(const Log, Catalog: WideString);
begin
  if m_LogConfig <> nil then
  begin
    if m_LogConfig.EnableDebug then
    begin
      InsertLog(CreateFileName(),CreateTitle(llDebug,catalog),CreateLog(log));
    end;
  end;
end;

procedure TRsLog.WriteError(const Log, Catalog: WideString);
begin
  if m_LogConfig <> nil then
  begin
    if m_LogConfig.EnableError then
    begin
      InsertLog(CreateFileName(),CreateTitle(llError,catalog),CreateLog(log));
    end;
  end;
end;

procedure TRsLog.WriteInfo(const Log, Catalog: WideString);
begin
  if m_LogConfig <> nil then
  begin
    if m_LogConfig.EnableInfo then
    begin
      InsertLog(CreateFileName(),CreateTitle(llInfo,catalog),CreateLog(log));
    end;
  end;
end;


function TRsLog.CreateFileName: string;
begin
  Result := m_AppPath + m_LogConfig.Path + FormatDateTime('yyyy-mm-dd',Now) + '.log';
  if not DirectoryExists(m_AppPath + m_LogConfig.Path) then
    ForceDirectories(m_AppPath + m_LogConfig.Path);
end;

function TRsLog.CreateLog(log: string): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss',Now) + ':' + log;
end;

function TRsLog.CreateTitle(logLevel: TLogLevel; catalog: string): string;
begin  
  case logLevel of
    llInfo: Result := '[info]';
    llDebug: Result := '[debug]';
    llError: Result := '[error]';
  else
    Result := '[ErrorLevel]';
  end;

  if (catalog <> '') then
  begin
    Result := Result + '[' + catalog + ']';
  end;
end;

destructor TRsLog.Destroy;
begin
  m_IdUDPClient.Free;
  m_LogConfig := nil;
  DeleteCriticalSection(m_CriticalSection);
  inherited;
end;

procedure TRsLog.EventSinkChanged(const EventSink: IInterface);
begin
  inherited;
  FEvents := EventSink as ILogEvents;
end;

procedure TRsLog.Initialize;
var
  hr : Cardinal;
  Factory: IClassFactory;
  tmpIt : IUnknown;
begin
  inherited;
  //事件
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
  //事件
  InitializeCriticalSection(m_CriticalSection);

  hr := DllGetClassObject(CLASS_RsLogConfig, IClassFactory, Factory);
  if hr = S_OK then
  try
    hr := Factory.CreateInstance(nil, IUnknown, tmpIt);
    if hr<> S_OK then begin
      raise exception.Create('创建对象失败：' + Inttostr(hr));
    end;
  except on e :Exception do
    begin
      raise exception.Create('创建对象异常：' + IntToStr(GetLastError));
    end;
  end;
  m_LogConfig :=  tmpIt as ILogConfig;  
  //m_LogConfig := CoRsLogConfig.Create;
  m_AppPath := ExtractFilePath(ParamStr(0));
  m_LogConfig.LoadFromFile(m_AppPath + 'Log.ini');
  m_LastLoadTick := GetTickCount;
  m_IdUDPClient:= TIdUDPClient.Create(nil);
end;

procedure TRsLog.InsertLog(const FileName, title, log: String);
var
  LogStream: TFileStream;
  procedure CheckNewFile();
  begin
    if not DirectoryExists(ExtractFilePath(FileName)) then
    begin
      ForceDirectories(ExtractFilePath(FileName));
    end;
    
    if not FileExists(FileName) then
    begin
      with TFileStream.Create(FileName,fmCreate) do
      begin
        Free;
      end;

    end;
  end;

  procedure DealWithException(E: Exception);
  var
    tmp: string;
  begin
    try
      tmp := ExtractFilePath(ParamStr(0)) + 'log_error.log';
      if not FileExists(tmp) then
      begin
        with TFileStream.Create(FileName,fmCreate) do
        begin
          Free;
        end;

      end;
      with TFileStream.Create(tmp, fmOpenWrite or fmShareDenyNone) do
      begin
        Position := Size;
        tmp := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' ' +  E.Message +  #13#10;
        Write(tmp[1],Length(tmp));
        Free;
      end;
    except
    end;
  end;

begin
  EnterCriticalSection(m_CriticalSection);
  try
    try
      RefreshConfig();
      
      CheckNewFile();
      LogStream := TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
      try
        LogStream.Position := LogStream.Size;
        LogStream.Write(title[1],Length(title));
        LogStream.Write(#13#10,2);
        LogStream.Write(log[1],Length(log));
        LogStream.Write(#13#10,2);

      finally
        LogStream.Free;
      end;

    except
      on E: Exception do
      begin
        DealWithException(E);
      end;
    end;

    if Assigned(FEvents) then
    begin
      try
        FEvents.OnLogout(PAnsiChar(title),PAnsiChar(log));
      except
      end;
    end;
    if m_LogConfig.EnableUDP then
    begin
      m_IdUDPClient.Send('127.0.0.1',m_LogConfig.UDPPort,title);
      m_IdUDPClient.Send('127.0.0.1',m_LogConfig.UDPPort,log);
    end;
     
  finally
    LeaveCriticalSection(m_CriticalSection);
  end;
end;

procedure TRsLog.RefreshConfig;
begin
  //最多5秒更新一次
  if GetTickCount - m_LastLoadTick > 5 * 1000 then
  begin
    m_LastLoadTick := GetTickCount;
    m_LogConfig.Reload();
  end;
end;


{ TRsLogConfig }

function TRsLogConfig.Get_EnableDebug: WordBool;
begin
  result := m_EnableInfo;
end;

function TRsLogConfig.Get_EnableError: WordBool;
begin
  result := m_EnableError;
end;

function TRsLogConfig.Get_EnableInfo: WordBool;
begin
  result := m_EnableInfo;
end;

function TRsLogConfig.Get_EnableUDP: WordBool;
begin
  Result := m_EnableUDP;
end;

function TRsLogConfig.Get_Path: WideString;
begin
  result := m_Path;
end;

function TRsLogConfig.Get_UDPPort: Integer;
begin
  result := m_UDPPort;
end;

procedure TRsLogConfig.Initialize;
begin
  inherited;
  m_Path := 'log\';
  EnableInfo := True;
  EnableDebug := False;
  EnableError := True;
end;

procedure TRsLogConfig.LoadFromFile(const FileName: WideString);
var
  IniFile: TIniFile;
begin
  m_ConfigFile := FileName;
  if FileExists(FileName) then
  begin
    IniFile := TIniFile.Create(FileName);
    try
      m_Path := AddDirSuffix(IniFile.ReadString('LogCfg','RelativePath','log\'));
      EnableInfo := IniFile.ReadBool('LogCfg','EnableInfo',True);
      EnableDebug := IniFile.ReadBool('LogCfg','EnableDebug',False);
      EnableError := IniFile.ReadBool('LogCfg','EnableError',True);
      EnableUDP := IniFile.ReadBool('LogCfg','EnableUDP',False);
      UDPPort := IniFile.ReadInteger('LogCfg','UDPPort',2320);
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TRsLogConfig.Reload;
var
  IniFile: TIniFile;
begin
  if FileExists(m_ConfigFile) then
  begin
    IniFile := TIniFile.Create(m_ConfigFile);
    try
      m_Path := AddDirSuffix(IniFile.ReadString('LogCfg','RelativePath','log\'));
      EnableInfo := IniFile.ReadBool('LogCfg','EnableInfo',True);
      EnableDebug := IniFile.ReadBool('LogCfg','EnableDebug',False);
      EnableError := IniFile.ReadBool('LogCfg','EnableError',True);
      EnableUDP := IniFile.ReadBool('LogCfg','EnableUDP',False);
      UDPPort := IniFile.ReadInteger('LogCfg','UDPPort',2320);
    finally
      IniFile.Free;
    end;
  end;

end;

procedure TRsLogConfig.Save;
begin
   if m_ConfigFile = '' then
    Raise Exception.Create('没有指定文件名');
  SaveToFile(m_ConfigFile);
end;

procedure TRsLogConfig.SaveToFile(const FileName: WideString);
var
  IniFile: TIniFile;
begin
  m_ConfigFile := FileName;
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.WriteString('LogCfg','RelativePath',Path);

    IniFile.WriteBool('LogCfg','EnableInfo',EnableInfo);
    IniFile.WriteBool('LogCfg','EnableDebug',EnableDebug);
    IniFile.WriteBool('LogCfg','EnableError',EnableError);
    IniFile.WriteBool('LogCfg','EnableUDP',EnableUDP);
    IniFile.WriteInteger('LogCfg','UDPPort',UDPPort);
  finally
    IniFile.Free;
  end;
end;

procedure TRsLogConfig.Set_EnableDebug(Value: WordBool);
begin
  m_EnableDebug := Value;
end;

procedure TRsLogConfig.Set_EnableError(Value: WordBool);
begin
  m_EnableError := Value;
end;

procedure TRsLogConfig.Set_EnableInfo(Value: WordBool);
begin
  m_EnableInfo := Value;
end;

procedure TRsLogConfig.Set_EnableUDP(Value: WordBool);
begin
  m_EnableUDP := Value;
end;

procedure TRsLogConfig.Set_Path(const Value: WideString);
begin
  m_Path := Value;
end;

procedure TRsLogConfig.Set_UDPPort(Value: Integer);
begin
  m_UDPPort := Value;
end;

procedure TRsLogConfig.ShowConfigForm(AppHandle, ParentHandle: Integer);
begin
  TfrmLogLibConfig.ShowConfig(AppHandle,ParentHandle,Self);
end;
function TRsLog.OnLogout(const Title, Log: WideString): HResult;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsLog, Class_RsLog,
    ciMultiInstance, tmApartment);
  TAutoObjectFactory.Create(ComServer, TRsLogConfig, CLASS_RsLogConfig,
    ciInternal, tmApartment);
end.
