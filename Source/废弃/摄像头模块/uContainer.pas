unit uContainer;

interface

uses
  SysUtils, Classes, DSPack,DSUtil,DirectShow9,jpeg,ActiveX,Graphics,Controls,
  Windows,StrUtils,uRsCameraLibDef,Messages,SyncObjs,Forms;
type
  TContainer = class(TDataModule)
    SampleGrabber: TSampleGrabber;
    VideoSource: TFilter;
    CaptureGraph: TFilterGraph;
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    m_Bitmap: Graphics.TBitmap;
    m_ParentHWND: Cardinal;
    m_ParentWidth: integer;
    m_ParentHeight: integer;
    m_ImgReciever: IImgReciever;
    FCriticalSection: TCriticalSection;
    //获取用户指定的摄像头设备，如果用户未指定则返回第一个。当找不到设备或者无摄像头设备时返回false
    function  GetDevice() :IMoniker;
    procedure OpenDevice;
  public
    { Public declarations }
    procedure InitParentRect();
    {功能：初始化摄像头，支持数字编号和'vid_058f&pid_0361'字符串编号. -add by LiMingLei 2015.6.10
    异常：如果初始化失败会有异常抛出}
    function  IniCamera(): Boolean;
    function  OpenCamera():Boolean;
    procedure CloseCamera();
    procedure GetBMP(Stream: ITFStream);
    procedure DrawBMP();
    procedure NotifyBMP();
    procedure CaptureBMP(S:ITFStream);
  public    
    property ParentHWND: Cardinal read m_ParentHWND write m_ParentHWND;
    property ImgReciever: IImgReciever read m_ImgReciever write m_ImgReciever;
  end;

implementation

{$R *.dfm}

procedure TContainer.CaptureBMP(S: ITFStream);
var
  imgStream: TMemoryStream;
begin
  imgStream := TMemoryStream.Create;
  try
    m_Bitmap.SaveToStream(imgStream);
    imgStream.Position := 0;
    S.WriteBuffer(imgStream.Memory^,imgStream.Size);
    S.Position := 0;
  finally
    imgStream.Free;
  end;
end;

procedure TContainer.CloseCamera;
begin
  SampleGrabber.OnBuffer := nil;
  CaptureGraph.Active := False;
end;

procedure TContainer.DataModuleCreate(Sender: TObject);
begin
  m_Bitmap := Graphics.TBitmap.Create;
  //属性赋值
  VideoSource.FilterGraph := CaptureGraph;
  FCriticalSection := TCriticalSection.Create;
end;

procedure TContainer.DataModuleDestroy(Sender: TObject);
begin
  m_Bitmap.Free;
  FCriticalSection.Free;
end;

procedure TContainer.DrawBMP;
var
  Canvas: TCanvas;
  DC: HDC;
begin
  Canvas := TCanvas.Create;
  DC := GetWindowDC(m_ParentHWND);
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    Canvas.StretchDraw(Rect(0,0,m_ParentWidth,m_ParentHeight),m_Bitmap);
  finally
    Canvas.Unlock;
    ReleaseDC(m_ParentHWND,DC);
    Canvas.Free;
  end;
end;

procedure TContainer.GetBMP(Stream: ITFStream);
begin
  FCriticalSection.Enter;
  CaptureBMP(Stream);
  FCriticalSection.Leave;
end;

function TContainer.GetDevice(): IMoniker;
var
  CapEnum : TSysDevEnum;
  i: Integer;  
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
//    if length(CameraID) > 0 then
//    begin
//      for i := 0 to CapEnum.CountFilters - 1 do
//      begin
//        result := CapEnum.GetMoniker(i);
//        //此处应加入自定义摄像头读取操作
//      end;
//    end;
  finally
    CapEnum.Free;
  end

end;

function TContainer.IniCamera(): Boolean;
begin
  VideoSource.BaseFilter.Moniker := GetDevice;
  Result := True;
end;


procedure TContainer.InitParentRect;
var
  rec: TRect;
begin
  if m_ParentHWND <> 0 then
  begin
    GetWindowRect(m_ParentHWND,rec);
    m_ParentWidth := rec.Right - rec.Left;
    m_ParentHeight := rec.Bottom - rec.Top;
  end;

  if m_ParentWidth = 0 then
    m_ParentWidth := 360;

  if m_ParentWidth = 0 then
    m_ParentWidth := 240;
end;


procedure TContainer.NotifyBMP;
begin
  if Assigned(m_ImgReciever) then
  begin
    m_ImgReciever.RecieveBMP(m_Bitmap.Handle);
  end;
end;

function TContainer.OpenCamera: Boolean;
begin
  result := false;
  SampleGrabber.OnBuffer := SampleGrabberBuffer;
  SampleGrabber.FilterGraph := CaptureGraph;
  case CaptureGraph.State of
    gsUninitialized: begin
        IniCamera;
        OpenDevice;
        result := true;
    end;
    gsStopped: begin
      OpenDevice;
      result := true;
    end;
    gsPaused: begin
      OpenDevice;
      result := true;
    end;
    gsPlaying: begin
      result := true;
      exit;
    end;
  end;
end;

procedure TContainer.OpenDevice;
begin
  CaptureGraph.Active := true;
  with CaptureGraph as IcaptureGraphBuilder2 do
  begin
    if VideoSource.BaseFilter.DataLength <= 0 then
    begin
      raise Exception.Create('图像预览失败!连接Filter失败');
    end;
    CheckDSError(RenderStream(@PIN_CATEGORY_PREVIEW,
          nil,
          VideoSource as IBaseFilter,
          nil,
          SampleGrabber as IBaseFilter));
    CaptureGraph.Play;
  end;
end;

procedure TContainer.SampleGrabberBuffer(sender: TObject; SampleTime: Double;
  pBuffer: Pointer; BufferLen: Integer);
begin
  if (m_ParentHWND = 0) and (not Assigned(m_ImgReciever)) then Exit;
  FCriticalSection.Enter;
  try
    SampleGrabber.GetBitmap(m_Bitmap);
    if m_ParentHWND <> 0 then
    begin
      DrawBmp;
    end;

    if Assigned(m_ImgReciever) then
    begin
      NotifyBMP;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;


end.
