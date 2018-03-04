
unit ufrmUserInfoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uGlobalDM, DB, ADODB, Buttons, ExtCtrls, RzPanel, StdCtrls,
  ufrmFingerRegister, OleCtrls, ZKFPEngXControl_TLB, PngSpeedButton,
  pngimage,DSUtil,DirectShow9,ufrmgather,JPEG,uTFSystem,ZKFPEngXUtils,
  PngCustomButton, ComCtrls, RzCmboBx,uJWD,StrUtils,
  uWorkShop,uTrainJiaolu,uGuideGroup,uTrainman,
  uSaftyEnum, Mask, RzEdit, RzDTP,uLCBaseDict,uLCTrainmanMgr;

type
  TfrmUserInfoEdit = class(TForm)
    ADOQuery: TADOQuery;
    OD: TOpenDialog;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    PngCustomButton1: TPngCustomButton;
    Label5: TLabel;
    RzGroupBox1: TRzGroupBox;
    RzPanel1: TRzPanel;
    imgPicture: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    comboGuideGroup: TRzComboBox;
    Label7: TLabel;
    comboTrainJiaolu: TRzComboBox;
    Label17: TLabel;
    comboWorkShop: TRzComboBox;
    Label6: TLabel;
    btnCapturePicture: TPngSpeedButton;
    btnLoadPicture: TPngSpeedButton;
    btnFingerRegister: TPngSpeedButton;
    labwebcamError: TLabel;
    imgwebcamError: TImage;
    Image1: TImage;
    labError: TLabel;
    RzGroupBox2: TRzGroupBox;
    Label10: TLabel;
    comboDriverType: TRzComboBox;
    Label12: TLabel;
    comboDriveLevel: TRzComboBox;
    Label11: TLabel;
    comboIsKey: TRzComboBox;
    Label13: TLabel;
    comboABCD: TRzComboBox;
    Label19: TLabel;
    Label8: TLabel;
    Label18: TLabel;
    Label4: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    comboKehuo: TRzComboBox;
    Label9: TLabel;
    Label20: TLabel;
    comboPost: TRzComboBox;
    edtNumber: TRzEdit;
    edtName: TRzEdit;
    edtTelNumber: TRzEdit;
    edtMobileNumber: TRzEdit;
    edtRestLength: TRzEdit;
    edtLastEndWorkTime: TRzEdit;
    edtAddress: TRzEdit;
    edtRemark: TRzEdit;
    dtpRuduanDate: TRzDateTimePicker;
    dtpRenzhiDate: TRzDateTimePicker;
    Label21: TLabel;
    comboArea: TRzComboBox;
    procedure btnFingerRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadPictureClick(Sender: TObject);
    procedure btnCapturePictureClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure ComboxKeyPress(Sender: TObject; var Key: Char);
    procedure edtNumberChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comboWorkShopChange(Sender: TObject);
    procedure comboAreaChange(Sender: TObject);
  private
    { Private declarations }
        // ����α��
    {��ǰ������ԱID}
    m_strGUID : String;
    //��Ϣ�༭״̬
    m_EditType : TDBOperationType;
    //ָ������1
    m_strFinger1Register : String;
    //ָ������2
    m_strFinger2Register : String;
    //��Ƭ
    m_PictureStream : TMemoryStream;
    //���������Ƿ����仯
    m_bChange : Boolean;
    //��ǰ������˾����Ϣ
    m_Trainman : RRsTrainman;
    //˾���ӿ�
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
  private
    {����:��ʼ��ָ����}
    procedure InitZKFPEng;
    procedure WMDevicechange(var Msg:TMessage); message WM_DEVICECHANGE;
    {����:����û�����}
    function CheckInput():Boolean;
    {����:��ȡ����}
    procedure ReadData(strGUID : String);
    //�ռ�����
    procedure GatherData(var trainman : RRsTrainman);

    //��ʼ����֯�ṹ�ؼ�
    procedure InitOrgCtrls;
    {����:��ʼ�������}
    procedure InitJWD();
    {����:��ʼ������}
    procedure InitWorkShop();
  public
    { Public declarations }
  end;
  {����:��ӳ���Ա��Ϣ}
  function AppendTrainmanInfo():Boolean;
  {����:�޸ĳ���Ա��Ϣ}
  function ModifyTrainmanInfo(strGUID : String):Boolean;

