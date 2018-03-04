unit uRsCameraImpl;

interface
uses
  Classes,SysUtils,ActiveX,Graphics,DSPack,
  Windows,SyncObjs,DirectShow9,DSUtil,Forms,
  uRsCameraLib,uRsLibClass;
type
  TCameraOption = class(TInterfacedObject,ICameraOption)
  public
    constructor Create();
  private
    m_FriendName : WideString;
    m_CameraIndex : Cardinal;
    m_TargetHandle : Cardinal;
  public
    function  GetCameraFriendName: WideString;stdcall;
    procedure SetCameraFriendName(value: WideString);stdcall;
    function  GetCameraIndex() : Cardinal;stdcall;
    procedure SetCameraIndex(Value : Cardinal);stdcall;
    function  GetTargetHandle() : Cardinal;stdcall;
    procedure SetTargetHandle(Value : Cardinal);stdcall;
  end;
  
  TCameraCtl = class(TRsLibEntry,ICamera)
  public
    constructor Create;override;
    destructor Destroy;override;
  private
    //����
    m_Option : ICameraOption;
    //����ͷ���ƶ���
    m_SampleGrabber: TSampleGrabber;
    m_VideoSource: TFilter;
    m_CaptureGraph: TFilterGraph;
    //����ͷͼ��洢
    m_Bitmap,m_CaptureBitmap: Graphics.TBitmap;
    //����ͷͼ������¼�
    m_ImgReciever: IImgReciever;
  private
    //��Ŀ��ؼ��ϻ���ͼ��
    procedure DrawTarget();
    //֪ͨ��������ͼ�񴫵ݹ���
    procedure NotifyReceiver();
  private
    //���Է���
    function  GetReciever: IImgReciever;stdcall;
    procedure SetReciever(value: IImgReciever);stdcall;
    function  GetOption : ICameraOption;stdcall;
    //�������ش����¼�����
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    //������ͷ�豸
    procedure OpenDevice;
    //��ȡ����ͷ�豸
    function  GetDevice() :IMoniker;
    //��ȡͼ��
    procedure GetBitmap(Bmp : Graphics.TBitmap);
  public
    //������ͷ
    function  Open(): Boolean;stdcall;
    //�ر�����ͷ
    procedure Close();stdcall;
    //��ͼ
    function  CaptureBitmap(Stream: ITFStream): Boolean;stdcall;
  end;
var
  FCriticalSection : TCriticalSection;
implementation

{ TCamearCtl }

procedure TCameraCtl.Close;
begin
  m_CaptureGraph.ClearGraph;
  m_CaptureGraph.Active := false;
end;

constructor TCameraCtl.Create;
begin
  m_CaptureGraph := TFilterGraph.Create(nil);
  with m_CaptureGraph do
  begin
    Mode := gmCapture;
    GraphEdit := True;
    LinearVolume := False;
  end;
  
  m_VideoSource := TFilter.Create(nil);
  with m_VideoSource do
  begin
    FilterGraph := m_CaptureGraph
  end;

  m_SampleGrabber := TSampleGrabber.Create(nil);
  with m_SampleGrabber do
  begin
    FilterGraph := m_CaptureGraph;
    OnBuffer := SampleGrabberBuffer;
  end;

  m_Bitmap := Graphics.TBitmap.Create;
  m_CaptureBitmap := Graphics.TBitmap.Create;
  m_Option := TCameraOption.Create;
end;

destructor TCameraCtl.Destroy;
begin
  Close;
  m_CaptureGraph.Free;
  m_SampleGrabber.Free;;
  m_VideoSource.Free;
  m_Option := nil;
  m_Bitmap.Free;
  m_CaptureBitmap.Free;
  inherited;
end;


procedure TCameraCtl.DrawTarget;
var
  c: TCanvas;
  DC: HDC;
  r,r2 : TRect;
  tmpHandle : Cardinal;
  bmp : Graphics.TBitmap;
begin
  if m_Option.GetTargetHandle = 0 then exit;
  if m_SampleGrabber.SampleGrabber = nil then exit;
  
  tmpHandle := m_Option.GetTargetHandle;
  bmp := Graphics.TBitmap.Create;
  try
    GetBitmap(bmp);
    c := TCanvas.Create;
    DC := GetWindowDC(tmpHandle);
    GetWindowRect(m_Option.GetTargetHandle,r );
    r2 := Rect(0,0,r.Right-r.Left,r.Bottom-r.Top);
    try
      c.Handle := DC;
      c.StretchDraw(r2,bmp);
    finally
      ReleaseDC(m_Option.GetTargetHandle,DC);
      c.Free;
    end;
  finally
    bmp.Free;    
  end;
end;


function TCameraCtl.CaptureBitmap(Stream: ITFStream): Boolean;
var
  imgStream: TMemoryStream;
