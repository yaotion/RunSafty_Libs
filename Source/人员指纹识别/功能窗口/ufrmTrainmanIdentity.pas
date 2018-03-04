unit ufrmTrainmanIdentity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngBitBtn, RzAnimtr, PngSpeedButton, ExtCtrls,
  pngimage, RzPanel,uTFSystem,ufrmTextInput,
  Mask, RzEdit,uTFVariantUtils,uSaftyEnum;
type
  TOnIdentityEvent = procedure(TrainmanNumber : string;VerifyID : integer) of object;
  TFrmTrainmanIdentity = class(TForm)
    RzPanel7: TRzPanel;
    Label11: TLabel;
    Image4: TImage;
    Panel1: TPanel;
    Label12: TLabel;
    lblAnalysis: TLabel;
    RzPanel2: TRzPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblTrainmanName1: TLabel;
    lblTrainmanNumber1: TLabel;
    btnCancelTrainman1: TPngSpeedButton;
    RzPanel1: TRzPanel;
    Label10: TLabel;
    btnCancel: TPngBitBtn;
    tmrAutoHideHint: TTimer;
    tmrRevocation: TTimer;
    Animator: TRzAnimator;
    edtGongHaoInput: TRzEdit;
    lbl1: TLabel;
    pngbtnOK: TPngBitBtn;
    RzPanel3: TRzPanel;
    ImgFinger: TImage;
    Label3: TLabel;
    Label4: TLabel;
    imgTrainmanPicture1: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure tmrAutoHideHintTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pngbtnOKClick(Sender: TObject);
  private
    //错误的验证次数
    m_nFingureErr : Integer;
  public
    //是否第一次现实
    m_bFirst : boolean;
    //输出
    m_nVerify : integer;
    //验证结束
    m_OnIdentity : TOnIdentityEvent;
    procedure IdentityTrainman(TrainmanNumber : string;Verify:Integer);
  public
    procedure ShowTouch(FingerImage : OleVariant);
    procedure ShowSuccess(TrainmanNumber,TrainmanName : string;TrainmanPic : OleVariant);
    procedure ShowFail();
  public
    property OnIdentity : TOnIdentityEvent read m_OnIdentity write m_OnIdentity;
  end;

  const MAX_ERROR_CNT = 20;
var
  nFailureCnt:Integer;
implementation
uses
  ActiveX,ComServ;
{$R *.dfm}
procedure TFrmTrainmanIdentity.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TFrmTrainmanIdentity.FormCreate(Sender: TObject);
begin
  Animator.Visible := False;
end;

procedure TFrmTrainmanIdentity.FormShow(Sender: TObject);
begin
  if not m_bFirst then exit;
  m_bFirst := false;
end;

procedure TFrmTrainmanIdentity.IdentityTrainman(TrainmanNumber: string;
  Verify: Integer);
begin
  if Assigned(m_OnIdentity) then
  begin
    m_OnIdentity(TrainmanNumber,Verify);
  end;
  close;
end;



procedure TFrmTrainmanIdentity.pngbtnOKClick(Sender: TObject);
begin
  if Trim(edtGongHaoInput.Text) = '' then
  begin
    MessageBox(Handle,'请输入工号!','错误',MB_ICONHAND);
    Exit;
  end;
  IdentityTrainman(edtGongHaoInput.Text,Ord(rfInput));
end;

procedure TFrmTrainmanIdentity.ShowFail;
var
  strNumber:string;
  nCnt :Integer;
begin
Show;
  m_nFingureErr := m_nFingureErr+1;
  tmrRevocation.Enabled := False;
  tmrAutoHideHint.Enabled := False;
  tmrAutoHideHint.Enabled := True;
  Animator.Visible := False;
  nCnt := MAX_ERROR_CNT - m_nFingureErr;

  if m_nFingureErr = MAX_ERROR_CNT then
  begin
    m_nFingureErr := 0;
    if TextInput('乘务员身份验证','指纹识别失败,请输入乘务员工号:',strNumber) = False then
      Exit;
    IdentityTrainman(strNumber,Ord(rfInput));
  end;
  lblAnalysis.Caption := '指纹识别失败!,还可按压'+IntToStr(nCnt)+'次';
end;

procedure TFrmTrainmanIdentity.ShowSuccess(TrainmanNumber,TrainmanName : string;
  TrainmanPic : OleVariant);
var
  ms : TMemoryStream;
begin
Show;
   m_nFingureErr := 0;
  tmrAutoHideHint.Enabled := True;
  tmrRevocation.Enabled := False;
  Animator.Visible := False;
  lblAnalysis.Caption := '识别成功!';
  lblTrainmanNumber1.Caption := TrainmanNumber;
  lblTrainmanName1.Caption := TrainmanName;
  ms :=TMemoryStream.Create;
  try
    TTFVariantUtils.TemplateOleVariantToStream(TrainmanPic,ms);
    ms.Position := 0;
    imgTrainmanPicture1.Picture.Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
  Sleep(500);
  IdentityTrainman(TrainmanNumber,Ord(rfFingerprint));
end;

procedure TFrmTrainmanIdentity.ShowTouch(FingerImage: OleVariant);
var
  ms : TMemoryStream;
begin
  Show;
  tmrAutoHideHint.Enabled := False;
  tmrRevocation.Enabled := True;
  lblAnalysis.Caption := '正在识别指纹...';
  lblAnalysis.Visible := True;
  Animator.Visible := True;
  if VarIsNull(FingerImage) then exit;
  
  ms :=TMemoryStream.Create;
  try
    TTFVariantUtils.TemplateOleVariantToStream(FingerImage,ms);
    ms.Position := 0;
    ImgFinger.Picture.Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

procedure TFrmTrainmanIdentity.tmrAutoHideHintTimer(Sender: TObject);
begin
  tmrAutoHideHint.Enabled := False;
end;

end.
