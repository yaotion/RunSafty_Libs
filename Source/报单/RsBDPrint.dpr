library RsBDPrint;

uses
  ComServ,
  uFrmPrintTMRpt in '���ܵ�Ԫ\uFrmPrintTMRpt.pas' {FrmPrintTMRpt},
  uFrmTMRptSelect in '���ܵ�Ԫ\uFrmTMRptSelect.pas' {frmTMRptSelect},
  uPrintTMReport in '���ܵ�Ԫ\uPrintTMReport.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  RsBDPrint_TLB in 'RsBDPrint_TLB.pas',
  uDBPrintImp in 'uDBPrintImp.pas' {BDPrint: CoClass},
  uVariantDict in 'uVariantDict.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
