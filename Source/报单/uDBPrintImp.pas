unit uDBPrintImp;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsBDPrint_TLB, StdVcl,SysUtils,Forms,Classes,
  uVariantDict,frxPrinter;

type
  TTmImp = class(TInterfacedObject,ITm)
  private
    m_Number: WideString;
    m_Name: WideString;
    m_ID: WideString;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
  end;
  
  TGrpImp = class(TInterfacedObject,IGrp)
  private
    m_Tm1: ITm;
    m_Tm2: ITm;
    m_Tm3: ITm;
    m_Tm4: ITm;

    function CreateTM: ITm; safecall;
    function Get_Tm1: ITm; safecall;
    procedure Set_Tm1(const Value: ITm); safecall;
    function Get_Tm2: ITm; safecall;
    procedure Set_Tm2(const Value: ITm); safecall;
    function Get_Tm3: ITm; safecall;
    procedure Set_Tm3(const Value: ITm); safecall;
    function Get_Tm4: ITm; safecall;
    procedure Set_Tm4(const Value: ITm); safecall;
  end;
  
  TParamImp = class(TInterfacedObject,IParam)
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_Dict: TVariantDict;
    m_Grp: IGrp;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_TrainNumber: WideString; safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    function Get_TrainTypeName: WideString; safecall;
    procedure Set_TrainTypeName(const Value: WideString); safecall;
    function Get_RemarkType: Integer; safecall;
    procedure Set_RemarkType(Value: Integer); safecall;
    function Get_PlanTime: TDateTime; safecall;
    procedure Set_PlanTime(Value: TDateTime); safecall;
    function Get_Grp: IGrp; safecall;
  end;

  
  TBDPrint = class(TAutoObject, IBDPrint)
  protected
    procedure Print(const Param: IParam); safecall;
    procedure PrintNoPlan; safecall;
    function CreateParam: IParam; safecall;
    procedure ConfigDialog; safecall;
  end;

implementation

uses ComServ,uTrainplan, uGlobal, uPrintTMReport, uFrmPrintTMRpt,uTFSystem,StrUtils,
  uTrainman,uSaftyEnum, RsGlobal_TLB, uFrmTMRptSelect;

procedure TBDPrint.Print(const Param: IParam);
var
  chuqinPlan1,chuqinPlan2:RRSChuQinPlan;
  strErr:string;
begin

  Application.Handle := GlobalDM.AppHandle;
  try
    FillChar(chuqinPlan1,SizeOf(RRSChuQinPlan),0);
    FillChar(chuqinPlan2,SizeOf(RRSChuQinPlan),0);


    chuqinPlan1.TrainPlan.strTrainNo := Param.TrainNo;
    chuqinPlan1.TrainPlan.strTrainNumber := Param.TrainNumber;
    chuqinPlan1.TrainPlan.strTrainTypeName := Param.TrainTypeName;
    chuqinPlan1.TrainPlan.nRemarkType := TRsPlanRemarkType(Param.RemarkType);
    chuqinPlan1.TrainPlan.dtStartTime := Param.PlanTime;

    with chuqinPlan1.ChuQinGroup.Group,Param.Grp do
    begin
      if Tm1 <> nil then
      begin
        Trainman1.strTrainmanGUID := Tm1.ID;
        Trainman1.strTrainmanNumber := Tm1.Number;
        Trainman1.strTrainmanName := Tm1.Name;
      end;

      if Tm2 <> nil then
      begin
        Trainman2.strTrainmanGUID := Tm2.ID;
        Trainman2.strTrainmanNumber := Tm2.Number;
        Trainman2.strTrainmanName := Tm2.Name;
      end;


      if Tm3 <> nil then
      begin
        Trainman3.strTrainmanGUID := Tm3.ID;
        Trainman3.strTrainmanNumber := Tm3.Number;
        Trainman3.strTrainmanName := Tm3.Name;
      end;


      if Tm4 <> nil then
      begin
        Trainman4.strTrainmanGUID := Tm4.ID;
        Trainman4.strTrainmanNumber := Tm4.Number;
        Trainman4.strTrainmanName := Tm4.Name;
      end;


    end;

    if TPrintTMReport.PrintRpt(LeftStr(GlobalDM.Site.Number,2),chuqinPlan1,chuqinPlan2,strErr)= False then
    begin
      Box(strErr);
    end;

    //由于DLL释放顺序问题，必需在卸载DLL前清空打印机，否则退出异常
    frxPrinters.Clear();
  finally
    Application.Handle := 0;
  end;

