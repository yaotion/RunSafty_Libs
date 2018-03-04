unit uFrmCancelLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, ComCtrls, RzDTP, uLeaveListInfo, 
  DateUtils, Types, uTFSystem, activex, uTrainman,uSaftyEnum,
  Buttons, PngCustomButton, AdvDateTimePicker, utfLookupEdit, utfPopTypes,
  uLCTrainmanMgr,uLCAskLeave,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmCancelLeave = class(TForm)
    RzPanel1: TRzPanel;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    memoLeave: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label7: TLabel;
    RzPanel3: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    dtpDueTime: TAdvDateTimePicker;
    edtAskerID: TtfLookupEdit;
    edtProverID: TtfLookupEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtAskerIDExit(Sender: TObject);
    procedure edtAskerIDChange(Sender: TObject);
    procedure edtAskerIDSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtProverIDExit(Sender: TObject);
    procedure edtProverIDSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtProverIDChange(Sender: TObject);
    procedure edtAskerIDNextPage(Sender: TObject);
    procedure edtAskerIDPrevPage(Sender: TObject);
    procedure edtProverIDNextPage(Sender: TObject);
    procedure edtProverIDPrevPage(Sender: TObject);

  private
    { Private declarations }
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCAskLeave: TRsLCAskLeave;
    //保存查出来的请假记录
    m_AskLeave: RRsAskLeave;
    //保存查出来的请假记录的请假类型
    m_TypeName: string;
    //保存职工信息，工号，姓名等
    m_Trainman: RRsTrainman;
    m_Prover: RRsTrainman;
    //保存当前职工信息获取的方式
    m_Verify: TRsRegisterFlag;
    //保存批准人信息
    //m_ProverPerson: RRsTrainman;
    //校验批准人是否合法
    function CheckAskerID(strAskerID: string): boolean;
    //查询可用的请假记录
    procedure GetValidAskLeaveRecord;
    //检查数据的输入
    function CheckInput: boolean;
    //初始司机选择下拉框
    procedure IniColumns(LookupEdit : TtfLookupEdit);
    //根据司机信息（如张三[1022]），提取司机工号
    function GetAskerID(strAsker: string): string;
    function CheckProverID(strTrainmanNumber: string): Boolean;  
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
    //
    procedure InitCancelLeaveInfo(TrainmanNumber:string);
    procedure init;
  public
    { Public declarations }

    class function ShowCancelLeaveForm(TrainmanNumber:string):Boolean;
  end;

implementation

uses uGlobal;
{$R *.dfm}

procedure TFrmCancelLeave.GetValidAskLeaveRecord;
var
  bExist: boolean;
  ErrMsg: string;
begin
  if not m_RsLCAskLeave.GetValidAskLeaveInfoByID(m_Trainman.strTrainmanNumber, m_AskLeave, m_TypeName, bExist, ErrMsg) then
  begin
    //查询时异常
    BoxErr(ErrMsg);
    ModalResult := mrOK;
    exit;
  end;

  if not bExist then
  begin
    Box('该职工最近没有未销假的请假记录，不能进行销假操作!');
    edtAskerID.Text := '';
    edtAskerID.SetFocus;
    exit;
  end;

  memoLeave.Text := Format('工号:%s'#13#10#13#10'请假类型:%s'#13#10#13#10'请假时间:%s',
    [
      m_AskLeave.strTrainManID,
      m_TypeName,
      FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeave.dtBeginTime)
      ]);
  dtpDueTime.DateTime := now;
end;

function TFrmCancelLeave.CheckAskerID(strAskerID: string): boolean;
begin
  result := false;
  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strAskerID,m_Trainman) then exit;
  result := true;
end;
        
