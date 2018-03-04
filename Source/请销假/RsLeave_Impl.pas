unit RsLeave_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, RsLeaveLib_TLB, StdVcl,RsGlobal_TLB,uGlobal,Forms;

type
  TRsUILeave = class(TAutoObject, IRsUILeave)
  protected
    function Askfor(const TrainmanNumber: WideString): WordBool; safecall;
    function Cancel(const TrainmanNumber: WideString): WordBool; safecall;
    procedure ShowQuery(EditEnable: WordBool); safecall;
    procedure TypeShowQuery; safecall;
  public
    procedure Initialize; override;
  end;

  implementation

uses
  ComServ,uFrmLeaveTypeMgr,uFrmLeaveQuery,uFrmAskLeave,uFrmCancelLeave;


function TRsUILeave.Askfor(const TrainmanNumber: WideString): WordBool;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    result := TFrmAskLeave.ShowAskLeaveFormByNumber(TrainmanNumber);
  finally
    Application.Handle := 0;
  end;
end;

function TRsUILeave.Cancel(const TrainmanNumber: WideString): WordBool;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    result := TFrmCancelLeave.ShowCancelLeaveForm(TrainmanNumber);
  finally
    Application.Handle := 0;
  end;

end;

procedure TRsUILeave.Initialize;
begin
  inherited;
  g_WebAPIUtils.Host := GlobalDM.WebAPI.Host;
  g_WebAPIUtils.Port := GlobalDM.WebAPI.Port;
end;

procedure TRsUILeave.ShowQuery(EditEnable: WordBool);
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    TFrmLeaveQuery.ShowForm(EditEnable);
  finally
    Application.Handle := 0;
  end;

end;

procedure TRsUILeave.TypeShowQuery;
begin
  Application.Handle := GlobalDM.AppHandle;
  try
    TFrmLeaveTypeMgr.ShowLeaveTypeMgrForm();
  finally
    Application.Handle := 0;
  end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TRsUILeave, Class_RsUILeave,
    ciMultiInstance, tmApartment);
end.
