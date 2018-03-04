unit uFrmAddMealTicketRuleInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,utfsystem,uMealTicketRule, ComCtrls;

type
  TFrmAddMealTicketRuleInfo = class(TForm)
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    edtCheCi: TEdit;
    dtpEnd: TDateTimePicker;
    Label1: TLabel;
    dtpStart: TDateTimePicker;
    Label3: TLabel;
    Label5: TLabel;
    edtQuDuan: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //车次信息
    m_CheCiInfo:RRsMealTicketCheCi;
  private
    { Private declarations }
    procedure InitData(CheCiInfo:RRsMealTicketCheCi);
    //检查界面条件
    function CheckInput():Boolean;
  public
    { Public declarations }
    class function GetRuleInfo(var CheCiInfo:RRsMealTicketCheCi):Boolean;
  end;

var
  FrmAddMealTicketRuleInfo: TFrmAddMealTicketRuleInfo;

implementation

{$R *.dfm}

procedure TFrmAddMealTicketRuleInfo.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmAddMealTicketRuleInfo.btnOkClick(Sender: TObject);
var
  strQuDuan:string;
begin
  if not CheckInput then
    Exit;

  m_CheCiInfo.dtStartTime := AssembleDateTime(StrToDateTime('1899-12-30'),dtpStart.Time );
  m_CheCiInfo.dtEndTime := AssembleDateTime(StrToDateTime('1899-12-30'),dtpEnd.Time );
  m_CheCiInfo.strCheCi := Trim(edtCheCi.Text) ;

  strQuDuan := Trim(edtQuDuan.Text) ;
  //strQuDuan := StringReplace(strQuDuan,'-,'-',[rfReplaceAll]);
  m_CheCiInfo.strQuDuan := strQuDuan ;

  ModalResult := mrOk ;
end;

function TFrmAddMealTicketRuleInfo.CheckInput: Boolean;
begin
  Result := False ;
  if dtpEnd.DateTime <= dtpStart.DateTime then
  begin
    BoxErr('结束时间不能小于开始时间');
    Exit;
  end;

  Result := True ;
end;

procedure TFrmAddMealTicketRuleInfo.FormCreate(Sender: TObject);
begin
  dtpStart.Format:='HH:mm:ss';
  dtpEnd.Format := 'HH:mm:ss';
end;

procedure TFrmAddMealTicketRuleInfo.FormDestroy(Sender: TObject);
begin
  ;
end;

class function TFrmAddMealTicketRuleInfo.GetRuleInfo(
  var CheCiInfo: RRsMealTicketCheCi): Boolean;
var
  frm : TFrmAddMealTicketRuleInfo;
begin
  Result := False ;
  frm := TFrmAddMealTicketRuleInfo.Create(nil);
  try
    frm.InitData(CheCiInfo);
    if frm.ShowModal = mrOk then
    begin
      CheCiInfo := frm.m_CheCiInfo ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

procedure TFrmAddMealTicketRuleInfo.InitData(CheCiInfo: RRsMealTicketCheCi);
begin
  m_CheCiInfo := CheCiInfo ;
  dtpStart.DateTime := CheCiInfo.dtStartTime;
  dtpEnd.DateTime := CheCiInfo.dtEndTime ;
  edtCheCi.Text := CheCiInfo.strCheCi ;
  edtQuDuan.Text := CheCiInfo.strQuDuan ;
end;

end.
