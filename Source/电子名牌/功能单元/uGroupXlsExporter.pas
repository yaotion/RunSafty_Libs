unit uGroupXlsExporter;

interface

uses
  SysUtils, Variants, Classes,windows,
  uTFSystem,uTrainmanJiaolu,uTrainJiaolu,uTrainman,
  uSaftyEnum,uTrainPlan, uDutyPlace,uLCDutyPlace,uLCTrainPlan,
  uLCNameBoard,uLCTrainJiaolu,uLCNameBoardEx,
  uLCTrainmanMgr,Forms,comobj;
const
  COL_INDEX_NAMED_SN = 1;         //���
  COL_INDEX_NAMED_ISREST = 2;     //����
  COL_INDEX_NAMED_TRAINNO1 = 3;   //����1
  COL_INDEX_NAMED_TRAINNO2 = 4;   //����2

  COL_INDEX_NAMED_TRAINMAN1_NUMBER = 5;   //����1
  COL_INDEX_NAMED_TRAINMAN1_NAME = 6;   //����1

  COL_INDEX_NAMED_TRAINMAN2_NUMBER = 7;   //����2
  COL_INDEX_NAMED_TRAINMAN2_NAME = 8;   //����1

  COL_INDEX_NAMED_TRAINMAN3_NUMBER = 9;   //����3
  COL_INDEX_NAMED_TRAINMAN3_NAME = 10;   //����1

  COL_INDEX_NAMED_TRAINMAN4_NUMBER = 11;   //����4
  COL_INDEX_NAMED_TRAINMAN4_NAME = 12;   //����1
    
type
  //�ɰ浼�����빦�ܣ�����ʱ��Ҫ���ӷ�������ȡ���ݣ�����ʹ�õ�������
  //��Ϊʹ��ֱ�Ӵ��������鵼��ΪXLS
  TGroupXlsExporter = class
  public
    constructor Create(
      RsLCNameBoardEx: TRsLCNameBoardEx;
      RsLCTrainmanMgr: TRsLCTrainmanMgr;
      webNameBoard: TRsLCNameBoard);
  private
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_webNameBoard: TRsLCNameBoard;
  private
    //��������ʽ
    procedure ExportNamedGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);
    //���ͷ
    procedure AddNamedHead(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //�������
    procedure AddNamedContext(excelApp, workBook, workSheet: Variant;NamedGroup:RRsNamedGroup;AOrder:Integer;var Row:Integer);
    //��ӽ�����
    procedure AddNamedFooter(excelApp, workBook, workSheet: Variant;var Row:Integer);

    //�����ֳ�ʽ
    procedure ExportOrderGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);
    //��������ʽ
    procedure ExportTogetherGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);


    //�������ʽ��·�Ļ�����Ϣ
    procedure ImportNamedGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string;
      UserID,UserNumber,UserName : string);
    //�����ֳ�ʽ��·�Ļ�����Ϣ
    procedure ImportOrderGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string);
    //��������ǽ�·�Ļ�����Ϣ
    procedure ImportTogetherGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string);
  public
    //����ͼ������excel
    procedure ExportGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);

    ///���뽻·�Ļ�����Ϣ
    procedure ImportGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string;
      UserID,UserNumber,UserName : string);
  end;



    

  
implementation

uses uDialogsLib;


{ TGroupXlsExporter }

procedure TGroupXlsExporter.AddNamedContext(excelApp, workBook,
  workSheet: Variant; NamedGroup: RRsNamedGroup; AOrder: Integer;
  var Row: Integer);
var
  strText : string ;
begin
  excelApp.Cells[Row,COL_INDEX_NAMED_SN] := IntToStr(AOrder+1) ;
  if NamedGroup.nCheciType = cctRest then
    strText := '��'
  else
    strText := '��' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_ISREST] := strText ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO1] := NamedGroup.strCheci1 ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO2] := NamedGroup.strCheci2 ;

  with NamedGroup.Group do
  begin
    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NUMBER] :=  Trainman1.strTrainmanNumber ;
    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NAME] :=  Trainman1.strTrainmanName ;

    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NUMBER] := Trainman2.strTrainmanNumber ;
    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NAME] := Trainman2.strTrainmanName ;

    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NUMBER] := Trainman3.strTrainmanNumber ;
    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NAME] := Trainman3.strTrainmanName ;

    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NUMBER] := Trainman4.strTrainmanNumber ;
    excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NAME] := Trainman4.strTrainmanName ;
  end;
  inc(Row)
