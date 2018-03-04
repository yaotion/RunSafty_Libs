library RsFingerLib;

uses
  ComServ,
  RsFingerLib_TLB in 'RsFingerLib_TLB.pas',
  RsFinger_Impl in 'RsFinger_Impl.pas' {RsFinger: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}


begin
end.
