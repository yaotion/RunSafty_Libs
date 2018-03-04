unit uRsMQLib;

interface
uses
  Classes;
type
  {使用的MQ的模式(mmQueue为队列模式必须指定发送队列SendQueueName和接收队列RecQueueName,
    TOPIC则只需指定TopicName}
  TMQMode = (mmQueue,mmTopic);
  //传递模式，持久化，非持久化
  TMQDeliveryMode = (mqdmNonPersistent, mqdmPersistent);
  //MQ连接信息
  IMQConnConfig = interface
  ['{E6A0ABB8-2BB8-4F21-8CAF-44A41415323C}']
    function GetUsername : string;stdcall;
    procedure SetUsername(Value : string);stdcall;
    function GetPassword : string;stdcall;
    procedure SetPassword(Value : string);stdcall;
    function GetIP : string;stdcall;
    procedure SetIP(Value : string);stdcall;
    function GetPort : string;stdcall;
    procedure SetPort(Value : string);stdcall;
    
    function ToString : string;
    
    property Username : string read GetUsername write SetUsername;
    property Password : string read GetPassword write SetPassword;
    property IP : string read GetIP write SetIP;
    property Port : string read GetPort write SetPort;
  end;

  //MQ接收文本事件类
  TMQRecTextEvent = procedure(Text : string;var Confirmd : boolean) of Object;
  ////MQ接收二进制流事件类
  TMQRecStreamEvent = procedure(S : TStream;var Confirmd : boolean) of Object;

  IMQRec  = interface
    ['{279B793F-A5D8-4A33-8496-4DA660A02EE9}']
    procedure RecText(Text : string;var Confirmed : boolean);
    procedure RecStream(S : TStream;var Confirmed : boolean);
  end;
  //消息接收接口实现类
  TMQRec = class(TInterfacedObject,IMQRec)
  private
    procedure RecText(Text : string;var Confirmed : boolean);
    procedure RecStream(S : TStream;var Confirmed : boolean);
  private
    m_OnRecText : TMQRecTextEvent;
    m_OnRecStream : TMQRecStreamEvent;
  public
    property OnRecText : TMQRecTextEvent read m_OnRecText write m_OnRecText;
    property OnRecStream : TMQRecStreamEvent read m_OnRecStream write m_OnRecStream;
  end;
  
  IMQUtils = interface
  ['{16AAAF4E-2F75-41D6-95E4-3C11465BD8E9}']
    //打开
    procedure Open();
    //发送文本
    procedure SendText(MessageText  : string);

    function  GetStarted : boolean;
    function  GetSendQueueName : string;
    procedure SetSendQueueName(Value : string);
    function  GetRecQueueName : string;
    procedure SetRecQueueName(Value : string);
    function  GetConnectionConfig : IMQConnConfig;
    function  GetClientID : string;
    procedure SetClientID(Value : string);
    function  GetTopicName : string;
    procedure SetTopicName(Value : string);
    function  GetMode : integer;
    procedure SetMode(Value : integer);
    function  GetDeliveryMode : integer;
    procedure SetDeliveryMode(Value : integer);
    function  GetOnReceive : IMQRec;
    procedure SetOnReceive(Value : IMQRec);
     //是否处于打开状态
    property Started : boolean read GetStarted;
    //队列名称
    property SendQueueName : string read GetSendQueueName write SetSendQueueName;
    //队列名称
    property RecQueueName : string read GetRecQueueName write SetRecQueueName;
   //连接配置信息
    property ConnectionCofing : IMQConnConfig read GetConnectionConfig;
    //客户端编号
    property ClientID  : string read GetClientID write SetClientID;
    //订阅主题
    property TopicName : string read GetTopicName write SetTopicName;
    //模式
    property Mode : integer read GetMode write SetMode;
    //是否持久化
    property DeliveryMode:integer read GetDeliveryMode write SetDeliveryMode;
    //接收文本事件
    property OnReceive : IMQRec read GetOnReceive write SetOnReceive;
  end;
implementation


{ TMQRec }

procedure TMQRec.RecStream(S: TStream; var Confirmed: boolean);
begin
  if assigned(m_OnRecStream) then
  begin
    m_OnRecStream(S,Confirmed);
  end;
end;

procedure TMQRec.RecText(Text: string; var Confirmed: boolean);
begin
  if assigned(m_OnRecText) then
  begin
    m_OnRecText(Text,Confirmed);
  end;
end;

end.
