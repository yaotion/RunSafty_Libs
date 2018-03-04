library RsUITrainmanLib;

uses
  ComServ,
  uFrmAddUser in '功能窗口\uFrmAddUser.pas' {FrmAddUser},
  RsAPITrainmanLib_TLB in '引用\RsAPITrainmanLib_TLB.pas',
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
