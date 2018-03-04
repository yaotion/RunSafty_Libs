library RsNameplateLib;

uses
  ComServ,
  RsNameplateLib_TLB in 'RsNameplateLib_TLB.pas',
  RsNameplate_Impl in 'RsNameplate_Impl.pas' {RsNameplate: CoClass},
  RsGlobal_TLB in '����\RsGlobal_TLB.pas',
  uNamedGroupView in '���ܵ�Ԫ\uNamedGroupView.pas',
  uOrderGroupInTrainView in '���ܵ�Ԫ\uOrderGroupInTrainView.pas',
  uOrderGroupView in '���ܵ�Ԫ\uOrderGroupView.pas',
  uTogetherTrainView in '���ܵ�Ԫ\uTogetherTrainView.pas',
  uTrainmanOrderView in '���ܵ�Ԫ\uTrainmanOrderView.pas',
  uTrainmanView in '���ܵ�Ԫ\uTrainmanView.pas',
  uViewDefine in '���ܵ�Ԫ\uViewDefine.pas',
  uFrmAddCheCi in '���ܴ���\��ӻ���\��ӳ���\uFrmAddCheCi.pas' {FrmAddCheCi},
  uFrmAddJiChe in '���ܴ���\��ӻ���\��ӻ���\uFrmAddJiChe.pas' {FrmAddJiChe},
  uFrmPlanInfo in '���ܴ���\�ƻ�����\uFrmPlanInfo.pas' {FrmPlanInfo},
  uFrmNameBorardSelectStation in '���ܴ���\ѡ��վ\uFrmNameBorardSelectStation.pas' {FrmNameBorardSelectStation},
  uGroupXlsExporter in '���ܵ�Ԫ\uGroupXlsExporter.pas',
  uFrmAddUser in '���ܴ���\�����Ա\uFrmAddUser.pas' {FrmAddUser},
  EventSink in '..\������Demo\���ܵ�Ԫ\������\EventSink.pas',
  uTFComObject in '..\������Demo\���ܵ�Ԫ\������\uTFComObject.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  uNamePlateView in '���ܵ�Ԫ\uNamePlateView.pas',
  uScrollView in '���ܵ�Ԫ\uScrollView.pas',
  uViewGroup in '���ܵ�Ԫ\uViewGroup.pas',
  uFrameNamePlate in 'uFrameNamePlate.pas' {FrameNamePlate: TFrame},
  uFrameOrderGrp in 'uFrameOrderGrp.pas' {FrameOrderGrp: TFrame},
  uWebApiCollection in 'uWebApiCollection.pas',
  uFrameNamedGrp in 'uFrameNamedGrp.pas' {FrameNamedGrp: TFrame},
  uFrameTogetherGrp in 'uFrameTogetherGrp.pas' {FrameTogetherGrp: TFrame},
  uFramePrepare in 'uFramePrepare.pas' {FramePrepare: TFrame},
  uFrameUnrun in 'uFrameUnrun.pas' {FrameUnrun: TFrame},
  uFrmNameBoardChangeLog in '���ܴ���\�䶯��־\uFrmNameBoardChangeLog.pas' {frmNameBoardChangeLog},
  uFrmNameBoard in 'uFrmNameBoard.pas' {FrmNameBoard},
  uBindTMPopEdit in '���ܵ�Ԫ\uBindTMPopEdit.pas',
  uFramePlateQueue in 'uFramePlateQueue.pas' {FramePlateQueue: TFrame},
  uFrameNullPlate in 'uFrameNullPlate.pas' {FrameNullPlate: TFrame},
  uHintWindow in '���ܵ�Ԫ\uHintWindow.pas',
  RsLeaveLib_TLB in '����\RsLeaveLib_TLB.pas',
  uValidator in 'uValidator.pas',
  uNamePlatesExporter in '���ܵ�Ԫ\uNamePlatesExporter.pas',
  uFrameTxGrp in 'uFrameTxGrp.pas' {FrameTxGrp: TFrame},
  uLCNameBoard in '�ӿ�\uLCNameBoard.pas',
  uLCNameBoardEx in '�ӿ�\uLCNameBoardEx.pas',
  uDrinkExtls in '���ܵ�Ԫ\��Ƶ�Ԫ\uDrinkExtls.pas',
  uFrmDrinkInfo in '���ܴ���\���\uFrmDrinkInfo.pas' {FrmDrinkInfo},
  uLCBeginwork in '���ܵ�Ԫ\�г��ƻ�\uLCBeginwork.pas',
  uLCEndwork in '���ܵ�Ԫ\�г��ƻ�\uLCEndwork.pas',
  uFrmTrainmanDetail in '���ܴ���\��Ա��Ϣ��ʾ\uFrmTrainmanDetail.pas' {frmTrainmanDetail};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
