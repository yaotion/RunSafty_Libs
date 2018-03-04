library RsGoodsManage;

uses
  ComServ,
  uFrmGoodsManage in '窗口\uFrmGoodsManage.pas' {frmGoodsManage},
  ufrmGoodsQuery in '窗口\ufrmGoodsQuery.pas' {frmGoodsQuery},
  uFrmGoodsRangeManage in '窗口\uFrmGoodsRangeManage.pas' {FrmGoodsRangeManage},
  uFrmGoodsRangeView in '窗口\uFrmGoodsRangeView.pas' {FrmGoodsRangeView},
  uFrmGoodsSend in '窗口\uFrmGoodsSend.pas' {frmGoodsSend},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  RsGoodsManage_TLB in 'RsGoodsManage_TLB.pas',
  uGoodsManageImp in 'uGoodsManageImp.pas' {GoodsManage: CoClass},
  RsTMFPLib_TLB in '..\人员指纹识别\RsTMFPLib_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
