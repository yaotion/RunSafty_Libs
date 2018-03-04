unit uFrmTicketModify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,utfsystem;

type
  TFrmTicketModify = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtBreakFast: TEdit;
    edtDinner: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure InitData(CanQuanA,CanQuanB,CanQuanC:Integer);
    function CheckInput():Boolean;
  private
     m_nCanQuanA:Integer;
     m_nCanQuanB:Integer;
     m_nCanQuanC:Integer;
  public
    { Public declarations }
    class function GetTicket(var CanQuanA,CanQuanB,CanQuanC:Integer):Boolean;
  end;

var
  FrmTicketModify: TFrmTicketModify;

implementation

{$R *.dfm}

procedure TFrmTicketModify.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmTicketModify.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;

  if not TBox('您确定修改该人员的饭票吗?') then exit;

  m_nCanQuanA := StrToInt(edtBreakFast.Text);
  m_nCanQuanB := StrToInt(edtDinner.Text);
  m_nCanQuanC := 0;

  ModalResult := mrOk ;
end;

function TFrmTicketModify.CheckInput: Boolean;
begin
  Result := True ;
end;

procedure TFrmTicketModify.FormCreate(Sender: TObject);
begin
  edtBreakFast.Text:= '0';
  edtDinner.Text := '2' ;
end;

class function TFrmTicketModify.GetTicket(var CanQuanA, CanQuanB,
  CanQuanC: Integer): Boolean;
var
  frm:TFrmTicketModify;
begin
  Result := False ;
  frm := TFrmTicketModify.Create(nil);
  try
    frm.InitData(CanQuanA, CanQuanB,CanQuanC);
    if frm.ShowModal = mrOk then
    begin
      CanQuanA := frm.m_nCanQuanA ;
      CanQuanB := frm.m_nCanQuanB ;
      CanQuanC := frm.m_nCanQuanC ;
      Result := True ;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmTicketModify.InitData(CanQuanA, CanQuanB, CanQuanC: Integer);
begin
  edtBreakFast.Text := IntToStr(CanQuanA);
  edtDinner.Text := IntToStr(CanQuanB);
end;

end.
