library RsAlcoholLib;

uses
  ComServ,
  RsAlcoholLib_TLB in 'RsAlcoholLib_TLB.pas',
  uRsAlcoholLibOption_Impl in 'uRsAlcoholLibOption_Impl.pas' {AlcoholOption: CoClass},
  uRsAlcoholLib_Impl in 'uRsAlcoholLib_Impl.pas' {AlcoholUI: CoClass},
  uFrmAlcoholUI_PC in '功能窗体\uFrmAlcoholUI_PC.pas' {frmAlcoholUI_PC},
  ufrmCamer in '功能窗体\ufrmCamer.pas' {frmCamera: TFrame},
  RsCameraLib_TLB in '..\摄像头Com模块\RsCameraLib_TLB.pas',
  uFrmAlcoholUI_ZiZhu in '功能窗体\uFrmAlcoholUI_ZiZhu.pas' {FrmAlcoholUI_ZiZhu},
  uFrmAlcoholUI in '功能窗体\uFrmAlcoholUI.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
