library RsAlcoholLib;

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
  uTFSystem,
  SysUtils,
  Classes,
  uRsAlcoholImpl in 'uRsAlcoholImpl.pas',
  uFrmAlcoholUI_PC in '功能窗体\uFrmAlcoholUI_PC.pas' {frmAlcoholUI_PC},
  uRsAlcoholLib in 'uRsAlcoholLib.pas',
  uRsLibClass in '..\Libs\uRsLibClass.pas',
  uRsLibUtils in '..\Libs\uRsLibUtils.pas',
  uRsLibPoolLib in '..\类库管理池\uRsLibPoolLib.pas';

{$R *.res}

exports
  InitEntryPool,
  ReflectEntry;
begin
  RegEntryClass(TAlcoholCtl,True);
end.
