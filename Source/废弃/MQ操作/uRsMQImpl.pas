unit uRsMQImpl;

interface
uses
  Classes,encddecd,BTURI,BTJMSInterfaces,BTJMSConnection,Forms,
  BTJMSConnectionFactory,BTJMSTypes,uRsLibClass,uRsMQLib,BTCommAdapterIndy;
type
  TMQConnConfig = class(TInterfacedObject,IMQConnConfig)
  private
    m_Username : string;
    m_Password : string;
    m_IP : string;
    m_Port : string;
  private
    function GetUsername : string;stdcall;
    procedure SetUsername(Value : string);stdcall;
    function GetPassword : string;stdcall;
    procedure SetPassword(Value : string);stdcall;
    function GetIP : string;stdcall;
    procedure SetIP(Value : string);stdcall;
    function GetPort : string;stdcall;
    procedure SetPort(Value : string);stdcall;
  public    
    function ToString : string;
  end;

  ///消息监听
  TMQMsgListener = class(TInterfacedObject,IMessageListener)
  private
    m_OnMQMessage : TOnMessageEvent;
  public
    procedure OnMessage(const Message: IMessage);
  public
    property OnMQMessage : TOnMessageEvent read m_OnMQMessage write m_OnMQMessage;
  end; 

  //MQ操作管理类
  TMQUtils = class(TRsLibEntry,IMQUtils)
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    //打开
    procedure Open();
    //发送文本
    procedure SendText(MessageText  : string);
    //发送二进制流(内容不能过多)
    procedure SendStream(S  : TStream);    
  private
     //连接
    m_Conn: IConnection;
    //回话 基于连接
    m_Session: ISession;
    //发送队列名称
    m_SendQueueName : string;
    //接收队列名称
    m_RecQueueName : string;
    //消息生产者
    m_Producer: IMessageProducer;
    //消息消费者
    m_Consumer: IMessageConsumer;
    //订阅的主题
    m_Topic : ITopic;
    //订阅主题名称
    m_TopicName : string;
    //消息监听类
    m_MsgListener : TMQMsgListener;
    //发送目标
    m_SendDestination : IDestination;
    //接收目标
    m_RecDestination :IDestination;
    //客户端编号
    m_ClientID : string;
    //队列模式或者订阅模式
    m_Mode : integer;
    //持久化模式
    m_DeliveryMode : integer;
    //接收事件
    m_OnReceive : IMQRec;
    //连接信息
    m_MQConnConfig : IMQConnConfig;
  private
    procedure CloseAll;
    procedure Check;
    procedure OnMQMessage(Sender: TObject; const Message: IMessage);
  private
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
  public
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
uses
  SysUtils;
{ TtfMQUtils }


procedure TMQUtils.Check;
begin
  if m_ClientID = '' then
  begin
    raise Exception.Create('请指定客户端ID');
  end;
  if TMQMode(m_Mode) = mmQueue then
  begin
    if m_SendQueueName = '' then
      raise Exception.Create('队列模式下必须指定发送队列名称');
    if m_RecQueueName = '' then
      raise Exception.Create('队列模式下必须指定接收队列名称');      
  end;

  if TMQMode(m_Mode) = mmTopic then
  begin
    if m_TopicName = '' then
      raise Exception.Create('广播模式下必须指定广播主题');
  end;
end;

procedure TMQUtils.CloseAll;
begin
  if m_Producer <> nil then
  begin
    m_Producer.Close;
    m_Producer := nil;
  end;
  if m_Consumer <> nil then
  begin
     m_Consumer.Close;
     m_Consumer := nil;
  end;
  if m_Session <> nil then
  begin
    m_Session.Close;
    m_Session := nil;
  end;
  if m_Conn <> nil then
  begin
    m_Conn.Close;
    m_Conn := nil;
  end;
end;

constructor TMQUtils.Create;
begin
 //客户端编号
  m_ClientID := '';
  //队列模式或者订阅模式
  m_Mode := 0;
  //持久化模式
  m_DeliveryMode := 1;
  //连接信息
  m_MQConnConfig := TMQConnConfig.Create;
end;

destructor TMQUtils.Destroy;
begin
  m_Producer := nil;
  m_Consumer := nil;
  m_SendDestination := nil;
  m_RecDestination := nil;
  m_Topic := nil;
  m_Session := nil;
  m_Conn := nil;
  m_MQConnConfig := nil;
  inherited;
end;

function TMQUtils.GetClientID: string;
begin
  result := m_ClientID;
end;


function TMQUtils.GetConnectionConfig: IMQConnConfig;
begin
  result := m_MQConnConfig;
end;

function TMQUtils.GetDeliveryMode: integer;
begin
  result := m_DeliveryMode;
end;

function TMQUtils.GetMode: integer;
begin
  result := m_Mode;
end;

function TMQUtils.GetOnReceive: IMQRec;
begin
  result := m_OnReceive;
end;

function TMQUtils.GetRecQueueName: string;
begin
  result := m_RecQueueName;
end;

function TMQUtils.GetSendQueueName: string;
begin
  result := m_SendQueueName;
end;

function TMQUtils.GetStarted: boolean;
begin
  result := m_Conn <> nil;
end;

function TMQUtils.GetTopicName: string;
begin
  result := m_TopicName;
end;

procedure TMQUtils.OnMQMessage(Sender: TObject; const Message: IMessage);
var
  msgText  : string;
  strContent : string;
  confirmed : boolean;
  ms : TStream;
