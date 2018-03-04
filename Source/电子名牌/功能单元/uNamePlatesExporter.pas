unit uNamePlatesExporter;

interface
uses
  Classes,SysUtils,Contnrs,uJsonSerialize,Comobj,Variants,Windows,Math;
type
  {$region '人员'}
  TNpTm = class(TSerialPersistent)
  private
    m_Name: string;
    m_Number: string;
  published
    property Name: string read m_Name write m_Name;
    property Number: string read m_Number write m_Number;
  end;


  TNpTmList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpTm;
    procedure SetItem(Index: Integer; AObject: TNpTm);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpTm read GetItem write SetItem; default;
  end;
  {$endregion}

  {$region '机组'}
  TNpGrp = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_Tm1: TNpTm;
    m_Tm2: TNpTm;
    m_Tm3: TNpTm;
  published
    property Tm1: TNpTm read m_Tm1 write m_Tm1;
    property Tm2: TNpTm read m_Tm2 write m_Tm2;
    property Tm3: TNpTm read m_Tm3 write m_Tm3;
  end;


  TNpGrpList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpGrp;
    procedure SetItem(Index: Integer; AObject: TNpGrp);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpGrp read GetItem write SetItem; default;
  end;
  {$endregion}

  {$region '记名式名牌'}
  TNpNamed = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_Cc1: string;
    m_Cc2: string;
    m_NeedRest: Boolean;
    m_Grp: TNpGrp;
  published
    property Cc1: string read m_Cc1 write m_Cc1;
    property Cc2: string read m_Cc2 write m_Cc2;
    property NeedRest: Boolean read m_NeedRest write m_NeedRest;
    property Grp: TNpGrp read m_Grp;
  end;



  TNpNamedList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpNamed;
    procedure SetItem(Index: Integer; AObject: TNpNamed);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpNamed read GetItem write SetItem; default;
  end;

  {$endregion}

  {$region '轮乘名牌'}
  TNpOrder = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_Grp: TNpGrp;
  published
    property Grp: TNpGrp read m_Grp;
  end;

  TNpOrderList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpOrder;
    procedure SetItem(Index: Integer; AObject: TNpOrder);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpOrder read GetItem write SetItem; default;
  end;


  {$endregion}

  {$region '包乘名牌'}
  TNpTrain = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_GrpList: TNpGrpList;
    m_TypeName: string;
    m_Number: string;
  published
    property TypeName: string read m_TypeName write m_TypeName;
    property Number: string read m_Number write m_Number;
    property GrpList: TNpGrpList read m_GrpList;
  end;


  TNpTrainList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpTrain;
    procedure SetItem(Index: Integer; AObject: TNpTrain);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpTrain read GetItem write SetItem; default;
  end;

  {$endregion}

  {$region '非运转'}
  TNpLeave = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_Name: string;
    m_TmList: TNpTmList;
  published
    property Name: string read m_Name write m_Name;
    property TmList: TNpTmList read m_TmList;
  end;

  TNpLeaveList = class(TSerialObjectList)
  protected
    function GetItem(Index: Integer): TNpLeave;
    procedure SetItem(Index: Integer; AObject: TNpLeave);
  public
    function GetSerialClass: TPersistentClass;override;
    property Items[Index: Integer]: TNpLeave read GetItem write SetItem; default;
  end;
  {$endregion}

  TNamePlatesExport = class
  public
    //记名式交路
    class procedure ExportPlates(const FileName,JlName: string;NpLst: TNpNamedList);overload;
    //轮乘交路
    class procedure ExportPlates(const FileName,JlName: string;NpLst: TNpOrderList);overload;
    //包乘交路
    class procedure ExportPlates(const FileName,JlName: string;NpTrainLst: TNpTrainList);overload;
    //非运转
    class procedure ExportPlates(const FileName,JlName: string;NpLeaveLst: TNpLeaveList);overload;
    //预备
    class procedure ExportPlates(const FileName,JlName: string;NpTmLst: TNpTmList);overload;
    //未在牌
    class procedure ExportPlates(const FileName: string;NpTmLst: TNpTmList);overload;
    //调休
    class procedure ExportPlates(const FileName,JlName: string;LessThanOneDay,MoreThanOneDay: TNpOrderList);overload;
  end;
