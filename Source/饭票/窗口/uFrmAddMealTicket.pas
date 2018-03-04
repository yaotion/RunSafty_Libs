unit uFrmAddMealTicket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,utfsystem,uTrainman,
  uLCTrainmanMgr,uMealTicketFacade;

type
  TFrmAddMealTicket = class(TForm)
    Label1: TLabel;
    edtCheCi: TEdit;
    Label2: TLabel;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    btnOk: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    edtName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtCanQuanA: TEdit;
    edtCanQuanB: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    //��Ա��Ϣ
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_Trainman:RRsTrainman;
    m_MealTicket:TMealTicket;
  private
    { Private declarations }
    //�������
    function CheckInput():Boolean;
    //���ŷ�Ʊ
    procedure FaFangTicket();
  public
    { Public declarations }
    class procedure GiveTicket();
  end;



implementation

uses
  uGlobal, uDutyUser, RsGlobal_TLB;

{$R *.dfm}

procedure TFrmAddMealTicket.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrOk ;
end;

procedure TFrmAddMealTicket.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;
  FaFangTicket;
  Box('���ųɹ�!');
end;

function TFrmAddMealTicket.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtCheCi.Text) = '' then
  begin
    BoxErr('���β���Ϊ��');
    Exit;
  end;

  if Trim(edtName.Text) = '' then
  begin
    BoxErr('���Ų���Ϊ��');
    Exit;
  end;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(edtName.Text,m_Trainman) then
  begin
    BoxErr('����Ĺ���');
    Exit;
  end;

  if Trim(edtCanQuanA.Text) = '' then
  begin
    BoxErr('���ȯ����Ϊ��');
    Exit;
  end;

  if Trim(edtCanQuanB.Text) = '' then
  begin
    BoxErr('����ȯ����Ϊ��');
    Exit;
  end;

  Result := True ;
end;

procedure TFrmAddMealTicket.FormCreate(Sender: TObject);
begin
  dtpTime.Time := Now ;
  dtpDate.Date := Now ;
  edtCanQuanA.Text := '0';
  edtCanQuanB.Text := '3';
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(g_WebAPIUtils);

  m_MealTicket := TMealTicketFactory.CreateTicketSender;
end;

procedure TFrmAddMealTicket.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
  m_MealTicket.Free;
end;

procedure TFrmAddMealTicket.FaFangTicket;
var
  dtRec:TDateTime ;
  iA,iB:integer;
  Ticket: RTicket;
begin
  if not UsesMealTicket   then
    Exit;

  iA := StrToInt(edtCanQuanA.Text);
  iB := StrToInt(edtCanQuanB.Text) ;

  dtRec := AssembleDateTime(dtpDate.Date,dtpTime.Time) ;

  Ticket.tmid := m_Trainman.strTrainmanNumber;
  Ticket.tmName := m_Trainman.strTrainmanName;
  Ticket.userid := GlobalDM.User.Number;
  Ticket.userName := GlobalDM.User.Name;
  Ticket.cc :=  edtCheCi.Text;
  Ticket.dtPaiBan := dtRec;
  Ticket.iA := iA;
  Ticket.iB := iB;

  m_MealTicket.Add(Ticket);
end;

class procedure TFrmAddMealTicket.GiveTicket;
var
  frm : TFrmAddMealTicket ;
begin
  if not TMealCfg.ManualSend[GlobalDM.WorkShop.ID] then
  begin
    Box('û���ֹ�����Ȩ�ޣ�����ϵ���������Ա!');
    Exit;
  end;
  frm := TFrmAddMealTicket.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;


end.
