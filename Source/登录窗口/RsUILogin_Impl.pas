unit RsUILogin_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsUILoginLib_TLB, StdVcl;

type
  TRsUILogin = class(TAutoObject, IRsUILogin)
  protected
    function Login(out TokenString: WideString): WordBool; safecall;
    function Get_WebAPI: IDispatch; safecall;
    procedure Set_WebAPI(const Value: IDispatch); safecall;
    procedure OpenSetup; safecall;

  end;

implementation

uses
  ComServ,uFrmLogin,ufrmConfig;

function TRsUILogin.Login(out TokenString: WideString): WordBool;
begin
  result := TfrmLogin.Login(TokenString);
end;

function TRsUILogin.Get_WebAPI: IDispatch;
begin

end;

procedure TRsUILogin.Set_WebAPI(const Value: IDispatch);
begin

end;

procedure TRsUILogin.OpenSetup;
begin
  TfrmConfig.EditConfig;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsUILogin, Class_RsUILogin,
    ciMultiInstance, tmApartment);
end.
