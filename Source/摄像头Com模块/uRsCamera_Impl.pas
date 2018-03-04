unit uRsCamera_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, SysUtils,ActiveX, Classes,Graphics,DSPack,
  Windows,SyncObjs,DirectShow9,DSUtil, RsCameraLib_TLB, StdVcl;

type


  TCamera = class(TAutoObject,ICamera)
  public
    procedure Initialize; override;
    destructor Destroy;override;
  private
    //获取设备类
    m_CapEnum : TSysDevEnum;
    //配置
    //摄像头控制对象
    m_SampleGrabber: TSampleGrabber;
    m_VideoSource: TFilter;
    m_CaptureGraph: TFilterGraph;
    //摄像头图像存储
    m_CaptureBitmap: Graphics.TBitmap;
    //摄像头图像接收事件
    m_ImgReciever: ImgReciever;
  private
    m_FriendName : WideString;
    m_CameraIndex : Cardinal;
    m_TargetHandle : Cardinal;
  private
    m_nWidth : Integer;//图像宽度
    m_nHeight : Integer;//图像高度
    m_strLastError : String;//最后一次错误信息
  private
    //在目标控件上绘制图像
    procedure DrawTarget();
    //通知接收者有图像传递过来
    procedure NotifyReceiver();
  private
      {功能：设置摄像头格式，可根据位深先后顺序优先选择}
    function SetVideoFormat(BaseFilter: IBaseFilter; nWidth, nHeight: Integer;
      const biBitCounts: array of Integer): Boolean;

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
    function CaptureBitmap(var Stream: OleVariant): WordBool; safecall;
    procedure Close; safecall;
    function Open: WordBool; safecall;
    procedure Set_ImgReciever(const Value: ImgReciever); safecall;
    function Get_CountFilters: Integer; safecall;
    function Get_Names(Index: Integer): WideString; safecall;
    procedure Refresh; safecall;
    function Get_CameraIndex: Integer; safecall;
    function Get_CameraName: WideString; safecall;
    function Get_TargetHandle: Integer; safecall;
    procedure Set_CameraIndex(Value: Integer); safecall;
    procedure Set_CameraName(const Value: WideString); safecall;
    procedure Set_TargetHandle(Value: Integer); safecall;
  
  end;


var
  FCriticalSection : TCriticalSection;

implementation

uses ComServ,Variants,uTFVariantUtils;



procedure TCamera.Initialize;
begin
  inherited Initialize;

  m_FriendName := '';
  m_CameraIndex := 0;
  m_TargetHandle := 0;

  m_nWidth := 320;
  m_nHeight := 240;

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

  m_CaptureBitmap := Graphics.TBitmap.Create;

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
  i: Cardinal;
begin
  //判断当前系统内是否看装了摄像头设备
  if m_CapEnum.CountFilters = 0 then
  begin
    result := nil;
    Exit ;
  end;
  //缺省取第一个摄像头设备
  result := m_CapEnum.GetMoniker(0);
  //如果用户指定了摄像头设备，则根据规则获取用户指定的摄像头设备
  if m_FriendName <> '' then
  begin
    for i := 0 to m_CapEnum.CountFilters - 1 do
    begin
      if AnsiCompareText(m_CapEnum.Filters[i].FriendlyName, m_FriendName) = 0 then
      begin
        result :=  m_CapEnum.GetMoniker(i);
        if m_CameraIndex = (i + 1) then exit;
      end;
    end;
  end;
end;

function TCamera.Get_ImgReciever: ImgReciever;
begin
  Result := m_ImgReciever;
end;



function TCamera.CaptureBitmap(var Stream: OleVariant): WordBool;
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
    Stream :=TTFVariantUtils.StreamToTemplateOleVariant(imgStream);
    result := true;
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
  m_CaptureBitmap.Free;
  m_CapEnum.Free;
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
  if m_TargetHandle = 0 then exit;
  if m_SampleGrabber.SampleGrabber = nil then exit;
  
  tmpHandle := m_TargetHandle;
  bmp := Graphics.TBitmap.Create;
  try
    GetBitmap(bmp);
    c := TCanvas.Create;
    DC := GetWindowDC(tmpHandle);
    GetWindowRect(m_TargetHandle,r );
    r2 := Rect(0,0,r.Right-r.Left,r.Bottom-r.Top);
    try
      c.Handle := DC;
      c.StretchDraw(r2,bmp);
    finally
      ReleaseDC(m_TargetHandle,DC);
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
  SetVideoFormat(m_VideoSource as IBaseFilter, m_nWidth, m_nHeight, [24, 16, 8]);

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
      if m_TargetHandle > 0 then
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



function TCamera.Get_CountFilters: Integer;
begin
  Result := m_CapEnum.CountFilters;
end;

function TCamera.Get_Names(Index: Integer): WideString;
begin
  if ( Index < 0 ) or  ( Index >=  Get_CountFilters ) then
    result := ''
  else
    result :=   m_CapEnum.Filters[Index].FriendlyName ;
end;

procedure TCamera.Refresh;
begin
  if Assigned(m_CapEnum) then
    m_CapEnum.Free;
  m_CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
end;

function TCamera.Get_CameraIndex: Integer;
begin
  result := m_CameraIndex;
end;

function TCamera.Get_CameraName: WideString;
begin
  result :=  m_FriendName;
end;

function TCamera.Get_TargetHandle: Integer;
begin
  result := m_TargetHandle;
end;

function TCamera.SetVideoFormat(BaseFilter: IBaseFilter; nWidth,
  nHeight: Integer; const biBitCounts: array of Integer): Boolean;
var
  PinList: TPinList;
  i: integer;
  pvi: PVIDEOINFOHEADER;
  VideoMediaTypes: TEnumMediaType;
  j: Integer;
begin
  result := False;
  try
    {设置分辨率}
    PinList := TPinList.Create(BaseFilter);
    VideoMediaTypes := TEnumMediaType.Create(PinList.First);
    try
      for j := 0 to High(biBitCounts) do
      begin
        for i := 0 to VideoMediaTypes.Count - 1 do
        begin
          pvi := PVIDEOINFOHEADER(VideoMediaTypes.Items[i].AMMediaType.pbFormat);

          if pvi.bmiHeader.biBitCount = biBitCounts[j] then
          begin
            if (pvi.bmiHeader.biWidth = nWidth) and
              (pvi.bmiHeader.biheight = nHeight) then
            begin
              (PinList.First as IAMStreamConfig).SetFormat(
                VideoMediaTypes.Items[i].AMMediaType^);

              result := True;
              exit;
            end;
          end;
        end;
      end;
    finally
      VideoMediaTypes.Free;
      PinList.Free;
    end;
  except
    On E:Exception do
    begin
      m_strLastError := '启动视频捕捉失败,错误:('+E.Message+')';
      OutPutDebugString(PChar(m_strLastError));
      Exit;
    end;
  end;
end;

procedure TCamera.Set_CameraIndex(Value: Integer);
begin
  m_CameraIndex := Value ;
end;

procedure TCamera.Set_CameraName(const Value: WideString);
begin
  m_FriendName :=   Value ;
end;

procedure TCamera.Set_TargetHandle(Value: Integer);
begin
  m_TargetHandle := Value ;
end;



initialization
  TAutoObjectFactory.Create(ComServer, TCamera, Class_Camera,
    ciMultiInstance, tmApartment);


  FCriticalSection := TCriticalSection.Create;

finalization
  FCriticalSection.Free;
end.