implementation

type
  TXls = class
  private
    MSExcel: OleVariant;
    MSExcelWorkBook: OleVariant;
    MSExcelWorkSheet: OleVariant;
    m_Version: Double;
    m_DefautExt: string;
    m_Error: string;
  public
    function Open(): Boolean;
    class procedure SetColWidth(Sheet: OleVariant;Col,Width: integer);
    //Range   A1:B2
    class procedure Merge(Sheet: OleVariant;Range: string);
    class procedure FontBold(Sheet: OleVariant;Range: string);
    class procedure SetBorder(Sheet: OleVariant;Range: string);
    procedure Save(const FileName: string);
    procedure Close();
  end;

  TXlsExport = class
  protected
    procedure FillHead(Sheet: OleVariant);virtual;
    procedure FillData(Sheet: OleVariant);virtual;
    procedure FillFooter(Sheet: OleVariant);virtual;
  public
    procedure ExportToXls(const FileName: string);
  end;

  TNamedExport = class(TXlsExport)
  public
    constructor Create(jlName: string;NpNamedLst: TNpNamedList);
  protected
    m_JlName: string;
    m_NpNamedLst: TNpNamedList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;



  TOrderExport = class(TXlsExport)
  public
    constructor Create(jlName: string;NpLst: TNpOrderList);
  protected
    m_JlName: string;
    m_NpLst: TNpOrderList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;


  TTogetherExport = class(TXlsExport)
  public
    constructor Create(jlName: string;NpLst: TNpTrainList);
  protected
    m_JlName: string;
    m_NpLst: TNpTrainList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;


  TPrepareExport = class(TXlsExport)
  public
    constructor Create(jlName: string;NpLst: TNpTmList);
  protected
    m_JlName: string;
    m_NpLst: TNpTmList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;

  TUnrunExport = class(TXlsExport)
  public
    constructor Create(jlName: string;NpLst: TNpLeaveList);
  protected
    m_JlName: string;
    m_NpLst: TNpLeaveList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;

  TNullPalateExport = class(TXlsExport)
  public
    constructor Create(NpLst: TNpTmList);
  protected
    m_NpLst: TNpTmList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;


  TTxPlateExport = class(TXlsExport)
  public
    constructor Create(jlName: string;LessThanOneDay,MoreThanOneDay: TNpOrderList);
  protected
    m_JlName: string;
    m_LessThanOneDay,m_MoreThanOneDay: TNpOrderList;
    procedure FillHead(Sheet: OleVariant);override;
    procedure FillData(Sheet: OleVariant);override;
  end;

function TNpTmList.GetItem(Index: Integer): TNpTm;
begin
  result := TNpTm(inherited GetItem(Index));
end;
function TNpTmList.GetSerialClass: TPersistentClass;
begin
  Result := TNpTm;
end;

procedure TNpTmList.SetItem(Index: Integer; AObject: TNpTm);
begin
  Inherited SetItem(Index,AObject);
end;

function TNpGrpList.GetItem(Index: Integer): TNpGrp;
begin
  result := TNpGrp(inherited GetItem(Index));
end;
function TNpGrpList.GetSerialClass: TPersistentClass;
begin
  Result := TNpGrp;
end;

procedure TNpGrpList.SetItem(Index: Integer; AObject: TNpGrp);
begin
  Inherited SetItem(Index,AObject);
end;


function TNpTrainList.GetItem(Index: Integer): TNpTrain;
begin
  result := TNpTrain(inherited GetItem(Index));
end;
function TNpTrainList.GetSerialClass: TPersistentClass;
begin
  Result := TNpTrain;
end;

procedure TNpTrainList.SetItem(Index: Integer; AObject: TNpTrain);
begin
  Inherited SetItem(Index,AObject);
end;


function TNpNamedList.GetItem(Index: Integer): TNpNamed;
begin
  result := TNpNamed(inherited GetItem(Index));
end;
function TNpNamedList.GetSerialClass: TPersistentClass;
begin
  Result := TNpNamed;
