library RsGoodsManage;

uses
  ComServ,
  uFrmGoodsManage in '����\uFrmGoodsManage.pas' {frmGoodsManage},
  ufrmGoodsQuery in '����\ufrmGoodsQuery.pas' {frmGoodsQuery},
  uFrmGoodsRangeManage in '����\uFrmGoodsRangeManage.pas' {FrmGoodsRangeManage},
  uFrmGoodsRangeView in '����\uFrmGoodsRangeView.pas' {FrmGoodsRangeView},
  uFrmGoodsSend in '����\uFrmGoodsSend.pas' {frmGoodsSend},
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  RsGlobal_TLB in '..\global\RsGlobal_TLB.pas',
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  RsGoodsManage_TLB in 'RsGoodsManage_TLB.pas',
  uGoodsManageImp in 'uGoodsManageImp.pas' {GoodsManage: CoClass},
  RsTMFPLib_TLB in '..\��Աָ��ʶ��\RsTMFPLib_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
