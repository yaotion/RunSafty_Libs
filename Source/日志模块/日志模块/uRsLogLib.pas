////////////////////////////////////////////////////////////////////////////////
///本单元仅供调用者引用编译，请勿修改其中任务内容
////////////////////////////////////////////////////////////////////////////////

unit uRsLogLib;

interface
uses
  SysUtils,windows;

type
  ///日志消息接收事件类
  TLogEvent = procedure(title: string;log: string) of object;

  //日志信息消息分发接口
  ILogListener = interface
  ['{43140F29-F57C-4A7B-82AF-BCAD6B8856AD}']
    procedure InsertLog(title: PAnsiChar;log: PAnsiChar);stdcall;
  end;

  //日志信息消息分发接口
  ILogConfig = interface
  ['{43140F29-F57C-4A7B-82AF-BCAD6B8856AB}']
    procedure SaveToFile(const FileName: string);stdcall;
    procedure LoadFromFile(const FileName: string); stdcall;
    procedure Reload();stdcall;
    procedure Save();stdcall;
    //显示配置窗口
    procedure ShowConfigForm(AppHandle,ParentHandle : THandle);stdcall;
    ////////////////////属性方法
    function GetPath: string;stdcall;
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
    /////////////////////属性//////////////////////////////////
    property Path: string read GetPath write SetPath;
    property EnableInfo: Boolean read GetEableInfo write SetEnableInfo;
    property EnableDebug: Boolean read GetEnableDebug write SetEnableDebug;
    property EnableError: Boolean read GetEnableError write SetEnableError;
    property UDPPort: integer read GetUDPPort write SetUDPPort;
    property EnableUDP: Boolean read GetEnableUDP write SetEnableUDP;
  end;
  
  //日志记录接口  
  ILog = interface
  ['{D2674977-1555-40B5-A96A-CBE11611AA9D}']
    procedure WriteInfo(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure WriteError(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure WriteDebug(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure SetListner(Listener: ILogListener);stdcall;
  end;
  
  //日志信息消息分发实现类
  TLogListener = class(TInterfacedObject,ILogListener)
  public
    constructor Create(LogEvent: TLogEvent);
  private
    m_LogEvent: TLogEvent;
  public
    procedure InsertLog(title: PAnsiChar;log: PAnsiChar);stdcall;
  end;

implementation


{ TLogListener }

constructor TLogListener.Create(LogEvent: TLogEvent);
begin
  m_LogEvent := LogEvent;


end;

procedure TLogListener.InsertLog(title: PAnsiChar;log: PAnsiChar);
begin
  if Assigned(m_LogEvent) then
    m_LogEvent(title,log);

end;
end.
