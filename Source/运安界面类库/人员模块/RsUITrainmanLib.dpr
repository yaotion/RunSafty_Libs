library RsUITrainmanLib;

uses
  ComServ,
  uFrmAddUser in '���ܴ���\uFrmAddUser.pas' {FrmAddUser},
  RsAPITrainmanLib_TLB in '����\RsAPITrainmanLib_TLB.pas',
  RsUITrainmanLib_TLB in 'RsUITrainmanLib_TLB.pas',
  RsUITrainman_Impl in 'RsUITrainman_Impl.pas' {RsUITrainman: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
