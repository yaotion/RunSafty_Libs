unit uFrmNameBoardManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PngCustomButton, ComCtrls, RzDTP, StdCtrls, ExtCtrls, Buttons,
  PngSpeedButton, RzPanel, RzStatus, uTFTabletop, RzTabs, AdvSplitter, RzTreeVw,
  uTFSystem,uTrainmanJiaolu,uTrainJiaolu,uTrainman,
  uSaftyEnum,uNamedGroupView,uOrderGroupInTrainView,uOrderGroupView,
  uTogetherTrainView,uTrainmanView, PngImageList, Menus,uTrainmanOrderView,uStation,
  uTrainPlan,  Mask, RzEdit, ActnList,uDutyPlace,uLCDutyPlace,uLCTrainPlan,
  uLCNameBoard, utfLookupEdit,utfPopTypes,uLCTrainJiaolu,uLCNameBoardEx,
  uLCTrainmanMgr,RsGlobal_TLB,uHttpWebAPI,
  uLCDict_TrainmanJiaoLu,uLCDict_Station;
const
  WM_Message_RefreshNormal = WM_USER + 1;
  WM_Message_RefreshOrder = WM_User + 2;
  WM_Message_Repaint = WM_User + 3;


  TAB_NAME_UNRUN = '����ת��Ա';
  TAB_NAME_PREPARE = 'Ԥ����Ա';
  TAB_NAME_NULL='δ������Ա';
  TAB_NAME_TX = '����';

