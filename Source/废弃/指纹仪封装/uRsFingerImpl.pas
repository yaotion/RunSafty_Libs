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
  ///��־���������Ϣ��ȡ������
  TFinger = class(TRsLibEntry,IFinger)
  public
    constructor Create;override;
    destructor Destroy;override;
  public
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
  protected
    //ָ��ʶ���¼�
    procedure FingerCaptureProc(ASender: TObject; ActionResult: WordBool; ATemplate: OleVariant);
    //ָ����ͼ������¼�
    procedure ImageReceived(Sender: TObject;var AImageValid: WordBool);
    //ָ����ͼ������¼�
    procedure FingerEnroll(Sender:TObject ;ActionResult: WordBool;ATemplate: OleVariant);
    //ָ�ƵǼ�֪ͨ�¼�
    procedure FeatureInfo(ASender: TObject; AQuality: Integer);
  private
    //ָ���ǿؼ�
    m_ZKFPEngX : TZKFPEngX;
    //ָ�ƻ�������������
    m_FingerBufferManage: TFingerBufferManage;
    //{ָ���Ǹ��ٻ���ռ�}
    m_fpcHandle: Integer;
    //����ָ����Ϣ�ľ��
    m_FingerMsgHandle : Integer;
    //���������б�
    m_ListenerList : IInterfaceList;
    //����ģʽ
    m_ListenMode : integer;
    //ָ��ʶ��׼��
    m_Score : integer;
    //��Ϣ������
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
  //�˴���Ҫѭ����������ļ�
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
  //ɾ������
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
end;

procedure TFinger.DeleteListener(Listener: IFingerListener);
begin
  m_ListenerList.Remove(Listener);
end;

destructor TFinger.Destroy;
begin
  //ע����Ϣ
  DeallocateHWnd(m_FingerMsgHandle);
  //�ͷ�ָ���ǻ�����ƶ���
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);

  //�ͷ�ָ���ǿؼ�
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
    //�ͷ�ָ���ǻ���ռ�
    if m_fpcHandle <> -1 then
      m_ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
    FreeAndNil(m_ZKFPEngX);
  end;

  //��ռ���
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
   //����ģʽ�������������͸����һ��ע��ļ�����
  if m_ListenMode = ord(flmSignle) then
  begin
    if m_ListenerList.Count = 0 then exit;

    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FeatureInfo(AQuality);
  end;
  //�㲥ģʽ������㲥��ÿһ��������
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
   //����ģʽ�������������͸����һ��ע��ļ�����
  if m_ListenMode = ord(flmSignle) then
  begin
    if m_ListenerList.Count = 0 then exit;

    (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerScroll(ActionResult,ATemplate);
  end;
  //�㲥ģʽ������㲥��ÿһ��������
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
    raise exception.Create('"Biokey.ocx"δע��!');
    Exit;    
  end;

  //����Ѿ������������³�ʼ��ָ���ǿ���
  if m_ZKFPEngX <> nil then
    FreeAndNil(m_ZKFPEngX);
  m_ZKFPEngX := TZKFPEngX.Create(nil);

   //��ʼ��ָ���ǻ����
  if m_fpcHandle <> -1 then
    m_ZKFPEngX.FreeFPCacheDB(m_fpcHandle);
  m_fpcHandle := m_ZKFPEngX.CreateFPCacheDB();
  
  if m_fpcHandle = 0 then
    raise exception.Create('����ZKFPEngXʧ��!');
    
  //����Ѿ������˻����������³�ʼ��
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  m_FingerBufferManage := TFingerBufferManage.Create(m_ZKFPEngX);

  strFailReasion:='';
  try
    initRlt := m_ZKFPEngX.InitEngine;
  except
    on E : Exception do
    begin
      strFailReasion := 'ָ���Ǵ�ʧ��,ԭ��' + E.Message;
      raise exception.Create(strFailReasion);
    end;
  end;  
  case initRlt of
    1: strFailReasion := '�����������ʧ��!';
    2: strFailReasion := 'ָ����USB���ӳ��ֹ���!';
    3: strFailReasion := 'ָ������Ų����ڻ�ռ��!';
  end;
  if strFailReasion <> '' then
  begin
    raise exception.Create(strFailReasion);
  end;
  //��׽��ָ�ƴ���
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
  //�޸Ļ���
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
    //����ָ����Ϣ
    if Msg.Msg = WM_MSGFingerCapture then
    begin
      //�ж�ָ���Ƿ��Ѿ����ڴ���
      m_FingerBufferManage.Score := m_Score;
      bCapture := m_FingerBufferManage.FindFingerPrint(m_ZKFPEngX.GetTemplate,nFindFingerID);
      //����ģʽ�������������͸����һ��ע��ļ�����
      if m_ListenMode = ord(flmSignle) then
      begin
        if m_ListenerList.Count = 0 then exit;
        if bCapture then
          (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerSuccess(nFindFingerID)
        else
          (m_ListenerList.Items[m_ListenerList.Count - 1] as IFingerListener).FingerFailure
      end
      //�㲥ģʽ������㲥��ÿһ��������
      else if m_ListenMode = ord(flmBoardCast) then
      for I := 0 to m_ListenerList.Count - 1 do
      begin
        if bCapture then
          (m_ListenerList.Items[i] as IFingerListener).FingerSuccess(nFindFingerID)
        else
          (m_ListenerList.Items[i] as IFingerListener).FingerFailure
      end;
    end
    //�û�������Ϣ
    else if Msg.Msg = WM_MSGImageReceived then
    begin
       //����ģʽ�������������͸����һ��ע��ļ�����
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
      //�㲥ģʽ������㲥��ÿһ��������
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
