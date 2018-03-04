unit uRsAlcoholLib_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Forms,ComObj,windows, ActiveX,
  RsCameraLib_TLB,RsAlcoholLib_TLB,
  uApparatus,uAlcoBaseDefine,uApparatusCommon,
  uFrmAlcoholUI,uFrmAlcoholUI_PC,uFrmAlcoholUI_ZiZhu, StdVcl;

type

  TAlcoholUI = class(TAutoObject, IAlcoholUI)
  public
    procedure Initialize; override;
  private
    m_TrainmanNumber : WideString;
    m_TrainmanName : WideString;
    m_TrainNo : WideString;
    m_TrainTypeName : WideString;
    m_TrainNumber : WideString;
    m_TestTime : TDateTime;
    m_Picture : OleVariant;
  protected
    function Get_TrainNo: WideString; safecall;
    function Get_TrainTypeName: WideString; safecall;
    function Get_TrainNumber: WideString; safecall;
    function Get_TrainmanName: WideString; safecall;
    function Get_TrainmanNumber: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    procedure Set_TrainTypeName(const Value: WideString); safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    procedure Set_TrainmanName(const Value: WideString); safecall;
    procedure Set_TrainmanNumber(const Value: WideString); safecall;
    function Get_Picture: OleVariant; safecall;
    function Get_TestTime: TDateTime; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    procedure Set_TestTime(Value: TDateTime); safecall;

  end;


  TAlcoholResult = class(TAutoObject,IAlcoholResult)
  protected
    function Get_Alcoholity: Integer; safecall;
    function Get_Picture: OleVariant; safecall;
    function Get_TestResult: Integer; safecall;
    function Get_TestTime: TDateTime; safecall;
    procedure Set_Alcoholity(Value: Integer); safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    procedure Set_TestResult(Value: Integer); safecall;
    procedure Set_TestTime(Value: TDateTime); safecall;
  public
    procedure Initialize; override;
  private
    m_TestResult : integer;
    m_Alcoholity : integer;
    m_TestTime : TDateTime ;
    m_Picture : OleVariant;
  end;



    //测酒接口实现类
  TAlcoholCtl = class(TAutoObject,IAlcoholCtl)
  public
    procedure Initialize; override;
    destructor Destroy;override;
  private
    //测酒选项
    m_Option : IAlcoholOption;
    //显示内容
    m_UI : IAlcoholUI;
    //测酒结果
    m_TestResult : IAlcoholResult;
    //是否已经准备就绪
    m_bTestReadied : boolean;
    //是否已经捕获过照片
    m_bCaptured : boolean;
    //是否已经测试完毕
    m_bTestOk : boolean;
    //测酒控制类
    m_AlcoholTest : TApparatus;
    //摄像头控制类
    m_Camera : ICamera;
    //模式
    m_nMode : Integer ;
    //测酒界面PC显示
    m_ShowForm : TFormAlcoholUI;
   // m_ShowForm : TfrmAlcoholUI_PC;
    //开始测试的毫秒数
    m_StartTick : Cardinal;
  protected
    //测酒仪状态信息通知事件
    procedure OnApparatusInfo(Info: RApparatusInfo);
    //捕获照片事件
    procedure OnPhotoCaptured();
    //用户取消事件
    procedure OnUICancel(Sender : TObject);
    //界面相应超时事件
    procedure OnUITimeOut(Sender : TObject);
    //设置不通状态的显示
    procedure SetUIState(Status : Word);
    //播放不同状态的声音
    procedure PlanLocalSound(Status : Word);
    //处理不同状态的流程
    procedure DealTest(Info: RApparatusInfo);
    //翻译测酒结果
    function GetAlcoholResult(wStatus: Word): TTestAlcoholResult;
  protected
    procedure Test;
    function Get_Option: IAlcoholOption; safecall;
    function Get_TestResult: IAlcoholResult; safecall;
    function Get_UI: IAlcoholUI; safecall;
    procedure StartTest; safecall;
    function Get_Camera: IDispatch; safecall;
    procedure Set_Camera(const Value: IDispatch); safecall;
    function Get_Mode: TAlcoholMode; safecall;
    procedure Set_Mode(Value: TAlcoholMode); safecall;
  end;


implementation

uses ComServ,SysUtils,MMSystem,DateUtils;

function TAlcoholUI.Get_TrainNo: WideString;
begin
  result := m_TrainNo;
end;

