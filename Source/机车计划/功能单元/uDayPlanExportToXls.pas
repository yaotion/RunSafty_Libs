unit uDayPlanExportToXls;

interface
uses
  Classes,SysUtils,Comobj,uLCDayPlan,uTemplateDayPlan,DateUtils,Variants,uTFSystem,
  Contnrs;


const
  INDEX_LEFT_TRAIN_NO1 = 1 ;
  INDEX_LEFT_TRAIN_INFO = 2 ;
  INDEX_LEFT_TRAIN_NO2 = 3 ;
  INDEX_LEFT_TRAIN_REMARK = 4 ;

  INDEX_SEPRATOR = 5 ;

  INDEX_RIGHT_TRAIN_NO1 = 6 ;
  INDEX_RIGHT_TRAIN_INFO = 7 ;
  INDEX_RIGHT_TRAIN_NO2 = 8 ;
  INDEX_RIGHT_TRAIN_REMARK = 9 ;

  xlHAlignCenter = -4108;   //excel居中对齐

  EXCEL_ROW_HEIGHT  = 16 ;

type
  //导出进度事件
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;
  //
  
  TDayPlanXls = class
  public
    function ExportToXls(BeginDate,EndDate: TDateTime;DayOrNight: integer;ExportData: TRsDayPlanExportData;
      ExcelFile: string): Boolean;
  private
    m_OnExportPlanProgress: TOnExportPlanProgress;          //导出进度事件

    //查询一共有多少条
    function GetTotalPlanCount(ExportData: TRsDayPlanExportData):Integer;
    //获取日期名字
    function GetPlanTitle(BeginDate,EndDate: TDateTime;DayOrNight: integer):string;
    //添加标题
    procedure AddTitle(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //////////////////左侧
    //添加头
    procedure AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //添加正文
    procedure AddLeftContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加打温
    procedure AddLeftDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);

    /////////////////右侧
    //添加头
    procedure AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //添加正文
    procedure AddRightContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加打温
    procedure AddRightDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);

    //添加边框
    procedure AddBorder(excelApp, workBook, workSheet: Variant;Row:Integer);
  public
    //导出进度事件
    property OnExportPlanProgress: TOnExportPlanProgress read m_OnExportPlanProgress write m_OnExportPlanProgress;
  end;


implementation

{ TDayPlanXls }

procedure TDayPlanXls.AddBorder(excelApp, workBook, workSheet: Variant;
  Row: Integer);
var
  strRange : string ;
begin
  strRange := Format('A1:I%d',[Row]);
  workSheet.range[strRange].borders.linestyle:=1;//设置边框样式
end;


procedure TDayPlanXls.AddLeftContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].WrapText:= False;//文本自动换行

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//行高

  inc(Row)
end;

procedure TDayPlanXls.AddLeftDaWen(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//行高

  inc(Row)
end;

procedure TDayPlanXls.AddLeftHead(excelApp, workBook, workSheet: Variant;
  DayPlanItemGroup: TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //标题
  strRange := Format('A%d:D%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,1].Font.Name := '宋体';
  excelApp.Cells[Row,1].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,1].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, 1].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);


  if DayPlanItemGroup.IsDaWen = 0 then
  begin

    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '车次';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '机车';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '车次';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '车型';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '机车';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '机车';
  end;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := '附注';

  inc(row);
end;

procedure TDayPlanXls.AddRightContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].WrapText:= False;//文本自动换行

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//行高

  inc(Row)
end;

procedure TDayPlanXls.AddRightDaWen(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//行高
  
  inc(Row)
end;


procedure TDayPlanXls.AddRightHead(excelApp, workBook, workSheet: Variant;
  DayPlanItemGroup: TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //标题
  strRange := Format('F%d:I%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,6].Font.Name := '宋体';
  excelApp.Cells[Row,6].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,6].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,6].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, 6].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);

  if DayPlanItemGroup.IsDaWen = 0 then
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '车次';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '机车';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '车次';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '车型';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '机车';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '机车';
  end;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 12;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := '附注';
  inc(row);
end;


