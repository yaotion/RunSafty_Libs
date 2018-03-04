unit uRsAlcoholImpl;

interface
uses
  Classes,Forms,Windows,uTFVariantUtils ,
    uRsLibClass,uRsCameraLib,
    uApparatus,uAlcoBaseDefine,uApparatusCommon,uRsAlcoholLib,uFrmAlcoholUI_PC;
type
  //��ƽӿ�ʵ����
  TAlcoholCtl = class(TRsLibEntry,IAlcoholCtl)
  public
    constructor Create;override;
    destructor Destroy;override;
  private
    //���ѡ��
    m_Option : IAlcoholOption;
    //��ʾ����
    m_UI : IAlcoholUI;
    //��ƽ��
    m_TestResult : IAlcoholResult;
    //�Ƿ��Ѿ�׼������
    m_bTestReadied : boolean;
    //�Ƿ��Ѿ��������Ƭ
    m_bCaptured : boolean;
    //�Ƿ��Ѿ��������
    m_bTestOk : boolean;
    //��ƿ�����
    m_AlcoholTest : TApparatus;
    //����ͷ������
    m_Camera : ICamera;
    //��ƽ�����ʾ
    m_ShowForm : TFrmAlcoholUI_PC;
    //��ʼ���Եĺ�����
    m_StartTick : Cardinal;
  protected
    //�����״̬��Ϣ֪ͨ�¼�
    procedure OnApparatusInfo(Info: RApparatusInfo);
    //������Ƭ�¼�
    procedure OnPhotoCaptured();
    //�û�ȡ���¼�
    procedure OnUICancel(Sender : TObject);
    //������Ӧ��ʱ�¼�
    procedure OnUITimeOut(Sender : TObject);
    //���ò�ͨ״̬����ʾ
    procedure SetUIState(Status : Word);
    //���Ų�ͬ״̬������
    procedure PlanLocalSound(Status : Word);
    //����ͬ״̬������
    procedure DealTest(Info: RApparatusInfo);
    //�����ƽ��
    function GetAlcoholResult(wStatus: Word): TTestAlcoholResult;
  private
    procedure Test;
    function GetOption : IAlcoholOption;
    function GetUI : IAlcoholUI;
    function GetTestResult : IAlcoholResult;
  end;
  //���ѡ��ʵ����
  TAlcoholOption = class(TInterfacedObject,IAlcoholOption)
  public
    constructor Create;
  private
    m_Position : Word;
    m_LocalSound : boolean;
  private
    function GetPosition : Integer;stdcall;
    procedure SetPosition(Value : Integer);stdcall;
    function GetLocalSound : Boolean;stdcall;
    procedure SetLocalSound(Value : Boolean);stdcall;
    function GetAppHandle : Cardinal;stdcall;
    procedure SetAppHandle(Value : Cardinal);stdcall;
  end;

  //�����ʾʵ����
  TAlcoholUI = class(TInterfacedObject,IAlcoholUI)
  public
    constructor Create;
  private
    m_TrainmanNumber : WideString;
    m_TrainmanName : WideString;
    m_TrainNo : WideString;
    m_TrainTypeName : WideString;
    m_TrainNumber : WideString;
    m_TestTime : TDateTime;
    m_Picture : OleVariant;
  private
    function GetTrainmanNumber : WideString;stdcall;
    procedure SetTrainmanNumber(Value : WideString);stdcall;
    function GetTrainmanName : WideString;stdcall;
    procedure SetTrainmanName(Value : WideString);stdcall;
    function GetTrainNo : WideString;stdcall;
    procedure SetTrainNo(Value : WideString);stdcall;
    function GetTrainTypeName : WideString;stdcall;
    procedure SetTrainTypeName(Value : WideString);stdcall;
    function GetTrainNumber : WideString;stdcall;
    procedure SetTrainNumber(Value : WideString);stdcall;
    function GetTestTime : TDateTime;stdcall;
    procedure SetTestTime(Value : TDateTime);stdcall;
    function GetPicture : OleVariant;stdcall;
    procedure SetPicture(Value : OleVariant);stdcall;
  end;
  //��ƽ��ʵ����
  TAlcoholResult = class(TInterfacedObject,IAlcoholResult)
  public
    constructor Create;
  private
    m_TestResult : integer;
    m_Alcoholity : integer;
    m_TestTime : TDateTime ;
    m_Picture : OleVariant;
  private
    function GetTestResult : integer;stdcall;
    procedure SetTestResult(Value : integer);stdcall;
    function GetAlcoholity : integer;stdcall;
    procedure SetAlcoholity(Value : integer);stdcall;
    function GetTestTime : TDateTime;stdcall;
    procedure SetTestTime(Value : TDateTime);stdcall;
    function GetPicture : OleVariant;stdcall;
    procedure SetPicture(Value : OleVariant);stdcall;
  end;  