end;


procedure TBDPrint.PrintNoPlan;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
    g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
    TFrmPrintTMRpt.printTMRpt_NoPlan;
    frxPrinters.Clear();
  finally
    Application.Handle := 0;
  end;

end;

function TBDPrint.CreateParam: IParam;
begin
  Result := TParamImp.Create;
end;

{ TParamImp }

constructor TParamImp.Create;
begin
  m_Dict := TVariantDict.Create;
  m_Grp := TGrpImp.Create;
end;

destructor TParamImp.Destroy;
begin
  m_Dict.Free;
  inherited;
end;

function TParamImp.Get_Grp: IGrp;
begin
  Result := m_Grp;
end;

function TParamImp.Get_PlanTime: TDateTime;
begin
  Result := m_Dict.ValueAsDateTime('PlanTime');
end;

function TParamImp.Get_RemarkType: Integer;
begin
  Result := m_Dict.ValueAsInt('RemarkType');
end;


function TParamImp.Get_TrainNo: WideString;
begin
  Result := m_Dict.ValueAsString('TrainNo');
end;

function TParamImp.Get_TrainNumber: WideString;
begin
  Result := m_Dict.ValueAsString('TrainNumber');
end;

function TParamImp.Get_TrainTypeName: WideString;
begin
  Result := m_Dict.ValueAsString('TrainTypeName');
end;

procedure TParamImp.Set_PlanTime(Value: TDateTime);
begin
  m_Dict.Values['PlanTime'] := Value;
end;

procedure TParamImp.Set_RemarkType(Value: Integer);
begin
  m_Dict.Values['RemarkType'] := Value;
end;

procedure TParamImp.Set_TrainNo(const Value: WideString);
begin
  m_Dict.Values['TrainNo'] := Value;
end;

procedure TParamImp.Set_TrainNumber(const Value: WideString);
begin
  m_Dict.Values['TrainNumber'] := Value;
end;

procedure TParamImp.Set_TrainTypeName(const Value: WideString);
begin
  m_Dict.Values['TrainTypeName'] := Value;
end;

{ TGrpImp }

function TGrpImp.CreateTM: ITm;
begin
  Result := TTmImp.Create;
end;

function TGrpImp.Get_Tm1: ITm;
begin
  Result := m_Tm1;
end;

function TGrpImp.Get_Tm2: ITm;
begin
  Result := m_Tm2;
end;

function TGrpImp.Get_Tm3: ITm;
begin
  Result := m_Tm3;
end;

function TGrpImp.Get_Tm4: ITm;
begin
  Result := m_Tm4;
end;

procedure TGrpImp.Set_Tm1(const Value: ITm);
begin
  m_Tm1 := Value;
end;

procedure TGrpImp.Set_Tm2(const Value: ITm);
begin
  m_Tm2 := Value;
end;

procedure TGrpImp.Set_Tm3(const Value: ITm);
begin
  m_Tm3 := Value;
end;

procedure TGrpImp.Set_Tm4(const Value: ITm);
begin
  m_Tm4 := Value;
end;

{ TTmImp }

function TTmImp.Get_ID: WideString;
begin
  Result := m_ID;
end;

function TTmImp.Get_Name: WideString;
begin
  Result := m_Name;
end;

function TTmImp.Get_Number: WideString;
begin
  Result := m_Number;
end;

procedure TTmImp.Set_ID(const Value: WideString);
begin
  m_ID := Value;
end;

procedure TTmImp.Set_Name(const Value: WideString);
begin
  m_Name := Value;
end;

procedure TTmImp.Set_Number(const Value: WideString);
begin
  m_Number := Value;
end;

procedure TBDPrint.ConfigDialog;
begin
  TfrmTMRptSelect.Config();
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBDPrint, Class_BDPrint,
    ciMultiInstance, tmApartment);
end.
