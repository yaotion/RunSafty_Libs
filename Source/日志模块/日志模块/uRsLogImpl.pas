unit uRsLogImpl;

interface
uses
  Classes,SysUtils,Windows,inifiles,IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient, IdUDPServer,uRsLogLib,uRsLibClass,uRsLibUtils,Dialogs;
type
  //日志报警级别
  TLogLevel = (llInfo,llDebug,llError);

  ///日志组件配置信息读取设置类
  TLogConfig = class(TRsLibEntry,ILogConfig)
  public
    constructor Create();override;
  private
    m_Path: string;
    m_EnableDebug: Boolean;
    m_EnableInfo: Boolean;
    m_EnableError: Boolean;
    m_UDPPort: integer;
    m_EnableUDP: Boolean;
    m_ConfigFile: string;
  protected
    ////////////////////属性方法
    function  GetPath: string;stdcall;
    procedure SetPath(Value : string);stdcall;
    function  GetEableInfo : boolean;stdcall;
    procedure SetEnableInfo(Value : boolean);stdcall;
    function  GetEnableDebug : boolean;stdcall;
    procedure SetEnableDebug(Value : boolean);stdcall;
    function  GetEnableError : boolean;stdcall;
    procedure SetEnableError(Value : boolean);stdcall;
    function  GetEnableUDP : boolean;stdcall;
    procedure SetEnableUDP(Value : boolean);stdcall;
    function  GetUDPPort : Integer;stdcall;
    procedure SetUDPPort(Value : Integer);stdcall;
  public
    procedure SaveToFile(const FileName: string); stdcall;
    procedure LoadFromFile(const FileName: string);stdcall;
    procedure Reload();stdcall;
    procedure Save();stdcall;
     //显示配置窗口
    procedure ShowConfigForm(AppHandle,ParentHandle : THandle);stdcall;
  public
    property Path: string read GetPath write SetPath;
    property EnableInfo: Boolean read GetEableInfo write SetEnableInfo;
    property EnableDebug: Boolean read GetEnableDebug write SetEnableDebug;
    property EnableError: Boolean read GetEnableError write SetEnableError;
    property UDPPort: integer read GetUDPPort write SetUDPPort;
    property EnableUDP: Boolean read GetEnableUDP write SetEnableUDP;
  end;
  
  ///日志处理实现类
  TLog = class(TRsLibEntry,ILog)
  public
    constructor Create();override;
    destructor Destroy();override;
  public
    {功能:插入日志}
    procedure InsertLog(const FileName: string;const title: string;const log : String);
  private
    //配置类
    m_LogConfig: TLogConfig;
    m_IdUDPClient: TIdUDPClient;
    {互斥对象}
    m_CriticalSection : TRTLCriticalSection;
    //日志监听类
    m_Listener: ILogListener;
    //应用程序根路径
    m_AppPath: string;
    m_LastLoadTick: Cardinal;
    
    procedure RefreshConfig();
    //生成日志文件名称
    function CreateFileName: string;
    //
    function CreateLog(log: PAnsiChar): string;
    //创建日志说明信息
    function CreateTitle(logLevel: TLogLevel;catalog: PAnsiChar): string;
  public
    //写信息类日志
    procedure WriteInfo(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    //写错误类日志
    procedure WriteError(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    //写调试类日志
    procedure WriteDebug(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    //设置日志监听方法
    procedure SetListner(Listener: ILogListener);stdcall;
  end;
  
implementation
uses
  uRsFrmLogLibConfig;

{ TLogConfig }

constructor TLogConfig.Create;
begin
  m_Path := 'log\';
  EnableInfo := True;
  EnableDebug := False;
  EnableError := True;
end;

function AddDirSuffix(const Dir: string): string;
{功能:目录尾加'\'修正}
begin
  Result := Trim(Dir);
  if Result = '' then Exit;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF};
end;


function TLogConfig.GetEableInfo: boolean;
begin
  result := m_EnableInfo;
end;

function TLogConfig.GetEnableDebug: boolean;
begin
  result :=  m_EnableDebug;
end;

function TLogConfig.GetEnableError: boolean;
begin
  result := m_EnableError;
end;

function TLogConfig.GetEnableUDP: boolean;
begin
  result := m_EnableUDP;
end;

function TLogConfig.GetPath: string;
begin
  result := m_Path;
end;

function TLogConfig.GetUDPPort: Integer;
begin
  result := m_UDPPort;
end;

procedure TLogConfig.LoadFromFile(const FileName: string);
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

procedure TLogConfig.Reload;
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


procedure TLogConfig.Save;
begin
  if m_ConfigFile = '' then
    Raise Exception.Create('没有指定文件名');
  SaveToFile(m_ConfigFile);
end;

procedure TLogConfig.SaveToFile(const FileName: string);
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

procedure TLogConfig.SetEnableDebug(Value: boolean);
begin
  m_EnableDebug := value;
end;

procedure TLogConfig.SetEnableError(Value: boolean);
begin
  m_EnableError := value;
end;

procedure TLogConfig.SetEnableInfo(Value: boolean);
begin
  m_EnableInfo := value;
end;

procedure TLogConfig.SetEnableUDP(Value: boolean);
begin
  m_EnableUDP := Value;
end;

procedure TLogConfig.SetPath(Value: string);
begin
  m_Path := value;
end;

procedure TLogConfig.SetUDPPort(Value: Integer);
begin
  m_UDPPort := Value;
end;


procedure TLogConfig.ShowConfigForm(AppHandle, ParentHandle: THandle);
begin
  TfrmLogLibConfig.ShowConfig(AppHandle,ParentHandle,Self);
end;

{ TLogSender }


constructor TLog.Create;
begin
  InitializeCriticalSection(m_CriticalSection);
  m_AppPath := ExtractFilePath(ParamStr(0));

  m_LogConfig := TLogConfig.Create;

  m_LogConfig.LoadFromFile(m_AppPath + 'Log.ini');

  m_LastLoadTick := GetTickCount;

  m_IdUDPClient:= TIdUDPClient.Create(nil);

end;
function TLog.CreateFileName: string;
begin
  Result := m_AppPath + m_LogConfig.Path + FormatDateTime('yyyy-mm-dd',Now) + '.log';
  if not DirectoryExists(m_AppPath + m_LogConfig.Path) then
    ForceDirectories(m_AppPath + m_LogConfig.Path);
end;

function TLog.CreateLog(log: PAnsiChar): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss',Now) + ':' + StrPas(log);
end;

function TLog.CreateTitle(logLevel: TLogLevel; catalog: PAnsiChar): string;
begin
  case logLevel of
    llInfo: Result := '[info]';
    llDebug: Result := '[debug]';
    llError: Result := '[error]';
  else
    Result := '[ErrorLevel]';
  end;

  if (catalog <> nil) and (StrPas(catalog) <> '') then
  begin
    Result := Result + '[' + StrPas(catalog) + ']';
  end;

end;

destructor TLog.Destroy;
begin
  m_IdUDPClient.Free;
  m_LogConfig.Free;
  DeleteCriticalSection(m_CriticalSection);
  inherited;
end;

procedure TLog.InsertLog(const FileName: string;const title: string;const log: String);
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

    if Assigned(m_Listener) then
    begin
      try
        m_Listener.InsertLog(PAnsiChar(title),PAnsiChar(log));
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


procedure TLog.RefreshConfig;
begin
  //最多5秒更新一次
  if GetTickCount - m_LastLoadTick > 5 * 1000 then
  begin
    m_LastLoadTick := GetTickCount;
    m_LogConfig.Reload();
  end;
end;

procedure TLog.SetListner(Listener: ILogListener);
begin
  m_Listener := Listener;
end;

procedure TLog.WriteDebug(log, catalog: PAnsiChar);
begin
  if m_LogConfig.EnableDebug then
  begin
    InsertLog(CreateFileName(),CreateTitle(llDebug,catalog),CreateLog(log));
  end;
end;

procedure TLog.WriteError(log, catalog: PAnsiChar);
begin
  if m_LogConfig.EnableError then
  begin
    InsertLog(CreateFileName(),CreateTitle(llError,catalog),CreateLog(log));
  end;
end;
procedure TLog.WriteInfo(log, catalog: PAnsiChar);
begin
  if m_LogConfig.EnableInfo then
  begin
    InsertLog(CreateFileName(),CreateTitle(llInfo,catalog),CreateLog(log));
  end;
end;


end.
