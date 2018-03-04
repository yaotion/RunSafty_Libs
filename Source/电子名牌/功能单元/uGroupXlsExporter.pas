unit uGroupXlsExporter;

interface

uses
  SysUtils, Variants, Classes,windows,
  uTFSystem,uTrainmanJiaolu,uTrainJiaolu,uTrainman,
  uSaftyEnum,uTrainPlan, uDutyPlace,uLCDutyPlace,uLCTrainPlan,
  uLCNameBoard,uLCTrainJiaolu,uLCNameBoardEx,
  uLCTrainmanMgr,Forms,comobj;
const
  COL_INDEX_NAMED_SN = 1;         //序号
  COL_INDEX_NAMED_ISREST = 2;     //类型
  COL_INDEX_NAMED_TRAINNO1 = 3;   //车次1
  COL_INDEX_NAMED_TRAINNO2 = 4;   //车次2

  COL_INDEX_NAMED_TRAINMAN1_NUMBER = 5;   //工号1
  COL_INDEX_NAMED_TRAINMAN1_NAME = 6;   //工号1

  COL_INDEX_NAMED_TRAINMAN2_NUMBER = 7;   //工号2
  COL_INDEX_NAMED_TRAINMAN2_NAME = 8;   //工号1

  COL_INDEX_NAMED_TRAINMAN3_NUMBER = 9;   //工号3
  COL_INDEX_NAMED_TRAINMAN3_NAME = 10;   //工号1

  COL_INDEX_NAMED_TRAINMAN4_NUMBER = 11;   //工号4
  COL_INDEX_NAMED_TRAINMAN4_NAME = 12;   //工号1
    
type
  //旧版导出导入功能，导出时需要连接服务器读取数据，不再使用导出功能
  //改为使得直接从名牌数组导出为XLS
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
    //导出记名式
    procedure ExportNamedGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);
    //添加头
    procedure AddNamedHead(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //添加正文
    procedure AddNamedContext(excelApp, workBook, workSheet: Variant;NamedGroup:RRsNamedGroup;AOrder:Integer;var Row:Integer);
    //添加结束符
    procedure AddNamedFooter(excelApp, workBook, workSheet: Variant;var Row:Integer);

    //导出轮乘式
    procedure ExportOrderGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);
    //导出包乘式
    procedure ExportTogetherGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);


    //导入记名式交路的机组信息
    procedure ImportNamedGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string;
      UserID,UserNumber,UserName : string);
    //导入轮乘式交路的机组信息
    procedure ImportOrderGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string);
    //导入包乘是交路的机组信息
    procedure ImportTogetherGroups(TrainmanJiaolu : RRsTrainmanJiaolu; FileName:string);
  public
    //导出图定车次excel
    procedure ExportGroups(TrainmanJiaolu : RRsTrainmanJiaolu;FileName:string);

    ///导入交路的机组信息
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
    strText := '是'
  else
    strText := '否' ;
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
  range.borders.linestyle:=1;//设置边框样式
end;

procedure TGroupXlsExporter.AddNamedHead(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
var
  strRange:string;
  col,range: Variant;
begin
  col := workSheet.Columns[1];
  col.ColumnWidth := 18;    //设置附注的宽度
  //标题1
  strRange := Format('A%d:D%d',[Row,Row]);
  range := workSheet.range[strRange];
  range.Merge(true);
  excelApp.Cells[Row, 1] := Format('交路:[%s]',[Title]) ;

   //标题2
  strRange := Format('E%d:L%d',[Row,Row]);
  range := workSheet.range[strRange];
  range.Merge(true);
  excelApp.Cells[Row,5] := '机组信息' ;

  inc(row);
  excelApp.Cells[Row,COL_INDEX_NAMED_SN] := '序号' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_ISREST] := '是否休班' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO1] := '车次1' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINNO2] := '车次2' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NUMBER] := '工号1' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN1_NAME] := '姓名1' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NUMBER] := '工号2' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN2_NAME] := '姓名2' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NUMBER] := '工号3' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN3_NAME] := '姓名3' ;

  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NUMBER] := '工号4' ;
  excelApp.Cells[Row,COL_INDEX_NAMED_TRAINMAN4_NAME] := '姓名4' ;
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
    strError := '你还没有安装Microsoft Excel，请先安装！';
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
    excelApp.Caption := '应用程序调用 Microsoft Excel';
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

    workSheet.columns.HorizontalAlignment:=3;  //居中
    AddNamedHead(excelApp,workBook,workSheet,TrainmanJiaolu.strTrainmanJiaoluName,nRow);

    for i := 0 to Length(namedGroupArray) - 1 do
    begin
      AddNamedContext(excelApp,workBook,workSheet,namedGroupArray[i],i,nRow);
      NoFocusProgress.Step(i + 1,length(namedGroupArray),'正在导出信息，请稍后');
    end;
    AddNamedFooter(excelApp,workBook,workSheet,nRow);

    Box('导出完毕请查看!');
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
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  InputDelTm := TRsLCTrainmanAddInput.Create;
  NamedGrpInputParam := TRsLCNamedGrpInputParam.Create;
  NoFocusProgress := TNoFocusProgress.Create;
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(FileName);
    workSheet := excelApp.Worksheets[1];
    workSheet.activate;
    //从第二行开始，第一行是标题
    nIndex := 2;
    nTotalCount := 0;

    //计算有多少个车次列
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
       Application.MessageBox('没有可导入的交路信息！','提示',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    //从第三行开始{第三行为实际的车次信息}
    nIndex := 3;
    //公共信息
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
     //收集数据
      namedGroup.strCheciGUID := NewGUID;
      namedGroup.nCheciOrder := StrToInt(excelApp.Cells[nIndex,COL_INDEX_NAMED_SN]);
      namedGroup.strCheci1 := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINNO1];
      namedGroup.strCheci2 := excelApp.Cells[nIndex,COL_INDEX_NAMED_TRAINNO2];
      if excelApp.Cells[nIndex,COL_INDEX_NAMED_ISREST]  = '否' then
        namedGroup.nCheciType :=  cctCheci
      else
        namedGroup.nCheciType := cctRest;

      //获取四个人员信息
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
          //删除原先的人员
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
          //删除原先的人员
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
          //删除原先的人员
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

      NoFocusProgress.Step(nIndex - 1,nTotalCount,'正在导入交路信息，请稍后');
    end;
  finally
    NoFocusProgress.Free;
    excelApp.Quit;
    excelApp := Unassigned;
    InputDelTm.Free;
    NamedGrpInputParam.Free;

  end;
  Application.MessageBox('导入完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TGroupXlsExporter.ImportOrderGroups(TrainmanJiaolu: RRsTrainmanJiaolu;
  FileName: string);
begin
  BoxErr('不支持轮乘式导入');
end;

procedure TGroupXlsExporter.ImportTogetherGroups(
  TrainmanJiaolu: RRsTrainmanJiaolu; FileName: string);
begin
     BoxErr('不支持包乘式导入');
end;

end.
