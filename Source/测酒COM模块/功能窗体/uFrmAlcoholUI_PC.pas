unit uFrmAlcoholUI_PC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngSpeedButton, pngimage, ExtCtrls, StdCtrls, RzPanel,
  RzAnimtr, RzTabs, RzPrgres, ActnList,RsAlcoholLib_TLB,uFrmAlcoholUI,uTFVariantUtils,jpeg,
  ImgList, PngImageList;

type
  TfrmAlcoholUI_PC = class(TFormAlcoholUI)
    RzPanel4: TRzPanel;
    Label4: TLabel;
    Image2: TImage;
    btnClose: TPngSpeedButton;
    tmrOverTime: TTimer;
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
    lblProgressBarHint: TLabel;
    lblAlcoholResult: TLabel;
    lblSaveHint: TLabel;
    ProgressBar: TRzProgressBar;
    Animator: TRzAnimator;
    pCanvas: TRzPanel;
    Panel1: TPanel;
    label10: TLabel;
    PngImageList: TPngImageList;
    procedure tmrOverTimeTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    {开始测试时间}
    m_nStartTime: int64;
    {功能:关闭测酒等待动画}
    procedure CloseAnimator();
  public
    { Public declarations }
    function GetCameraHandle: Cardinal;override;
    procedure InitUI(UI : IAlcoholUI);override;
    procedure SetReady;override;
    procedure SetNormal;override;
    procedure SetMore;override;
    procedure SetMuch;override;
    procedure SetError(ErrorMsg : string); override;
    procedure CloseUI; override;
    procedure SetPos(Pos:Integer); override;
  end;

implementation

{$R *.dfm}

{ TfrmAlcoholUI_PC }

procedure TfrmAlcoholUI_PC.btnCloseClick(Sender: TObject);
begin
  CancelTest;
end;



procedure TfrmAlcoholUI_PC.CloseAnimator;
begin
  Animator.Visible := False;
  Animator.Animate := False;
  tmrOverTime.Enabled := false ;
end;

procedure TfrmAlcoholUI_PC.CloseUI;
begin
  CloseAnimator;
  Close;
end;

procedure TfrmAlcoholUI_PC.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TfrmAlcoholUI_PC.FormDestroy(Sender: TObject);
begin
  OutputDebugString('TfrmAlcoholUI_PC.FormDestroy');
end;

function TfrmAlcoholUI_PC.GetCameraHandle: Cardinal;
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
  lblProgressBarHint.Visible := False;
  tmrOverTime.Enabled := False;

  lblTrainmanNumber.Caption := ui.TrainmanNumber;
  lblTrainmanName.Caption := ui.TrainmanName;
  lblTrainTypeName.Caption := ui.TrainTypeName;
  lblTrainNumber.Caption := ui.TrainmanNumber;
  lblTrainNo.Caption := ui.TrainNo;

  ms := TMemoryStream.Create;
  try
    TTFVariantUtils.TemplateOleVariantToStream(ui.Picture,ms);
    ms.Position :=0;
    if ms.Size <> 0 then
    begin
      try
        jpeg := TJPEGImage.Create;
        try
          jpeg.LoadFromStream(ms);
          Image1.Picture.Graphic := jpeg;
        finally
          jpeg.Free;
        end;
      except

      end;
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
end;

procedure TfrmAlcoholUI_PC.SetMuch;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '酗酒!不允许出勤!';
  lblAlcoholResult.Font.Color := clRed;
end;

procedure TfrmAlcoholUI_PC.SetNormal;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '测试正常!';
end;



procedure TfrmAlcoholUI_PC.SetPos(Pos: Integer);
begin
  if Pos = Ord(ptNormal) then
  begin
    Self.Left := (Screen.Width - Self.Width) div 2;
    Self.Top := (Screen.Height - Self.Height) div 2;
  end
  else if Pos = Ord(ptRightBottom) then
  begin
    Self.Left := Screen.Width - Self.Width;
    Self.Top := Screen.Height - Self.Height;
  end;
end;

procedure TfrmAlcoholUI_PC.SetReady;
begin
  m_nStartTime := GetTickCount();
  CloseAnimator;
  ProgressBar.Visible := True;
  lblProgressBarHint.Visible := True;
  tmrOverTime.Enabled := True;
  m_nStartTime := GetTickCount();
  lblAlcoholResult.Caption := '请测酒';
end;



procedure TfrmAlcoholUI_PC.tmrOverTimeTimer(Sender: TObject);
begin
 try
    ProgressBar.PartsComplete := GetTickCount() - m_nStartTime;
    if ProgressBar.TotalParts = ProgressBar.PartsComplete then
    begin
      TTimer(Sender).Enabled := False ;
      CloseAnimator();
      lblSaveHint.Visible := True;
      lblAlcoholResult.Caption := '测酒超时!';
      lblAlcoholResult.Font.Color := clRed;
      TimerOut;
    end;
  except
    on E: Exception do
    begin
      TTimer(Sender).Enabled := False;
    end;
  end;
end;

end.
