unit uFrmLeaveQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, Buttons, PngCustomButton, ComCtrls,
  Grids, AdvObj, BaseGrid, AdvGrid, RzDTP, PngSpeedButton, 
  uLeaveListInfo,  uTFSystem, uFrmAskLeaveDetail, RzCmboBx, ComObj,
  Mask, RzEdit, uTrainman, uGuideGroup, RzButton, RzRadChk,
  uLCAskLeave,uLCTeamGuide,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmLeaveQuery = class(TForm)
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    statusMain: TStatusBar;
    dtpBeginDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    Label2: TLabel;
    btnQuery: TPngSpeedButton;          
    btnViewDetail: TPngSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    cmbType: TRzComboBox;
    cmbStatus: TRzComboBox;
    Label6: TLabel;
    RzPanel1: TRzPanel;
    btnExit: TPngSpeedButton;
    btnQingMgr: TPngSpeedButton;
    btnXiaoMgr: TPngSpeedButton;
    Panel1: TPanel;
    Panel4: TPanel;
    btnExport: TPngSpeedButton;
    strGridLeaveInfo: TAdvStringGrid;
    OpenDialog1: TOpenDialog;
    edtNumber: TRzEdit;
    Label1: TLabel;
    cmbPost: TRzComboBox;
    Label7: TLabel;
    cmbGroup: TRzComboBox;
    checkDataRange: TRzCheckBox;
    cbkShowAllUnEnd: TRzCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnViewDetailClick(Sender: TObject);
    procedure btnQingMgrClick(Sender: TObject);
    procedure btnXiaoMgrClick(Sender: TObject);
    procedure strGridLeaveInfoGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure btnExitClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure strGridLeaveInfoDblClick(Sender: TObject);
    procedure cmbGroupChange(Sender: TObject);
    procedure checkDataRangeClick(Sender: TObject);
  private
    { Private declarations }
    m_bEditEnabled : boolean;
    m_RsLCAskLeave: TRsLCAskLeave;
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //初始化界面
    procedure Init;
    //查询请假信息
    procedure QueryLeaveInfo; 
    //导出请假信息
    procedure ExportLeaveInfo;
    //获取当前选中的请假信息
    function GetSelectRowIndex(out rowIndex: integer): boolean;
    //设置日期范围的初始值及是否可用
    procedure SetDateRange();
  public
    { Public declarations }
    //提供类接口，显示请假类型管理窗口
    class procedure ShowForm(EditEnabled : boolean = true);
  end;

implementation
uses
  DateUtils,uFrmAskLeave,uFrmCancelLeave,uGuideSign, uDialogsLib, uGlobal;
{$R *.dfm}

procedure TFrmLeaveQuery.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLeaveQuery.btnExportClick(Sender: TObject);
begin
  ExportLeaveInfo;
end;

procedure TFrmLeaveQuery.btnQingMgrClick(Sender: TObject);
begin
  if not TFrmAskLeave.ShowAskLeaveFormByNumber('') then exit;
  QueryLeaveInfo;
end;

procedure TFrmLeaveQuery.btnQueryClick(Sender: TObject);
begin
  edtNumber.SetFocus;
  QueryLeaveInfo;
end;

procedure TFrmLeaveQuery.btnViewDetailClick(Sender: TObject);
var
  iRow: integer;
begin
  if not GetSelectRowIndex(iRow) then
  begin
    Box('您没有选中有效记录!');
    exit;
  end;

  TFrmAskLeaveDetail.ShowForm(strGridLeaveInfo.Cells[999, iRow], strGridLeaveInfo.Cells[3, iRow], strGridLeaveInfo.Cells[1, iRow], strGridLeaveInfo.Cells[2, iRow]);
end;

procedure TFrmLeaveQuery.btnXiaoMgrClick(Sender: TObject);
var
  iRow: integer;
  strTrainmanNumber, strTrainmanName: string;
begin
  if GetSelectRowIndex(iRow) then
  begin
    strTrainmanNumber := strGridLeaveInfo.Cells[1, iRow];  
    strTrainmanName := strGridLeaveInfo.Cells[2, iRow];
  end;

  if not TFrmCancelLeave.ShowCancelLeaveForm('') then exit;
  QueryLeaveInfo;
end;

procedure TFrmLeaveQuery.checkDataRangeClick(Sender: TObject);
begin
  SetDateRange;
end;

procedure TFrmLeaveQuery.cmbGroupChange(Sender: TObject);
begin
  QueryLeaveInfo;
end;

function TFrmLeaveQuery.GetSelectRowIndex(out rowIndex: integer): boolean;
begin
  result := false;
  if (strGridLeaveInfo.Row = 0) or (strGridLeaveInfo.Row = strGridLeaveInfo.RowCount - 1) then exit;
  rowIndex := strGridLeaveInfo.Row;
  result := true;
