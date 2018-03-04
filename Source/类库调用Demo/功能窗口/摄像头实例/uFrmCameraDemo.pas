unit uFrmCameraDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, Menus, RzCommon, Buttons
  ,Contnrs,RsCameraLib_TLB,uRsCameraObject;

type

  TfrmCameraDemo = class(TForm)
    RzPanel1: TRzPanel;
    btnRefreshDevices: TSpeedButton;
    RzPanel2: TRzPanel;
    pParent: TPanel;
    lstCamera: TListBox;
    PopupMenu1: TPopupMenu;
    miOpenCamera: TMenuItem;
    miCloseCamera: TMenuItem;
    N3: TMenuItem;
    miCapture: TMenuItem;
    btnClose: TSpeedButton;
    pnCamera: TPanel;
    imgBMP: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure miOpenCameraClick(Sender: TObject);
    procedure miCloseCameraClick(Sender: TObject);
    procedure miCaptureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshDevicesClick(Sender: TObject);
  private
    procedure InitCameraList;
  public
    { Public declarations }
    class procedure Show;
  end;



implementation
uses
  uGlobalDM,uTFVariantUtils;
{$R *.dfm}

procedure TfrmCameraDemo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCameraDemo.btnRefreshDevicesClick(Sender: TObject);
begin
  InitCameraList;
end;

procedure TfrmCameraDemo.Button1Click(Sender: TObject);
var
  c : Icamera;
begin
  c := (GlobalDM.Camera.DefaultInterface  as  ICamera ) ;
  c.TargetHandle := RzPanel1.Handle;
  c.Open;
end;

procedure TfrmCameraDemo.FormCreate(Sender: TObject);
begin
  GlobalDM.Camera := TRsCameraObject.Create ;

  GlobalDM.Camera.Init(ExtractFilePath(Application.ExeName) + 'libs\RsCameraLib.dll',
    CLASS_Camera,IUnKnown);
end;

procedure TfrmCameraDemo.FormDestroy(Sender: TObject);
begin
  (GlobalDM.Camera.DefaultInterface  as  ICamera ).Close;
  GlobalDM.Camera.Free ;
end;

procedure TfrmCameraDemo.InitCameraList;
var
  i : integer;
  c : Icamera;
begin
  c := (GlobalDM.Camera.DefaultInterface  as  ICamera ) ;
  c.Refresh;
  lstCamera.Items.Clear;

  for i := 0 to c.CountFilters - 1 do
  begin
    //面板上添加摄像头名字
    lstCamera.Items.Add(c.Names[i]);
  end;
end;




procedure TfrmCameraDemo.miCaptureClick(Sender: TObject);
var
  s : TMemoryStream;
  bmp: TBitmap;

  data : OleVariant ;
  camera : Icamera;
begin
  camera := (GlobalDM.Camera.DefaultInterface  as  ICamera ) ;


  if lstCamera.ItemIndex < 0 then exit;
  s := TMemoryStream.Create;
  bmp := TBitmap.Create;
  try
    try

      if not camera.CaptureBitmap( data ) then
      begin
        ShowMessage('抓图失败');
        exit;
      end;
      TTFVariantUtils.TemplateOleVariantToStream(data,s);
      s.Position := 0 ;

      bmp.LoadFromStream(s);

      imgBMP.Picture.Bitmap := bmp ;
      bmp.Free;
    except on e : exception do
      Caption := e.Message;
    end;
  finally
    s.Free;
  end;
end;

procedure TfrmCameraDemo.miCloseCameraClick(Sender: TObject);
var
  c : Icamera;
begin
 if lstCamera.ItemIndex < 0 then exit;
  c := (GlobalDM.Camera.DefaultInterface  as  ICamera ) ;
  c.Close;
end;

procedure TfrmCameraDemo.miOpenCameraClick(Sender: TObject);
var
  c : Icamera;
  i : integer ;
begin


  c := (GlobalDM.Camera.DefaultInterface  as  ICamera ) ;
  try
    c.Close ;

    if lstCamera.ItemIndex < 0 then exit;
      i := lstCamera.ItemIndex ;

    //c.CameraName := c.Names[i];
    c.CameraIndex := i ;//(i + 1);
    c.TargetHandle := pnCamera.Handle;
    c.Open;
  except
    on e:Exception do
    begin
      ShowMessage(e.Message);
    end;

  end;

end;



class procedure TfrmCameraDemo.Show;
var
  frmCameraDemo: TfrmCameraDemo;
begin
  frmCameraDemo:= TfrmCameraDemo.Create(nil);
  frmCameraDemo.ShowModal;
  frmCameraDemo.Free;
end;


end.
