library RsAPIBaseLib;

uses
  ComServ,
  RsAPIBaseLib_TLB in 'RsAPIBaseLib_TLB.pas',
  RsAPIBase_Impl in 'RsAPIBase_Impl.pas' {RsAPIBase: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
