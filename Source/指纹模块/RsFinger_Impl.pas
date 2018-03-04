unit RsFinger_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX,AxCtrls,windows, Messages,RsFingerLib_TLB, graphics,Classes,ZKFPEngXControl_TLB,
  ZKFPEngXUtils,uTFVariantUtils,StdVcl;


const
  WM_MSGFingerCapture = WM_User + 11;
  WM_MSGFingerEnorll = WM_USER + 12;
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;
type


  TRsFinger = class(TAutoObject, IRsFinger)
  public
    destructor Destroy;override;
    procedure Initialize; override;
  protected
    //打开指纹仪
    procedure Open; safecall;
    //关闭指纹仪
    procedure Close; safecall;
    //开始登记
    procedure BeginScroll; safecall;
    //结束登记
    procedure CancelScroll; safecall;
    //开始捕获
    procedure BeginCapture; safecall;
    //结束捕获
    procedure EndCapture; safecall;
    procedure AddFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure UpdateFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure DeleteFinger(FingerID: Integer); safecall;
    //清除指纹
    procedure ClearFingers; safecall;

    function Get_ListenMode: Integer; safecall;
    procedure Set_ListenMode(Value: Integer); safecall;

    //添加指纹监听
    procedure AddListener(const Listener: IFingerListener); safecall;
    //删除指纹监听
    procedure ClearListeners; safecall;
    //清除指纹监听
    procedure DeleteListener(const Listener: IFingerListener); safecall;

     //指纹仪序号
    function Get_SensorIndex: Integer; safecall;
     //指纹仪数量
    function Get_SensorCount: Integer; safecall;
    //指纹仪编码
    function Get_SensorSN: WideString; safecall;
    function Get_IsRegister: WordBool; safecall;
    //已注册指纹的次数
    function Get_EnrollIndex: Integer; safecall;
    //指纹识别精准，缺省为8，范围1-10
    function Get_Score: Integer; safecall;
    procedure Set_Score(Value: Integer); safecall;
    function Get_Acitve: WordBool; safecall;
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
  ComServ,DSUtil,SysUtils,Variants;

procedure TRsFinger.Open;
var
  initRlt : Integer;
  strFailReasion : string;
begin
  if ZKFPEngActiveXExist() = false then
  begin
    raise exception.Create('"Biokey.ocx"未注册!');
    Exit;    
  end;

  //如果已经创建了缓存区则重新初始化
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);

  //如果已经创建过则重新初始化指纹仪控组
  if m_ZKFPEngX <> nil then
    FreeAndNil(m_ZKFPEngX);
  m_ZKFPEngX := TZKFPEngX.Create(nil);

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

procedure TRsFinger.Close;
begin
  if m_ZKFPEngX <> nil then
    m_ZKFPEngX.EndEngine;
end;



procedure TRsFinger.BeginScroll;
begin
  m_ZKFPEngX.BeginEnroll;
end;

procedure TRsFinger.CancelScroll;
begin
  m_ZKFPEngX.CancelEnroll;
end;

procedure TRsFinger.BeginCapture;
begin
  m_ZKFPEngX.BeginCapture;
end;

procedure TRsFinger.EndCapture;
begin
  m_ZKFPEngX.CancelCapture;
end;



procedure TRsFinger.FeatureInfo(ASender: TObject; AQuality: Integer);
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

procedure TRsFinger.FingerCaptureProc(ASender: TObject; ActionResult: WordBool;
  ATemplate: OleVariant);
begin
  PostMessage(m_FingerMsgHandle,WM_MSGFingerCapture,0,0);
end;

