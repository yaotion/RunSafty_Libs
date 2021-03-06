unit RsNameplate_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsNameplateLib_TLB, StdVcl,uGlobal,Forms;

type
  TRsNameplate = class(TAutoObject, IRsNameplate)
  protected
    procedure ShowNameplate(EditEnable, CanDel: WordBool); safecall;
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ,uFrmNameBoard, RsGlobal_TLB;

procedure TRsNameplate.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TRsNameplate.ShowNameplate(EditEnable, CanDel: WordBool);
begin
  Application.Handle := GlobalDM.AppHandle;
  TFrmNameBoard.OpenForm();
  Application.Handle := 0;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRsNameplate, Class_RsNameplate,
    ciMultiInstance, tmApartment);
end.
