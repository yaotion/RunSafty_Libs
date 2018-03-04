unit uFrmTrainmanDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,uTrainman,ZKFPEngXUtils,
  JPEG, Mask, RzEdit,uLCTrainmanMgr;

type
  TfrmTrainmanDetail = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    RzPanel1: TRzPanel;
    imgPicture: TImage;
    Label9: TLabel;
    Label20: TLabel;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    edtNumber: TRzEdit;
    edtName: TRzEdit;
    edtMobileNumber: TRzEdit;
    edtTelNumber: TRzEdit;
    edtAddress: TRzEdit;
    edtRemark: TRzEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    m_strTrainmanGUID : string;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    procedure Init;
  public
    { Public declarations }
    class function ViewTrainmanDetail(TrainmanGUID : string) : boolean;
  end;



implementation
uses
  uGlobal;
var
  frmTrainmanDetail: TfrmTrainmanDetail;
{$R *.dfm}

procedure TfrmTrainmanDetail.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainmanDetail.btnSaveClick(Sender: TObject);
begin
  m_RsLCTrainmanMgr.UpdateTrainmanTel(m_strTrainmanGUID,
    Trim(edtTelNumber.Text),trim(edtMobileNumber.Text),
    Trim(edtAddress.Text),trim(edtRemark.Text));
  ModalResult := mrOk;
end;

procedure TfrmTrainmanDetail.FormCreate(Sender: TObject);
begin
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(g_WebAPIUtils);
end;

procedure TfrmTrainmanDetail.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TfrmTrainmanDetail.Init;
var
  trainman : RRsTrainman;
   PictureStream : TMemoryStream;
  JpegImage : TJPEGImage;
begin

  m_RsLCTrainmanMgr.GetTrainman(m_strTrainmanGUID,trainman,2);
  edtNumber.Text := trainman.strTrainmanNumber;
  edtName.Text := trainman.strTrainmanName;
  edtNumber.Text := trainman.strTrainmanNumber;
  edtTelNumber.Text := trainman.strTelNumber;
  edtMobileNumber.Text := trainman.strMobileNumber;
  edtAddress.Text := trainman.strAdddress;
  edtRemark.Text := trainman.strRemark;
  //’’∆¨
  if not (VarIsNull(trainman.Picture) or VarIsEmpty(trainman.Picture)) then
  begin
    PictureStream := TMemoryStream.Create;
    TemplateOleVariantToStream(trainman.Picture,PictureStream);
    JpegImage := TJpegImage.Create;
    PictureStream.Position := 0;
    JpegImage.LoadFromStream(PictureStream);
    imgPicture.Picture.Graphic := JpegImage;
    JpegImage.Free;
    PictureStream.Free;
    if imgPicture.Picture.Width = 0 then
      imgPicture.Picture.Graphic := nil;
  end;
end;

class function TfrmTrainmanDetail.ViewTrainmanDetail(TrainmanGUID : string) : boolean;
begin
  result := false;
  frmTrainmanDetail:= TfrmTrainmanDetail.Create(nil);
  try
    frmTrainmanDetail.m_strTrainmanGUID := TrainmanGUID;
    frmTrainmanDetail.Init;
    if frmTrainmanDetail.ShowModal = mrOk then
      result := true;
  finally
    frmTrainmanDetail.Free;
  end;
end;

end.
