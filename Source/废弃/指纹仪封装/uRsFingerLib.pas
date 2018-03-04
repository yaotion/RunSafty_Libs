unit uRsFingerLib;

interface

type
  //监听模式(单独模式，广播模式)
  TListenMode = (flmSignle,flmBoardCast);

  //指纹动作监听
  IFingerListener = interface
    ['{C2945238-CCC6-4937-A8BC-D01E6EFF4494}']
    //指纹按下
    procedure FingerTouching(FingerImage : OleVariant);stdcall;
    //指纹识别失败
    procedure FingerFailure;stdcall;
    //指纹识别成功
    procedure FingerSuccess(FingerID : Cardinal);stdcall;
    //指纹登记结束
    procedure FingerScroll(ActionResult: WordBool;ATemplate: OleVariant);stdcall;
    //指纹登记统计事件(按压次数)
    procedure FeatureInfo(AQuality: Integer);stdcall;
  end;

  TFingerTouchingEvent = procedure(FingerImage : OleVariant) of object;
  TFingerFailureEvent = procedure of Object;
  TFingerSuccessEvent = procedure(FingerID : Cardinal) of object;
  TFingerScrollEvent = procedure (ActionResult: WordBool;ATemplate: OleVariant) of Object;
  TFeatureInfo = procedure(AQuality: Integer) of Object;
  //指纹监听实现类(供外部调用)
  TFingerListener = class(TInterfacedObject,IFingerListener)
  private
    m_OnTouching   : TFingerTouchingEvent;
    m_OnFailure    : TFingerFailureEvent;
    m_OnSuccess    : TFingerSuccessEvent;
    m_OnScroll     : TFingerScrollEvent;
    m_OnFeatureInfo: TFeatureInfo;
  public
    //指纹按下
    procedure FingerTouching(FingerImage : OleVariant);stdcall;
    //指纹识别失败
    procedure FingerFailure;stdcall;
    //指纹识别成功
    procedure FingerSuccess(FingerID : Cardinal);stdcall;
    //指纹登记结束
    procedure FingerScroll(ActionResult: WordBool;ATemplate: OleVariant);stdcall;
    //指纹登记统计事件(按压次数)
    procedure FeatureInfo(AQuality: Integer);stdcall;
  public
     property OnTouching : TFingerTouchingEvent read m_OnTouching    write m_OnTouching;
     property OnFailure  : TFingerFailureEvent  read m_OnFailure     write m_OnFailure;
     property OnSuccess  : TFingerSuccessEvent  read m_OnSuccess     write m_OnSuccess;
     property OnScroll   : TFingerScrollEvent   read m_OnScroll      write m_OnScroll;
     property OnFeatureInfo: TFeatureInfo         read m_OnFeatureInfo write m_OnFeatureInfo;
  end;

  //指纹控制
  IFinger = interface
    ['{C440312E-35F6-4262-A239-5FAB5FD0316F}']
    //打开指纹仪
    procedure Open;stdcall;
    //关闭指纹仪
    procedure Close;stdcall;
    //开始登记
    procedure BeginScroll;stdcall;
    //结束登记
    procedure CancelScroll;stdcall;
    //开始捕获
    procedure BeginCapture;stdcall;
    //结束捕获
    procedure EndCapture;stdcall;
    //添加指纹
    procedure AddFinger(FingerID : Cardinal;FingerDatas : array of OleVariant);stdcall;
    //修改指纹
    procedure UpdateFinger(FingerID : Cardinal;FingerDatas : array of OleVariant);stdcall;
    //删除指纹
    procedure DeleteFinger(FingerID : Cardinal);stdcall;
    //清除指纹
    procedure ClearFingers;stdcall;
    //添加指纹监听
    procedure AddListener(Listener:IFingerListener);stdcall;
    //删除指纹监听
    procedure DeleteListener(Listener:IFingerListener);stdcall;
    //清除指纹监听
    procedure ClearListeners;stdcall;
    //获取监听模式
    function  GetListenMode : byte;stdcall;
    //设置监听模式
    procedure SetListenMode(Mode : byte);stdcall;
    //指纹仪数量
    function GetSensorCount : integer;
    //指纹仪序号
    function GetSensorIndex : integer;
    //指纹仪编码
    function GetSensorSN : WideString;
    //是否在注册中
    function GetIsRegister : boolean;
    //已注册指纹的次数
    function GetEnrollIndex : integer;
    //获取指纹级别精准
    function GetScore : Integer;
    //设置指纹识别精准
    procedure SetScore(Value : Integer);
    //获取指纹仪是否已经被打开
    function GetActive : boolean;
    //监听模式
    property ListenMode : byte read GetListenMode write SetListenMode;
    //指纹仪数量
    property SensorCount : integer read GetSensorCount;
    //指纹仪序号
    property SensorIndex : integer read GetSensorIndex;
    //指纹仪编码
    property SensorSN : WideString read GetSensorSN;
    //是否在登记状态中
    property IsRegister : boolean  read GetIsRegister;
    //已注册指纹的次数
    property EnrollIndex : integer read GetEnrollIndex;
    //指纹识别精准，缺省为8，范围1-10
    property Score : Integer read GetScore write SetScore;
    //指纹仪是否已经被打开
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
