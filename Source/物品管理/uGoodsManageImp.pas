unit uGoodsManageImp;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsGoodsManage_TLB, StdVcl,Classes,Forms;

type
  TTmImp = class(TInterfacedObject,ITm)
  private
    m_ID: WideString;
    m_Number: WideString;
    m_Name: WideString;
    m_Verify: integer;
    
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Number: WideString; safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Verify: Integer; safecall;
    procedure Set_Verify(Value: Integer); safecall;
  end;
  
  TGoodsManage = class(TAutoObject, IGoodsManage)
  protected
    procedure CodeRangeMgr; safecall;
    procedure GoodsMgr; safecall;
    procedure SendGoods(const Tm: ITm); safecall;
    function CreateTm: ITm; safecall;
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ, uFrmGoodsManage, uFrmGoodsRangeManage, uFrmGoodsSend,uTrainman,
uSaftyEnum, uGlobal, RsGlobal_TLB;

procedure TGoodsManage.CodeRangeMgr;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    TFrmGoodsRangeManage.ShowForm();
  finally
    Application.Handle := 0;
  end;

end;

procedure TGoodsManage.GoodsMgr;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    LengingManage();
  finally
    Application.Handle := 0;
  end;

end;

procedure TGoodsManage.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TGoodsManage.SendGoods(const Tm: ITm);
var
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  TrainMan.strTrainmanGUID := Tm.ID;
  TrainMan.strTrainmanNumber := Tm.Number;
  TrainMan.strTrainmanName := Tm.Name;
  Verify := TRsRegisterFlag(Tm.Verify);
  
  SendLendings(TrainMan,Verify);
end;

function TGoodsManage.CreateTm: ITm;
begin
  Result := TTmImp.Create;
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

function TTmImp.Get_Verify: Integer;
begin
  Result := m_Verify;
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

procedure TTmImp.Set_Verify(Value: Integer);
begin
  m_Verify := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TGoodsManage, Class_GoodsManage,
    ciMultiInstance, tmApartment);
end.
