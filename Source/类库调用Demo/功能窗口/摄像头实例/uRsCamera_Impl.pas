unit uRsCamera_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, SysUtils,ActiveX, AxCtrls, Classes,Graphics,DSPack,
  Windows,SyncObjs,DirectShow9,DSUtil, RsCameraLib_TLB, StdVcl;

type


  //流接口适配器实现
  TTFStreamAdapter = class(TAutoObject,ITFStream)
  public
    procedure Initialize; override; 
    destructor Destroy;override;
  private
    m_Stream: TStream;
  private
    function Read(var Buffer: Shortint; Count: Integer): Integer; safecall;
    function Write(var Buffer: Shortint; Count: Integer): Integer;safecall;
    function Seek(Offset: Integer; Origin: Word): Integer;safecall;
    procedure ReadBuffer(var Buffer: Shortint; Count: Integer);safecall;
    procedure WriteBuffer(var Buffer: Shortint; Count: Integer);safecall;

    function Get_Position: Int64; safecall;
    procedure Set_Position(Value: Int64); safecall;
    function Get_Size: Int64; safecall;
    procedure Set_Size(Value: Int64); safecall;
  end;
  


  TCameraOption = class(TAutoObject,ICameraOption)
  public
    procedure Initialize; override;
    destructor Destroy;override;
  private
    m_FriendName : WideString;
    m_CameraIndex : Cardinal;
    m_TargetHandle : Cardinal;
  public
    function Get_CameraFriendName: WideString; safecall;
    procedure Set_CameraFriendName(const Value: WideString); safecall;
    function Get_CameraIndex: Integer; safecall;
    procedure Set_CameraIndex(Value: Integer); safecall;
    function Get_TargetHandle: Integer; safecall;
    procedure Set_TargetHandle(Value: Integer); safecall;
  end;

  TCamera = class(TAutoObject, IConnectionPointContainer, ICamera)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: ICameraEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    procedure Initialize; override;
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
    m_ImgReciever: ImgReciever;
  private
    //在目标控件上绘制图像
    procedure DrawTarget();
    //通知接收者有图像传递过来
    procedure NotifyReceiver();
  private
      //处理流回传的事件方法
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    //打开摄像头设备
    procedure OpenDevice;
    //获取摄像头设备
    function  GetDevice() :IMoniker;
    //获取图像
    procedure GetBitmap(Bmp : Graphics.TBitmap);
  protected
    function Get_ImgReciever: ImgReciever; safecall;
    function Get_Option: ICameraOption; safecall;
    function CaptureBitmap(const TFStream: ITFStream): WordBool; safecall;
    procedure Close; safecall;
    function Open: WordBool; safecall;
    procedure Set_ImgReciever(const Value: ImgReciever); safecall;

    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
  end;


var
  FCriticalSection : TCriticalSection;

implementation

uses ComServ;

procedure TCamera.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ICameraEvents;
end;

procedure TCamera.Initialize;
var
  hr : Cardinal;
  Factory: IClassFactory;
  tmpIt : IUnknown;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;


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
  //m_Option := TCameraOption.Create;


  hr := DllGetClassObject(CLASS_CameraOption, IClassFactory, Factory);
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
  m_Option :=  tmpIt as ICameraOption;

end;



procedure TCamera.NotifyReceiver;
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

procedure TCamera.GetBitmap(Bmp: Graphics.TBitmap);
begin
  FCriticalSection.Enter;
  m_SampleGrabber.GetBitmap(Bmp);
  FCriticalSection.Leave;
end;

function TCamera.GetDevice: IMoniker;
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

function TCamera.Get_ImgReciever: ImgReciever;
begin
  Result := m_ImgReciever;
end;

function TCamera.Get_Option: ICameraOption;
begin
  result := m_Option;
end;

function TCamera.CaptureBitmap(const TFStream: ITFStream): WordBool;
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
    //TFStream.WriteBuffer(imgStream.Memory^,imgStream.Size);
    TFStream.Position := 0;
    Result := TFStream.Size > 0;
  finally
    imgStream.Free;
  end;
end;

procedure TCamera.Close;
begin
  m_CaptureGraph.ClearGraph;
  m_CaptureGraph.Active := false;
end;

destructor TCamera.Destroy;
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