implementation
uses
  DateUtils;
{$R *.dfm}

function AppendTrainmanInfo():Boolean;
//����:��ӳ���Ա��Ϣ
var
  frmUserInfoEdit: TfrmUserInfoEdit;
begin
  Result := False;
  frmUserInfoEdit:= TfrmUserInfoEdit.Create(nil);
  try
    frmUserInfoEdit.Caption := '���˾����Ϣ';
    frmUserInfoEdit.InitOrgCtrls;
    frmUserInfoEdit.m_EditType := otInsert;
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;
end;

function ModifyTrainmanInfo(strGUID : String):Boolean;
//����:�޸ĳ���Ա��Ϣ
var
  frmUserInfoEdit: TfrmUserInfoEdit;
begin
  frmUserInfoEdit:= TfrmUserInfoEdit.Create(nil);
  Result := False;
  try
    frmUserInfoEdit.Caption := '�޸�˾����Ϣ';
    frmUserInfoEdit.m_EditType := otModify;    
    frmUserInfoEdit.InitOrgCtrls;
    frmUserInfoEdit.ReadData(strGUID);
    if frmUserInfoEdit.ShowModal = mrok then
      Result := True;
  finally
    frmUserInfoEdit.Free;
  end;

end;

{ TfrmUserInfoEdit }


procedure TfrmUserInfoEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmUserInfoEdit.btnCapturePictureClick(Sender: TObject);
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

procedure TfrmUserInfoEdit.btnFingerRegisterClick(Sender: TObject);
begin
  if FingerRegister(m_strFinger1Register,m_strFinger2Register) then
    m_bChange := True;
end;

procedure TfrmUserInfoEdit.btnSaveClick(Sender: TObject);
var
  trainman : RRsTrainman;
begin
  if CheckInput() = False then Exit;

  trainman := m_Trainman;
  //�ռ�����
  GatherData(trainman);
  try
    if m_EditType = otInsert then
    begin
      trainman.strTrainmanGUID := NewGUID;
      m_RsLCTrainmanMgr.AddTrainman(trainman);
    end
    else
      m_RsLCTrainmanMgr.UpdateTrainman(trainman);
  except on e : exception do
    begin
      Box('��������ʧ�ܣ�' + e.Message);
      exit;
    end;
  end;

  try
    GlobalDM.FingerPrintCtl.ServerFingerCtl.FinerID := NewGUID;
    if GlobalDM.FingerPrintCtl.InitSuccess then
    begin
      //����ָ�ƿ�������
      if m_RsLCTrainmanMgr.GetTrainmanByNumber(edtNumber.Text,trainman,1) then
      begin
        GlobalDM.FingerPrintCtl.UpdateBufferTemplate(trainman.nID,trainman.FingerPrint1,trainman.FingerPrint2);

        if m_EditType = otInsert then
          GlobalDM.FingerPrintCtl.LocalFingerCtl.AddTrainman(trainman)
        else
          GlobalDM.FingerPrintCtl.LocalFingerCtl.UpdateTrianmanFingers(trainman);
      end;

    end;
  except on e : exception do
    begin
      Box('����ָ������ʧ��:' + e.Message);
      exit;
    end;
  end;
  ModalResult := mrOK;
end;

function TfrmUserInfoEdit.CheckInput: Boolean;
//����:����û������Ƿ�Ϸ�
begin
  Result := False;
  if Trim(edtNumber.Text) = '' then
  begin
    Box('�����빤��!');
    edtNumber.SetFocus;
    Exit;
  end;

  if Trim(edtName.Text) = '' then
  begin
    Box('����������!');
    edtName.SetFocus;
    Exit;
  end;

  if m_RsLCTrainmanMgr.ExistNumber(m_Trainman.strTrainmanGUID,Trim(edtNumber.Text)) then
  begin
    Box('�ù����Ѿ����ڣ����������룡');
    edtNumber.SetFocus;
    edtNumber.SelectAll;
    Exit;
  end;

  Result := True;
  
