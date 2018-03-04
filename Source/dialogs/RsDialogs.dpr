library RsDialogs;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Forms,
  windows,
  uNoFocusBox in 'dialogs\uNoFocusBox.pas' {NoFocusBox},
  uNoFocusProgress in 'dialogs\uNoFocusProgress.pas' {NoFocusProgress},
  uNoFocusHint in 'dialogs\uNoFocusHint.pas' {NoFocusHint},
  uDateTimeInput in 'dialogs\uDateTimeInput.pas' {DateTimeInput};

{$R *.res}
procedure DLLHandler(dwReason: DWORD);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:;
    DLL_THREAD_ATTACH:;
    DLL_THREAD_DETACH:;
    DLL_PROCESS_DETACH: Application.Handle := 0;
  end;
end;

procedure InitApp(Handle: THandle);
begin
  Application.Handle := Handle;
end;
  exports
    InitApp;
begin
  ReportMemoryLeaksOnShutdown := Boolean(System.DebugHook);
  DllProc := @DLLHandler;
  DLLHandler(DLL_PROCESS_ATTACH);
end.