end;


procedure TGroupXlsExporter.AddNamedFooter(excelApp, workBook,
  workSheet: Variant; var Row: Integer);
var
  strRange : string ;
  range: Variant;
begin
  strRange := Format('A1:L%d',[Row-1]);
  range := workSheet.range[strRange]; 
  range.borders.linestyle:=1;//���ñ߿���ʽ
end;

procedure TGroupXlsExporter.AddNamedHead(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
var
  strRange:string;
  col,range: Variant;
begin
  col := workSheet.Columns[1];
  col.ColumnWidth := 18;    //���ø�ע�Ŀ��
  //����1
  strRange := Format('A%d:D%d',[Row,Row]);
  range := workSheet.range[strRange];
  range.Merge(true);
  excelApp.Cells[Row, 1] := Format('��·:[%s]',[Title]) ;

   //����2
  strRange := Format('E%d:L%d',[Row,Row]);
  range := workSheet.range[strRange];
  range.Merge(true);
  excelApp.Cells[Row,5] := '������Ϣ' ;

  inc(row);
  excelApp.Cells[Row,COL_INDEX_NAMED_SN] := '���' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_ISREST] := '�Ƿ��ݰ�' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO1] := '����1' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO2] := '����2' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NUMBER] := '����1' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NAME] := '����1' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NUMBER] := '����2' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NAME] := '����2' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NUMBER] := '����3' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NAME] := '����3' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NUMBER] := '����4' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NAME] := '����4' ;
  inc(row);
end;

constructor TGroupXlsExporter.Create(RsLCNameBoardEx: TRsLCNameBoardEx;
  RsLCTrainmanMgr: TRsLCTrainmanMgr; webNameBoard: TRsLCNameBoard);
begin
  m_RsLCNameBoardEx := RsLCNameBoardEx;
  m_RsLCTrainmanMgr := RsLCTrainmanMgr;
  m_webNameBoard := webNameBoard;
end;

procedure TGroupXlsExporter.ExportGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string);
begin
  case TrainmanJiaolu.nJiaoluType of
  jltNamed :
    begin
      ExportNamedGroups(TrainmanJiaolu,FileName);
    end;
  jltOrder :
    begin
      ExportOrderGroups(TrainmanJiaolu,FileName);
    end;
  jltTogether :
    begin
      ExportTogetherGroups(TrainmanJiaolu,FileName);
    end;
  end;
end;

procedure TGroupXlsExporter.ExportNamedGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string);
var
  excelApp, workBook, workSheet: Variant;
  i,nRow: integer;
  strError: string;
  namedGroupArray : TRsNamedGroupArray;
  NoFocusProgress: TNoFocusProgress;
begin
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strError := '�㻹û�а�װMicrosoft Excel�����Ȱ�װ��';
    exit;
  end;

  if not m_webNameBoard.GetNamedGroup(TrainmanJiaolu.strTrainmanJiaoluGUID,namedGroupArray,strError) then
  begin
    BoxErr(strError);
    Exit;
  end;

  NoFocusProgress := TNoFocusProgress.Create;
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    if FileExists(FileName) then
    begin
      excelApp.workBooks.Open(FileName);
      workSheet := excelApp.Worksheets[1];
      workSheet.activate;
    end
    else
    begin
      excelApp.WorkBooks.Add;
      workBook := excelApp.Workbooks.Add;
      workSheet := workBook.Sheets.Add;
    end;

    nRow := 1 ;

    workSheet.columns.HorizontalAlignment:=3;  //����
    AddNamedHead(excelApp,workBook,workSheet,TrainmanJiaolu.strTrainmanJiaoluName,nRow);

    for i := 0 to Length(namedGroupArray) - 1 do
    begin
      AddNamedContext(excelApp,workBook,workSheet,namedGroupArray[i],i,nRow);
      NoFocusProgress.Step(i + 1,length(namedGroupArray),'���ڵ�����Ϣ�����Ժ�');
    end;
    AddNamedFooter(excelApp,workBook,workSheet,nRow);

    Box('���������鿴!');
    if not FileExists(FileName) then
      workSheet.SaveAs(FileName);
  finally
    NoFocusProgress.Free;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

