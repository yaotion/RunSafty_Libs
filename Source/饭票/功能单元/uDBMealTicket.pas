unit uDBMealTicket;

interface

uses
  SysUtils,Classes,DBXpress,SqlExpr,uTFSystem,uMealTicket,
  uTrainman,DB,ADODB
;

type

  TRsDBLogMealTicket = class(TDBOperate)
  public
    //根据计划车次，饭票，
    function  Query(StartDate,EndDate:TDateTime;DriverCode,ShenHeCode:string;out MealTicketList:TRsMealTicketList):Boolean;
    procedure Log(MealTicket:RRsMealTicket);
  private
    procedure AdoToData(Ado:TADOQuery;var MealTicket:RRsMealTicket);
    procedure DataToAdo( MealTicket:RRsMealTicket;Ado:TADOQuery);
  end;

  {饭票操作类}
  TRsDBMealTicket = class
  public
    constructor Create(Connection:TSQLConnection);
    destructor Destroy();override;
  public
    //获取发放记录
    function  Query(StartDate,EndDate:TDateTime;DriverCode: string;out MealTicketList:TRsMealTicketList):Boolean;
    //根据计划车次，饭票，
    function Insert(MealTicket:RRsMealTicket):Boolean;
    //删除饭票信息
    procedure Delete(PaiBanStr:string;TrainmanNumber:string);
    //更新
    function Update(PaiBanStr:string;TrainmanNumber:string;CanQuanA, CanQuanB, CanQuanC: Integer):Boolean;
    //获取人员信息
    function GetDriverInfo(TrainmanNumber:string;var TrainmanName:string;var TrainmanDepart:string):Boolean;
    //获取审核人信息
    function GetAdminInfo(TrainmanNumber:string;var TrainmanName:string):Boolean;
    //获取该人员的最近饭票时间
    function GetCanQuanLastTime(TrainmanNumber:string;var DateTime:TDateTime):Boolean;
    //是否应领过饭票
    function IsGivedTicket(PaiBanStr:string;TrainmanNumber:string;var CanQuanA,CanQuanB,CanQuanC:Integer):boolean;
  private
    procedure WriteLog(const log: string);
    //派班插入
    function InsertPaiBanInfo(MealTicket:RRsMealTicket):Boolean;
    //餐券插入
    function InsertCanQuanInfo(MealTicket:RRsMealTicket):Boolean;

    //餐券修改
    procedure UpdateCanQuanInfo(PaiBanStr:string;TrainmanNumber:string;CanQuanA, CanQuanB, CanQuanC: Integer);
    //
    procedure UpdatePaiBanInfo(PaiBanStr:string;TrainmanNumber:string;CanQuanA, CanQuanB, CanQuanC: Integer);

    //删除派班
    procedure DeletePaiBanInfo(PaiBanStr:string;TrainmanNumber:string);
    //删除饭票
    procedure DeleteCanQuanInfo(PaiBanStr:string;TrainmanNumber:string);
    //存在派班信息
    function IsExistPanBanInfo(PaiBanStr:string):Boolean;
    // 是否存在饭票信息
    function IsExistCanQuanInfo(PaiBanStr:string;TrainmanNumber:string):Boolean;
    //餐券是否是空的 餐券表里面
    function IsEmptyCanQuanInfo(PaiBanStr:string):Boolean;
  private
    procedure CanQuanDataToQuery(SQLQuery:TSQLQuery;MealTicket:RRsMealTicket);
    procedure PaiBanDataToQuery(SQLQuery:TSQLQuery;MealTicket:RRsMealTicket);
  private
    m_sqlConnection:TSQLConnection;
    m_OnLog: TOnEventByString;
  public
    property OnLog: TOnEventByString read m_OnLog write m_OnLog;
  end;

implementation

{ TRsDBMealTicket }

procedure TRsDBMealTicket.CanQuanDataToQuery(SQLQuery: TSQLQuery;
  MealTicket: RRsMealTicket);
