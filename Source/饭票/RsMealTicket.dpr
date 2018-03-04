library RsMealTicket;

uses
  ComServ,
  Dialogs,
  RsMealTicket_TLB in 'RsMealTicket_TLB.pas',
  uMealTicketImp in 'uMealTicketImp.pas' {Ticket: CoClass},
  ufrmMealTicketQuery in '����\ufrmMealTicketQuery.pas' {frmMealTicketQuery},
  uFrmViewMealTicket in '����\uFrmViewMealTicket.pas' {FrmViewMealTicket},
  uFrmViewMealTicketLog in '����\uFrmViewMealTicketLog.pas' {FrmViewMealTicketLog},
  uFrmMealTicketConfig in '����\����\uFrmMealTicketConfig.pas' {FrmMealTicketConfig},
  uFrmMealticketServerCfg in '����\����\uFrmMealticketServerCfg.pas' {FrmMealTicketServerCfg},
  uFrmTicketModify in '����\����\uFrmTicketModify.pas' {FrmTicketModify},
  uFrmAddMealTicketRule in '����\��Ʊ����\uFrmAddMealTicketRule.pas' {FrmAddMealTicketRule},
  uFrmAddMealTicketRuleInfo in '����\��Ʊ����\uFrmAddMealTicketRuleInfo.pas' {FrmAddMealTicketRuleInfo},
  uFrmMealTicketRule in '����\��Ʊ����\uFrmMealTicketRule.pas' {FrmMealTicketRule},
  uFrmViewMealTicketRuleInfo in '����\��Ʊ����\uFrmViewMealTicketRuleInfo.pas' {FrmViewMealTicketRuleInfo},
  ufrmTicketCountInput in '����\ufrmTicketCountInput.pas' {FrmTicketCountInput},
  uDBMealTicket in '���ܵ�Ԫ\uDBMealTicket.pas',
  uMealTicketFacade in '���ܵ�Ԫ\uMealTicketFacade.pas',
  uMealTicketManager in '���ܵ�Ԫ\uMealTicketManager.pas',
  uGlobal in 'uGlobal.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uLCWebAPI in 'uLCWebAPI.pas',
  uFrmAddMealTicket in '����\uFrmAddMealTicket.pas' {FrmAddMealTicket};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin

end.