implementation
uses
  SysUtils,MMSystem,DateUtils;

{ TAlcoholCtl }

constructor TAlcoholCtl.Create;
begin
  inherited;
  m_Option := TAlcoholOption.Create;
  m_UI := TAlcoholUI.Create;
  m_TestResult := TAlcoholResult.Create;
  m_AlcoholTest := nil;
  m_ShowForm := TFrmAlcoholUI_PC.Create(nil);
end;

procedure TAlcoholCtl.DealTest(Info: RApparatusInfo);
var
  ms : TMemoryStream;
begin
  if Info.wStatus = crReady then exit;
  
  //�����ƽ��
  m_TestResult.TestResult := Ord(GetAlcoholResult(Info.wStatus));
  m_TestResult.Alcoholity := Info.dwAlcoholicity ;
  m_TestResult.TestTime := DateUtils.IncMilliSecond(m_UI.TestTime,GetTickCount-m_StartTick);
  ms := TMemoryStream.Create;
  try
    if not m_bCaptured then
    begin
      m_Camera.CaptureBitmap(TTFStreamAdapter.Create(ms));
      m_TestResult.Picture := TTFVariantUtils.StreamToTemplateOleVariant(ms);
    end;
  finally
    ms.Free;
  end;
  //�رղ�ƿ���
  m_AlcoholTest.OnApparatusInfoChange := nil;
  m_AlcoholTest.StopTest;
  //�ر�����ͷ
  m_Camera.Close;
  //�ر���ʾ����
  m_ShowForm.CloseUI;
  //������
  m_bTestOk := true;
end;

destructor TAlcoholCtl.Destroy;
begin

  if m_Camera <> nil then
  begin
    m_Camera := nil;
  end;
  
  if m_AlcoholTest <> nil then
  begin
    m_AlcoholTest.OnApparatusInfoChange := nil;
    m_AlcoholTest.OnRunPhoto := nil;
    try
      m_AlcoholTest.StopTest;
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

function TAlcoholCtl.GetOption: IAlcoholOption;
begin
  result := m_Option;
end;

function TAlcoholCtl.GetTestResult: IAlcoholResult;
begin
  result := m_TestResult;
end;

function TAlcoholCtl.GetUI: IAlcoholUI;
begin
  result := m_UI;
end;

procedure TAlcoholCtl.OnApparatusInfo(Info: RApparatusInfo);
begin  
  if info.wStatus = crReady then
  begin
    //ÿ�β��ֻ�е�һ�ξ���,������������ָ��
    if m_bTestReadied then
    begin
      exit;
    end;
    //��״ְ̬λ�Ѿ���
    m_bTestReadied := true;
  end else begin
    //�����ڲ���Ƿ�������ָ��֮ǰ��ż���������Ƶ�����ָ��
    if not m_bTestReadied then
      exit;
  end;
  //����ָ��״���´������ʾ
  SetUIState(info.wStatus);
  //����ָ��״̬������
  PlanLocalSound(info.wStatus);
  //�����ƿ���
  DealTest(info);
