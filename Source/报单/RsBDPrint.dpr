library RsBDPrint;

uses
  ComServ,
  uFrmPrintTMRpt in '功能单元\uFrmPrintTMRpt.pas' {FrmPrintTMRpt},
  uFrmTMRptSelect in '功能单元\uFrmTMRptSelect.pas' {frmTMRptSelect},
  uPrintTMReport in '功能单元\uPrintTMReport.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
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
