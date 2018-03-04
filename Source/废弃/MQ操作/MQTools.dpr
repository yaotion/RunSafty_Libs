program MQTools;

uses
  Forms,
  uMQUtils in 'uMQUtils.pas',
  uFrmDemo in 'uFrmDemo.pas' {frmMQDemo};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.CreateForm(TfrmMQDemo, frmMQDemo);
  Application.Run;
end.
