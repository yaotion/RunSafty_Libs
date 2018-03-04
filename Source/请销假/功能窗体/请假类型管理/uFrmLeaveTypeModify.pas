unit uFrmLeaveTypeModify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, ExtCtrls, RzPanel, StdCtrls, uLeaveListInfo,
  uTFSystem, activex;

type
  //提供接口检测是否符合调用者的要求
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
    //检查事件对象
    m_CheckEvent: TCheckEvent;
    //临时保存请假信息
    m_LeaveType: RRsLeaveType;
    //用来保存所属类别
    m_LeaveClassArray: TRsLeaveClassArray;

    function CheckInput: boolean;
  public
    { Public declarations }
        //提供类接口，显示请假类型管理窗口
    class function ShowLeaveTypeModifyForm(var LeaveType: RRsLeaveType;
      LeaveClassArray: TRsLeaveClassArray;
      chkEvent: TCheckEvent): boolean;
    //初始化界面
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
    //保存数据
  m_LeaveType := LeaveType;
  m_LeaveClassArray := LeaveClassArray;
  m_CheckEvent := chkEvent;

    //初始化控件
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
    Box('请假类型名称没有填写!');
    edtLeaveName.SelectAll;
    edtLeaveName.SetFocus;
    exit;
  end;

  if cmbTypeName.Text = '' then
  begin
    result := false;
    Box('所属类别没有选择!');
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
    //验证输入是否合法
  if not CheckInput then exit;

  //将控件的值临时保存起来
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


  //检查是否符合调用者的条件

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
