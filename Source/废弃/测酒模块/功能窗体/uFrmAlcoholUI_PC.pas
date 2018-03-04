unit uFrmAlcoholUI_PC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngSpeedButton, pngimage, ExtCtrls, StdCtrls, RzPanel,
  RzAnimtr, RzTabs, RzPrgres, ActnList,uRsAlcoholLib,uTFVariantUtils,jpeg;
const
  MAX_COUNT = 5; //允许测试的最大计数
  TIMEOUT = 30; //测酒超时时间为30秒
type
  TfrmAlcoholUI_PC = class(TForm)
    RzPanel4: TRzPanel;
    Label4: TLabel;
    Image2: TImage;
    btnClose: TPngSpeedButton;
    tmrRunCamer: TTimer;
    TimerRef: TTimer;
    tmrCalcTestAlcoholTime: TTimer;
    tmrCloseWindow: TTimer;
    ActionList1: TActionList;
    ActCancel: TAction;
    RzPanel5: TRzPanel;
    Label3: TLabel;
    Label2: TLabel;
    lblTrainmanNumber: TLabel;
    lblTrainmanName: TLabel;
    Image1: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblTrainTypeName: TLabel;
    lblTrainNumber: TLabel;
    lblTrainNo: TLabel;
    RzPanel6: TRzPanel;
    Label1: TLabel;
    lblAlcoholResult: TLabel;
    lblSaveHint: TLabel;
    ProgressBar: TRzProgressBar;
    Animator: TRzAnimator;
    pCanvas: TRzPanel;
    Panel1: TPanel;
    procedure tmrCalcTestAlcoholTimeTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    {开始测试时间}
    m_nStartTime: int64;
    m_OnCancel : TNotifyEvent;
    m_OnTimeOut : TNotifyEvent;
    {功能:关闭测酒等待动画}
    procedure CloseAnimator();
    function GetCameraPanelHandle: Cardinal;
    procedure SetOnCancel(const Value: TNotifyEvent);
    procedure SetOnTimeOut(const Value: TNotifyEvent);
  protected
    procedure CancelTest;
    procedure TimerOut;
    { Private declarations }
  public
    { Public declarations }
    procedure InitUI(UI : IAlcoholUI);
    procedure SetReady;
    procedure SetNormal;
    procedure SetMore;
    procedure SetMuch;
    procedure SetError(ErrorMsg : string);
    procedure CloseUI;
    property CameraPanelHandle : Cardinal read GetCameraPanelHandle;
    property OnCancel : TNotifyEvent read m_OnCancel write SetOnCancel;
    property OnTimeOut : TNotifyEvent read m_OnTimeOut write SetOnTimeOut;
  end;

implementation

{$R *.dfm}

{ TfrmAlcoholUI_PC }

procedure TfrmAlcoholUI_PC.btnCloseClick(Sender: TObject);
begin
  CancelTest;
end;

procedure TfrmAlcoholUI_PC.CancelTest;
begin
  Close;
  if assigned(m_OnCancel) then
  begin
    m_OnCancel(Self);
  end;
end;

procedure TfrmAlcoholUI_PC.CloseAnimator;
begin
  Animator.Visible := False;
  Animator.Animate := False;
end;

procedure TfrmAlcoholUI_PC.CloseUI;
begin
  CloseAnimator;
  Close;
end;

function TfrmAlcoholUI_PC.GetCameraPanelHandle: Cardinal;
begin
  result := pCanvas.Handle;
end;

procedure TfrmAlcoholUI_PC.InitUI(UI : IAlcoholUI);
var
  ms : TMemoryStream;
  jpeg : TJPEGImage;
begin
  Animator.Visible := True;
  Animator.Animate := True;
  lblAlcoholResult.Caption := '等待测酒仪就绪...';

  ProgressBar.TotalParts := TIMEOUT * 1000;
  ProgressBar.PartsComplete := 0;
  ProgressBar.Visible := False;
  Label1.Visible := False;
  tmrCalcTestAlcoholTime.Enabled := False;

  lblTrainmanNumber.Caption := ui.TrainmanNumber;
  lblTrainmanName.Caption := ui.TrainmanName;
  lblTrainTypeName.Caption := ui.TrainTypeName;
  lblTrainNumber.Caption := ui.TrainmanNumber;
  lblTrainNo.Caption := ui.TrainNo;

  ms := TMemoryStream.Create;
  try
    uTFVariantUtils.TTFVariantUtils.TemplateOleVariantToStream(ui.Picture,ms);
    ms.Position :=0;
    jpeg := TJPEGImage.Create;
    try
      jpeg.LoadFromStream(ms);
      image1.Picture.Graphic := jpeg;
    finally
      jpeg.Free;
    end;
  finally
    ms.Free;
  end;
end;


procedure TfrmAlcoholUI_PC.SetError(ErrorMsg : string);
begin
  CloseAnimator();
  lblAlcoholResult.Font.Color := clRed;
  lblAlcoholResult.Caption := '与测酒仪连接出现故障!请联系值班员。错误:(' +
    ErrorMsg + ')';
end;

procedure TfrmAlcoholUI_PC.SetMore;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '饮酒!不允许出勤!';
  lblAlcoholResult.Font.Color := clRed;
  tmrCloseWindow.Enabled := True;
end;

procedure TfrmAlcoholUI_PC.SetMuch;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '酗酒!不允许出勤!';
  lblAlcoholResult.Font.Color := clRed;
  tmrCloseWindow.Enabled := True;
end;

procedure TfrmAlcoholUI_PC.SetNormal;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '测试正常!';
  tmrCloseWindow.Enabled := True;
end;

procedure TfrmAlcoholUI_PC.SetOnCancel(const Value: TNotifyEvent);
begin
  m_OnCancel := Value;
end;

procedure TfrmAlcoholUI_PC.SetOnTimeOut(const Value: TNotifyEvent);
begin
  m_OnTimeOut := Value;
end;

procedure TfrmAlcoholUI_PC.SetReady;
begin
  m_nStartTime := GetTickCount();
  ProgressBar.Visible := True;
  Label1.Visible := True;
  tmrCalcTestAlcoholTime.Enabled := True;
  m_nStartTime := GetTickCount();
  lblAlcoholResult.Caption := '请测酒';
end;

procedure TfrmAlcoholUI_PC.TimerOut;
begin
  Close;
  if assigned(m_OnTimeOut) then
  begin
    m_OnTimeOut(Self);
  end;
end;

procedure TfrmAlcoholUI_PC.tmrCalcTestAlcoholTimeTimer(Sender: TObject);
begin
 try
    ProgressBar.PartsComplete := GetTickCount() - m_nStartTime;
    if ProgressBar.TotalParts = ProgressBar.PartsComplete then
    begin
      CloseAnimator();
      lblSaveHint.Visible := True;
      lblAlcoholResult.Caption := '测酒超时!';
      lblAlcoholResult.Font.Color := clRed;
      tmrCloseWindow.Enabled := True;
      CancelTest;
    end;
  except
    on E: Exception do
    begin
      tmrCalcTestAlcoholTime.Enabled := False;
    end;
  end;
end;

end.
