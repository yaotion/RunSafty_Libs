unit uMQUtils;

interface
uses
  Classes,BTURI,BTJMSInterfaces,BTJMSConnection,BTCommAdapterIndy,
    BTJMSConnectionFactory,BTJMSTypes;
type
  //MQ������Ϣ
  RMQConnConfig = record
  public
    //�û���
    UserName:string;
    //����
    UserPSW:string;
    //��ַ
    IP:string;
    //�˿�
    Port:string;
  public
    function ToString:string;
    function ToURI : IURI;
  end;

  ///��Ϣ����
  TMQMsgListener = class(TInterfacedObject,IMessageListener)
  private
    m_OnMQMessage : TOnMessageEvent;
  public
    procedure OnMessage(const Message: IMessage);
  public
    property OnMQMessage : TOnMessageEvent read m_OnMQMessage write m_OnMQMessage;
  end;
  
  //MQ�����ı��¼���
  TMQRecTextEvent = procedure(Text : string;var Confirmd : boolean) of Object;
  {ʹ�õ�MQ��ģʽ(mmQueueΪ����ģʽ����ָ�����Ͷ���SendQueueName�ͽ��ն���RecQueueName,
    TOPIC��ֻ��ָ��TopicName}
  TMQMode = (mmQueue,mmTopic);
  //����ģʽ���־û����ǳ־û�
  TMQDeliveryMode = (mqdmNonPersistent, mqdmPersistent);
  //MQ����������
  TMQUtils = class
  public
    constructor Create;
    destructor Destroy;override;
  public
    //��
    procedure Open;
    //ֹͣ
    procedure Stop;
    //�ر�
    procedure Close;
    //�����ı�
    procedure SendText(MessageText  : string);
  private
     //����
    m_Conn: IConnection;
    //�ػ� ��������
    m_Session: ISession;
    //���Ͷ�������
    m_SendQueueName : string;
    //���ն�������
    m_RecQueueName : string;
    //��Ϣ������
    m_Producer: IMessageProducer;
    //��Ϣ������
    m_Consumer: IMessageConsumer;
    //���ĵ�����
    m_Topic : ITopic;
    //��Ϣ������
    m_MsgListener : TMQMsgListener;
    //���յ��ı���Ϣ
    m_OnReceiveText : TMQRecTextEvent;
    //����Ŀ��
    m_SendDestination : IDestination;
    //����Ŀ��
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
    //�Ƿ��ڴ�״̬
    property Started : boolean read GetStarted;
    //��������
    property SendQueueName : string read m_SendQueueName write m_SendQueueName;
    //��������
    property RecQueueName : string read m_RecQueueName write m_RecQueueName;
    //�����ı��¼�
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
    raise Exception.Create('��ָ���ͻ���ID');  
  end;
  if Mode = mmQueue then
  begin
    if m_SendQueueName = '' then
      raise Exception.Create('����ģʽ�±���ָ�����Ͷ�������');
    if m_RecQueueName = '' then
      raise Exception.Create('����ģʽ�±���ָ�����ն�������');      
  end;

  if Mode = mmTopic then
  begin
    if TopicName = '' then
      raise Exception.Create('�㲥ģʽ�±���ָ���㲥����');
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
  //������������Ƿ��㹻
  Check;
  //�ر����е�����
  CloseAll;
  //��������  
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
