unit uFrmAddMealTicketRule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,uMealTicketRule,utfsystem;

type
  TFrmAddMealTicketRule = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    edtTicketA: TEdit;
    edtTicketB: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtName: TEdit;
    Label2: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_TicketRule:RRsMealTicketRule;
  private
    { Private declarations }
    procedure InitData(TicketRule:RRsMealTicketRule);
    //检查输入条件
    function CheckInput():Boolean;
  public
    { Public declarations }
    class function GetTicketRule(var TicketRule:RRsMealTicketRule):Boolean;
  end;

var
  FrmAddMealTicketRule: TFrmAddMealTicketRule;

implementation

{$R *.dfm}

procedure TFrmAddMealTicketRule.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmAddMealTicketRule.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;
  m_TicketRule.strName := edtName.Text ;
  m_TicketRule.iA := StrToInt(edtTicketA.Text);
  m_TicketRule.iB := StrToInt(edtTicketB.Text);
  ModalResult := mrOk ;
end;

function TFrmAddMealTicketRule.CheckInput: Boolean;
begin
  Result := False ;
  if ( Trim(edtTicketA.Text) = '' ) or ( Trim(edtTicketB.Text) = '' ) then
  begin
    BoxErr('饭票张数不能为空!');
    Exit;
  end;
  Result := True ;
end;

procedure TFrmAddMealTicketRule.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TFrmAddMealTicketRule.FormDestroy(Sender: TObject);
begin
  ;
end;

class function TFrmAddMealTicketRule.GetTicketRule(
  var TicketRule: RRsMealTicketRule): Boolean;
var
  frm : TFrmAddMealTicketRule;
begin
  Result := False ;
  frm := TFrmAddMealTicketRule.Create(nil);
  try
    frm.InitData(TicketRule);
    if frm.ShowModal = mrOk then
    begin
      TicketRule := frm.m_TicketRule ;
      Result := True ;
    end;
  finally
    frm.Free;
  end;

end;

procedure TFrmAddMealTicketRule.InitData(TicketRule: RRsMealTicketRule);
begin
  m_TicketRule := TicketRule ;
  edtTicketA.Text := IntToStr(TicketRule.iA);
  edtTicketB.Text := IntToStr(TicketRule.iB);
  edtName.Text := TicketRule.strName ;
end;

end.
  