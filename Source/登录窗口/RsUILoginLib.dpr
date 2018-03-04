library RsUILoginLib;

uses
  ComServ,
  RsUILoginLib_TLB in 'RsUILoginLib_TLB.pas',
  RsUILogin_Impl in 'RsUILogin_Impl.pas' {RsUILogin: CoClass},
  uFrmLogin in '功能窗口\登录验证\uFrmLogin.pas' {frmLogin},
  ufrmConfig in '功能窗口\配置设置\ufrmConfig.pas' {frmConfig},
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  RsGlobal_TLB in '引用\RsGlobal_TLB.pas',
  uGlobal in 'uGlobal.pas',
  uWebApiCollection in '功能单元\uWebApiCollection.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
