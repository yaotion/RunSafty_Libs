unit uFrmFollowLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, ComCtrls, RzDTP, uLeaveListInfo, uDBLeaveInfo,
  uGlobalDM, DateUtils, Types, uTFSystem, activex, uTrainman,uSaftyEnum,
  Buttons, PngCustomButton,uDBTrainman, AdvDateTimePicker;

type
  TFrmFollowLeave = class(TForm)
    RzPanel1: TRzPanel;
    Bevel1: TBevel;
    Label3: TLabel;
    edtProverID: TEdit;
    Label6: TLabel;
    RzGroupBox3: TRzGroupBox;
    edtAskerID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memoLog: TMemo;
    Label4: TLabel;
    memoLeave: TMemo;
    btnValidNumber: TButton;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label7: TLabel;
    RzPanel3: TRzPanel;
    btnCancel: TButton;
    btnOK: TButton;
    dtpDueTime: TAdvDateTimePicker;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnValidNumberClick(Sender: TObject);
    procedure edtProverIDExit(Sender: TObject);
  private
    { Private declarations }
    //��һ������ָ���¼�
    m_OldFingerTouch : TNotifyEvent;
     //����Ա��Ϣ���ݿ������
    m_DBTrainman : TRsDBTrainman;
    //���ݿ���������
    m_dbLeaveInfo: TRsDBLeaveInfo;
    //��ѯ����ְ���������Ϣ
    m_AskLeave: RRsAskLeave;
    //��ѯ����ְ������ٵ�������ͣ����û�У���Ϊ���ַ���
    m_TypeName: string;
    //���һ�����ٵĽ���ʱ��
    m_FollowEndTime: TDateTime;
   //����ְ����Ϣ�����ţ�������
    m_Trainman: RRsTrainman;
    //���浱ǰְ����Ϣ��ȡ�ķ�ʽ
    m_Verify: TRsRegisterFlag;
    //������׼����Ϣ
    m_ProverPerson: RRsTrainman;
    //������ݵ�����
    function CheckInput: boolean;
    //У����׼���Ƿ�Ϸ�
    function CheckProverID(strProverID: string): boolean;
    //��ѯ���õ���ټ�¼
    procedure GetValidAskLeaveRecord;
     //����ָ����
    procedure OnFingerTouching(Sender: TObject);
  public
    { Public declarations }
    //��ʾ�Ի���
    class function ShowForm : boolean;
  end;
implementation
uses
  ufrmTrainmanIdentity;
{$R *.dfm}

procedure TFrmFollowLeave.GetValidAskLeaveRecord;
var
  bExist: boolean;
  ErrMsg: string;
begin
  if not m_dbLeaveInfo.GetValidAskLeaveInfoByID(m_Trainman.strTrainmanNumber, m_AskLeave, m_TypeName, bExist, ErrMsg) then
  begin
    //��ѯʱ�쳣
    BoxErr(ErrMsg);
    ModalResult := mrOK;
    exit;
  end;

  if not bExist then
  begin
    Box('��ְ�����û��δ���ٵ���ټ�¼�����ܽ������ٲ���!');
    edtAskerID.Text := '';
    exit;
  end;

  if not m_dbLeaveInfo.GetValidFollowLeave(m_AskLeave.strAskLeaveGUID, m_FollowEndTime, bExist, ErrMsg) then
  begin
    //��ѯʱ�쳣
    BoxErr(ErrMsg);
    ModalResult := mrOK;
    exit;
  end;

  if not bExist then
  begin
    m_FollowEndTime := 0;
    memoLeave.Text := Format('����:%s'#13#10'�������:%s'#13#10'��ٿ�ʼʱ��:%s'#13#10'��ٽ���ʱ��:%s'#13#10'������ٵ�Ԥ������ʱ��:%s',
      [m_AskLeave.strTrainManID,
      m_TypeName,
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtBeginTime),
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtEndTime),
        '��ְ��û�����ټ�¼'
        ]);
    dtpDueTime.DateTime := IncDay(m_AskLeave.dtEndTime,1);
  end
  else
  begin
    memoLeave.Text := Format('����:%s'#13#10'�������:%s'#13#10'��ٿ�ʼʱ��:%s'#13#10'��ٽ���ʱ��:%s'#13#10'������ٵ�Ԥ������ʱ��:%s',
      [m_AskLeave.strTrainManID,
      m_TypeName,
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtBeginTime),
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtEndTime),
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_FollowEndTime)
        ]);
    dtpDueTime.DateTime := IncDay(m_AskLeave.dtEndTime,1);
  end;

end;