procedure TFrmCancelLeave.edtAskerIDExit(Sender: TObject);
begin
  if trim(edtAskerID.Text) = '' then exit;
  
  if not CheckAskerID(GetAskerID(edtAskerID.Text)) then
  begin
    Box('您输入的销假人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;

  GetValidAskLeaveRecord;
end;

procedure TFrmCancelLeave.edtAskerIDNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtAskerID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtAskerIDPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtAskerID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtAskerIDChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtAskerID do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtAskerIDSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtAskerID.OnChange := nil;
  try
   edtAskerID.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtAskerID.OnChange := edtAskerIDChange;
  end;
end;

procedure TFrmCancelLeave.edtProverIDChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtProverIDExit(Sender: TObject);
begin
  if trim(edtProverID.Text) = '' then exit;

  if not CheckProverID(GetAskerID(edtProverID.Text)) then
  begin
    Box('您输入的批准人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;
end;

procedure TFrmCancelLeave.edtProverIDNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtProverIDPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmCancelLeave.edtProverIDSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtProverID.OnChange := nil;
  try
   edtProverID.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtProverID.OnChange := edtProverIDChange;
  end
end;

procedure TFrmCancelLeave.btnOKClick(Sender: TObject);
var
  CancelLeaveDetail: RRsCancelLeaveDetail;
  ErrMsg: string;
begin
  if not CheckInput then exit;
                                 
  //验证该职工是否是本车间人员
  if m_Trainman.strWorkShopGUID <> GlobalDM.WorkShop.ID then
  begin
    Box('该职工非本车间人员，不能办理销假!');
    exit;
  end;

  if not TBox('您确定要登记此条销假记录吗？') then exit;
  
  // 验证成功，则开始保存数据
  CancelLeaveDetail.strCancelLeaveGUID := NewGUID;
  CancelLeaveDetail.strAskLeaveGUID := m_AskLeave.strAskLeaveGUID;
  CancelLeaveDetail.strTrainmanID := m_Trainman.strTrainmanNumber;
  CancelLeaveDetail.strProverID := m_Prover.strTrainmanNumber;
  CancelLeaveDetail.strProverName := m_Prover.strTrainmanName;
  CancelLeaveDetail.dtCreateTime := Now;
  CancelLeaveDetail.dtCancelTime := dtpDueTime.DateTime;
  CancelLeaveDetail.strDutyUserID := GlobalDM.User.ID;
  CancelLeaveDetail.strDutyUserName := GlobalDM.User.Name;
  CancelLeaveDetail.strSiteID := GlobalDM.Site.ID;
  CancelLeaveDetail.strSiteName := GlobalDM.Site.Name;
  CancelLeaveDetail.Verify := m_Verify;
  try
    if not m_RsLCAskLeave.AddCancelLeaveDetail(CancelLeaveDetail, ErrMsg) then
    begin
      BoxErr('销假失败：' + ErrMsg);
      exit;
    end;
    Box('销假成功!');


    ModalResult := mrOK;
  except on e : exception do
    begin
      Box('销假失败:' + e.Message);
    end;
  end;
end;

function TFrmCancelLeave.CheckInput: boolean;
begin
  result := false;
  if trim(edtAskerID.Text) = '' then
  begin
    Box('您没有输入销假人!');
    edtAskerID.SetFocus;
    exit;
  end;

  if not CheckAskerID(GetAskerID(edtAskerID.Text)) then
  begin
    Box('您输入的销假人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;

  if memoLeave.Text = '' then
  begin
    Box('找不到该职工有效的请假记录!');
    exit;
  end;

  result := true;
end;

function TFrmCancelLeave.CheckProverID(strTrainmanNumber: string): Boolean;
begin
  result := false;
  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,m_Prover) then exit;
  result := true;
end;

class function TFrmCancelLeave.ShowCancelLeaveForm(
  TrainmanNumber: string): Boolean;
var
  frmForm: TFrmCancelLeave;
begin
  result := false;
  frmForm := TFrmCancelLeave.Create(nil);
  try
    frmForm.init;
    frmForm.InitCancelLeaveInfo(TrainmanNumber);
    if frmForm.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmForm.Free;
  end;
end;



procedure TFrmCancelLeave.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmCancelLeave.FormDestroy(Sender: TObject);
begin
  m_RsLCAskLeave.Free;
  m_RsLCTrainmanMgr.Free;
end;

procedure TFrmCancelLeave.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
end;

procedure TFrmCancelLeave.IniColumns(LookupEdit: TtfLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '序号';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '工号';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '姓名';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '职务';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '客货';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '关键人';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := 'ABCD';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '联系电话';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '状态';
  col.Width := 80;
end;

procedure TFrmCancelLeave.init;
begin


  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(g_WebAPIUtils);
  m_RsLCAskLeave := TRsLCAskLeave.Create(g_WebAPIUtils);
  IniColumns(edtAskerID);
  IniColumns(edtProverID);
end;

procedure TFrmCancelLeave.InitCancelLeaveInfo(TrainmanNumber: string);
begin
  edtAskerID.OnChange := nil;
  edtAskerID.Text := TrainmanNumber ;
  edtAskerID.OnChange := edtAskerIDChange;
end;

function TFrmCancelLeave.GetAskerID(strAsker: string): string;
var
  intPos1, intPos2: integer;
begin
  strAsker := trim(strAsker);                
  result := strAsker;
  
  intPos1 := Pos('[', strAsker);
  intPos2 := Pos(']', strAsker);
  if (intPos1 > 0) and (intPos2 > intPos1) then
    result := Copy(strAsker, intPos1+1, intPos2-intPos1-1);
end;

procedure TFrmCancelLeave.SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(TrainmanArray) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := TrainmanArray[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(TrainmanArray[i].strTrainmanNumber);
    item.SubItems.Add(TrainmanArray[i].strTrainmanName);
    item.SubItems.Add(TRsPostNameAry[TrainmanArray[i].nPostID]);
    item.SubItems.Add(TRsKeHuoNameArray[TrainmanArray[i].nKehuoID]);
    if TrainmanArray[i].bIsKey > 0 then
    begin
      item.SubItems.Add('是');
    end else begin
      item.SubItems.Add('');
    end;
    item.SubItems.Add(TrainmanArray[i].strABCD);
    item.SubItems.Add(TrainmanArray[i].strMobileNumber);
    item.SubItems.Add(TRsTrainmanStateNameAry[TrainmanArray[i].nTrainmanState]);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);
end;

end.
