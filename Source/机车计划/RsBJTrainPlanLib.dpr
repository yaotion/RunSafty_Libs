library RsBJTrainPlanLib;

uses
  ComServ,
  RsGlobal_TLB in '����\RsGlobal_TLB.pas',
  uFrmMainTemeplateTrainNo in '���ܴ���\uFrmMainTemeplateTrainNo.pas' {FrmMainTemeplateTrainNo},
  uFrmTemeplateDaWenItem in '���ܴ���\uFrmTemeplateDaWenItem.pas' {FrmTemeplateDaWenItem},
  uFrmTemeplateTrainNoGroup in '���ܴ���\uFrmTemeplateTrainNoGroup.pas' {FrmTemeplateTrainNoGroup},
  uFrmTemeplateTrainNoItem in '���ܴ���\uFrmTemeplateTrainNoItem.pas' {FrmTemeplateTrainNoItem},
  uFrmTemplateTrainNoManager in '���ܴ���\uFrmTemplateTrainNoManager.pas' {TemplateTrainNoManager},
  uRunSaftyMessageDefine in '..\..\..\����\���ܵ�Ԫ\��Ϣ����\uRunSaftyMessageDefine.pas',
  uDayPlanExportToXls in '���ܵ�Ԫ\uDayPlanExportToXls.pas',
  uTemplateDayPlan in '���ܵ�Ԫ\uTemplateDayPlan.pas',
  RsBJTrainPlanLib_TLB in 'RsBJTrainPlanLib_TLB.pas',
  RsBJTrainPlan_Impl in 'RsBJTrainPlan_Impl.pas' {RsBJTrainPlan: CoClass},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
