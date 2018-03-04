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

  ///��Ϣ����
  TMQMsgListener = class(TInterfacedObject,IMessageListener)
  private
    m_OnMQMessage : TOnMessageEvent;
  public
    procedure OnMessage(const Message: IMessage);
  public
    property OnMQMessage : TOnMessageEvent read m_OnMQMessage write m_OnMQMessage;
  end; 

  //MQ����������
  TMQUtils = class(TRsLibEntry,IMQUtils)
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    //��
    procedure Open();
    //�����ı�
    procedure SendText(MessageText  : string);
    //���Ͷ�������(���ݲ��ܹ���)
    procedure SendStream(S  : TStream);    
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
    //������������
    m_TopicName : string;
    //��Ϣ������
    m_MsgListener : TMQMsgListener;
    //����Ŀ��
    m_SendDestination : IDestination;
    //����Ŀ��
    m_RecDestination :IDestination;
    //�ͻ��˱��
    m_ClientID : string;
    //����ģʽ���߶���ģʽ
    m_Mode : integer;
    //�־û�ģʽ
    m_DeliveryMode : integer;
    //�����¼�
    m_OnReceive : IMQRec;
    //������Ϣ
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
   //�Ƿ��ڴ�״̬
    property Started : boolean read GetStarted;
    //��������
    property SendQueueName : string read GetSendQueueName write SetSendQueueName;
    //��������
    property RecQueueName : string read GetRecQueueName write SetRecQueueName;
   //����������Ϣ
    property ConnectionCofing : IMQConnConfig read GetConnectionConfig;
    //�ͻ��˱��
    property ClientID  : string read GetClientID write SetClientID;
    //��������
    property TopicName : string read GetTopicName write SetTopicName;
    //ģʽ
    property Mode : integer read GetMode write SetMode;
    //�Ƿ�־û�
    property DeliveryMode:integer read GetDeliveryMode write SetDeliveryMode;
    //�����ı��¼�
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
    raise Exception.Create('��ָ���ͻ���ID');
  end;
  if TMQMode(m_Mode) = mmQueue then
  begin
    if m_SendQueueName = '' then
      raise Exception.Create('����ģʽ�±���ָ�����Ͷ�������');
    if m_RecQueueName = '' then
      raise Exception.Create('����ģʽ�±���ָ�����ն�������');      
  end;

  if TMQMode(m_Mode) = mmTopic then
  begin
    if m_TopicName = '' then
      raise Exception.Create('�㲥ģʽ�±���ָ���㲥����');
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
 //�ͻ��˱��
  m_ClientID := '';
  //����ģʽ���߶���ģʽ
  m_Mode := 0;
  //�־û�ģʽ
  m_DeliveryMode := 1;
  //������Ϣ
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
  //������������Ƿ��㹻
  Check;
  //�ر����е�����
  CloseAll;
  //��������  
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
