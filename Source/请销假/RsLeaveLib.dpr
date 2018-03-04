library RsLeaveLib;

uses
  ComServ,
  RsLeaveLib_TLB in 'RsLeaveLib_TLB.pas',
  RsLeave_Impl in 'RsLeave_Impl.pas' {RsAPILeave: CoClass},
  uFrmAskLeave in '功能窗体\请假登记\uFrmAskLeave.pas' {FrmAskLeave},
  uFrmLeaveTypeMgr in '功能窗体\请假类型管理\uFrmLeaveTypeMgr.pas' {FrmLeaveTypeMgr},
  uFrmLeaveTypeModify in '功能窗体\请假类型管理\uFrmLeaveTypeModify.pas' {FrmLeaveTypeModify},
  uFrmLeaveQuery in '功能窗体\请销假记录查询\uFrmLeaveQuery.pas' {FrmLeaveQuery},
  uFrmAskLeaveDetail in '功能窗体\请销假详细信息\uFrmAskLeaveDetail.pas' {FrmAskLeaveDetail},
  uFrmCancelLeave in '功能窗体\销假登记\uFrmCancelLeave.pas' {FrmCancelLeave},
  ufrmLeaveJlSelect in '功能窗体\请假登记\ufrmLeaveJlSelect.pas' {frmLeaveJlSelect},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  ufrmTextInput in '功能窗体\ufrmTextInput.pas' {frmTextInput},
  ufrmTmJlSelect in '功能窗体\ufrmTmJlSelect.pas' {frmTmjlSelect},
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