begin
  if not Started then exit;
  if not assigned(m_Consumer) then exit;

  if Supports(Message,ITextMessage) then
  begin
    msgText := (Message as ITextMessage).Text;
    confirmed := false;
    if assigned(m_OnReceive) then
    begin
      m_OnReceive.RecText(msgText,confirmed);
    end;
    if confirmed  then
      message.Acknowledge;
    exit;
  end;

  if Supports(Message,IBytesMessage) then
  begin
    strContent := DecodeString((Message as IBytesMessage).Content);
    confirmed := false;
    if assigned(m_OnReceive) then
    begin
      ms := TMemoryStream.Create;
      try
        ms.WriteBuffer(strContent[1],length(strContent));
        m_OnReceive.RecStream(ms,confirmed);
      finally
        ms.Free;
      end;
    end;
    if confirmed  then
      message.Acknowledge;
  end;
end;

procedure TMQUtils.Open();
begin
  //检测输入条件是否足够
  Check;
  //关闭所有的连接
  CloseAll;
  //创建链接  
  m_Conn := TBTJMSConnection.MakeConnection(m_MQConnConfig.Username,
    m_MQConnConfig.Password, m_MQConnConfig.ToString);
  m_Conn.ClientID := ClientID;
  m_Conn.Start;
  //
  m_Session := m_Conn.CreateSession(False, amClientAcknowledge);

  if TMQMode(m_Mode) = mmQueue then
  begin
    m_SendDestination := m_Session.CreateQueue(m_SendQueueName);
    m_Producer := m_Session.CreateProducer(m_SendDestination);
    m_Producer.DeliveryMode := TJMSDeliveryMode(DeliveryMode);

    m_RecDestination := m_Session.CreateQueue(m_RecQueueName);
    m_Consumer := m_Session.CreateConsumer(m_RecDestination);
    m_MsgListener := TMQMsgListener.Create;
    TMQMsgListener(m_MsgListener).OnMQMessage := OnMQMessage ;
    m_Consumer.MessageListener := m_MsgListener;

  end;
  if TMQMode(m_Mode) = mmTopic then
  begin
    m_Topic := m_Session.CreateTopic(TopicName);
    m_Producer := m_Session.CreateProducer(m_Topic);
    m_Producer.DeliveryMode := TJMSDeliveryMode(DeliveryMode);
    m_MsgListener := TMQMsgListener.Create;
    TMQMsgListener(m_MsgListener).OnMQMessage := OnMQMessage ;
    m_Consumer := m_Session.CreateDurableSubscriber(m_Topic,ClientID);
    m_Consumer.MessageListener := m_MsgListener;
  end;
end;

procedure TMQUtils.SendStream(S: TStream);
var
  msg: IBytesMessage;
  Size: Int64;
  Content,encodeContent: AnsiString;
begin
  Size := s.Size;
  if (Size < 0) or (Size > MaxInt) then
    raise Exception.Create('Stream size error');
   
  S.Position := 0;
  SetLength(Content, Size);
  S.ReadBuffer(Pointer(Content)^, Size);
  encodeContent := EncodeString(content);
  msg := m_Session.CreateBytesMessage;
  msg.Content := encodeContent ;

  m_Producer.TimeToLive := 100000000;
  m_Producer.DeliveryMode := TJMSDeliveryMode(m_DeliveryMode);
  m_Producer.Send(msg);
  msg := nil;
end;

procedure TMQUtils.SendText(MessageText: string);
var
  txtMsg: ITextMessage;
begin
  txtMsg := m_Session.CreateTextMessage(MessageText);
  m_Producer.TimeToLive := 100000000;
  m_Producer.DeliveryMode := dmPersistent;
  m_Producer.Send(txtMsg);
  txtMsg := nil;
end;


procedure TMQUtils.SetClientID(Value: string);
begin
  m_ClientID := Value;
end;

procedure TMQUtils.SetDeliveryMode(Value: integer);
begin
  m_DeliveryMode := Value;
end;

procedure TMQUtils.SetMode(Value: integer);
begin
  m_Mode := Value;
end;

procedure TMQUtils.SetOnReceive(Value: IMQRec);
begin
  m_OnReceive := Value;
end;

procedure TMQUtils.SetRecQueueName(Value: string);
begin
  m_RecQueueName := value;
end;

procedure TMQUtils.SetSendQueueName(Value: string);
begin
  m_SendQueueName := value;
end;

procedure TMQUtils.SetTopicName(Value: string);
begin
  m_TopicName := Value;
end;

{ TMQMsgListener }

procedure TMQMsgListener.OnMessage(const Message: IMessage);
begin
  if assigned(m_OnMQMessage) then
  begin
    m_OnMQMessage(Self,Message);
  end;
end;


{ TMQConnConfig }

function TMQConnConfig.GetIP: string;
begin
  result := m_IP;
end;

function TMQConnConfig.GetPassword: string;
begin
  result := m_Password;
end;

function TMQConnConfig.GetPort: string;
begin
  result := m_Port;
end;

function TMQConnConfig.GetUsername: string;
begin
  result := m_Username;
end;

procedure TMQConnConfig.SetIP(Value: string);
begin
  m_IP := value;
end;

procedure TMQConnConfig.SetPassword(Value: string);
begin
  m_Password := value;
end;

procedure TMQConnConfig.SetPort(Value: string);
begin
  m_Port := Value;
end;

procedure TMQConnConfig.SetUsername(Value: string);
begin
  m_Username := Value;
end;

function TMQConnConfig.ToString: string;
begin
  result := Format('stomp://%s:%s',[m_IP,m_Port]);
end;

end.
