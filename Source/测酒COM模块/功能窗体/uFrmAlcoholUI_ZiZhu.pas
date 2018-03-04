unit uFrmAlcoholUI_ZiZhu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, ImgList, PngImageList, jpeg, RzPanel, RzAnimtr,
  Buttons, PngCustomButton, RzPrgres, StdCtrls, pngimage, uTFImage,
  RsAlcoholLib_TLB,uFrmAlcoholUI,uTFVariantUtils;

type
  TFrmAlcoholUI_ZiZhu = class(TFormAlcoholUI)
    imgPicture: TTFImage;
    lblAlcoholResult: TLabel;
    lblSaveHint: TLabel;
    ProgressBar: TRzProgressBar;
    lblProgressBarHint: TLabel;
    btnCancel: TPngCustomButton;
    Animator: TRzAnimator;
    pnlTitle: TPanel;
    RzPanel1: TRzPanel;
    imgTrainmanPicture: TImage;
    PngImageList: TPngImageList;
    ActionList1: TActionList;
    ActCancel: TAction;
    Label9: TLabel;
    lblTrainNo: TLabel;
    Label8: TLabel;
    lblTrainNumber: TLabel;
    lblTrainTypeName: TLabel;
    Label3: TLabel;
    lblTrainmanNumber: TLabel;
    Label2: TLabel;
    lblTrainmanName: TLabel;
    tmrOverTime: TTimer;
    pCanvas: TRzPanel;
    label10: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    procedure ActCancelExecute(Sender: TObject);
    procedure tmrOverTimeTimer(Sender: TObject);
  private
    {开始测试时间}
    m_nStartTime: int64;
  private
    {功能:关闭测酒等待动画}
    procedure CloseAnimator();
  public
    { Public declarations }
    function GetCameraHandle: Cardinal;override;
    procedure InitUI(UI : IAlcoholUI);override;
    procedure SetReady; override;
    procedure SetNormal; override;
    procedure SetMore; override;
    procedure SetMuch; override;
    procedure SetError(ErrorMsg : string);override;
    procedure CloseUI; override;
    procedure SetPos(Pos:Integer); override;
  end;

var
  FrmAlcoholUI_ZiZhu: TFrmAlcoholUI_ZiZhu;

implementation

{$R *.dfm}

procedure TFrmAlcoholUI_ZiZhu.ActCancelExecute(Sender: TObject);
begin
    CancelTest;
end;


procedure TFrmAlcoholUI_ZiZhu.CloseAnimator;
begin
  Animator.Visible := False;
  Animator.Animate := False;
  tmrOverTime.Enabled := false ;
end;

procedure TFrmAlcoholUI_ZiZhu.CloseUI;
begin
  CloseAnimator;
  Close;
end;

function TFrmAlcoholUI_ZiZhu.GetCameraHandle: Cardinal;
begin
  result := pCanvas.Handle;
end;


procedure TFrmAlcoholUI_ZiZhu.InitUI(UI: IAlcoholUI);
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
          imgTrainmanPicture.Picture.Graphic := jpeg;
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

procedure TFrmAlcoholUI_ZiZhu.SetError(ErrorMsg: string);
begin
  CloseAnimator();
  lblAlcoholResult.Font.Color := clRed;
  lblAlcoholResult.Caption := '与测酒仪连接出现故障!请联系值班员。错误:(' +
    ErrorMsg + ')';
end;

procedure TFrmAlcoholUI_ZiZhu.SetMore;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '饮酒!不允许出勤!';
  lblAlcoholResult.Font.Color := clRed;
end;

procedure TFrmAlcoholUI_ZiZhu.SetMuch;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '酗酒!不允许出勤!';
  lblAlcoholResult.Font.Color := clRed;
end;

procedure TFrmAlcoholUI_ZiZhu.SetNormal;
begin
  lblSaveHint.Visible := True;
  lblAlcoholResult.Caption := '测试正常!';
end;


procedure TFrmAlcoholUI_ZiZhu.SetPos(Pos: Integer);
begin
  ;
end;

procedure TFrmAlcoholUI_ZiZhu.SetReady;
begin
  m_nStartTime := GetTickCount();
  CloseAnimator();
  ProgressBar.Visible := True;
  lblProgressBarHint.Visible := True;
  tmrOverTime.Enabled := True;
  m_nStartTime := GetTickCount();
  lblAlcoholResult.Caption := '请测酒';
end;


procedure TFrmAlcoholUI_ZiZhu.tmrOverTimeTimer(Sender: TObject);
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
      tmrOverTime.Enabled := False;
    end;
  end;
end;

end.
