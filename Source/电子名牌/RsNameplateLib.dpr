library RsNameplateLib;

uses
  ComServ,
  RsNameplateLib_TLB in 'RsNameplateLib_TLB.pas',
  RsNameplate_Impl in 'RsNameplate_Impl.pas' {RsNameplate: CoClass},
  RsGlobal_TLB in '引用\RsGlobal_TLB.pas',
  uNamedGroupView in '功能单元\uNamedGroupView.pas',
  uOrderGroupInTrainView in '功能单元\uOrderGroupInTrainView.pas',
  uOrderGroupView in '功能单元\uOrderGroupView.pas',
  uTogetherTrainView in '功能单元\uTogetherTrainView.pas',
  uTrainmanOrderView in '功能单元\uTrainmanOrderView.pas',
  uTrainmanView in '功能单元\uTrainmanView.pas',
  uViewDefine in '功能单元\uViewDefine.pas',
  uFrmAddCheCi in '功能窗口\添加机班\添加车次\uFrmAddCheCi.pas' {FrmAddCheCi},
  uFrmAddJiChe in '功能窗口\添加机班\添加机车\uFrmAddJiChe.pas' {FrmAddJiChe},
  uFrmPlanInfo in '功能窗口\计划详情\uFrmPlanInfo.pas' {FrmPlanInfo},
  uFrmNameBorardSelectStation in '功能窗口\选择车站\uFrmNameBorardSelectStation.pas' {FrmNameBorardSelectStation},
  uGroupXlsExporter in '功能单元\uGroupXlsExporter.pas',
  uFrmAddUser in '功能窗口\添加人员\uFrmAddUser.pas' {FrmAddUser},
  EventSink in '..\类库调用Demo\功能单元\类库调用\EventSink.pas',
  uTFComObject in '..\类库调用Demo\功能单元\类库调用\uTFComObject.pas',
  uDialogsLib in '..\dialogs\uDialogsLib.pas',
  uGlobal in 'uGlobal.pas',
  uNamePlateView in '功能单元\uNamePlateView.pas',
  uScrollView in '功能单元\uScrollView.pas',
  uViewGroup in '功能单元\uViewGroup.pas',
  uFrameNamePlate in 'uFrameNamePlate.pas' {FrameNamePlate: TFrame},
  uFrameOrderGrp in 'uFrameOrderGrp.pas' {FrameOrderGrp: TFrame},
  uWebApiCollection in 'uWebApiCollection.pas',
  uFrameNamedGrp in 'uFrameNamedGrp.pas' {FrameNamedGrp: TFrame},
  uFrameTogetherGrp in 'uFrameTogetherGrp.pas' {FrameTogetherGrp: TFrame},
  uFramePrepare in 'uFramePrepare.pas' {FramePrepare: TFrame},
  uFrameUnrun in 'uFrameUnrun.pas' {FrameUnrun: TFrame},
  uFrmNameBoardChangeLog in '功能窗口\变动日志\uFrmNameBoardChangeLog.pas' {frmNameBoardChangeLog},
  uFrmNameBoard in 'uFrmNameBoard.pas' {FrmNameBoard},
  uBindTMPopEdit in '功能单元\uBindTMPopEdit.pas',
  uFramePlateQueue in 'uFramePlateQueue.pas' {FramePlateQueue: TFrame},
  uFrameNullPlate in 'uFrameNullPlate.pas' {FrameNullPlate: TFrame},
  uHintWindow in '功能单元\uHintWindow.pas',
  RsLeaveLib_TLB in '引用\RsLeaveLib_TLB.pas',
  uValidator in 'uValidator.pas',
  uNamePlatesExporter in '功能单元\uNamePlatesExporter.pas',
  uFrameTxGrp in 'uFrameTxGrp.pas' {FrameTxGrp: TFrame},
  uLCNameBoard in '接口\uLCNameBoard.pas',
  uLCNameBoardEx in '接口\uLCNameBoardEx.pas',
  uDrinkExtls in '功能单元\测酒单元\uDrinkExtls.pas',
  uFrmDrinkInfo in '功能窗口\测酒\uFrmDrinkInfo.pas' {FrmDrinkInfo},
  uLCBeginwork in '功能单元\行车计划\uLCBeginwork.pas',
  uLCEndwork in '功能单元\行车计划\uLCEndwork.pas',
  uFrmTrainmanDetail in '功能窗口\人员信息显示\uFrmTrainmanDetail.pas' {frmTrainmanDetail};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