type
  TfrmNameBoardManage = class(TForm)
    RzStatusBar1: TRzStatusBar;
    statusPanelSum: TRzStatusPane;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    lblHint: TLabel;
    RzPanel3: TRzPanel;
    AdvSplitter1: TAdvSplitter;
    pBoardParent: TRzPanel;
    tabZFQD: TRzTabControl;
    Panel1: TPanel;
    treeJiaolu: TRzTreeView;
    PngImageCollection: TPngImageCollection;
    pmenuNamed: TPopupMenu;
    miAddNamedGroup: TMenuItem;
    N2: TMenuItem;
    miAddNamedTrainman: TMenuItem;
    miDeleteNamedTrainman: TMenuItem;
    N5: TMenuItem;
    miDeleteNamedGroup: TMenuItem;
    tabtopBoard: TTFTabletop;
    pmenuOrder: TPopupMenu;
    miAddOrderGroup: TMenuItem;
    miDeleteOrderGroup: TMenuItem;
    MenuItem3: TMenuItem;
    miAddOrderTrainman: TMenuItem;
    miDeleteOrderTrainman: TMenuItem;
    MenuItem6: TMenuItem;
    pmenuTogether: TPopupMenu;
    miAddTogetherGroup: TMenuItem;
    miDeleteTogetherGroup: TMenuItem;
    MenuItem9: TMenuItem;
    miAddTogetherTrainman: TMenuItem;
    miDeleteTogetherTrainman: TMenuItem;
    MenuItem12: TMenuItem;
    N1: TMenuItem;
    miAddTogetherTrain: TMenuItem;
    miDeleteTogetherTrain: TMenuItem;
    RzPanel1: TRzPanel;
    Label2: TLabel;
    btnQuery: TPngSpeedButton;
    miOrderCut: TMenuItem;
    N4: TMenuItem;
    miOrderPasteBefore: TMenuItem;
    miOrderPasteAfter: TMenuItem;
    miOrderPasteCover: TMenuItem;
    miEditCheci: TMenuItem;
    miUpdateTrain: TMenuItem;
    pMenu1: TPopupMenu;
    mniDelPlate: TMenuItem;
    btnConvertState: TPngSpeedButton;
    actlst1: TActionList;
    actDel: TAction;
    mniNamedViewPlan: TMenuItem;
    N6: TMenuItem;
    mniOrderViewPlan: TMenuItem;
    mniTogegherViewPlan: TMenuItem;
    actViewPlan: TAction;
    pmenuUnnormalOrderPopup: TPopupMenu;
    mniUnnormalOrderDelete: TMenuItem;
    mniUnnormalOrderMove: TMenuItem;
    N3: TMenuItem;
    M1: TMenuItem;
    N7: TMenuItem;
    miInsertOrderGroup: TMenuItem;
    edtTrainman1: TtfLookupEdit;
    miEditOrder: TMenuItem;
    btnExport: TPngSpeedButton;
    btnImport: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    btnManualTurnLeft: TSpeedButton;
    btnManualTurnRight: TSpeedButton;
    mniNamedViewKeyTrainman: TMenuItem;
    mniNamedViewFixedGroup: TMenuItem;
    mniOrderViewKeyTrainman: TMenuItem;
    mniTogegherViewKeyTrainman: TMenuItem;
    mniTogegherViewFixedGroup: TMenuItem;
    mniOrderViewFixedGroup: TMenuItem;
    N8: TMenuItem;
    miTX_Named: TMenuItem;
    N10: TMenuItem;
    miTX_Order: TMenuItem;
    N9: TMenuItem;
    miTX_Together: TMenuItem;
    PopupMenuTX: TPopupMenu;
    miTX_End: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure treeJiaoluChange(Sender: TObject; Node: TTreeNode);
    procedure pmenuNamedPopup(Sender: TObject);
    procedure tabZFQDChange(Sender: TObject);
    procedure pmenuOrderPopup(Sender: TObject);
    procedure pmenuTogetherPopup(Sender: TObject);
    
    procedure miAddNamedGroupClick(Sender: TObject);
    procedure miDeleteNamedGroupClick(Sender: TObject);
    procedure miAddNamedTrainmanClick(Sender: TObject);
    procedure miDeleteNamedTrainmanClick(Sender: TObject);
    
    procedure miAddOrderGroupClick(Sender: TObject);
    procedure miDeleteOrderGroupClick(Sender: TObject);
    procedure miAddOrderTrainmanClick(Sender: TObject);
    procedure miDeleteOrderTrainmanClick(Sender: TObject);

    procedure miAddTogetherTrainClick(Sender: TObject);
    procedure miDeleteTogetherTrainClick(Sender: TObject);
    procedure miAddTogetherGroupClick(Sender: TObject);
    procedure miDeleteTogetherGroupClick(Sender: TObject);
    procedure miAddTogetherTrainmanClick(Sender: TObject);
    procedure miDeleteTogetherTrainmanClick(Sender: TObject);
    
    procedure miAddPrepareTrainmanClick(Sender: TObject);
    procedure miDeletePrepareTrainmanClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure miOrderCutClick(Sender: TObject);
    procedure miOrderPasteBeforeClick(Sender: TObject);
    procedure miOrderPasteCoverClick(Sender: TObject);
    procedure miOrderPasteAfterClick(Sender: TObject);
    procedure btnManualTurnLeftClick(Sender: TObject);
    procedure miEditCheciClick(Sender: TObject);
    procedure miUpdateTrainClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPYKeyPress(Sender: TObject; var Key: Char);
    procedure mniN4Click(Sender: TObject);
    procedure mniDelPlateClick(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure mniNamedViewPlanClick(Sender: TObject);
    procedure mniOrderViewPlanClick(Sender: TObject);
    procedure mniTogegherViewPlanClick(Sender: TObject);
    procedure mniUnnormalOrderDeleteClick(Sender: TObject);
    procedure mniUnnormalOrderMoveClick(Sender: TObject);
    procedure pmenuUnnormalOrderPopupPopup(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure miInsertOrderGroupClick(Sender: TObject);
    procedure edtTrainman1Change(Sender: TObject);
    procedure edtTrainman1NextPage(Sender: TObject);
    procedure edtTrainman1PrevPage(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure btnManualTurnRightClick(Sender: TObject);
    procedure miEditOrderClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure miTX_NamedClick(Sender: TObject);
    procedure miTX_OrderClick(Sender: TObject);
    procedure miTX_TogetherClick(Sender: TObject);
    procedure miTX_EndClick(Sender: TObject);
    procedure PopupMenuTXPopup(Sender: TObject);
  private
    procedure WMMessageRefreshNormal(var Msg : TMessage) ; message WM_Message_RefreshNormal;
    procedure WMMessageRefreshOrder(var Msg : TMessage) ; message WM_Message_RefreshOrder;
    procedure WMMessageRepaint(var Msg : TMessage); message WM_Message_Repaint;
  private
    { Private declarations }
    m_DutyUser: TRsLCBoardInputDuty;
    m_InputJL: TRsLCBoardInputJL;
    
    //�Ƿ���Ա༭����
    m_bEditEnabled : boolean;
    //������·�ӿ�
    m_webTrainJiaoLu:TRsLCTrainJiaolu;
    //���ƽӿ�
    m_webNameBoard:TRsLCNameBoard;
    //�ƻ��ӿ�
    m_webTrainPlan:TRsLCTrainPlan;
    //���ڵ�ӿ�
    m_webDutyPlace:TRsLCDutyPlace;
    //��ǰ���е��г������б�
    m_TrainJiaoluArray : TRsTrainJiaoluArray;
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    //��ǰ���е���Ա��·�б�
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    //��ǰѡ�е���Ա��·
    m_SelectedTrainmanJiaolu : RRsTrainmanJiaolu;
    //��Ա��Ϣ���ݿ������
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //��ǰѡ�е�VIEW
    m_SelectView : TView;
    //��ǰ�������µĳ��ڵ�
    m_listDutyPlace:TRsDutyPlaceList;
    //��ȡ�����GUID
    m_strWorkShopGUID : string;
    //���еĻ����GUID
    m_CutView : TView;
    //��ǰѡ�е���Ա��Ϣ
    m_SelectUserInfo: RRsTrainman;
  
    m_LCTrainmanJiaolu :TRsLCTrainmanJiaolu; 
    m_LCStation : TRsLCStation;
    //��ʼ����������·��
    procedure InitTrainJiaolu;
    //��ʼ����������
    procedure InitJiaoluTab;
    procedure InitTXTab(TrainmanJiaoluGUID : string);
    //��ʼ����·�ڵķ���ת(���)��ǩ
    procedure InitUnrunTab(TrainmanJiaoluGUID : string);
    //��ʼ����·�ڵ�Ԥ��(����)��ǩ
    procedure InitPrepareTab(TrainmanJiaoluGUID : string);
    //��ʼ���ֳ˽�·�ı�ǩ��Ϣ(���ڵ�)
    procedure InitOrderJiaoluTab(TrainmanJiaoluGUID : string);
    //��ʼ����δ������վ (����)
    procedure InitOrderNullTab(TrainmanJiaoluGUID: string);    
    //��ʼ������ʽ��·�ı�ǩ��Ϣ
    procedure InitNamedJiaoluTab(TrainmanJiaoluGUID : string);
    //��ʼ�����˽�·�ı�ǩ��Ϣ
    procedure InitTogetherJiaoluTab(TrainmanJiaoluGUID : string);


    procedure InitTXGroups(TrainmanJiaoluGUID : string);
    //��ʼ����·�µķ���ת(������)��Ա����
    procedure InitUnrunTrainman(TrainmanJiaoluGUID : string);
    //��ʼ����·�µ�Ԥ��(����)��Ա����
    procedure InitPrepareTrainman(TrainmanJiaoluGUID : string);
    //��ʼ���ֳ˽�·�µ�����
    procedure InitOrderBoard(TrainmanJiaoluGUID :string);
    //��ʼ���ֳ˽�·�ڻ���������վΪ�յ�����
    procedure ShowUnnormalOrderBoard(TrainmanJiaoluGUID :string);
    //��ʼ������ʽ��·�µ�����
    procedure InitNamedBoard(TrainmanJiaoluGUID :string);
    //��ʼ�����˽�·�µ�����
    procedure InitTogetherBoard(TrainmanJiaoluGUID :string);


    //��ʼ����Ա���ҿؼ�������Ϣ
    procedure IniColumns(LookupEdit : TtfLookupEdit);
    //���õ�������������
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);


    //���ü���ʽ�����Ҽ��˵�
    procedure DisabledNamedPopMenu;
    //�����ֳ������Ҽ��˵�
    procedure DisableOrderPopMenu;
    //���ð��������Ҽ��˵�
    procedure DisabledTogetherPopMenu;


    //��ȡѡ�е���Ա��·��Ϣ
    function GetSelectedTrainmaJiaolu(out TrainmanJiaolu : RRsTrainmanJiaolu) : boolean;
    //��ȡѡ�е��г���·
    function GetSelectedTrainJiaolu(out TrainJiaoLuGUID:string):boolean ;
    //��ȡѡ�еĳ��ڵ���Ϣ
    function GetSelectedDutyPlace(out DutyPlace:RRsDutyPlace):Boolean;

    //��ȡѡ�е�������Ϣ
    function GetSelectedView : TView;

    //����ʽ��·����Ա��קʩ�ź���
    procedure NamedTrainmanDragDrop(Sender:TTrainmanView;TrainmanView:TTrainmanView);
    //����ʽ������ק�ͷź���
    procedure NamedGroupDragDrop(Sender:TNamedGroupView;
      NamedGroupView:TNamedGroupView);
    //�ֳ˽�·����Ա��קʩ�ź���
    procedure OrderTrainmanDragDrop(Sender:TTrainmanView;TrainmanView:TTrainmanView);
    //�ֳ˻�����ק�ͷź���
    procedure OrderGroupDragDrop(Sender:TOrderGroupView;OrderGroupView:TOrderGroupView);
     //���˽�·����Ա��קʩ�ź���
    procedure TogetherTrainmanDragDrop(Sender:TTrainmanView;TrainmanView:TTrainmanView);
    //���˻�����ק�ͷź���
    procedure TogetherGroupDragDrop(Sender:TOrderGroupInTrainView;OrderGroupInTrainView:TOrderGroupInTrainView);
    //���˻�����ק�ͷź���
    procedure NotAllowTrainmanDrag(Sender:TTrainmanView;TrainmanView:TTrainmanView;var bIsOver:Boolean);
    procedure ExchangeOrderGroup(Sender:TOrderGroupView;OrderGroupView:TOrderGroupView);

    ///�Ƿ��ǲ�ѯ�Ļ���
    function IsQueriedGroup(Group : RRsGroup) : boolean;
    //�Ƿ��ǲ�ѯ����Ա
    function IsQueriedTrainman(Trainman : RRsTrainman) : boolean;
    //�����Ա�Ƿ�����ֵ��
    function IsTrainmanBusy(TrainmanGUID : string) : boolean;
    //�������Ƿ�����ֵ�˼ƻ�
    function IsGroupBusy(GroupGUID : string) : boolean;
    //��⵱ǰ���˻����Ƿ�������ֵ�˵Ļ���
    function IsTrainBusy(TrainGUID : string) : boolean;

    //��ȡ��ǰ��ͼ��ǰһ����ͼ
    function GetPrevView(View : TView) : TVIEW;
    //��ȡ��ǰ��ͼ�ĺ�һ����ͼ
    function GetNextView(View : TView) : TVIEW;
    //���¼��㵱ǰ��ͼ�ڸ���ͼ��λ��
    procedure ReorderOrderViews;
    procedure ReorderNamedViews;

    
    //������ӵ���Ա�Ƿ�ϸ�
    function CheckAddTrainman(Group : RRsGroup;Trainman:RRsTrainman) : boolean;
    //���������Ա�Ƿ��Ѿ������Ź�����
    function CheckGroupIsOwner(Group : RRsGroup;JiaoluType:TRsJiaoluType) : boolean;
    
    //������ӻ����Ƿ�ϸ�
    function CheckAddGroup(Group : RRsGroup):boolean;
    ////////////////////--add----------------------------/////////////////////
    function UsesDelGroup : boolean;
    function GetWebUrl: string;
    procedure Init;
    function GetNameplateTrainmanJiaolu: string;
    procedure SetNameplateTrainmanJiaolu(const Value: string);
  public
    webAPIUtils : TWebAPIUtils;
  public
    property NameplateTrainmanJiaolu : string read GetNameplateTrainmanJiaolu
      write SetNameplateTrainmanJiaolu;
  public
    { Public declarations }
    class procedure OpenNameBoardManage(
      EditEnabled : boolean = true;CanDel : boolean = true);
  end;



implementation
uses
  uFrmAddGroup,uFrmAddCheCi,uFrmAddUser,uFrmAddJiChe,DateUtils,uFrmTrainmanSelect,
  ComObj,
  uFrmPlanInfo,uFrmNameBorardSelectStation,uFrmSelectDutyPlace,
  uGroupXlsExporter, uDutyUser, uDialogsLib, uGlobal;
var
  frmNameBoardManage: TfrmNameBoardManage = nil;
{$R *.dfm}

{ TfrmNameBoardManage }

procedure TfrmNameBoardManage.actDelExecute(Sender: TObject);
var
  trainmanView : TTrainmanView;
begin
  Exit ;
  trainmanView := TTrainmanView ( GetSelectedView );
  if (trainmanView = nil)  then
  begin
    Box('����ָ��Ҫת���ĳ���Ա��Ϣ');
    exit;
  end;

  if TBox('ȷ��ת����?') then
  begin
    m_RsLCNameBoardEx.Trainman.SetStateToNull(trainmanView.Trainman.strTrainmanGUID);
    TBox('ת���ɹ�');
    InitJiaoluTab;
  end;
end;


procedure TfrmNameBoardManage.btnExportClick(Sender: TObject);
var
  strFileName:string;
  trainmanJiaolu : RRsTrainmanJiaolu;
  GroupXlsExporter: TGroupXlsExporter;
begin
  //�ų� Ԥ����Ա�ͷ���ת��Ա
  if treeJiaolu.Selected.Level = 0 then
  begin
    if treeJiaolu.Selected.Index = 0 then
    begin
      BoxErr('��֧�ֵ���Ԥ����Ա');
      exit;
    end;
    if treeJiaolu.Selected.Index = 1 then
    begin
      BoxErr('��֧�ֵ�������ת��Ա');
      exit;
    end;
  end;


  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then
  begin
    BoxErr('û�л�ȡ��ѡ�е���Ա��·');
    exit;
  end;


  if not SaveDialog.Execute(Self.Handle)  then
    exit ;
  strFileName := SaveDialog.FileName ;
  GroupXlsExporter := TGroupXlsExporter.Create(m_RsLCNameBoardEx,m_RsLCTrainmanMgr,m_webNameBoard);
  try
    GroupXlsExporter.ExportGroups(trainmanJiaolu,strFileName);
  finally
    GroupXlsExporter.Free;
  end;

end;

procedure TfrmNameBoardManage.btnImportClick(Sender: TObject);
var
  strFileName,strText,strError:string;
  trainmanJiaolu : RRsTrainmanJiaolu;
  GroupXlsExporter: TGroupXlsExporter;
begin
  //�ų� Ԥ����Ա�ͷ���ת��Ա
  if treeJiaolu.Selected.Level = 0 then
  begin
    if treeJiaolu.Selected.Index = 0 then
    begin
      BoxErr('��֧�ֵ���Ԥ����Ա');
      exit;
    end;
    if treeJiaolu.Selected.Index = 1 then
    begin
      BoxErr('��֧�ֵ�������ת��Ա');
      exit;
    end;
  end;


  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then
  begin
    BoxErr('û�л�ȡ��ѡ�е���Ա��·');
    exit;
  end;

  if TBox('����ǰ,�Ƿ�ɾ���ý�·�����ͼ������?') then
  begin
    if not m_webNameBoard.DeleteNamedGroupByJiaoLu(trainmanJiaolu.strTrainmanJiaoluGUID,strError) then
    begin
      BoxErr(strError);
      Exit ;
    end;
  end;

  strText := Format('��ǰѡ�еĽ�·Ϊ: [%s] ,�Ƿ��������?',[trainmanJiaolu.strTrainmanJiaoluName]);
  if not TBox(strText) then
    Exit ;

  if not OpenDialog.Execute then exit;
  strFileName := OpenDialog.FileName ;
  
  GroupXlsExporter := TGroupXlsExporter.Create(m_RsLCNameBoardEx,m_RsLCTrainmanMgr,m_webNameBoard);
  try
    GroupXlsExporter.ImportGroups(trainmanJiaolu,strFileName,
      GlobalDM.User.ID,GlobalDM.User.Number,GlobalDM.User.Name);
    InitNamedBoard(trainmanJiaolu.strTrainmanJiaoluGUID);
  finally
    GroupXlsExporter.Free;
  end;



end;

procedure TfrmNameBoardManage.btnManualTurnLeftClick(Sender: TObject);
begin
  try
    m_RsLCNameBoardEx.Named.Group.Turn(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID,1);
    InitJiaoluTab;
  except on e : exception do
    BoxErr('�����쳣��' + e.Message);
  end;
end;

procedure TfrmNameBoardManage.btnManualTurnRightClick(Sender: TObject);
begin
  try
    m_RsLCNameBoardEx.Named.Group.Turn(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID,2);

    InitJiaoluTab;
  except on e : exception do
    BoxErr('�����쳣��' + e.Message);
  end;
end;

procedure TfrmNameBoardManage.btnQueryClick(Sender: TObject);
var
  i: integer;
  Node: TTreeNode;
  TrainmanJiaolu : RRsTrainmanJiaolu;
  FindRet: TRsLCBoardTmFindRet;
begin
  if edtTrainman1.Text = '' then
  begin
    InitJiaoluTab ;
    Exit ;
  end;

  if m_SelectUserInfo.strTrainmanGUID = '' then
  begin
    Box('û���ҵ�ָ�������ĳ���Ա��');
    exit;
  end;


  FindRet := TRsLCBoardTmFindRet.Create;
  try
    if not m_RsLCNameBoardEx.Trainman.Find(m_SelectUserInfo.strTrainmanNumber,FindRet) then
    begin
      Box('û���ҵ�ָ�������ĳ���Ա���ƣ�');
      exit;
    end;
    //�� �г���·��ʼ����
    //����Ա��·��
    for i := 0 to treeJiaolu.Items.Count - 1 do
    begin
      Node := treeJiaolu.Items[i];
      if Node.Level = 1 then
      begin
        TrainmanJiaolu := m_TrainmanJiaoluArray[Integer(Node.Data)];
        if (TrainmanJiaolu.strTrainmanJiaoluGUID = FindRet.strTrainmanJiaoluGUID) then
        begin
          Node.Expanded := true;
          if not Node.Selected then
            Node.Selected := true
          else
            InitJiaoluTab;
          exit;
        end;
      end;
    end;
  finally
    FindRet.Free;
  end;



end;

function TfrmNameBoardManage.CheckGroupIsOwner(Group: RRsGroup;JiaoluType:TRsJiaoluType): boolean;
var
  Msg: string;
begin

  Result := m_RsLCNameBoardEx.Group.PersonInOtherGrp(Group.Trainman1.strTrainmanNumber,
    Group.Trainman2.strTrainmanNumber,
    Group.Trainman3.strTrainmanNumber,
    Group.Trainman4.strTrainmanNumber,Msg);

  if not Result then
  begin
    Box(Msg);
  end;
end;

function TfrmNameBoardManage.CheckAddGroup(Group: RRsGroup): boolean;
var
  msg: string;
begin
  Result := m_RsLCNameBoardEx.Group.IsBusy(Group.strGroupGUID,msg);
  if not Result then
    Box(msg);
end;

function TfrmNameBoardManage.CheckAddTrainman(Group: RRsGroup;
  Trainman: RRsTrainman): boolean;
begin
  result := false;
  if IsGroupBusy(Group.strGroupGUID) then
  begin
    Box('�û����Ѱ��żƻ������������Ա');
    exit;
  end;
  if IsTrainmanBusy(trainman.strTrainmanGUID) then
  begin
    Box('����Ա����ֵ�˱�ļƻ����������Ա');
    exit;
  end;
  if trainman.nTrainmanState = tsUnRuning then
  begin
    Box('��������������Ϊ����Աִ�����ٲ����ٰ�������');
    exit;
  end;
  result := true;
end;

procedure TfrmNameBoardManage.DisabledNamedPopMenu;
begin
  miAddNamedGroup.Enabled := false;
  miAddNamedTrainman.Enabled := false;
  miEditCheci.Enabled := False;
  miTX_Named.Enabled := False;
end;

procedure TfrmNameBoardManage.DisabledTogetherPopMenu;
var
  i: Integer;
begin
  for I := 0 to pmenuTogether.Items.Count - 1 do
  begin
    pmenuTogether.Items.Items[i].Enabled := False;
  end;
end;

procedure TfrmNameBoardManage.DisableOrderPopMenu;
begin
  miAddOrderGroup.Enabled := false;
  miAddOrderTrainman.Enabled := false;
  miOrderCut.Enabled := false;
  miOrderPasteBefore.Enabled := false;
  miOrderPasteAfter.Enabled := false;
  miOrderPasteCover.Enabled := false;
  miTX_Order.Enabled := False;
end;

procedure TfrmNameBoardManage.edtPYKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnQuery.Click;
  end;
end;

procedure TfrmNameBoardManage.edtTrainman1Change(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := 1;
    strWorkShopGUID := '' ;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmNameBoardManage.edtTrainman1NextPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    strWorkShopGUID := '' ;
    m_RsLCTrainmanMgr.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmNameBoardManage.edtTrainman1PrevPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID:string;
begin        
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    strWorkShopGUID := '' ;
    m_RsLCTrainmanMgr.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmNameBoardManage.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman1.OnChange := nil;
  try
   if edtTrainman1.Text <> '' then
    m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,m_SelectUserInfo)
   else
    m_RsLCTrainmanMgr.GetTrainman('',m_SelectUserInfo) ;

   edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
     edtTrainman1.OnChange := edtTrainman1Change;
  end;
end;



procedure TfrmNameBoardManage.ExchangeOrderGroup(Sender,
  OrderGroupView: TOrderGroupView);
var
  tmpGroup : RRsOrderGroup;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  if not TBox('ȷ���������������λ����') then
    Exit ;

  if not GetSelectedTrainmaJiaolu(TrainmanJiaolu) then
  begin
    Box('��ѡ����Ա��·!');
    Exit;
  end;
  m_InputJL.SetTrainmanJL(TrainmanJiaolu);

  m_RsLCNameBoardEx.Group.Swap(m_InputJL,m_DutyUser,Sender.OrderGroup.Group.strGroupGUID,
  OrderGroupView.OrderGroup.Group.strGroupGUID);


  tmpGroup := sender.OrderGroup;


  tabtopBoard.ExchangeView(Sender, OrderGroupView);
  ReorderOrderViews;
end;

procedure TfrmNameBoardManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  frmNameBoardManage := nil;
end;

procedure TfrmNameBoardManage.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
  m_LCStation.Free;
  m_webDutyPlace.Free ;
  m_webTrainPlan.Free ;
  m_webNameBoard.Free ;
  m_webTrainJiaoLu.Free ;

  m_RsLCNameBoardEx.Free;
  m_DutyUser.Free;
  m_InputJL.Free;
  m_LCTrainmanJiaolu.free;
  webAPIUtils.Free;
end;

function TfrmNameBoardManage.GetNameplateTrainmanJiaolu: string;
begin
  result := GlobalDM.ReadIniConfig('UserData','NameplateTrainmanJiaolu');
end;

function TfrmNameBoardManage.GetNextView(View: TView): TVIEW;
var
  i,nIndex : integer;
begin
  result := nil;
  nIndex := -1;
  for i := 0 to tabtopBoard.GetViewCount - 1 do
  begin
    if (tabtopBoard.GetView(i) = VIEW) then
    begin
       nIndex := i;
       break;
    end;
  end;
  if (nIndex < 0) or (nIndex > tabtopBoard.GetViewCount - 1) then
    exit;
  nIndex := nIndex + 1;
  if (nIndex < 0) or (nIndex > tabtopBoard.GetViewCount - 1) then
    exit;
  result := tabtopBoard.GetView(nIndex);
  
end;

function TfrmNameBoardManage.GetPrevView(View: TView): TVIEW;
var
  i,nIndex : integer;
begin
  result := nil;
  nIndex := -1;
  for i := 0 to tabtopBoard.GetViewCount - 1 do
  begin
    if (tabtopBoard.GetView(i) = VIEW) then
    begin
       nIndex := i;
       break;
    end;
  end;
  if (nIndex < 0) or (nIndex > tabtopBoard.GetViewCount - 1) then
    exit;
  nIndex := nIndex - 1;
  if (nIndex < 0) or (nIndex > tabtopBoard.GetViewCount - 1) then
    exit;
  result := tabtopBoard.GetView(nIndex);
end;

function TfrmNameBoardManage.GetSelectedDutyPlace(
  out DutyPlace: RRsDutyPlace): Boolean;
begin
  result := false;
  if tabZFQD.Tabs.Count = 0 then exit;
  if (tabZFQD.TabIndex + 1) > length(m_listDutyPlace) then exit;
  DutyPlace := m_listDutyPlace[tabZFQD.TabIndex];
  result := true;
end;

function TfrmNameBoardManage.GetSelectedTrainJiaolu(
  out TrainJiaoLuGUID: string): boolean;
const
  PREPARE_RUN = 0 ; //Ԥ��
  UN_RUN = 1 ;      //����ת
var
  nIndex:Integer;
begin

  result := false ;

  if treeJiaolu.Selected = nil  then
    Exit ;

  nIndex := Integer(treeJiaolu.Selected.Data) ;
  if treeJiaolu.Selected.Level = 1 then
  begin
    nIndex := Integer(treeJiaolu.Selected.Parent.Data);
  end;


  TrainJiaoLuGUID := m_TrainJiaoluArray[nIndex].strTrainJiaoluGUID ;
  
  result := true ;
end;

function TfrmNameBoardManage.GetSelectedTrainmaJiaolu(
  out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
begin
  result := false;
  if m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID = '' then exit;
  TrainmanJiaolu := m_SelectedTrainmanJiaolu;
  result := true;
end;

function TfrmNameBoardManage.GetSelectedView: TView;
var
  pt : TPoint;
begin
  pt := tabtopBoard.ScreenToClient(mouse.CursorPos);
  Result := tabtopBoard.FindView(pt.X,pt.Y);
end;

function TfrmNameBoardManage.GetWebUrl: string;
var
  strUrl : string;
begin
  strUrl := GlobalDM.WebAPI.URL;
  Result := strUrl ;
end;

procedure TfrmNameBoardManage.InitUnrunTab(TrainmanJiaoluGUID : string);
var
  tabItem : TRzTabCollectionItem ;
begin
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := TAB_NAME_UNRUN;
end;


procedure TfrmNameBoardManage.IniColumns(LookupEdit: TtfLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '���';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '����';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '����';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := 'ְ��';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '�ͻ�';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '�ؼ���';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := 'ABCD';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '��ϵ�绰';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '״̬';
  col.Width := 80;
end;

procedure TfrmNameBoardManage.Init;
var
  bUses:Boolean;
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=GlobalDM.WebAPI.Host;
  webAPIUtils.Port := GlobalDM.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  m_LCTrainmanJiaolu := TRsLCTrainmanJiaolu.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_LCStation := TRsLCStation.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(WebAPIUtils);
  m_webDutyPlace := TRsLCDutyPlace.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webTrainPlan := TRsLCTrainPlan.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webNameBoard := TRsLCNameBoard.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webTrainJiaoLu := TRsLCTrainJiaolu.Create(GetWebUrl,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(WebAPIUtils);
  pBoardParent.DoubleBuffered  := false;
  tabtopBoard.DoubleBuffered := true;
  tabtopBoard.AutoScroll := false;
  tabtopBoard.AutoSize := false;



  IniColumns(edtTrainman1);

  //�Ƿ�����ɾ���������Ա
  bUses :=  UsesDelGroup ;
  miDeleteNamedTrainman.Enabled := bUses ;
  miDeleteNamedGroup.Enabled := bUses ;

  miDeleteOrderTrainman.Enabled := bUses;
  miDeleteOrderGroup.Enabled := bUses ;

  miDeleteTogetherTrainman.Enabled := bUses ;
  miDeleteTogetherGroup.Enabled := bUses ;

  m_bEditEnabled := true;

  m_DutyUser := TRsLCBoardInputDuty.Create;
  m_InputJL := TRsLCBoardInputJL.Create;
  
  m_DutyUser.strDutyGUID := GlobalDM.User.ID;
  m_DutyUser.strDutyNumber := GlobalDM.User.Number;
  m_DutyUser.strDutyName := GlobalDM.User.Name;
end;

procedure TfrmNameBoardManage.InitJiaoluTab;
var
  HintBox: TNoFocusHint;
begin
  tabtopBoard.BeginUpdate;
  tabtopBoard.PopupMenu := nil;
  m_CutView := nil;
  m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID := '';
  HintBox := TNoFocusHint.Create;
  HintBox.Hint('���ڼ����������ݡ���');
  try
    if treeJiaolu.Selected = nil then
    begin
      tabZFQD.Tabs.Clear;
      tabtopBoard.ClearView;
      NameplateTrainmanJiaolu := '';
      exit;
    end;
    m_SelectedTrainmanJiaolu := m_TrainmanJiaoluArray[Integer(treeJiaolu.Selected.Data)];
    NameplateTrainmanJiaolu := m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID;

    btnManualTurnLeft.Enabled := False;
    btnManualTurnRight.Enabled := False;
    case m_SelectedTrainmanJiaolu.nJiaoluType of
      jltNamed :
      begin
        btnManualTurnLeft.Enabled := True;
        btnManualTurnRight.Enabled := True;
        if m_bEditEnabled then
          tabtopBoard.PopupMenu := pmenuNamed;
        InitNamedJiaoluTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);

        InitUnrunTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitPrepareTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitTXTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
      end;
      jltOrder : begin
        tabtopBoard.PopupMenu := pmenuOrder;
        InitOrderJiaoluTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitUnrunTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitOrderNullTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitPrepareTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitTXTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
      end;
      jltTogether : begin
        if m_bEditEnabled then
          tabtopBoard.PopupMenu := pmenuTogether;

        InitTogetherJiaoluTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitUnrunTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitPrepareTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
        InitTXTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
      end;
    end;
  finally
    tabtopBoard.EndUpdate;
    HintBox.Close();
    HintBox.Free;
  end;
end;


procedure TfrmNameBoardManage.InitNamedJiaoluTab(TrainmanJiaoluGUID: string);
var
  namedGroupArray : TRsNamedGroupArray;
  namedView : TNamedGroupView;
  i : integer;
  tabItem : TRzTabCollectionItem;
  blnSelected: boolean;
  ErrInfo: string;
begin
  tabtopBoard.ClearView;
  tabZFQD.Tabs.Clear;
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := '����ʽ��·��Ա����';
  tabZFQD.TabIndex := 0;
  Exit;

  tabtopBoard.SetLayoutType(ltVertical);
  blnSelected := false;


  if not m_webNameBoard.GetNamedGroup(TrainmanJiaoluGUID,namedGroupArray,ErrInfo) then
  begin
    Box(ErrInfo);
    Exit;
  end;
  try
    for i := 0 to length(namedGroupArray) - 1 do
    begin
      namedView := TNamedGroupView.Create(nil);
      namedView.OnTrainmanDragOver := NamedTrainmanDragDrop;
      namedView.OnNamedGroupDragOver := NamedGroupDragDrop;
      namedGroupArray[i].nCheciOrder := i + 1;
      namedView.NamedGroup := namedGroupArray[i];
      namedView.Images := PngImageCollection;
      tabtopBoard.AddView(namedView);
      if IsQueriedGroup(namedGroupArray[i].Group) then
      begin
        namedView.Selected := true;
        if not blnSelected then
        begin
          tabtopBoard.VertScrollBar.Position := namedView.top + namedView.Height - tabtopBoard.Height;
          tabtopBoard.ReCanvas;
          blnSelected := true;
        end;
      end;
    end;
  finally
  end;
end;


procedure TfrmNameBoardManage.InitOrderJiaoluTab(TrainmanJiaoluGUID: string);
var
  trainmanJiaolu : RRsTrainmanJiaolu;
  tabItem : TRzTabCollectionItem;
  i: integer;
  nTrainJiaoluIndex : integer;
  trainJiaoluGUID : string;
  strError:string;
begin
  tabZFQD.Tabs.Clear;
  nTrainJiaoluIndex := -1;
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  if (treeJiaolu.Selected = nil) then exit;
  //��ǰѡ���Ϊ��Ա��·
  if (treeJiaolu.Selected.Level = 1) then
  begin
    nTrainJiaoluIndex := Integer(treeJiaolu.Selected.Parent.Data);
  end;
  //��ǰѡ���Ϊ������·
  if (treeJiaolu.Selected.Level = 0) then
  begin
    if treeJiaolu.Selected.Index < 2 then  exit;
    nTrainJiaoluIndex := Integer(treeJiaolu.Selected.Data);
  end;
  if nTrainJiaoluIndex < 0 then exit;
  
  trainJiaoluGUID := m_TrainJiaoluArray[nTrainJiaoluIndex].strTrainJiaoluGUID;
  SetLength(m_listDutyPlace,0);
  if not m_webDutyPlace.GetDutyPlaceByClient(trainJiaoluGUID,m_listDutyPlace,strError) then
  begin
    BoxErr(strError);
    Exit ;
  end;

  try
    for i := 0 to length(m_listDutyPlace) - 1 do
    begin
      tabItem := tabZFQD.Tabs.Add;
      tabItem.Caption := m_listDutyPlace[i].placeName;
    end;
    if tabZFQD.Tabs.Count > 0 then
      tabZFQD.TabIndex := 0;
  except  on e: exception do
    Box('��ȡ��վ��Ϣʧ��:' + e.Message);
  end;

end;


procedure TfrmNameBoardManage.InitPrepareTab(TrainmanJiaoluGUID: string);
var
  tabItem : TRzTabCollectionItem ;
begin
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := TAB_NAME_PREPARE;
end;

procedure TfrmNameBoardManage.InitPrepareTrainman(TrainmanJiaoluGUID : string);
var
  trainmanArray : TRsTrainmanArray;
  trainmanOrderView : TTrainmanOrderView;
  i : integer;
  blnSelected: boolean;
begin

  if m_bEditEnabled or mniDelPlate.Visible then
    tabtopBoard.PopupMenu := pMenu1
  else
    tabtopBoard.PopupMenu := nil;


    
  tabtopBoard.ClearView;
  tabtopBoard.SetLayoutType(ltVertical);
  m_RsLCNameBoardEx.Trainman.GetPrepare(m_strWorkShopGUID,TrainmanJiaoluGUID,trainmanArray);
  blnSelected := false;
  tabtopBoard.BeginUpdate;
  try
    for i := 0 to length(trainmanArray) - 1 do
    begin
      trainmanOrderView := TTrainmanOrderView.Create(nil);
      trainmanOrderView.TrainmanView.OnTrainmanBeforeDragOver := NotAllowTrainmanDrag;
      trainmanOrderView.TrainmanView.Trainman := trainmanArray[i];
      trainmanOrderView.TrainmanView.Images := PngImageCollection;
      trainmanOrderView.Index := i + 1;
      tabtopBoard.AddView(trainmanOrderView);

      if m_SelectUserInfo.strTrainmanGUID <> '' then
      begin
        if IsQueriedTrainman(trainmanArray[i]) then
        begin
          trainmanOrderView.Selected := true;
          if not blnSelected then
          begin
            tabtopBoard.VertScrollBar.Position := trainmanOrderView.top + trainmanOrderView.Height - tabtopBoard.Height;
            tabtopBoard.ReCanvas;
            blnSelected := true;
          end;
        end;
      end;
    end;

  finally
    tabtopBoard.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.InitTogetherJiaoluTab(TrainmanJiaoluGUID: string);
var
  togetherGroupArray : TRsTogetherTrainArray;
  togetherView : TTogetherTrainView;
  orderGroupInTrainView: TOrderGroupInTrainView;
  i, j : integer;
  tabItem : TRzTabCollectionItem;
  Condition: RNameBoardCondition;
  blnSelected: boolean;
  ErrInfo: string;
begin
  tabtopBoard.ClearView;
  tabZFQD.Tabs.Clear;
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := '���˽�·��Ա����';
  tabZFQD.TabIndex := 0;
  Exit;

  tabtopBoard.SetLayoutType(ltVertical);
  Condition.Init;
  Condition.strTrainmanJiaoluGUID := TrainmanJiaoluGUID;
  blnSelected := false;
  if not m_webNameBoard.GetTogetherGroup(TrainmanJiaoluGUID,togetherGroupArray,ErrInfo) then
  begin
    Box(ErrInfo);
    Exit;
  end;
  
  for i := 0 to length(togetherGroupArray) - 1 do
  begin
    togetherView := TTogetherTrainView.Create(nil);
    togetherView.TogetherTrain := togetherGroupArray[i];
    togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
    togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
    togetherView.Images := PngImageCollection;
    tabtopBoard.AddView(togetherView);

    begin
      for j := 0 to Length(togetherGroupArray[i].Groups) - 1 do
      begin
        if IsQueriedGroup(togetherGroupArray[i].Groups[j].Group) then
        begin
          if not blnSelected then
          begin
            tabtopBoard.VertScrollBar.Position := togetherView.top + togetherView.Height - tabtopBoard.Height;
            tabtopBoard.ReCanvas;
            blnSelected := true;
          end;
          orderGroupInTrainView := TOrderGroupInTrainView(togetherView.Childs[j]);
          orderGroupInTrainView.Selected := true;
        end;
      end;
    end;
  end;
end;

procedure TfrmNameBoardManage.InitTrainJiaolu;
var
  i,k : integer;
  node,SubNode : TTreeNode;
  trainjiaoluGUID : string;
  trainmanJiaoluArray : TRsTrainmanJiaoluArray;
  strError:string;
begin
  treeJiaolu.Items.Clear;

  if not m_webTrainJiaoLu.GetTrainJiaoluBySite(m_TrainJiaoluArray,strError) then
    BoxErr(strError);
  //����������·��ȡ������·�µ���Ա��·��Ϣ
  for i := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    m_strWorkShopGUID := m_TrainJiaoluArray[i].strWorkShopGUID;
    node := treeJiaolu.Items.AddChild(nil,'');
    node.Text := m_TrainJiaoluArray[i].strTrainJiaoluName;
    node.Data := Pointer(i);
    trainjiaoluGUID := m_TrainJiaoluArray[i].strTrainJiaoluGUID;
    try
      m_LCTrainmanJiaolu.GetTMJLByTrainJL(trainjiaoluGUID,trainmanJiaoluArray);
    except
      on E: Exception do
      begin
        BoxErr(E.Message);
      end;
    end;
    for k := 0 to Length(trainmanJiaoluArray) - 1 do
    begin
      //ȫ����Ա��·���������ȡ������
      SetLength(m_TrainmanJiaoluArray,length(m_TrainmanJiaoluArray)+ 1);
      m_TrainmanJiaoluArray[length(m_TrainmanJiaoluArray) -1] :=  trainmanJiaoluArray[k];
      SubNode := treeJiaolu.Items.AddChild(node,'');
      SubNode.Text := trainmanJiaoluArray[k].strTrainmanJiaoluName;
      SubNode.Data := Pointer(length(m_TrainmanJiaoluArray) - 1);
      if length(NameplateTrainmanJiaolu) > 1 then
      begin
        if (m_TrainmanJiaoluArray[length(m_TrainmanJiaoluArray) -1].strTrainmanJiaoluGUID = NameplateTrainmanJiaolu)
        and (treeJiaolu.Selected = nil) then
          treeJiaolu.Select(subNode);
      end;
    end;
    node.Expanded := true;
  end;
end;




procedure TfrmNameBoardManage.InitTXGroups(TrainmanJiaoluGUID: string);
var
  orderGroupArray : TRsOrderGroupArray;
  orderView : TOrderGroupView;
  i : integer;
  Groups: TRsGroupArray;
  Row0Col,Row1Col: integer;
begin
  tabtopBoard.PopupMenu := PopupMenuTX;

  tabtopBoard.ClearView;
//  tabtopBoard.SetLayoutType(ltVertical);
  tabtopBoard.VertScrollBar.Position := 0;

  
  tabtopBoard.SetLayoutType(ltGrid);



  tabtopBoard.BeginUpdate;
  try
    m_RsLCNameBoardEx.Group.GroupTX.Get(TrainmanJiaoluGUID,Groups);


    SetLength(orderGroupArray,Length(Groups));

    tabtopBoard.RowCount := 2;
    tabtopBoard.FixedCells[0,0] := '����1��';
    tabtopBoard.FixedCells[1,0] := '����2��';


    Row0Col := 0;
    Row1Col := 0;

    with TOrderGroupView.Create do
    begin
      tabtopBoard.RowHeight := Height;
      Free;
    end;

    
    for i := 0 to length(orderGroupArray) - 1 do
    begin


      orderView := TOrderGroupView.Create(nil);
      orderGroupArray[i].Group := Groups[i];
      orderGroupArray[i].nOrder := (i + 1);
      orderGroupArray[i].strTrainmanJiaoluGUID :=  TrainmanJiaoluGUID;
      orderView.OrderGroup := orderGroupArray[i];
      orderView.Images := PngImageCollection;


      if Groups[i].dtTXBeginTime > StartOfTheDay(Now)  then
      begin
        orderView.Row := 0;
        orderView.Col := Row0Col;
        Inc(Row0Col);
      end
      else
      begin
        orderView.Row := 1;
        orderView.Col := Row1Col;
        Inc(Row1Col);
      end;
      
      tabtopBoard.AddView(orderView);
    end;
  finally
    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;


procedure TfrmNameBoardManage.InitTXTab(TrainmanJiaoluGUID : string);
var
  tabItem : TRzTabCollectionItem ;
begin
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := TAB_NAME_TX;
end;

procedure TfrmNameBoardManage.InitOrderNullTab(TrainmanJiaoluGUID: string);
var
  tabItem : TRzTabCollectionItem ;
begin
  tabItem := tabZFQD.Tabs.Add;
  tabItem.Caption := TAB_NAME_NULL;
end;

procedure TfrmNameBoardManage.InitUnrunTrainman(TrainmanJiaoluGUID : string);
var
  trainmanArray : TRsTrainmanLeaveArray;
  trainmanView : TTrainmanView;
  strTempGUID : string;
  i,rowCount,colCount,tmpCount : integer;
  blnSelected: boolean;
begin
  tabtopBoard.PopupMenu := nil ;

  tabtopBoard.BeginUpdate;
  tabtopBoard.ClearView;
  tabtopBoard.RowCount := 0 ;
  tabtopBoard.ColCount := 0 ;

  tabtopBoard.SetLayoutType(ltGrid);
  tabtopBoard.GridLineColor := $003B312D; //���ñ�����뱳��ɫһ�������ر����

  try
    //��ȡ��ǰ��Ա��·����ķ���ת��Ա��Ϣ
    m_RsLCNameBoardEx.Trainman.GetUnRun(m_strWorkShopGUID,TrainmanJiaoluGUID,trainmanArray);
    if length(trainmanArray) = 0 then
      exit ;
    strTempGUID := '';
    rowCount := 0 ;
    colCount := 0 ;
    tmpCount := 0 ;
    blnSelected := false;
    for i := 0 to length(trainmanArray) - 1 do
    begin
      if i = 0 then
      begin
        strTempGUID := trainmanArray[i].strLeaveTypeGUID;
        rowCount := 1;
        tabtopBoard.RowCount := rowCount;
        tabtopBoard.ColCount := 1;
        tabtopBoard.FixedCells[rowCount-1,0] := trainmanArray[i].strLeaveTypeName;
        if trainmanArray[i].strLeaveTypeName = '' then
          tabtopBoard.FixedCells[rowCount-1,0] := '������';
      end;
      if strTempGUID <> trainmanArray[i].strLeaveTypeGUID then
      begin
        strTempGUID := trainmanArray[i].strLeaveTypeGUID;
        rowCount := rowCount + 1;
        tabtopBoard.RowCount := rowCount;
        tabtopBoard.FixedCells[rowCount-1,0] := trainmanArray[i].strLeaveTypeName;
        if trainmanArray[i].strLeaveTypeName = '' then
          tabtopBoard.FixedCells[rowCount-1,0] := '������';
        tmpCount := 0;
      end;

      tmpCount := tmpCount + 1;
      if tmpCount > colCount then
      begin
        colCount := tmpCount;
        tabtopBoard.ColCount := colCount; // + 1;
      end;
      trainmanView := TTrainmanView.Create(nil);
      trainmanView.OnTrainmanBeforeDragOver := NotAllowTrainmanDrag;
      trainmanView.Images := PngImageCollection;
      trainmanView.Trainman := trainmanArray[i].Trainman;
      trainmanView.Row := rowCount - 1;
      trainmanView.Col := tmpCount - 1;
      tabtopBoard.AddView(trainmanView);

      //ֱ�Ӱѹ������ƶ�������������Աλ�ã����Ҹ�����ǰ��VIEW
      if  m_SelectUserInfo.strTrainmanGUID <> '' then
      begin
        if IsQueriedTrainman(trainmanArray[i].Trainman) then
        begin
          trainmanView.Selected := true;
          if not blnSelected then
          begin
            tabtopBoard.VertScrollBar.Position := trainmanView.top + trainmanView.Height - tabtopBoard.Height;
            tabtopBoard.ReCanvas;
            blnSelected := true;
          end;
        end;
      end;
    end;
  finally
    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.ShowUnnormalOrderBoard(
  TrainmanJiaoluGUID: string);
var
  orderGroupArray : TRsOrderGroupArray;
  orderView : TOrderGroupView;
  i : integer;
  blnSelected: boolean;
begin
  if m_bEditEnabled then
    tabtopBoard.PopupMenu := pmenuUnnormalOrderPopup
  else
    tabtopBoard.PopupMenu := nil;


    
  tabtopBoard.ClearView;
  tabtopBoard.SetLayoutType(ltVertical);
  tabtopBoard.VertScrollBar.Position := 0;
  tabtopBoard.BeginUpdate;
  blnSelected := false;
  try
    begin
      m_RsLCNameBoardEx.Order.Group.GetNullStationGrps(
        TrainmanJiaoluGUID,orderGroupArray);
      for i := 0 to length(orderGroupArray) - 1 do
      begin
        orderView := TOrderGroupView.Create(nil);
        orderView.OnTrainmanDragOver := OrderTrainmanDragDrop;
        orderView.OnOrderGroupDragOver := OrderGroupDragDrop;
        orderGroupArray[i].nOrder := (i + 1);
        orderView.OrderGroup := orderGroupArray[i];
        orderView.Images := PngImageCollection;
        tabtopBoard.AddView(orderView);

        if m_SelectUserInfo.strTrainmanGUID <> '' then
        begin
          if IsQueriedGroup(orderGroupArray[i].Group) then
          begin    
            orderView.Selected := true;
            if not blnSelected then
            begin
              tabtopBoard.VertScrollBar.Position := orderView.top + orderView.Height - tabtopBoard.Height;
              tabtopBoard.ReCanvas;
              blnSelected := true;
            end;
          end;
        end;
      end;
    end;
  finally

    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;



function TfrmNameBoardManage.IsGroupBusy(GroupGUID: string): boolean;
var
  trainmanPlan : RRsTrainmanPlan;
begin
  result := false;

  if m_RsLCNameBoardEx.Group.GetPlan(GroupGUID,trainmanPlan) then
  begin
    result := true;
    Box(Format('����Ա���ڵĻ�������ֵ�˼ƻ�:%s[%s],���ܲ���',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',trainmanPlan.TrainPlan.dtStartTime),trainmanPlan.TrainPlan.strTrainNo]));
    exit;
  end;

end;

function TfrmNameBoardManage.IsQueriedGroup(Group : RRsGroup): boolean;
begin
  result := True;
  if m_SelectUserInfo.strTrainmanGUID = Group.Trainman1.strTrainmanGUID then
    Exit;
  if m_SelectUserInfo.strTrainmanGUID = Group.Trainman2.strTrainmanGUID then
    Exit;
  if m_SelectUserInfo.strTrainmanGUID = Group.Trainman3.strTrainmanGUID then
    Exit;
  if m_SelectUserInfo.strTrainmanGUID = Group.Trainman4.strTrainmanGUID then
    Exit;
  result := False;
end;

function TfrmNameBoardManage.IsQueriedTrainman(Trainman: RRsTrainman): boolean;
begin
  result := false;
  if m_SelectUserInfo.strTrainmanGUID = Trainman.strTrainmanGUID then
    result := true;
end;

function TfrmNameBoardManage.IsTrainBusy(TrainGUID: string): boolean;
var
  trainmanPlan : RRsTrainmanPlan;
begin
  result := false;
  if m_RsLCNameBoardEx.Together.GetTrainPlan(TrainGUID,trainmanPlan) then
  begin
    result := true;
    Box(Format('�û����л�������ֵ�˼ƻ�:%s[%s],���ܲ���',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',trainmanPlan.TrainPlan.dtStartTime),trainmanPlan.TrainPlan.strTrainNo]));
    exit;
  end;
end;

function TfrmNameBoardManage.IsTrainmanBusy(TrainmanGUID: string): boolean;
var
  trainmanPlan : RRsTrainmanPlan;
begin
  result := false;

  if m_RsLCNameBoardEx.Trainman.GetPlan(TrainmanGUID,trainmanPlan) then
  begin
    result := true;
    Box(Format('����Ա���ڵĻ�������ֵ�˼ƻ�:%s[%s],���ܲ���',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',trainmanPlan.TrainPlan.dtStartTime),trainmanPlan.TrainPlan.strTrainNo]));
    exit;
  end;

end;

procedure TfrmNameBoardManage.miAddNamedGroupClick(Sender: TObject);
var
  strCheci1,strCheci2 : string;
  bIsRest : boolean;
  namedGroup : RRsNamedGroup;
  trainmanJiaolu : RRsTrainmanJiaolu;
  strGroupGUID: string;
  namedView: TNamedGroupView;
  AddParam: TRsLCNamedGrpInputParam;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  bIsRest := false;
  if not TFrmAddCheCi.GetCheCiInfo(strCheci1,strCheci2,bIsRest) then exit;


  if not TFrmAddGroup.InputGroup('',
    namedGroup.Group.Trainman1,
    namedGroup.Group.Trainman2,namedGroup.Group.Trainman3,namedGroup.Group.Trainman4) then exit;
  try

    //����������Ա�Ƿ��ܱ����
    if not CheckAddGroup(namedGroup.Group) then exit;
    //���������Ա�Ƿ��Ѿ�������������
    if not CheckGroupIsOwner(namedGroup.Group,jltNamed) then Exit ;

    namedGroup.strCheciGUID := NewGUID;
    namedGroup.nCheciOrder := 0;
    namedGroup.strCheci1 := strCheci1;
    namedGroup.strCheci2 := strCheci2;
    namedGroup.nCheciType :=  cctCheci;
    if bIsRest then
      namedGroup.nCheciType := cctRest;
    namedGroup.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;

    namedGroup.Group.strGroupGUID := NewGUID;

    AddParam := TRsLCNamedGrpInputParam.Create;
    try
      AddParam.TrainmanJiaolu.SetTrainmanJL(trainmanJiaolu);
      AddParam.DutyUser.strDutyNumber := m_DutyUser.strDutyNumber;
      AddParam.DutyUser.strDutyName := m_DutyUser.strDutyName;
      AddParam.DutyUser.strDutyGUID := m_DutyUser.strDutyGUID;

      AddParam.CheciGUID := namedGroup.strCheciGUID;
      AddParam.CheciOrder := namedGroup.nCheciOrder;
      AddParam.CheciType := Ord(namedGroup.nCheciType);
      AddParam.Checi1 := namedGroup.strCheci1;
      AddParam.Checi2 := namedGroup.strCheci2;
      AddParam.TrainmanNumber1 := namedGroup.Group.Trainman1.strTrainmanNumber;
      AddParam.TrainmanNumber2 := namedGroup.Group.Trainman2.strTrainmanNumber;
      AddParam.TrainmanNumber3 := namedGroup.Group.Trainman3.strTrainmanNumber;
      AddParam.TrainmanNumber4 := namedGroup.Group.Trainman4.strTrainmanNumber;


      m_RsLCNameBoardEx.Named.Group.Add(AddParam);
    finally
      AddParam.Free;
    end;

    strGroupGUID := namedGroup.Group.strGroupGUID;


    m_RsLCNameBoardEx.Named.Group.GetNamedGroup(strGroupGUID, namedGroup);

    namedView := TNamedGroupView.Create(nil);
    namedView.OnTrainmanDragOver := NamedTrainmanDragDrop;
    namedView.OnNamedGroupDragOver := NamedGroupDragDrop;
    namedView.NamedGroup := namedGroup;
    namedView.Images := PngImageCollection;
    tabtopBoard.AddView(namedView);
    ReorderNamedViews;
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miAddNamedTrainmanClick(Sender: TObject);
var
  view : TView;
  trainman : RRsTrainman;
  group : RRsNamedGroup;
  nTrainmanIndex : integer;
  AddInput: TRsLCTrainmanAddInput;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then
  begin
    Box('����ָ��Ҫ���õĳ���Աλ��');
    exit;
  end;

  if TTrainmanView(View).Trainman.strTrainmanGUID <> '' then
  begin
    Box('����ɾ������Ա');
    Exit;
  end;

  group := TNamedGroupView(view.Parent).NamedGroup;
  if IsGroupBusy(group.Group.strGroupGUID) then
  begin
    exit;
  end;
  GetSelectedTrainmaJiaolu(TrainmanJiaolu);
  nTrainmanIndex := TNamedGroupView(view.Parent).Childs.IndexOf(view) + 1;
  if not TFrmAddUser.InputTrainman('',Trainman) then exit;
  try
    //������Ա�Ƿ�������
    if not CheckAddTrainman(group.Group,trainman) then exit;

    AddInput := TRsLCTrainmanAddInput.Create;
    try

      AddInput.TrainmanJiaolu.SetTrainmanJL(TrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := Trainman.strTrainmanNumber;
      AddInput.TrainmanIndex := nTrainmanIndex;
      AddInput.GroupGUID := group.Group.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

    finally
      AddInput.Free;
    end;
    //ˢ������
    InitNamedBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);

  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miAddOrderGroupClick(Sender: TObject);
var
  orderGroup : RRsOrderGroup;
  trainmanJiaolu : RRsTrainmanJiaolu;
  station : RRsStation;
  orderView : TOrderGroupView;
  dutyPlace:RRsDutyPlace;
  AddParam: TRsLCOrderGrpInputParam;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;

  if not GetSelectedDutyPlace(dutyPlace) then
  begin
    BoxErr('��ѡ����ڵ�!');
    Exit;
  end;
  orderGroup.Group.place := dutyPlace ;


  if not TFrmAddGroup.InputGroup('',orderGroup.Group.Trainman1,orderGroup.Group.Trainman2,
    orderGroup.Group.Trainman3,orderGroup.Group.Trainman4) then exit;
  try
    //����������Ա�Ƿ��ܱ����
    if not CheckAddGroup(orderGroup.Group) then exit;
    //���������Ա�Ƿ��Ѿ�������������
    if not CheckGroupIsOwner(orderGroup.Group,jltOrder) then Exit ;


    orderGroup.strOrderGUID := NewGUID;
    orderGroup.nOrder := 0;
    orderGroup.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;

    orderGroup.Group.strGroupGUID := NewGUID;
    orderGroup.Group.Station.strStationGUID := station.strStationGUID;

    AddParam := TRsLCOrderGrpInputParam.Create;
    try
      AddParam.TrainmanJiaolu.SetTrainmanJL(trainmanJiaolu);
      AddParam.DutyUser.Assign(m_DutyUser);
      AddParam.OrderGUID := orderGroup.strOrderGUID;
      AddParam.LastArriveTime := 0;
      AddParam.PlaceID := orderGroup.Group.place.placeID;
      AddParam.TrainmanNumber1 := orderGroup.Group.Trainman1.strTrainmanNumber;
      AddParam.TrainmanNumber2 := orderGroup.Group.Trainman2.strTrainmanNumber;
      AddParam.TrainmanNumber3 := orderGroup.Group.Trainman3.strTrainmanNumber;
      AddParam.TrainmanNumber4 := orderGroup.Group.Trainman4.strTrainmanNumber;

      m_RsLCNameBoardEx.Order.Group.Add(AddParam);

    finally
      AddParam.Free;
    end;


    orderView := TOrderGroupView.Create(nil);
    orderView.OnTrainmanDragOver := OrderTrainmanDragDrop;
    orderView.OnOrderGroupDragOver := OrderGroupDragDrop;
    orderGroup.nOrder := tabtopBoard.GetViewCount+1;
    orderView.OrderGroup := orderGroup;
    orderView.Images := PngImageCollection;
    tabtopBoard.AddView(orderView);
    ReorderOrderViews;
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miAddOrderTrainmanClick(Sender: TObject);
var
  view : TView;
  trainman : RRsTrainman;
  orderGroup : RRsOrderGroup;
  nTrainmanIndex : integer;     
  AddInput: TRsLCTrainmanAddInput;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then
  begin
    Box('����ָ��Ҫ���õĳ���Աλ��');
    exit;
  end;
  orderGroup := TOrderGroupView(view.Parent).OrderGroup;
  if IsGroupBusy(orderGroup.Group.strGroupGUID) then
  begin
    exit;
  end;
  GetSelectedTrainmaJiaolu(TrainmanJiaolu);
  nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;
  if not TFrmAddUser.InputTrainman('',Trainman) then exit;
  try
    //������Ա�Ƿ�������
    if not CheckAddTrainman(TOrderGroupView(view.Parent).OrderGroup.Group,trainman) then exit;
    AddInput := TRsLCTrainmanAddInput.Create;
    try

      AddInput.TrainmanJiaolu.SetTrainmanJL(TrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := Trainman.strTrainmanNumber;
      AddInput.TrainmanIndex := nTrainmanIndex;
      AddInput.GroupGUID := orderGroup.Group.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

    finally
      AddInput.Free;
    end;


    InitOrderBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miAddPrepareTrainmanClick(Sender: TObject);
var
  trainman,tm2 : RRsTrainman;
begin
  if not TFrmAddUser.InputTrainman('',trainman) then exit;
  try
    m_RsLCTrainmanMgr.GetTrainman(trainman.strTrainmanGUID,tm2);
    m_RsLCTrainmanMgr.SetTrainmanState(tm2.strTrainmanGUID,Ord(tsReady));
    InitUnrunTab(tm2.strWorkShopGUID);
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miAddTogetherGroupClick(Sender: TObject);
var
  orderGroupInTrain : RRsOrderGroupInTrain;
  trainmanJiaolu : RRsTrainmanJiaolu;
  view : TView;
  strTrainGUID: string;
  togetherView : TTogetherTrainView;
  TogetherTrain: RRsTogetherTrain;
  AddParam: TRsLCTogetherGrpInputParam;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTogetherTrainView.ClassName) then
  begin
    Box('����ָ��Ҫ��ӵĻ������ڵİ��˻�����Ϣ');
    exit;
  end;

  if not TFrmAddGroup.InputGroup('',
    orderGroupInTrain.Group.Trainman1,
    orderGroupInTrain.Group.Trainman2,orderGroupInTrain.Group.Trainman3,
    orderGroupInTrain.Group.Trainman4) then exit;

  try
    if not CheckAddGroup(orderGroupInTrain.Group) then exit;

    //���������Ա�Ƿ��Ѿ�������������
    if not CheckGroupIsOwner(orderGroupInTrain.Group,jltTogether) then Exit ;

    orderGroupInTrain.strOrderGUID := NewGUID;
    orderGroupInTrain.strTrainGUID := TTogetherTrainView(view).TogetherTrain.strTrainGUID;
    orderGroupInTrain.nOrder := 0;

    orderGroupInTrain.Group.strGroupGUID := NewGUID;

    AddParam := TRsLCTogetherGrpInputParam.Create;
    try
      AddParam.TrainmanJiaolu.SetTrainmanJL(trainmanJiaolu);
      AddParam.DutyUser.Assign(m_DutyUser);
      AddParam.OrderGUID := orderGroupInTrain.strOrderGUID;
      AddParam.Order := orderGroupInTrain.nOrder;
      AddParam.TrainGUID := orderGroupInTrain.strTrainGUID;
      AddParam.TrainmanNumber1 := orderGroupInTrain.Group.Trainman1.strTrainmanNumber;
      AddParam.TrainmanNumber2 := orderGroupInTrain.Group.Trainman2.strTrainmanNumber;
      AddParam.TrainmanNumber3 := orderGroupInTrain.Group.Trainman3.strTrainmanNumber;
      AddParam.TrainmanNumber4 := orderGroupInTrain.Group.Trainman4.strTrainmanNumber;


      m_RsLCNameBoardEx.Together.Group.Add(AddParam);

    finally
      AddParam.Free;
    end;

    tabtopBoard.BeginUpdate;
    try
      togetherView := TTogetherTrainView(view);
      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
      togetherView.TogetherTrain := TogetherTrain;
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.ReComposition;
    finally 
      tabtopBoard.EndUpdate;
    end;
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miAddTogetherTrainClick(Sender: TObject);
var
  togetherTrain : RRsTogetherTrain;
  trainmanJiaolu : RRsTrainmanJiaolu;
  togetherView: TTogetherTrainView;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  if not TFrmAddJiChe.InputTrainInfo(togetherTrain.strTrainTypeName,togetherTrain.strTrainNumber) then exit;

  //���ܴ�����ͬ����
  if m_RsLCNameBoardEx.Together.ExistTrain(togetherTrain.strTrainTypeName,togetherTrain.strTrainNumber) then
  begin
    BoxErr('���ܴ�����ͬ�İ��˻���');
    Exit ;
  end;

  try
    togetherTrain.strTrainGUID := NewGUID;
    togetherTrain.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;

    m_RsLCNameBoardEx.Together.AddTrain(trainmanJiaolu.strTrainmanJiaoluGUID,
    togetherTrain.strTrainGUID,
    togetherTrain.strTrainTypeName,
    togetherTrain.strTrainNumber);


    tabtopBoard.BeginUpdate;
    try
      togetherView := TTogetherTrainView.Create(nil);
      togetherView.TogetherTrain := togetherTrain;
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.AddView(togetherView);
      tabtopBoard.ReComposition;
    finally 
      tabtopBoard.EndUpdate;
    end;
  except on  e : exception do
    begin
      Box('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miAddTogetherTrainmanClick(Sender: TObject);
var
  view : TView;
  trainman : RRsTrainman;
  orderGroupInTrain : RRsOrderGroupInTrain;
  nTrainmanIndex : integer;
  AddInput: TRsLCTrainmanAddInput;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then
  begin
    Box('����ָ��Ҫ���õĳ���Աλ��');
    exit;
  end;



  if TTrainmanView(View).Trainman.strTrainmanGUID <> '' then
  begin
    Box('����ɾ������Ա');
    Exit;
  end;


  orderGroupInTrain := TOrderGroupInTrainView(view.Parent).OrderGroupInTrain;
  if IsGroupBusy(orderGroupInTrain.Group.strGroupGUID) then
  begin
    exit;
  end;
  nTrainmanIndex := TOrderGroupInTrainView(view.Parent).Childs.IndexOf(view) + 1;
  if not TFrmAddUser.InputTrainman('',Trainman) then exit;

  try
    //������Ա�Ƿ�������
    if not CheckAddTrainman(orderGroupInTrain.Group,trainman) then exit;

    AddInput := TRsLCTrainmanAddInput.Create;
    try

      AddInput.TrainmanJiaolu.SetTrainmanJL(TrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := Trainman.strTrainmanNumber;
      AddInput.TrainmanIndex := nTrainmanIndex;
      AddInput.GroupGUID := orderGroupInTrain.Group.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

    finally
      AddInput.Free;
    end;

    InitTogetherJiaoluTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);

    InitTogetherJiaoluTab(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
  except on  e : exception do
    begin
      BoxErr('���ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miDeleteNamedGroupClick(Sender: TObject);
var
  view : TView;
  namedGroupView : TNamedGroupView;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view := m_SelectView;
  namedGroupView := TNamedGroupView(m_SelectView);
  if (view = nil) or (view.ClassName <> TNamedGroupView.ClassName) then
  begin
    Box('����ָ��Ҫɾ���Ļ�����Ϣ');
    exit;
  end;
  if IsGroupBusy(namedGroupView.NamedGroup.Group.strGroupGUID) then exit;
  if not TBox('��ȷ��Ҫɾ���˻�����') then exit;
  namedGroupView := TNamedGroupView(view);
  try
    if IsGroupBusy(namedGroupView.NamedGroup.Group.strGroupGUID) then exit;

    GetSelectedTrainmaJiaolu(TrainmanJiaolu);
    m_InputJL.SetTrainmanJL(TrainmanJiaolu);
    m_RsLCNameBoardEx.Named.Group.Delete(m_InputJL,namedGroupView.NamedGroup.Group.strGroupGUID,m_DutyUser);

    tabtopBoard.DeleteView(namedGroupView);
    ReorderNamedViews;
  except on e : exception do
    begin
      Box('ɾ������ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miDeleteNamedTrainmanClick(Sender: TObject);
var
  view : TView;
  trainmanView : TTrainmanView;        
  group : RRsNamedGroup;
  strGroupGUID: string;
  nTrainmanIndex : integer;
  Input: TRsLCTrainmanAddInput;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then  
  begin
    Box('����ָ��Ҫɾ���ĳ���Ա��Ϣ');
    exit;
  end;

  trainmanView := TTrainmanView(view);
  try
    if IsTrainmanBusy(trainmanVIew.Trainman.strTrainmanGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˳���Ա��') then exit;
    //�ӻ�����ɾ����Ա
    nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);

      Input.DutyUser.Assign(m_DutyUser);
      Input.TrainmanNumber := trainmanView.Trainman.strTrainmanNumber;
      Input.GroupGUID := TNamedGroupView(trainmanView.Parent).NamedGroup.Group.strGroupGUID;
      Input.TrainmanIndex := nTrainmanIndex;
      m_RsLCNameBoardEx.Group.DeleteTrainman(Input);
    finally
      Input.Free;
    end;
    
    //ˢ�»���������ʾ
    group := TNamedGroupView(view.Parent).NamedGroup;
    strGroupGUID := group.Group.strGroupGUID;
    m_RsLCNameBoardEx.Named.Group.GetNamedGroup(strGroupGUID, group);

    group.nCheciOrder := TNamedGroupView(view.Parent).NamedGroup.nCheciOrder;
    TNamedGroupView(view.Parent).NamedGroup := group;
    tabtopBoard.ReComposition;

  except on e : exception do
    begin
      BoxErr('ɾ������Աʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miDeleteOrderGroupClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
  begin
    Box('����ָ��Ҫɾ���Ļ�����Ϣ');
    exit;
  end;

  orderGroupView := TOrderGroupView(view);
  try
    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˻�����') then exit;
    m_InputJL.SetTrainmanJL(m_SelectedTrainmanJiaolu);
    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupView.OrderGroup.Group.strGroupGUID,m_DutyUser);
    tabtopBoard.DeleteView(orderGroupView);
    ReorderOrderViews;
  except on e : exception do
    begin
      Box('ɾ������ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miDeleteOrderTrainmanClick(Sender: TObject);
var
  view : TView;
  trainmanView : TTrainmanView; 
  orderGroup : RRsOrderGroup;
  strGroupGUID: string;
  nTrainmanIndex : integer;
  Input: TRsLCTrainmanAddInput;
begin

  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then
  begin
    Box('����ָ��Ҫɾ���ĳ���Ա��Ϣ');
    exit;
  end;

  trainmanView := TTrainmanView(view);
  try
    if IsTrainmanBusy(trainmanVIew.Trainman.strTrainmanGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˳���Ա��') then exit;
     //�ӻ�����ɾ����Ա
    nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);
      Input.DutyUser.Assign(m_DutyUser);
      input.TrainmanNumber := trainmanView.Trainman.strTrainmanNumber;
      Input.TrainmanIndex := nTrainmanIndex;
      Input.GroupGUID :=TOrderGroupView(trainmanView.Parent).OrderGroup.Group.strGroupGUID;
      m_RsLCNameBoardEx.Group.DeleteTrainman(Input);
    finally
      Input.Free;
    end;


    //ˢ����ʾ������Ϣ
    orderGroup := TOrderGroupView(view.Parent).OrderGroup;
    strGroupGUID := orderGroup.Group.strGroupGUID;
    m_RsLCNameBoardEx.Order.Group.GetOrderGroup(strGroupGUID, OrderGroup);

    orderGroup.nOrder := TOrderGroupView(view.Parent).OrderGroup.nOrder;
    TOrderGroupView(view.Parent).OrderGroup := orderGroup;
    tabtopBoard.ReComposition;

  except on e : exception do
    begin
      BoxErr('ɾ������Աʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miDeletePrepareTrainmanClick(Sender: TObject);
var
  view : TView;
  trainmanView : TTrainmanView;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then  
  begin
    Box('����ָ��Ҫɾ���ĳ���Ա��Ϣ');
    exit;
  end;
  trainmanView := TTrainmanView(view);
  try
    m_RsLCTrainmanMgr.SetTrainmanState(trainmanView.Trainman.strTrainmanGUID,Ord(tsNil));
    InitUnrunTab(trainmanView.Trainman.strWorkShopGUID);
  except on e : exception do
    begin
      BoxErr('ɾ������Աʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miDeleteTogetherGroupClick(Sender: TObject);
var
  view : TView;
  orderGroupInTrainView : TOrderGroupInTrainView;
  strTrainGUID: string;  
  TogetherTrain: RRsTogetherTrain;
  togetherView: TTogetherTrainView;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TOrderGroupInTrainView.ClassName) then  
  begin
    Box('����ָ��Ҫɾ���İ��˻�����Ϣ');
    exit;
  end;

  orderGroupInTrainView := TOrderGroupInTrainView(view);
  try
    if IsGroupBusy(orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˻�����') then exit;


    m_InputJL.SetTrainmanJL(m_SelectedTrainmanJiaolu);
    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID,m_DutyUser);


    tabtopBoard.BeginUpdate;
    try
      togetherView := TTogetherTrainView(view.Parent);
      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
      togetherView.TogetherTrain := TogetherTrain;
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.ReComposition;



    finally
      tabtopBoard.EndUpdate;
    end;
  except on e : exception do
    begin
      BoxErr('ɾ�����˻���ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miDeleteTogetherTrainClick(Sender: TObject);
var
  view : TView;
  togetherTrainView : TTogetherTrainView;
  togetherTrain:RRsTogetherTrain;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTogetherTrainView.ClassName) then
  begin
    Box('����ָ��Ҫɾ���İ��˻�����Ϣ');
    exit;
  end;
  togetherTrainView := TTogetherTrainView(view);


  m_RsLCNameBoardEx.Together.GetTrain(togetherTrainView.TogetherTrain.strTrainGUID,togetherTrain);

  if Length(togetherTrain.Groups) <> 0 then
    Exit ;


  if IsTrainBusy(togetherTrainView.TogetherTrain.strTrainGUID) then exit;
  if not TBox('��ȷ��Ҫɾ���˰��˻�����') then exit;

  try
    m_RsLCNameBoardEx.Together.DeleteTrain(togetherTrainView.TogetherTrain.strTrainGUID);
    tabtopBoard.DeleteView(togetherTrainView);
  except on e : exception do
    begin
      BoxErr('ɾ�����˻���ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miDeleteTogetherTrainmanClick(Sender: TObject);
var
  view : TView;
  trainmanView : TTrainmanView;  
  strTrainGUID: string;
  togetherView: TTogetherTrainView;
  TogetherTrain: RRsTogetherTrain;
  orderGroupInTrain : RRsOrderGroupInTrain;
  nTrainmanIndex : integer;
  Input: TRsLCTrainmanAddInput;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TTrainmanView.ClassName) then  
  begin
    Box('����ָ��Ҫɾ���ĳ���Ա��Ϣ');
    exit;
  end;

  trainmanView := TTrainmanView(view);

    if IsTrainmanBusy(trainmanVIew.Trainman.strTrainmanGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˳���Ա��') then exit;
     //�ӻ�����ɾ����Ա
    nTrainmanIndex := TOrderGroupInTrainView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);
      Input.DutyUser.Assign(m_DutyUser);
      Input.TrainmanNumber := trainmanView.Trainman.strTrainmanNumber;
      Input.GroupGUID := TOrderGroupInTrainView(trainmanView.Parent).OrderGroupInTrain.Group.strGroupGUID;
      Input.TrainmanIndex := nTrainmanIndex;
      m_RsLCNameBoardEx.Group.DeleteTrainman(Input);
    finally
      Input.Free;
    end;


    //ˢ�°��˻�����ʾ
    orderGroupInTrain := TOrderGroupInTrainView(view.Parent).OrderGroupInTrain;
    tabtopBoard.BeginUpdate;
    try
      togetherView := TTogetherTrainView(view.Parent.Parent);
      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;

      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
      togetherView.TogetherTrain := TogetherTrain;
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.ReComposition;
    finally
      tabtopBoard.EndUpdate;
    end;


end;

procedure TfrmNameBoardManage.miEditCheciClick(Sender: TObject);
var
  namedView : TNamedGroupView;
  namedGroup : RRsNamedGroup;
  bIsRest : boolean;
  checi1,checi2 : string;
begin
  namedView := TNamedGroupView(m_SelectView);
  if namedView = nil then exit;
  namedGroup := namedView.NamedGroup;
  bIsRest := namedGroup.nCheciType = cctRest;
  checi1 := namedGroup.strCheci1;
  checi2 := namedGroup.strCheci2;
  if not TFrmAddCheCi.GetCheCiInfo(checi1,checi2,bIsRest) then exit;
  namedGroup.nCheciType := cctCheci;
  if bIsRest then
  begin
    namedGroup.nCheciType := cctRest;
  end;
  namedGroup.strCheci1 := checi1;
  namedGroup.strCheci2 := checi2;

  m_RsLCNameBoardEx.Named.Group.UpdateCC(checi1,checi2,namedGroup.strCheciGUID,Ord(namedGroup.nCheciType));

  namedVIEW.NamedGroup := namedGroup;
  tabtopBoard.Repaint;
end;

procedure TfrmNameBoardManage.miEditOrderClick(Sender: TObject);
var
  view : TView;
  namedGroupView : TNamedGroupView;
  namedGroup : RRsNamedGroup;
  nOrder : Integer ;
  strOrder:string ;
begin
  view := m_SelectView;
  namedGroupView := TNamedGroupView(m_SelectView);
  if (view = nil) or (view.ClassName <> TNamedGroupView.ClassName) then
  begin
    Box('����ָ��������Ϣ');
    exit;
  end;


  namedGroup := namedGroupView.NamedGroup ;
  strOrder := InputBox('�޸����','���������',inttostr(namedGroup.nOrgCheciOrder));
  if strOrder = inttostr(namedGroup.nOrgCheciOrder)  then
    Exit;

  try
    if not TBox('ȷ���޸������?') then
      Exit ;
    nOrder := StrToInt(strOrder) ;
    m_RsLCNameBoardEx.Named.Group.UpdateIndex(namedGroup.strCheciGUID,nOrder);
  except
    BoxErr('ת����Ŵ���');
    Exit;
  end;

  InitNamedBoard(namedGroup.strTrainmanJiaoluGUID);

end;

procedure TfrmNameBoardManage.miOrderCutClick(Sender: TObject);
begin
  m_CutView := m_SelectView;
end;

procedure TfrmNameBoardManage.miOrderPasteAfterClick(Sender: TObject);
var
  dtArriveTime : TDateTime;
  sourceVIEW,destOrderView,nextOrderView : TOrderGroupView;
  orderGroup : RRsOrderGroup;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  destOrderView := TOrderGroupView(m_SelectView);
  sourceView := TOrderGroupView(m_CutView);
  nextOrderView := TOrderGroupView(GetNextView(destOrderView));
  //û��ǰһ��������ȡĿ�����ĵ���ʱ���ǰ10����
  dtArriveTime :=  IncMinute(destOrderView.OrderGroup.dtLastArriveTime,10);
  //��ǰһ��������ȥ����������м��¼�
  if nextOrderView <> nil then
  begin
    dtArriveTime := destOrderView.OrderGroup.dtLastArriveTime +
      (nextOrderView.OrderGroup.dtLastArriveTime - destOrderView.OrderGroup.dtLastArriveTime) /2;
  end;


  if not GetSelectedTrainmaJiaolu(TrainmanJiaolu) then Exit;
  m_InputJL.SetTrainmanJL(TrainmanJiaolu);
  m_RsLCNameBoardEx.Group.UpdateArriveTime(
    TOrderGroupView(m_CutView).OrderGroup.Group.strGroupGUID,
    TOrderGroupView(m_CutView).OrderGroup.dtLastArriveTime,
    dtArriveTime,
    m_DutyUser,m_InputJL);

  orderGroup := sourceVIEW.OrderGroup;
  orderGroup.dtLastArriveTime := dtArriveTime;
  sourceVIEW.OrderGroup := orderGroup;
  tabtopBoard.BeginUpdate;
  try
    tabtopBoard.InsertExistViewAfter(destOrderView, sourceView);
    ReorderOrderViews;
  finally
    tabtopBoard.EndUpdate;
    tabtopBoard.Repaint;
  end;
  m_CutView := nil;   
end;

procedure TfrmNameBoardManage.miOrderPasteBeforeClick(Sender: TObject);
var
  dtArriveTime : TDateTime;
  sourceVIEW,destOrderView,preOrderView : TOrderGroupView;
  orderGroup : RRsOrderGroup;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  destOrderView := TOrderGroupView(m_SelectView);
  sourceView := TOrderGroupView(m_CutView);
  preOrderView := TOrderGroupView(GetPrevView(destOrderView));
  //û��ǰһ��������ȡĿ�����ĵ���ʱ���ǰ10����
  dtArriveTime :=  DateUtils.IncMinute(destOrderView.OrderGroup.dtLastArriveTime,-10);
  //��ǰһ��������ȥ����������м��¼�
  if preOrderView <> nil then
  begin
    dtArriveTime := preOrderView.OrderGroup.dtLastArriveTime +
      (destOrderView.OrderGroup.dtLastArriveTime - preOrderView.OrderGroup.dtLastArriveTime) /2;
  end;
  if not GetSelectedTrainmaJiaolu(TrainmanJiaolu) then Exit;
  m_InputJL.SetTrainmanJL(TrainmanJiaolu);

  m_RsLCNameBoardEx.Group.UpdateArriveTime(
    TOrderGroupView(m_CutView).OrderGroup.Group.strGroupGUID,
    TOrderGroupView(m_CutView).OrderGroup.dtLastArriveTime,
     dtArriveTime,
     m_DutyUser,m_InputJL);


  orderGroup := sourceVIEW.OrderGroup;
  orderGroup.dtLastArriveTime := dtArriveTime;
  sourceVIEW.OrderGroup := orderGroup;
  tabtopBoard.BeginUpdate;
  try
    tabtopBoard.InsertExistViewBefore(destOrderView, sourceView);
    ReorderOrderViews;
  finally
    tabtopBoard.EndUpdate;
  end;
  m_CutView := nil;
end;

procedure TfrmNameBoardManage.miOrderPasteCoverClick(Sender: TObject);
var
  sourceView : TOrderGroupView;
  destOrderView : TOrderGroupView;
begin
  destOrderView := TOrderGroupView(m_SelectView);
  sourceView := TOrderGroupView(m_CutView);
  ExchangeOrderGroup(sourceView,destOrderView);
  m_CutView := nil;
end;

procedure TfrmNameBoardManage.miTX_NamedClick(Sender: TObject);
var
  view : TView;
  namedGroupView : TNamedGroupView;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view := m_SelectView;
  namedGroupView := TNamedGroupView(m_SelectView);
  
  if IsGroupBusy(namedGroupView.NamedGroup.Group.strGroupGUID) then exit;
  
  if not TBox('ȷ��ҪΪ�û��������') then exit;
  namedGroupView := TNamedGroupView(view);
  try
    GetSelectedTrainmaJiaolu(TrainmanJiaolu);
    m_InputJL.SetTrainmanJL(TrainmanJiaolu);

    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,namedGroupView.NamedGroup.Group.strGroupGUID);

    tabtopBoard.DeleteView(namedGroupView);
    ReorderNamedViews;
  except on e : exception do
    begin
      Box('�������ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miTX_OrderClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;
begin
  view := m_SelectView;
  orderGroupView := TOrderGroupView(view);
  try
    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
    if not TBox('ȷ��ҪΪ�û��������') then exit;
    m_InputJL.SetTrainmanJL(m_SelectedTrainmanJiaolu);
    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,orderGroupView.OrderGroup.Group.strGroupGUID);
    tabtopBoard.DeleteView(orderGroupView);
    ReorderOrderViews;
  except on e : exception do
    begin
      Box('�������ʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.miTX_TogetherClick(Sender: TObject);
var
  view : TView;
  orderGroupInTrainView : TOrderGroupInTrainView;
  strTrainGUID: string;  
  TogetherTrain: RRsTogetherTrain;
  togetherView: TTogetherTrainView;
begin
  view := m_SelectView;

  orderGroupInTrainView := TOrderGroupInTrainView(view);
  try
    if IsGroupBusy(orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID) then exit;
    if not TBox('ȷ��ҪΪ�û��������') then exit;


    m_InputJL.SetTrainmanJL(m_SelectedTrainmanJiaolu);
    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID);

    tabtopBoard.BeginUpdate;
    try
      togetherView := TTogetherTrainView(view.Parent);
      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
      togetherView.TogetherTrain := TogetherTrain;
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.ReComposition;
    finally
      tabtopBoard.EndUpdate;
    end;
  except on e : exception do
    begin
      BoxErr('�������ʧ�ܣ�' + e.Message);
    end;
  end;

end;
procedure TfrmNameBoardManage.miUpdateTrainClick(Sender: TObject);
var
  togetherTrain : TTogetherTrainView;
  togetherGroup : RRsTogetherTrain;
  strTrainTypeName,strTrainNumber : string;
begin
  if m_SelectView.ClassName <> TTogetherTrainView.ClassName then
    Exit;
  togetherTrain := TTogetherTrainView(m_SelectView);
  if togetherTrain = nil then exit;
  togetherGroup := togetherTrain.TogetherTrain;
  strTrainTypeName := togetherGroup.strTrainTypeName;
  strTrainNumber := togetherGroup.strTrainNumber;
  if not TFrmAddJiChe.InputTrainInfo(strTrainTypeName,strTrainNumber) then exit;
  togetherGroup.strTrainTypeName := strTrainTypeName;
  togetherGroup.strTrainNumber := strTrainNumber;

  m_RsLCNameBoardEx.Together.UpdateTrain(togetherGroup.strTrainGUID,
  togetherGroup.strTrainTypeName,togetherGroup.strTrainNumber);

  togetherTrain.TogetherTrain := togetherGroup;
  tabtopBoard.Repaint;
end;

procedure TfrmNameBoardManage.mniDelPlateClick(Sender: TObject);
var
  trainmanView : TTrainmanView;
begin
  trainmanView := TTrainmanView ( GetSelectedView );
  if (trainmanView = nil)  then
  begin
    Box('����ָ��Ҫת���ĳ���Ա��Ϣ');
    exit;
  end;

  if TBox('ȷ��ת����?') then
  begin
    m_RsLCNameBoardEx.Trainman.SetStateToNull(trainmanView.Trainman.strTrainmanNumber);
    Box('ת���ɹ�');
    InitJiaoluTab;
  end;
end;

procedure TfrmNameBoardManage.mniN4Click(Sender: TObject);
begin
//
end;

procedure TfrmNameBoardManage.mniNamedViewPlanClick(Sender: TObject);
var
  view : TView;
  namedGroupView : TNamedGroupView;
  TrainmanPlan:RRsTrainmanPlan;
begin
  view := m_SelectView;
  namedGroupView := TNamedGroupView(m_SelectView);
  if (view = nil) or (view.ClassName <> TNamedGroupView.ClassName) then
  begin
    Box('����ָ��������Ϣ');
    exit;
  end;


  m_RsLCNameBoardEx.Group.GetPlan(namedGroupView.NamedGroup.Group.strGroupGUID,TrainmanPlan);
  TFrmPlanInfo.ShowPlan(TrainmanPlan.TrainPlan);

end;

procedure TfrmNameBoardManage.mniOrderViewPlanClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;
  TrainmanPlan:RRsTrainmanPlan;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
  begin
    Box('����ָ��������Ϣ');
    exit;
  end;

  orderGroupView := TOrderGroupView(view);


  m_RsLCNameBoardEx.Group.GetPlan(orderGroupView.OrderGroup.Group.strGroupGUID,TrainmanPlan);
  TFrmPlanInfo.ShowPlan(TrainmanPlan.TrainPlan);
end;

procedure TfrmNameBoardManage.mniTogegherViewPlanClick(Sender: TObject);
var
  view : TView;
  TrainmanPlan:RRsTrainmanPlan;
  orderGroupInTrainView : TOrderGroupInTrainView;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TOrderGroupInTrainView.ClassName) then  
  begin
    Box('����ָ��������Ϣ');
    exit;
  end;
  orderGroupInTrainView := TOrderGroupInTrainView(view);

  m_RsLCNameBoardEx.Group.GetPlan(orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID,TrainmanPlan);
  TFrmPlanInfo.ShowPlan(TrainmanPlan.TrainPlan);
end;

procedure TfrmNameBoardManage.mniUnnormalOrderDeleteClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  view :=  m_SelectView;;
  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
  begin
    Box('����ָ��Ҫɾ���Ļ�����Ϣ');
    exit;
  end;

  orderGroupView := TOrderGroupView(view);
  try
    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
    if not TBox('��ȷ��Ҫɾ���˻�����') then exit;
    GetSelectedTrainmaJiaolu(TrainmanJiaolu);
    m_InputJL.jiaoluID := TrainmanJiaolu.strTrainmanJiaoluGUID;
    m_InputJL.jiaoluName := TrainmanJiaolu.strTrainmanJiaoluName;
    m_InputJL.jiaoluType := Ord(TrainmanJiaolu.nJiaoluType);
    
    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupView.OrderGroup.Group.strGroupGUID,m_DutyUser);;

    tabtopBoard.DeleteView(orderGroupView);
    ReorderOrderViews;
  except on e : exception do
    begin
      Box('ɾ������ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.mniUnnormalOrderMoveClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;

  trainJiaoluGUID : string;
  StationArray: TRsStationArray;
  strStationGUID:string;
  ErrorInfo: string;
  placeList : TRsDutyPlaceList;
  i: Integer;
begin

  view :=  m_SelectView;;
  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
  begin
    Box('����ָ���Ļ�����Ϣ');
    exit;
  end;
  orderGroupView := TOrderGroupView(view);


  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('��ѡ��·��Ϣ');
    exit;
  end;

  //��ȡ���еĳ�վ
  if not m_LCStation.GetStationsOfJiaoJu(trainJiaoluGUID,StationArray,ErrorInfo) then
  begin
    Box(ErrorInfo);
    Exit;
  end;
  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(trainjiaoluGUID,placeList,ErrorInfo) then
  begin
    box(ErrorInfo);
    exit;
  end;
  SetLength(StationArray,length(placeList));
  for i := 0 to length(placeList) - 1 do
  begin
    StationArray[i].strStationGUID := placeList[i].placeID;
    StationArray[i].strStationName := placeList[i].placeName;
    StationArray[i].strStationNumber := placeList[i].placeID;
  end;
  if not TFrmNameBorardSelectStation.GetSelStation(StationArray,strStationGUID) then
    Exit;
  if strStationGUID <> '' then
  begin
    if not m_webNameBoard.ChangeGroupPlace(orderGroupView.OrderGroup.Group.strGroupGUID,
    orderGroupView.OrderGroup.Group.place.placeID,
    strStationGUID,ErrorInfo) then
    begin
      Box(ErrorInfo);
      Exit;
    end;

    tabtopBoard.DeleteView(orderGroupView);
    ReorderOrderViews;
    Box('�ƶ��ɹ�');

  end;
end;

procedure TfrmNameBoardManage.miTX_EndClick(Sender: TObject);
var
  view : TView;
  orderGroupView : TOrderGroupView;
begin
  view := m_SelectView;
  orderGroupView := TOrderGroupView(view);
  try
    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
    if not TBox('ȷ��Ҫ�����û��������') then exit;
    m_InputJL.SetTrainmanJL(m_SelectedTrainmanJiaolu);
    m_RsLCNameBoardEx.Group.GroupTX.Del(m_InputJL,m_DutyUser,orderGroupView.OrderGroup.Group.strGroupGUID);
    tabtopBoard.DeleteView(orderGroupView);
    ReorderOrderViews;
  except on e : exception do
    begin
      Box('����ʧ�ܣ�' + e.Message);
    end;
  end;

end;
procedure TfrmNameBoardManage.N7Click(Sender: TObject);
var
  strTrainJiaoluGUID:string;
  strError:string;
  dutyPlace:RRsDutyPlace;
  view : TView;
  orderGroupView : TOrderGroupView;
  group:RRsGroup;
begin
  view := m_SelectView;
  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
  begin
    Box('����ָ���Ļ�����Ϣ');
    exit;
  end;

  orderGroupView := TOrderGroupView(view);
  try
    group := orderGroupView.OrderGroup.Group ;
    if IsGroupBusy(group.strGroupGUID) then exit;

    strTrainJiaoluGUID := '' ;
    if not GetSelectedTrainJiaolu(strTrainJiaoluGUID)  then
    begin
      BoxErr('��ѡ��·');
      Exit ;
    end;
    if not TFrmSelectDutyPlace.SelectDutyPlace(strTrainJiaoluGUID,dutyPlace) then Exit;

    if group.place.placeID = dutyPlace.placeID then
    begin
      BoxErr('ԭ���ڵ�ͱ��޸ĵĳ��ڵ㲻��һ����');
      Exit;
    end;


    if not TBox('��ȷ�޸ĸû���ĳ��ڵ���') then exit;
    if not m_webNameBoard.ChangeGroupPlace(group.strGroupGUID,
      group.place.placeID,dutyPlace.placeID,strError)  then
    begin
      BoxErr(strError);
      Exit;
    end;

    InitOrderBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
  except on e : exception do
    begin
      Box('�޸Ļ�����ڵ�ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miInsertOrderGroupClick(Sender: TObject);
var
  dtArriveTime : TDateTime;
  selOrderView,preOrderView : TOrderGroupView;
  orderGroup : RRsOrderGroup;
  trainmanJiaolu : RRsTrainmanJiaolu;
  zfqj : RRsZheFanQuJian;
  station : RRsStation;
  strGroupGUID: string;
  dutyPlace:RRsDutyPlace;
  InputParam: TRsLCOrderGrpInputParam;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  if not GetSelectedDutyPlace(dutyPlace) then
  begin
    BoxErr('��ѡ����ڵ�!');
    Exit;
  end;
  orderGroup.Group.place := dutyPlace ;


  if not TFrmAddGroup.InputGroup(
    '',
    orderGroup.Group.Trainman1,
    orderGroup.Group.Trainman2,orderGroup.Group.Trainman3,orderGroup.Group.Trainman4) then exit;
  try
    //����������Ա�Ƿ��ܱ����
    if not CheckAddGroup(orderGroup.Group) then exit;

        //���������Ա�Ƿ��Ѿ�������������
    if not CheckGroupIsOwner(orderGroup.Group,jltOrder) then Exit ;


    orderGroup.strOrderGUID := NewGUID;
    orderGroup.nOrder := 0;
    orderGroup.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;

    orderGroup.Group.strGroupGUID := NewGUID;
    if trainmanJiaolu.nTrainmanRunType = trtZFQJ then
    begin
      orderGroup.Group.ZFQJ.strZFQJGUID := zfqj.strZFQJGUID;
    end
    else
    begin
      orderGroup.Group.Station.strStationGUID := station.strStationGUID;
    end;

    InputParam := TRsLCOrderGrpInputParam.Create;

    try
      InputParam.TrainmanJiaolu.SetTrainmanJL(trainmanJiaolu);
      InputParam.DutyUser.strDutyGUID := m_DutyUser.strDutyGUID;
      InputParam.DutyUser.strDutyNumber := m_DutyUser.strDutyNumber;
      InputParam.DutyUser.strDutyName := m_DutyUser.strDutyName;
      InputParam.OrderGUID := orderGroup.strOrderGUID;
      InputParam.LastArriveTime := orderGroup.dtLastArriveTime;
      InputParam.PlaceID := orderGroup.Group.place.placeID;
      InputParam.TrainmanNumber1 := orderGroup.Group.Trainman1.strTrainmanNumber;
      InputParam.TrainmanNumber2 := orderGroup.Group.Trainman2.strTrainmanNumber;
      InputParam.TrainmanNumber3 := orderGroup.Group.Trainman3.strTrainmanNumber;
      InputParam.TrainmanNumber4 := orderGroup.Group.Trainman4.strTrainmanNumber;

      m_RsLCNameBoardEx.Order.Group.Add(InputParam);;
    finally
      InputParam.Free;
    end;


    strGroupGUID := orderGroup.Group.strGroupGUID;


    m_RsLCNameBoardEx.Order.Group.GetOrderGroup(strGroupGUID, OrderGroup);




    selOrderView := TOrderGroupView(m_SelectView);
    preOrderView := TOrderGroupView(GetPrevView(selOrderView));
    //û��ǰһ��������ȡĿ�����ĵ���ʱ���ǰ60����
    dtArriveTime :=  DateUtils.IncMinute(selOrderView.OrderGroup.dtLastArriveTime,-60);
    //��ǰһ��������ȥ����������м��¼�
    if preOrderView <> nil then
    begin
      dtArriveTime := preOrderView.OrderGroup.dtLastArriveTime +
        (selOrderView.OrderGroup.dtLastArriveTime - preOrderView.OrderGroup.dtLastArriveTime) /2;
    end ;

    m_InputJL.SetTrainmanJL(trainmanJiaolu);
    m_RsLCNameBoardEx.Group.UpdateArriveTime(OrderGroup.strOrderGUID,
    OrderGroup.dtLastArriveTime,dtArriveTime,m_DutyUser,m_InputJL);
  finally

  end;
end;

procedure TfrmNameBoardManage.NamedGroupDragDrop(Sender,
  NamedGroupView: TNamedGroupView);
var
  trainmanJiaolu : RRsTrainmanJiaolu;
  tmpGroup  : RRsNamedGroup;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then
  begin
    Box('��ѡ����Ա��·��Ϣ');
    exit;
  end;

  try
    if not TBox('ȷ���������������λ����') then
      Exit ;

    m_InputJL.SetTrainmanJL(trainmanJiaolu);
    m_RsLCNameBoardEx.Group.Swap(m_InputJL,m_DutyUser,NamedGroupView.NamedGroup.Group.strGroupGUID,
    Sender.NamedGroup.Group.strGroupGUID);

    
    tmpGroup := sender.NamedGroup;
    Sender.NamedGroup := NamedGroupView.NamedGroup;
    NamedGroupView.NamedGroup := tmpGroup;

 

  except on E: Exception do
    begin
      Boxerr('��������ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.NotAllowTrainmanDrag(Sender,
  TrainmanView: TTrainmanView; var bIsOver: Boolean);
begin
  bIsOver := false;
end;

class procedure TfrmNameBoardManage.OpenNameBoardManage(EditEnabled : boolean = true;
CanDel : boolean = true);
begin
  if frmNameBoardManage = nil then
  begin
    frmNameBoardManage := TfrmNameBoardManage.Create(nil);
    frmNameBoardManage.Init;
    frmNameBoardManage.m_bEditEnabled := EditEnabled;
    frmNameBoardManage.mniDelPlate.Visible  := CanDel;
    frmNameBoardManage.InitTrainJiaolu;
    frmNameBoardManage.Show;
  end
  else
  begin
    frmNameBoardManage.Show;
    frmNameBoardManage.WindowState := wsMaximized;
  end;

end;

procedure TfrmNameBoardManage.OrderGroupDragDrop(Sender,
  OrderGroupView: TOrderGroupView);
begin
  ExchangeOrderGroup(OrderGroupView,Sender);
end;

procedure TfrmNameBoardManage.OrderTrainmanDragDrop(Sender,
  TrainmanView: TTrainmanView);
var
  tmpTrainman,sourceTrainman : RRsTrainman;
  sourceGroup,destGroup:RRsGroup;
  destIndex : integer;
  sourceParentGUID,destParentGUID : string;
  AddInput: TRsLCTrainmanAddInput;
begin
  if not m_bEditEnabled then exit;

  //��Ա�Ƿ��Ѿ����żƻ�
  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
  begin
    exit;
  end;
  //�����Ƿ��Ѿ����żƻ�
  if IsGroupBusy(TOrderGroupView(TrainmanView.Parent).OrderGroup.Group.strGroupGUID) or
      IsGroupBusy(TOrderGroupView(Sender.Parent).OrderGroup.Group.strGroupGUID) then
  begin
    exit;
  end;

  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;

  sourceTrainman := TrainmanView.Trainman;
  sourceGroup := TOrderGroupView(TrainmanView.Parent).OrderGroup.Group;
  sourceParentGUID := TOrderGroupView(TrainmanView.Parent).OrderGroup.strOrderGUID;

  destGroup := TOrderGroupView(Sender.Parent).OrderGroup.Group;
  destParentGUID := TOrderGroupView(Sender.Parent).OrderGroup.strOrderGUID;
  destIndex := TOrderGroupView(Sender.Parent).Childs.IndexOf(Sender) + 1;

  if (TrainmanView.Trainman.strTrainmanGUID = '') then
  begin
    sourceTrainman := Sender.Trainman;

    destGroup := TOrderGroupView(TrainmanView.Parent).OrderGroup.Group;
    destParentGUID := TOrderGroupView(TrainmanView.Parent).OrderGroup.strOrderGUID;
    destIndex := TOrderGroupView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;

    sourceGroup := TOrderGroupView(Sender.Parent).OrderGroup.Group;
    sourceParentGUID := TOrderGroupView(Sender.Parent).OrderGroup.strOrderGUID;
  end;

  
  try
    AddInput := TRsLCTrainmanAddInput.Create;
    try
      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
      AddInput.TrainmanIndex := destIndex;
      AddInput.GroupGUID := destGroup.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

      
    finally
      AddInput.Free;
    end;

    //������Ա����ͼ
    tmpTrainman := sender.Trainman;
    Sender.Trainman := TrainmanView.Trainman;
    TrainmanView.Trainman := tmpTrainman;
    
  except on E: Exception do
    begin
      Boxerr('������Աʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.pmenuNamedPopup(Sender: TObject);
var
  view : TView;
  trainmanJiaolu : RRsTrainmanJiaolu;
  bUses:Boolean ;
begin
  DisabledNamedPopMenu;
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  miAddNamedGroup.Enabled := true;
  view :=  GetSelectedView;
  m_SelectView := View;
  if view = nil then exit;

    //�Ƿ�����ɾ���������Ա
  bUses :=  UsesDelGroup ;
  miDeleteNamedTrainman.Enabled := bUses ;
  miDeleteNamedGroup.Enabled := bUses ;

  //���л���
  if view.ClassName = TNamedGroupView.ClassName then
  begin
    miEditCheci.Enabled := true;
    mniNamedViewPlan.Enabled := True ;
    miDeleteNamedTrainman.Enabled := False ;
    miTX_Named.Enabled := True;
    exit;
  end;
  //���г���Ա
  if view.ClassName = TTrainmanView.ClassName then
  begin
    mniNamedViewPlan.Enabled := False ;
    miAddNamedTrainman.Enabled := true;
    if TTrainmanView(View).Trainman.strTrainmanGUID <> '' then
      ;
    exit;
  end;
end;

procedure TfrmNameBoardManage.pmenuOrderPopup(Sender: TObject);
var
  view : TView;
  trainmanJiaolu : RRsTrainmanJiaolu;
  bUses:Boolean;
begin
  DisableOrderPopMenu;
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  miOrderCut.Checked := false;
  if m_CutView <> nil then
  begin
    miOrderCut.Checked := true;
  end;
  miAddOrderGroup.Enabled := true;
  view :=  GetSelectedView;
  m_SelectView := View;
  if view = nil then exit;
  //���л���

  bUses := UsesDelGroup ;
  miDeleteOrderTrainman.Enabled := bUses;
  miDeleteOrderGroup.Enabled := bUses ;


  if view.ClassName = TOrderGroupView.ClassName then
  begin
    mniOrderViewPlan.Enabled := True ;
    miTX_Order.Enabled := True;
    if m_CutView = nil then
    begin
      miOrderCut.Enabled := true;
    end else begin
      //ѡ�еĻ���Ϊ�Ѽ��еĻ�����
      if view = m_CutView then
      begin

      end else begin
        miOrderCut.Enabled := true;
        miOrderPasteBefore.Enabled := true;
        miOrderPasteAfter.Enabled := true;
        miOrderPasteCover.Enabled := true;
      end;
    end;
    exit;
  end;
  //���г���Ա
  if view.ClassName = TTrainmanView.ClassName then
  begin
    mniOrderViewPlan.Enabled := False ;
    miAddOrderTrainman.Enabled := true;
    exit;
  end;
end;

procedure TfrmNameBoardManage.pmenuTogetherPopup(Sender: TObject);
var
  view : TView;
  trainmanJiaolu : RRsTrainmanJiaolu;
  bUses : Boolean ;
begin
  DisabledTogetherPopMenu;
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  miAddTogetherTrain.Enabled := true;
  view :=  GetSelectedView;
  m_SelectView := View;
  if view = nil then exit;

   //���л���
  if view.ClassName = TTogetherTrainView.ClassName then
  begin
    mniTogegherViewPlan.Enabled := False ;
    miDeleteTogetherTrain.Enabled := true;
    miAddTogetherGroup.Enabled := true;
    miUpdateTrain.Enabled := True;
    miDeleteTogetherTrain.Enabled := True;
    exit;
  end;

  bUses := UsesDelGroup ;
  miDeleteTogetherTrainman.Enabled := bUses ;
  miDeleteTogetherGroup.Enabled := bUses ;

  //���л���
  if view.ClassName = TOrderGroupInTrainView.ClassName then
  begin
     mniTogegherViewPlan.Enabled := True ;
    miAddTogetherGroup.Enabled := true;
    miTX_Together.Enabled := True;
    exit;
  end;
  //���г���Ա
  if view.ClassName = TTrainmanView.ClassName then
  begin
    mniTogegherViewPlan.Enabled := False ;
    miAddTogetherTrainman.Enabled := true;
    mniTogegherViewKeyTrainman.Enabled := true;
    mniTogegherViewFixedGroup.Enabled := true;

    exit;
  end;
end;

procedure TfrmNameBoardManage.pmenuUnnormalOrderPopupPopup(Sender: TObject);
var
  view : TView;
  trainmanJiaolu : RRsTrainmanJiaolu;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
  view :=  GetSelectedView;
  m_SelectView := View;

end;

procedure TfrmNameBoardManage.PopupMenuTXPopup(Sender: TObject);
var
  view : TView;
begin
  miTX_End.Enabled := False;
  view :=  GetSelectedView;
  m_SelectView := View;
  if view = nil then exit;


  miTX_End.Enabled := True;
end;
procedure TfrmNameBoardManage.ReorderOrderViews;
var
  i : integer;
begin
  for i := 0 to tabtopBoard.GetViewCount - 1 do
  begin
    TOrderGroupView(tabtopBoard.GetView(i)).SetOrderGroupOrder(i+1);
  end;
  tabtopBoard.ReComposition;
  tabtopBoard.ReCanvas;
end;
      


procedure TfrmNameBoardManage.SetNameplateTrainmanJiaolu(const Value: string);
begin
  GlobalDM.WriteIniConfig('UserData','NameplateTrainmanJiaolu',Value);
end;

procedure TfrmNameBoardManage.SetPopupData(LookupEdit: TtfLookupEdit;
  TrainmanArray: TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(TrainmanArray) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := TrainmanArray[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(TrainmanArray[i].strTrainmanNumber);
    item.SubItems.Add(TrainmanArray[i].strTrainmanName);
    item.SubItems.Add(TRsPostNameAry[TrainmanArray[i].nPostID]);
    item.SubItems.Add(TRsKeHuoNameArray[TrainmanArray[i].nKehuoID]);
    if TrainmanArray[i].bIsKey > 0 then
    begin
      item.SubItems.Add('��');
    end else begin
      item.SubItems.Add('');
    end;
    item.SubItems.Add(TrainmanArray[i].strABCD);
    item.SubItems.Add(TrainmanArray[i].strMobileNumber);
    item.SubItems.Add(TRsTrainmanStateNameAry[TrainmanArray[i].nTrainmanState]);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('���� %d ҳ���� %d ҳ', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);

end;

procedure TfrmNameBoardManage.InitNamedBoard(TrainmanJiaoluGUID: string);
var
  namedGroupArray : TRsNamedGroupArray;
  namedView : TNamedGroupView;
  i : integer;
  blnSelected: boolean;
  strError:string;
begin
  if m_bEditEnabled then
    tabtopBoard.PopupMenu := pmenuNamed
  else
    tabtopBoard.PopupMenu := nil;


    
  tabtopBoard.ClearView;
  tabtopBoard.SetLayoutType(ltVertical);


  if not m_webNameBoard.GetNamedGroup(TrainmanJiaoluGUID,namedGroupArray,strError) then
  begin
    BoxErr(strError);
  end;

  blnSelected := false;
  tabtopBoard.BeginUpdate;
  try
    for i := 0 to length(namedGroupArray) - 1 do
    begin
      namedView := TNamedGroupView.Create(nil);
      namedView.OnTrainmanDragOver := NamedTrainmanDragDrop;
      namedView.OnNamedGroupDragOver := NamedGroupDragDrop;
      namedGroupArray[i].nOrgCheciOrder := namedGroupArray[i].nCheciOrder ;
      namedGroupArray[i].nCheciOrder := i + 1;
      namedView.NamedGroup := namedGroupArray[i];
      namedView.Images := PngImageCollection;
      tabtopBoard.AddView(namedView);

      if m_SelectUserInfo.strTrainmanGUID <> ''  then
      begin
        if IsQueriedGroup(namedGroupArray[i].Group) then
        begin
          namedView.Selected := true;
          if not blnSelected then
          begin
            tabtopBoard.VertScrollBar.Position := namedView.top + namedView.Height - tabtopBoard.Height;
            tabtopBoard.ReCanvas;
            blnSelected := true;
          end;
        end;
      end;
    end;
  finally
    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.InitOrderBoard(TrainmanJiaoluGUID: string);
var
  orderGroupArray : TRsOrderGroupArray;
  orderView : TOrderGroupView;
  i : integer;
  placeDuty:RRsDutyPlace;
  blnSelected: boolean;
  strError:string;
begin
  placeDuty := m_listDutyPlace[0];
  if m_bEditEnabled then  
    tabtopBoard.PopupMenu := pmenuOrder
  else
    tabtopBoard.PopupMenu := nil;

  tabtopBoard.ClearView;
  tabtopBoard.SetLayoutType(ltVertical);
  tabtopBoard.VertScrollBar.Position := 0;

  tabtopBoard.BeginUpdate;
  blnSelected := false;
  try
    if not m_webNameBoard.GetOrderGroup(TrainmanJiaoluGUID,placeDuty.placeID,'',orderGroupArray,strError)  then
    begin
      BoxErr(strError);
      Exit;
    end;
    for i := 0 to length(orderGroupArray) - 1 do
    begin

      orderView := TOrderGroupView.Create(nil);
      orderView.OnTrainmanDragOver := OrderTrainmanDragDrop;
      orderView.OnOrderGroupDragOver := OrderGroupDragDrop;
      orderGroupArray[i].nOrder := (i + 1);
      orderView.OrderGroup := orderGroupArray[i];
      orderView.Images := PngImageCollection;
      tabtopBoard.AddView(orderView);

      if m_SelectUserInfo.strTrainmanGUID <> '' then
      begin
        if IsQueriedGroup(orderGroupArray[i].Group) then
        begin    
          orderView.Selected := true;
          if not blnSelected then
          begin
            tabtopBoard.VertScrollBar.Position := orderView.top + orderView.Height - tabtopBoard.Height;
            tabtopBoard.ReCanvas;
            blnSelected := true;
          end;
        end;
      end;
    end;
  finally
    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.InitTogetherBoard(TrainmanJiaoluGUID: string);
var
  togetherGroupArray : TRsTogetherTrainArray;
  togetherView : TTogetherTrainView;
  orderGroupInTrainView: TOrderGroupInTrainView;
  i, j : integer;
  blnSelected: boolean;
  strError:string;
begin
  if m_bEditEnabled then
    tabtopBoard.PopupMenu := pmenuTogether
  else
    tabtopBoard.PopupMenu := nil;

    
  tabtopBoard.ClearView;
  tabtopBoard.SetLayoutType(ltVertical);

  if not m_webNameBoard.GetTogetherGroup(TrainmanJiaoluGUID,togetherGroupArray,strError) then
  begin
    BoxErr(strError);
  end;


  blnSelected := false;

  tabtopBoard.BeginUpdate;
  try
    for i := 0 to length(togetherGroupArray) - 1 do
    begin
      togetherView := TTogetherTrainView.Create(nil);
      togetherView.TogetherTrain := togetherGroupArray[i];
      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
      togetherView.Images := PngImageCollection;
      tabtopBoard.AddView(togetherView);

      if m_SelectUserInfo.strTrainmanGUID <> '' then
      begin
        for j := 0 to Length(togetherGroupArray[i].Groups) - 1 do
        begin
          if IsQueriedGroup(togetherGroupArray[i].Groups[j].Group) then
          begin
            if not blnSelected then
            begin
              tabtopBoard.VertScrollBar.Position := togetherView.top + togetherView.Height - tabtopBoard.Height;
              tabtopBoard.ReCanvas;
              blnSelected := true;
            end;
            orderGroupInTrainView := TOrderGroupInTrainView(togetherView.Childs[j]);
            orderGroupInTrainView.Selected := true;
          end;
        end;
      end;
    end;
  finally
    tabtopBoard.ReComposition;
    tabtopBoard.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.ReorderNamedViews;
var
  i : integer;
begin
  for i := 0 to tabtopBoard.GetViewCount - 1 do
  begin
    TNamedGroupView(tabtopBoard.GetView(i)).SetNamedGroupOrder(i+1);
  end;
  tabtopBoard.ReComposition;
  tabtopBoard.ReCanvas;
end;

procedure TfrmNameBoardManage.tabZFQDChange(Sender: TObject);
var
  trainmanJiaolu : RRsTrainmanJiaolu;
  nIndex:Integer;
  strType:string;
begin

  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then
  begin
    exit;
  end;
  nIndex := tabZFQD.TabIndex  ;
  strType := tabZFQD.Tabs[nIndex].Caption ;

  if strType = TAB_NAME_UNRUN then
  begin
    InitUnrunTrainman(trainmanJiaolu.strTrainmanJiaoluGUID);
    Exit;
  end;

  if strType = TAB_NAME_NULL then
  begin
    ShowUnnormalOrderBoard(trainmanJiaolu.strTrainmanJiaoluGUID);
    exit;
  end;
  if strType = TAB_NAME_PREPARE then
  begin
    InitPrepareTrainman(trainmanJiaolu.strTrainmanJiaoluGUID);
    exit;
  end;

  if strType = TAB_NAME_TX then
  begin
    InitTXGroups(trainmanJiaolu.strTrainmanJiaoluGUID);
    Exit;  
  end;
  
  case trainmanJiaolu.nJiaoluType of
    jltNamed :
    begin
      InitNamedBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
    end;
    jltOrder : begin
      InitOrderBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
    end;
    jltTogether : begin
     InitTogetherBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
    end;
  end;


end;

procedure TfrmNameBoardManage.TogetherGroupDragDrop(Sender:TOrderGroupInTrainView;
      OrderGroupInTrainView:TOrderGroupInTrainView); 
var
  trainmanJiaolu : RRsTrainmanJiaolu;
  tmpGroup : RRsOrderGroupInTrain;
begin
  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then
  begin
    Box('��ѡ����Ա��·��Ϣ');
    exit;
  end;
  try
      if not TBox('ȷ���������������λ����') then
      Exit ;

    m_InputJL.SetTrainmanJL(trainmanJiaolu);

    m_RsLCNameBoardEx.Group.Swap(m_InputJL,m_DutyUser,OrderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID,
      Sender.OrderGroupInTrain.Group.strGroupGUID);



    tmpGroup := Sender.OrderGroupInTrain;
    Sender.OrderGroupInTrain := OrderGroupInTrainView.OrderGroupInTrain;
    OrderGroupInTrainView.OrderGroupInTrain := tmpGroup;

  except on E: Exception do
    begin
      Boxerr('��������ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.TogetherTrainmanDragDrop(Sender,
  TrainmanView: TTrainmanView);
var
  tmpTrainman,sourceTrainman : RRsTrainman;
  sourceGroup,destGroup:RRsGroup;
  destIndex : integer;
  sourceParentGUID,destParentGUID : string;
  AddInput: TRsLCTrainmanAddInput;
begin
  if not m_bEditEnabled then exit;

  //��Ա�Ƿ��Ѿ����żƻ�
  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
  begin
    exit;
  end;
  //�����Ƿ��Ѿ����żƻ�
  if IsGroupBusy(TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group.strGroupGUID) or
      IsGroupBusy(TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group.strGroupGUID) then
  begin
    exit;
  end;

  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;

  sourceTrainman := TrainmanView.Trainman;
  sourceGroup := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group;
  sourceParentGUID := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.strOrderGUID;

  destGroup := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group;
  destParentGUID := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.strOrderGUID;
  destIndex := TOrderGroupInTrainView(Sender.Parent).Childs.IndexOf(Sender) + 1;
  
  if (TrainmanView.Trainman.strTrainmanGUID = '') then
  begin
    sourceTrainman := Sender.Trainman;
    
    destGroup := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group;
    destParentGUID := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.strOrderGUID;
    destIndex := TOrderGroupInTrainView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;

    sourceGroup := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group;
    sourceParentGUID := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.strOrderGUID;
  end;

  
  try
    AddInput := TRsLCTrainmanAddInput.Create;
    try
      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
      AddInput.TrainmanIndex := destIndex;
      AddInput.GroupGUID := destGroup.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

      
    finally
      AddInput.Free;
    end;
   
    
    //������Ա����ͼ
    tmpTrainman := sender.Trainman;
    Sender.Trainman := TrainmanView.Trainman;
    TrainmanView.Trainman := tmpTrainman;
  except on E: Exception do
    begin
      Boxerr('������Աʧ�ܣ�' + e.Message);
    end;
  end;

end;

procedure TfrmNameBoardManage.NamedTrainmanDragDrop(Sender,
  TrainmanView: TTrainmanView);
var
  tmpTrainman,sourceTrainman : RRsTrainman;
  sourceGroup,destGroup:RRsGroup;
  destIndex : integer;
  sourceParentGUID,destParentGUID : string;
  AddInput: TRsLCTrainmanAddInput;
begin
  if not m_bEditEnabled then exit;

  //��Ա�Ƿ��Ѿ����żƻ�
  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
  begin
    exit;
  end;
  //�����Ƿ��Ѿ����żƻ�
  if IsGroupBusy(TNamedGroupView(TrainmanView.Parent).NamedGroup.Group.strGroupGUID) or
      IsGroupBusy(TNamedGroupView(Sender.Parent).NamedGroup.Group.strGroupGUID) then
  begin
    exit;
  end;

  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;

  sourceTrainman := TrainmanView.Trainman;
  sourceGroup := TNamedGroupView(TrainmanView.Parent).NamedGroup.Group;
  sourceParentGUID := TNamedGroupView(TrainmanView.Parent).NamedGroup.strCheciGUID;

  destGroup := TNamedGroupView(Sender.Parent).NamedGroup.Group;
  destParentGUID := TNamedGroupView(Sender.Parent).NamedGroup.strCheciGUID;
  destIndex := TNamedGroupView(Sender.Parent).Childs.IndexOf(Sender) + 1;
  
  if (TrainmanView.Trainman.strTrainmanGUID = '') then
  begin
    sourceTrainman := Sender.Trainman;
    
    destGroup := TNamedGroupView(TrainmanView.Parent).NamedGroup.Group;
    destParentGUID := TNamedGroupView(TrainmanView.Parent).NamedGroup.strCheciGUID;
    destIndex := TNamedGroupView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;

    sourceGroup := TNamedGroupView(Sender.Parent).NamedGroup.Group;
    sourceParentGUID := TNamedGroupView(Sender.Parent).NamedGroup.strCheciGUID;
  end;

  
  try
    AddInput := TRsLCTrainmanAddInput.Create;
    try
      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelectedTrainmanJiaolu);
      AddInput.DutyUser.Assign(m_DutyUser);
      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
      AddInput.TrainmanIndex := destIndex;
      AddInput.GroupGUID := destGroup.strGroupGUID;

      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);

      
    finally
      AddInput.Free;
    end;

    
   
    //������Ա����ͼ
    tmpTrainman := sender.Trainman;
    Sender.Trainman := TrainmanView.Trainman;
    TrainmanView.Trainman := tmpTrainman;
  except on E: Exception do
    begin
      Boxerr('������Աʧ�ܣ�' + e.Message);
    end;
  end;
end;


procedure TfrmNameBoardManage.treeJiaoluChange(Sender: TObject;
  Node: TTreeNode);
begin  
  InitJiaoluTab;
end;

function TfrmNameBoardManage.UsesDelGroup: boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := GlobalDM.ReadIniConfig('SysConfig','UsesDelGroup');

  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

procedure TfrmNameBoardManage.WMMessageRefreshNormal(var Msg: TMessage);
begin
  InitJiaoluTab;
end;

procedure TfrmNameBoardManage.WMMessageRefreshOrder(var Msg: TMessage);
begin
  InitOrderBoard(m_SelectedTrainmanJiaolu.strTrainmanJiaoluGUID);
end;

procedure TfrmNameBoardManage.WMMessageRepaint(var Msg: TMessage);
begin
  tabtopBoard.Repaint;
end;

end.

