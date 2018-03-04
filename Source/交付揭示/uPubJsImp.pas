unit uPubJsImp;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsPubJs_TLB, StdVcl,uGlobal,uVariantDict,uTrainPlan,
  Forms;

type
  TParamImp = class(TInterfacedObject,IParam)
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_Dict: TVariantDict;
    function Get_PlanID: WideString; safecall;
    procedure Set_PlanID(const Value: WideString); safecall;
    function Get_TrainNo: WideString; safecall;
    procedure Set_TrainNo(const Value: WideString); safecall;
    function Get_TrainNumber: WideString; safecall;
    procedure Set_TrainNumber(const Value: WideString); safecall;
    function Get_PlanTime: TDateTime; safecall;
    procedure Set_PlanTime(Value: TDateTime); safecall;
    function Get_TmNumber1: WideString; safecall;
    procedure Set_TmNumber1(const Value: WideString); safecall;
    function Get_TmName1: WideString; safecall;
    procedure Set_TmName1(const Value: WideString); safecall;
    function Get_TmNumber2: WideString; safecall;
    procedure Set_TmNumber2(const Value: WideString); safecall;
    function Get_TmName2: WideString; safecall;
    procedure Set_TmName2(const Value: WideString); safecall;
  end;
  
  TPubJs = class(TAutoObject, IPubJs)
  protected
    procedure PrintJFJSOldMode(const Plan: RRsChuQinPlan);
    procedure Print(const Param: IParam); safecall;
    function CreateParam: IParam; safecall;
  public
    procedure Initialize; override;
  end;


implementation

uses
ComServ,
uPubJsPrintCtl, uTrainman, UFrmPrintJieShi;

procedure TPubJs.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TPubJs.Print(const Param: IParam);
var
  Plan: RRsChuQinPlan;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    FillChar(Plan,SizeOf(Plan),0);

    Plan.TrainPlan.strTrainPlanGUID := Param.PlanID;
    Plan.TrainPlan.strTrainNo := Param.TrainNo;
    Plan.TrainPlan.strTrainNumber := Param.TrainNumber;
    Plan.TrainPlan.dtStartTime := Param.PlanTime;
    Plan.ChuQinGroup.Group.Trainman1.strTrainmanNumber := Param.TmNumber1;
    Plan.ChuQinGroup.Group.Trainman1.strTrainmanName := Param.TmName1;
    Plan.ChuQinGroup.Group.Trainman2.strTrainmanNumber := Param.TmNumber2;
    Plan.ChuQinGroup.Group.Trainman2.strTrainmanName := Param.TmName2;

    if GlobalDM.ReadServerConfig('JFJSCfg','PrintOldMode') = '1' then
      PrintJFJSOldMode(Plan)
    else
      TPubJsPrintCtl.Print(Plan);
  finally
    Application.Handle := 0;
  end;

end;



procedure TPubJs.PrintJFJSOldMode(const Plan: RRsChuQinPlan);
var
  trainman : RRsTrainman;
begin

  with TFrmPrintJieShi.Create(nil) do
  begin
    try
      trainman := Plan.ChuQinGroup.Group.Trainman1;

      if trainman.strTrainmanName = '' then
        trainman := Plan.ChuQinGroup.Group.Trainman2;
      ShowPrintJiaoFuJieShi(Plan,Trainman);
    finally
      Free;
    end;

  end;


end;


function TPubJs.CreateParam: IParam;
begin
  Result := TParamImp.Create;
end;

{ TParamImp }

constructor TParamImp.Create;
begin
  m_Dict := TVariantDict.Create;
end;

destructor TParamImp.Destroy;
begin
  m_Dict.Free;
  inherited;
end;

function TParamImp.Get_PlanID: WideString;
begin
  Result := m_Dict.ValueAsString('PlanID');
end;

function TParamImp.Get_PlanTime: TDateTime;
begin
  Result := m_Dict.ValueAsDateTime('PlanTime');
end;

function TParamImp.Get_TmName1: WideString;
begin
  Result := m_Dict.ValueAsString('TmName1');
end;

function TParamImp.Get_TmName2: WideString;
begin
  Result := m_Dict.ValueAsString('TmName2');
end;

function TParamImp.Get_TmNumber1: WideString;
begin
  Result := m_Dict.ValueAsString('TmNumber1');
end;

function TParamImp.Get_TmNumber2: WideString;
begin
  Result := m_Dict.ValueAsString('TmNumber2');
end;

function TParamImp.Get_TrainNo: WideString;
begin
  Result := m_Dict.ValueAsString('TrainNo');
end;

function TParamImp.Get_TrainNumber: WideString;
begin
  Result := m_Dict.ValueAsString('TrainNumber');
end;

procedure TParamImp.Set_PlanID(const Value: WideString);
begin
  m_Dict.Values['PlanID'] := Value;
end;

procedure TParamImp.Set_PlanTime(Value: TDateTime);
begin
  m_Dict.Values['PlanTime'] := Value;
end;

procedure TParamImp.Set_TmName1(const Value: WideString);
begin
  m_Dict.Values['TmName1'] := Value;
end;

procedure TParamImp.Set_TmName2(const Value: WideString);
begin
  m_Dict.Values['TmName2'] := Value;
end;

procedure TParamImp.Set_TmNumber1(const Value: WideString);
begin
  m_Dict.Values['TmNumber1'] := Value;
end;

procedure TParamImp.Set_TmNumber2(const Value: WideString);
begin
  m_Dict.Values['TmNumber2'] := Value;
end;

procedure TParamImp.Set_TrainNo(const Value: WideString);
begin
  m_Dict.Values['TrainNo'] := Value;
end;

procedure TParamImp.Set_TrainNumber(const Value: WideString);
begin
  m_Dict.Values['TrainNumber'] := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPubJs, Class_PubJs,
    ciMultiInstance, tmApartment);
end.