begin
  with SQLQuery.Params do
  begin
    //ParamByName('CANJUAN_INFO_ID').Value :=  MealTicket.CANJUAN_INFO_ID;
    ParamByName('PAIBAN_STR').Value :=  MealTicket.PAIBAN_STR;

    ParamByName('DRIVER_CODE').AsString :=  MealTicket.DRIVER_CODE ;
    ParamByName('DRIVER_NAME').AsString :=  MealTicket.DRIVER_NAME ;
    ParamByName('CHEJIAN_NAME').AsString := MealTicket.CHEJIAN_NAME ;
    ParamByName('CANQUAN_A').AsInteger :=  MealTicket.CANQUAN_A ;
    ParamByName('CANQUAN_B').AsInteger :=  MealTicket.CANQUAN_B ;
    ParamByName('CANQUAN_C').AsInteger :=  MealTicket.CANQUAN_C ;

    ParamByName('PAIBAN_CHECI').AsString :=  MealTicket.PAIBAN_CHECI  ;
    ParamByName('CHUQIN_TIME').AsString :=  MealTicket.CHUQIN_TIME ;
    ParamByName('CHUQIN_YEAR').AsInteger :=  MealTicket.CHUQIN_YEAR ;
    ParamByName('CHUQIN_MONTH').AsInteger :=  MealTicket.CHUQIN_MONTH ;
    ParamByName('CHUQIN_DAY').AsInteger :=  MealTicket.CHUQIN_DAY ;
    ParamByName('CHUQIN_YMD').AsInteger :=  MealTicket.CHUQIN_YMD ;
    ParamByName('CHUQIN_DEPART').AsString :=  MealTicket.CHUQIN_DEPART ;

    ParamByName('SHENHEREN_CODE').AsString :=  MealTicket.SHENHEREN_CODE ;
    ParamByName('SHENHEREN_NAME').AsString :=  MealTicket.SHENHEREN_NAME ;
    ParamByName('CHECK_FLAG').AsInteger :=  MealTicket.CHECK_FLAG ;

    ParamByName('REC_TIME').AsString :=  MealTicket.REC_TIME ;
  end;
end;

constructor TRsDBMealTicket.Create(Connection: TSQLConnection);
begin
  inherited Create();
  m_sqlConnection := Connection ;
end;


procedure TRsDBMealTicket.Delete(PaiBanStr:string;TrainmanNumber:string);
var
  iA,iB,iC:Integer;
begin
  //如果已经领取过饭票，就不在删除了
  if IsGivedTicket(PaiBanStr,TrainmanNumber,iA,iB,iC) then
    Exit;
  
  DeleteCanQuanInfo(PaiBanStr,TrainmanNumber);
  if IsEmptyCanQuanInfo(PaiBanStr) then
    DeletePaiBanInfo(PaiBanStr,TrainmanNumber);
end;

