library RsTMFPLib;

uses
  ComServ,
  RsTMFPLib_TLB in 'RsTMFPLib_TLB.pas',
  RsTMFP_Impl in 'RsTMFP_Impl.pas' {RsTMFP: CoClass},
  uFrmFingerLoadProgress in '功能窗口\uFrmFingerLoadProgress.pas' {FrmFingerLoadProgress},
  uFingerCtls in '功能单元\uFingerCtls.pas',
  ufrmTrainmanIdentity in '功能窗口\ufrmTrainmanIdentity.pas' {FrmTrainmanIdentity},
  ufrmFingerRegister in '功能窗口\ufrmFingerRegister.pas' {frmFingerRegister},
  ufrmTrainmanPicFigEdit in '功能窗口\ufrmTrainmanPicFigEdit.pas' {FormTrainmanPicFigEdit},
  ufrmgather in '功能窗口\ufrmgather.pas',
  ufrmCamer in '功能窗口\ufrmCamer.pas',
  ufrmTextInput in '功能窗口\ufrmTextInput.pas' {frmTextInput},
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
