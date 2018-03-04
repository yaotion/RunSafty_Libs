unit ufrmCamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DSPack,DSUtil,DirectShow9,jpeg;

type
  {TPictureFormat 图片类型}
  TPictureFormat = (pfBMP,pfJPEG);

  TfrmCamera = class(TFrame)
    VideoWindow: TVideoWindow;
    SampleGrabber: TSampleGrabber;
    VideoSource: TFilter;
    AudioSourceFilter: TFilter;
    CaptureGraph: TFilterGraph;
  public
    constructor Create(AOwner: TComponent); override;
  private
    { Private declarations }
    m_nWidth : Integer;//图像宽度
    m_nHeight : Integer;//图像高度
    m_strLastError : String;//最后一次错误信息
  private
    function VideoPreview(): Boolean;
    procedure EndCapture();
  public
    { Public declarations }
    {功能：初始化摄像头
    异常：如果初始化失败会有异常抛出}
    function IniCamera(): Boolean;

    {功能：打开摄像头
    异常：如果打开失败会有异常抛出}
    function OpenCamera():Boolean;

    {功能：关闭摄像头
    异常：如果关闭失败会有异常抛出}
    function CloseCamera():Boolean;

    {功能：
        保存摄像头图片
     参数：
        FileName : 存储图片的名称
        PictureFormat : 存储格式,支持BMP和JPEG
     返回值:
        保存成功返回True,否则返回False}
    function CapturePicture(const strFileName: string ;
        PictureFormat : TPictureFormat): Boolean;overload;
    function CapturePictureByStream(var PictureStream: TMemoryStream;
        PictureFormat : TPictureFormat = pfJPEG): Boolean;overload;

    {功能：将bmp转为jpg}
    procedure BMPConverToJpeg(const fgName: string);

    {功能：设置图像分辨率}
    procedure SetResolution(nWidth,nHeiht:Integer);
  public
    property LastError : String read m_strLastError;

  end;

implementation

{$R *.dfm}

{ TfrmCamera }


procedure TfrmCamera.BMPConverToJpeg(const fgName: string);
{功能：将bmp转为jpg}
var
  JpgFile: TJpegImage;
  BmpFile: TBitmap;
  S: string;
begin
  S := fgName;
  try
    JpgFile := TJpegImage.Create;
    JpgFile.CompressionQuality := 100;
    JpgFile.Performance := jpBestQuality;
    JPgFile.PixelFormat := jf24Bit;
    BmpFile := TBitmap.Create;
    BmpFile.LoadFromFile(S);
    JpgFile.Assign(bmpFile);
    s := ChangeFileExt(S, '.jpg');
    JpgFile.SaveToFile(S);
    Application.processmessages;
  finally
    FreeAndNil(bmpFile);
    FreeAndNil(JpgFile);
  end;
end;

function TfrmCamera.CapturePicture(const strFileName: string ;
    PictureFormat : TPictureFormat): Boolean;
{ 功能：
    保存摄像头图片
  参数：
    FileName : 存储图片的名称
    PictureFormat : 存储格式,支持BMP和JPEG
  返回值:
    保存成功返回True,否则返回False}
var
  PictureStream : TMemoryStream;
begin
  Result := False;
  PictureStream := TMemoryStream.Create;
  try
    if CapturePictureByStream(PictureStream,PictureFormat) = False then Exit;
    if FileExists(strFileName) then DeleteFile(strFileName);
    PictureStream.SaveToFile(strFileName);
    Result := True;
  finally
    PictureStream.Free;
  end;
end;

function TfrmCamera.CapturePictureByStream(var PictureStream: TMemoryStream;
  PictureFormat: TPictureFormat): Boolean;
var
  PictureBmp: TBitmap;
  MyJpeg: TJpegImage;
begin
  Result := False;
  if not CaptureGraph.Active then Exit;
  PictureStream.Position := 0;
  PictureBmp := TBitmap.Create;
  try
    SampleGrabber.GetBitmap(PictureBmp);
    if PictureFormat = pfBMP then
    begin
      PictureBmp.SaveToStream(PictureStream);
    end
    else
    begin
      myJpeg := TJpegImage.Create;
      myJpeg.Assign(PictureBmp);
      myJpeg.CompressionQuality := 100;
      myJpeg.Compress;
      myJpeg.SaveToStream(PictureStream);
      myJpeg.Free;
    end;
  except
    On E:Exception do
    begin
      PictureBmp.free;
      OutPutDebugString(PChar('拍照失败!错误:('+E.Message+')'));
      Exit;
    end;
  end;
  PictureBmp.free;
  Result := True;

