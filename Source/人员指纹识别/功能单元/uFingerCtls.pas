unit uFingerCtls;

interface
uses
  Classes,SysUtils,XMLIntf,XMLDoc,uLLCommonFun,uLCTrainmanMgr,uTrainman,
  uTFSystem,uLCCommon,uBaseWebInterface,Variants,ZKFPEngXUtils,ZKFPEngXControl_TLB,
  Windows,uHttpWebAPI,Contnrs;
//******************************************************************************
//    指纹仪控制单元，实现指纹后台下载及指纹缓存管理
//******************************************************************************
const
  FINGERPATH = 'Fingers\';
type
  //本地指纹管理类
  TLocalFingerCtl = class
  public
    constructor Create(const AppPath: string);
    destructor Destroy;override;
  private
    m_Xml: IXMLDocument;
    m_AppPath: string;
    m_OnProgress: TOnReadChangeEvent;

    {功能:获取本地缓存指纹版本ID}
    function GetFingerID(): string;
    {功能:设置本地缓存指纹版本ID}
    procedure SetFingerID(const Value: string);
    {功能:更新进度信息}
    procedure WriteProgress(nMax,nPosition: integer);
  public
    {功能:打开本地缓存指纹}
    procedure Open();
    procedure AddTrainman(const trainman: RRsTrainman);
    procedure UpdateTrianmanFingers(const trainman: RRsTrainman);
    {功能:向本地缓存中添加指纹信息}
    procedure AddTrainmans(const trainmanArray : TRsTrainmanArray;PutFingerFile:Boolean = true);
    {功能:加载本地缓存人员信息到人员数组}
    procedure LoadTrainmanBrief(var trainmanArray : TRsTrainmanArray);
    {功能:保存缓存数据到文件}
    procedure Save();
    {功能:清空缓存}
    procedure Clear();
    {功能:保存指纹模板到文件}
    class procedure SaveFingerFile(Path: string;const Trainman: RRsTrainman);
    property AppPath: string read m_AppPath write m_AppPath;
    property FinerID: string read GetFingerID write SetFingerID;
    property OnProgress: TOnReadChangeEvent read m_OnProgress write m_OnProgress;
  end;

  TCheckStopEvent = procedure (var Stop: Boolean) of object;

  //服务器指纹信息控制类
  TServerFingerCtl = class
  public
    constructor Create(WebAPIUtils: TWebAPIUtils);
    destructor Destroy;override;
  private
    //人员信息接口
    m_RsLCTrainmamMgr: TRsLCTrainmanMgr;
    //配置信息接口，于用获取指纹版本信息
    m_RsLCCommon: TRsLCCommon;
    //进度事伯
    m_OnProgress: TOnReadChangeEvent;
    //检测是否中止的回调
    m_OnCheckUserStop: TCheckStopEvent;
    {功能:获取指纹版本ID}
    function GetFingerID(): string;
    {功能:设置指纹版本ID}
    procedure SetFingerID(const Value: string);
    {功能:更新进茺信息}
    procedure WriteProgress(nMax,nPosition: integer);
    {功能:检查是否中止}
    procedure CheckUserStop(var Stop: Boolean);
  public
    {功能:获取人员指纹信息}
    procedure GetTrainmanBrief(var trainmanArray : TRsTrainmanArray);
    property FinerID: string read GetFingerID write SetFingerID;
    property OnProgress: TOnReadChangeEvent read m_OnProgress write m_OnProgress;
    property OnCheckUserStop: TCheckStopEvent read m_OnCheckUserStop write m_OnCheckUserStop;
  end;



  //指纹事件保持类
  TEventPersist = class
  public
    OnTouch: TNotifyEvent;
    OnLoginFail: TNotifyEvent;
    OnLoginSuccess: TOnEventByString;
    OnImageReceived: TZKFPEngXOnImageReceived;
    OnFeatureInfo: TZKFPEngXOnFeatureInfo;
    OnEnroll: TZKFPEngXOnEnroll;
  end;

  TFingerPrintCtl = class;
  TFingerEventHolder = class
  public
    constructor Create(FingerCtl: TFingerPrintCtl);
    destructor Destroy;override;
  private
    m_FingerCtl: TFingerPrintCtl;
    m_PersistList: TObjectList;
  public
    procedure Hold();
    procedure Restore();
  end;

  TSynFingerLoader = class;

  //指纹仪控制类
  TFingerPrintCtl = class
  public
    constructor Create(const AppPath: string;WebAPIUtils: TWebAPIUtils);
    destructor Destroy;override;
  private
    m_OnTouch: TNotifyEvent;
    m_OnLoginFail: TNotifyEvent;
    m_OnLoginSuccess: TOnEventByString;
    //指纹事件保持对象
    m_FingerEventHolder: TFingerEventHolder;
    //是否只使用本地人员
    m_bUserLocalTM: Boolean;
    //指纹后台下载线程
    m_SynFingerLoader: TSynFingerLoader;
  private
    //指纹仪组件
    m_ZKFPEngX : TZKFPEngX;
    //程序所在路径
    m_AppPath: string;
    //本地指纹控制对象
    m_LocalFingerCtl: TLocalFingerCtl;
    //服务器指纹控制对象
    m_ServerFingerCtl: TServerFingerCtl;
    //指纹缓存
    m_BufferMgr: TFingerBufferManage;
    //是否初始化指纹仪成功能
    m_bInitSuccess: Boolean;
    //初始化指纹仪失败原因
    m_strInitError: string;
    //缓存的人员数组
    m_TmArray: TRsTrainmanArray;

    {功能:加载指纹信息到指纹仪缓冲区}
    procedure ReloadFingerCache();
    {功能:捕捉到指纹信息事件}
    procedure OnFingerCapture(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    //指纹按下的消息
    procedure FingerTouchingProc(Sender : TObject);

    {功能:获取本地指纹版本信息通知}
    procedure OnGetLocalFingerID(Sender: TObject);
    {功能:后台加载指纹完成通知}
    procedure OnSynLoadComplete(Sender: TObject);

  public
    {功能:更新指纹仪缓冲区中的指纹}
    procedure UpdateBufferTemplate(const nID:Integer;const fdata1,fdata2:OleVariant);
    {功能:在本地缓存人员中通过工号查找人员}
    function FindTmByNumber(Number: string; out Trainman: RRsTrainman): Boolean;
    {功能:检查本地缓存中是否有指定工号的人员}
    function ExistNumber(Number: string): Boolean;
    {功能:从本地缓存文件中加载人员信息及指纹信息}
    procedure LoadLocalTM(OnProgress: TOnReadChangeEvent);
    {功能:从服务器加载人员信息}
    procedure LoadServerTM(OnProgress: TOnReadChangeEvent);
    {功能:初始化指纹仪}
    function Init: Boolean;
    property InitError: string read m_strInitError write m_strInitError;
    property UseLocalTM: Boolean read m_bUserLocalTM write m_bUserLocalTM;
    property OnTouch: TNotifyEvent read m_OnTouch write m_OnTouch;
    property OnLoginFail: TNotifyEvent read m_OnLoginFail write m_OnLoginFail;
    property OnLoginSuccess: TOnEventByString read m_OnLoginSuccess write m_OnLoginSuccess;
    property InitSuccess: Boolean read m_bInitSuccess;
    property LocalFingerCtl: TLocalFingerCtl read m_LocalFingerCtl;
    property ServerFingerCtl: TServerFingerCtl read m_ServerFingerCtl;
    property EventHolder: TFingerEventHolder read m_FingerEventHolder;
    property SynFingerLoader: TSynFingerLoader read m_SynFingerLoader;
    property ZKFPEngX : TZKFPEngX read m_ZKFPEngX;
  end;



  //指纹信息后台同步类
  TSynFingerLoader = class
  public
    constructor Create(AppPath,WebApiHost: string;WebApiPort: integer);
    destructor Destroy;override;
  private
    //WEB接口配置信对象
    m_WebAPIUtils: TWebAPIUtils;
    //线程对象
    m_Thread: TRunFunctionThread;
    //服务器指纹控制对象
    m_ServerFingerCtl: TServerFingerCtl;
    //后台加载指纹完成后的通知事件
    m_OnLoadComplete: TNotifyEvent;
    //获取本地缓存指纹版本ID的事件
    m_OnGetLocalFingerID: TNotifyEvent;
    //日志输出事件
    m_OnLogOut: TOnEventByString;
    //人员信息数组
    m_TmArray: TRsTrainmanArray;

    //本地指纹版本ID
    m_LocalFingerID: string;
    //服务器指纹版本ID
    m_ServerFingerID: string;
    //同步周期
    m_nInterval: integer;
    m_AppPath: string;
    procedure ThreadFun();
    procedure WriteLog(const log: string);
    procedure NotifyLoadComplete();
    procedure NotifyGetFingerID();
    procedure CheckUserStop(var Stop: Boolean);
  public
    procedure Start();
    property Interval: integer read m_nInterval write m_nInterval;
    property OnLoadComplete: TNotifyEvent read m_OnLoadComplete write m_OnLoadComplete;
    property OnGetLocalFingerID: TNotifyEvent read m_OnGetLocalFingerID write m_OnGetLocalFingerID;
    property OnLogOut: TOnEventByString read m_OnLogOut write m_OnLogOut;
  end;
implementation

{ TLocalFingerCtl }

procedure TLocalFingerCtl.AddTrainman(const trainman: RRsTrainman);
var
  strPath: string;
  RootNode, Node: IXMLNode;
begin
  strPath := AppPath + FINGERPATH;
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  RootNode := m_Xml.DocumentElement;

  Node := RootNode.AddChild(Format('Row%d', [RootNode.ChildNodes.Count]));
  Node.Attributes['nID'] := trainman.nID;
  Node.Attributes['strTrainmanGUID'] := trainman.strTrainmanGUID;
  Node.Attributes['strTrainmanName'] := trainman.strTrainmanName;
  Node.Attributes['strTrainmanNumber'] := trainman.strTrainmanNumber;
  Node.Attributes['strJP'] := trainman.strJP;

  SaveFingerFile(strPath,trainman);
end;
procedure TLocalFingerCtl.AddTrainmans(const trainmanArray: TRsTrainmanArray;
  PutFingerFile:Boolean);
var
  i: Integer;
  strPath: string;
  RootNode, Node: IXMLNode;
begin
  strPath := AppPath + FINGERPATH;
  if not DirectoryExists(strPath) then ForceDirectories(strPath);
  RootNode := m_Xml.DocumentElement;


  for i := 0 to Length(trainmanArray) - 1 do
  begin
    Node := RootNode.AddChild(Format('Row%d', [i+1]));
    Node.Attributes['nID'] := TrainmanArray[i].nID;
    Node.Attributes['strTrainmanGUID'] := TrainmanArray[i].strTrainmanGUID;
    Node.Attributes['strTrainmanName'] := TrainmanArray[i].strTrainmanName;
    Node.Attributes['strTrainmanNumber'] := TrainmanArray[i].strTrainmanNumber;
    Node.Attributes['strJP'] := TrainmanArray[i].strJP;

    if PutFingerFile then
      SaveFingerFile(strPath,TrainmanArray[i]);
      
    WriteProgress(Length(trainmanArray),i + 1);
  end;
end;


procedure TLocalFingerCtl.Clear;
begin
  m_Xml.DocumentElement.ChildNodes.Clear;
end;

constructor TLocalFingerCtl.Create(const AppPath: string);
begin
  m_AppPath := AppPath;
  m_Xml := NewXMLDocument();
  m_Xml.DocumentElement := m_Xml.CreateNode('Trainman');
end;

destructor TLocalFingerCtl.Destroy;
begin
  m_Xml := nil;
  inherited;
end;

function TLocalFingerCtl.GetFingerID: string;
begin
  Result := TCF_VariantParse.VariantToString(m_Xml.DocumentElement.Attributes['LocalFingerLibGUID']);
end;


procedure TLocalFingerCtl.LoadTrainmanBrief(var trainmanArray: TRsTrainmanArray);
var
  ms: TMemoryStream;
  template: OleVariant;
  strFile, strPath: string;
  i: integer;
  RootNode, Node: IXMLNode;
begin
  SetLength(trainmanArray, 0);
  strPath := AppPath + 'Fingers\';

  ms := TMemoryStream.Create;
  try
    RootNode := m_Xml.DocumentElement;
    SetLength(trainmanArray, RootNode.ChildNodes.Count);
    for i := 0 to RootNode.ChildNodes.Count - 1 do
    begin
      Node := RootNode.ChildNodes[i];
      {$region '填充人员信息'}
      trainmanArray[i].nID := Node.Attributes['nID'];
      trainmanArray[i].strTrainmanGUID := Node.Attributes['strTrainmanGUID'];
      trainmanArray[i].strTrainmanName := Node.Attributes['strTrainmanName'];
      trainmanArray[i].strTrainmanNumber := Node.Attributes['strTrainmanNumber'];
      trainmanArray[i].strJP := Node.Attributes['strJP'];
      {$endregion}

      {$region '加载指纹1'}
      strFile := strPath + IntToStr(trainmanArray[i].nID) + '-' +  trainmanArray[i].strTrainmanNumber + '.fp1';
      if FileExists(strFile) then
      begin
        ms.Clear;
        ms.LoadFromFile(strFile);
        template := StreamToTemplateOleVariant(ms);
        if (not VarIsEmpty(template)) and (not VarIsNull(template)) then
          trainmanArray[i].FingerPrint1 := template
        else
          trainmanArray[i].FingerPrint1 := null;
      end
      else
        trainmanArray[i].FingerPrint1 := null;
      {$endregion}

      {$region '加载指纹2'}
      strFile := strPath + IntToStr(trainmanArray[i].nID) + '-' +  trainmanArray[i].strTrainmanNumber + '.fp2';

      if FileExists(strFile) then
      begin
        ms.Clear;
        ms.LoadFromFile(strFile);
        template := StreamToTemplateOleVariant(ms);
        if (not VarIsEmpty(template)) and (not VarIsNull(template)) then
          trainmanArray[i].FingerPrint2 := template
        else
          trainmanArray[i].FingerPrint2 := null;
      end
      else
        trainmanArray[i].FingerPrint2 := null;
      {$endregion}

      WriteProgress(RootNode.ChildNodes.Count,i + 1);
    end;
  finally
    ms.Free;
  end;
  

end;

procedure TLocalFingerCtl.Open;
begin
  if FileExists(m_AppPath + 'Trainman.xml') then  
    m_Xml.LoadFromFile(m_AppPath + 'Trainman.xml');
end;

procedure TLocalFingerCtl.Save;
begin
  m_Xml.SaveToFile(m_AppPath + 'Trainman.xml');
end;

class procedure TLocalFingerCtl.SaveFingerFile(Path: string;const Trainman: RRsTrainman);
var
  strFile: string;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    if (not VarIsEmpty(Trainman.FingerPrint1)) and (not VarIsNull(Trainman.FingerPrint1)) then
    begin
      strFile := Path + Format('%d-%s.fp1', [Trainman.nID, Trainman.strTrainmanNumber]);

      Stream.Clear;
      TCF_VariantParse.OleVariantToStream(Trainman.FingerPrint1,Stream);

      if Stream.Size > 0 then
        Stream.SaveToFile(strFile)
    end;

    if (not VarIsEmpty(Trainman.FingerPrint2)) and  (not VarIsNull(Trainman.FingerPrint2)) then
    begin
      strFile := Path + Format('%d-%s.fp2', [Trainman.nID, Trainman.strTrainmanNumber]);
      Stream.Clear;
      TCF_VariantParse.OleVariantToStream(Trainman.FingerPrint2,Stream);
      if Stream.Size > 0 then
        Stream.SaveToFile(strFile)
    end;
  finally
    Stream.Free;
  end;


end;


procedure TLocalFingerCtl.SetFingerID(const Value: string);
begin
  m_Xml.DocumentElement.Attributes['LocalFingerLibGUID'] := Value;
end;

procedure TLocalFingerCtl.UpdateTrianmanFingers(const trainman: RRsTrainman);
var
  strPath: string;
begin
  strPath := AppPath + FINGERPATH;
  if not DirectoryExists(strPath) then ForceDirectories(strPath);

  SaveFingerFile(strPath,trainman);
end;

procedure TLocalFingerCtl.WriteProgress(nMax, nPosition: integer);
begin
  if Assigned(m_OnProgress) then
    m_OnProgress(nMax,nPosition);
end;

{ TServerFingerCtl }

procedure TServerFingerCtl.CheckUserStop(var Stop: Boolean);
begin
  Stop := False;
  if Assigned(m_OnCheckUserStop) then
    m_OnCheckUserStop(Stop);
end;

constructor TServerFingerCtl.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_RsLCTrainmamMgr := TRsLCTrainmanMgr.Create(WebAPIUtils);
  m_RsLCCommon := TRsLCCommon.Create(Format('http://%s:%d/AshxService/QueryProcess.ashx?',[WebAPIUtils.Host,WebAPIUtils.Port]),'','');
end;


destructor TServerFingerCtl.Destroy;
begin
  m_RsLCTrainmamMgr.Free;
  m_RsLCCommon.Free;
  inherited;
end;

function TServerFingerCtl.GetFingerID: string;
var
  ErrInfo: string;
begin
  Result := m_RsLCCommon.GetDBSysConfig('SysConfig','ServerFingerLibGUID', ErrInfo);

  if ErrInfo <> '' then
    raise Exception.Create('获取指纹特征失败:' + ErrInfo);
end;


procedure TServerFingerCtl.GetTrainmanBrief(
  var trainmanArray: TRsTrainmanArray);
var
  nStartID: integer;
  nTotalCount: integer;
  TempArray: TRsTrainmanArray;
  bCurIndex: integer;
  I: Integer;
  bStop: Boolean;
begin
  nStartID := 0;
  bCurIndex := 0;
  SetLength(trainmanArray,0);
  repeat
    CheckUserStop(bStop);
    if bStop then break;
    
    m_RsLCTrainmamMgr.GetTrainmansBrief(nStartID,50,1,TempArray,nTotalCount);

    if Length(trainmanArray) = 0 then
      SetLength(trainmanArray,nTotalCount);

    for I := 0 to Length(TempArray) - 1 do
    begin
      trainmanArray[bCurIndex + i] := TempArray[i];
    end;

    bCurIndex := bCurIndex + Length(TempArray);

    WriteProgress(nTotalCount,bCurIndex + 1);

    if Length(TempArray) > 0 then    
      nStartID := TempArray[Length(TempArray) - 1].nID;
  until ((bCurIndex >= nTotalCount - 1) or (Length(TempArray)  = 0));
 
end;

procedure TServerFingerCtl.SetFingerID(const Value: string);
var
  ErrInfo: string;
begin
  m_RsLCCommon.SetDBSysConfig('SysConfig','ServerFingerLibGUID',Value, ErrInfo);

  if ErrInfo <> '' then
    raise Exception.Create('设置指纹特征失败:' + ErrInfo);
end;
procedure TServerFingerCtl.WriteProgress(nMax, nPosition: integer);
begin
  if Assigned(m_OnProgress) then
    m_OnProgress(nMax,nPosition);
end;

{ TFingerPrintCtl }

constructor TFingerPrintCtl.Create(const AppPath: string;WebAPIUtils: TWebAPIUtils);
begin
  m_AppPath := AppPath;
  m_LocalFingerCtl := TLocalFingerCtl.Create(AppPath);
  m_LocalFingerCtl.AppPath := AppPath;
  m_ServerFingerCtl := TServerFingerCtl.Create(WebAPIUtils);
  m_FingerEventHolder := TFingerEventHolder.Create(Self);
  m_SynFingerLoader := TSynFingerLoader.Create(AppPath,WebAPIUtils.Host,WebAPIUtils.Port);
  m_SynFingerLoader.OnGetLocalFingerID := OnGetLocalFingerID;
  m_SynFingerLoader.m_OnLoadComplete := OnSynLoadComplete;
end;

destructor TFingerPrintCtl.Destroy;
begin
  m_SynFingerLoader.Free;
  m_LocalFingerCtl.Free;
  m_ServerFingerCtl.Free;
  if Assigned(m_BufferMgr) then
    m_BufferMgr.Free;

  if Assigned(m_ZKFPEngX) then
    m_ZKFPEngX.Free;

  m_FingerEventHolder.Free;
  inherited;
end;

function TFingerPrintCtl.ExistNumber(Number: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if m_bUserLocalTM then
  begin
    for I := 0 to Length(m_TmArray) - 1 do
    begin
      if m_TmArray[i].strTrainmanNumber = Number then
      begin
        Result := True;
        break;
      end;
    end;
  end
  else
  begin
    Result := m_ServerFingerCtl.m_RsLCTrainmamMgr.ExistNumber('',Number);
  end;

end;

function TFingerPrintCtl.FindTmByNumber(Number: string;
  out Trainman: RRsTrainman): Boolean;
var
  I: Integer;
begin
  ZeroMemory(@Trainman,SizeOf(Trainman));
  Result := False;
  if m_bUserLocalTM then
  begin
    for I := 0 to Length(m_TmArray) - 1 do
    begin
      if m_TmArray[i].strTrainmanNumber = Number then
      begin
        Trainman := m_TmArray[i];
        Result := True;
        break;
      end;
    end;
  end
  else
  begin
    result := m_ServerFingerCtl.m_RsLCTrainmamMgr.GetTrainmanByNumber(Number,Trainman,2);
  end;

end;

procedure TFingerPrintCtl.FingerTouchingProc(Sender: TObject);
begin
  m_ZKFPEngX.OnFingerTouching := nil;
  try
    if Assigned(m_OnTouch) then
        m_OnTouch(m_ZKFPEngX);
  finally
    m_ZKFPEngX.OnFingerTouching := FingerTouchingProc;
  end;
end;

function TFingerPrintCtl.Init: Boolean;
{功能:初始化指纹仪}
var
  initRlt : Integer;
begin
  Result := False;
  m_bInitSuccess := false;

  m_LocalFingerCtl.Open();
  
  if ZKFPEngActiveXExist() = false then
  begin
    m_strInitError := '"Biokey.ocx"未为注册!';
    Exit;
  end;
  
  if Assigned(m_ZKFPEngX) then
    FreeAndNil(m_ZKFPEngX);
    
  m_ZKFPEngX := TZKFPEngX.Create(nil);
  if Assigned(m_BufferMgr) then
    FreeandNil(m_BufferMgr);
    
  m_BufferMgr := TFingerBufferManage.Create(m_ZKFPEngX);
  m_strInitError := '';
  try
    initRlt := m_ZKFPEngX.InitEngine;
    case initRlt of
      1: m_strInitError := '驱动程序加载失败!';
      2: m_strInitError := '指纹仪USB连接出现故障!';
      3: m_strInitError := '指纹仪序号不存在或被占用!';
    end;
    if m_strInitError <> '' then
    begin
      FreeAndNil(m_ZKFPEngX);
      Exit;
    end;
  except
    on E : Exception do
    begin
      FreeAndNil(m_ZKFPEngX);
      m_strInitError := '指纹仪无法使用,请检查驱动是否正常。';
      Exit;
    end;
  end;

  m_bInitSuccess := True;
  Result := True;

  m_ZKFPEngX.OnCapture := OnFingerCapture;

  m_ZKFPEngX.OnFingerTouching := FingerTouchingProc;
end;

procedure TFingerPrintCtl.LoadLocalTM(OnProgress: TOnReadChangeEvent);
begin
  m_LocalFingerCtl.OnProgress := OnProgress;
  try
    m_LocalFingerCtl.LoadTrainmanBrief(m_TmArray);
    ReloadFingerCache();
  finally
    m_LocalFingerCtl.OnProgress := nil;
  end;
end;
procedure TFingerPrintCtl.LoadServerTM(OnProgress: TOnReadChangeEvent);
var
  TrainmanArray: TRsTrainmanArray;
  FinerID: string;
begin
  m_ServerFingerCtl.OnProgress := OnProgress;
  m_LocalFingerCtl.OnProgress := OnProgress;
  try
    FinerID := m_ServerFingerCtl.FinerID;
    m_ServerFingerCtl.GetTrainmanBrief(TrainmanArray);
    m_LocalFingerCtl.Clear;
    m_LocalFingerCtl.AddTrainmans(TrainmanArray);
    m_TmArray := TrainmanArray;
    ReloadFingerCache();
    m_LocalFingerCtl.FinerID := FinerID;
    m_LocalFingerCtl.Save();
  finally
    m_LocalFingerCtl.OnProgress := nil;
    m_ServerFingerCtl.OnProgress := nil;
  end;

end;

procedure TFingerPrintCtl.OnFingerCapture(ASender: TObject;
  ActionResult: WordBool; ATemplate: OleVariant);
var
  nID, i, n: Integer;
  tmNumber: string;
begin
  m_ZKFPEngX.OnCapture := nil;
  try
    if ActionResult = False then
    begin
      if Assigned(m_OnLoginFail) then
        m_OnLoginFail(Self);
      Exit;
    end;
    if m_BufferMgr.FindFingerPrint(ATemplate,nID) then
    begin
      tmNumber := '';
      n := Length(m_TmArray);
      for i := 0 to n - 1 do
      begin
        if m_TmArray[i].nID = nID then
        begin
          tmNumber := m_TmArray[i].strTrainmanNumber;
          break;
        end;
      end;

      if tmNumber <> '' then
      begin
        if Assigned(m_OnLoginSuccess) then
        begin
           m_OnLoginSuccess(tmNumber);
        end;
      end
      else
      begin
        if Assigned(m_OnLoginFail) then
          m_OnLoginFail(Nil);
      end;
    end
    else
    begin
      if Assigned(m_OnLoginFail) then m_OnLoginFail(Nil);
    end;
  finally
    m_ZKFPEngX.OnCapture := OnFingerCapture;
  end;
end;

procedure TFingerPrintCtl.OnGetLocalFingerID(Sender: TObject);
begin
  TSynFingerLoader(Sender).m_LocalFingerID := m_LocalFingerCtl.FinerID;
end;

procedure TFingerPrintCtl.OnSynLoadComplete(Sender: TObject);
begin
  m_LocalFingerCtl.Clear;
  m_LocalFingerCtl.AddTrainmans(TSynFingerLoader(Sender).m_TmArray,False);
  m_LocalFingerCtl.FinerID := TSynFingerLoader(Sender).m_ServerFingerID;
  m_LocalFingerCtl.Save();
  m_tmArray := TSynFingerLoader(Sender).m_TmArray;
  ReloadFingerCache();
end;

procedure TFingerPrintCtl.ReloadFingerCache;
var
  I: Integer;
begin
  if Assigned(m_BufferMgr) then
  begin
    FreeAndNil(m_BufferMgr);
  end;

  m_BufferMgr := TFingerBufferManage.Create(m_ZKFPEngX);
  for I := 0 to Length(m_TmArray) - 1 do
  begin
    if (not VarIsEmpty(m_TmArray[i].FingerPrint1)) and (not VarIsNull(m_TmArray[i].FingerPrint1)) then
    begin
      m_BufferMgr.AddFingerPrint(m_TmArray[i].FingerPrint1,m_TmArray[i].nID);
    end;

    if (not VarIsEmpty(m_TmArray[i].FingerPrint2)) and (not VarIsNull(m_TmArray[i].FingerPrint2)) then
    begin
      m_BufferMgr.AddFingerPrint(m_TmArray[i].FingerPrint2,m_TmArray[i].nID);
    end;
  end;
end;

procedure TFingerPrintCtl.UpdateBufferTemplate(const nID: Integer;
  const fdata1, fdata2: OleVariant);
begin
  if InitSuccess  then
  begin
    m_BufferMgr.RemoveFingerPrint(nID);
    if LengTh(fdata1) > 0 then
      m_BufferMgr.AddFingerPrint(fdata1, nID);
    if Length(fdata2) > 0 then
      m_BufferMgr.AddFingerPrint(fdata2, nID);
  end;
end;
{ TFingerEventHolder }

constructor TFingerEventHolder.Create(FingerCtl: TFingerPrintCtl);
begin
  m_FingerCtl := FingerCtl;
  m_PersistList := TObjectList.Create;
end;

destructor TFingerEventHolder.Destroy;
begin
  m_PersistList.Free;
  inherited;
end;

procedure TFingerEventHolder.Hold;
var
  EventPersist: TEventPersist;
begin
  EventPersist := TEventPersist.Create;
  EventPersist.OnTouch := m_FingerCtl.OnTouch;
  EventPersist.OnLoginFail := m_FingerCtl.OnLoginFail;
  EventPersist.OnLoginSuccess := m_FingerCtl.OnLoginSuccess;
  if Assigned(m_FingerCtl.m_ZKFPEngX) then
  begin
    EventPersist.OnImageReceived := m_FingerCtl.m_ZKFPEngX.OnImageReceived;
    EventPersist.OnFeatureInfo := m_FingerCtl.m_ZKFPEngX.OnFeatureInfo;
    EventPersist.OnEnroll := m_FingerCtl.m_ZKFPEngX.OnEnroll;
  end;

  m_PersistList.Add(EventPersist);


  m_FingerCtl.OnTouch := nil;
  m_FingerCtl.OnLoginFail := nil;
  m_FingerCtl.OnLoginSuccess := nil;
  if Assigned(m_FingerCtl.m_ZKFPEngX) then
  begin
    m_FingerCtl.m_ZKFPEngX.OnImageReceived := nil;
    m_FingerCtl.m_ZKFPEngX.OnFeatureInfo := nil;
    m_FingerCtl.m_ZKFPEngX.OnEnroll := nil;
  end;

end;

procedure TFingerEventHolder.Restore;
begin
  if m_PersistList.Count > 0 then
  begin
    m_FingerCtl.OnTouch := TEventPersist(m_PersistList.Last).OnTouch;
    m_FingerCtl.OnLoginFail := TEventPersist(m_PersistList.Last).OnLoginFail;
    m_FingerCtl.OnLoginSuccess := TEventPersist(m_PersistList.Last).OnLoginSuccess;
    if Assigned(m_FingerCtl.m_ZKFPEngX) then
    begin
      m_FingerCtl.m_ZKFPEngX.OnImageReceived := TEventPersist(m_PersistList.Last).OnImageReceived;
      m_FingerCtl.m_ZKFPEngX.OnFeatureInfo := TEventPersist(m_PersistList.Last).OnFeatureInfo;
      m_FingerCtl.m_ZKFPEngX.OnEnroll := TEventPersist(m_PersistList.Last).OnEnroll;
    end;

    m_PersistList.Remove(m_PersistList.Last);
  end;
end;



{ TSynFingerLoader }

procedure TSynFingerLoader.CheckUserStop(var Stop: Boolean);
begin
  Stop := m_Thread.Terminated;
end;

constructor TSynFingerLoader.Create(AppPath,WebApiHost: string;WebApiPort: integer);
begin
  m_AppPath := AppPath;
  m_nInterval := 300000;
  m_WebAPIUtils := TWebAPIUtils.Create;
  m_WebAPIUtils.Host := WebApiHost;
  m_WebAPIUtils.Port := WebApiPort;
  m_Thread := TRunFunctionThread.Create(ThreadFun);
  m_ServerFingerCtl := TServerFingerCtl.Create(m_WebAPIUtils);
  m_ServerFingerCtl.OnCheckUserStop := CheckUserStop;
end;

destructor TSynFingerLoader.Destroy;
begin
  m_Thread.Free;
  m_ServerFingerCtl.Free;
  m_WebAPIUtils.Free;
  inherited;
end;

procedure TSynFingerLoader.NotifyGetFingerID;
begin
  if Assigned(m_OnGetLocalFingerID) then
    m_OnGetLocalFingerID(Self);
  
end;

procedure TSynFingerLoader.NotifyLoadComplete;
begin
  if Assigned(m_OnLoadComplete) then
    m_OnLoadComplete(self)
end;



procedure TSynFingerLoader.Start;
begin
  m_Thread.Resume;
end;

procedure TSynFingerLoader.ThreadFun;
var
  I: Integer;
begin
  while not m_Thread.Terminated do
  begin

    try
      if m_Thread.Terminated then break;
      
      m_ServerFingerID := m_ServerFingerCtl.GetFingerID;
      if m_ServerFingerID <> '' then
      begin
        TThread.Synchronize(m_Thread,NotifyGetFingerID);

        if m_ServerFingerID <> m_LocalFingerID then
        begin
          m_ServerFingerCtl.GetTrainmanBrief(m_TmArray);

          for I := 0 to Length(m_TmArray) - 1 do
          begin
            TLocalFingerCtl.SaveFingerFile(m_AppPath + FINGERPATH,m_TmArray[i]);
          end;
          
          TThread.Synchronize(m_Thread,NotifyLoadComplete);
        end;

      end;

      ThreadDelay(m_nInterval,m_Thread);
    except
      on E: Exception do
      begin
        WriteLog(E.Message);
      end;
    end;
  end;
end;
procedure TSynFingerLoader.WriteLog(const log: string);
begin
  if Assigned(m_OnLogOut) then
    m_OnLogOut(Self.ClassName + ' - ' + log);
end;

end.
