unit RsTMFP_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsTMFPLib_TLB, StdVcl,Classes,
  RsGlobal_TLB,uFingerCtls,uHttpWebAPI,uTFSystem,uFrmTrainmanIdentity,uTrainman;

type
  TRsTMFP = class(TInterfacedObject, IRsTMFP)
  public
    destructor Destroy;override;
    constructor Create;
  protected
    procedure LoadLocalTrainmans(ShowProgress: WordBool); safecall;
    procedure UpdateTrainmans(ShowProgress: WordBool); safecall;
    function Get_InitSucceed: WordBool; safecall;
    procedure AddListener(const Listener: IRsFingerListener); safecall;
    procedure RegFinger(const TrainmanNumber: WideString); safecall;
    function Get_Global: IUnknown; safecall;
    procedure Set_Global(const Value: IUnknown); safecall;
    function GetTrainmanByNumber(const TrainmanNumber: WideString;
      out Trainman: IRsFingerTrainman): WordBool; safecall;
    procedure DelListener(const Listener: IRsFingerListener); safecall;
    procedure Init; safecall;
    function Get_LocalIdentity: WordBool; safecall;
    procedure Set_LocalIdentity(Value: WordBool); safecall;
  private
    m_FingerPrintCtl: TFingerPrintCtl;

    m_webAPIUtils : TWebAPIUtils;
    //监听对象列表
    m_ListenerList : IInterfaceList;
    //指纹验证窗口
    m_ListenForm : TFrmTrainmanIdentity;
  private
    m_Global : IGlobalProxy;
    procedure FingerTouch(Sender : TObject);
    procedure FingerLoginSuccess(Text : string);
    procedure FingerLoginFail(Sender : TObject);
    procedure TrainmanIdentity(TrainmanNumber : string;VerifyID : integer);
  end;
  TRsFingerTrainman = class(TInterfacedObject, IRsFingerTrainman)
  protected
    function Get_TrainmanGUID: WideString; safecall;
    procedure Set_TrainmanGUID(const Value: WideString); safecall;
    function Get_TrainmanID: Integer; safecall;
    procedure Set_TrainmanID(Value: Integer); safecall;
    function Get_TrainmanNumber: WideString; safecall;
    procedure Set_TrainmanNumber(const Value: WideString); safecall;
    function Get_TrainmanName: WideString; safecall;
    procedure Set_TrainmanName(const Value: WideString); safecall;
    function Get_FingerPrint1: OleVariant; safecall;
    procedure Set_FingerPrint1(Value: OleVariant); safecall;
    function Get_FingerPrint2: OleVariant; safecall;
    procedure Set_FingerPrint2(Value: OleVariant); safecall;
    function Get_Picture: OleVariant; safecall;
    procedure Set_Picture(Value: OleVariant); safecall;
    property TrainmanGUID: WideString read Get_TrainmanGUID write Set_TrainmanGUID;
    property TrainmanID: Integer read Get_TrainmanID write Set_TrainmanID;
    property TrainmanNumber: WideString read Get_TrainmanNumber write Set_TrainmanNumber;
    property TrainmanName: WideString read Get_TrainmanName write Set_TrainmanName;
    property FingerPrint1: OleVariant read Get_FingerPrint1 write Set_FingerPrint1;
    property FingerPrint2: OleVariant read Get_FingerPrint2 write Set_FingerPrint2;
    property Picture: OleVariant read Get_Picture write Set_Picture;
  private
    m_TrainmanGUID : WideString;
    m_TrainmanID : Integer;
    m_TrainmanNumber : WideString;
    m_TrainmanName : WideString;
    m_FingerPrint1 : OleVariant;
    m_FingerPrint2 : OleVariant;
    m_Picture : OleVariant;
  end;
  TRsFingerUtils = class(TAutoObject, IRsFingerUtils)
  protected
    function GetProxy: IRsFingerProxy; safecall;
  end;
  TRsFingerProxy = class(TInterfacedObject,IRsFingerProxy)
  public
    constructor Create;
    destructor Destroy;override;
  protected
    function Get_RsTrainmanFP: IRsTMFP; safecall;
    procedure Set_RsTrainmanFP(const Value: IRsTMFP); safecall;
    property RsTrainmanFP: IRsTMFP read Get_RsTrainmanFP write Set_RsTrainmanFP;
  public
    m_TrainmanFP : IRsTMFP;
  end;
implementation

uses ComServ,uFrmFingerLoadProgress,SysUtils,uFrmTrainmanPicFigEdit;

var
  _FingerProxy: IRsFingerProxy = nil;
procedure TRsTMFP.LoadLocalTrainmans(ShowProgress: WordBool);
var
  readEvent : TOnReadChangeEvent; 
