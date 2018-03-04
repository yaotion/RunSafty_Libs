unit uFrmNameBoardChangeLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzChkLst, Grids, AdvObj, BaseGrid, AdvGrid,
  Buttons, PngSpeedButton, ExtCtrls, RzPanel, RzRadGrp,uTrainmanJiaolu,
  uTFSystem,uSaftyEnum,uTrainman,DateUtils,ComObj,
  ComCtrls, RzDTP,uLCNameBoardEx, Mask, RzEdit,
  RzCmboBx, RzButton, ImgList,uWebApiCollection, RzCommon;

type
  TfrmNameBoardChangeLog = class(TForm)
    strGridLeaveInfo: TAdvStringGrid;
    RzPanel1: TRzPanel;
    rgTrainmanjiaolu: TRzCheckList;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnView: TRzToolButton;
    BtnExport: TRzToolButton;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    dtpBeginDate: TRzDateTimePicker;
    Label2: TLabel;
    dtpEndDate: TRzDateTimePicker;
    Label3: TLabel;
    cbbType: TRzComboBox;
    Label4: TLabel;
    edtKey: TRzEdit;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    RzSpacer5: TRzSpacer;
    RzSpacer6: TRzSpacer;
    RzSpacer7: TRzSpacer;
    RzSpacer8: TRzSpacer;
    RzFrameController1: TRzFrameController;
    procedure FormCreate(Sender: TObject);
    procedure strGridLeaveInfoDblClickCell(Sender: TObject; ARow,
      ACol: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
    { Private declarations }
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    m_ChangeLogArray : TRsChangeLogArray;
    procedure Init;
  public
    { Public declarations }
    class procedure Open();
  end;
implementation
uses
  uGlobal;
var
  frmNameBoardChangeLog: TfrmNameBoardChangeLog;
{$R *.dfm}
{ TfrmNameBoardChangeLog }

procedure TfrmNameBoardChangeLog.BtnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    strGridLeaveInfo.SaveToXLS(SaveDialog1.FileName);
    Box('导出完毕!');
  end;
end;

procedure TfrmNameBoardChangeLog.BtnViewClick(Sender: TObject);
var
  trainmanjiaolus : TStrings;
  i: Integer;
  dtBeginTime,dtEndTime : TDateTime;
  nChangeType: integer;
begin
  trainmanjiaolus := TStringList.Create;
  try
    //组合选择的人员交路
    dtBeginTime := DateOf(dtpBeginDate.DateTime);
    dtEndTime := IncSecond(IncDay(DateOf(dtpEndDate.Date),1),-1);


    for I := 0 to rgTrainmanjiaolu.Items.Count - 1 do
    begin
      if rgTrainmanjiaolu.ItemChecked[i] then
      begin
        trainmanjiaolus.Add(m_TrainmanjiaoluArray[i].strTrainmanJiaoluGUID);
      end;
    end;
    if trainmanjiaolus.Count = 0 then
      Exit;

    if cbbType.Value = '' then
      nChangeType := -1
    else
      nChangeType := StrToIntDef(cbbType.Value,-1);


    m_RsLCNameBoardEx.QueryChangeLog(dtBeginTime,dtEndTime,trainmanjiaolus,nChangeType,edtKey.Text,m_ChangeLogArray);


     with strGridLeaveInfo do
    begin
      ClearRows(1,10000);
      if length(m_ChangeLogArray) > 0  then
        RowCount := length(m_ChangeLogArray) + 1
      else
      begin
        RowCount := 2;
        Cells[999,1] := ''
      end;
      for i := 0 to length(m_ChangeLogArray) - 1 do
      begin
        Cells[0, i + 1] := IntToStr(i + 1);
        Cells[1, i + 1] := m_ChangeLogArray[i].strTrainmanJiaoluName;
        Cells[2, i + 1] := TRSLBoardChangeTypeNameArray[TRSLBoardChangeType(m_ChangeLogArray[i].nBoardChangeType)];
        Cells[3, i + 1] := m_ChangeLogArray[i].strContent;
        Cells[4, i + 1] := m_ChangeLogArray[i].strDutyUserName;
        Cells[5, i + 1] := m_ChangeLogArray[i].strDutyUserNumber;
        Cells[6, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_ChangeLogArray[i].dtEventTime);
        Cells[999, i + 1] := m_ChangeLogArray[i].strLogGUID;
      end;
      Invalidate;
    end;
  finally
    trainmanjiaolus.Free;
  end;
end;
procedure TfrmNameBoardChangeLog.FormCreate(Sender: TObject);
begin
  SetLength(m_TrainmanJiaoluArray,0);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(g_WebAPIUtils);
end;

procedure TfrmNameBoardChangeLog.FormDestroy(Sender: TObject);
begin
  m_RsLCNameBoardEx.Free;
end;

procedure TfrmNameBoardChangeLog.Init;
var
  i: Integer;
  ChangeType: TRSLBoardChangeType;
begin
  dtpBeginDate.DateTime := now - 1;
  dtpEndDate.DateTime := now;
  LCWebAPI.LCTMJl.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.Site.ID,'',m_TrainmanjiaoluArray);
  rgTrainmanJiaolu.Items.Clear;
  for i := 0 to length(m_TrainmanjiaoluArray) - 1 do
  begin
    rgTrainmanJiaolu.Items.Add(m_TrainmanjiaoluArray[i].strTrainmanJiaoluName);
  end;

  cbbType.Items.Clear;
  cbbType.AddItemValue('全部','');

  for ChangeType := Low(TRSLBoardChangeType) to High(TRSLBoardChangeType) do
  begin
    cbbType.AddItemValue(TRSLBoardChangeTypeNameArray[ChangeType],IntToStr(Ord(ChangeType)));
  end;
  
end;

class procedure TfrmNameBoardChangeLog.Open;
begin
  frmNameBoardChangeLog:= TfrmNameBoardChangeLog.Create(nil);
  try
    frmNameBoardChangeLog.Init;
    frmNameBoardChangeLog.ShowModal;
  finally
    frmNameBoardChangeLog.Free;
  end;
end;

procedure TfrmNameBoardChangeLog.strGridLeaveInfoDblClickCell(Sender: TObject;
  ARow, ACol: Integer);
begin
  if ARow = 0 then exit;
  if ACol <> 3 then exit;
  //TfrmShowText.ShowText(strGridLeaveInfo.Cells[ACol,ARow]);
end;

end.
