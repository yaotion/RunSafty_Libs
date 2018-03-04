unit uFrmViewMealTicketLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, Buttons, PngSpeedButton, ExtCtrls,
  RzPanel,uMealTicket,uLCMealTicket,utfsystem, RzCommon, RzDTP, Mask, RzEdit,
  RzListVw, ImgList;

type
  TFrmViewMealTicketLog = class(TForm)
    rzpnl1: TRzPanel;
    btnRefresh: TPngSpeedButton;
    lb1: TLabel;
    lb2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    dtpStartDate: TRzDateTimePicker;
    RzFrameController1: TRzFrameController;
    dtpStartTime: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    dtpEndTime: TRzDateTimePicker;
    edtDriver: TRzEdit;
    edtFaFang: TRzEdit;
    lvRecord: TRzListView;
    ImageList1: TImageList;
    btnExport: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    btnDel: TPngSpeedButton;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    m_LCTicket:TRsLCMealTicket;

    m_listTicket:TRsMealTicketList;
  private
    { Private declarations }
    procedure InitData();
    procedure DataToListView(MealList:TRsMealTicketList);
  public
    { Public declarations }
    class procedure ShowForm(EnableDel: Boolean = False);
  end;

var
  FrmViewMealTicketLog: TFrmViewMealTicketLog;

implementation

uses
  uGlobal,Comobj, uDialogsLib;

type
  TLogExporter = class
  private
    procedure CreateTitle(MSExcelWorkSheet: Variant);
    procedure CreateBody(MSExcelWorkSheet: Variant;MealList:TRsMealTicketList);
  public
    procedure ExportToFile(const FileName: string;MealList:TRsMealTicketList);
  end;


{$R *.dfm}

{ TFrmViewMealTicketLog }

procedure TFrmViewMealTicketLog.btnDelClick(Sender: TObject);
begin
  if lvRecord.Selected = nil then Exit;

  if not TBox('确定要删除记录吗？') then Exit;

  m_LCTicket.DelLog(PMealTicket(lvRecord.Selected.Data).ID);

  lvRecord.Selected.Delete;
end;

procedure TFrmViewMealTicketLog.btnExportClick(Sender: TObject);
var
  NoFocusHint: TNoFocusHint;
begin
  if SaveDialog.Execute(self.Handle) then
  begin


    with TLogExporter.Create do
    begin
      NoFocusHint := TNoFocusHint.Create;
      try
        NoFocusHint.Hint('正在导出数据...');
        ExportToFile(SaveDialog.FileName, m_listTicket);
        NoFocusHint.close;
        Box('导出完毕!');
      finally
        Free;
        NoFocusHint.Free;
      end;
    end;
  end;
end;

