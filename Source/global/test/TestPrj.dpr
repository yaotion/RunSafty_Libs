program TestPrj;

uses
  Forms,
  GlobalTest in 'GlobalTest.pas' {Form5},
  RsGlobal_TLB in '..\RsGlobal_TLB.pas',
  EventSink in '..\..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