end;

procedure TAlcoholCtl.OnPhotoCaptured;
var
  ms : TMemoryStream;
begin
  if not m_bCaptured then
  begin
    m_bCaptured := true;
    ms := TMemoryStream.Create;
    try
      m_Camera.CaptureBitmap(TTFStreamAdapter.Create(ms));
      m_TestResult.Picture := TTFVariantUtils.StreamToTemplateOleVariant(ms);
    finally
      ms.Free;
    end;
  end;
end;

procedure TAlcoholCtl.OnUICancel(Sender: TObject);
var
  info : RApparatusInfo;
begin
  info.dwAlcoholicity := 0;
  info.wStatus := crNotTest;
  //�����ƿ���
  DealTest(info);
end;

procedure TAlcoholCtl.OnUITimeOut(Sender: TObject);
var
  info : RApparatusInfo;
begin
  info.dwAlcoholicity := 0;
  info.wStatus := crTimeOut;
  //�����ƿ���
  DealTest(info);
end;

procedure TAlcoholCtl.PlanLocalSound(Status: Word);
var
  strFile,strPath : string ;
begin
  case Status of
    crReady: begin
      strFile := '����.wav';
      m_AlcoholTest.bOnLight := True;
    end;
    crNormal: strFile := '��������.wav';
    crMore: strFile := '����.wav';
    crMuch: strFile := '���.wav';
  end;
                             
  strPath := ExtractFilePath(Application.ExeName) + 'Sounds\';
  strFile := strPath + strFile;
  if FileExists(strFile) then
  begin
    //���ʹ�ñ�������
    if m_Option.LocalSound then
    begin
      PlaySound(Pchar(strFile),Application.Handle,SND_FILENAME or SND_ASYNC);
    end;
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
begin
  if m_AlcoholTest <> nil then
    FreeAndNil(m_AlcoholTest);
  //��ʼ������ǿ�����
  m_AlcoholTest := TApparatus.Create(nil);
  m_AlcoholTest.bDisplayGongHao := true;
  m_AlcoholTest.bDisplayDrinkResult := true;
  m_AlcoholTest.OnRunPhoto := OnPhotoCaptured;
  m_AlcoholTest.OnApparatusInfoChange := OnApparatusInfo;
  m_AlcoholTest.strName := m_UI.TrainmanName;
  m_AlcoholTest.strNo := m_UI.TrainmanNumber;

  //��ʼ������ͷ������
  if m_Camera = nil then
  begin
    m_Camera := ReflectEntryEx(ICamera) as ICamera;
  end;
  m_Camera.Option.TargetHandle := m_ShowForm.CameraPanelHandle;
  if m_Option.Position = Ord(ptNormal) then
  begin
    m_ShowForm.Left := (Screen.Width - m_ShowForm.Width) div 2;
    m_ShowForm.Top := (Screen.Height - m_ShowForm.Height) div 2;
  end;
  if m_Option.Position = Ord(ptRightBottom) then
  begin
    m_ShowForm.Left := Screen.Width - m_ShowForm.Width;
    m_ShowForm.Top := Screen.Height - m_ShowForm.Height;
  end;
  m_ShowForm.InitUI(m_UI);

  //������ͷ
  if not m_Camera.Open then
  begin
    m_ShowForm.SetError('������ͷʧ��');
  end;
  //�򿪲����
  if not m_AlcoholTest.Open then
  begin
    m_ShowForm.SetError('�򿪲����ʧ��');
  end;
  m_StartTick := GetTickCount;
  m_AlcoholTest.StartTest(false);
  //��ʼ���
  m_bTestReadied := false;
  m_bCaptured := false;
  m_bTestOk := false;
  m_AlcoholTest.StartTest(False);
  //��ʾ��ƴ��壬�������״����Ϊ����״̬
  m_ShowForm.OnCancel := OnUICancel;
  m_ShowForm.OnTimeOut := OnUITimeOut;
  m_ShowForm.ShowModal;