function TAlcoholUI.Get_TrainTypeName: WideString;
begin
  result := m_TrainTypeName;
end;

procedure TAlcoholUI.Initialize;
begin
  inherited;
  m_TrainmanNumber := '';
  m_TrainmanName := '';
  m_TrainNo := '';
  m_TrainTypeName := '';
  m_TrainNumber := '';
  m_TestTime := 0;
  m_Picture := varEmpty;
end;

function TAlcoholUI.Get_TrainNumber: WideString;
begin
  result := m_TrainmanNumber;
end;

function TAlcoholUI.Get_TrainmanName: WideString;
begin
  result := m_TrainmanName;
end;

function TAlcoholUI.Get_TrainmanNumber: WideString;
begin
  result := m_TrainmanNumber;
end;

procedure TAlcoholUI.Set_TrainNo(const Value: WideString);
begin
  m_TrainNo := Value;
end;

procedure TAlcoholUI.Set_TrainTypeName(const Value: WideString);
begin
  m_TrainTypeName :=  Value ;
end;

procedure TAlcoholUI.Set_TrainNumber(const Value: WideString);
begin
  m_TrainNumber := Value ;
end;

procedure TAlcoholUI.Set_TrainmanName(const Value: WideString);
begin
  m_TrainmanName := Value ;
end;

procedure TAlcoholUI.Set_TrainmanNumber(const Value: WideString);
begin
  m_TrainmanNumber :=  Value ;
end;

function TAlcoholUI.Get_Picture: OleVariant;
begin
 result := m_Picture;
end;

function TAlcoholUI.Get_TestTime: TDateTime;
begin
  result := m_TestTime;
end;

procedure TAlcoholUI.Set_Picture(Value: OleVariant);
begin
  m_Picture :=  Value ;
end;

procedure TAlcoholUI.Set_TestTime(Value: TDateTime);
begin
  m_TestTime :=  Value ;
end;

function TAlcoholResult.Get_Alcoholity: Integer;
begin
  result := m_Alcoholity;
end;

function TAlcoholResult.Get_Picture: OleVariant;
begin
  result := m_Picture;
end;

function TAlcoholResult.Get_TestResult: Integer;
begin
  result := m_TestResult;
end;

function TAlcoholResult.Get_TestTime: TDateTime;
begin
  result := m_TestTime;
end;

procedure TAlcoholResult.Initialize;
begin
  inherited;
  m_TestResult := 0;
  m_Alcoholity := 0;
  m_TestTime := 0; 
  m_Picture := varEmpty;
end;

procedure TAlcoholResult.Set_Alcoholity(Value: Integer);
begin
  m_Alcoholity := Value;
end;

procedure TAlcoholResult.Set_Picture(Value: OleVariant);
begin
  m_Picture := value;
end;

procedure TAlcoholResult.Set_TestResult(Value: Integer);
begin
  m_TestResult := value;
end;

procedure TAlcoholResult.Set_TestTime(Value: TDateTime);
begin
  m_TestTime := Value;
end;

procedure TAlcoholCtl.DealTest(Info: RApparatusInfo);
var
  data :OleVariant ;
begin
  if Info.wStatus = crReady then
  begin
    m_AlcoholTest.bOnLight := True;
    exit;
  end;
  
  //保存测酒结果
  m_TestResult.TestResult := Ord(GetAlcoholResult(Info.wStatus));
  m_TestResult.Alcoholity := Info.dwAlcoholicity ;
  m_TestResult.TestTime := DateUtils.IncMilliSecond(m_UI.TestTime,GetTickCount-m_StartTick);

  if not m_bCaptured then
  begin
    m_Camera.CaptureBitmap(data);
    m_TestResult.Picture := data;
  end;
  //关闭测酒控制
  m_AlcoholTest.OnApparatusInfoChange := nil;
  m_AlcoholTest.StopTest;
  //关闭摄像头
  m_Camera.Close;
  //关闭显示窗体
  m_ShowForm.CloseUI;
  //测酒完成
  m_bTestOk := true;
end;

destructor TAlcoholCtl.Destroy;
begin
  if m_AlcoholTest <> nil then
  begin
    m_AlcoholTest.OnApparatusInfoChange := nil;
    m_AlcoholTest.OnRunPhoto := nil;
    try
      m_AlcoholTest.StopTest;
      m_AlcoholTest.Close;
      m_AlcoholTest.Free;
    except on e : exception do

    end;
  end;


  m_Option := nil;
  m_UI := nil;
  m_TestResult := nil;
  FreeAndNil(m_ShowForm);
  inherited;
