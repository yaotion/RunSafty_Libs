library RsPubJs;

uses
  ComServ,
  RsPubJs_TLB in 'RsPubJs_TLB.pas',
  uPubJsImp in 'uPubJsImp.pas' {PubJs: CoClass},
  uLib_PubJsCtl in '功能单元\uLib_PubJsCtl.pas',
  uPubJsPrintCtl in '功能单元\uPubJsPrintCtl.pas',
  UFrmPrintJieShi in '窗口\UFrmPrintJieShi.pas' {FrmPrintJieShi},
  uRsLibUtils in '功能单元\uRsLibUtils.pas',
  uDDMLDownload in '功能单元\uDDMLDownload.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  uVariantDict in '功能单元\uVariantDict.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
