unit uRsFingerImpl;

interface
uses
  Windows,Classes,Messages,graphics,ZKFPEngXControl_TLB,ZKFPEngXUtils,uTFVariantUtils,
  uRsFingerLib,uRsLibClass,uRsLibUtils,uRsLibPoolLib;
const
  WM_MSGFingerCapture = WM_User + 11;
  WM_MSGFingerEnorll = WM_USER + 12;
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;
type
  ///日志组件配置信息读取设置类
  TFinger = class(TRsLibEntry,IFinger)
  public
    constructor Create;override;
    destructor Destroy;override;
  public
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
  protected
    //指纹识别事件
    procedure FingerCaptureProc(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    //指纹仪图像接收事件
    procedure ImageReceived(Sender: TObject;var AImageValid: WordBool);
    //指纹仪图像接收事件
    procedure FingerEnroll(Sender:TObject ;ActionResult: WordBool;ATemplate: OleVariant);
    //指纹登记通知事件
    procedure FeatureInfo(ASender: TObject; AQuality: Integer);
  private
    //指纹仪控件
    m_ZKFPEngX : TZKFPEngX;
    //指纹缓冲区操作管理
    m_FingerBufferManage: TFingerBufferManage;
    //{指纹仪高速缓冲空间}
    m_fpcHandle: Integer;
    //接收指纹消息的句柄
    m_FingerMsgHandle : Integer;
    //监听对象列表
    m_ListenerList : IInterfaceList;
    //监听模式
    m_ListenMode : integer;
    //指纹识别精准度
    m_Score : integer;
    //消息处理函数
    procedure WndProc(var Msg : TMessage);
  end;
implementation
uses
  Forms,DSUtil,SysUtils,Variants;
{ TFinger }

procedure TFinger.AddFinger(FingerID: Cardinal;FingerDatas: array of OleVariant);
var
  i : integer;
begin
  for i:= 0 to length(FingerDatas) - 1 do
  begin
    m_FingerBufferManage.AddFingerPrint(FingerDatas[i],FingerID);
  end;
end;

procedure TFinger.AddListener(Listener: IFingerListener);
begin
  m_ListenerList.Add(Listener);
end;

procedure TFinger.BeginCapture;
begin
  m_ZKFPEngX.BeginCapture;
end;

procedure TFinger.BeginScroll;
begin
  m_ZKFPEngX.BeginEnroll;
end;

procedure TFinger.CancelScroll;
begin
  m_ZKFPEngX.CancelEnroll;
end;

procedure TFinger.ClearFingers;
begin
  //此处需要循环清除本地文件
  m_FingerBufferManage.FingerBufferInfoList.Clear;
end;

procedure TFinger.ClearListeners;
begin
  m_ListenerList.Clear;
end;

procedure TFinger.Close;
begin
  if m_ZKFPEngX <> nil then
    m_ZKFPEngX.EndEngine;
end;

constructor TFinger.Create;
begin
  m_Score := 8;
  m_ZKFPEngX := nil;
  m_ListenMode := Ord(flmSignle);
  m_ListenerList := TInterfaceList.Create;
  m_FingerMsgHandle := AllocateHWnd(WndProc);
end;

procedure TFinger.DeleteFinger(FingerID: Cardinal);stdcall;
begin
  //删除缓存
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
end;

procedure TFinger.DeleteListener(Listener: IFingerListener);
begin
  m_ListenerList.Remove(Listener);
end;

destructor TFinger.Destroy;
begin
  //注销消息
  DeallocateHWnd(m_FingerMsgHandle);
  //释放指纹仪缓冲控制对象
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);

  //释放指纹仪控件
  if m_ZKFPEngX <> nil then
  begin
    if m_ZKFPEngX.IsRegister then
      m_ZKFPEngX.CancelEnroll;
    m_ZKFPEngX.CancelCapture;

    m_ZKFPEngX.OnFeatureInfo := nil;
    m_ZKFPEngX.OnImageReceived := nil;
    m_ZKFPEngX.OnEnroll := nil;
    m_ZKFPEngX.OnCapture := nil;

    m_ZKFPEngX.EndEngine;
    //释放指纹仪缓存空间
    if m_fpcHandle <> -1 then
      m_ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
    FreeAndNil(m_ZKFPEngX);
  end;

  //清空监听
  m_ListenerList := nil;
  inherited;
