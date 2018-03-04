unit uMQUtils;

interface
uses
  Classes,BTURI,BTJMSInterfaces,BTJMSConnection,BTCommAdapterIndy,
    BTJMSConnectionFactory,BTJMSTypes;
type
  //MQ连接信息
  RMQConnConfig = record
  public
    //用户名
    UserName:string;
    //密码
    UserPSW:string;
    //地址
    IP:string;
    //端口
    Port:string;
  public
    function ToString:string;
    function ToURI : IURI;
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
  
  //MQ接收文本事件类
  TMQRecTextEvent = procedure(Text : string;var Confirmd : boolean) of Object;
  {使用的MQ的模式(mmQueue为队列模式必须指定发送队列SendQueueName和接收队列RecQueueName,
    TOPIC则只需指定TopicName}
  TMQMode = (mmQueue,mmTopic);
  //传递模式，持久化，非持久化
  TMQDeliveryMode = (mqdmNonPersistent, mqdmPersistent);
  //MQ操作管理类
  TMQUtils = class
  public
    constructor Create;
    destructor Destroy;override;
  public
    //打开
    procedure Open;
    //停止
    procedure Stop;
    //关闭
    procedure Close;
    //发送文本
    procedure SendText(MessageText  : string);
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
    //消息监听类
    m_MsgListener : TMQMsgListener;
    //当收到文本消息
    m_OnReceiveText : TMQRecTextEvent;
    //发送目标
    m_SendDestination : IDestination;
    //接收目标
    m_RecDestination :IDestination;
  private
    procedure CloseAll;
    procedure Check;
    procedure OnMQMessage(Sender: TObject; const Message: IMessage);
  private
    function GetStarted: boolean;
  public
    ConnectionConfig : RMQConnConfig;
    ClientID  : string;
    TopicName : string;
    Mode : TMQMode;
    DeliveryMode:TMQDeliveryMode;
  public
    //是否处于打开状态
    property Started : boolean read GetStarted;
    //队列名称
    property SendQueueName : string read m_SendQueueName write m_SendQueueName;
    //队列名称
    property RecQueueName : string read m_RecQueueName write m_RecQueueName;
    //接收文本事件
    property OnReceiveText : TMQRecTextEvent read m_OnReceiveText write m_OnReceiveText;
  end;
implementation
uses
  SysUtils;
{ TtfMQUtils }


procedure TMQUtils.Check;
begin
  if ClientID = '' then
  begin
    raise Exception.Create('请指定客户端ID');  
  end;
  if Mode = mmQueue then
  begin
    if m_SendQueueName = '' then
      raise Exception.Create('队列模式下必须指定发送队列名称');
    if m_RecQueueName = '' then
      raise Exception.Create('队列模式下必须指定接收队列名称');      
  end;

  if Mode = mmTopic then
  begin
    if TopicName = '' then
      raise Exception.Create('广播模式下必须指定广播主题');
  end;
end;

procedure TMQUtils.Close;
begin
  m_Conn.Close;
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
  inherited;
end;

function TMQUtils.GetStarted: boolean;
begin
  result := m_Conn <> nil;
end;

procedure TMQUtils.OnMQMessage(Sender: TObject; const Message: IMessage);
var
  msgText  : string;
  confirmed : boolean;
begin
  if not Started then exit;
  if not assigned(m_Consumer) then exit;

  if Supports(Message,ITextMessage) then
  begin
    msgText := (Message as ITextMessage).Text;
    confirmed := false;
    m_OnReceiveText(msgText,confirmed);
    if confirmed  then
      message.Acknowledge;
  end;

end;

procedure TMQUtils.Open;
begin
  //检测输入条件是否足够
  Check;
  //关闭所有的连接
  CloseAll;
  //创建链接  
  m_Conn := TBTJMSConnection.MakeConnection(ConnectionConfig.UserName,
    ConnectionConfig.UserPSW, ConnectionConfig.ToString);
  m_Conn.ClientID := ClientID;
  m_Conn.Start;
  //
  m_Session := m_Conn.CreateSession(False, amClientAcknowledge);

  if Mode = mmQueue then
  begin
    m_SendDestination := m_Session.CreateQueue(m_SendQueueName);
    m_Producer := m_Session.CreateProducer(m_SendDestination);
    m_Producer.DeliveryMode := TJMSDeliveryMode(DeliveryMode);

    m_RecDestination := m_Session.CreateQueue(m_RecQueueName);
    m_Consumer := m_Session.CreateConsumer(m_RecDestination);
    m_MsgListener := TMQMsgListener.Create;
    m_MsgListener.OnMQMessage := OnMQMessage ;
    m_Consumer.MessageListener := m_MsgListener;

  end;
  if Mode = mmTopic then
  begin
    m_Topic := m_Session.CreateTopic(TopicName);
    m_Producer := m_Session.CreateProducer(m_Topic);
    m_Producer.DeliveryMode := TJMSDeliveryMode(DeliveryMode);
    m_MsgListener := TMQMsgListener.Create;
    m_MsgListener.OnMQMessage := OnMQMessage ;
    m_Consumer := m_Session.CreateDurableSubscriber(m_Topic,ClientID);
    m_Consumer.MessageListener := m_MsgListener;
  end;
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

procedure TMQUtils.Stop;
begin
  m_Conn.Stop;
end;
{ RMQConnConfig }

function RMQConnConfig.ToString: string;
begin
  result := Format('stomp://%s:%s',[IP,Port]);
end;

function RMQConnConfig.ToURI: IURI;
var
  BrokerURL : string;
begin
 try
    BrokerURL :=  ToString();
    Result := TBTURI.Create(BrokerURL);
    if Result.Port = '' then
    begin
      Result.Port := '61613';
    end;
  except
    on E: EURISyntaxException do
    begin
      raise Exception.Create('Invalid broker URI: ' + BrokerURL);
    end;
  end;
end;

{ TMQRecThread }


{ TMQMsgListener }

procedure TMQMsgListener.OnMessage(const Message: IMessage);
begin
  if assigned(m_OnMQMessage) then
  begin
    m_OnMQMessage(Self,Message);
  end;
end;

{ TMQSender }


end.
