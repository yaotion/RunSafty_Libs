program TestPrj;

uses
  Forms,
  GlobalTest in 'GlobalTest.pas' {Form5},
  RsGlobal_TLB in '..\RsGlobal_TLB.pas',
  EventSink in '..\..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\..\类库调用Demo\功能单元\类库调用\uTFComObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