end;

function TfrmCamera.CloseCamera: Boolean;
begin
 try
   EndCapture();
   Result := True;
 except
  on E: Exception do
   raise E.Create(E.Message);
 end;
end;

constructor TfrmCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_nWidth := 320;
  m_nHeight := 240;
end;

procedure TfrmCamera.EndCapture;
begin
  CaptureGraph.ClearGraph;
  CaptureGraph.Active := False;  
end;

function TfrmCamera.IniCamera: Boolean;
//功能：初始化摄像头
var
  CapEnum: TSysDevEnum; //系统设备,uses DSUtil;
var
  PinList: TPinList;
  i, nCapEnumIndex: integer;
  pvi: PVIDEOINFOHEADER;
  VideoMediaTypes: TEnumMediaType;

begin
  Result := False;
  
  OutPutDebugString('初始化SysDevEnum');
  CaptureGraph.ClearGraph;
  CaptureGraph.Active := False;

  SampleGrabber.FilterGraph := CaptureGraph;
  VideoWindow.FilterGraph := CaptureGraph;
  VideoSource.FilterGraph := CaptureGraph;

  CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if CapEnum.CountFilters = 0 then
  begin
    m_strLastError := '未找到视频设备.';
    OutPutDebugString(PChar(m_strLastError));
    CapEnum.Free;
    exit;
  end;

  nCapEnumIndex := 0;
  for i := 0 to CapEnum.CountFilters - 1 do
  begin
    if CapEnum.Filters[i].FriendlyName = 'e-Loam良田 2.0 Camera' then
    begin
      nCapEnumIndex := i;
      Break;
    end;
  end;

  VideoSource.BaseFilter.Moniker := CapEnum.GetMoniker(nCapEnumIndex);
  CapEnum.Free;

  CaptureGraph.Active := True;
    
  try
    {设置分辨率}
    PinList := TPinList.Create(VideoSource as IBaseFilter);
    VideoMediaTypes := TEnumMediaType.Create(PinList.First);

    for i := 0 to VideoMediaTypes.Count - 1 do
    begin
      pvi := PVIDEOINFOHEADER(VideoMediaTypes.Items[i].AMMediaType.pbFormat);
      if pvi.bmiHeader.biBitCount = 24 then
      begin
        if (pvi.bmiHeader.biWidth = m_nWidth) and
          (pvi.bmiHeader.biheight = m_nHeight) then
        begin
          (PinList.First as IAMStreamConfig).SetFormat(
            VideoMediaTypes.Items[i].AMMediaType^);
          Break;
        end;
      end;
    end;

    VideoMediaTypes.Free;
    PinList.Free;
  except
    On E:Exception do
    begin
      m_strLastError := '启动视频捕捉失败,错误:('+E.Message+')';
      OutPutDebugString(PChar(m_strLastError));
      Exit;
    end;
  end;

  Result := True;

end;

function TfrmCamera.OpenCamera: Boolean;
{功能：打开摄像头
异常：如果打开失败会有异常抛出}
begin
  Result := VideoPreview();
end;

procedure TfrmCamera.SetResolution(nWidth, nHeiht: Integer);
{功能：设置图像分辨率}
begin
  m_nWidth := nWidth;
  m_nHeight := nHeiht;
end;

function TfrmCamera.VideoPreview: Boolean;
// 功能:预览视频,失败返回False
begin
  Result := False;
  try
    CaptureGraph.ClearGraph;
    with CaptureGraph as IcaptureGraphBuilder2 do
    begin
      if VideoSource.BaseFilter.DataLength > 0 then
      begin
        CheckDSError(RenderStream(@PIN_CATEGORY_PREVIEW,
            nil,
            VideoSource as IBaseFilter,
            SampleGrabber as IBaseFilter,
            VideoWindow as IBaseFilter));
      end
      else
      begin
        m_strLastError := '图像预览失败!连接Filter失败';
        OutPutDebugString(PChar(m_strLastError));
      end;
    end;
    CaptureGraph.Play;
  except
    On E:Exception do
    begin
      m_strLastError := '图像预览失败!错误:('+E.Message+')';
      OutPutDebugString(PChar(m_strLastError));
      Exit;
    end;
  end;
  Result := True;
end;

end.