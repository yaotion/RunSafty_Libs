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
    //上一个调用指纹事件
    m_OldFingerTouch : TNotifyEvent;
     //乘务员信息数据库操作累
    m_DBTrainman : TRsDBTrainman;
    //数据库操作类对象
    m_dbLeaveInfo: TRsDBLeaveInfo;
    //查询到的职工的请假信息
    m_AskLeave: RRsAskLeave;
    //查询到的职工的请假的请假类型，如果没有，则为空字符串
    m_TypeName: string;
    //最后一次续假的结束时间
    m_FollowEndTime: TDateTime;
   //保存职工信息，工号，姓名等
    m_Trainman: RRsTrainman;
    //保存当前职工信息获取的方式
    m_Verify: TRsRegisterFlag;
    //保存批准人信息
    m_ProverPerson: RRsTrainman;
    //检查数据的输入
    function CheckInput: boolean;
    //校验批准人是否合法
    function CheckProverID(strProverID: string): boolean;
    //查询可用的请假记录
    procedure GetValidAskLeaveRecord;
     //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
  public
    { Public declarations }
    //显示对话框
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
    //查询时异常
    BoxErr(ErrMsg);
    ModalResult := mrOK;
    exit;
  end;

  if not bExist then
  begin
    Box('该职工最近没有未销假的请假记录，不能进行续假操作!');
    edtAskerID.Text := '';
    exit;
  end;

  if not m_dbLeaveInfo.GetValidFollowLeave(m_AskLeave.strAskLeaveGUID, m_FollowEndTime, bExist, ErrMsg) then
  begin
    //查询时异常
    BoxErr(ErrMsg);
    ModalResult := mrOK;
    exit;
  end;

  if not bExist then
  begin
    m_FollowEndTime := 0;
    memoLeave.Text := Format('工号:%s'#13#10'请假类型:%s'#13#10'请假开始时间:%s'#13#10'请假结束时间:%s'#13#10'最近续假的预计销假时间:%s',
      [m_AskLeave.strTrainManID,
      m_TypeName,
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtBeginTime),
        FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtEndTime),
        '该职工没有续假记录'
        ]);
    dtpDueTime.DateTime := IncDay(m_AskLeave.dtEndTime,1);
  end
  else
  begin
    memoLeave.Text := Format('工号:%s'#13#10'请假类型:%s'#13#10'请假开始时间:%s'#13#10'请假结束时间:%s'#13#10'最近续假的预计销假时间:%s',
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
    Application.MessageBox('没有找到相应的乘务员信息', '提示', MB_OK + MB_ICONINFORMATION);
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
    Box('您输入的批准人工号不正确!');
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
  if not TBox('您确定要登记此条销假记录吗？') then exit;
  // 验证成功，则开始保存数据
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
      BoxErr('续假失败:' + ErrMsg);
      exit;
    end;

    GlobalDM.ADOConnection.CommitTrans;
    Box('续假成功!');
    ModalResult := mrOK;
  except on e : exception  do
    begin
      GlobalDM.ADOConnection.RollbackTrans;
      Box('续假失败:' + e.Message);
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
    Box('您没有指定续假人!');
    exit;
  end;

  if memoLeave.Text = '' then
  begin
    Box('找不到该职工有效的请假记录!');
    exit;
  end;

  if trim(edtProverID.Text) = '' then
  begin
    Box('您没有输入批准人工号!');
    edtProverID.SetFocus;
    exit;
  end;

  if not CheckProverID(trim(edtProverID.Text)) then
  begin
    Box('您输入的批准人工号不正确!');
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
    Box('预计销假时间设置的不正确，请设置一个较晚的日期!');
    dtpDueTime.SetFocus;
    exit;
  end;

  if length(trim(memoLog.Text)) > 200 then
  begin
    Box('备注的最大长度为200!');
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