procedure TFrmViewMealTicketLog.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmViewMealTicketLog.DataToListView(MealList: TRsMealTicketList);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
   lvRecord.Items.Clear;
  for I := 0 to Length(MealList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Data := @MealList[i];
      Caption := inttostr(i+1) ;

      strText := Format('[%s]%s',[MealList[i].DRIVER_CODE,MealList[i].DRIVER_NAME]);
      SubItems.Add(strText);

      SubItems.Add(IntToStr(MealList[i].CANQUAN_A));
      SubItems.Add(IntToStr(MealList[i].CANQUAN_B));

      SubItems.Add(MealList[i].CHUQIN_TIME);
      SubItems.Add(MealList[i].PAIBAN_CHECI);

      strText := Format('[%s]%s',[MealList[i].SHENHEREN_CODE,MealList[i].SHENHEREN_NAME]);
      SubItems.Add(strText);

      SubItems.Add(MealList[i].REC_TIME) ;
    end;
  end;
end;

procedure TFrmViewMealTicketLog.FormCreate(Sender: TObject);
begin
  m_LCTicket := TRsLCMealTicket.Create(g_WebAPIUtils);
  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';
end;

procedure TFrmViewMealTicketLog.FormDestroy(Sender: TObject);
begin
  m_LCTicket.Free;
end;

procedure TFrmViewMealTicketLog.InitData;
var
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
begin
  //获取开始和结束的查询时间
  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  //查询数据库
  SetLength(m_listTicket,0);
  m_LCTicket.QueryLog(dtStart,dtEnd,edtDriver.Text,edtFaFang.Text,m_listTicket);

  //显示结果集
  DataToListView(m_listTicket);
end;

class procedure TFrmViewMealTicketLog.ShowForm(EnableDel: Boolean);
var
  frm : TFrmViewMealTicketLog;
begin
  frm := TFrmViewMealTicketLog.Create(nil);
  try
    frm.btnDel.Visible := EnableDel;
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

{ TLogExporter }

procedure TLogExporter.CreateBody(MSExcelWorkSheet: Variant;MealList:TRsMealTicketList);
var
  I: Integer;
begin
  for I := 0 to Length(MealList) - 1 do
  begin
    MSExcelWorkSheet.Cells[i + 2,1] := inttostr(i+1);
    MSExcelWorkSheet.Cells[i + 2,2] := Format('[%s]%s',[MealList[i].DRIVER_CODE,MealList[i].DRIVER_NAME]);;
    MSExcelWorkSheet.Cells[i + 2,3] := IntToStr(MealList[i].CANQUAN_A);
    MSExcelWorkSheet.Cells[i + 2,4] := IntToStr(MealList[i].CANQUAN_B);
    MSExcelWorkSheet.Cells[i + 2,5] := MealList[i].CHUQIN_TIME;
    MSExcelWorkSheet.Cells[i + 2,6] := MealList[i].PAIBAN_CHECI;
    MSExcelWorkSheet.Cells[i + 2,7] := Format('[%s]%s',[MealList[i].SHENHEREN_CODE,MealList[i].SHENHEREN_NAME]);
    MSExcelWorkSheet.Cells[i + 2,8] := MealList[i].REC_TIME;
  end;
end;

type
  RXlsColumn = record
    Title: string;
    Width: integer;
  end;
  
const
  XLSTITLEARRAY: array[0..7] of RXlsColumn = (
    (Title: '序号';Width: 5),
    (Title: '领取人';Width: 22),
    (Title: '早餐';Width: 8),
    (Title: '正餐';Width: 8),
    (Title: '计划时间';Width: 30),
    (Title: '车次';Width: 12),
    (Title: '发放人';Width: 22),
    (Title: '发放时间';Width: 30)
    );
  
procedure TLogExporter.CreateTitle(MSExcelWorkSheet: Variant);
var
  I: Integer;
  Range: Variant;
begin
  for I := 0 to Length(XLSTITLEARRAY) - 1 do
  begin
    Range := MSExcelWorkSheet.Columns[i + 1];
    Range.HorizontalAlignment := $FFFFEFDD;   //左对齐
    Range.ColumnWidth := XLSTITLEARRAY[i].Width;

    Range := MSExcelWorkSheet.Cells[1,i + 1];
    Range.FormulaR1C1 := XLSTITLEARRAY[i].Title;
    Range.Font.Bold := True;

  end;
end;

procedure TLogExporter.ExportToFile(const FileName: string;MealList:TRsMealTicketList);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  version: Double;
  fullName,defautExt: string;
begin
  MSExcel := CreateOleObject('Excel.Application');
  try
    MSExcel.DisplayAlerts := 0;
    if TryStrToFloat(MSExcel.Version,version) then
    begin
      if version >= 12 then
        defautExt := '.xlsx'
      else
        defautExt := '.xls';
    end
    else
      defautExt := '.xls';

    if ExtractFileExt(FileName) = '' then
      fullName := FileName + defautExt
    else
      fullName := FileName;

    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];

    CreateTitle(MSExcelWorkSheet);

    CreateBody(MSExcelWorkSheet,MealList);

    MSExcelWorkBook.SaveAs(fullName);
  finally
    MSExcel.Quit;
  end;

end;

end.
