library RsUILoginLib;

uses
  ComServ,
  RsUILoginLib_TLB in 'RsUILoginLib_TLB.pas',
  RsUILogin_Impl in 'RsUILogin_Impl.pas' {RsUILogin: CoClass},
  uFrmLogin in '���ܴ���\��¼��֤\uFrmLogin.pas' {frmLogin},
  ufrmConfig in '���ܴ���\��������\ufrmConfig.pas' {frmConfig},
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  RsGlobal_TLB in '����\RsGlobal_TLB.pas',
  uGlobal in 'uGlobal.pas',
  uWebApiCollection in '���ܵ�Ԫ\uWebApiCollection.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