procedure TRsDBMealTicket.DeletePaiBanInfo(PaiBanStr, TrainmanNumber: string);
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin

  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('delete from TB_PAIBAN_INFO where PAIBAN_STR = %s ',[
      QuotedStr(PaiBanStr)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      ExecSQL();
    end;
  finally
    sqlQuery.Free;
  end;
end;

procedure TRsDBMealTicket.DeleteCanQuanInfo(PaiBanStr, TrainmanNumber: string);
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('delete from TB_CANJUAN_INFO where PAIBAN_STR = %s and  DRIVER_CODE = %s ',[
      QuotedStr(PaiBanStr),QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      ExecSQL();
    end;
  finally
    sqlQuery.Free;
  end;
end;

destructor TRsDBMealTicket.Destroy;
begin
  m_sqlConnection := nil ;
  inherited;
end;

function TRsDBMealTicket.GetAdminInfo(TrainmanNumber: string;
  var TrainmanName: string):Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select * from TB_USER_INFO where USER_CODE = %s ',
      [QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      Open;
      if not IsEmpty then
      begin
        TrainmanName := FieldByName('USER_NAME').AsString;
        Result := True ;
      end;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.GetCanQuanLastTime(TrainmanNumber:string;var DateTime: TDateTime): Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select GIVE_TIME from TB_CANJUAN_INFO where DRIVER_CODE = %s and GIVE_FLAG = 1 order by GIVE_TIME desc',
      [QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      Open;
      if not IsEmpty then
      begin
        DateTime := FieldByName('GIVE_TIME').AsDateTime;
        Result := True ;
      end;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.GetDriverInfo(TrainmanNumber: string;
  var TrainmanName: string; var TrainmanDepart: string):Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select * from TB_DRIVER_INFO where DRIVER_CODE = %s ',
      [QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      Open;
      if not IsEmpty then
      begin
        TrainmanName := FieldByName('DRIVER_NAME').AsString;
        TrainmanDepart := FieldByName('CHEJIAN_NAME').AsString;
        Result := True ;
      end;
    end;
  finally
    sqlQuery.Free;
  end;
end;



function TRsDBMealTicket.Insert(MealTicket:RRsMealTicket):Boolean;
begin
  if not IsExistPanBanInfo(MealTicket.PAIBAN_STR) then
  begin
    WriteLog('插入派班信息');
     InsertPaiBanInfo(MealTicket);
  end
  else
  begin
    WriteLog('存在派班信息');
  end;
  WriteLog('插入餐券信息');
  InsertCanQuanInfo(MealTicket) ;
  Result := True ;
end;

function TRsDBMealTicket.InsertCanQuanInfo(MealTicket: RRsMealTicket):Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := True ;
  //REC_TIME,GIVE_TIME,CHUQIN_TIME
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    try
      strSql := 'INSERT INTO TB_CANJUAN_INFO (   ' +
        ' CANJUAN_INFO_ID,PAIBAN_STR,DRIVER_CODE,DRIVER_NAME,CHEJIAN_NAME, '+
        ' CANQUAN_A,CANQUAN_B,CANQUAN_C,PAIBAN_CHECI,CHUQIN_TIME,CHUQIN_YEAR, '+
        ' CHUQIN_MONTH,CHUQIN_DAY,CHUQIN_YMD,CHUQIN_DEPART,SHENHEREN_CODE,  '+
        ' SHENHEREN_NAME,CHECK_FLAG,REC_TIME)  '+
        ' VALUES  '+
        '( GEN_ID(GEN_TB_CANJUAN_INFO_ID,1) ,:PAIBAN_STR,:DRIVER_CODE,:DRIVER_NAME,:CHEJIAN_NAME, '+
        ' :CANQUAN_A, :CANQUAN_B,:CANQUAN_C, :PAIBAN_CHECI, :CHUQIN_TIME, :CHUQIN_YEAR, '+
        ' :CHUQIN_MONTH, :CHUQIN_DAY, :CHUQIN_YMD, :CHUQIN_DEPART, :SHENHEREN_CODE,  '+
        ' :SHENHEREN_NAME, :CHECK_FLAG,:REC_TIME ) ';
        with sqlQuery do
        begin
          SQL.Text := strSql;
          CanQuanDataToQuery(sqlQuery,MealTicket);
          ExecSQL();
        end;
        WriteLog('插入餐券成功');
    except
      on e:Exception do
      begin
        WriteLog('插入餐券信息失败:' + E.Message);
        Result := False ;
      end;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.InsertPaiBanInfo(MealTicket: RRsMealTicket):Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  Result := True ;
  try
    try
      strSql := 'INSERT INTO TB_PAIBAN_INFO (   ' +
      ' PAIBAN_INFO_ID,PAIBAN_STR,PAIBAN_CHECI,CHUQIN_TIME,CHUQIN_DEPART,'+
      ' CANQUAN_A,CANQUAN_B,CANQUAN_C, '+
      ' PAIBAN_YEAR,PAIBAN_MONTH,PAIBAN_DAY,PAIBAN_YMD,CHECK_FLAG,'+
      ' SHENHEREN_CODE, SHENHEREN_NAME,REC_TIME)  '+
      ' VALUES  '+
      ' (GEN_ID(GEN_TB_PAIBAN_INFO_ID,1),:PAIBAN_STR,:PAIBAN_CHECI,:CHUQIN_TIME,:CHUQIN_DEPART, '+
      ' :CANQUAN_A, :CANQUAN_B,:CANQUAN_C,'+
      ' :PAIBAN_YEAR, :PAIBAN_MONTH, :PAIBAN_DAY, :PAIBAN_YMD,:CHECK_FLAG,'  +
      ' :SHENHEREN_CODE,:SHENHEREN_NAME,:REC_TIME ) ';
      //strSql := 'INSERT INTO TB_PAIBAN_INFO (PAIBAN_INFO_ID) VALUES  (GEN_ID(GEN_TB_PAIBAN_INFO_ID,1)) ';
      with sqlQuery do
      begin       
        SQL.Text := strSql;
        PaiBanDataToQuery(sqlQuery,MealTicket);
        ExecSQL();
      end;

    except
      on E: Exception do
      begin
        WriteLog('插入派班信息失败:' + E.Message);
        Result := False ;
      end;

    end;
  finally
    sqlQuery.Free;
  end;
end;





function TRsDBMealTicket.IsEmptyCanQuanInfo(PaiBanStr: string): Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select PAIBAN_STR  from TB_CANJUAN_INFO where PAIBAN_STR  = %s ',[
      QuotedStr(PaiBanStr)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      open();
      Result := IsEmpty ;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.IsExistCanQuanInfo(PaiBanStr: string;TrainmanNumber:string): Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select PAIBAN_STR  from TB_CANJUAN_INFO where PAIBAN_STR  = %s and DRIVER_CODE = %s ',[
      QuotedStr(PaiBanStr),QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      open();
      if not IsEmpty then
        Result := True ;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.IsExistPanBanInfo(PaiBanStr: string): Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select PAIBAN_STR from TB_PAIBAN_INFO where PAIBAN_STR = %s',[
      QuotedStr(PaiBanStr)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      open();
      if not IsEmpty then
        Result := True ;
    end;
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.IsGivedTicket(PaiBanStr,
  TrainmanNumber: string;var CanQuanA,CanQuanB,CanQuanC:Integer): boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False ;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select *  from TB_CANJUAN_INFO where PAIBAN_STR  = %s and DRIVER_CODE = %s ',[
      QuotedStr(PaiBanStr),QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      open();
      if not IsEmpty then
      begin
        if sqlQuery.FieldByName('GIVE_FLAG').AsInteger = 1 then
          Result := True
        else
        begin
          CanQuanA := sqlQuery.FieldByName('CANQUAN_A').AsInteger ;
          CanQuanB := sqlQuery.FieldByName('CANQUAN_B').AsInteger ;
          CanQuanC := sqlQuery.FieldByName('CANQUAN_C').AsInteger ;
        end
      end;
    end;
  finally
    sqlQuery.Free;
  end;
end;

procedure TRsDBMealTicket.PaiBanDataToQuery(SQLQuery: TSQLQuery;
  MealTicket: RRsMealTicket);
begin
  with SQLQuery.Params do
  begin
    //ParamByName('PAIBAN_INFO_ID').Value :=  MealTicket.CANJUAN_INFO_ID;
    ParamByName('PAIBAN_STR').Value :=  MealTicket.PAIBAN_STR;

    ParamByName('PAIBAN_CHECI').AsString :=  MealTicket.PAIBAN_CHECI  ;
    ParamByName('CHUQIN_TIME').AsString :=  MealTicket.CHUQIN_TIME ;
    ParamByName('CHUQIN_DEPART').AsString :=  MealTicket.CHUQIN_DEPART ;

    ParamByName('CANQUAN_A').AsInteger :=  MealTicket.CANQUAN_A ;
    ParamByName('CANQUAN_B').AsInteger :=  MealTicket.CANQUAN_B ;
    ParamByName('CANQUAN_C').AsInteger :=  MealTicket.CANQUAN_C ;

    ParamByName('PAIBAN_YEAR').AsInteger :=  MealTicket.CHUQIN_YEAR ;
    ParamByName('PAIBAN_MONTH').AsInteger :=  MealTicket.CHUQIN_MONTH ;
    ParamByName('PAIBAN_DAY').AsInteger :=  MealTicket.CHUQIN_DAY ;
    ParamByName('PAIBAN_YMD').AsInteger :=  MealTicket.CHUQIN_YMD ;

    ParamByName('CHECK_FLAG').AsInteger :=  MealTicket.CHECK_FLAG ;
    ParamByName('SHENHEREN_CODE').AsString :=  MealTicket.SHENHEREN_CODE ;
    ParamByName('SHENHEREN_NAME').AsString :=  MealTicket.SHENHEREN_NAME ;

    ParamByName('REC_TIME').AsString :=  MealTicket.REC_TIME ;
  end;
end;

function TRsDBMealTicket.Query(StartDate, EndDate: TDateTime; DriverCode: string;
  out MealTicketList: TRsMealTicketList): Boolean;
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  Result := False;
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('select * from TB_CANJUAN_INFO where REC_TIME between %s and %s',[
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',StartDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate))]);
    if DriverCode <> '' then
    begin
      strSql := strSql + ' and DRIVER_CODE = ' + QuotedStr(DriverCode);
    end;


    strSql := strSql + 'order by REC_TIME desc' ;

    sqlQuery.SQL.Text := strSql ;
    sqlQuery.Open;
    if sqlQuery.IsEmpty then
      Exit;

    //TSQLQuery 不能使用       RecordCount
    while not sqlQuery.Eof do
    begin
    SetLength(MealTicketList,Length(MealTicketList) + 1);
      with MealTicketList[Length(MealTicketList)  - 1] do
      begin
        DRIVER_CODE := sqlQuery.FieldByName('DRIVER_CODE').AsString;
        DRIVER_NAME := sqlQuery.FieldByName('DRIVER_NAME').AsString;
        CHEJIAN_NAME := sqlQuery.FieldByName('CHEJIAN_NAME').AsString;

        PAIBAN_CHECI := sqlQuery.FieldByName('PAIBAN_CHECI').AsString;
        CHUQIN_TIME :=  sqlQuery.FieldByName('CHUQIN_TIME').AsString;

        CANQUAN_A := sqlQuery.FieldByName('CANQUAN_A').AsInteger;
        CANQUAN_B := sqlQuery.FieldByName('CANQUAN_B').AsInteger;

        SHENHEREN_CODE := sqlQuery.FieldByName('SHENHEREN_CODE').AsString;
        SHENHEREN_NAME := sqlQuery.FieldByName('SHENHEREN_NAME').AsString;

        REC_TIME := sqlQuery.FieldByName('REC_TIME').AsString;
        sqlQuery.Next;
      end;
    end;
   
  finally
    sqlQuery.Free;
  end;
end;

function TRsDBMealTicket.Update(PaiBanStr, TrainmanNumber: string; CanQuanA,
  CanQuanB, CanQuanC: Integer):Boolean;
begin
  Result := False ;
  if not IsExistCanQuanInfo(PaiBanStr,TrainmanNumber) then
  begin
     Exit;
  end;
  UpdateCanQuanInfo(PaiBanStr,TrainmanNumber,CanQuanA,CanQuanB, CanQuanC);
  UpdatePaiBanInfo(PaiBanStr,TrainmanNumber,CanQuanA,CanQuanB, CanQuanC);
  Result := True ;
end;

procedure TRsDBMealTicket.UpdateCanQuanInfo(PaiBanStr, TrainmanNumber: string;
  CanQuanA, CanQuanB, CanQuanC: Integer);
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('update TB_CANJUAN_INFO set CANQUAN_A = %d, CANQUAN_B =%d,CANQUAN_c = %d where PAIBAN_STR = %s ' +
    'and  DRIVER_CODE = %s',[CanQuanA,CanQuanB,CanQuanC,
      QuotedStr(PaiBanStr),QuotedStr(TrainmanNumber)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      ExecSQL();
    end;
  finally
    sqlQuery.Free;
  end;
end;

procedure TRsDBMealTicket.UpdatePaiBanInfo(PaiBanStr, TrainmanNumber: string;
  CanQuanA, CanQuanB, CanQuanC: Integer);
var
  sqlQuery:TSQLQuery;
  strSql:string;
begin
  sqlQuery := TSQLQuery.Create(nil);
  sqlQuery.SQLConnection := m_sqlConnection ;
  try
    strSql := Format('update TB_PAIBAN_INFO set CANQUAN_A = %d, CANQUAN_B =%d,CANQUAN_c = %d where PAIBAN_STR = %s '
    ,[CanQuanA,CanQuanB,CanQuanC,
      QuotedStr(PaiBanStr)]);
    with sqlQuery do
    begin
      SQL.Text := strSql;
      ExecSQL();
    end;
  finally
    sqlQuery.Free;
  end;
end;

procedure TRsDBMealTicket.WriteLog(const log: string);
begin
  if Assigned(m_OnLog) then
    m_OnLog(log);

end;

{ TRsDBLogMealTicket }

procedure TRsDBLogMealTicket.AdoToData(Ado: TADOQuery;
  var MealTicket: RRsMealTicket);
begin
  with Ado do
  begin
    MealTicket.DRIVER_CODE := FieldByName('strDriverCode').AsString;
    MealTicket.DRIVER_NAME := FieldByName('strDriverName').AsString;
    MealTicket.CHEJIAN_NAME := FieldByName('strCheJianName').AsString;

    MealTicket.PAIBAN_CHECI := FieldByName('strCheCi').AsString;
    MealTicket.CHUQIN_TIME :=  FieldByName('dtChuQin').AsString;

    MealTicket.CANQUAN_A := FieldByName('nTicketA').AsInteger;
    MealTicket.CANQUAN_B := FieldByName('nTicketB').AsInteger;

    MealTicket.SHENHEREN_CODE := FieldByName('strFaFangCode').AsString;
    MealTicket.SHENHEREN_NAME := FieldByName('strFaFangName').AsString;

    MealTicket.REC_TIME := FieldByName('dtCreateTime').AsString;
  end;
end;

procedure TRsDBLogMealTicket.DataToAdo(MealTicket: RRsMealTicket;
  Ado: TADOQuery);
begin
  with Ado do
  begin
    FieldByName('strDriverCode').AsString := MealTicket.DRIVER_CODE ;
    FieldByName('strDriverName').AsString := MealTicket.DRIVER_NAME;
    FieldByName('strCheJianName').AsString := MealTicket.CHEJIAN_NAME;

    FieldByName('strCheCi').AsString := MealTicket.PAIBAN_CHECI;
    FieldByName('dtChuQin').AsString := MealTicket.CHUQIN_TIME;

    FieldByName('nTicketA').AsInteger := MealTicket.CANQUAN_A;
    FieldByName('nTicketB').AsInteger := MealTicket.CANQUAN_B ;

    FieldByName('strFaFangCode').AsString := MealTicket.SHENHEREN_CODE;
    FieldByName('strFaFangName').AsString := MealTicket.SHENHEREN_NAME;

    FieldByName('dtCreateTime').AsDateTime := now;
  end;
end;

procedure TRsDBLogMealTicket.Log(MealTicket: RRsMealTicket);
var
  ADOQuery:TADOQuery;
  strSql:string;
begin
  ADOQuery := NewADOQuery;
  try
    strSql := 'select * from TAB_MealTicket_log where 1 = 2 ';
    with ADOQuery do
    begin
      SQL.Text := strSql ;
      Open;
      Append;
      DataToAdo(MealTicket,ADOQuery);
      Post;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLogMealTicket.Query(StartDate, EndDate: TDateTime; DriverCode,
  ShenHeCode: string; out MealTicketList: TRsMealTicketList): Boolean;
var
  ADOQuery:TADOQuery;
  strSql:string;
  i:Integer;
begin
  i := 0 ;
  Result := False;
  ADOQuery := NewADOQuery;
  try
    strSql := Format('select * from TAB_MealTicket_log where dtCreateTime between %s and %s',[
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',StartDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate))]);
    if DriverCode <> '' then
    begin
      strSql := strSql + ' and strDriverCode = ' + QuotedStr(DriverCode);
    end;

    if ShenHeCode <> '' then
    begin
      strSql := strSql + ' and strShenHeCode = ' + QuotedStr(DriverCode);
    end;

    with ADOQuery do
    begin
      SQL.Text := strSql ;
      Open;
      if ADOQuery.IsEmpty then
        Exit;
      SetLength(MealTicketList,ADOQuery.RecordCount);
      while not ADOQuery.Eof do
      begin
        AdoToData(ADOQuery,MealTicketList[i]);
        Inc(i);
        ADOQuery.Next;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
