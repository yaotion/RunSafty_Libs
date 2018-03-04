unit ufrmCamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DSPack,DSUtil,DirectShow9,jpeg;

type
  {TPictureFormat ͼƬ����}
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
    m_nWidth : Integer;//ͼ����
    m_nHeight : Integer;//ͼ��߶�
    m_strLastError : String;//���һ�δ�����Ϣ
  private
    function VideoPreview(): Boolean;
    procedure EndCapture();
  public
    { Public declarations }
    {���ܣ���ʼ������ͷ
    �쳣�������ʼ��ʧ�ܻ����쳣�׳�}
    function IniCamera(): Boolean;

    {���ܣ�������ͷ
    �쳣�������ʧ�ܻ����쳣�׳�}
    function OpenCamera():Boolean;

    {���ܣ��ر�����ͷ
    �쳣������ر�ʧ�ܻ����쳣�׳�}
    function CloseCamera():Boolean;

    {���ܣ�
        ��������ͷͼƬ
     ������
        FileName : �洢ͼƬ������
        PictureFormat : �洢��ʽ,֧��BMP��JPEG
     ����ֵ:
        ����ɹ�����True,���򷵻�False}
    function CapturePicture(const strFileName: string ;
        PictureFormat : TPictureFormat): Boolean;overload;
    function CapturePictureByStream(var PictureStream: TMemoryStream;
        PictureFormat : TPictureFormat = pfJPEG): Boolean;overload;

    {���ܣ���bmpתΪjpg}
    procedure BMPConverToJpeg(const fgName: string);

    {���ܣ�����ͼ��ֱ���}
    procedure SetResolution(nWidth,nHeiht:Integer);
  public
    property LastError : String read m_strLastError;

  end;

implementation

{$R *.dfm}

{ TfrmCamera }


procedure TfrmCamera.BMPConverToJpeg(const fgName: string);
{���ܣ���bmpתΪjpg}
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
{ ���ܣ�
    ��������ͷͼƬ
  ������
    FileName : �洢ͼƬ������
    PictureFormat : �洢��ʽ,֧��BMP��JPEG
  ����ֵ:
    ����ɹ�����True,���򷵻�False}
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
      OutPutDebugString(PChar('����ʧ��!����:('+E.Message+')'));
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
//���ܣ���ʼ������ͷ
var
  CapEnum: TSysDevEnum; //ϵͳ�豸,uses DSUtil;
var
  PinList: TPinList;
  i, nCapEnumIndex: integer;
  pvi: PVIDEOINFOHEADER;
  VideoMediaTypes: TEnumMediaType;

begin
  Result := False;
  
  OutPutDebugString('��ʼ��SysDevEnum');
  CaptureGraph.ClearGraph;
  CaptureGraph.Active := False;

  SampleGrabber.FilterGraph := CaptureGraph;
  VideoWindow.FilterGraph := CaptureGraph;
  VideoSource.FilterGraph := CaptureGraph;

  CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if CapEnum.CountFilters = 0 then
  begin
    m_strLastError := 'δ�ҵ���Ƶ�豸.';
    OutPutDebugString(PChar(m_strLastError));
    CapEnum.Free;
    exit;
  end;

  nCapEnumIndex := 0;
  for i := 0 to CapEnum.CountFilters - 1 do
  begin
    if CapEnum.Filters[i].FriendlyName = 'e-Loam���� 2.0 Camera' then
    begin
      nCapEnumIndex := i;
      Break;
    end;
  end;

  VideoSource.BaseFilter.Moniker := CapEnum.GetMoniker(nCapEnumIndex);
  CapEnum.Free;

  CaptureGraph.Active := True;
    
  try
    {���÷ֱ���}
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
      m_strLastError := '������Ƶ��׽ʧ��,����:('+E.Message+')';
      OutPutDebugString(PChar(m_strLastError));
      Exit;
    end;
  end;

  Result := True;

end;

function TfrmCamera.OpenCamera: Boolean;
{���ܣ�������ͷ
�쳣�������ʧ�ܻ����쳣�׳�}
begin
  Result := VideoPreview();
end;

procedure TfrmCamera.SetResolution(nWidth, nHeiht: Integer);
{���ܣ�����ͼ��ֱ���}
begin
  m_nWidth := nWidth;
  m_nHeight := nHeiht;
end;

function TfrmCamera.VideoPreview: Boolean;
// ����:Ԥ����Ƶ,ʧ�ܷ���False
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
        m_strLastError := 'ͼ��Ԥ��ʧ��!����Filterʧ��';
        OutPutDebugString(PChar(m_strLastError));
      end;
    end;
    CaptureGraph.Play;
  except
    On E:Exception do
    begin
      m_strLastError := 'ͼ��Ԥ��ʧ��!����:('+E.Message+')';
      OutPutDebugString(PChar(m_strLastError));
      Exit;
    end;
  end;
  Result := True;
end;

end.