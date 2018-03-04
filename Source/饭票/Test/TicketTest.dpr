program TicketTest;

uses
  Forms,
  ActiveX,
  Dialogs,
  uFrmMain in 'uFrmMain.pas' {Form5},
  EventSink in '..\..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  RsGlobal_TLB in '..\..\global\RsGlobal_TLB.pas',
  RsBDPrint_TLB in '..\..\报单\RsBDPrint_TLB.pas',
  RsPubJs_TLB in '..\..\交付揭示\RsPubJs_TLB.pas',
  RsGoodsManage_TLB in '..\..\物品管理\RsGoodsManage_TLB.pas',
  RsMealTicket_TLB in '..\RsMealTicket_TLB.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