end;

procedure TNpNamedList.SetItem(Index: Integer; AObject: TNpNamed);
begin
  Inherited SetItem(Index,AObject);
end;



function TNpOrderList.GetItem(Index: Integer): TNpOrder;
begin
  result := TNpOrder(inherited GetItem(Index));
end;
function TNpOrderList.GetSerialClass: TPersistentClass;
begin
  Result := TNpOrder;
end;

procedure TNpOrderList.SetItem(Index: Integer; AObject: TNpOrder);
begin
  Inherited SetItem(Index,AObject);
end;


function TNpLeaveList.GetItem(Index: Integer): TNpLeave;
begin
  result := TNpLeave(inherited GetItem(Index));
end;
function TNpLeaveList.GetSerialClass: TPersistentClass;
begin
  Result := TNpLeave;
end;

procedure TNpLeaveList.SetItem(Index: Integer; AObject: TNpLeave);
begin
  Inherited SetItem(Index,AObject);      
end;                                                     
{ TNamePlatesExport }

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  NpTrainLst: TNpTrainList);
var
  TogetherExport: TTogetherExport;
begin
  TogetherExport := TTogetherExport.Create(JlName,NpTrainLst);
  try
    TogetherExport.ExportToXls(FileName);
  finally
    TogetherExport.Free;
  end;
end;

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  NpLst: TNpOrderList);
var
  OrderExport: TOrderExport;
begin
  OrderExport := TOrderExport.Create(JlName,NpLst);
  try
    OrderExport.ExportToXls(FileName);
  finally
    OrderExport.Free;
  end;
end;

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  NpLst: TNpNamedList);
var
  NamedExport: TNamedExport;
begin
  NamedExport := TNamedExport.Create(JlName,NpLst);
  try
    NamedExport.ExportToXls(FileName);
  finally
    NamedExport.Free;
  end;

end;

class procedure TNamePlatesExport.ExportPlates(const FileName: string;
  NpTmLst: TNpTmList);
var
  NullPalateExport: TNullPalateExport;
begin
  NullPalateExport := TNullPalateExport.Create(NpTmLst);
  try
    NullPalateExport.ExportToXls(FileName);
  finally
    NullPalateExport.Free;
  end;
end;

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  NpTmLst: TNpTmList);
var
  PrepareExport: TPrepareExport;
begin
  PrepareExport := TPrepareExport.Create(JlName,NpTmLst);
  try
    PrepareExport.ExportToXls(FileName);
  finally
    PrepareExport.Free;
  end;
end;

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  NpLeaveLst: TNpLeaveList);
var
  UnrunExport: TUnrunExport;
begin
  UnrunExport := TUnrunExport.Create(JlName,NpLeaveLst);
  try
    UnrunExport.ExportToXls(FileName);
  finally
    UnrunExport.Free;
  end;
end;

class procedure TNamePlatesExport.ExportPlates(const FileName, JlName: string;
  LessThanOneDay, MoreThanOneDay: TNpOrderList);
var
  TxPlateExport: TTxPlateExport;
begin
  TxPlateExport := TTxPlateExport.Create(JlName,LessThanOneDay, MoreThanOneDay);
  try
    TxPlateExport.ExportToXls(FileName);
  finally
    TxPlateExport.Free;
  end;
end;

{ TNpGrp }

constructor TNpGrp.Create;
begin
  inherited;
  m_Tm1 := TNpTm.Create;
  m_Tm2 := TNpTm.Create;
  m_Tm3 := TNpTm.Create;
end;

destructor TNpGrp.Destroy;
begin
  m_Tm1.Free;
  m_Tm2.Free;
  m_Tm3.Free;
  inherited;
end;

{ TNpNamed }

constructor TNpNamed.Create;
begin
  inherited;
  m_Grp := TNpGrp.Create;
end;

destructor TNpNamed.Destroy;
begin
  m_Grp.Free;
  inherited;
end;

{ TNpOrder }

constructor TNpOrder.Create;
begin
  inherited;
  m_Grp := TNpGrp.Create;
end;