end;

procedure TfrmUserInfoEdit.comboAreaChange(Sender: TObject);
begin
  InitWorkShop();
end;

procedure TfrmUserInfoEdit.comboWorkShopChange(Sender: TObject);
var
  trainJiaoluArray : TRsTrainJiaoluArray;
  guideGroupArray : TRsGuideGroupArray;
  i: Integer;
  workShopGUID : string;
begin
  comboTrainJiaolu.Items.Clear;
  comboTrainJiaolu.Values.Clear;
  comboTrainJiaolu.AddItemValue('��ѡ������','');
  comboTrainJiaolu.ItemIndex := 0;
                    
  comboGuideGroup.Items.Clear;
  comboGuideGroup.Values.Clear;
  comboGuideGroup.AddItemValue('��ѡ��ָ����','');
  comboGuideGroup.ItemIndex := 0;
  if comboWorkShop.ItemIndex > -1 then
    workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //���������Ϣ
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(workShopGUID,trainJiaoluArray);
    for i := 0 to length(trainJiaoluArray) - 1 do
    begin
      comboTrainJiaolu.AddItemValue(trainJiaoluArray[i].strTrainJiaoluName,
          trainJiaoluArray[i].strTrainJiaoluGUID);
    end;

    //���ָ������Ϣ
    RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop(comboWorkShop.Value,guideGroupArray);
    for i := 0 to length(guideGroupArray) - 1 do
    begin
      comboGuideGroup.AddItemValue(guideGroupArray[i].strGuideGroupName,
          guideGroupArray[i].strGuideGroupGUID);
    end;    
  end;
end;

procedure TfrmUserInfoEdit.ComboxKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    btnSave.SetFocus;
    key := #0;
  end;
end;

procedure TfrmUserInfoEdit.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    comboPost.SetFocus;
    key := #0;
  end;
end;

procedure TfrmUserInfoEdit.edtNumberChange(Sender: TObject);
var
  strJwd : string ;
  TrainmanNumber : string ;
  i : Integer ;
begin
  TrainmanNumber := edtNumber.Text ;
  strJwd :=  LeftStr(TrainmanNumber,2) ;
  for I := 0 to comboArea.Items.Count - 1 do
  begin
    if comboArea.Values[i] =  strJwd  then
    begin
      comboArea.ItemIndex := i ;
      comboAreaChange(nil);
      Break ;
    end;
  end;
  m_bChange := True;
end;

procedure TfrmUserInfoEdit.edtNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    edtName.SetFocus;
    key := #0;
  end;
end;

procedure TfrmUserInfoEdit.FormCreate(Sender: TObject);
begin
  m_strFinger1Register := '';
  m_strFinger2Register := '';
  m_PictureStream := TMemoryStream.Create;

  m_Trainman.nTrainmanState := tsNil;
  InitZKFPEng();
  if WebcamExists() = False then
  begin
    btnCapturePicture.Enabled := False;
    imgwebcamError.Visible := True;
    labwebcamError.Visible := True;
  end;
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  //�����
end;
procedure TfrmUserInfoEdit.InitJWD();
var
  i:Integer;
  JWDArray:TRsJWDArray;
  strError  : string;
begin
  if not RsLCBaseDict.LCJwd.GetAllJwdList(JWDArray,strError) then
  begin
    box(strError);
    exit;
  end;
  comboArea.Items.Clear;
  comboArea.Values.Clear;
  for i := 0 to length(JWDArray) - 1 do
  begin
    comboArea.AddItemValue(JWDArray[i].strName,JWDArray[i].strUserCode);
  end;
  comboArea.ItemIndex := comboArea.Values.IndexOf(LeftStr(GlobalDM.SiteInfo.strSiteIP,2));

