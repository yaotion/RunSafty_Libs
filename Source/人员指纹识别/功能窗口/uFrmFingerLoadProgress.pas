unit uFrmFingerLoadProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzPrgres, ExtCtrls, RzPanel, pngimage,uTFSystem;

type
  TFrmFingerLoadProgress = class(TForm)
    RzPanel1: TRzPanel;
    Label1: TLabel;
    ProgressBar: TRzProgressBar;
    Image1: TImage;
  private
    { Private declarations }
    procedure StepProgress(nMax,nPosition: integer);
  public
    { Public declarations }
    class function ShowProgress(): TOnReadChangeEvent;
    class procedure CloseProgress();
  end;

implementation

var
  FrmFingerLoadProgress: TFrmFingerLoadProgress = nil;
{$R *.dfm}



{ TfrmReadFingerprintTemplates }

class procedure TFrmFingerLoadProgress.CloseProgress;
begin
  if Assigned(FrmFingerLoadProgress) then
  begin
    FreeAndNil(FrmFingerLoadProgress);
  end;
end;

class function TFrmFingerLoadProgress.ShowProgress: TOnReadChangeEvent;
begin
  if not Assigned(FrmFingerLoadProgress) then
  begin
    FrmFingerLoadProgress := TFrmFingerLoadProgress.Create(Application);
    FrmFingerLoadProgress.Show;
    FrmFingerLoadProgress.Update();
  end;
  Result := FrmFingerLoadProgress.StepProgress;
end;

procedure TFrmFingerLoadProgress.StepProgress(nMax, nPosition: integer);
begin
  ProgressBar.TotalParts := nMax;
  ProgressBar.PartsComplete := nPosition;
end;

end.
