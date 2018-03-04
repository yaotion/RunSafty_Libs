unit ufrmTestDrinking;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, ufrmCamer, RzPrgres, RzAnimtr, StdCtrls,uApparatus,
  {uBaseDefine,} uAlcoBaseDefine, ImgList, PngImageList, MMSystem, JPEG,uTFSystem,
  uCenterStretchImage,ActnList, Buttons, PngCustomButton, uTrainman,
  uApparatusCommon, RzPanel, RzTabs, PngSpeedButton,uTFVariantUtils,
  ZKFPEngXUtils;

const
  MAX_COUNT = 5; //允许测试的最大计数
  TIMEOUT = 30; //测酒超时时间为30秒
type
  TfrmTestDrinking = class(TForm)
    tmrRunCamer: TTimer;
    TimerRef: TTimer;
    tmrCalcTestAlcoholTime: TTimer;
    tmrCloseWindow: TTimer;
    ActionList1: TActionList;
    ActCancel: TAction;
    RzPanel4: TRzPanel;
    Label4: TLabel;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    Label1: TLabel;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    Animator: TRzAnimator;
    lblAlcoholResult: TLabel;
    lblSaveHint: TLabel;
    Image2: TImage;
    btnClose: TPngSpeedButton;
    Label3: TLabel;
    Label2: TLabel;
    lblTrainmanNumber: TLabel;
    lblTrainmanName: TLabel;
    Image1: TImage;
    Label5: TLabel;
    imgTrainmanPicture1: TPaintBox;
    Label6: TLabel;
    ProgressBar: TRzProgressBar;
    Label8: TLabel;
    Label9: TLabel;
    lblTrainTypeName: TLabel;
    lblTrainNumber: TLabel;
    lblTrainNo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tmrRunCamerTimer(Sender: TObject);
    procedure TimerRefTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrCloseWindowTimer(Sender: TObject);
    procedure tmrCalcTestAlcoholTimeTimer(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgTrainmanPicture1Paint(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //车次
    m_strTrainNo:string;
    //车型
    m_strTrainTypeName:string;
    //车号
    m_strTrainNumber:string;
    {测酒仪操作对象}
    m_AlcoholTest : TApparatus;
    {是否正在测酒}
    m_bIsTestAlcohol: Boolean;
    {是否就绪}
    m_bReady: Boolean;
    {开始测试时间}
    m_nStartTime: int64;
    {测酒结果}
    m_TestAlcoholInfo : RTestAlcoholInfo;
    //是否已经存储过照片
    m_bCaptured : boolean;
    {当前测酒的乘务员信息}
////    m_Trainman : RRsTrainman;

    {功能:绘制字幕到流}
    procedure PaintZiMu();
    {功能:绘制字幕到位图}
    procedure PAintToBmp(Picture: TBitmap);
    {功能:开始测酒}
    procedure StartTest();
    {功能:停止测酒}
    procedure EndTest();
    {功能:关闭测酒等待动画}
    procedure CloseAnimator();
    {功能:初始化测酒仪}
    procedure InitAlcoholTest();
    {功能:初始化测酒相关界面}
    procedure InitTestAlcoholUI();
    {功能:保存测酒结果}
    procedure SaveAlcohol(dwAlcoholicity :Word ; wStatus: Word);
    {功能:测酒状态通知事件}
    procedure OnApparatusInfo(Info: RApparatusInfo);
    {功能:根据测酒状态播放语音}
    procedure PlayAlcoholTestResult(AlcoholicStatus: TAlcoholicStatus);
    {功能:进行测酒提示}
    procedure PleaseTestAlcohol();
    {功能:根据Woed类型的测酒结果返回TTestAlcoholResult型的测酒结果}
    function GetAlcoholResult(wStatus: Word): TTestAlcoholResult;
    procedure OnPhotoCaptured();
  public
    { Public declarations }
  end;

  {功能:饮酒测试}
////  procedure TestDrinking(Trainman:RRsTrainman;TrainTypeName,TrainNumber,TrainNo:string;AlcoholTest : TApparatus;
//      var TestAlcoholInfo:RTestAlcoholInfo;RightBottomShow: Boolean = False);

implementation

{$R *.dfm}

//procedure TestDrinking(Trainman:RRsTrainman;TrainTypeName,TrainNumber,TrainNo:string;AlcoholTest : TApparatus;
//    var TestAlcoholInfo:RTestAlcoholInfo;RightBottomShow: Boolean);
//{功能:饮酒测试}
//var
//  frmTestDrinking: TfrmTestDrinking;
//begin
//  frmTestDrinking := TfrmTestDrinking.Create(nil);
//  try
//
//    if RightBottomShow then
//    begin
//      frmTestDrinking.Position := poDesigned;
//      frmTestDrinking.Left := Screen.Width - frmTestDrinking.Width;
//      frmTestDrinking.Top := Screen.Height - frmTestDrinking.Height;
//    end;
//    frmTestDrinking.m_strTrainNo :=  TrainNo ;
//    frmTestDrinking.m_strTrainTypeName := TrainTypeName ;
//    frmTestDrinking.m_strTrainNumber := TrainNumber ;
//    frmTestDrinking.m_Trainman := Trainman;
//    frmTestDrinking.m_AlcoholTest := TApparatus.Create(nil);
//
//////    if FileExists(GlobalDM.AppPath + 'Config.ini') then
////    begin
////      frmTestDrinking.m_AlcoholTest.bDisplayDrinkResult :=
////        ReadIniFile(GlobalDM.AppPath + 'Config.ini','SysConfig','CjyType') <> '1';
////      frmTestDrinking.m_AlcoholTest.bDisplayGongHao :=
////        frmTestDrinking.m_AlcoholTest.bDisplayDrinkResult;
////    end;
//
//
//    frmTestDrinking.m_AlcoholTest.OnRunPhoto := frmTestDrinking.OnPhotoCaptured;
//
//    frmTestDrinking.ShowModal;
//    TestAlcoholInfo.taTestAlcoholResult :=
//        frmTestDrinking.m_TestAlcoholInfo.taTestAlcoholResult;
//    TestAlcoholInfo.dwAlcoholicity := frmTestDrinking.m_TestAlcoholInfo.dwAlcoholicity ;
//    TestAlcoholInfo.dtTestTime := frmTestDrinking.m_TestAlcoholInfo.dtTestTime;
//    if TestAlcoholInfo.taTestAlcoholResult <> taNoTest then
//    begin
//      if frmTestDrinking.m_TestAlcoholInfo.IsHavePicture then
//        frmTestDrinking.PaintZiMu;
//    end;
//    TestAlcoholInfo.Picture := frmTestDrinking.m_TestAlcoholInfo.Picture;
//
//  finally
//    frmTestDrinking.Free;
//  end;
//end;



procedure TfrmTestDrinking.ActCancelExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmTestDrinking.CloseAnimator;
//功能:关闭动画
begin
  Animator.Visible := False;
  Animator.Animate := False;
end;



procedure TfrmTestDrinking.EndTest;
//功能：结束测试
begin
  tmrCalcTestAlcoholTime.Enabled := False;
  try
    m_AlcoholTest.OnApparatusInfoChange := nil;
    m_AlcoholTest.StopTest;
  except
  end;
  m_bIsTestAlcohol := False;

end;

procedure TfrmTestDrinking.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if m_bIsTestAlcohol then
    m_AlcoholTest.OnApparatusInfoChange := nil;
///  frmcmr.CloseCamera;
end;

procedure TfrmTestDrinking.FormCreate(Sender: TObject);
begin
  m_bIsTestAlcohol := False;
  m_TestAlcoholInfo.taTestAlcoholResult := taNoTest;
  ///m_TestAlcoholInfo.dtTestTime := GlobalDM.GetNow;
end;

procedure TfrmTestDrinking.FormDestroy(Sender: TObject);
begin
 if Assigned(m_AlcoholTest) then
  begin
    m_AlcoholTest.Free;
  end;
end;

procedure TfrmTestDrinking.FormShow(Sender: TObject);
begin



////  m_AlcoholTest.strName := m_Trainman.strTrainmanName;
//  m_AlcoholTest.strNo := m_Trainman.strTrainmanNumber;
//
//  lblTrainmanName.Caption := m_Trainman.strTrainmanName;
//  lblTrainmanNumber.Caption := m_Trainman.strTrainmanNumber;

  //车次信息
  lblTrainTypeName.Caption := m_strTrainTypeName ;
  lblTrainNumber.Caption := m_strTrainNumber ;
  lblTrainNo.Caption := m_strTrainNo ;

  InitAlcoholTest();
  InitTestAlcoholUI();
  lblAlcoholResult.Caption := '正在打开摄像头...';
  tmrRunCamer.Enabled := True;

  if not m_AlcoholTest.Open then
  begin
    Application.MessageBox('打开测酒仪失败。','提示',MB_OK);
  end;
end;

function TfrmTestDrinking.GetAlcoholResult(wStatus: Word): TTestAlcoholResult;
//功能:返回测酒结果
begin
  result := taNoTest;
  case wStatus of
    crNormal: Result := taNormal;
    crMore: Result := taAlcoholContentMiddling;
    crMuch: Result := taAlcoholContentHeight;
    crAbnormity: Result := tsError;
  end;
end;

procedure TfrmTestDrinking.imgTrainmanPicture1Paint(Sender: TObject);
begin
////  TTFVariantUtils.CopyJPEGVariantToPaintBox(m_Trainman.Picture,TPaintBox(Sender));
end;

procedure TfrmTestDrinking.InitAlcoholTest;
//功能:初始化测酒仪
var
  AlcoholConfig: RAlcoholConfig;
  strNormalStandard, strDrinkStandard, strBibulosityStandard: string;
  strDir : String;
begin
  strDir := ExtractFileDir(Application.ExeName)+'\';
  strNormalStandard :=
    Trim(ReadIniFile(strDir + 'config.ini', 'Alcohol', 'dwNormalStandard'));

  strDrinkStandard :=
    Trim(ReadIniFile(strDir + 'config.ini', 'Alcohol', 'dwDrinkStandard'));

  strBibulosityStandard :=
    Trim(ReadIniFile(strDir + 'config.ini', 'Alcohol', 'dwBibulosityStandard'));

  if strNormalStandard <> '' then
    AlcoholConfig.dwNormalStandard := StrToInt(strNormalStandard)
  else
    AlcoholConfig.dwNormalStandard := 20; //正常标准

  if strDrinkStandard <> '' then
    AlcoholConfig.dwDrinkStandard := StrToInt(strDrinkStandard)
  else
    AlcoholConfig.dwDrinkStandard := 25; //饮酒标准

  if strBibulosityStandard <> '' then
    AlcoholConfig.dwBibulosityStandard := StrToInt(strBibulosityStandard)
  else
    AlcoholConfig.dwBibulosityStandard := 80; //酗酒标准

  AlcoholConfig.dwNormalModify := 0; //正常标准修订
  AlcoholConfig.dwDrinkModify := 0; //饮酒标准修订
  AlcoholConfig.dwBibulosityModify := 0; //酗酒标准修订

  m_AlcoholTest.AlcolholConfig := AlcoholConfig;

end;

procedure TfrmTestDrinking.InitTestAlcoholUI;
//功能：初始化测酒界面
begin
  Animator.Visible := True;
  Animator.Animate := True;
  lblAlcoholResult.Caption := '等待测酒仪就绪...';

  ProgressBar.TotalParts := TIMEOUT * 1000;
  ProgressBar.PartsComplete := 0;
  ProgressBar.Visible := False;
  Label1.Visible := False;
  tmrCalcTestAlcoholTime.Enabled := False;

end;

procedure TfrmTestDrinking.OnApparatusInfo(Info: RApparatusInfo);
//功能:测酒仪测试变化通知
var
  bFirstRead : boolean;
begin
  bFirstRead:=not m_bReady;
  if (Info.wStatus = crReady) then
  begin
    m_bReady := True;
  end;
  if m_bReady = False then Exit;

  CloseAnimator();

  if Info.wStatus <> crReady then
    SaveAlcohol(Info.dwAlcoholicity,Info.wStatus);

  case Info.wStatus of
    crReady:
      begin
        if bFirstRead then
          PleaseTestAlcohol();
        Exit;
      end;
    crNormal:
      begin
        EndTest();
        lblSaveHint.Visible := True;
        lblAlcoholResult.Caption := '测试正常!';
        PlayAlcoholTestResult(acrNormal);
///        frmcmr.CloseCamera;
        tmrCloseWindow.Enabled := True;
        Exit;
      end;
    crMore:
      begin
        EndTest();
///        frmCmr.CloseCamera();
        lblSaveHint.Visible := True;
        lblAlcoholResult.Caption := '饮酒!不允许出勤!';
        lblAlcoholResult.Font.Color := clRed;

        PlayAlcoholTestResult(acrMore);
        tmrCloseWindow.Enabled := True;
        Exit;

      end;
    crMuch:
      begin
        EndTest();
///        frmCmr.CloseCamera();
        lblSaveHint.Visible := True;
        lblAlcoholResult.Caption := '酗酒!不允许出勤!';
        lblAlcoholResult.Font.Color := clRed;
        PlayAlcoholTestResult(acrMuch);
        tmrCloseWindow.Enabled := True;
        Exit;
      end;
  end;

end;

procedure TfrmTestDrinking.OnPhotoCaptured;
var
  ms : TMemoryStream;
begin
  if not m_bCaptured then
  begin
    m_bCaptured := true;
    ms := TMemoryStream.Create;
    try
///      frmcmr.CapturePictureByStream(ms, pfBMP);
      m_TestAlcoholInfo.Picture :=  StreamToTemplateOleVariant(ms);
    finally
      ms.Free;
    end;
  end;
end;
procedure TfrmTestDrinking.PAintToBmp(Picture: TBitmap);
var
  strText : String;
begin
  //绘制背景
  DrawAlphaBackground(Picture,clBlack,Rect(0,0,90,115),140);
  //加入工号，姓名，测酒日期，测酒时间
  Picture.Canvas.Brush.Style := bsClear;
  Picture.Canvas.Font.Name := '宋体';
  Picture.Canvas.Font.Size := 9;
  Picture.Canvas.Font.Color := clWhite;
////  Picture.Canvas.TextOut(3,3,'工号:'+m_Trainman.strTrainmanNumber);
//  Picture.Canvas.TextOut(3,22,'姓名:'+m_Trainman.strTrainmanName);
//
//  Picture.Canvas.TextOut(3,41,'日期:'+formatDateTime('yy-MM-dd',
//      m_TestAlcoholInfo.dtTestTime));
//  Picture.Canvas.TextOut(3,60,'时间:'+formatDateTime('hh:mm:ss',
//      m_TestAlcoholInfo.dtTestTime));
//  Picture.Canvas.TextOut(3,79,'酒精:' + IntToStr( m_TestAlcoholInfo.dwAlcoholicity));

      
  strText := '';

  case m_TestAlcoholInfo.taTestAlcoholResult of
    taNormal: strText := '正常';
    taAlcoholContentMiddling:strText := '饮酒';
    taAlcoholContentHeight: strText := '酗酒';
    taNoTest: strText := '未测试';
    tsError: strText := '故障';
    else
      strText := '其他' ;
  end;

  if m_TestAlcoholInfo.taTestAlcoholResult <> taNormal then
    Picture.Canvas.Font.Color := clRed;
  Picture.Canvas.TextOut(3,98,'结果:'+strText);
end;

procedure TfrmTestDrinking.PaintZiMu;
var
  PictureStream:TMemoryStream;
  Jpeg: TJPEGImage;
  Bmp: TBitmap;
  i,j:Integer;
begin
  if m_TestAlcoholInfo.IsHavePicture = False then Exit;
  PictureStream := TMemoryStream.Create;
  Jpeg := TJpegImage.Create;
  Bmp := TBitmap.Create;
  try
    TemplateOleVariantToStream(m_TestAlcoholInfo.Picture,PictureStream);
    PictureStream.Position := 0;
    //Jpeg.LoadFromStream(PictureStream);
    //Bmp.Assign(Jpeg);
    Bmp.LoadFromStream(PictureStream);
    PAintToBmp(Bmp);
    Jpeg.Assign(Bmp);
    Jpeg.CompressionQuality := 70;
    Jpeg.Compress;
    PictureStream.Clear;
    Jpeg.SaveToStream(PictureStream);
    m_TestAlcoholInfo.Picture := StreamToTemplateOleVariant(PictureStream);
  finally
    Jpeg.Free;
    Bmp.Free;
    PictureStream.Free;
  end;
end;

procedure TfrmTestDrinking.PlayAlcoholTestResult(
  AlcoholicStatus: TAlcoholicStatus);
var
  strFile,strPath : string ;
begin
  case AlcoholicStatus of
    acrReady: begin
      strFile := '请测酒.wav';
      m_AlcoholTest.bOnLight := True;
    end;
    acrNormal: strFile := '测试正常.wav';
    acrMore: strFile := '饮酒.wav';
    acrMuch: strFile := '酗酒.wav';
  end;
                             
  strPath := ExtractFilePath(Application.ExeName) + 'Sounds\';
  strFile := strPath + strFile;
  if FileExists(strFile) then
  begin
////    //如果使用本地音乐
////    if GlobalDM.IsUseLocalDrinkSound then
//    begin
//      PlaySound(Pchar(strFile),Handle,SND_FILENAME or SND_ASYNC);
//    end;
  end;
end;

procedure TfrmTestDrinking.SaveAlcohol(dwAlcoholicity :Word ;wStatus: Word);
//功能:保存测酒结果
var
  ms : TMemoryStream;
begin
  m_TestAlcoholInfo.taTestAlcoholResult := GetAlcoholResult(wStatus);
////  m_TestAlcoholInfo.dwAlcoholicity := dwAlcoholicity ;
  ms := TMemoryStream.Create;
  try
    if not m_bCaptured then
    begin
///      frmcmr.CapturePictureByStream(ms, pfBMP);
      m_TestAlcoholInfo.Picture := TTFVariantUtils.StreamToTemplateOleVariant(ms);
    end;
  finally
    ms.Free;
  end;
////  m_TestAlcoholInfo.dtTestTime := GlobalDM.GetNow();
end;

procedure TfrmTestDrinking.StartTest;
//功能：开始测试
begin
  //启动提示
  InitTestAlcoholUI();
  m_bReady := False;
  try
    m_AlcoholTest.OnApparatusInfoChange := OnApparatusInfo;
    m_AlcoholTest.StartTest(False);
  except
    on E: Exception do
    begin
      CloseAnimator();
      lblAlcoholResult.Font.Color := clRed;
      lblAlcoholResult.Caption := '与测酒仪连接出现故障!请联系值班员。错误:(' +
        E.Message + ')';
      Exit;
    end;
  end;
  m_bIsTestAlcohol := True;

end;

procedure TfrmTestDrinking.TimerRefTimer(Sender: TObject);
begin
  TimerRef.Enabled := False;
  TimerRef.Interval := 3000; //以后每次重新测酒都要等待3秒
  if m_bIsTestAlcohol then
    EndTest();
  StartTest();
end;

procedure TfrmTestDrinking.PleaseTestAlcohol;
//功能：进行测酒提示
begin
  ProgressBar.Visible := True;
  Label1.Visible := True;
  tmrCalcTestAlcoholTime.Enabled := True;
  m_nStartTime := GetTickCount();
  lblAlcoholResult.Caption := '请测酒';
  PlayAlcoholTestResult(acrReady);
end;

procedure TfrmTestDrinking.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTestDrinking.tmrCalcTestAlcoholTimeTimer(Sender: TObject);
begin
  try
    ProgressBar.PartsComplete := GetTickCount() - m_nStartTime;
    if ProgressBar.TotalParts = ProgressBar.PartsComplete then
    begin
      EndTest();
      CloseAnimator();
      SaveAlcohol(0,crTimeOut);
///      frmCmr.CloseCamera();
      lblSaveHint.Visible := True;
      lblAlcoholResult.Caption := '测酒超时!';
      lblAlcoholResult.Font.Color := clRed;
      tmrCloseWindow.Enabled := True;
    end;
  except
    on E: Exception do
    begin
      tmrCalcTestAlcoholTime.Enabled := False;
    end;
  end;
end;

procedure TfrmTestDrinking.tmrCloseWindowTimer(Sender: TObject);
begin
  tmrCloseWindow.Enabled := False;
  Close;
end;

procedure TfrmTestDrinking.tmrRunCamerTimer(Sender: TObject);
begin
  tmrRunCamer.Enabled := False;
  try
////    frmcmr.IniCamera();
//    frmcmr.OpenCamera;
  except
    on E: Exception do
    begin
      lblAlcoholResult.Font.Color := clRed;
      lblAlcoholResult.Caption := '摄像头打开失败!错误:(' +E.Message + ')';
      Exit;
    end;
  end;
  lblAlcoholResult.Caption := '等待测酒仪就绪...';
  TimerRef.Enabled := True;
end;


end.

