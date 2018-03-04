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
    //配置
    m_Option : ICameraOption;
    //摄像头控制对象
    m_SampleGrabber: TSampleGrabber;
    m_VideoSource: TFilter;
    m_CaptureGraph: TFilterGraph;
    //摄像头图像存储
    m_Bitmap,m_CaptureBitmap: Graphics.TBitmap;
    //摄像头图像接收事件
    m_ImgReciever: IImgReciever;
  private
    //在目标控件上绘制图像
    procedure DrawTarget();
    //通知接收者有图像传递过来
    procedure NotifyReceiver();
  private
    //属性方法
    function  GetReciever: IImgReciever;stdcall;
    procedure SetReciever(value: IImgReciever);stdcall;
    function  GetOption : ICameraOption;stdcall;
    //处理流回传的事件方法
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    //打开摄像头设备
    procedure OpenDevice;
    //获取摄像头设备
    function  GetDevice() :IMoniker;
    //获取图像
    procedure GetBitmap(Bmp : Graphics.TBitmap);
  public
    //打开摄像头
    function  Open(): Boolean;stdcall;
    //关闭摄像头
    procedure Close();stdcall;
    //截图
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
    //判断当前系统内是否看装了摄像头设备
    if CapEnum.CountFilters = 0 then
    begin
      Raise Exception.Create('当前未安装任务视频采集设备.');
    end;
    //缺省取第一个摄像头设备
    result := CapEnum.GetMoniker(0);   
    //如果用户指定了摄像头设备，则根据规则获取用户指定的摄像头设备
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