begin
  result := false;
  imgStream := TMemoryStream.Create;
  try
    if m_SampleGrabber.SampleGrabber = nil then
      exit;
    GetBitmap(m_CaptureBitmap);
    m_CaptureBitmap.SaveToStream(imgStream);
    imgStream.Position := 0;
    Stream.WriteBuffer(imgStream.Memory^,imgStream.Size);
    Stream.Position := 0;
    Result := Stream.Size > 0;
  finally
    imgStream.Free;
  end;
end;

procedure TCameraCtl.GetBitmap(Bmp: Graphics.TBitmap);
begin
  FCriticalSection.Enter;
  m_SampleGrabber.GetBitmap(Bmp);
  FCriticalSection.Leave;
end;

function TCameraCtl.GetDevice: IMoniker;
var
  CapEnum : TSysDevEnum;
  i: Cardinal;  
begin
  CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  try
    //�жϵ�ǰϵͳ���Ƿ�װ������ͷ�豸
    if CapEnum.CountFilters = 0 then
    begin
      Raise Exception.Create('��ǰδ��װ������Ƶ�ɼ��豸.');
    end;
    //ȱʡȡ��һ������ͷ�豸
    result := CapEnum.GetMoniker(0);   
    //����û�ָ��������ͷ�豸������ݹ����ȡ�û�ָ��������ͷ�豸
    if m_Option.CameraFriendName <> '' then
    begin
      for i := 0 to CapEnum.CountFilters - 1 do
      begin
        if AnsiCompareText(CapEnum.Filters[i].FriendlyName, m_Option.CameraFriendName) = 0 then
        begin
          result :=  CapEnum.GetMoniker(i);
          if m_Option.CameraIndex = (i + 1) then exit;
        end;
      end;
    end;
  finally
    CapEnum.Free;
  end
end;

function TCameraCtl.GetOption: ICameraOption;
begin
  result := m_Option;
end;

function TCameraCtl.GetReciever: IImgReciever;
begin
  Result := m_ImgReciever;
end;

procedure TCameraCtl.NotifyReceiver;
var
  bmp : Graphics.TBitmap;
begin
  if m_SampleGrabber.SampleGrabber = nil then exit;
  if Assigned(m_ImgReciever) then
  begin
    bmp := Graphics.TBitmap.Create;
    try
      GetBitmap(bmp);
      m_ImgReciever.RecieveBMP(bmp.Handle);
    finally
      bmp.Free;
    end;
  end;
end;

function TCameraCtl.Open: Boolean;
begin
  OpenDevice;
  result := true;
end;




procedure TCameraCtl.OpenDevice;
begin
  m_CaptureGraph.ClearGraph;
  m_CaptureGraph.Active := false;
  m_VideoSource.BaseFilter.Moniker := GetDevice;
  m_CaptureGraph.Active := true;
  with m_CaptureGraph as ICaptureGraphBuilder2 do
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, m_VideoSource as IBaseFilter,
    nil, m_SampleGrabber as IbaseFilter);

  m_CaptureGraph.Play;
end;

procedure TCameraCtl.SampleGrabberBuffer(sender: TObject; SampleTime: Double;
  pBuffer: Pointer; BufferLen: Integer);
begin
  try
    FCriticalSection.Enter;
    try
      if m_Option.GetTargetHandle > 0 then
      begin
        DrawTarget;
      end;

      if Assigned(m_ImgReciever) then
      begin
        NotifyReceiver;
      end;
    finally
      FCriticalSection.Leave;
    end;
  except on e : exception do
    OutputDebugString(PChar(e.Message));

  end;
end;

procedure TCameraCtl.SetReciever(value: IImgReciever);
begin
  m_ImgReciever := value;
end;

{ TCameraOption }

constructor TCameraOption.Create();
begin
  m_FriendName := '';
  m_CameraIndex := 0;
  m_TargetHandle := 0;
end;

function TCameraOption.GetCameraFriendName: WideString;
begin
  result :=  m_FriendName;
end;

function TCameraOption.GetCameraIndex: Cardinal;
begin
  result := m_CameraIndex;
end;

function TCameraOption.GetTargetHandle: Cardinal;
begin
  result := m_TargetHandle;
end;

procedure TCameraOption.SetCameraFriendName(value: WideString);
begin
  m_FriendName := value;
end;

procedure TCameraOption.SetCameraIndex(Value: Cardinal);
begin
  m_CameraIndex := value;
end;

procedure TCameraOption.SetTargetHandle(Value: Cardinal);
begin
  m_TargetHandle := value;
end;

initialization
  CoInitialize(nil);
  FCriticalSection := TCriticalSection.Create;
finalization
  FCriticalSection.Free;
  CoUninitialize();
end.