begin
  if not m_FingerPrintCtl.InitSuccess then
  begin
    if not m_FingerPrintCtl.Init then
    begin
      Box('指纹仪初始化失败,无法加载人员及指纹信息');
      exit;
    end;
  end;
  try
    readEvent := nil;
    if ShowProgress then
      readEvent := TFrmFingerLoadProgress.ShowProgress();
    m_FingerPrintCtl.LoadLocalTM(readEvent);
    m_FingerPrintCtl.SynFingerLoader.Start();
  finally
    TFrmFingerLoadProgress.CloseProgress();
  end;
end;

procedure TRsTMFP.UpdateTrainmans(ShowProgress: WordBool);
var
  readEvent : TOnReadChangeEvent; 
begin
  if not m_FingerPrintCtl.InitSuccess then
  begin
    if not m_FingerPrintCtl.Init then
    begin
      Box('指纹仪初始化失败,无法更新人员及指纹信息');
      exit;
    end;
  end;
  try
    readEvent := nil;
    if ShowProgress then
      readEvent := TFrmFingerLoadProgress.ShowProgress();
    m_FingerPrintCtl.LoadServerTM(readEvent);
    m_FingerPrintCtl.SynFingerLoader.Start();
  finally
    TFrmFingerLoadProgress.CloseProgress();
  end;
end;


function TRsTMFP.Get_InitSucceed: WordBool;
begin
  result := false;
  if m_FingerPrintCtl = nil then exit;

  result := m_FingerPrintCtl.InitSuccess;
end;

procedure TRsTMFP.AddListener(const Listener: IRsFingerListener);
begin
  m_ListenerList.Add(Listener);
end;

procedure TRsTMFP.RegFinger(const TrainmanNumber: WideString);
begin
  ModifyTrainmanPicFig(m_Global,m_FingerPrintCtl,TrainmanNumber) ;
end;


procedure TRsTMFP.TrainmanIdentity(TrainmanNumber: string; VerifyID: integer);
var
  fingerTM : IRsFingerTrainman;
  tm : RRsTrainman;
begin
 if m_ListenerList.Count > 0 then
 begin
   fingerTM := TRsFingerTrainman.Create;
   if not m_FingerPrintCtl.FindTmByNumber(TrainmanNumber,tm) then
   begin
     Box('错误的工号:' + TrainmanNumber);
     exit;
   end;
   fingerTM.TrainmanGUID := tm.strTrainmanGUID;
   fingerTM.TrainmanID := tm.nID;
   fingerTM.TrainmanNumber := tm.strTrainmanNumber;
   fingerTM.TrainmanName := tm.strTrainmanName;
   fingerTM.FingerPrint1 := tm.FingerPrint1;
   fingerTM.FingerPrint2 := tm.FingerPrint2;
   fingerTM.Picture := tm.Picture;
   (m_ListenerList.Items[m_ListenerList.Count-1] as irsFingerListener).CaptureTrainman(fingerTM);
 end;
end;

function TRsTMFP.Get_Global: IUnknown;
begin
  result := m_Global;
end;

procedure TRsTMFP.Set_Global(const Value: IUnknown);
begin
  m_Global := Value as IGlobalProxy;
end;



function TRsTMFP.GetTrainmanByNumber(const TrainmanNumber: WideString;
  out Trainman: IRsFingerTrainman): WordBool;
var
  tm : RRsTrainman;
begin
  result :=  m_FingerPrintCtl.FindTmByNumber(TrainmanNumber,tm);
  if Result then
  begin
    Trainman := TRsFingerTrainman.Create;
    Trainman.TrainmanGUID := tm.strTrainmanGUID;
    Trainman.TrainmanID := tm.nID;
    Trainman.TrainmanNumber := tm.strTrainmanNumber;
    Trainman.TrainmanName := tm.strTrainmanName;
    Trainman.FingerPrint1 := tm.FingerPrint1;
    Trainman.FingerPrint2 := tm.FingerPrint2;
    Trainman.Picture := tm.Picture;
  end;
end;

procedure TRsTMFP.DelListener(const Listener: IRsFingerListener);
begin
  m_ListenerList.Remove(Listener);
end;

destructor TRsTMFP.Destroy;
begin
  inherited;
  m_webAPIUtils.Free;
  m_FingerPrintCtl.Free;
  m_ListenerList := nil;
  m_ListenForm.Free;
end;

procedure TRsTMFP.FingerLoginFail(Sender: TObject);
begin
  if m_ListenerList.Count = 0 then exit;
  m_ListenForm.ShowFail;
end;

procedure TRsTMFP.FingerLoginSuccess(Text: string);
var
  tm : RRsTrainman;
