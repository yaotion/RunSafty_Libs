library RsLeaveLib;

uses
  ComServ,
  RsLeaveLib_TLB in 'RsLeaveLib_TLB.pas',
  RsLeave_Impl in 'RsLeave_Impl.pas' {RsAPILeave: CoClass},
  uFrmAskLeave in '���ܴ���\��ٵǼ�\uFrmAskLeave.pas' {FrmAskLeave},
  uFrmLeaveTypeMgr in '���ܴ���\������͹���\uFrmLeaveTypeMgr.pas' {FrmLeaveTypeMgr},
  uFrmLeaveTypeModify in '���ܴ���\������͹���\uFrmLeaveTypeModify.pas' {FrmLeaveTypeModify},
  uFrmLeaveQuery in '���ܴ���\�����ټ�¼��ѯ\uFrmLeaveQuery.pas' {FrmLeaveQuery},
  uFrmAskLeaveDetail in '���ܴ���\��������ϸ��Ϣ\uFrmAskLeaveDetail.pas' {FrmAskLeaveDetail},
  uFrmCancelLeave in '���ܴ���\���ٵǼ�\uFrmCancelLeave.pas' {FrmCancelLeave},
  ufrmLeaveJlSelect in '���ܴ���\��ٵǼ�\ufrmLeaveJlSelect.pas' {frmLeaveJlSelect},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  ufrmTextInput in '���ܴ���\ufrmTextInput.pas' {frmTextInput},
  ufrmTmJlSelect in '���ܴ���\ufrmTmJlSelect.pas' {frmTmjlSelect},
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
