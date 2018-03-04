unit ufrmgather;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ufrmCamer, StdCtrls, ADODB, jpeg, DB,
  Buttons, PngBitBtn;

type
  TfrmPictureGather = class(TForm)
    frmCamer: TfrmCamera;
    btnCapture: TPngBitBtn;
    btnCancel: TPngBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCaptureClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    private
    { Private declarations }
  public
    m_PictureStream : TMemoryStream;
  { Public declarations }
  published

  end;



  function PictureGather(var PictureStream : TMemoryStream):Boolean;

implementation

{$R *.dfm}

function PictureGather(var PictureStream : TMemoryStream):Boolean;
//功能: 照片采集
var
  frmPictureGather: TfrmPictureGather;
begin
  frmPictureGather := TfrmPictureGather.Create(nil);
  try
    frmPictureGather.m_PictureStream := PictureStream;
    Result := frmPictureGather.ShowModal = Mrok;
  finally
    frmPictureGather.Free;
  end;
end;

procedure TfrmPictureGather.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPictureGather.btnCaptureClick(Sender: TObject);
var
  JpegGraphic: TJpegImage;
  strFileName: string;
begin
  JpegGraphic := TJpegImage.Create;
  FreeAndNil(m_PictureStream);
  m_PictureStream := TMemoryStream.Create;

  strFileName := ExtractFilepath(application.ExeName) + 'temp.jpg';
  frmCamer.CapturePicture(strFileName,pfJpeg);
  JpegGraphic.LoadFromFile(strFileName);
  DeleteFile(strFileName);

  JpegGraphic.SaveToStream(m_PictureStream);

  FreeAndNil(JpegGraphic);
  ModalResult := mrok;

end;

procedure TfrmPictureGather.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmCamer.CloseCamera();
end;

procedure TfrmPictureGather.FormShow(Sender: TObject);
begin
  frmCamer.IniCamera;
  frmCamer.OpenCamera();
  btnCapture.Enabled := True;
end;

end.