begin
  if m_ListenerList.Count = 0 then exit;
  if m_FingerPrintCtl.FindTmByNumber(Text,tm) then
  begin
    m_ListenForm.ShowSuccess(Text,tm.strTrainmanName,tm.Picture);
  end;
end;

procedure TRsTMFP.FingerTouch(Sender: TObject);
var
  Img : OleVariant;
begin
  if m_ListenerList.Count = 0 then exit;
  
  if m_FingerPrintCtl.ZKFPEngX.GetFingerImage(Img) then
    m_ListenForm.ShowTouch(Img);
end;

procedure TRsTMFP.Init;
var
  appPath : string;
begin
  appPath :=  ExtractFilePath(ParamStr(0));
  m_webAPIUtils := TWebAPIUtils.Create;
  m_webAPIUtils.Host := m_Global.WebAPI.Host;
  m_webAPIUtils.Port := m_Global.WebAPI.Port;
  m_webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  m_FingerPrintCtl := TFingerPrintCtl.Create(AppPath,m_webAPIUtils);
  m_FingerPrintCtl.Init;
  m_FingerPrintCtl.OnTouch := FingerTouch;
  m_FingerPrintCtl.OnLoginSuccess := FingerLoginSuccess;
  m_FingerPrintCtl.OnLoginFail := FingerLoginFail;
  m_ListenForm := TFrmTrainmanIdentity.Create(nil);
  m_ListenForm.OnIdentity := TrainmanIdentity;
end;

constructor TRsTMFP.Create;
begin
  inherited;
  m_ListenerList := TInterfaceList.Create;
  inherited;
end;

{ TRsFingerTrainman }

function TRsFingerTrainman.Get_FingerPrint1: OleVariant;
begin
  result := m_FingerPrint1;
end;

function TRsFingerTrainman.Get_FingerPrint2: OleVariant;
begin
  result := m_FingerPrint2;
end;

function TRsFingerTrainman.Get_Picture: OleVariant;
begin
  result := m_Picture;
end;

function TRsFingerTrainman.Get_TrainmanGUID: WideString;
begin
  result := m_TrainmanGUID;
end;

function TRsFingerTrainman.Get_TrainmanID: Integer;
begin
   result := m_TrainmanID;
end;

function TRsFingerTrainman.Get_TrainmanName: WideString;
begin
  result := m_TrainmanName;
end;

function TRsFingerTrainman.Get_TrainmanNumber: WideString;
begin
  result := m_TrainmanNumber;
end;

procedure TRsFingerTrainman.Set_FingerPrint1(Value: OleVariant);
begin
  m_FingerPrint1 := value;
end;

procedure TRsFingerTrainman.Set_FingerPrint2(Value: OleVariant);
begin
  m_FingerPrint2 := value;
end;

procedure TRsFingerTrainman.Set_Picture(Value: OleVariant);
begin
  m_Picture := Value;
end;

procedure TRsFingerTrainman.Set_TrainmanGUID(const Value: WideString);
begin
  m_TrainmanGUID := value;
end;

procedure TRsFingerTrainman.Set_TrainmanID(Value: Integer);
begin
  m_TrainmanID := Value;
end;

procedure TRsFingerTrainman.Set_TrainmanName(const Value: WideString);
begin
  m_TrainmanName := Value;
end;

procedure TRsFingerTrainman.Set_TrainmanNumber(const Value: WideString);
begin
  m_TrainmanNumber := Value;
end;

function TRsTMFP.Get_LocalIdentity: WordBool;
begin
  result := m_FingerPrintCtl.UseLocalTM;
end;

procedure TRsTMFP.Set_LocalIdentity(Value: WordBool);
begin
  m_FingerPrintCtl.UseLocalTM := Value;
end;

function TRsFingerUtils.GetProxy: IRsFingerProxy;
begin
  if not Assigned(_FingerProxy) then
    _FingerProxy := TRsFingerProxy.Create;

  Result := _FingerProxy;
end;

{ TRsFingerProxy }

constructor TRsFingerProxy.Create;
begin
  m_TrainmanFP := TRsTMFP.Create;
end;

destructor TRsFingerProxy.Destroy;
begin
  m_TrainmanFP := nil;
  inherited;
end;

function TRsFingerProxy.Get_RsTrainmanFP: IRsTMFP;
begin
  result := m_TrainmanFP;
end;

procedure TRsFingerProxy.Set_RsTrainmanFP(const Value: IRsTMFP);
begin
  m_TrainmanFP := value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsFingerUtils, CLASS_RsFingerUtils,
    ciMultiInstance, tmApartment);
finalization
  _FingerProxy := nil;
end.
