library RsCameraLib;

{%TogetherDiagram 'ModelSupport_RsCameraLib\default.txaPackage'}

uses
  ComServ,
  RsCameraLib_TLB in 'RsCameraLib_TLB.pas',
  uRsCamera_Impl in 'uRsCamera_Impl.pas' {Camera: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
