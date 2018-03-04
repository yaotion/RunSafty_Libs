unit uFrmFingerDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Buttons, StdCtrls, ComCtrls,uTFVariantUtils,
  RzEdit,Contnrs,uRsFingerObject,RsFingerLib_TLB;

type

  //单个注册信息
  TRegItem = class
  public
    RegID : Cardinal;
    RegName : string;
  end;

  TfrmFingerDemo = class(TForm,IFingerListener)
    RzPanel2: TRzPanel;
    StatusBar1: TStatusBar;
    RzGroupBox1: TRzGroupBox;
    btnOpenFinger: TSpeedButton;
    btnCloseFinger: TSpeedButton;
    Label1: TLabel;
    edtSensorNum: TEdit;
    Label2: TLabel;
    edtSensorIndex: TEdit;
    Label3: TLabel;
    edtSensorSN: TEdit;
    RzGroupBox2: TRzGroupBox;
    RzPanel1: TRzPanel;
    Image1: TImage;
    RzGroupBox3: TRzGroupBox;
    btnBeginScroll: TSpeedButton;
    btnCancelScroll: TSpeedButton;
    Label5: TLabel;
    edtRegName: TEdit;
    memoRegList: TRzMemo;
    Label7: TLabel;
    btnBeginCapture: TSpeedButton;
    btnEndCapture: TSpeedButton;
    Label8: TLabel;
    edtRegID: TEdit;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnOpenFingerClick(Sender: TObject);
    procedure btnCloseFingerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBeginScrollClick(Sender: TObject);
    procedure btnCancelScrollClick(Sender: TObject);
    procedure btnBeginCaptureClick(Sender: TObject);
    procedure btnEndCaptureClick(Sender: TObject);
  private
    { Private declarations }
    //m_Listener : TFingerListener;
    m_RegList : TObjectList;
    //指纹按压
    procedure FingerTouching(FingerImage : OleVariant);safecall;
    //指纹登记结束
    procedure FingerScroll(ActionResult: WordBool;ATemplate: OleVariant); safecall;
    //指纹捕获成功
    procedure FingerSuccess(FingerID : Cardinal);safecall;
    //指纹捕获失败
    procedure FingerFailure();safecall;
    //指纹登记通知事件
    procedure FeatureInfo(AQuality: Integer);safecall;
  public
    { Public declarations }
    class procedure Show;
  end;



implementation
uses
  uGlobalDM;
var
  frmFingerDemo: TfrmFingerDemo;
{$R *.dfm}

procedure TfrmFingerDemo.btnBeginScrollClick(Sender: TObject);
var
  regID : integer;
begin
  if not (GlobalDM.Finger.DefaultInterface as IRsFinger).Acitve then
  begin
    ShowMessage('请先初始化指纹仪');
    exit;
  end;
  if Trim(edtRegID.Text) = '' then
  begin
    ShowMessage('请输入序号');
    edtRegID.SetFocus;
    exit;
  end;
  if Trim(edtRegName.Text) = '' then
  begin
    ShowMessage('请输入姓名');
    edtRegName.SetFocus;
    exit;
  end;
  if not TryStrToInt(edtRegID.Text,regID) then
  begin
    ShowMessage('序号必须为数字');
    edtRegID.SetFocus;
    exit;
  end;
  if (GlobalDM.Finger.DefaultInterface as IRsFinger).IsRegister then
    (GlobalDM.Finger.DefaultInterface as IRsFinger).CancelScroll;

  btnBeginScroll.Enabled := false;
  edtRegName.Enabled := false;
  edtRegID.Enabled := false;
  (GlobalDM.Finger.DefaultInterface as IRsFinger).BeginScroll;


  StatusBar1.Panels[1].Text := '开始登记：请按压指纹3次';
end;

procedure TfrmFingerDemo.btnCancelScrollClick(Sender: TObject);
begin
  if not (GlobalDM.Finger.DefaultInterface as IRsFinger).Acitve then
  begin
    ShowMessage('请先初始化指纹仪');
    exit;
  end;

  btnBeginScroll.Enabled := true;
  edtRegName.Enabled := true;
  edtRegID.Enabled := true;
  (GlobalDM.Finger.DefaultInterface as IRsFinger).CancelScroll;

  
end;

procedure TfrmFingerDemo.btnCloseFingerClick(Sender: TObject);
begin
  if not (GlobalDM.Finger.DefaultInterface as IRsFinger).Acitve then
  begin
    ShowMessage('请先初始化指纹仪');
    exit;
  end;

  btnCloseFinger.Enabled := false;
  try
    (GlobalDM.Finger.DefaultInterface as IRsFinger).close;
    StatusBar1.Panels[0].Text := '指纹仪:已关闭';
  finally
    btnOpenFinger.Enabled := true;
  end;
end;

procedure TfrmFingerDemo.btnOpenFingerClick(Sender: TObject);
begin
  try
    btnOpenFinger.Enabled := false;
    (GlobalDM.Finger.DefaultInterface as IRsFinger).Open;
    ShowMessage('指纹仪初始化成功');
    btnCloseFinger.Enabled := true;
    edtSensorNum.Text := IntToStr((GlobalDM.Finger.DefaultInterface as IRsFinger).SensorCount);
    edtSensorIndex.Text := IntToStr((GlobalDM.Finger.DefaultInterface as IRsFinger).SensorIndex);
    edtSensorSN.Text := (GlobalDM.Finger.DefaultInterface as IRsFinger).SensorSN;
    StatusBar1.Panels[0].Text := '指纹仪:已打开';
  except on  e: exception do
    begin
      ShowMessage(e.Message);
      btnOpenFinger.Enabled := true;
    end;
  end;
