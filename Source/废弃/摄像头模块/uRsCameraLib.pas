unit uRsCameraLib;

interface
uses
  classes,sysutils,windows,graphics,uRsLibUtils,uRsLibClass,uRsLibPoolLib;

type
  //ͼ����սӿ�
  //���ڽ��ն�̬ͼ��
  IImgReciever = interface
  ['{3F6967A5-2675-4E33-BCDF-EEF2B489585C}']
    procedure RecieveBMP(BITMAP: HBITMAP);stdcall;
  end;


  //ImgReciever  DELPHIʵ�֣��������������ʹ�ã��ɰ��Լ���ʹ�÷�ʽʵ��
  TRecieveBMPEvent = procedure(Sender : Pointer;BITMAP: HBITMAP) of object;


  //ͼ�ӽ���ʵ����
  //CopyFromHandle����Ϊ��BMP�������һ��ͼ��
  TImgReciever = class(TInterfacedObject,IImgReciever)
  private
    m_OnRecieveBMP: TRecieveBMPEvent;
  public
    class procedure CopyFromHandle(hBIT: HBITMAP;BMP: TBitmap);
    procedure RecieveBMP(BITMAP: HBITMAP);virtual;stdcall;
    
    property OnRecieverImg: TRecieveBMPEvent read m_OnRecieveBMP write m_OnRecieveBMP;
  end;

  //�������ӿ�
  ITFStream = interface
  ['{3E03B168-42D3-452C-B240-44B4104ECCA9}']
    function Read(var Buffer; Count: Longint): Longint;stdcall;
    function Write(const Buffer; Count: Longint): Longint;stdcall;
    function Seek(Offset: Longint; Origin: Word): Longint;stdcall;
    procedure ReadBuffer(var Buffer; Count: Longint);stdcall;
    procedure WriteBuffer(const Buffer; Count: Longint);stdcall;
    function GetPosition(): Int64;stdcall;
    procedure SetPosition(const value: Int64);stdcall;
    function GetSize: int64;stdcall;
    procedure SetSize64(const value: Int64);stdcall;

    property Position: Int64 read GetPosition write SetPosition;
    property Size: Int64 read GetSize write SetSize64;
  end;


  //���ӿ�������ʵ��
  TTFStreamAdapter = class(TInterfacedObject,ITFStream)
  public
    constructor Create(Stream: TStream);
  private
    m_Stream: TStream;
  private
    function Read(var Buffer; Count: Longint): Longint;stdcall;
    function Write(const Buffer; Count: Longint): Longint;stdcall;
    function Seek(Offset: Longint; Origin: Word): Longint;stdcall;
    procedure ReadBuffer(var Buffer; Count: Longint);stdcall;
    procedure WriteBuffer(const Buffer; Count: Longint);stdcall;
    function GetPosition(): Int64;stdcall;
    procedure SetPosition(const value: Int64);stdcall;
    function GetSize: int64;stdcall;
    procedure SetSize64(const value: Int64);stdcall;
  end;

  ICameraOption = interface
  ['{51DD0C7A-D6A9-43CF-BD4A-0D75EA0EB7BD}']
      //////////////////////���Է���/////////////////////////////////////////////
    function  GetCameraFriendName: WideString;stdcall;
    procedure SetCameraFriendName(value: WideString);stdcall;
    function  GetCameraIndex() : Cardinal;stdcall;
    procedure SetCameraIndex(Value : Cardinal);stdcall;
    function  GetTargetHandle() : Cardinal;stdcall;
    procedure SetTargetHandle(Value : Cardinal);stdcall;

    //����ͷ���豸����������ʾ������
    property CameraFriendName: WideString read GetCameraFriendName write SetCameraFriendName;
    //����ͷ��ͬ���豸�������е����
    property CameraIndex : Cardinal read GetCameraIndex write SetCameraIndex;
    //ͼ����ʾ�ؼ����
    property TargetHandle : Cardinal read GetTargetHandle write SetTargetHandle;
  end;
  
  //����ͷ���ƽӿ�
  ICamera = interface
  ['{7BBBB6AD-D3DB-47E5-B1C8-AEC2E36F8525}']
    //���Է���
    function  GetReciever: IImgReciever;stdcall;
    procedure SetReciever(value: IImgReciever);stdcall;
    function  GetOption : ICameraOption;stdcall;
    //������ͷ
    function  Open(): Boolean;stdcall;
    //�ر�����ͷ
    procedure Close();stdcall;
    //����һͼƬ
    function  CaptureBitmap(TFStream: ITFStream): Boolean;stdcall;
    //��̬ͼ����սӿ�
    property  ImgReciever: IImgReciever read GetReciever write SetReciever;
    //
    property  Option : ICameraOption read GetOption;
  end;

  
implementation

{ TTFStreamAdapter }
constructor TTFStreamAdapter.Create(Stream: TStream);
begin
  m_Stream := Stream;
end;

function TTFStreamAdapter.GetPosition: Int64;
begin
  Result := m_Stream.Position;
end;

function TTFStreamAdapter.GetSize: int64;
begin
  Result := m_Stream.Size;
end;

function TTFStreamAdapter.Read(var Buffer; Count: Integer): Longint;
begin
  Result := m_Stream.Read(Buffer,Count);
end;

procedure TTFStreamAdapter.ReadBuffer(var Buffer; Count: Integer);
begin
  m_Stream.ReadBuffer(Buffer,Count);
end;

function TTFStreamAdapter.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result := m_Stream.Seek(Offset,Origin);
end;

procedure TTFStreamAdapter.SetPosition(const value: Int64);
begin
  m_Stream.Position := value;
end;

procedure TTFStreamAdapter.SetSize64(const value: Int64);
begin
  m_Stream.Size := value;
end;

function TTFStreamAdapter.Write(const Buffer; Count: Integer): Longint;
begin
  Result := m_Stream.Write(Buffer,Count);
end;

procedure TTFStreamAdapter.WriteBuffer(const Buffer; Count: Integer);
begin
  m_Stream.WriteBuffer(Buffer,Count);
end;

{ TImgReciever }

class procedure TImgReciever.CopyFromHandle(hBIT: HBITMAP;BMP: TBitmap);
var
  lbitMap: TBitmap;
begin
  lbitMap := TBitmap.Create;
  try
    lbitMap.Handle := hBIT;

    BMP.Assign(lbitMap);
    
    lbitMap.ReleaseHandle();
  finally
    lbitMap.Free;
  end;
end;

procedure TImgReciever.RecieveBMP(BITMAP: HBITMAP);
begin
  if Assigned(m_OnRecieveBMP) then
    m_OnRecieveBMP(Self,BITMAP);
end;

  
end.
