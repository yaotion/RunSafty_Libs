library RsPubJs;

uses
  ComServ,
  RsPubJs_TLB in 'RsPubJs_TLB.pas',
  uPubJsImp in 'uPubJsImp.pas' {PubJs: CoClass},
  uLib_PubJsCtl in '���ܵ�Ԫ\uLib_PubJsCtl.pas',
  uPubJsPrintCtl in '���ܵ�Ԫ\uPubJsPrintCtl.pas',
  UFrmPrintJieShi in '����\UFrmPrintJieShi.pas' {FrmPrintJieShi},
  uRsLibUtils in '���ܵ�Ԫ\uRsLibUtils.pas',
  uDDMLDownload in '���ܵ�Ԫ\uDDMLDownload.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  uVariantDict in '���ܵ�Ԫ\uVariantDict.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
