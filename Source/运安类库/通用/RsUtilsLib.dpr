library RsUtilsLib;

uses
  ComServ,
  RsUtilsLib_TLB in 'RsUtilsLib_TLB.pas',
  RsUtils_Impl in 'RsUtils_Impl.pas' {WebAPI: CoClass},
  uWiniNet in '���ܵ�Ԫ\uWiniNet.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