end;

{ TAlcoholOption }

constructor TAlcoholOption.Create;
begin
  m_Position := Ord(ptNormal);
  m_LocalSound := false;
end;

function TAlcoholOption.GetAppHandle: Cardinal;
begin
  result := Application.Handle;
end;

function TAlcoholOption.GetLocalSound: Boolean;
begin
  result := m_LocalSound;
end;

function TAlcoholOption.GetPosition: Integer;
begin
  result := m_Position;
end;

procedure TAlcoholOption.SetAppHandle(Value: Cardinal);
begin
  Application.Handle := Value;
end;

procedure TAlcoholOption.SetLocalSound(Value: Boolean);
begin
  m_LocalSound := value;
end;

procedure TAlcoholOption.SetPosition(Value: Integer);
begin
  m_Position := value;
end;

{ TAlcoholUI }

constructor TAlcoholUI.Create;
begin
  m_TrainmanNumber := '';
  m_TrainmanName := '';
  m_TrainNo := '';
  m_TrainTypeName := '';
  m_TrainNumber := '';
  m_TestTime := 0;
  m_Picture := varEmpty;
end;

function TAlcoholUI.GetPicture: OleVariant;
begin
 result := m_Picture;
end;

function TAlcoholUI.GetTestTime: TDateTime;
begin
  result := m_TestTime;
end;

function TAlcoholUI.GetTrainmanName: WideString;
begin
  result := m_TrainmanName;
end;

function TAlcoholUI.GetTrainmanNumber: WideString;
begin
  result := m_TrainmanNumber;
end;

function TAlcoholUI.GetTrainNo: WideString;
begin
  result := m_TrainNo;
end;

function TAlcoholUI.GetTrainNumber: WideString;
begin
  result := m_TrainNumber;
end;

function TAlcoholUI.GetTrainTypeName: WideString;
begin
  result := m_TrainTypeName;
end;

procedure TAlcoholUI.SetPicture(Value: OleVariant);
begin
  m_Picture := value;
end;

procedure TAlcoholUI.SetTestTime(Value: TDateTime);
begin
  m_TestTime := Value;
end;

procedure TAlcoholUI.SetTrainmanName(Value: WideString);
begin
  m_TrainmanName := Value;
end;

procedure TAlcoholUI.SetTrainmanNumber(Value: WideString);
begin
  m_TrainmanNumber := Value;
end;

procedure TAlcoholUI.SetTrainNo(Value: WideString);
begin
  m_TrainNo := Value;
end;

procedure TAlcoholUI.SetTrainNumber(Value: WideString);
begin
  m_TrainNumber := Value;
end;

procedure TAlcoholUI.SetTrainTypeName(Value: WideString);
begin
  m_TrainTypeName := Value;
end;

{ TAlcoholResult }

constructor TAlcoholResult.Create;
begin
  m_TestResult := 0;
  m_Alcoholity := 0;
  m_TestTime := 0; 
  m_Picture := varEmpty;
end;

function TAlcoholResult.GetAlcoholity: integer;
begin
  result := m_Alcoholity;
end;

function TAlcoholResult.GetPicture: OleVariant;
begin
  result := m_Picture;
end;

function TAlcoholResult.GetTestResult: integer;
begin
  result := m_TestResult;
end;

function TAlcoholResult.GetTestTime: TDateTime;
begin
  result := m_TestTime;
end;

procedure TAlcoholResult.SetAlcoholity(Value: integer);
begin
  m_Alcoholity := value;
end;

procedure TAlcoholResult.SetPicture(Value: OleVariant);
begin
  m_Picture := value;
end;

procedure TAlcoholResult.SetTestResult(Value: integer);
begin
  m_TestResult := value;
end;

procedure TAlcoholResult.SetTestTime(Value: TDateTime);
begin
  m_TestTime := Value;
end;

initialization
finalization
  Application.Handle := 0;
end.
