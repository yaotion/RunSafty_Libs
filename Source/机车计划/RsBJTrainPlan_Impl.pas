unit RsBJTrainPlan_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsBJTrainPlanLib_TLB, StdVcl,RsGlobal_TLB,uGlobal,Forms;

type
  TRsBJTrainPlan = class(TAutoObject, IRsBJTrainPlan)
  protected
    procedure ShowForm(Readonly: WordBool); safecall;

  end;

implementation

uses ComServ,uFrmMainTemeplateTrainNo;


procedure TRsBJTrainPlan.ShowForm(Readonly: WordBool);
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo(Readonly);
  Application.Handle := 0;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsBJTrainPlan, Class_RsBJTrainPlan,
    ciMultiInstance, tmApartment);
end.
