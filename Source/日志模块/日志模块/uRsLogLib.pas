////////////////////////////////////////////////////////////////////////////////
///����Ԫ�������������ñ��룬�����޸�������������
////////////////////////////////////////////////////////////////////////////////

unit uRsLogLib;

interface
uses
  SysUtils,windows;

type
  ///��־��Ϣ�����¼���
  TLogEvent = procedure(title: string;log: string) of object;

  //��־��Ϣ��Ϣ�ַ��ӿ�
  ILogListener = interface
  ['{43140F29-F57C-4A7B-82AF-BCAD6B8856AD}']
    procedure InsertLog(title: PAnsiChar;log: PAnsiChar);stdcall;
  end;

  //��־��Ϣ��Ϣ�ַ��ӿ�
  ILogConfig = interface
  ['{43140F29-F57C-4A7B-82AF-BCAD6B8856AB}']
    procedure SaveToFile(const FileName: string);stdcall;
    procedure LoadFromFile(const FileName: string); stdcall;
    procedure Reload();stdcall;
    procedure Save();stdcall;
    //��ʾ���ô���
    procedure ShowConfigForm(AppHandle,ParentHandle : THandle);stdcall;
    ////////////////////���Է���
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
    /////////////////////����//////////////////////////////////
    property Path: string read GetPath write SetPath;
    property EnableInfo: Boolean read GetEableInfo write SetEnableInfo;
    property EnableDebug: Boolean read GetEnableDebug write SetEnableDebug;
    property EnableError: Boolean read GetEnableError write SetEnableError;
    property UDPPort: integer read GetUDPPort write SetUDPPort;
    property EnableUDP: Boolean read GetEnableUDP write SetEnableUDP;
  end;
  
  //��־��¼�ӿ�  
  ILog = interface
  ['{D2674977-1555-40B5-A96A-CBE11611AA9D}']
    procedure WriteInfo(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure WriteError(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure WriteDebug(log: PAnsiChar;catalog: PAnsiChar = nil);stdcall;
    procedure SetListner(Listener: ILogListener);stdcall;
  end;
  
  //��־��Ϣ��Ϣ�ַ�ʵ����
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