end;
{����:��ʼ������}
procedure TfrmUserInfoEdit.InitWorkShop();
var
  i : integer;
  workshopArray : TRsWorkShopArray;
  strAreaGUID:string;
  Error: string;
begin
  if leftStr(GlobalDM.SiteInfo.strSiteIP,2) = comboArea.Values[comboArea.ItemIndex] then
    strAreaGUID := GlobalDM.SiteInfo.strAreaGUID
  else
    strAreaGUID := comboArea.Values[comboArea.ItemIndex];

  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,workshopArray,Error) then
  begin
    Box(Error);
  end;
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('��ѡ�񳵼�','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  comboWorkShop.ItemIndex := 0;
  comboWorkShopChange(nil);
end;
procedure TfrmUserInfoEdit.InitOrgCtrls;
begin
  InitJWD();
end;

procedure TfrmUserInfoEdit.InitZKFPEng;
{����:��ʼ��ָ����}
begin
  if GlobalDM.FingerPrintCtl.InitSuccess = False then
  begin
    btnFingerRegister.Enabled := False;
    image1.Visible := True;
    labError.Visible := True;
    labError.Caption := 'ָ�����޷�ʹ��,'+GlobalDM.FingerPrintCtl.InitError;
    Exit;
  end;
end;

procedure TfrmUserInfoEdit.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
  m_PictureStream.Free;
end;

procedure TfrmUserInfoEdit.FormShow(Sender: TObject);
begin
  m_bChange := False;
end;

procedure TfrmUserInfoEdit.GatherData(var trainman : RRsTrainman);
var
  pictureStream : TMemoryStream;
begin
  trainman.strTrainmanNumber := Trim(edtNumber.Text);
  trainman.strTrainmanName := edtName.Text;
  trainman.nPostID := TRsPost(StrToInt(comboPost.Values[comboPost.ItemIndex]));
  trainman.strWorkShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  trainman.strTrainJiaoluGUID := comboTrainJiaolu.Values[comboTrainJiaolu.ItemIndex];
  trainman.strGuideGroupGUID := comboGuideGroup.Values[comboGuideGroup.ItemIndex];
  trainman.nDriverType := TRsDriverType(StrToInt(comboDriverType.Values[comboDriverType.ItemIndex]));
  trainman.nDriverLevel := StrToInt(comboDriveLevel.Values[comboDriveLevel.ItemIndex]);
  trainman.bIsKey := StrToInt(comboIsKey.Values[comboIsKey.ItemIndex]);
  trainman.strAreaGUID := comboArea.Values[comboArea.ItemIndex];

  if comboABCD.ItemIndex > -1 then  
    trainman.strABCD :=  comboABCD.Values[comboABCD.ItemIndex];

  if comboKehuo.ItemIndex > -1 then
    trainman.nKeHuoID := TRsKehuo(StrToInt(comboKehuo.Values[comboKehuo.ItemIndex]));

  trainman.strTelNumber  := edtTelNumber.Text;
  trainman.strMobileNumber :=  edtMobileNumber.Text;
  trainman.dtRuZhiTime:= DateOf(dtpRuduanDate.DateTime);
  trainman.dtJiuZhiTime := DateOf(dtpRenzhiDate.DateTime);

  trainman.strAdddress := Trim(edtAddress.Text);
  trainman.strRemark := Trim(edtRemark.Text);
  trainman.strJP := GlobalDM.GetHzPy(Trim(edtName.Text));
  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    //ָ��
    trainman.FingerPrint1 := GlobalDM.FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger1Register);
    trainman.FingerPrint2 := GlobalDM.FingerPrintCtl.ZKFPEngX.DecodeTemplate1(m_strFinger2Register);
  end;

  if not (imgPicture.Picture.Graphic = nil) then
  begin
    //��Ƭ
    PictureStream := TMemoryStream.Create;
    try
      TJpegImage(imgPicture.Picture.Graphic).SaveToStream(PictureStream);
      trainman.Picture := StreamToTemplateOleVariant(PictureStream);
    finally
      PictureStream.Free;
    end;
  end;
  
