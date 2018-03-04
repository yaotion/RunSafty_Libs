unit uRsCameraLib;

interface
uses
  classes,sysutils,windows,graphics,uRsLibUtils,uRsLibClass,uRsLibPoolLib;

type
  //图像接收接口
  //用于接收动态图像
  IImgReciever = interface
  ['{3F6967A5-2675-4E33-BCDF-EEF2B489585C}']
    procedure RecieveBMP(BITMAP: HBITMAP);stdcall;
  end;


  //ImgReciever  DELPHI实现，如果有其它语言使用，可按自己的使用方式实现
  TRecieveBMPEvent = procedure(Sender : Pointer;BITMAP: HBITMAP) of object;


  //图接接收实现类
  //CopyFromHandle方法为从BMP句柄复制一份图像
  TImgReciever = class(TInterfacedObject,IImgReciever)
  private
    m_OnRecieveBMP: TRecieveBMPEvent;
  public
    class procedure CopyFromHandle(hBIT: HBITMAP;BMP: TBitmap);
    procedure RecieveBMP(BITMAP: HBITMAP);virtual;stdcall;
    
    property OnRecieverImg: TRecieveBMPEvent read m_OnRecieveBMP write m_OnRecieveBMP;
  end;

  //流操作接口
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


  //流接口适配器实现
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
      //////////////////////属性方法/////////////////////////////////////////////
    function  GetCameraFriendName: WideString;stdcall;
    procedure SetCameraFriendName(value: WideString);stdcall;
    function  GetCameraIndex() : Cardinal;stdcall;
    procedure SetCameraIndex(Value : Cardinal);stdcall;
    function  GetTargetHandle() : Cardinal;stdcall;
    procedure SetTargetHandle(Value : Cardinal);stdcall;

    //摄像头在设备管理器中显示的名字
    property CameraFriendName: WideString read GetCameraFriendName write SetCameraFriendName;
    //摄像头在同名设备管理器中的序号
    property CameraIndex : Cardinal read GetCameraIndex write SetCameraIndex;
    //图像显示控件句柄
    property TargetHandle : Cardinal read GetTargetHandle write SetTargetHandle;
  end;
  
  //摄像头控制接口
  ICamera = interface
  ['{7BBBB6AD-D3DB-47E5-B1C8-AEC2E36F8525}']
    //属性方法
    function  GetReciever: IImgReciever;stdcall;
    procedure SetReciever(value: IImgReciever);stdcall;
    function  GetOption : ICameraOption;stdcall;
    //打开摄像头
    function  Open(): Boolean;stdcall;
    //关闭摄像头
    procedure Close();stdcall;
    //捕获一图片
    function  CaptureBitmap(TFStream: ITFStream): Boolean;stdcall;
    //动态图像接收接口
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
