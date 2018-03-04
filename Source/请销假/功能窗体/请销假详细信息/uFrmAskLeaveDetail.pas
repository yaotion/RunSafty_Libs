unit uFrmAskLeaveDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uLeaveListInfo, uTFSystem, ExtCtrls,
  RzPanel, Grids, AdvObj, BaseGrid, AdvGrid, ComCtrls, Buttons, PngCustomButton,
  uLCAskLeave,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmAskLeaveDetail = class(TForm)
    RzPanel1: TRzPanel;
    statusMain: TStatusBar;
    strGridLeaveInfo: TAdvStringGrid;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure strGridLeaveInfoGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
  private
    { Private declarations }
    m_RsLCAskLeave: TRsLCAskLeave;

    m_AskLeaveDetail: RRsAskLeaveDetail;

    m_CancelLeaveDetail: RRsCancelLeaveDetail;

    function Init(strAskLeaveGUID: string;strTypeName:string): boolean;
  public
    { Public declarations }
    class procedure ShowForm(strAskLeaveGUID, strTypeName, strTrainmanNumber, strTrainmanName:string);
  end;


implementation

uses uGlobal;

{$R *.dfm}

procedure TFrmAskLeaveDetail.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFrmAskLeaveDetail.FormDestroy(Sender: TObject);
begin
  m_RsLCAskLeave.Free;
end;

class procedure TFrmAskLeaveDetail.ShowForm(strAskLeaveGUID, strTypeName, strTrainmanNumber, strTrainmanName:string);
var
  FrmAskLeaveDetail: TFrmAskLeaveDetail;
begin
  FrmAskLeaveDetail := TFrmAskLeaveDetail.Create(nil);
  if FrmAskLeaveDetail.Init(strAskLeaveGUID,strTypeName) then
  begin
    FrmAskLeaveDetail.Caption := Format('请销假详细信息 - %s[%s]', [strTrainmanName, strTrainmanNumber]);
    FrmAskLeaveDetail.ShowModal;
  end;
  FrmAskLeaveDetail.Free;
end;

procedure TFrmAskLeaveDetail.strGridLeaveInfoGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ARow = 0 then
  begin
    HAlign := taCenter;
  end
  else
  begin
    if ACol <> 3 then HAlign := taCenter;
  end;
end;

function TFrmAskLeaveDetail.Init(strAskLeaveGUID: string;strTypeName:string): boolean;
var
  ErrMsg: string;
begin
  m_RsLCAskLeave:= TRsLCAskLeave.Create(g_WebAPIUtils);

  result := false;
  if not m_RsLCAskLeave.GetAskLeaveDetail(strAskLeaveGUID, m_AskLeaveDetail, ErrMsg) then
  begin
    BoxErr('查询请假详情失败:' + ErrMsg);
    exit;
  end;

  if not m_RsLCAskLeave.GetCancelLeaveDetail(strAskLeaveGUID, m_CancelLeaveDetail, ErrMsg) then
  begin
    BoxErr('查询销假详情失败:' + ErrMsg);
    exit;
  end;

  {*liulin del 20130923
  if not m_dbLeaveInfo.GetFollowLeaveDetails(strAskLeaveGUID, m_FollowLeaveDetailArray, ErrMsg) then
  begin
    BoxErr('查询续假详情失败:' + ErrMsg);
    exit;
  end;
  *}

  with strGridLeaveInfo do
  begin
    ClearRows(1, 10000);

    Cells[0, 1] := '1';
    Cells[1, 1] := '请假';
    Cells[2, 1] := strTypeName;
    Cells[3, 1] := m_AskLeaveDetail.strMemo;
    Cells[4, 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeaveDetail.dtBeginTime);
    //Cells[5, 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeaveDetail.dtEndTime);
    Cells[5, 1] := '';//'--';
    Cells[6, 1] := Format('%s[%s]', [m_AskLeaveDetail.strProverName, m_AskLeaveDetail.strProverID]);
    //Cells[7, 1] := m_AskLeaveDetail.strProverName;
    Cells[7, 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_AskLeaveDetail.dtCreateTime);

    Cells[8, 1] := m_AskLeaveDetail.strDutyUserName;
    Cells[9, 1] := m_AskLeaveDetail.strSiteName;

    if m_CancelLeaveDetail.strCancelLeaveGUID <> '' then
    begin
      Cells[0, 2] := intToStr(2);
      Cells[1, 2] := '销假';
      Cells[2, 2] := strTypeName;
      Cells[3, 2] := '';//'- - ';
      Cells[4, 2] := '';//'- - ';
      Cells[5, 2] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_CancelLeaveDetail.dtCancelTime);
      Cells[6, 2] := Format('%s[%.4s]', [m_CancelLeaveDetail.strProverName,m_CancelLeaveDetail.strProverID]);
      //Cells[7, 2] := m_CancelLeaveDetail.strProverName;
      Cells[7, 2] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_CancelLeaveDetail.dtCreateTime);
      Cells[8, 2] := m_CancelLeaveDetail.strDutyUserName;
      Cells[9, 2] := m_CancelLeaveDetail.strSiteName;
    end;

    if m_CancelLeaveDetail.strCancelLeaveGUID <> '' then
      RowCount := 3
    else
      RowCount := 2;
    statusMain.Panels[0].Text := Format('共查询出%d条数据', [RowCount - 1]);
  end;
  result := true;
end;

end.