end;

procedure TFinger.EndCapture;
begin
  m_ZKFPEngX.CancelCapture;
end;

procedure TFinger.FeatureInfo(ASender: TObject; AQuality: Integer);
var
  i : integer;
begin
   //单个模式，将捕获结果发送给最后一个注册的监听着
  if m_ListenMode = ord(flmSignle) then
  begin
    if m_ListenerList.Count = 0 then exit;

    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FeatureInfo(AQuality);
  end;
  //广播模式将结果广播给每一个接收者
  if m_ListenMode = ord(flmBoardCast) then
  for I := 0 to m_ListenerList.Count - 1 do
  begin
    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FeatureInfo(AQuality);
  end;
end;

procedure TFinger.FingerCaptureProc(ASender: TObject; ActionResult: WordBool;
  ATemplate: OleVariant);
begin
  PostMessage(m_FingerMsgHandle,WM_MSGFingerCapture,0,0);
end;

procedure TFinger.FingerEnroll(Sender: TObject; ActionResult: WordBool;
  ATemplate: OleVariant);
var
  i : integer;
begin
   //单个模式，将捕获结果发送给最后一个注册的监听着
  if m_ListenMode = ord(flmSignle) then
  begin
    if m_ListenerList.Count = 0 then exit;

    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerScroll(ActionResult,ATemplate);
  end;
  //广播模式将结果广播给每一个接收者
  if m_ListenMode = ord(flmBoardCast) then
  for I := 0 to m_ListenerList.Count - 1 do
  begin
    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerScroll(ActionResult,ATemplate);
  end;
end;


function TFinger.GetActive: boolean;
begin
  result := false;
  if m_ZKFPEngX = nil then exit;
  result := m_ZKFPEngX.Active;
end;

function TFinger.GetEnrollIndex: integer;
begin
  result := m_ZKFPEngX.EnrollIndex;
end;

function TFinger.GetIsRegister: boolean;
begin
  result := m_ZKFPEngX.IsRegister;
end;

function TFinger.GetListenMode: byte;
begin
  result := m_ListenMode;
end;

function TFinger.GetScore: Integer;
begin
 result := m_Score;
end;

function TFinger.GetSensorCount: integer;
begin
  result := m_ZKFPEngX.SensorCount;
end;

function TFinger.GetSensorIndex: integer;
begin
  result := m_ZKFPEngX.SensorIndex;
end;

function TFinger.GetSensorSN: WideString;
begin
  result := m_ZKFPEngX.SensorSN;
end;

procedure TFinger.ImageReceived(Sender: TObject; var AImageValid: WordBool);
begin
  PostMessage(m_FingerMsgHandle,WM_MSGImageReceived,0,0);
end;

procedure TFinger.Open;
var
  initRlt : Integer;
  strFailReasion : string;
begin
  if ZKFPEngActiveXExist() = false then
  begin
    raise exception.Create('"Biokey.ocx"未注册!');
    Exit;    
  end;

  //如果已经创建过则重新初始化指纹仪控组
  if m_ZKFPEngX <> nil then
    FreeAndNil(m_ZKFPEngX);
  m_ZKFPEngX := TZKFPEngX.Create(nil);

   //初始化指纹仪缓存池
  if m_fpcHandle <> -1 then
    m_ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
  m_fpcHandle := m_ZKFPEngX.CreateFPCacheDB();
  
  if m_fpcHandle = 0 then
    raise exception.Create('创建ZKFPEngX失败!');
    
  //如果已经创建了缓存区则重新初始化
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  m_FingerBufferManage := TFingerBufferManage.Create(m_ZKFPEngX);

  strFailReasion:='';
  try
    initRlt := m_ZKFPEngX.InitEngine;
  except
    on E : Exception do
    begin
      strFailReasion := '指纹仪打开失败,原因：' + E.Message;
      raise exception.Create(strFailReasion);
    end;
  end;  
  case initRlt of
    1: strFailReasion := '驱动程序加载失败!';
    2: strFailReasion := '指纹仪USB连接出现故障!';
    3: strFailReasion := '指纹仪序号不存在或被占用!';
  end;
  if strFailReasion <> '' then
  begin
    raise exception.Create(strFailReasion);
  end;
  //捕捉到指纹触发
  m_ZKFPEngX.OnCapture := FingerCaptureProc;
  m_ZKFPEngX.OnImageReceived := ImageReceived;
  m_ZKFPEngX.OnEnroll := FingerEnroll;
  m_ZKFPEngX.OnFeatureInfo := FeatureInfo;