end;

procedure TFrmLeaveQuery.FormDestroy(Sender: TObject);
begin
  m_RsLCAskLeave.Free;
  m_RsLCGuideGroup.Free;
end;

procedure TFrmLeaveQuery.Init;
var
  i: integer;
  LeaveTypeArray: TRsLeaveTypeArray;
  GuideGroupArray : TRsSimpleInfoArray;
  ErrMsg : string;
begin
  m_RsLCAskLeave := TRsLCAskLeave.Create(g_WebAPIUtils);
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(g_WebAPIUtils);

  dtpBeginDate.DateTime := DateUtils.StartOfTheMonth(Now);
  dtpEndDate.DateTime := DateUtils.EndOfTheMonth(Now);
  //载入请假类型列表
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('查询请假类型列表失败:' + ErrMsg);
    exit;
  end;

  cmbType.Items.Clear;
  cmbType.Values.Clear;
  cmbType.AddItemValue('全部','');
  for i := 0 to length(LeaveTypeArray) - 1 do
  begin
    cmbType.AddItemValue(LeaveTypeArray[i].strTypeName,LeaveTypeArray[i].strTypeGUID);
  end;
  cmbType.ItemIndex := 0;

  cmbStatus.Items.Clear;
  cmbStatus.Values.Clear;
  cmbStatus.AddItemValue('全部','');
  cmbStatus.AddItemValue('请假','1');
  cmbStatus.AddItemValue('销假','3');
  cmbStatus.AddItemValue('撤销','10000');
  cmbStatus.ItemIndex := 1;

  cmbPost.Items.Clear;
  cmbPost.Values.Clear;
  cmbPost.AddItemValue('全部','');
  cmbPost.AddItemValue('司机','1');
  cmbPost.AddItemValue('副司机','2');
  cmbPost.AddItemValue('学员','3');
  cmbPost.ItemIndex := 0;

  //添加指导队信息
  m_RsLCGuideGroup.GetGroupArray(GlobalDM.WorkShop.ID, GuideGroupArray);
  cmbGroup.Items.Clear;
  cmbGroup.Values.Clear;
  cmbGroup.AddItemValue('全部','');
  for i := 0 to length(GuideGroupArray) - 1 do
  begin
    cmbGroup.AddItemValue(GuideGroupArray[i].strName, GuideGroupArray[i].strGUID);
  end;
  cmbGroup.ItemIndex := 0;

  SetDateRange;
  btnQingMgr.Enabled := m_bEditEnabled;
  btnXiaoMgr.Enabled := m_bEditEnabled;
  QueryLeaveInfo;
end;

procedure TFrmLeaveQuery.SetDateRange;
begin
  dtpBeginDate.Enabled := checkDataRange.Checked;
  dtpEndDate.Enabled := checkDataRange.Checked;
end;

class procedure TFrmLeaveQuery.ShowForm(EditEnabled : boolean = true);
var
  FrmLeaveQuery: TFrmLeaveQuery;
begin
  FrmLeaveQuery := TFrmLeaveQuery.Create(nil);
  FrmLeaveQuery.m_bEditEnabled :=  EditEnabled;
  FrmLeaveQuery.Init();
  FrmLeaveQuery.ShowModal;
  FrmLeaveQuery.Free;
end;

procedure TFrmLeaveQuery.strGridLeaveInfoDblClick(Sender: TObject);
begin
  btnViewDetail.Click;
end;

procedure TFrmLeaveQuery.strGridLeaveInfoGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
  begin
    HAlign := taCenter;
  end
  else
  begin
    if ACol <> 9 then HAlign := taCenter;
  end;
end;

procedure TFrmLeaveQuery.QueryLeaveInfo;
var
  i: integer;
  strBeginDateTime: string;
  strDueDateTime: string;
  askLeaveWithTypeArray: TRsAskLeaveWithTypeArray;