procedure TCamera.DrawTarget;
var
  c: TCanvas;
  DC: HDC;
  r,r2 : TRect;
  tmpHandle : Cardinal;
  bmp : Graphics.TBitmap;
begin
  if m_Option.Get_TargetHandle = 0 then exit;
  if m_SampleGrabber.SampleGrabber = nil then exit;
  
  tmpHandle := m_Option.Get_TargetHandle;
  bmp := Graphics.TBitmap.Create;
  try
    GetBitmap(bmp);
    c := TCanvas.Create;
    DC := GetWindowDC(tmpHandle);
    GetWindowRect(m_Option.Get_TargetHandle,r );
    r2 := Rect(0,0,r.Right-r.Left,r.Bottom-r.Top);
    try
      c.Handle := DC;
      c.StretchDraw(r2,bmp);
    finally
      ReleaseDC(m_Option.Get_TargetHandle,DC);
      c.Free;
    end;
  finally
    bmp.Free;    
  end;
end;

function TCamera.Open: WordBool;
begin
  OpenDevice;
  result := true;
end;

procedure TCamera.OpenDevice;
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

procedure TCamera.SampleGrabberBuffer(sender: TObject; SampleTime: Double;
  pBuffer: Pointer; BufferLen: Integer);
begin
  try
    FCriticalSection.Enter;
    try
      if m_Option.Get_TargetHandle > 0 then
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

procedure TCamera.Set_ImgReciever(const Value: ImgReciever);
begin
  m_ImgReciever := value;
end;





destructor TCameraOption.Destroy;
begin

  inherited;
end;

function TCameraOption.Get_CameraFriendName: WideString;
begin
  result :=  m_FriendName;
end;

function TCameraOption.Get_CameraIndex: Integer;
begin
  result := m_CameraIndex;
end;

function TCameraOption.Get_TargetHandle: Integer;
begin
  result := m_TargetHandle;
end;

procedure TCameraOption.Initialize;
begin
  inherited;
  m_FriendName := '';
  m_CameraIndex := 0;
  m_TargetHandle := 0;
end;

procedure TCameraOption.Set_CameraFriendName(const Value: WideString);
begin
  m_FriendName := value;
end;

procedure TCameraOption.Set_CameraIndex(Value: Integer);
begin
  m_CameraIndex := value;
end;

procedure TCameraOption.Set_TargetHandle(Value: Integer);
begin
  m_TargetHandle := value;
end;

{ TTFStreamAdapter }




destructor TTFStreamAdapter.Destroy;
begin
  m_Stream.Free;
  inherited;
end;

function TTFStreamAdapter.Get_Position: Int64;
begin
  Result := m_Stream.Position;
end;

function TTFStreamAdapter.Get_Size: int64;
begin
  Result := m_Stream.Size;
end;

procedure TTFStreamAdapter.Initialize;
begin
  inherited;
  m_Stream:= TMemoryStream.Create;
end;

function TTFStreamAdapter.Read(var Buffer: Shortint; Count: Integer): Integer;
begin
  Result := m_Stream.Read(Buffer,Count);
end;

procedure TTFStreamAdapter.ReadBuffer(var Buffer: Shortint; Count: Integer);
begin
  m_Stream.ReadBuffer(Buffer,Count);
end;

function TTFStreamAdapter.Seek(Offset: Integer; Origin: Word): Integer;
begin
  Result := m_Stream.Seek(Offset,Origin);
end;

procedure TTFStreamAdapter.Set_Position(Value: Int64);
begin
  m_Stream.Position := value;
end;



procedure TTFStreamAdapter.Set_Size(Value: Int64);
begin
  m_Stream.Size := Value ;
end;

function TTFStreamAdapter.Write(var Buffer: Shortint; Count: Integer): Integer;
begin
  Result := m_Stream.Write(Buffer,Count);
end;

procedure TTFStreamAdapter.WriteBuffer(var Buffer: Shortint; Count: Integer);
begin
  m_Stream.WriteBuffer(Buffer,Count);
end;



initialization
  TAutoObjectFactory.Create(ComServer, TCamera, Class_Camera,
    ciMultiInstance, tmApartment);

  FCriticalSection := TCriticalSection.Create;

finalization
  FCriticalSection.Free;
end.
