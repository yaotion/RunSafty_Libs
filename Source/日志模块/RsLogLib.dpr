library RsLogLib;

uses
  ComServ,
  RsLogLib_TLB in 'RsLogLib_TLB.pas',
  RsLogLib_Impl in 'RsLogLib_Impl.pas' {RsLog: CoClass},
  uRsFrmLogLibConfig in 'uRsFrmLogLibConfig.pas' {frmLogLibConfig};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