procedure TRsFinger.FingerEnroll(Sender: TObject; ActionResult: WordBool;
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

procedure TRsFinger.AddFinger(FingerID: Integer; FingerDatas: OleVariant);
var
  i: integer;
  fingerArray : array of Variant ;
begin
  fingerArray := FingerDatas ;
  for i:= 0 to length(fingerArray) - 1 do
  begin
    m_FingerBufferManage.AddFingerPrint(fingerArray[i],FingerID);
  end;
end;



procedure TRsFinger.UpdateFinger(FingerID: Integer; FingerDatas: OleVariant);
var
  i: Integer;
  fingerArray : array of Variant ;
begin
  //修改缓存
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
  fingerArray := FingerDatas ;
  for i:= 0 to length(fingerArray) - 1 do
  begin
    m_FingerBufferManage.AddFingerPrint(fingerArray[i],FingerID);
  end;
end;


procedure TRsFinger.WndProc(var Msg: TMessage);
var
  strMessage:string;
  nFindFingerID : integer;
  I: Integer;
  bmp : graphics.TBitmap;
  ms : TMemoryStream;
  bCapture : boolean;
begin
  strMessage := format('TRsFinger 消息:%d',[msg.Msg]);
  OutputDebugString(pansichar(strMessage));
  if m_ZKFPEngX = nil then
    exit;
  
  m_ZKFPEngX.OnCapture := nil;
  m_ZKFPEngX.OnImageReceived := nil;
  try
{$REGION '消息处理'}
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
  {$ENDREGION}
  finally
    m_ZKFPEngX.OnCapture := FingerCaptureProc;
    m_ZKFPEngX.OnImageReceived := ImageReceived;
  end;
end;

procedure TRsFinger.DeleteFinger(FingerID: Integer);
begin
  //删除缓存
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
end;

procedure TRsFinger.ClearFingers;
begin
   //此处需要循环清除本地文件
  m_FingerBufferManage.FingerBufferInfoList.Clear;
end;



destructor TRsFinger.Destroy;
begin
  OutputDebugString(pansichar('TRsFinger.Destroy_begin'));
  //注销消息
  OutputDebugString(pansichar(inttostr(m_FingerMsgHandle)))  ;
  if m_FingerMsgHandle <> 0 then
    DeallocateHWnd(m_FingerMsgHandle);
  OutputDebugString(pansichar('TRsFinger.Destroy-----DeallocateHWnd'));
  //释放指纹仪缓冲控制对象
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  //释放指纹仪控件
  OutputDebugString(pansichar('TRsFinger.Destroy------释放指纹仪控件'));
  if m_ZKFPEngX <> nil then
  begin
    OutputDebugString(pansichar('TRsFinger.Destroy---CancelEnroll'));
    if m_ZKFPEngX.IsRegister then
      m_ZKFPEngX.CancelEnroll;
    OutputDebugString(pansichar('TRsFinger.Destroy---CancelCapture'));
    m_ZKFPEngX.CancelCapture;

    m_ZKFPEngX.OnFeatureInfo := nil;
    m_ZKFPEngX.OnImageReceived := nil;
    m_ZKFPEngX.OnEnroll := nil;
    m_ZKFPEngX.OnCapture := nil;
    OutputDebugString(pansichar('TRsFinger.Destroy---清空事件'));

    m_ZKFPEngX.EndEngine;
    FreeAndNil(m_ZKFPEngX);
    OutputDebugString(pansichar('TRsFinger.Destroy---EndEngine和释放'));
  end;
  OutputDebugString(pansichar('TRsFinger.Destroy---ListenerList释放'));
  m_ListenerList := nil ;
end;





function TRsFinger.Get_ListenMode: Integer;
begin
  result := m_ListenMode;
end;

procedure TRsFinger.Set_ListenMode(Value: Integer);
begin
  m_ListenMode := Value;
end;




function TRsFinger.Get_SensorCount: Integer;
begin
  result := m_ZKFPEngX.SensorCount;
end;

function TRsFinger.Get_SensorIndex: Integer;
begin
  result := m_ZKFPEngX.SensorIndex;
end;



function TRsFinger.Get_SensorSN: WideString;
begin
  result := m_ZKFPEngX.SensorSN;
end;



procedure TRsFinger.ImageReceived(Sender: TObject; var AImageValid: WordBool);
begin
  PostMessage(m_FingerMsgHandle,WM_MSGImageReceived,0,0);
end;

procedure TRsFinger.Initialize;
begin
  OutputDebugString('TRsFinger.Initialize');
  m_Score := 8;
  m_ZKFPEngX := nil;
  m_ListenMode := Ord(flmSignle);
  m_FingerMsgHandle := AllocateHWnd(WndProc);
  m_ListenerList := TInterfaceList.Create;
  inherited;
end;

function TRsFinger.Get_IsRegister: WordBool;
begin
  result := m_ZKFPEngX.IsRegister;
end;



function TRsFinger.Get_EnrollIndex: Integer;
begin
  result := m_ZKFPEngX.EnrollIndex;
end;



function TRsFinger.Get_Score: Integer;
begin
 result := m_Score;
end;



function TRsFinger.Get_Acitve: WordBool;
begin
  result := false;
  if m_ZKFPEngX = nil then exit;
  result := m_ZKFPEngX.Active;
end;



procedure TRsFinger.Set_Score(Value: Integer);
begin
  if Value in[1..10] then
  begin
    m_Score := value;
  end;
end;



procedure TRsFinger.AddListener(const Listener: IFingerListener);
begin
  m_ListenerList.Add(Listener);
end;

procedure TRsFinger.ClearListeners;
begin
  m_ListenerList.Clear;
end;

procedure TRsFinger.DeleteListener(const Listener: IFingerListener);
begin
  m_ListenerList.Remove(Listener);

end;

initialization

  TAutoObjectFactory.Create(ComServer, TRsFinger, Class_RsFinger,
    ciMultiInstance, tmApartment);
end.
