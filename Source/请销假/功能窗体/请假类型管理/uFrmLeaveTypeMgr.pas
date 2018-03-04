unit uFrmLeaveTypeMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, RzPanel, Buttons, PngCustomButton, StdCtrls,
  PngSpeedButton, Grids, AdvObj, BaseGrid, AdvGrid, uLeaveListInfo,
  uFrmLeaveTypeModify, uTFSystem, activex,uLCAskLeave,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmLeaveTypeMgr = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    statusMain: TStatusBar;
    edtLeaveName: TLabeledEdit;
    strGridLeaveInfo: TAdvStringGrid;
    PngCustomButton1: TPngCustomButton;
    btnQuery: TPngSpeedButton;
    btnAdd: TPngSpeedButton;
    btnEdit: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    Label1: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);

  private
    { Private declarations }
    //数据库操作类对象
    m_RsLCAskLeave: TRsLCAskLeave;
    //查询假期信息
    procedure QueryLeaveInfo;
    //通过指定名字查询
    procedure QueryLeaveInfoByName(strLeaveName: string);
    //得到用户选中行的请假类型ID
    function GetSelectedLeaveID(out LeaveID: string): boolean;
    // 得到选中行的请假类型名称
    function GetSelectedLeaveName(out strLeaveName: string): boolean;
    procedure CheckAfterAdd(LeaveType: RRsLeaveType; var CheckOK: boolean);
    procedure CheckAfterEdit(LeaveType: RRsLeaveType; var CheckOK: boolean);
            //获取一个GUID字符串
    function GetGuid: string;
  public
    { Public declarations }
    //提供类接口，显示请假类型管理窗口
    class procedure ShowLeaveTypeMgrForm();
    //初始化界面
    procedure Init;
  end;

implementation

uses uGlobal;

{$R *.dfm}

function TFrmLeaveTypeMgr.GetGuid: string;
var
  ID: TGuid;
begin
  if CoCreateGuid(ID) = s_OK then
  begin
    result := GUIDToString(ID);
  end
  else
  begin
    result := '';
  end;

end;

class procedure TFrmLeaveTypeMgr.ShowLeaveTypeMgrForm();
var
  FrmLeaveTypeMgr: TFrmLeaveTypeMgr;
begin
  FrmLeaveTypeMgr := TFrmLeaveTypeMgr.Create(nil);
  FrmLeaveTypeMgr.Init;
  FrmLeaveTypeMgr.ShowModal;
  FrmLeaveTypeMgr.Free;
end;

function TFrmLeaveTypeMgr.GetSelectedLeaveID(out LeaveID: string): boolean;
begin
  result := false;
  if (strGridLeaveInfo.Row = 0) or (strGridLeaveInfo.Row = strGridLeaveInfo.RowCount - 1) then exit;
  LeaveID := strGridLeaveInfo.Cells[999, strGridLeaveInfo.Row];
  if Trim(LeaveID) = '' then exit;
  result := true;
end;

function TFrmLeaveTypeMgr.GetSelectedLeaveName(out strLeaveName: string): boolean;
begin
  result := false;
  if (strGridLeaveInfo.Row = 0) or (strGridLeaveInfo.Row = strGridLeaveInfo.RowCount - 1) then exit;
  strLeaveName := strGridLeaveInfo.Cells[1, strGridLeaveInfo.Row];
  if Trim(strLeaveName) = '' then exit;
  result := true;
end;

procedure TFrmLeaveTypeMgr.btnAddClick(Sender: TObject);
var
  LeaveType: RRsLeaveType;
  LeaveClassArray: TRsLeaveClassArray;
  ErrMsg: string;
begin

  LeaveType.strTypeGUID := GetGuid;
  if LeaveType.strTypeGUID = '' then
  begin
    BoxErr('获取GUID失败!');
    exit;
  end;


  //获取下拉列表框中数据
  if not m_RsLCAskLeave.LCLeaveType.GetLeaveClasses(LeaveClassArray, ErrMsg) then
  begin
    BoxErr('查询请假所属类别失败:' + ErrMsg);
    exit;
  end;

  //显示添加界面
  if not TFrmLeaveTypeModify.ShowLeaveTypeModifyForm(LeaveType, LeaveClassArray, CheckAfterAdd) then exit;



  //写数据库
  if not m_RsLCAskLeave.LCLeaveType.AddLeaveType(LeaveType, ErrMsg) then
  begin
    BoxErr('添加请假类型时失败:' + ErrMsg);
  end
  else
  begin
    //重新查询
    QueryLeaveInfo;
  end;
end;

procedure TFrmLeaveTypeMgr.CheckAfterAdd(LeaveType: RRsLeaveType; var CheckOK: boolean);
begin
  CheckOk := false;
  try

    if not m_RsLCAskLeave.LCLeaveType.ExistLeaveType(LeaveType) then
    begin
      CheckOk := true;
      exit;
    end
    else
    begin
      Box('该请假类型已存在，不允许重复添加!');
      exit;
    end;
  except
    on e: Exception do
    begin
      BoxErr('判断请假类型是否存在时失败：' + e.Message);
      exit;
    end;
  end;
end;

