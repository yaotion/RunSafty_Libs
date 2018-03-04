unit uFrmLeaveTypeModify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, ExtCtrls, RzPanel, StdCtrls, uLeaveListInfo,
  uTFSystem, activex;

type
  //�ṩ�ӿڼ���Ƿ���ϵ����ߵ�Ҫ��
  TCheckEvent = procedure(LeaveType: RRsLeaveType; var CheckOK: boolean) of object;

  TFrmLeaveTypeModify = class(TForm)
    RzPanel1: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnOK: TButton;
    edtLeaveName: TLabeledEdit;
    cmbTypeName: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    //����¼�����
    m_CheckEvent: TCheckEvent;
    //��ʱ���������Ϣ
    m_LeaveType: RRsLeaveType;
    //���������������
    m_LeaveClassArray: TRsLeaveClassArray;

    function CheckInput: boolean;
  public
    { Public declarations }
        //�ṩ��ӿڣ���ʾ������͹�����
    class function ShowLeaveTypeModifyForm(var LeaveType: RRsLeaveType;
      LeaveClassArray: TRsLeaveClassArray;
      chkEvent: TCheckEvent): boolean;
    //��ʼ������
    procedure Init(LeaveType: RRsLeaveType;
      LeaveClassArray: TRsLeaveClassArray;
      chkEvent: TCheckEvent);
  end;

implementation

{$R *.dfm}

procedure TFrmLeaveTypeModify.Init(LeaveType: RRsLeaveType;
  LeaveClassArray: TRsLeaveClassArray;
  chkEvent: TCheckEvent);
var
  i: integer;
  len: integer;
begin
    //��������
  m_LeaveType := LeaveType;
  m_LeaveClassArray := LeaveClassArray;
  m_CheckEvent := chkEvent;

    //��ʼ���ؼ�
  len := length(LeaveClassArray);
  for i := 0 to len - 1 do
  begin
    cmbTypeName.Items.Add(LeaveClassArray[i].strClassName);
    if m_LeaveType.strClassName = LeaveClassArray[i].strClassName then
    begin
      cmbTypeName.ItemIndex := i;
    end;

  end;
  edtLeaveName.Text := m_LeaveType.strTypeName;
end;

class function TFrmLeaveTypeModify.ShowLeaveTypeModifyForm(var LeaveType: RRsLeaveType;
  LeaveClassArray: TRsLeaveClassArray;
  chkEvent: TCheckEvent): boolean;
var
  FrmLeaveTypeModify: TFrmLeaveTypeModify;
begin
  result := false;
  FrmLeaveTypeModify := TFrmLeaveTypeModify.Create(nil);
  try
    FrmLeaveTypeModify.Init(LeaveType, LeaveClassArray, chkEvent);
    if FrmLeaveTypeModify.ShowModal = mrCancel then exit;
    LeaveType := FrmLeaveTypeModify.m_LeaveType;
    result := true;
  finally
    FrmLeaveTypeModify.Free;
  end;
end;

procedure TFrmLeaveTypeModify.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TFrmLeaveTypeModify.CheckInput: boolean;
begin
  if trim(edtLeaveName.Text) = '' then
  begin
    result := false;
    Box('�����������û����д!');
    edtLeaveName.SelectAll;
    edtLeaveName.SetFocus;
    exit;
  end;

  if cmbTypeName.Text = '' then
  begin
    result := false;
    Box('�������û��ѡ��!');
    cmbTypeName.SetFocus;
    exit;
  end;

  result := true;

end;

procedure TFrmLeaveTypeModify.btnOKClick(Sender: TObject);
var
  bOK: boolean;
  i: integer;
  len: integer;
begin
    //��֤�����Ƿ�Ϸ�
  if not CheckInput then exit;

  //���ؼ���ֵ��ʱ��������
  m_LeaveType.strTypeName := trim(edtLeaveName.Text);
  m_LeaveType.strClassName := cmbTypeName.Text;

  len := length(m_LeaveClassArray);

  for i := 0 to len - 1 do
  begin
    if m_LeaveType.strClassName = m_LeaveClassArray[i].strClassName then
    begin
      m_LeaveType.nClassID := m_LeaveClassArray[i].nClassID;
      break;
    end;
  end;


  //����Ƿ���ϵ����ߵ�����

  if assigned(m_CheckEvent) then
  begin
    bOK := false;
    m_CheckEvent(m_LeaveType, bOK);
    if not bOK then
    begin
      exit;
    end;
  end;

  ModalResult := mrOK;
end;


end.
