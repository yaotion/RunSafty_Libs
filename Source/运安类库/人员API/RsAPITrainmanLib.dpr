library RsAPITrainmanLib;

uses
  ComServ,
  RsUtilsLib_TLB in '..\Õ®”√\RsUtilsLib_TLB.pas',
  RsAPITrainmanLib_TLB in 'RsAPITrainmanLib_TLB.pas',
  RsAPITrainman_Impl in 'RsAPITrainman_Impl.pas'; {RsAPITrainmanLib_TLB: CoClass}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