destructor TNpOrder.Destroy;
begin
  m_Grp.Free;
  inherited;
end;

{ TNpTrain }

constructor TNpTrain.Create;
begin
  inherited;
  m_GrpList := TNpGrpList.Create;
end;

destructor TNpTrain.Destroy;
begin
  m_GrpList.Free;
  inherited;
end;

{ TNpLeave }

constructor TNpLeave.Create;
begin
  inherited;
  m_TmList := TNpTmList.Create;
end;

destructor TNpLeave.Destroy;
begin
  m_TmList.Free;
  inherited;
end;

{ TXls }

procedure TXls.Close;
begin
  MSExcel.Quit;
end;


class procedure TXls.FontBold(Sheet: OleVariant; Range: string);
var
  oleRange: OleVariant;
begin
  oleRange := Sheet.range[Range];
  oleRange.Font.Bold := True;
end;

class procedure TXls.Merge(Sheet: OleVariant; Range: string);
var
  oleRange: OleVariant;
begin
  oleRange := Sheet.range[Range];
  oleRange.Merge();
end;

function TXls.Open: Boolean;
begin
  Result := False;
  try
    MSExcel := CreateOleObject('Excel.Application');
    MSExcel.DisplayAlerts := 0;

    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];
  except
    ON E: Exception do
    begin
      m_Error := '打开EXCEL失败:' + E.Message;
      Exit;
    end;
  end;


  if TryStrToFloat(MSExcel.Version,m_Version) then
  begin
    if m_Version >= 12 then
      m_DefautExt := '.xlsx'
    else
      m_DefautExt := '.xls';
  end
  else
    m_DefautExt := '.xls';


  Result := True;

end;

procedure TXls.Save(const FileName: string);
begin
  MSExcelWorkBook.SaveAs(FileName);
end;

class procedure TXls.SetBorder(Sheet: OleVariant; Range: string);
var
  objRange: OleVariant;
begin
  objRange := Sheet.range[Range];
  objRange.borders.linestyle:=1;
end;

class procedure TXls.SetColWidth(Sheet: OleVariant; Col,Width: integer);
var
  range: OleVariant;
begin
  range := Sheet.Columns[Col];
  range.ColumnWidth := Width;
end;

{ TXlsExport }

procedure TXlsExport.ExportToXls(const FileName: string);
var
  Xls: TXls;
  FullName: string;
begin
  Xls := TXls.Create;
  try
    if not Xls.Open() then
    begin
      Raise Exception.Create(Xls.m_Error);
    end;
    try
      FillHead(Xls.MSExcelWorkSheet);
      FillData(Xls.MSExcelWorkSheet);
      FillFooter(Xls.MSExcelWorkSheet);
      if ExtractFileExt(FileName) = '' then
        FullName := FileName + Xls.m_DefautExt
      else
        FullName := FileName;

      Xls.Save(FullName);
    finally
      Xls.Close();
    end;
  finally
    Xls.Free;
  end;

end;


procedure TXlsExport.FillData(Sheet: OleVariant);
begin

end;

procedure TXlsExport.FillFooter(Sheet: OleVariant);
begin

end;

procedure TXlsExport.FillHead(Sheet: OleVariant);
begin

end;

{ TNamedExport }

constructor TNamedExport.Create(jlName: string; NpNamedLst: TNpNamedList);
begin
  m_JlName := jlName;
  m_NpNamedLst := NpNamedLst;
end;

procedure TNamedExport.FillData(Sheet: OleVariant);
var
  strText : string;
  Row: integer;
  I: Integer;
