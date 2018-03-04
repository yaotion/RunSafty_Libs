unit ufrmTrainmanPicFigEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Buttons, PngSpeedButton, StdCtrls, DB, ADODB,
  ufrmFingerRegister, OleCtrls, ZKFPEngXControl_TLB,
  pngimage, DSUtil, DirectShow9, ufrmgather, JPEG, uTFSystem, ZKFPEngXUtils, ufrmTextInput,
  Mask, RzEdit,uLCTrainmanMgr,uTrainman,uLLCommonFun,uFingerCtls,
  RsGlobal_TLB,uHttpWebAPI;

type
  TFormTrainmanPicFigEdit = class(TForm)
    RzGroupBox2: TRzGroupBox;
    btnCapturePicture: TPngSpeedButton;
    btnLoadPicture: TPngSpeedButton;
    Bevel1: TBevel;
    btnSave: TButton;
    btnClose: TButton;
    OD: TOpenDialog;
    labwebcamError: TLabel;
    imgwebcamerr: TImage;
    btnFingerRegister: TPngSpeedButton;
    Bevel2: TBevel;
    image1: TImage;
    labError: TLabel;
    Label1: TLabel;
    edtNumber: TRzEdit;
    Label2: TLabel;
    edtName: TRzEdit;
    imgPicture: TImage;
    imgTrainmanPicture1: TPaintBox;
    btnClearFinger: TPngSpeedButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCapturePictureClick(Sender: TObject);
    procedure btnFingerRegisterClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoadPictureClick(Sender: TObject);
    procedure btnClearFingerClick(Sender: TObject);
  private
    {��ǰ������ԱID}
    m_TrainmanNumber: string;

    //ָ������1
    m_strFinger1Register: string;
    //ָ������2
    m_strFinger2Register: string;
    //��Ƭ
    m_PictureStream: TMemoryStream;
    m_bChange: Boolean;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_Trainman: RRsTrainman;
  public
    function ReadData(TrainmanNumber: string) : boolean;
  private
    procedure Modify;
    procedure FormDataToADOQuery;
    procedure InitZKFPEng;
    procedure WMDevicechange(var Msg: TMessage); message WM_DEVICECHANGE;
    procedure Init;
  public
    FingerPrintCtl : TFingerPrintCtl;
    webAPIUtils : TWebAPIUtils;
    Global : IGlobalProxy;
  end;
function ModifyTrainmanPicFig(AppGlobal : IGlobalProxy ;
  FingerPrintCtl : TFingerPrintCtl;TrainmanNumber: string): Boolean;
implementation

function WebcamExists():Boolean;
  //����:�������ͷ�Ƿ�װ
  var
    CapEnum : TSysDevEnum;
  begin
    Result := False;
    CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    try
      if CapEnum.CountFilters > 0 then
        Result := True;
    finally
    end;
    CapEnum.Free;
  end;

{$R *.dfm}

function ModifyTrainmanPicFig(AppGlobal : IGlobalProxy ;
  FingerPrintCtl : TFingerPrintCtl;TrainmanNumber: string): Boolean;
//����:�޸ĳ���Ա��Ϣ
var
  frmUserInfoEdit: TFormTrainmanPicFigEdit;
begin
  frmUserInfoEdit := TFormTrainmanPicFigEdit.Create(nil);
  Result := False;
  try
    frmUserInfoEdit.Global := AppGlobal;

    frmUserInfoEdit.FingerPrintCtl := FingerPrintCtl;
    frmUserInfoEdit.Init;
    frmUserInfoEdit.Caption := '�޸ĳ���Ա��Ϣ';
    if not frmUserInfoEdit.ReadData(TrainmanNumber) then
    begin
      box('����Ĺ���:' + TrainmanNumber);
      exit;
    end;
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;

end;

function TFormTrainmanPicFigEdit.ReadData(TrainmanNumber: string) : boolean;
//����:��ȡ����Ա��Ϣ
var
  PictureStream: TMemoryStream;
  JpegImage: TJPEGImage;
begin
  result := false;
  m_TrainmanNumber := TrainmanNumber;
  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(m_TrainmanNumber,m_Trainman,2) then
    exit;

  edtNumber.Text := m_Trainman.strTrainmanNumber;
  edtName.Text := m_Trainman.strTrainmanName;
  if FingerPrintCtl.InitSuccess then
  begin
    if m_Trainman.nFingerPrint1_Null = 1 then
    begin
      m_strFinger1Register := FingerPrintCtl.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint1);
    end;


    if m_Trainman.nFingerPrint2_Null = 1 then
    begin
      m_strFinger2Register := FingerPrintCtl.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint2);
    end;
  end;

  if m_Trainman.nPicture_Null = 1 then
  begin
    PictureStream := TMemoryStream.Create;
    JpegImage := TJpegImage.Create;
    TCF_VariantParse.OleVariantToStream(m_Trainman.Picture,PictureStream);
    PictureStream.Position := 0;
    JpegImage.LoadFromStream(PictureStream);
    imgPicture.Picture.Graphic := JpegImage;
    JpegImage.Free;
    PictureStream.Free;
    if imgPicture.Picture.Width = 0 then
      imgPicture.Picture.Graphic := nil;
  end;
  result := true;
end;