procedure TDayPlanXls.AddTitle(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
begin
  
  workSheet.Rows[Row].Font.Name := '宋体';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size := 24 ;
  workSheet.range['A1:I1'].Merge(true);
  excelApp.Cells[Row, 1].Value :=  '机车交路计划';
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  workSheet.rows[Row].rowheight:= 28.5;//行高

  inc(Row);
  workSheet.range['A2:I2'].Merge;
  workSheet.Rows[Row].Font.Name := '宋体';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size :=12 ;
  excelApp.Cells[Row, 1].Value := Title ;
  inc(Row);

  workSheet.Columns[INDEX_LEFT_TRAIN_REMARK].ColumnWidth := 16;    //设置附注的宽度
  workSheet.Columns[INDEX_RIGHT_TRAIN_REMARK].ColumnWidth := 16;   //设置附注的宽度
  workSheet.Columns[INDEX_SEPRATOR].ColumnWidth := 1 ;             //中间的分割线的宽度
end;

function TDayPlanXls.ExportToXls(BeginDate,EndDate: TDateTime;DayOrNight: integer;ExportData: TRsDayPlanExportData; ExcelFile: string): Boolean;
var
  excelApp, workBook, workSheet: Variant;
  i,j, nRow,nTempRow,nLeftMax,nRightMax,nMaxRow,nCurrentPos,nTotalCount: integer;
  strErrorInfo,strTitle: string;
begin
  nCurrentPos := 0 ;
  result := false;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strErrorInfo := '你还没有安装Microsoft Excel，请先安装！';
    BoxErr(strErrorInfo);
    exit;
  end;

  try
    //excelApp.DisplayAlerts:=false ;
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(ExcelFile) then
    begin
      excelApp.workBooks.Open(ExcelFile);
      workBook := excelApp.Worksheets[1].activate;
      workSheet :=  excelApp.ActiveSheet ;
    end
    else
    begin
      excelApp.WorkBooks.Add;
      workBook := excelApp.Workbooks.Add;
      workSheet := workBook.Sheets.Add;
    end;

    nRow := 1;


    strTitle := GetPlanTitle(BeginDate, EndDate,DayOrNight ) ;
    AddTitle(excelApp,workBook,workSheet,strTitle,nRow );


    //获取总条数
    nTotalCount := GetTotalPlanCount(ExportData);

    nTempRow := nRow ;
    //获取左面的区域列表
    for I := 0 to ExportData.LeftGroup.Count - 1 do
    begin

      AddLeftHead(excelApp, workBook, workSheet,ExportData.LeftGroup.Items[i].PlanItemGroup,nRow);

      //判断是否是打温车型
      if ExportData.LeftGroup.Items[i].PlanItemGroup.IsDaWen = 0 then
      begin

        for j := 0 to Length(ExportData.LeftGroup.Items[i].PlanArray) - 1 do
        begin
          AddLeftContext(excelApp, workBook, workSheet,ExportData.LeftGroup.Items[i].PlanArray[j],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress( nCurrentPos , nTotalCount - 1);
            inc(nCurrentPos);
          end;
        end;
      end
      else
      begin
        for J := 0 to Length(ExportData.LeftGroup.Items[i].PlanArray) - 1 do
        begin
          AddLeftDaWen(excelApp, workBook, workSheet,ExportData.LeftGroup.Items[i].PlanArray[j],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1);
            inc(nCurrentPos);
          end;
        end;
      end;
    end;

    nLeftMax :=  nRow ;
    nRow := nTempRow ;

    //获取右面的区域列表
    for I := 0 to ExportData.RightGroup.Count - 1 do
    begin

      AddRightHead(excelApp, workBook, workSheet,ExportData.RightGroup.Items[i].PlanItemGroup,nRow);
  
      //判断是否是打温车型
      if ExportData.RightGroup.Items[i].PlanItemGroup.IsDaWen = 0 then
      begin
        for j := 0 to Length(ExportData.RightGroup.Items[i].PlanArray) - 1 do
        begin
          AddRightContext(excelApp, workBook, workSheet,ExportData.RightGroup.Items[i].PlanArray[j],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1 );
            inc(nCurrentPos);
          end;
        end;
      end
      else
      begin
        for J := 0 to Length(ExportData.RightGroup.Items[i].PlanArray) - 1 do
        begin
          AddRightDaWen(excelApp, workBook, workSheet,ExportData.RightGroup.Items[i].PlanArray[j],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1 );
            inc(nCurrentPos);
          end;
        end;
      end;
    end;


    nRightMax := nRow ;
    nMaxRow := nRightMax ;
    if nLeftMax > nMaxRow then
      nMaxRow := nLeftMax ;

    //添加边框 (因为上面自增了一个所以下去下面需要减去一个)
    AddBorder(excelApp, workBook, workSheet,nMaxRow - 1 )  ;

    if not FileExists(ExcelFile) then
      workSheet.SaveAs(excelFile);
    result := true;
  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;


function TDayPlanXls.GetPlanTitle(BeginDate, EndDate: TDateTime;
  DayOrNight: integer): string;
var
  strTtitle : string ;
  strDateBegin : string ;
  strDateEnd : string ;
  strPlan : string;
begin
  strDateBegin := FormatDateTime('yyyy-MM-dd',BeginDate) ;
  strDateEnd :=  FormatDateTime('yyyy-MM-dd',IncDay(BeginDate,1)) ;
  case DayOrNight  of
  ord(dptDay) :
    begin
      strPlan := ' 白班';
      strTtitle := '时间：' + strDateBegin + strPlan ;
    end;
  ord(dptNight) :
    begin
      strPlan := ' 夜班';
      strTtitle := '时间：' + strDateBegin + strPlan ;
    end;
  ord(dtpAll) :
    begin
      strTtitle := Format('%s 18：00—%s 18：00',[strDateBegin,strDateEnd]) ;
    end;
  else
    begin
      ;
    end;
  end;
  Result := strTtitle ;
end;

function TDayPlanXls.GetTotalPlanCount(ExportData: TRsDayPlanExportData): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ExportData.LeftGroup.Count - 1 do
  begin
    Result := Result + Length(ExportData.LeftGroup.Items[i].PlanArray);
  end;

  for I := 0 to ExportData.RightGroup.Count - 1 do
  begin
    Result := Result + Length(ExportData.RightGroup.Items[i].PlanArray);
  end;
end;

end.