end;

procedure TfrmUserInfoEdit.ReadData(strGUID: String);
//����:��ȡ����Ա��Ϣ
var
  PictureStream : TMemoryStream;
  JpegImage : TJPEGImage;
begin  
  m_strGUID := strGUID;
  if not m_RsLCTrainmanMgr.GetTrainman(m_strGUID,m_Trainman,3) then
  begin
    Box('û���ҵ�ָ����˾����Ϣ');
    exit;
  end;

  edtNumber.Text := m_Trainman.strTrainmanNumber;
  edtName.Text := m_Trainman.strTrainmanName;
  ComboPost.ItemIndex := comboPost.Values.IndexOf(IntToStr(Ord(m_Trainman.nPostID)));


  comboArea.ItemIndex := comboArea.Values.IndexOf(m_Trainman.strAreaGUID);
  comboArea.OnChange(Self);
  
  comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(m_Trainman.strWorkShopGUID);
  comboWorkShop.OnChange(Self);

  
  comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(m_Trainman.strTrainJiaoluGUID);

  if comboTrainJiaolu.ItemIndex = -1 then
    comboTrainJiaolu.ItemIndex := 0;
    
  comboGuideGroup.ItemIndex := comboGuideGroup.Values.IndexOf(m_Trainman.strGuideGroupGUID);
  
  comboDriverType.ItemIndex := comboDriverType.Values.IndexOf(IntToStr(Ord(m_Trainman.nPostID)));
  comboDriveLevel.ItemIndex := comboDriveLevel.Values.IndexOf(IntToStr(Ord(m_Trainman.nDriverLevel)));
  comboIsKey.ItemIndex := comboIsKey.Values.IndexOf(IntToStr(Ord(m_Trainman.bIsKey)));
  comboABCD.ItemIndex := comboABCD.Values.IndexOf(m_Trainman.strABCD);

  comboKehuo.ItemIndex := comboKehuo.Values.IndexOf(IntToStr(Ord(m_Trainman.nKeHuoID)));
  edtTelNumber.Text := m_Trainman.strTelNumber;
  edtMobileNumber.Text := m_Trainman.strMobileNumber;
  dtpRuduanDate.DateTime := m_Trainman.dtRuZhiTime;
  dtpRenzhiDate.DateTime := m_Trainman.dtJiuZhiTime;
  edtRestLength.Text := '0Сʱ';
  edtLastEndWorkTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_Trainman.dtLastEndworkTime);
  edtAddress.Text := m_Trainman.strAdddress;
  edtRemark.Text := m_Trainman.strRemark;

  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    //ָ��
    if not (VarIsNull(m_Trainman.FingerPrint1) or VarIsEmpty(m_Trainman.FingerPrint1)) then
      m_strFinger1Register := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint1);
    if not (VarIsNull(m_Trainman.FingerPrint2) or VarIsEmpty(m_Trainman.FingerPrint2)) then
      m_strFinger2Register := GlobalDM.FingerPrintCtl.ZKFPEngX.EncodeTemplate1(m_Trainman.FingerPrint2);
  end;
  //��Ƭ
  if not (VarIsNull(m_Trainman.Picture) or VarIsEmpty(m_Trainman.Picture)) then
  begin
    PictureStream := TMemoryStream.Create;
    TemplateOleVariantToStream(m_Trainman.Picture,PictureStream);
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

procedure TfrmUserInfoEdit.btnLoadPictureClick(Sender: TObject);
begin
  if OD.Execute = False then Exit;
  m_bChange := True;
  ImgPicture.Picture.LoadFromFile(OD.FileName);
  m_PictureStream.LoadFromFile(OD.FileName);
end;

procedure TfrmUserInfoEdit.WMDevicechange(var Msg: TMessage);
begin
  if btnCapturePicture.Enabled = False then
  begin
    if WebcamExists() then
    begin
      btnCapturePicture.Enabled := True;
      imgwebcamError.Visible := False;
      labwebcamError.Visible := False;
    end;
  end;

end;

end.