end;

function TAlcoholCtl.GetAlcoholResult(wStatus: Word): TTestAlcoholResult;
begin
  result := taNoTest;
  case wStatus of
    crNormal: Result := taNormal;
    crMore: Result := taAlcoholContentMiddling;
    crMuch: Result := taAlcoholContentHeight;
    crAbnormity: Result := tsError;
  end;
end;

function TAlcoholCtl.Get_Option: IAlcoholOption;
begin
  result := m_Option;
end;

function TAlcoholCtl.Get_TestResult: IAlcoholResult;
begin
  result := m_TestResult;
end;

function TAlcoholCtl.Get_UI: IAlcoholUI;
begin
  result := m_UI;
end;

procedure TAlcoholCtl.Initialize;
var
  hr : Cardinal;
  Factory: IClassFactory;
  tmpIt : IUnknown;
begin
  inherited;
  hr := DllGetClassObject(CLASS_AlcoholOption, IClassFactory, Factory);
  if hr = S_OK then
  try
    hr := Factory.CreateInstance(nil, IUnknown, tmpIt);
    if hr<> S_OK then begin
      raise exception.Create('创建对象CLASS_AlcoholOption失败：' + Inttostr(hr));
    end;
  except on e :Exception do
    begin
      raise exception.Create('创建对象CLASS_AlcoholOption异常：' + IntToStr(GetLastError));
    end;
  end;
  m_Option :=  tmpIt as IAlcoholOption;


  hr := DllGetClassObject(CLASS_AlcoholUI, IClassFactory, Factory);
  if hr = S_OK then
  try
    hr := Factory.CreateInstance(nil, IUnknown, tmpIt);
    if hr<> S_OK then begin
      raise exception.Create('创建对象CLASS_AlcoholUI失败：' + Inttostr(hr));
    end;
  except on e :Exception do
    begin
      raise exception.Create('创建对象CLASS_AlcoholUI异常：' + IntToStr(GetLastError));
    end;
  end;
  m_UI  :=  tmpIt as IAlcoholUI;


  hr := DllGetClassObject(CLASS_AlcoholResult, IClassFactory, Factory);
  if hr = S_OK then
  try
    hr := Factory.CreateInstance(nil, IUnknown, tmpIt);
    if hr<> S_OK then begin
      raise exception.Create('创建对象失败：' + Inttostr(hr));
    end;
  except on e :Exception do
    begin
      raise exception.Create('创建对象异常：' + IntToStr(GetLastError));
    end;
  end;
  m_TestResult := tmpIt as IAlcoholResult;


  m_Camera := nil ;
  m_AlcoholTest := nil;
  m_ShowForm := nil ;
  m_nMode := 0 ;
end;

procedure TAlcoholCtl.OnApparatusInfo(Info: RApparatusInfo);
begin
  {$REGION '过滤不正确的命令'}
  if info.wStatus = crReady then
  begin
    //每次测酒只有第一次就绪,丢弃其他就绪指令
    if m_bTestReadied then
    begin
      exit;
    end;
    //将状态职位已就绪
    m_bTestReadied := true;
  end else
  begin
    //丢弃在测酒仪发出就绪指令之前会偶尔出现饮酒的饮酒指令
    if not m_bTestReadied then
      exit;
  end;
  {$ENDREGION};
  //设置指定状体下窗体的显示
  SetUIState(info.wStatus);
  //播放指定状态的语音
  PlanLocalSound(info.wStatus);
  //处理测酒控制
  DealTest(info);
end;

procedure TAlcoholCtl.OnPhotoCaptured;
var
  data :OleVariant ;
begin
  if not m_bCaptured then
  begin
    m_bCaptured := true;
    m_Camera.CaptureBitmap(data);
    m_TestResult.Picture := data;
  end;
end;

procedure TAlcoholCtl.OnUICancel(Sender: TObject);
var
  info : RApparatusInfo;
begin
  info.dwAlcoholicity := 0;
  info.wStatus := crNotTest;
  //处理测酒控制
  DealTest(info);
end;

procedure TAlcoholCtl.OnUITimeOut(Sender: TObject);
var
  info : RApparatusInfo;
begin
  info.dwAlcoholicity := 0;
  info.wStatus := crTimeOut;
  //处理测酒控制
  DealTest(info);
