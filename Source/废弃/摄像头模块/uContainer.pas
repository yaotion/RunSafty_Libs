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
    //��ȡ�û�ָ��������ͷ�豸������û�δָ���򷵻ص�һ�������Ҳ����豸����������ͷ�豸ʱ����false
    function  GetDevice() :IMoniker;
    procedure OpenDevice;
  public
    { Public declarations }
    procedure InitParentRect();
    {���ܣ���ʼ������ͷ��֧�����ֱ�ź�'vid_058f&pid_0361'�ַ������. -add by LiMingLei 2015.6.10
    �쳣�������ʼ��ʧ�ܻ����쳣�׳�}
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
  //���Ը�ֵ
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
    //�жϵ�ǰϵͳ���Ƿ�װ������ͷ�豸
    if CapEnum.CountFilters = 0 then
    begin
      Raise Exception.Create('��ǰδ��װ������Ƶ�ɼ��豸.');
    end;
    //ȱʡȡ��һ������ͷ�豸
    result := CapEnum.GetMoniker(0);   
    //����û�ָ��������ͷ�豸������ݹ����ȡ�û�ָ��������ͷ�豸
//    if length(CameraID) > 0 then
//    begin
//      for i := 0 to CapEnum.CountFilters - 1 do
//      begin
//        result := CapEnum.GetMoniker(i);
//        //�˴�Ӧ�����Զ�������ͷ��ȡ����
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
      raise Exception.Create('ͼ��Ԥ��ʧ��!����Filterʧ��');
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
