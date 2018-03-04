library RsGlobal;

uses
  ComServ,
  RsGlobal_TLB in 'RsGlobal_TLB.pas',
  uGlobalImp in 'uGlobalImp.pas' {Global: CoClass},
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