end;

procedure TAlcoholCtl.PlanLocalSound(Status: Word);
const
  MUSIC_READY :string =  '请测酒.wav' ;
  MUSIC_NORMAL:string = '测试正常.wav';
  MUSIC_MORE :string  = '饮酒.wav';
  MUSIC_MUCH :string  = '酗酒.wav';
  MUSIC_PATH:string   ='Sounds\' ;
var
  strFile,strPath : string ;
begin
  case Status of
    crReady: strFile := MUSIC_READY ;
    crNormal: strFile := MUSIC_NORMAL ;
    crMore: strFile := MUSIC_MORE ;
    crMuch: strFile := MUSIC_MUCH ;
  end;

  strPath := ExtractFilePath(Application.ExeName) + MUSIC_PATH;
  strFile := strPath + strFile;
  //如果文件存在且使用本地播放
  if ( FileExists(strFile) ) and ( m_Option.LocalSound )then
  begin
    PlaySound(Pchar(strFile),Application.Handle,SND_FILENAME or SND_ASYNC);
  end;
end;

procedure TAlcoholCtl.SetUIState(Status: Word);
begin
  case Status of
    crReady  : m_ShowForm.SetReady;
    crNormal : m_ShowForm.SetNormal;
    crMore   : m_ShowForm.SetMore;
    crMuch   : m_ShowForm.SetMuch;
  end;
end;

procedure TAlcoholCtl.Test;
var
  nRet :Integer ;
  strText:string;
begin
  if m_AlcoholTest <> nil then
    FreeAndNil(m_AlcoholTest);
  //初始化测酒仪控制类
  m_AlcoholTest := TApparatus.Create(nil);
  m_AlcoholTest.bDisplayGongHao := true;
  m_AlcoholTest.bDisplayDrinkResult := true;
  m_AlcoholTest.OnRunPhoto := OnPhotoCaptured;
  m_AlcoholTest.OnApparatusInfoChange := OnApparatusInfo;
  m_AlcoholTest.strName := m_UI.TrainmanName;
  m_AlcoholTest.strNo := m_UI.TrainmanNumber;

  //初始化摄像头控制类
  if m_nMode = amPC  then
    m_ShowForm :=  TFrmAlcoholUI_PC.Create(nil)   
  else
     m_ShowForm := TFrmAlcoholUI_ZiZhu.Create(nil)  ;

  m_Camera.TargetHandle := m_ShowForm.CameraHandle;

  m_ShowForm.SetPos(m_Option.Position);
  m_ShowForm.InitUI(m_UI);

  //打开摄像头
  if not m_Camera.Open then
  begin
    m_ShowForm.SetError('打开摄像头失败');
  end;
  //打开测酒仪
  if not m_AlcoholTest.Open then
  begin
    m_ShowForm.SetError('打开测酒仪失败');
  end;
  m_StartTick := GetTickCount;
  m_AlcoholTest.StartTest(false);
  //开始测酒
  m_bTestReadied := false;
  m_bCaptured := false;
  m_bTestOk := false;
  //显示测酒窗体，并将测酒状体置为就绪状态
  m_ShowForm.OnCancel := OnUICancel;
  m_ShowForm.OnTimeOut := OnUITimeOut;
  nRet := m_ShowForm.ShowModal;
  //释放
  FreeAndNil(m_ShowForm);
  strText := IntToStr(nRet);
end;


procedure TAlcoholCtl.StartTest;
begin
  Test;
end;

function TAlcoholCtl.Get_Camera: IDispatch;
begin
  result := m_Camera ;
end;

procedure TAlcoholCtl.Set_Camera(const Value: IDispatch);
begin
  m_Camera := Value as ICamera ;
end;

function TAlcoholCtl.Get_Mode: TAlcoholMode;
begin
  Result :=  m_nMode ;
end;

procedure TAlcoholCtl.Set_Mode(Value: TAlcoholMode);
begin
  m_nMode := Value ;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAlcoholUI, Class_AlcoholUI,
    ciMultiInstance, tmApartment);

  TAutoObjectFactory.Create(ComServer, TAlcoholResult, CLASS_AlcoholResult,
    ciMultiInstance, tmApartment);

  TAutoObjectFactory.Create(ComServer, TAlcoholCtl, CLASS_AlcoholCtl,
    ciMultiInstance, tmApartment);
end.
