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
    //��ָ����
    procedure Open; safecall;
    //�ر�ָ����
    procedure Close; safecall;
    //��ʼ�Ǽ�
    procedure BeginScroll; safecall;
    //�����Ǽ�
    procedure CancelScroll; safecall;
    //��ʼ����
    procedure BeginCapture; safecall;
    //��������
    procedure EndCapture; safecall;
    procedure AddFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure UpdateFinger(FingerID: Integer; FingerDatas: OleVariant); safecall;
    procedure DeleteFinger(FingerID: Integer); safecall;
    //���ָ��
    procedure ClearFingers; safecall;

    function Get_ListenMode: Integer; safecall;
    procedure Set_ListenMode(Value: Integer); safecall;

    //���ָ�Ƽ���
    procedure AddListener(const Listener: IFingerListener); safecall;
    //ɾ��ָ�Ƽ���
    procedure ClearListeners; safecall;
    //���ָ�Ƽ���
    procedure DeleteListener(const Listener: IFingerListener); safecall;

     //ָ�������
    function Get_SensorIndex: Integer; safecall;
     //ָ��������
    function Get_SensorCount: Integer; safecall;
    //ָ���Ǳ���
    function Get_SensorSN: WideString; safecall;
    function Get_IsRegister: WordBool; safecall;
    //��ע��ָ�ƵĴ���
    function Get_EnrollIndex: Integer; safecall;
    //ָ��ʶ��׼��ȱʡΪ8����Χ1-10
    function Get_Score: Integer; safecall;
    procedure Set_Score(Value: Integer); safecall;
    function Get_Acitve: WordBool; safecall;
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
  ComServ,DSUtil,SysUtils,Variants;

procedure TRsFinger.Open;
var
  initRlt : Integer;
  strFailReasion : string;
begin
  if ZKFPEngActiveXExist() = false then
  begin
    raise exception.Create('"Biokey.ocx"δע��!');
    Exit;    
  end;

  //����Ѿ������˻����������³�ʼ��
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);

  //����Ѿ������������³�ʼ��ָ���ǿ���
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
  //�޸Ļ���
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
  strMessage := format('TRsFinger ��Ϣ:%d',[msg.Msg]);
  OutputDebugString(pansichar(strMessage));
  if m_ZKFPEngX = nil then
    exit;
  
  m_ZKFPEngX.OnCapture := nil;
  m_ZKFPEngX.OnImageReceived := nil;
  try
{$REGION '��Ϣ����'}
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
  {$ENDREGION}
  finally
    m_ZKFPEngX.OnCapture := FingerCaptureProc;
    m_ZKFPEngX.OnImageReceived := ImageReceived;
  end;
end;

procedure TRsFinger.DeleteFinger(FingerID: Integer);
begin
  //ɾ������
  m_FingerBufferManage.RemoveFingerPrint(FingerID);
end;

procedure TRsFinger.ClearFingers;
begin
   //�˴���Ҫѭ����������ļ�
  m_FingerBufferManage.FingerBufferInfoList.Clear;
end;



destructor TRsFinger.Destroy;
begin
  OutputDebugString(pansichar('TRsFinger.Destroy_begin'));
  //ע����Ϣ
  OutputDebugString(pansichar(inttostr(m_FingerMsgHandle)))  ;
  if m_FingerMsgHandle <> 0 then
    DeallocateHWnd(m_FingerMsgHandle);
  OutputDebugString(pansichar('TRsFinger.Destroy-----DeallocateHWnd'));
  //�ͷ�ָ���ǻ�����ƶ���
  if Assigned(m_FingerBufferManage) then
    FreeandNil(m_FingerBufferManage);
  //�ͷ�ָ���ǿؼ�
  OutputDebugString(pansichar('TRsFinger.Destroy------�ͷ�ָ���ǿؼ�'));
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
    OutputDebugString(pansichar('TRsFinger.Destroy---����¼�'));

    m_ZKFPEngX.EndEngine;
    FreeAndNil(m_ZKFPEngX);
    OutputDebugString(pansichar('TRsFinger.Destroy---EndEngine���ͷ�'));
  end;
  OutputDebugString(pansichar('TRsFinger.Destroy---ListenerList�ͷ�'));
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
