unit RsAPIBase_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsAPIBaseLib_TLB, StdVcl;

type
  TRsAPIBase = class(TAutoObject, IRsAPIBase)
  protected
    procedure GetAllJwdList(out JWDArray: IRsJWDArray); safecall;

  end;

implementation

uses ComServ;

procedure TRsAPIBase.GetAllJwdList(out JWDArray: IRsJWDArray);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsAPIBase, Class_RsAPIBase,
    ciMultiInstance, tmApartment);
end.