procedure TFormTrainmanPicFigEdit.WMDevicechange(var Msg: TMessage);
begin
  if (Msg.LParam = 0) and (Msg.WParam = 7) then
  begin
    if btnCapturePicture.Enabled = False then
    begin
      if WebcamExists() then
      begin
        btnCapturePicture.Enabled := True;
        imgwebcamerr.Visible := False;
        labwebcamError.Visible := False;
      end;
    end;
  end;
end;

procedure TFormTrainmanPicFigEdit.btnCapturePictureClick(Sender: TObject);
var
  JpegGraphic: TJpegImage;
begin
  if PictureGather(m_PictureStream) then
  begin
    m_bChange := True;
    m_PictureStream.Position := 0;
    JpegGraphic := TJpegImage.Create;
    JpegGraphic.LoadFromStream(m_PictureStream);
    imgPicture.Picture.Graphic := JpegGraphic;
    JpegGraphic.Free;
  end;
end;

procedure TFormTrainmanPicFigEdit.btnClearFingerClick(Sender: TObject);
begin
  if not TBox('��ȷ��Ҫ����ó���Ա��ָ����Ϣ��?') then
    Exit;


  try
    m_RsLCTrainmanMgr.ClearFinger(m_Trainman.strTrainmanGUID);
    Box('�ɹ����ָ����Ϣ!');
    m_bChange := true;
    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      BoxErr('���ָ����Ϣʧ�ܣ�����:(' + E.Message + ')');
    end;
  end;
end;
                                                                    
procedure TFormTrainmanPicFigEdit.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTrainmanPicFigEdit.btnFingerRegisterClick(Sender: TObject);
begin
  if FingerRegister(Global,FingerPrintCtl,m_strFinger1Register, m_strFinger2Register) then
    m_bChange := True;
end;

procedure TFormTrainmanPicFigEdit.btnLoadPictureClick(Sender: TObject);
begin
  if OD.Execute = False then Exit;
  ImgPicture.Picture.LoadFromFile(OD.FileName);
  m_PictureStream.LoadFromFile(OD.FileName);
  m_bChange := true;
end;

procedure TFormTrainmanPicFigEdit.btnSaveClick(Sender: TObject);
begin
  if m_bChange then
  begin
     Modify();
  end else begin
    ModalResult := mrCancel;
  end;
end;

procedure TFormTrainmanPicFigEdit.Modify;
//����:�޸ĳ���Ա��Ƭ��ָ����Ϣ
begin
  if TBox('ȷ��Ҫ�޸ĸó���Ա��Ϣ��?') = False then Exit;

  try
     FormDataToADOQuery();
     m_RsLCTrainmanMgr.UpdateFingerAndPic(m_Trainman);
      //���±���ָ��������
      if FingerPrintCtl.InitSuccess then
      begin
        FingerPrintCtl.LocalFingerCtl.UpdateTrianmanFingers(m_Trainman);
        FingerPrintCtl.UpdateBufferTemplate(m_Trainman.nID,
        FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger1Register),
        FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger2Register));
      end;

  except
    on E: Exception do
    begin
      BoxErr('��Ϣ����ʧ�ܣ�����:(' + E.Message + ')');
      Exit;
    end;
  end;

  ModalResult := mrok;
end;

procedure TFormTrainmanPicFigEdit.FormDataToADOQuery;
//����:�������е����ݱ��������ݼ���
begin
  if FingerPrintCtl.InitSuccess then
  begin
    if m_strFinger1Register <> '' then
    begin
      m_Trainman.FingerPrint1 := FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger1Register);
    end;
    if m_strFinger2Register <> '' then
    begin
      m_Trainman.FingerPrint2 := FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger2Register);
    end;
  end;
  if m_PictureStream.Size > 0 then
  begin
    m_PictureStream.Position := 0;
    TCF_VariantParse.StreamToOleVariant(m_PictureStream,m_Trainman.Picture);
  end;
end;

procedure TFormTrainmanPicFigEdit.FormDestroy(Sender: TObject);
begin
  m_PictureStream.Free;
  FingerPrintCtl.EventHolder.Restore;
  m_RsLCTrainmanMgr.Free;
  webAPIUtils.Free;
end;

procedure TFormTrainmanPicFigEdit.Init;
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=Global.WebAPI.Host;
  webAPIUtils.Port := Global.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  m_strFinger1Register := '';
  m_strFinger2Register := '';
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(WebAPIUtils);
  FingerPrintCtl.EventHolder.Hold();
  FingerPrintCtl.OnTouch := nil;
  FingerPrintCtl.OnLoginSuccess := nil;
  m_PictureStream := TMemoryStream.Create;
  InitZKFPEng();
  if WebcamExists() = False then
  begin
    btnCapturePicture.Enabled := False;
    imgwebcamerr.Visible := True;
    labwebcamError.Visible := True;
  end;
end;

procedure TFormTrainmanPicFigEdit.InitZKFPEng;
{����:��ʼ��ָ����}
begin
  if FingerPrintCtl.InitSuccess = False then
  begin
    image1.Visible := True;
    labError.Visible := True;
    labError.Caption := 'ָ�����޷�ʹ��,' + FingerPrintCtl.InitError;
    btnFingerRegister.Enabled := false;
    Exit;
  end
  else
  begin
    image1.Visible := False;
    labError.Visible := False;
    btnFingerRegister.Enabled := true;
  end;
end;


end.

