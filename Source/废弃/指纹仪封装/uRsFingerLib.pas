unit uRsFingerLib;

interface

type
  //����ģʽ(����ģʽ���㲥ģʽ)
  TListenMode = (flmSignle,flmBoardCast);

  //ָ�ƶ�������
  IFingerListener = interface
    ['{C2945238-CCC6-4937-A8BC-D01E6EFF4494}']
    //ָ�ư���
    procedure FingerTouching(FingerImage : OleVariant);stdcall;
    //ָ��ʶ��ʧ��
    procedure FingerFailure;stdcall;
    //ָ��ʶ��ɹ�
    procedure FingerSuccess(FingerID : Cardinal);stdcall;
    //ָ�ƵǼǽ���
    procedure FingerScroll(ActionResult: WordBool;ATemplate: OleVariant);stdcall;
    //ָ�ƵǼ�ͳ���¼�(��ѹ����)
    procedure FeatureInfo(AQuality: Integer);stdcall;
  end;

  TFingerTouchingEvent = procedure(FingerImage : OleVariant) of object;
  TFingerFailureEvent = procedure of Object;
  TFingerSuccessEvent = procedure(FingerID : Cardinal) of object;
  TFingerScrollEvent = procedure (ActionResult: WordBool;ATemplate: OleVariant) of Object;
  TFeatureInfo = procedure(AQuality: Integer) of Object;
  //ָ�Ƽ���ʵ����(���ⲿ����)
  TFingerListener = class(TInterfacedObject,IFingerListener)
  private
    m_OnTouching   : TFingerTouchingEvent;
    m_OnFailure    : TFingerFailureEvent;
    m_OnSuccess    : TFingerSuccessEvent;
    m_OnScroll     : TFingerScrollEvent;
    m_OnFeatureInfo: TFeatureInfo;
  public
    //ָ�ư���
    procedure FingerTouching(FingerImage : OleVariant);stdcall;
    //ָ��ʶ��ʧ��
    procedure FingerFailure;stdcall;
    //ָ��ʶ��ɹ�
    procedure FingerSuccess(FingerID : Cardinal);stdcall;
    //ָ�ƵǼǽ���
    procedure FingerScroll(ActionResult: WordBool;ATemplate: OleVariant);stdcall;
    //ָ�ƵǼ�ͳ���¼�(��ѹ����)
    procedure FeatureInfo(AQuality: Integer);stdcall;
  public
     property OnTouching : TFingerTouchingEvent read m_OnTouching    write m_OnTouching;
     property OnFailure  : TFingerFailureEvent  read m_OnFailure     write m_OnFailure;
     property OnSuccess  : TFingerSuccessEvent  read m_OnSuccess     write m_OnSuccess;
     property OnScroll   : TFingerScrollEvent   read m_OnScroll      write m_OnScroll;
     property OnFeatureInfo: TFeatureInfo         read m_OnFeatureInfo write m_OnFeatureInfo;
  end;

  //ָ�ƿ���
  IFinger = interface
    ['{C440312E-35F6-4262-A239-5FAB5FD0316F}']
    //��ָ����
    procedure Open;stdcall;
    //�ر�ָ����
    procedure Close;stdcall;
    //��ʼ�Ǽ�
    procedure BeginScroll;stdcall;
    //�����Ǽ�
    procedure CancelScroll;stdcall;
    //��ʼ����
    procedure BeginCapture;stdcall;
    //��������
    procedure EndCapture;stdcall;
    //���ָ��
    procedure AddFinger(FingerID : Cardinal;FingerDatas : array of OleVariant);stdcall;
    //�޸�ָ��
    procedure UpdateFinger(FingerID : Cardinal;FingerDatas : array of OleVariant);stdcall;
    //ɾ��ָ��
    procedure DeleteFinger(FingerID : Cardinal);stdcall;
    //���ָ��
    procedure ClearFingers;stdcall;
    //���ָ�Ƽ���
    procedure AddListener(Listener:IFingerListener);stdcall;
    //ɾ��ָ�Ƽ���
    procedure DeleteListener(Listener:IFingerListener);stdcall;
    //���ָ�Ƽ���
    procedure ClearListeners;stdcall;
    //��ȡ����ģʽ
    function  GetListenMode : byte;stdcall;
    //���ü���ģʽ
    procedure SetListenMode(Mode : byte);stdcall;
    //ָ��������
    function GetSensorCount : integer;
    //ָ�������
    function GetSensorIndex : integer;
    //ָ���Ǳ���
    function GetSensorSN : WideString;
    //�Ƿ���ע����
    function GetIsRegister : boolean;
    //��ע��ָ�ƵĴ���
    function GetEnrollIndex : integer;
    //��ȡָ�Ƽ���׼
    function GetScore : Integer;
    //����ָ��ʶ��׼
    procedure SetScore(Value : Integer);
    //��ȡָ�����Ƿ��Ѿ�����
    function GetActive : boolean;
    //����ģʽ
    property ListenMode : byte read GetListenMode write SetListenMode;
    //ָ��������
    property SensorCount : integer read GetSensorCount;
    //ָ�������
    property SensorIndex : integer read GetSensorIndex;
    //ָ���Ǳ���
    property SensorSN : WideString read GetSensorSN;
    //�Ƿ��ڵǼ�״̬��
    property IsRegister : boolean  read GetIsRegister;
    //��ע��ָ�ƵĴ���
    property EnrollIndex : integer read GetEnrollIndex;
    //ָ��ʶ��׼��ȱʡΪ8����Χ1-10
    property Score : Integer read GetScore write SetScore;
    //ָ�����Ƿ��Ѿ�����
    property Acitve : boolean read GetActive;


    
  end;
implementation

{ TFingerListener }

procedure TFingerListener.FeatureInfo(AQuality: Integer);
begin
  if Assigned(m_OnFeatureInfo) then
    m_OnFeatureInfo(AQuality);
end;

procedure TFingerListener.FingerFailure;
begin
  if Assigned(m_OnFailure) then
    m_OnFailure;
end;

procedure TFingerListener.FingerScroll(ActionResult: WordBool;
  ATemplate: OleVariant);
begin
  if Assigned(m_OnScroll) then
    m_OnScroll(ActionResult,ATemplate);
end;

procedure TFingerListener.FingerSuccess(FingerID: Cardinal);
begin
  if Assigned(m_OnSuccess) then
    m_OnSuccess(FingerID);
end;

procedure TFingerListener.FingerTouching(FingerImage: OleVariant);
begin
  if Assigned(m_OnTouching) then
    m_OnTouching(FingerImage);
end;

end.