begin
  for I := 0 to m_NpNamedLst.Count - 1 do
  begin
    Row := i + 3;
    Sheet.Cells[Row,1] := IntToStr(i + 1) ;
    if m_NpNamedLst[i].NeedRest then
      strText := '是'
    else
      strText := '否' ;
    Sheet.Cells[Row,2] := strText ;
    Sheet.Cells[Row,3] := m_NpNamedLst[i].Cc1;
    Sheet.Cells[Row,4] := m_NpNamedLst[i].Cc2;

    Sheet.Cells[Row,5] :=  m_NpNamedLst[i].Grp.Tm1.Number;
    Sheet.Cells[Row,6] :=  m_NpNamedLst[i].Grp.Tm1.Name;

    Sheet.Cells[Row,7] :=  m_NpNamedLst[i].Grp.Tm2.Number;
    Sheet.Cells[Row,8] :=  m_NpNamedLst[i].Grp.Tm2.Name;
    
    Sheet.Cells[Row,9] :=  m_NpNamedLst[i].Grp.Tm3.Number;
    Sheet.Cells[Row,10] :=  m_NpNamedLst[i].Grp.Tm3.Name;
  end;


  TXls.SetBorder(Sheet,Format('A1:J%d',[m_NpNamedLst.Count + 3]));
end;


procedure TNamedExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.SetColWidth(Sheet,1,18);
  TXls.Merge(Sheet,'A1:D1');
  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;

  TXls.Merge(Sheet,'E1:J1');
  Sheet.Cells[1,5] := '机组信息' ;

  Sheet.Cells[2,1] := '序号' ;
  Sheet.Cells[2,2] := '是否休班' ;
  Sheet.Cells[2,3] := '车次1' ;
  Sheet.Cells[2,4] := '车次2' ;

  Sheet.Cells[2,5] := '工号1' ;
  Sheet.Cells[2,6] := '姓名1' ;

  Sheet.Cells[2,7] := '工号2' ;
  Sheet.Cells[2,8] := '姓名2' ;

  Sheet.Cells[2,9] := '工号3' ;
  Sheet.Cells[2,10] := '姓名3' ;
end;

{ TOrderExport }

constructor TOrderExport.Create(jlName: string; NpLst: TNpOrderList);
begin
  m_JlName := jlName;
  m_NpLst := NpLst;
end;

procedure TOrderExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I: Integer;
begin
  for I := 0 to m_NpLst.Count - 1 do
  begin
    Row := i + 3;
    Sheet.Cells[Row,1] := IntToStr(i + 1) ;

    Sheet.Cells[Row,2] :=  m_NpLst[i].Grp.Tm1.Number;
    Sheet.Cells[Row,3] :=  m_NpLst[i].Grp.Tm1.Name;

    Sheet.Cells[Row,4] :=  m_NpLst[i].Grp.Tm2.Number;
    Sheet.Cells[Row,5] :=  m_NpLst[i].Grp.Tm2.Name;

    Sheet.Cells[Row,6] :=  m_NpLst[i].Grp.Tm3.Number;
    Sheet.Cells[Row,7] :=  m_NpLst[i].Grp.Tm3.Name;
  end;

  TXls.SetBorder(Sheet,Format('A1:G%d',[m_NpLst.Count + 2]));
end;

procedure TOrderExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.Merge(Sheet,'A1:G1');
  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;

  Sheet.Cells[2,1] := '序号' ;

  Sheet.Cells[2,2] := '工号1' ;
  Sheet.Cells[2,3] := '姓名1' ;

  Sheet.Cells[2,4] := '工号2' ;
  Sheet.Cells[2,5] := '姓名2' ;

  Sheet.Cells[2,6] := '工号3' ;
  Sheet.Cells[2,7] := '姓名3' ;
end;

{ TTogetherExport }

constructor TTogetherExport.Create(jlName: string; NpLst: TNpTrainList);
begin
  m_JlName := jlName;
  m_NpLst := NpLst;
end;