end;

procedure TfrmFingerDemo.FeatureInfo(AQuality: Integer);
begin
 StatusBar1.Panels[1].Text := Format('登记指纹还需要按压%d次',[(GlobalDM.Finger.DefaultInterface as IRsFinger).EnrollIndex - 1]);
end;

procedure TfrmFingerDemo.FingerFailure;
begin
  ShowMessage('错误的指纹');
end;

procedure TfrmFingerDemo.FingerScroll(ActionResult: WordBool;
  ATemplate: OleVariant);
var
  reg : TRegItem;
  fData :  array of OleVariant;
  ms : TMemoryStream;
begin
  try
  try
    if ActionResult then
    begin
      ms := TMemoryStream.Create;
      try
        TTFVariantUtils.TemplateOleVariantToStream(ATemplate,ms);
        ms.SaveToFile(ExtractFilePath(Application.ExeName) + 'tmp.finger');
      finally
        ms.Free;
      end;
      reg := TRegItem.Create;
      reg.RegID := StrToInt(edtRegID.Text);
      reg.RegName := edtRegName.Text;
      setlength(fData,1);
      fData[0] := ATemplate;
      m_RegList.Add(reg);
      if not CheckBox1.Checked then
        (GlobalDM.Finger.DefaultInterface as IRsFinger).AddFinger(reg.RegID,fData)
      else
        (GlobalDM.Finger.DefaultInterface as IRsFinger).UpdateFinger(reg.RegID,fData) ;

      memoRegList.Lines.Add(Format('编号:%d---------姓名:%s',[reg.RegID,reg.RegName]));
      ShowMessage('登记成功');
    end else begin
      ShowMessage('登记失败');
    end;
  except
   on e:exception do
   begin
     ShowMessage(e.Message);
   end;

  end;
  finally
    edtRegName.Enabled := true;
    edtRegID.Enabled := true;
    btnBeginScroll.Enabled := true;
  end;
end;

procedure TfrmFingerDemo.FingerSuccess(FingerID: Cardinal);
var
  i: Integer;
begin
  for i := 0 to m_RegList.Count - 1 do
  begin
    if TRegItem(m_RegList.Items[i]).RegID = FingerID then
    begin
      ShowMessage(Format('指纹捕获成功，您是%d-%s',[FingerID,TRegItem(m_RegList.Items[i]).RegName]));
      btnBeginCapture.Enabled :=true;
      btnEndCapture.Click;      
      exit;
    end;
  end;

end;

procedure TfrmFingerDemo.FingerTouching(FingerImage: OleVariant);
var
  ms : TMemoryStream;
  bmp : TBitmap;
begin
  ms := TMemoryStream.Create;
  try
    TTFVariantUtils.TemplateOleVariantToStream(FingerImage,ms);
    bmp := TBitmap.Create;
    try
      ms.Position := 0;
      bmp.LoadFromStream(ms);
      image1.Picture.Bitmap:= bmp;
    finally
      bmp.Free;
    end;
  finally
    ms.Free;
  end;
end;

procedure TfrmFingerDemo.FormCreate(Sender: TObject);
begin
  m_RegList := TObjectList.Create;


  GlobalDM.Finger := TRsFingerObject.Create;
  GlobalDM.Finger.Init(ExtractFilePath(Application.ExeName) + 'libs\RsFingerLib.dll',
    CLASS_RsFinger,IUnKnown);

  (GlobalDM.Finger.DefaultInterface as IRsFinger).AddListener(self);

end;

procedure TfrmFingerDemo.FormDestroy(Sender: TObject);
begin
  (GlobalDM.Finger.DefaultInterface as IRsFinger).DeleteListener(self);
  GlobalDM.Finger.Free ;
  m_RegList.Free;
end;

procedure TfrmFingerDemo.FormShow(Sender: TObject);
begin
  btnOpenFinger.Enabled := true;
  btnCloseFinger.Enabled := false;
end;

class procedure TfrmFingerDemo.Show;
begin
  frmFingerDemo:= TfrmFingerDemo.Create(nil);
  try
    frmFingerDemo.ShowModal;
  finally
    frmFingerDemo.Free;
  end;
end;

procedure TfrmFingerDemo.btnBeginCaptureClick(Sender: TObject);
begin
  if not (GlobalDM.Finger.DefaultInterface as IRsFinger).Acitve  then
  begin
    ShowMessage('请先初始化指纹仪');
    exit;
  end;

  btnBeginCapture.Enabled := false;
  try
    (GlobalDM.Finger.DefaultInterface as IRsFinger).BeginCapture;


  except on e : exception do
    btnBeginCapture.Enabled := true;
  end;
end;

procedure TfrmFingerDemo.btnEndCaptureClick(Sender: TObject);
begin
  if not (GlobalDM.Finger.DefaultInterface as IRsFinger).Acitve then
  begin
    ShowMessage('请先初始化指纹仪');
    exit;
  end;

  (GlobalDM.Finger.DefaultInterface as IRsFinger).BeginCapture;

  btnBeginCapture.Enabled := true;
end;



end.