procedure TFrmFollowLeave.OnFingerTouching(Sender: TObject);
begin
  if not IdentfityTrainman(Sender,m_TrainMan,m_Verify, '','','','') then
  begin
    Application.MessageBox('û���ҵ���Ӧ�ĳ���Ա��Ϣ', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  edtAskerID.Text := Format('%s[%s]',[m_Trainman.strTrainmanName,m_Trainman.strTrainmanNumber]);
  if Trim(edtAskerID.Text) <> '' then
  begin
    GetValidAskLeaveRecord;
  end;
end;

function TFrmFollowLeave.CheckProverID(strProverID: string): boolean;
begin
  result := false;
  if not m_DBTrainman.GetTrainmanByNumber(strProverID,m_ProverPerson) then exit;
  result := true;
end;

procedure TFrmFollowLeave.edtProverIDExit(Sender: TObject);
begin
  if trim(edtProverID.Text) = '' then exit;
  
  if not CheckProverID(trim(edtProverID.Text)) then
  begin
    Box('���������׼�˹��Ų���ȷ!');
    edtProverID.SelectAll;
    edtProverID.SetFocus;
    exit;
  end;  
end;

procedure TFrmFollowLeave.btnOKClick(Sender: TObject);
var
  FollowLeaveDetail: RRsFollowLeaveDetail;
  ErrMsg: string;
begin
  if not CheckInput then exit;
  if not TBox('��ȷ��Ҫ�ǼǴ������ټ�¼��') then exit;
  // ��֤�ɹ�����ʼ��������
  FollowLeaveDetail.strFollowLeaveGUID := NewGUID;
  FollowLeaveDetail.strAskLeaveGUID := m_AskLeave.strAskLeaveGUID;
  FollowLeaveDetail.strMemo := trim(memoLog.Text);
  FollowLeaveDetail.dtEndTime := dtpDueTime.DateTime;
  FollowLeaveDetail.strProverID := m_ProverPerson.strTrainmanNumber;
  FollowLeaveDetail.strProverName := m_ProverPerson.strTrainmanName;
  FollowLeaveDetail.dtCreateTime := Now;
  FollowLeaveDetail.strDutyUserID := GlobalDM.DutyUser.strDutyGUID;
  FollowLeaveDetail.strDutyUserName := GlobalDM.DutyUser.strDutyName;
  FollowLeaveDetail.strSiteID := GlobalDM.SiteInfo.strSiteGUID;
  FollowLeaveDetail.strSiteName := GlobalDM.SiteInfo.strSiteName;
  FollowLeaveDetail.Verify := m_Verify;

  GlobalDM.ADOConnection.BeginTrans;
  try
    if not m_dbLeaveInfo.AddFollowLeaveDetail(FollowLeaveDetail, ErrMsg) then
    begin
      GlobalDM.ADOConnection.RollbackTrans;
      BoxErr('����ʧ��:' + ErrMsg);
      exit;
    end;

    GlobalDM.ADOConnection.CommitTrans;
    Box('���ٳɹ�!');
    ModalResult := mrOK;
  except on e : exception  do
    begin
      GlobalDM.ADOConnection.RollbackTrans;
      Box('����ʧ��:' + e.Message);
    end;
  end;
end;

procedure TFrmFollowLeave.btnValidNumberClick(Sender: TObject);
begin
  if not IdentfityTrainman(nil,m_Trainman,m_Verify,'','','','') then  exit;
  edtAskerID.Text := Format('%s[%s]',[m_Trainman.strTrainmanName,m_Trainman.strTrainmanNumber]);
  edtAskerID.Text := m_Trainman.strTrainmanName;
  if Trim(edtAskerID.Text) <> '' then
  begin
    GetValidAskLeaveRecord;
  end;
end;

function TFrmFollowLeave.CheckInput: boolean;
var
  dateShip: TValueRelationship;
  dtTemp: TDateTime;
begin
  result := false;
  if trim(edtAskerID.Text) = '' then
  begin
    Box('��û��ָ��������!');
    exit;
  end;

  if memoLeave.Text = '' then
  begin
    Box('�Ҳ�����ְ����Ч����ټ�¼!');
    exit;
  end;

  if trim(edtProverID.Text) = '' then
  begin
    Box('��û��������׼�˹���!');
    edtProverID.SetFocus;
    exit;
  end;

  if not CheckProverID(trim(edtProverID.Text)) then
  begin
    Box('���������׼�˹��Ų���ȷ!');
    edtProverID.SelectAll;
    edtProverID.SetFocus;
    exit;
  end;

  if m_FollowEndTime = 0 then
  begin
    dtTemp := m_AskLeave.dtEndTime;
  end
  else
  begin
    dtTemp := m_FollowEndTime;
  end;

  dateShip := CompareDate(dtpDueTime.DateTime, DateOf(dtTemp));
  if dateShip = LessThanValue then
  begin
    Box('Ԥ������ʱ�����õĲ���ȷ��������һ�����������!');
    dtpDueTime.SetFocus;
    exit;
  end;

  if length(trim(memoLog.Text)) > 200 then
  begin
    Box('��ע����󳤶�Ϊ200!');
    memoLog.SelectAll;
    memoLog.SetFocus;
    exit;
  end;
  result := true;
end;

class function TFrmFollowLeave.ShowForm : boolean;
var
  frmForm: TFrmFollowLeave;
begin
  result := false;
  frmForm := TFrmFollowLeave.Create(nil);
  try
    if frmForm.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmForm.Free;
  end;
end;

procedure TFrmFollowLeave.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmFollowLeave.FormCreate(Sender: TObject);
begin
  m_dbLeaveInfo := TRsDBLeaveInfo.Create(GlobalDM.ADOConnection);
  m_DBTrainman := TRsDBTrainman.Create(GlobalDM.ADOConnection);
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;
end;

procedure TFrmFollowLeave.FormDestroy(Sender: TObject);
begin
  m_dbLeaveInfo.Free;
  m_DBTrainman.Free;
  GlobalDM.OnFingerTouching := m_OldFingerTouch;
end;

end.
