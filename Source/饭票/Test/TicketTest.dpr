program TicketTest;

uses
  Forms,
  ActiveX,
  Dialogs,
  uFrmMain in 'uFrmMain.pas' {Form5},
  EventSink in '..\..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  RsGlobal_TLB in '..\..\global\RsGlobal_TLB.pas',
  RsBDPrint_TLB in '..\..\����\RsBDPrint_TLB.pas',
  RsPubJs_TLB in '..\..\������ʾ\RsPubJs_TLB.pas',
  RsGoodsManage_TLB in '..\..\��Ʒ����\RsGoodsManage_TLB.pas',
  RsMealTicket_TLB in '..\RsMealTicket_TLB.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
