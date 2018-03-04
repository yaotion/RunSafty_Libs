unit RsUITrainman_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsUITrainmanLib_TLB,RSAPITrainmanLib_TLB, StdVcl;

type
  TRsUITrainman = class(TAutoObject, IRsUITrainman)
  protected
    function InputTrainman(const WorkShopGUID: WideString;
      out Trainman: IDispatch): WordBool; safecall;
    function Get_APITrainman: IDispatch; safecall;
    procedure Set_APITrainman(const Value: IDispatch); safecall;
  private
    m_APITrainman : IRsAPITrainman;
  end;

implementation

uses ComServ,uFrmAddUser;

function TRsUITrainman.InputTrainman(const WorkShopGUID: WideString;
  out Trainman: IDispatch): WordBool;
var
  itm : irsTrainman;
begin
  result := TFrmAddUser.InputTrainman(m_APITrainman,WorkShopGUID,itm);
  if Result then
    Trainman := itm;
end;

function TRsUITrainman.Get_APITrainman: IDispatch;
begin
  result := m_APITrainman;
end;

procedure TRsUITrainman.Set_APITrainman(const Value: IDispatch);
begin
  m_APITrainman := Value as IRsAPITrainman;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsUITrainman, Class_RsUITrainman,
    ciMultiInstance, tmApartment);
end.
