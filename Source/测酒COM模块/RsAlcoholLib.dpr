library RsAlcoholLib;

uses
  ComServ,
  RsAlcoholLib_TLB in 'RsAlcoholLib_TLB.pas',
  uRsAlcoholLibOption_Impl in 'uRsAlcoholLibOption_Impl.pas' {AlcoholOption: CoClass},
  uRsAlcoholLib_Impl in 'uRsAlcoholLib_Impl.pas' {AlcoholUI: CoClass},
  uFrmAlcoholUI_PC in '���ܴ���\uFrmAlcoholUI_PC.pas' {frmAlcoholUI_PC},
  ufrmCamer in '���ܴ���\ufrmCamer.pas' {frmCamera: TFrame},
  RsCameraLib_TLB in '..\����ͷComģ��\RsCameraLib_TLB.pas',
  uFrmAlcoholUI_ZiZhu in '���ܴ���\uFrmAlcoholUI_ZiZhu.pas' {FrmAlcoholUI_ZiZhu},
  uFrmAlcoholUI in '���ܴ���\uFrmAlcoholUI.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
