library RsTMFPLib;

uses
  ComServ,
  RsTMFPLib_TLB in 'RsTMFPLib_TLB.pas',
  RsTMFP_Impl in 'RsTMFP_Impl.pas' {RsTMFP: CoClass},
  uFrmFingerLoadProgress in '���ܴ���\uFrmFingerLoadProgress.pas' {FrmFingerLoadProgress},
  uFingerCtls in '���ܵ�Ԫ\uFingerCtls.pas',
  ufrmTrainmanIdentity in '���ܴ���\ufrmTrainmanIdentity.pas' {FrmTrainmanIdentity},
  ufrmFingerRegister in '���ܴ���\ufrmFingerRegister.pas' {frmFingerRegister},
  ufrmTrainmanPicFigEdit in '���ܴ���\ufrmTrainmanPicFigEdit.pas' {FormTrainmanPicFigEdit},
  ufrmgather in '���ܴ���\ufrmgather.pas',
  ufrmCamer in '���ܴ���\ufrmCamer.pas',
  ufrmTextInput in '���ܴ���\ufrmTextInput.pas' {frmTextInput},
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