end;
procedure TFinger.SetListenMode(Mode: byte);
begin
  m_ListenMode := Mode;
end;


procedure TFinger.SetScore(Value: Integer);
begin
  if Value in[1..10] then
  begin
    m_Score := value;
  end;
end;

procedure TFinger.UpdateFinger(FingerID: Cardinal;FingerDatas : array of OleVariant);
var
  i: Integer;
begin
  //修改缓存
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
  for i := 0 to length(FingerDatas) - 1 do
  begin
    m_FingerBufferManage.AddFingerPrint(FingerDatas[i],FingerID);
  end;
end;

procedure TFinger.WndProc(var Msg: TMessage);
var
  nFindFingerID : integer;
  I: Integer;
  bmp : graphics.TBitmap;
  ms : TMemoryStream;
  bCapture : boolean;
begin
  m_ZKFPEngX.OnCapture := nil;
  m_ZKFPEngX.OnImageReceived := nil;
  try
    //捕获指纹消息
    if Msg.Msg = WM_MSGFingerCapture then
    begin
      //判断指纹是否已经在内存中
      m_FingerBufferManage.Score := m_Score;
      bCapture := m_FingerBufferManage.FindFingerPrint(m_ZKFPEngX.GetTemplate,nFindFingerID);
      //单个模式，将捕获结果发送给最后一个注册的监听着
      if m_ListenMode = ord(flmSignle) then
      begin
        if m_ListenerList.Count = 0 then exit;
        if bCapture then
          (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerSuccess(nFindFingerID)
        else
          (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerFailure
      end
      //广播模式将结果广播给每一个接收者
      else if m_ListenMode = ord(flmBoardCast) then
      for I := 0 to m_ListenerList.Count - 1 do
      begin
        if bCapture then
          (m_ListenerList.Items[i] as IFingerListener).FingerSuccess(nFindFingerID)
        else
          (m_ListenerList.Items[i] as IFingerListener).FingerFailure
      end;
    end
    //用户按下消息
    else if Msg.Msg = WM_MSGImageReceived then
    begin
       //单个模式，将捕获结果发送给最后一个注册的监听着
      if m_ListenMode = ord(flmSignle) then
      begin
        if m_ListenerList.Count = 0 then exit;
        bmp := TBitmap.Create;
        ms := TMemoryStream.Create;
        try
          bmp.Width := m_ZKFPEngX.ImageWidth;
          bmp.Height := m_ZKFPEngX.ImageHeight;
          m_ZKFPEngX.PrintImageAt(bmp.Canvas.Handle,0,0,bmp.Width,bmp.Height);
          bmp.SaveToStream(ms);
          (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerTouching(StreamToTemplateOleVariant(ms));
        finally
          bmp.Free;
          ms.Free;;
        end;
      end;
      //广播模式将结果广播给每一个接收者
      if m_ListenMode = ord(flmBoardCast) then
      for I := 0 to m_ListenerList.Count - 1 do
      begin
        (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerTouching(m_ZKFPEngX.GetTemplate);
      end;
    end;
  finally
    m_ZKFPEngX.OnCapture := FingerCaptureProc;
    m_ZKFPEngX.OnImageReceived := ImageReceived;
  end;
end;

end.
