library RsBJTrainPlanLib;

uses
  ComServ,
  RsGlobal_TLB in '引用\RsGlobal_TLB.pas',
  uFrmMainTemeplateTrainNo in '功能窗体\uFrmMainTemeplateTrainNo.pas' {FrmMainTemeplateTrainNo},
  uFrmTemeplateDaWenItem in '功能窗体\uFrmTemeplateDaWenItem.pas' {FrmTemeplateDaWenItem},
  uFrmTemeplateTrainNoGroup in '功能窗体\uFrmTemeplateTrainNoGroup.pas' {FrmTemeplateTrainNoGroup},
  uFrmTemeplateTrainNoItem in '功能窗体\uFrmTemeplateTrainNoItem.pas' {FrmTemeplateTrainNoItem},
  uFrmTemplateTrainNoManager in '功能窗体\uFrmTemplateTrainNoManager.pas' {TemplateTrainNoManager},
  uRunSaftyMessageDefine in '..\..\..\公共\功能单元\消息定义\uRunSaftyMessageDefine.pas',
  uDayPlanExportToXls in '功能单元\uDayPlanExportToXls.pas',
  uTemplateDayPlan in '功能单元\uTemplateDayPlan.pas',
  RsBJTrainPlanLib_TLB in 'RsBJTrainPlanLib_TLB.pas',
  RsBJTrainPlan_Impl in 'RsBJTrainPlan_Impl.pas' {RsBJTrainPlan: CoClass},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
