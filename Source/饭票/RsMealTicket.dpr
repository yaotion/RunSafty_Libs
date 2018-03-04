library RsMealTicket;

uses
  ComServ,
  Dialogs,
  RsMealTicket_TLB in 'RsMealTicket_TLB.pas',
  uMealTicketImp in 'uMealTicketImp.pas' {Ticket: CoClass},
  ufrmMealTicketQuery in '窗口\ufrmMealTicketQuery.pas' {frmMealTicketQuery},
  uFrmViewMealTicket in '窗口\uFrmViewMealTicket.pas' {FrmViewMealTicket},
  uFrmViewMealTicketLog in '窗口\uFrmViewMealTicketLog.pas' {FrmViewMealTicketLog},
  uFrmMealTicketConfig in '窗口\设置\uFrmMealTicketConfig.pas' {FrmMealTicketConfig},
  uFrmMealticketServerCfg in '窗口\设置\uFrmMealticketServerCfg.pas' {FrmMealTicketServerCfg},
  uFrmTicketModify in '窗口\设置\uFrmTicketModify.pas' {FrmTicketModify},
  uFrmAddMealTicketRule in '窗口\饭票规则\uFrmAddMealTicketRule.pas' {FrmAddMealTicketRule},
  uFrmAddMealTicketRuleInfo in '窗口\饭票规则\uFrmAddMealTicketRuleInfo.pas' {FrmAddMealTicketRuleInfo},
  uFrmMealTicketRule in '窗口\饭票规则\uFrmMealTicketRule.pas' {FrmMealTicketRule},
  uFrmViewMealTicketRuleInfo in '窗口\饭票规则\uFrmViewMealTicketRuleInfo.pas' {FrmViewMealTicketRuleInfo},
  ufrmTicketCountInput in '窗口\ufrmTicketCountInput.pas' {FrmTicketCountInput},
  uDBMealTicket in '功能单元\uDBMealTicket.pas',
  uMealTicketFacade in '功能单元\uMealTicketFacade.pas',
  uMealTicketManager in '功能单元\uMealTicketManager.pas',
  uGlobal in 'uGlobal.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uLCWebAPI in 'uLCWebAPI.pas',
  uFrmAddMealTicket in '窗口\uFrmAddMealTicket.pas' {FrmAddMealTicket};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin

end.
