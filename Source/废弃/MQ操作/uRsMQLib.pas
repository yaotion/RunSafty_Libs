unit uRsMQLib;

interface
uses
  Classes;
type
  {ʹ�õ�MQ��ģʽ(mmQueueΪ����ģʽ����ָ�����Ͷ���SendQueueName�ͽ��ն���RecQueueName,
    TOPIC��ֻ��ָ��TopicName}
  TMQMode = (mmQueue,mmTopic);
  //����ģʽ���־û����ǳ־û�
  TMQDeliveryMode = (mqdmNonPersistent, mqdmPersistent);
  //MQ������Ϣ
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

  //MQ�����ı��¼���
  TMQRecTextEvent = procedure(Text : string;var Confirmd : boolean) of Object;
  ////MQ���ն��������¼���
  TMQRecStreamEvent = procedure(S : TStream;var Confirmd : boolean) of Object;

  IMQRec  = interface
    ['{279B793F-A5D8-4A33-8496-4DA660A02EE9}']
    procedure RecText(Text : string;var Confirmed : boolean);
    procedure RecStream(S : TStream;var Confirmed : boolean);
  end;
  //��Ϣ���սӿ�ʵ����
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
    //��
    procedure Open();
    //�����ı�
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
