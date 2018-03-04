unit uFrmAddCheCi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzLabel, RzButton, RzRadChk,uTFSystem,
  ExtCtrls, RzCommon;

type
  TFrmAddCheCi = class(TForm)
    lbl1: TRzLabel;
    edtCheCiGo: TRzEdit;
    edtCheCiBack: TRzEdit;
    lbl2: TRzLabel;
    checkIsRest: TRzCheckBox;
    RzFrameController1: TRzFrameController;
    Bevel1: TBevel;
    btnOK: TButton;
    rzbtbtnCancel: TButton;
    procedure checkIsRestClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure rzbtbtnCancelClick(Sender: TObject);
    procedure edtCheCiGoExit(Sender: TObject);
    procedure edtCheCiBackExit(Sender: TObject);
  private
    { Private declarations }
    procedure SetEditEnable;
  public
    //获取记名式交路的车次信息
    class function GetCheCiInfo(var CheCi1,CheCi2 : string;var IsRest : boolean) : boolean;
  end;

implementation

{$R *.dfm}

{ TFrmAddCheCi }


procedure TFrmAddCheCi.rzbtbtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmAddCheCi.SetEditEnable;
begin
  if checkIsRest.Checked then
  begin
    edtCheCiGo.Enabled := false;
    edtCheCiBack.Enabled := false;
  end else begin
    edtCheCiGo.Enabled := true;
    edtCheCiBack.Enabled := true;
  end;
end;

procedure TFrmAddCheCi.btnOKClick(Sender: TObject);
begin
  if not checkIsRest.Checked then
  begin
    if Trim(edtCheCiGo.Text) = '' then
    begin
      Box('请输入出乘车次');
      //edtCheCiGo.SetFocus;
      exit;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TFrmAddCheCi.checkIsRestClick(Sender: TObject);
begin
  SetEditEnable;
end;


procedure TFrmAddCheCi.edtCheCiBackExit(Sender: TObject);
begin
  edtCheCiBack.Text := UpperCase(edtCheCiBack.Text);
end;

procedure TFrmAddCheCi.edtCheCiGoExit(Sender: TObject);
begin
  edtCheCiGo.Text := UpperCase(edtCheCiGo.Text);
end;

class function TFrmAddCheCi.GetCheCiInfo(var CheCi1, CheCi2: string;
  var IsRest: boolean): boolean;
var
  frmAddCheCi : TFrmAddCheCi;
begin
  result := false;
  frmAddCheCi := TFrmAddCheCi.Create(nil);
  try
    frmAddCheCi.edtCheCiGo.Text := Trim(CheCi1);
    frmAddCheCi.edtCheCiBack.Text := Trim(CheCi2);
    frmAddCheCi.checkIsRest.Checked := IsRest;
    frmAddCheCi.SetEditEnable;
    if frmAddCheCi.ShowModal <> mrOK then exit;
    CheCi1 := UpperCase(Trim(frmAddCheCi.edtCheCiGo.Text));
    CheCi2 := UpperCase(Trim(frmAddCheCi.edtCheCiBack.Text));
    IsRest := frmAddCheCi.checkIsRest.Checked;
    result := true;
  finally
    frmAddCheCi.Free;
  end;
end;

end.