procedure TTogetherExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I, J: Integer;
begin
  Row := 3;
  for I := 0 to m_NpLst.Count - 1 do
  begin



    Sheet.Cells[Row,2] := m_NpLst[i].TypeName + '-' + m_NpLst[i].Number;


    if m_NpLst[i].GrpList.Count = 0 then
    begin
      Sheet.Cells[Row,1] := IntToStr(Row - 2) ;
      Inc(Row);
    end
    else
    begin
      TXls.Merge(Sheet,Format('B%d:B%d',[Row,Row + m_NpLst[i].GrpList.Count - 1]));
      
      for J := 0 to m_NpLst[i].GrpList.Count - 1 do
      begin
        Sheet.Cells[Row,1] := IntToStr(Row - 2) ;


        Sheet.Cells[Row,3] :=  m_NpLst[i].GrpList[j].Tm1.Number;
        Sheet.Cells[Row,4] :=  m_NpLst[i].GrpList[j].Tm1.Name;

        Sheet.Cells[Row,5] :=  m_NpLst[i].GrpList[j].Tm2.Number;
        Sheet.Cells[Row,6] :=  m_NpLst[i].GrpList[j].Tm2.Name;

        Sheet.Cells[Row,7] :=  m_NpLst[i].GrpList[j].Tm3.Number;
        Sheet.Cells[Row,8] :=  m_NpLst[i].GrpList[j].Tm3.Name;
        Inc(Row);
      end;
    end;



  end;

  Dec(Row);
  TXls.SetBorder(Sheet,Format('A1:H%d',[Row]));
end;

procedure TTogetherExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.Merge(Sheet,'A1:H1');

  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;

  Sheet.Cells[2,1] := '序号' ;

  Sheet.Cells[2,2] := '机车' ;
  
  Sheet.Cells[2,3] := '工号1' ;
  Sheet.Cells[2,4] := '姓名1' ;

  Sheet.Cells[2,5] := '工号2' ;
  Sheet.Cells[2,6] := '姓名2' ;

  Sheet.Cells[2,7] := '工号3' ;
  Sheet.Cells[2,8] := '姓名3' ;
end;

{ TPrepareExport }

constructor TPrepareExport.Create(jlName: string; NpLst: TNpTmList);
begin
  m_JlName := jlName;
  m_NpLst := NpLst;
end;

procedure TPrepareExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I: Integer;
begin
  for I := 0 to m_NpLst.Count - 1 do
  begin
    Row := i + 3;
    Sheet.Cells[Row,1] := IntToStr(i + 1) ;

    Sheet.Cells[Row,2] :=  m_NpLst[i].Number;
    Sheet.Cells[Row,3] :=  m_NpLst[i].Name;
  end;

  TXls.SetBorder(Sheet,Format('A1:C%d',[m_NpLst.Count + 2]));
end;


procedure TPrepareExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.Merge(Sheet,'A1:C1');
  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;

  Sheet.Cells[2,1] := '序号' ;

  Sheet.Cells[2,2] := '工号' ;
  Sheet.Cells[2,3] := '姓名' ;
end;

{ TUnrunExport }

constructor TUnrunExport.Create(jlName: string; NpLst: TNpLeaveList);
begin
  m_JlName := jlName;
  m_NpLst := NpLst;
end;

procedure TUnrunExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I: Integer;
  J: Integer;
begin                                      
  Row := 3;
  for I := 0 to m_NpLst.Count - 1 do
  begin
    Sheet.Cells[Row,2] := m_NpLst[i].Name;

    if m_NpLst[i].TmList.Count = 0 then
    begin
      Sheet.Cells[Row,1] := IntToStr(Row - 2) ;
      Inc(Row);
    end
    else
    begin
      TXls.Merge(Sheet,Format('B%d:B%d',[Row,Row + m_NpLst[i].TmList.Count - 1]));
      for J := 0 to m_NpLst[i].TmList.Count - 1 do
      begin

        Sheet.Cells[Row,1] := IntToStr(Row - 2) ;

        Sheet.Cells[Row,3] :=  m_NpLst[i].TmList[j].Number;
        Sheet.Cells[Row,4] :=  m_NpLst[i].TmList[j].Name;
        Inc(Row);
      end;
    end;
  end;

  Dec(Row);
  TXls.SetBorder(Sheet,Format('A1:D%d',[Row]));
end;

procedure TUnrunExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.Merge(Sheet,'A1:D1');
  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;

  Sheet.Cells[2,1] := '序号' ;

  Sheet.Cells[2,2] := '类型' ;

  Sheet.Cells[2,3] := '工号' ;
  Sheet.Cells[2,4] := '姓名' ;
end;

{ TNullPalateExport }

constructor TNullPalateExport.Create(NpLst: TNpTmList);
begin
  m_NpLst := NpLst;
end;