procedure TGroupXlsExporter.ExportOrderGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string);
begin

end;

procedure TGroupXlsExporter.ExportTogetherGroups(
  TrainmanJiaolu: RRsTrainmanJiaolu; FileName: string);
begin

end;

procedure TGroupXlsExporter.ImportGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string;UserID,UserNumber,UserName : string);
begin
  case TrainmanJiaolu.nJiaoluType of
  jltNamed :
    begin
      ImportNamedGroups(TrainmanJiaolu,FileName,UserID,UserNumber,UserName);
    end;
  jltOrder :
    begin
      ImportOrderGroups(TrainmanJiaolu,FileName);
    end;
  jltTogether :
    begin
      ImportTogetherGroups(TrainmanJiaolu,FileName);
    end;
  end;
end;


procedure TGroupXlsExporter.ImportNamedGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string;UserID,UserNumber,UserName : string);
var
  excelApp,workSheet: Variant;
  nIndex,nTotalCount : integer;
  strNo:string ;
  namedGroup : RRsNamedGroup;
  trainman1 : RRsTrainman ;
  trainman2 : RRsTrainman ;
  trainman3 : RRsTrainman ;
  trainman4 : RRsTrainman ;
  strTrainmanNumber : string ;
  InputDelTm: TRsLCTrainmanAddInput;
  NamedGrpInputParam: TRsLCNamedGrpInputParam;
  NoFocusProgress: TNoFocusProgress;