begin
  try
    strBeginDateTime := '';
    strDueDateTime := '';
    if checkDataRange.Checked then
    begin
      strBeginDateTime := FormatDateTime('YYYY-MM-DD 00:00:00', DateOf(dtpBeginDate.DateTime));
      strDueDateTime := FormatDateTime('YYYY-MM-DD 23:59:59', DateOf(dtpEndDate.DateTime));
    end;
    m_RsLCAskLeave.GetLeaves(strBeginDateTime,strDueDateTime,trim(edtNumber.Text),cmbType.Values[cmbType.itemindex],
      cmbStatus.Values[cmbStatus.itemindex], GlobalDM.WorkShop.ID, cmbPost.Values[cmbPost.itemindex],
      cmbGroup.Values[cmbGroup.itemindex],cbkShowAllUnEnd.Checked,askLeaveWithTypeArray);
    with strGridLeaveInfo do
    begin
      ClearRows(1, RowCount - 1);
      RowCount := length(askLeaveWithTypeArray) + 2;
      statusMain.Panels[0].Text := Format('共查询出%d条数据', [RowCount - 2]);
      for i := 0 to length(askLeaveWithTypeArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);
        Cells[1, i + 1] := askLeaveWithTypeArray[i].AskLeave.strTrainManID;
        Cells[2, i + 1] := askLeaveWithTypeArray[i].AskLeave.strTrainmanName;
        Cells[3, i + 1] := askLeaveWithTypeArray[i].strTypeName;
        Cells[4, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',askLeaveWithTypeArray[i].AskLeave.dtBeginTime);
        if askLeaveWithTypeArray[i].AskLeave.dtEndTime > INCYEAR(Now,-30) then
          Cells[5, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',askLeaveWithTypeArray[i].AskLeave.dtEndTime);

        case askLeaveWithTypeArray[i].AskLeave.nStatus of
          1: Cells[6, i + 1] := '请假中';
          2: Cells[6, i + 1] := '续假中'; //暂未使用
          3: Cells[6, i + 1] := '已销假';
          10000: Cells[6, i + 1] := '已撤销';
        end;

        Cells[7, i + 1] := Format('%s[%.4s]', [askLeaveWithTypeArray[i].AskLeave.strAskProverName,
          askLeaveWithTypeArray[i].AskLeave.strAskProverID]);
        Cells[8, i + 1] := askLeaveWithTypeArray[i].AskLeave.strAskDutyUserName;
        Cells[9, i + 1] := askLeaveWithTypeArray[i].AskLeave.strMemo;
        Cells[10, i + 1] := TRsPostNameAry[askLeaveWithTypeArray[i].AskLeave.nPostID];
        Cells[11, i + 1] := askLeaveWithTypeArray[i].AskLeave.strGuideGroupName;

        Cells[999, i + 1] := askLeaveWithTypeArray[i].AskLeave.strAskLeaveGUID;
      end;
    end;
  except on e : exception do
    begin
      Box('查询信息失败:' + e.Message);
    end;
  end;
end;

procedure TFrmLeaveQuery.ExportLeaveInfo;
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
  NoFocusProgress: TNoFocusProgress;
begin
  if strGridLeaveInfo.RowCount <= 1 then
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;
  if (strGridLeaveInfo.RowCount = 2) and (strGridLeaveInfo.Cells[999, 1] = '') then 
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;

  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  NoFocusProgress := TNoFocusProgress.Create;
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
      excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;

    m_nIndex := 1;
    excelApp.Cells[m_nIndex,1].Value := '工号';
    excelApp.Cells[m_nIndex,2].Value := '姓名';
    excelApp.Cells[m_nIndex,3].Value := '请假类型';
    excelApp.Cells[m_nIndex,4].Value := '请假开始时间';
    excelApp.Cells[m_nIndex,5].Value := '请假结束时间';
    excelApp.Cells[m_nIndex,6].Value := '当前状态';  
    excelApp.Cells[m_nIndex,7].Value := '请假批准人';
    excelApp.Cells[m_nIndex,8].Value := '操作员';
    excelApp.Cells[m_nIndex,9].Value := '备注信息';   
    excelApp.Cells[m_nIndex,10].Value := '职位';
    excelApp.Cells[m_nIndex,11].Value := '指导队';
    
    Inc(m_nIndex);
    for i := 1 to strGridLeaveInfo.RowCount - 1 do
    begin
      if strGridLeaveInfo.Cells[999, i] <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := strGridLeaveInfo.Cells[1, i];
        excelApp.Cells[m_nIndex,2].Value := strGridLeaveInfo.Cells[2, i];
        excelApp.Cells[m_nIndex,3].Value := strGridLeaveInfo.Cells[3, i];
        excelApp.Cells[m_nIndex,4].Value := strGridLeaveInfo.Cells[4, i];
        excelApp.Cells[m_nIndex,5].Value := strGridLeaveInfo.Cells[5, i];
        excelApp.Cells[m_nIndex,6].Value := strGridLeaveInfo.Cells[6, i];  
        excelApp.Cells[m_nIndex,7].Value := strGridLeaveInfo.Cells[7, i];
        excelApp.Cells[m_nIndex,8].Value := strGridLeaveInfo.Cells[8, i];
        excelApp.Cells[m_nIndex,9].Value := strGridLeaveInfo.Cells[9, i];  
        excelApp.Cells[m_nIndex,10].Value := strGridLeaveInfo.Cells[10, i];
        excelApp.Cells[m_nIndex,11].Value := strGridLeaveInfo.Cells[11, i];
      end;
      NoFocusProgress.Step(i,strGridLeaveInfo.RowCount-1,'正在导出请假信息，请稍后');
      Inc(m_nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    NoFocusProgress.Free;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Box('导出完毕！');
end;

end.