procedure TNullPalateExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I: Integer;
begin
  for I := 0 to m_NpLst.Count - 1 do
  begin
    Row := i + 2;
    Sheet.Cells[Row,1] := IntToStr(i + 1) ;

    Sheet.Cells[Row,2] :=  m_NpLst[i].Number;
    Sheet.Cells[Row,3] :=  m_NpLst[i].Name;
  end;
  TXls.SetBorder(Sheet,Format('A1:C%d',[m_NpLst.Count + 1]));
end;


procedure TNullPalateExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;
  Sheet.Cells[1,1] := '序号' ;
  Sheet.Cells[1,2] := '工号' ;
  Sheet.Cells[1,3] := '姓名' ;
end;


{ TTxPlateExport }

constructor TTxPlateExport.Create(jlName: string;LessThanOneDay, MoreThanOneDay: TNpOrderList);
begin
  m_JlName := jlName;
  m_LessThanOneDay := LessThanOneDay;
  m_MoreThanOneDay := MoreThanOneDay;
end;

procedure TTxPlateExport.FillData(Sheet: OleVariant);
var
  Row: integer;
  I: Integer;
begin
  for I := 0 to m_LessThanOneDay.Count - 1 do
  begin
    Row := i + 4;
    Sheet.Cells[Row,1] :=  m_LessThanOneDay[i].Grp.Tm1.Number;
    Sheet.Cells[Row,2] :=  m_LessThanOneDay[i].Grp.Tm1.Name;

    Sheet.Cells[Row,3] :=  m_LessThanOneDay[i].Grp.Tm2.Number;
    Sheet.Cells[Row,4] :=  m_LessThanOneDay[i].Grp.Tm2.Name;

    Sheet.Cells[Row,5] :=  m_LessThanOneDay[i].Grp.Tm3.Number;
    Sheet.Cells[Row,6] :=  m_LessThanOneDay[i].Grp.Tm3.Name;
  end;

  for I := 0 to m_MoreThanOneDay.Count - 1 do
  begin
    Row := i + 4;
    Sheet.Cells[Row,7] :=  m_LessThanOneDay[i].Grp.Tm1.Number;
    Sheet.Cells[Row,8] :=  m_LessThanOneDay[i].Grp.Tm1.Name;

    Sheet.Cells[Row,9] :=  m_LessThanOneDay[i].Grp.Tm2.Number;
    Sheet.Cells[Row,10] :=  m_LessThanOneDay[i].Grp.Tm2.Name;

    Sheet.Cells[Row,11] :=  m_LessThanOneDay[i].Grp.Tm3.Number;
    Sheet.Cells[Row,12] :=  m_LessThanOneDay[i].Grp.Tm3.Name;
  end;

  TXls.SetBorder(Sheet,Format('A1:G%d',[Max(m_MoreThanOneDay.Count,m_LessThanOneDay.Count) + 3]));
end;
procedure TTxPlateExport.FillHead(Sheet: OleVariant);
begin
  Sheet.columns.HorizontalAlignment:=3;

  TXls.Merge(Sheet,'A1:L1');
  Sheet.Cells[1, 1] := Format('交路:[%s]',[m_JlName]) ;
  
  TXls.Merge(Sheet,'A2:F2');
  Sheet.Cells[2, 1] := '调休1天';

  TXls.Merge(Sheet,'G2:L2');
  Sheet.Cells[2, 7] := '调休2天';


  TXls.Merge(Sheet,'A3:B3');
  Sheet.Cells[3, 1] := '乘务员1';

  TXls.Merge(Sheet,'C3:D3');
  Sheet.Cells[3, 3] := '乘务员2';

  TXls.Merge(Sheet,'E3:F3');
  Sheet.Cells[3, 5] := '乘务员3';

  TXls.Merge(Sheet,'G3:H3');
  Sheet.Cells[3, 7] := '乘务员1';

  TXls.Merge(Sheet,'I3:J3');
  Sheet.Cells[3, 9] := '乘务员2';

  TXls.Merge(Sheet,'K3:L3');
  Sheet.Cells[3, 11] := '乘务员3';
end;
end.