procedure TFrmLeaveTypeMgr.CheckAfterEdit(LeaveType: RRsLeaveType; var CheckOK: boolean);
begin
  CheckOk := false;
  try

    if not m_RsLCAskLeave.LCLeaveType.ExistLeaveTypeWhenEdit(LeaveType) then
    begin
      CheckOk := true;
      exit;
    end
    else
    begin
      Box('该请假类型已存在!');
      exit;
    end;

  except
    on e: Exception do
    begin
      BoxErr('判断请假类型是否存在时失败：' + e.Message);
      exit;
    end;
  end;
end;

procedure TFrmLeaveTypeMgr.btnDeleteClick(Sender: TObject);
var
  LeaveID: string;
  ErrMsg: string;
begin
  if not GetSelectedLeaveID(LeaveID) then
  begin
    Box('请选择要删除的请假类型!');
    exit;
  end;

  if not TBox('您确定要删除此请假类型吗?') then Exit;



  if not m_RsLCAskLeave.LCLeaveType.DeleteLeaveType(LeaveID, ErrMsg) then
  begin
    BoxErr('删除请假类型时失败:' + ErrMsg);
    exit;
  end
  else
  begin
    QueryLeaveInfo;
  end;
end;

procedure TFrmLeaveTypeMgr.btnEditClick(Sender: TObject);
var
  strLeaveName: string;
  LeaveType: RRsLeaveType;
  LeaveClassArray: TRsLeaveClassArray;
  bExist: boolean;
  ErrMsg: string;
begin
  if not GetSelectedLeaveName(strLeaveName) then
  begin
    Box('请选择要编辑的请假类型!');
    exit;
  end;



  if not m_RsLCAskLeave.LCLeaveType.GetLeaveType(strLeaveName, LeaveType, bExist, ErrMsg) then
  begin
    BoxErr('查询请假类型详情时失败:' + ErrMsg);
    exit;
  end;

  if not bExist then
  begin
    Box('数据库中不存在名为' + strLeaveName + '的请假类型');
    exit;
  end;


  if not m_RsLCAskLeave.LCLeaveType.GetLeaveClasses(LeaveClassArray, ErrMsg) then
  begin
    BoxErr('查询请假所属类别失败:' + ErrMsg);
    exit;
  end;

  if not TFrmLeaveTypeModify.ShowLeaveTypeModifyForm(LeaveType, LeaveClassArray, CheckAfterEdit) then exit;



  if not m_RsLCAskLeave.LCLeaveType.UpdateLeaveType(LeaveType, ErrMsg) then
  begin
    BoxErr('更新请假类型时失败:' + ErrMsg);
    exit;
  end;
  QueryLeaveInfo;
end;

procedure TFrmLeaveTypeMgr.btnQueryClick(Sender: TObject);
begin
  if edtLeaveName.Text = '' then
  begin
    //全部查询
    QueryLeaveInfo;
  end
  else
  begin
    QueryLeaveInfoByName(edtLeaveName.Text);
  end;

end;

procedure TFrmLeaveTypeMgr.FormDestroy(Sender: TObject);
begin
  m_RsLCAskLeave.Free;
end;

procedure TFrmLeaveTypeMgr.Init;
begin
  m_RsLCAskLeave := TRsLCAskLeave.Create(g_WebAPIUtils);
  QueryLeaveInfo;
end;

procedure TFrmLeaveTypeMgr.QueryLeaveInfo;
var
  i: integer;
  LeaveTypeArray: TRsLeaveTypeArray;
  ErrMsg: string;
begin

  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('查询请假类型列表失败:' + ErrMsg);
    exit;
  end;


  with strGridLeaveInfo do
  begin
    ClearRows(1, 10000);
    RowCount := length(LeaveTypeArray) + 2;
    statusMain.Panels[0].Text := Format('共查询出%d条数据', [RowCount - 2]);
    for i := 0 to length(LeaveTypeArray) - 1 do
    begin
      Cells[0, i + 1] := inttoStr(i + 1);
      Cells[1, i + 1] := LeaveTypeArray[i].strTypeName;
      Cells[2, i + 1] := LeaveTypeArray[i].strClassName;
      Cells[999, i + 1] := LeaveTypeArray[i].strTypeGUID;
    end;
  end;
end;

procedure TFrmLeaveTypeMgr.QueryLeaveInfoByName(strLeaveName: string);
var
  LeaveType: RRsLeaveType;
  bExist: boolean;
  ErrMsg: string;
begin

  if not m_RsLCAskLeave.LCLeaveType.GetLeaveType(strLeaveName, LeaveType, bExist, ErrMsg) then
  begin
    BoxErr('查询请假类型详情时失败:' + ErrMsg);
    exit;
  end;

  strGridLeaveInfo.ClearRows(1, 10000);
  if bExist then
  begin
    with strGridLeaveInfo do
    begin
      statusMain.Panels[0].Text := Format('共查询出%d条数据', [1]);
      Cells[0, 1] := inttostr(1);
      Cells[1, 1] := LeaveType.strTypeName;
      Cells[2, 1] := LeaveType.strClassName;
      Cells[999, 1] := LeaveType.strTypeGUID;
    end;
  end
  else
  begin
    statusMain.Panels[0].Text := Format('共查询出%d条数据', [0]);
  end;
end;
end.
