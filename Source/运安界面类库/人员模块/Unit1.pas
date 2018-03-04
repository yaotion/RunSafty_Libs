unit Unit1;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsUITrainmanLib_TLB, StdVcl;

type
  TRsUITrainman = class(TAutoObject, IRsUITrainman)
  protected

  end;

implementation

uses ComServ;

initialization
  TAutoObjectFactory.Create(ComServer, TRsUITrainman, Class_RsUITrainman,
    ciMultiInstance, tmApartment);
end.
