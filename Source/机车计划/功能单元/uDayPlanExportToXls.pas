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

  xlHAlignCenter = -4108;   //excel���ж���

  EXCEL_ROW_HEIGHT  = 16 ;

type
  //���������¼�
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;
  //
  
  TDayPlanXls = class
  public
    function ExportToXls(BeginDate,EndDate: TDateTime;DayOrNight: integer;ExportData: TRsDayPlanExportData;
      ExcelFile: string): Boolean;
  private
    m_OnExportPlanProgress: TOnExportPlanProgress;          //���������¼�

    //��ѯһ���ж�����
    function GetTotalPlanCount(ExportData: TRsDayPlanExportData):Integer;
    //��ȡ��������
    function GetPlanTitle(BeginDate,EndDate: TDateTime;DayOrNight: integer):string;
    //��ӱ���
    procedure AddTitle(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //////////////////���
    //���ͷ
    procedure AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //�������
    procedure AddLeftContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��Ӵ���
    procedure AddLeftDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);

    /////////////////�Ҳ�
    //���ͷ
    procedure AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //�������
    procedure AddRightContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��Ӵ���
    procedure AddRightDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);

    //��ӱ߿�
    procedure AddBorder(excelApp, workBook, workSheet: Variant;Row:Integer);
  public
    //���������¼�
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
  workSheet.range[strRange].borders.linestyle:=1;//���ñ߿���ʽ
end;


procedure TDayPlanXls.AddLeftContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].WrapText:= False;//�ı��Զ�����

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//�и�

  inc(Row)
end;

procedure TDayPlanXls.AddLeftDaWen(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//�и�

  inc(Row)
end;

procedure TDayPlanXls.AddLeftHead(excelApp, workBook, workSheet: Variant;
  DayPlanItemGroup: TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //����
  strRange := Format('A%d:D%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,1].Font.Name := '����';
  excelApp.Cells[Row,1].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,1].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, 1].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);


  if DayPlanItemGroup.IsDaWen = 0 then
  begin

    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '����';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '����';
  end;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := '��ע';

  inc(row);
end;

procedure TDayPlanXls.AddRightContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].WrapText:= False;//�ı��Զ�����

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//�и�

  inc(Row)
end;

procedure TDayPlanXls.AddRightDaWen(excelApp, workBook, workSheet: Variant;
  DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//�и�
  
  inc(Row)
end;


procedure TDayPlanXls.AddRightHead(excelApp, workBook, workSheet: Variant;
  DayPlanItemGroup: TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //����
  strRange := Format('F%d:I%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,6].Font.Name := '����';
  excelApp.Cells[Row,6].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,6].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,6].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, 6].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);

  if DayPlanItemGroup.IsDaWen = 0 then
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '����';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '����';
  end;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := '��ע';
  inc(row);
end;


procedure TDayPlanXls.AddTitle(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
begin
  
  workSheet.Rows[Row].Font.Name := '����';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size := 24 ;
  workSheet.range['A1:I1'].Merge(true);
  excelApp.Cells[Row, 1].Value :=  '������·�ƻ�';
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  workSheet.rows[Row].rowheight:= 28.5;//�и�

  inc(Row);
  workSheet.range['A2:I2'].Merge;
  workSheet.Rows[Row].Font.Name := '����';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size :=12 ;
  excelApp.Cells[Row, 1].Value := Title ;
  inc(Row);

  workSheet.Columns[INDEX_LEFT_TRAIN_REMARK].ColumnWidth := 16;    //���ø�ע�Ŀ��
  workSheet.Columns[INDEX_RIGHT_TRAIN_REMARK].ColumnWidth := 16;   //���ø�ע�Ŀ��
  workSheet.Columns[INDEX_SEPRATOR].ColumnWidth := 1 ;             //�м�ķָ��ߵĿ��
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
    strErrorInfo := '�㻹û�а�װMicrosoft Excel�����Ȱ�װ��';
    BoxErr(strErrorInfo);
    exit;
  end;

  try
    //excelApp.DisplayAlerts:=false ;
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
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


    //��ȡ������
    nTotalCount := GetTotalPlanCount(ExportData);

    nTempRow := nRow ;
    //��ȡ����������б�
    for I := 0 to ExportData.LeftGroup.Count - 1 do
    begin

      AddLeftHead(excelApp, workBook, workSheet,ExportData.LeftGroup.Items[i].PlanItemGroup,nRow);

      //�ж��Ƿ��Ǵ��³���
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

    //��ȡ����������б�
    for I := 0 to ExportData.RightGroup.Count - 1 do
    begin

      AddRightHead(excelApp, workBook, workSheet,ExportData.RightGroup.Items[i].PlanItemGroup,nRow);
  
      //�ж��Ƿ��Ǵ��³���
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

    //��ӱ߿� (��Ϊ����������һ��������ȥ������Ҫ��ȥһ��)
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
      strPlan := ' �װ�';
      strTtitle := 'ʱ�䣺' + strDateBegin + strPlan ;
    end;
  ord(dptNight) :
    begin
      strPlan := ' ҹ��';
      strTtitle := 'ʱ�䣺' + strDateBegin + strPlan ;
    end;
  ord(dtpAll) :
    begin
      strTtitle := Format('%s 18��00��%s 18��00',[strDateBegin,strDateEnd]) ;
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