begin
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  InputDelTm := TRsLCTrainmanAddInput.Create;
  NamedGrpInputParam := TRsLCNamedGrpInputParam.Create;
  NoFocusProgress := TNoFocusProgress.Create;
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    excelApp.workBooks.Open(FileName);
    workSheet := excelApp.Worksheets[1];
    workSheet.activate;
    //�ӵڶ��п�ʼ����һ���Ǳ���
    nIndex := 2;
    nTotalCount := 0;

    //�����ж��ٸ�������
    while true do
    begin
      strNo := excelApp.Cells[nIndex,COL_INDEX_NAMED_SN];
      if strNo = '' then
        break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;

    if nTotalCount = 0 then
    begin
       Application.MessageBox('û�пɵ���Ľ�·��Ϣ��','��ʾ',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    //�ӵ����п�ʼ{������Ϊʵ�ʵĳ�����Ϣ}
    nIndex := 3;
    //������Ϣ
    namedGroup.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;

    InputDelTm.TrainmanJiaolu.jiaoluID := trainmanJiaolu.strTrainmanJiaoluGUID;
    InputDelTm.TrainmanJiaolu.jiaoluName := trainmanJiaolu.strTrainmanJiaoluName;
    InputDelTm.TrainmanJiaolu.jiaoluType := Ord(trainmanJiaolu.nJiaoluType);
    InputDelTm.DutyUser.strDutyGUID := UserID;
    InputDelTm.DutyUser.strDutyNumber := UserNumber;
    InputDelTm.DutyUser.strDutyName := UserName;

    NamedGrpInputParam.TrainmanJiaolu.jiaoluID := trainmanJiaolu.strTrainmanJiaoluGUID;
    NamedGrpInputParam.TrainmanJiaolu.jiaoluName := trainmanJiaolu.strTrainmanJiaoluName;
    NamedGrpInputParam.TrainmanJiaolu.jiaoluType := Ord(trainmanJiaolu.nJiaoluType);

    NamedGrpInputParam.DutyUser.strDutyGUID := UserID;
    NamedGrpInputParam.DutyUser.strDutyNumber := UserNumber;
    NamedGrpInputParam.DutyUser.strDutyName := UserName;




    for nIndex := 3 to nTotalCount + 1 do
    begin
     //�ռ�����
      namedGroup.strCheciGUID := NewGUID;
      namedGroup.nCheciOrder := StrToInt(excelApp.Cells[nIndex,COL_INDEX_NAMED_SN]);
      namedGroup.strCheci1 := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINNO1];
      namedGroup.strCheci2 := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINNO2];
      if excelApp.Cells[nIndex,COL_INDEX_NAMED_ISREST]  = '��' then
        namedGroup.nCheciType :=  cctCheci
      else
        namedGroup.nCheciType := cctRest;

      //��ȡ�ĸ���Ա��Ϣ
      trainman1.strTrainmanGUID := '';
      strTrainmanNumber := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINMAN1_NUMBER];
      if strTrainmanNumber <> '' then
      begin
        if m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman1) then
        begin
          InputDelTm.TrainmanNumber := strTrainmanNumber;
          m_RsLCNameBoardEx.Group.DeleteTrainman(InputDelTm);
          namedGroup.Group.Trainman1 := trainman1 ;
        end;
      end;

      trainman2.strTrainmanGUID := '';
      strTrainmanNumber := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINMAN2_NUMBER];
      if strTrainmanNumber <> '' then
      begin
        if m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman2) then
        begin
          //ɾ��ԭ�ȵ���Ա
          InputDelTm.TrainmanNumber := strTrainmanNumber;
          m_RsLCNameBoardEx.Group.DeleteTrainman(InputDelTm);
          namedGroup.Group.Trainman2 := trainman2 ;
        end;
      end;


      trainman3.strTrainmanGUID := '';
      strTrainmanNumber := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINMAN3_NUMBER];
      if strTrainmanNumber <> '' then
      begin
        if m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman3) then
        begin
          //ɾ��ԭ�ȵ���Ա
          InputDelTm.TrainmanNumber := strTrainmanNumber;
          m_RsLCNameBoardEx.Group.DeleteTrainman(InputDelTm);
          namedGroup.Group.Trainman3 := trainman3 ;
        end;
      end;


      trainman4.strTrainmanGUID := '';
      strTrainmanNumber := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINMAN4_NUMBER];
      if strTrainmanNumber <> '' then
      begin
        if m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman4) then
        begin
          //ɾ��ԭ�ȵ���Ա
          InputDelTm.TrainmanNumber := strTrainmanNumber;
          m_RsLCNameBoardEx.Group.DeleteTrainman(InputDelTm);
          namedGroup.Group.Trainman4 := trainman4 ;
        end;
      end;

      namedGroup.Group.strGroupGUID := NewGUID;

      NamedGrpInputParam.CheciGUID :=  namedGroup.strCheciGUID;

      NamedGrpInputParam.CheciOrder := namedGroup.nCheciOrder;

      NamedGrpInputParam.CheciType := Ord(namedGroup.nCheciType);
      NamedGrpInputParam.Checi1 := namedGroup.strCheci1;
      NamedGrpInputParam.Checi2 := namedGroup.strCheci2;
      NamedGrpInputParam.TrainmanNumber1 := namedGroup.Group.Trainman1.strTrainmanNumber;
      NamedGrpInputParam.TrainmanNumber2 := namedGroup.Group.Trainman2.strTrainmanNumber;
      NamedGrpInputParam.TrainmanNumber3 := namedGroup.Group.Trainman3.strTrainmanNumber;
      NamedGrpInputParam.TrainmanNumber4 := namedGroup.Group.Trainman4.strTrainmanNumber;

      m_RsLCNameBoardEx.Named.Group.Add(NamedGrpInputParam);

      NoFocusProgress.Step(nIndex - 1,nTotalCount,'���ڵ��뽻·��Ϣ�����Ժ�');
    end;
  finally
    NoFocusProgress.Free;
    excelApp.Quit;
    excelApp := Unassigned;
    InputDelTm.Free;
    NamedGrpInputParam.Free;

  end;
  Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
end;

procedure TGroupXlsExporter.ImportOrderGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string);
begin
  BoxErr('��֧���ֳ�ʽ����');
end;

procedure TGroupXlsExporter.ImportTogetherGroups(
  TrainmanJiaolu: RRsTrainmanJiaolu; FileName: string);
begin
     BoxErr('��֧�ְ���ʽ����');
end;

end.
