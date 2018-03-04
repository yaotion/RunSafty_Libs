unit uFrmNameBoardManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, ExtCtrls, Buttons,
  RzPanel, RzStatus, RzTabs, AdvSplitter, RzTreeVw,
  uTFSystem,uTrainmanJiaolu,uTrainJiaolu,uTrainman,
  uSaftyEnum,uNamedGroupView,uOrderGroupInTrainView,uOrderGroupView,
  uTogetherTrainView,uTrainmanView, Menus,uTrainmanOrderView,uStation,
  uTrainPlan,  Mask, RzEdit, ActnList,uDutyPlace,uLCDutyPlace,uLCTrainPlan,
  uLCNameBoard, utfLookupEdit,utfPopTypes,uLCTrainJiaolu,uLCNameBoardEx,
  uLCTrainmanMgr,RsGlobal_TLB,uHttpWebAPI,
  uLCDict_TrainmanJiaoLu,uLCDict_Station,uScrollView, RzCommon, RzBorder;
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
    StatusBar: TRzStatusBar;
    statusPanelSum: TRzStatusPane;
    pnlClients: TRzPanel;
    pmenuNamed: TPopupMenu;
    miAddNamedGroup: TMenuItem;
    N2: TMenuItem;
    miAddNamedTrainman: TMenuItem;
    miDeleteNamedTrainman: TMenuItem;
    N5: TMenuItem;
    miDeleteNamedGroup: TMenuItem;
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
    miOrderCut: TMenuItem;
    N4: TMenuItem;
    miOrderPasteBefore: TMenuItem;
    miOrderPasteAfter: TMenuItem;
    miOrderPasteCover: TMenuItem;
    miEditCheci: TMenuItem;
    miUpdateTrain: TMenuItem;
    pMenu1: TPopupMenu;
    mniDelPlate: TMenuItem;
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
    miEditOrder: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
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
    treeJiaolu: TRzTreeView;
    RzFrameController1: TRzFrameController;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzPanel1: TRzPanel;
    AdvSplitter1: TAdvSplitter;
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
    procedure miEditCheciClick(Sender: TObject);
    procedure miUpdateTrainClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPYKeyPress(Sender: TObject; var Key: Char);
    procedure mniN4Click(Sender: TObject);
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
    procedure miEditOrderClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure miTX_NamedClick(Sender: TObject);
    procedure miTX_OrderClick(Sender: TObject);
    procedure miTX_TogetherClick(Sender: TObject);
    procedure miTX_EndClick(Sender: TObject);
    procedure PopupMenuTXPopup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure WMMessageRefreshNormal(var Msg : TMessage) ; message WM_Message_RefreshNormal;
    procedure WMMessageRefreshOrder(var Msg : TMessage) ; message WM_Message_RefreshOrder;
    procedure WMMessageRepaint(var Msg : TMessage); message WM_Message_Repaint;
  private
    { Private declarations }
    m_DutyUser: TRsLCBoardInputDuty;
    m_InputJL: TRsLCBoardInputJL;

    m_ScrollView: TScrollView;
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

    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    //��ǰ���е���Ա��·�б�
    m_TmJLArray : TRsTrainmanJiaoluArray;
    //��ǰѡ�е���Ա��·
    m_SelTmJL : RRsTrainmanJiaolu;
    //��Ա��Ϣ���ݿ������
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //��ǰѡ�е�VIEW
    m_SelectView : TView;
    //��ǰ�������µĳ��ڵ�
    m_listDutyPlace:TRsDutyPlaceList;
    //���еĻ����GUID
    m_CutView : TView;
    //��ǰѡ�е���Ա��Ϣ
    m_SelectUserInfo: RRsTrainman;
  
    m_LCTrainmanJiaolu :TRsLCTrainmanJiaolu; 
    m_LCStation : TRsLCStation;
    //��ʼ����������·��
    procedure InitJiaolu;
    //��ʼ����������
    procedure InitJiaoluTab;
    //��ʼ���ֳ˽�·�ı�ǩ��Ϣ(���ڵ�)
    procedure InitOrderJiaoluTab(TrainmanJiaoluGUID : string);
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
    procedure Init;
    function GetNameplateTrainmanJiaolu: string;
    procedure SetNameplateTrainmanJiaolu(const Value: string);
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);
    procedure OnDropMode(src,dest: TView;X,Y: integer;var Mode: TDropMode);
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
  uGroupXlsExporter, uDutyUser, uDialogsLib, uGlobal,Contnrs, uViewDefine;
var
  frmNameBoardManage: TfrmNameBoardManage = nil;
{$R *.dfm}
type
  PTmJL = ^RRsTrainmanJiaolu;


  TPlaceCollection = class(TStringList)
  private
    function GetPlaceID(index: integer): string;
    function GetPlaceName(index: integer): string;
  public
    procedure AddPlace(ID,Name: string);
    property PlaceName[index: integer]: string read GetPlaceName;
    property PlaceID[index: integer]: string read GetPlaceID;
  end;



  TTmJL = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_ID: string;
    m_Name: string;
    m_JlType: integer;
    m_TrainJl: string;
    m_PlaceLst: TPlaceCollection;
  public
    property ID: string read m_ID write m_ID;
    property Name: string read m_Name write m_Name;
    property JlType: integer read m_JlType write m_JlType;
    property TrainJL: string read m_TrainJl write m_TrainJl;
    property PlaceLst: TPlaceCollection read m_PlaceLst;
  end;

  TTmJlLst = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTmJL;
    procedure SetItem(Index: Integer; AObject: TTmJL);
  public
    function FindJl(ID: string): TTmJL;
    procedure FillData(jlArray: TRsTrainmanJiaoluArray);
    property Items[Index: Integer]: TTmJL read GetItem write SetItem; default;
  end;


  TTrainJlPlace = class
  public
    procedure Add(TrainJl,PlaceID,PlaceName: string);
    procedure GetPlaceLst(TrainJl: string;PlaceCollection: TPlaceCollection);
  end;

  
var
  _TmJLLst: TTmJlLst;
  
{ TTmJlLst }

procedure TTmJlLst.FillData(jlArray: TRsTrainmanJiaoluArray);
var
  I: Integer;
  JL: TTmJL;
begin

  for I := 0 to Length(jlArray) - 1 do
  begin
    JL := FindJl(jlArray[i].strTrainmanJiaoluGUID);
    if JL = nil then
    begin
      JL := TTmJL.Create;
      JL.ID := jlArray[i].strTrainmanJiaoluGUID;
      JL.Name := jlArray[i].strTrainmanJiaoluName;
      JL.JlType := Ord(jlArray[i].nJiaoluType);
      Add(JL);
    end;
  end;
end;

function TTmJlLst.FindJl(ID: string): TTmJL;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].ID = ID then
    begin
      Result := Items[i];
      Break;
    end;  
  end;
end;

function TTmJlLst.GetItem(Index: Integer): TTmJL;
begin
  Result := TTmJL(inherited GetItem(Index))
end;

procedure TTmJlLst.SetItem(Index: Integer; AObject: TTmJL);
begin
  inherited SetItem(Index,AObject);
end;  
{ TPlaceCollection }

procedure TPlaceCollection.AddPlace(ID, Name: string);
begin
  Values[ID] := Name;
end;

function TPlaceCollection.GetPlaceID(index: integer): string;
begin
  Result := Names[index]
end;

function TPlaceCollection.GetPlaceName(index: integer): string;
begin
  Result := ValueFromIndex[index];
end;

  
{ TTmJL }

constructor TTmJL.Create;
begin
  m_PlaceLst := TPlaceCollection.Create;
end;

destructor TTmJL.Destroy;
begin
  m_PlaceLst.Free;
  inherited;
end;  
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

procedure TfrmNameBoardManage.btnQueryClick(Sender: TObject);
var
  i: integer;
  Node: TTreeNode;
  TrainmanJiaolu : RRsTrainmanJiaolu;
  FindRet: TRsLCBoardTmFindRet;
begin
//  if edtTrainman1.Text = '' then
//  begin
//    InitJiaoluTab ;
//    Exit ;
//  end;

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
        TrainmanJiaolu := PTmJl(Node.Data)^;
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
//  edtTrainman1.OnChange := nil;
//  try
//   if edtTrainman1.Text <> '' then
//    m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,m_SelectUserInfo)
//   else
//    m_RsLCTrainmanMgr.GetTrainman('',m_SelectUserInfo) ;
//
//   edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
//  finally
//     edtTrainman1.OnChange := edtTrainman1Change;
//  end;
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

  ReorderOrderViews;
end;

procedure TfrmNameBoardManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  frmNameBoardManage := nil;
end;

procedure TfrmNameBoardManage.FormCreate(Sender: TObject);
begin
  m_ScrollView := TScrollView.Create(SELF);
//  m_ScrollView.Parent := pBoardParent;
  m_ScrollView.Align := alClient;
  m_ScrollView.SelectedBorderColor := CL_NP_BK_SELECT;
  m_ScrollView.DroppingColor := $00156AC8;
  m_ScrollView.OnDragViewOver := OnDragViewOver;
  m_ScrollView.OnDropMode := OnDropMode;
  m_ScrollView.DropModePopMenu.SetValidMode([dmInsertSibling,dmExchange,dmCancel]);
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


function TfrmNameBoardManage.GetSelectedDutyPlace(
  out DutyPlace: RRsDutyPlace): Boolean;
begin

end;

function TfrmNameBoardManage.GetSelectedTrainJiaolu(
  out TrainJiaoLuGUID: string): boolean;
begin
  result := treeJiaolu.Selected <> nil ;
  if  result then
    TrainJiaoLuGUID := PTmJl(treeJiaolu.Selected.Data).strTrainJiaoluGUID;
end;

function TfrmNameBoardManage.GetSelectedTrainmaJiaolu(
  out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
begin
  result := false;
  if treeJiaolu.Selected = nil then Exit;
  m_SelTmJL := PTmJL(treeJiaolu.Selected.Data)^;
  TrainmanJiaolu := m_SelTmJL;
  result := true;
end;

function TfrmNameBoardManage.GetSelectedView: TView;
begin
  Result := m_ScrollView.Selected;
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
  m_LCTrainmanJiaolu := TRsLCTrainmanJiaolu.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_LCStation := TRsLCStation.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(WebAPIUtils);
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webNameBoard := TRsLCNameBoard.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_webTrainJiaoLu := TRsLCTrainJiaolu.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(WebAPIUtils);

//  IniColumns(edtTrainman1);

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
//  procedure CreateOrderTabs();
//  begin
//    InitOrderJiaoluTab(m_SelTmJL.strTrainmanJiaoluGUID);
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_UNRUN;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_NULL;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_PREPARE;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_TX;
//  end;
//  procedure CreateNamedTabs();
//  begin
//    tabZFQD.Tabs.Add.Caption := '����ʽ��·��Ա����';
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_UNRUN;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_PREPARE;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_TX;
//  end;
//  procedure CreateTogatherTabs();
//  begin
//    tabZFQD.Tabs.Add.Caption := '���˽�·��Ա����';;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_UNRUN;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_PREPARE;
//    tabZFQD.Tabs.Add.Caption := TAB_NAME_TX;
//  end;
begin
  m_CutView := nil;

end;


procedure TfrmNameBoardManage.InitNamedJiaoluTab(TrainmanJiaoluGUID: string);
begin


end;


procedure TfrmNameBoardManage.InitOrderJiaoluTab(TrainmanJiaoluGUID: string);

begin


end;


procedure TfrmNameBoardManage.InitPrepareTrainman(TrainmanJiaoluGUID : string);
begin
  m_ScrollView.Views.Clear;


  m_RsLCNameBoardEx.Trainman.GetPrepare(GlobalDM.WorkShop.ID,TrainmanJiaoluGUID,trainmanArray);
  m_ScrollView.Views.BeginUpdate;
  try
    for i := 0 to length(trainmanArray) - 1 do
    begin
      trainmanOrderView := TTrainmanOrderView.Create();
      (trainmanOrderView.Items[0] as TTrainmanView).Trainman := trainmanArray[i];;
      trainmanOrderView.Index := i + 1;
      m_ScrollView.Views.AddView(trainmanOrderView);
    end;

  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.InitTogetherJiaoluTab(TrainmanJiaoluGUID: string);
var
  tabItem : TRzTabCollectionItem;
begin
//  tabZFQD.Tabs.Clear;
//  tabItem := tabZFQD.Tabs.Add;
//  tabItem.Caption := '���˽�·��Ա����';
//  tabZFQD.TabIndex := 0;
end;

procedure TfrmNameBoardManage.InitJiaolu;
var
  i: integer;
  node: TTreeNode;
begin
  treeJiaolu.Items.Clear;

  m_LCTrainmanJiaolu.GetTMJLByTrainJLWithSite(GlobalDM.Site.ID,
  '',m_TmJLArray);


  for I := 0 to Length(m_TmJLArray) - 1 do
  begin
    node := treeJiaolu.Items.AddChild(nil,'');
    node.Text := m_TmJLArray[i].strTrainmanJiaoluName;
    node.Data := @m_TmJLArray[i];
  end;
end;




procedure TfrmNameBoardManage.InitTXGroups(TrainmanJiaoluGUID: string);
//var
//  orderGroupArray : TRsOrderGroupArray;
//  orderView : TOrderGroupView;
//  i : integer;
//  Groups: TRsGroupArray;
//  Row0Col,Row1Col: integer;
begin
//  tabtopBoard.PopupMenu := PopupMenuTX;
//
//  tabtopBoard.ClearView;
//  tabtopBoard.VertScrollBar.Position := 0;
//
//  
//  tabtopBoard.SetLayoutType(ltGrid);
//
//
//
//  tabtopBoard.BeginUpdate;
//  try
//    m_RsLCNameBoardEx.Group.GroupTX.Get(TrainmanJiaoluGUID,Groups);
//
//
//    SetLength(orderGroupArray,Length(Groups));
//
//    tabtopBoard.RowCount := 2;
//    tabtopBoard.FixedCells[0,0] := '����1��';
//    tabtopBoard.FixedCells[1,0] := '����2��';
//
//
//    Row0Col := 0;
//    Row1Col := 0;
//
//    with TOrderGroupView.Create do
//    begin
//      tabtopBoard.RowHeight := Height;
//      Free;
//    end;
//
//    
//    for i := 0 to length(orderGroupArray) - 1 do
//    begin
//
//
//      orderView := TOrderGroupView.Create(nil);
//      orderGroupArray[i].Group := Groups[i];
//      orderGroupArray[i].nOrder := (i + 1);
//      orderGroupArray[i].strTrainmanJiaoluGUID :=  TrainmanJiaoluGUID;
//      orderView.OrderGroup := orderGroupArray[i];
//
//
//      if Groups[i].dtTXBeginTime > StartOfTheDay(Now)  then
//      begin
//        orderView.Row := 0;
//        orderView.Col := Row0Col;
//        Inc(Row0Col);
//      end
//      else
//      begin
//        orderView.Row := 1;
//        orderView.Col := Row1Col;
//        Inc(Row1Col);
//      end;
//      
//      tabtopBoard.AddView(orderView);
//    end;
//  finally
//    tabtopBoard.ReComposition;
//    tabtopBoard.EndUpdate;
//  end;
end;




procedure TfrmNameBoardManage.InitUnrunTrainman(TrainmanJiaoluGUID : string);
//var
//  trainmanArray : TRsTrainmanLeaveArray;
//  trainmanView : TTrainmanView;
//  strTempGUID : string;
//  i,rowCount,colCount,tmpCount : integer;
//  blnSelected: boolean;
begin
//  tabtopBoard.PopupMenu := nil ;
//
//  tabtopBoard.BeginUpdate;
//  tabtopBoard.ClearView;
//  tabtopBoard.RowCount := 0 ;
//  tabtopBoard.ColCount := 0 ;
//
//  tabtopBoard.SetLayoutType(ltGrid);
//  tabtopBoard.GridLineColor := $003B312D; //���ñ�����뱳��ɫһ�������ر����
//
//  try
//    //��ȡ��ǰ��Ա��·����ķ���ת��Ա��Ϣ
//    m_RsLCNameBoardEx.Trainman.GetUnRun(GlobalDM.WorkShop.ID,TrainmanJiaoluGUID,trainmanArray);
//    if length(trainmanArray) = 0 then
//      exit ;
//    strTempGUID := '';
//    rowCount := 0 ;
//    colCount := 0 ;
//    tmpCount := 0 ;
//    blnSelected := false;
//    for i := 0 to length(trainmanArray) - 1 do
//    begin
//      if i = 0 then
//      begin
//        strTempGUID := trainmanArray[i].strLeaveTypeGUID;
//        rowCount := 1;
//        tabtopBoard.RowCount := rowCount;
//        tabtopBoard.ColCount := 1;
//        tabtopBoard.FixedCells[rowCount-1,0] := trainmanArray[i].strLeaveTypeName;
//        if trainmanArray[i].strLeaveTypeName = '' then
//          tabtopBoard.FixedCells[rowCount-1,0] := '������';
//      end;
//      if strTempGUID <> trainmanArray[i].strLeaveTypeGUID then
//      begin
//        strTempGUID := trainmanArray[i].strLeaveTypeGUID;
//        rowCount := rowCount + 1;
//        tabtopBoard.RowCount := rowCount;
//        tabtopBoard.FixedCells[rowCount-1,0] := trainmanArray[i].strLeaveTypeName;
//        if trainmanArray[i].strLeaveTypeName = '' then
//          tabtopBoard.FixedCells[rowCount-1,0] := '������';
//        tmpCount := 0;
//      end;
//
//      tmpCount := tmpCount + 1;
//      if tmpCount > colCount then
//      begin
//        colCount := tmpCount;
//        tabtopBoard.ColCount := colCount; // + 1;
//      end;
//      trainmanView := TTrainmanView.Create(nil);
//      trainmanView.Trainman := trainmanArray[i].Trainman;
//      trainmanView.Row := rowCount - 1;
//      trainmanView.Col := tmpCount - 1;
//      tabtopBoard.AddView(trainmanView);
//
//      //ֱ�Ӱѹ������ƶ�������������Աλ�ã����Ҹ�����ǰ��VIEW
//      if  m_SelectUserInfo.strTrainmanGUID <> '' then
//      begin
//        if IsQueriedTrainman(trainmanArray[i].Trainman) then
//        begin
//          trainmanView.Selected := true;
//          if not blnSelected then
//          begin
//            tabtopBoard.VertScrollBar.Position := trainmanView.top + trainmanView.Height - tabtopBoard.Height;
//            tabtopBoard.ReCanvas;
//            blnSelected := true;
//          end;
//        end;
//      end;
//    end;
//  finally
//    tabtopBoard.ReComposition;
//    tabtopBoard.EndUpdate;
//  end;
end;

procedure TfrmNameBoardManage.ShowUnnormalOrderBoard(
  TrainmanJiaoluGUID: string);
var
  orderGroupArray : TRsOrderGroupArray;
  orderView : TOrderGroupView;
  i : integer;
  blnSelected: boolean;
begin
  m_ScrollView.Views.Clear;
    

  m_ScrollView.Views.BeginUpdate;
  blnSelected := false;
  try
    begin
      m_RsLCNameBoardEx.Order.Group.GetNullStationGrps(
        TrainmanJiaoluGUID,orderGroupArray);
      for i := 0 to length(orderGroupArray) - 1 do
      begin
        orderView := TOrderGroupView.Create();
        orderGroupArray[i].nOrder := (i + 1);
        orderView.OrderGroup := orderGroupArray[i];
        m_ScrollView.Views.AddView(orderView);
      end;
    end;
  finally
    m_ScrollView.Views.EndUpdate;
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

    namedView := TNamedGroupView.Create();
    namedView.NamedGroup := namedGroup;
    m_ScrollView.Views.AddView(namedView);
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
//  nTrainmanIndex := TNamedGroupView(view.Parent).Childs.IndexOf(view) + 1;
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
    InitNamedBoard(m_SelTmJL.strTrainmanJiaoluGUID);

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

//
//    orderView := TOrderGroupView.Create(nil);
//    orderView.OnTrainmanDragOver := OrderTrainmanDragDrop;
//    orderView.OnOrderGroupDragOver := OrderGroupDragDrop;
//    orderGroup.nOrder := tabtopBoard.GetViewCount+1;
//    orderView.OrderGroup := orderGroup;
//    orderView.Images := PngImageCollection;
//    tabtopBoard.AddView(orderView);
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
//  nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;
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


    InitOrderBoard(m_SelTmJL.strTrainmanJiaoluGUID);
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

//    tabtopBoard.BeginUpdate;
//    try
//      togetherView := TTogetherTrainView(view);
//      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
//      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
//      togetherView.TogetherTrain := TogetherTrain;
//      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
//      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
//      togetherView.Images := PngImageCollection;
//      tabtopBoard.ReComposition;
//    finally 
//      tabtopBoard.EndUpdate;
//    end;
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

//
//    tabtopBoard.BeginUpdate;
//    try
//      togetherView := TTogetherTrainView.Create(nil);
//      togetherView.TogetherTrain := togetherTrain;
//      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
//      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
//      togetherView.Images := PngImageCollection;
//      tabtopBoard.AddView(togetherView);
//      tabtopBoard.ReComposition;
//    finally 
//      tabtopBoard.EndUpdate;
//    end;
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
//  nTrainmanIndex := TOrderGroupInTrainView(view.Parent).Childs.IndexOf(view) + 1;
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

//    tabtopBoard.DeleteView(namedGroupView);
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
//    nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);

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
//    tabtopBoard.ReComposition;

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
    m_InputJL.SetTrainmanJL(m_SelTmJL);
    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupView.OrderGroup.Group.strGroupGUID,m_DutyUser);
//    tabtopBoard.DeleteView(orderGroupView);
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
//    nTrainmanIndex := TOrderGroupView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);
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


    m_InputJL.SetTrainmanJL(m_SelTmJL);
    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID,m_DutyUser);
//
//
//    tabtopBoard.BeginUpdate;
//    try
//      togetherView := TTogetherTrainView(view.Parent);
//      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
//      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
//      togetherView.TogetherTrain := TogetherTrain;
//      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
//      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
//      togetherView.Images := PngImageCollection;
//      tabtopBoard.ReComposition;
//
//
//
//    finally
//      tabtopBoard.EndUpdate;
//    end;
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
//
//  try
//    m_RsLCNameBoardEx.Together.DeleteTrain(togetherTrainView.TogetherTrain.strTrainGUID);
//    tabtopBoard.DeleteView(togetherTrainView);
//  except on e : exception do
//    begin
//      BoxErr('ɾ�����˻���ʧ�ܣ�' + e.Message);
//    end;
//  end;

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
//    nTrainmanIndex := TOrderGroupInTrainView(view.Parent).Childs.IndexOf(view) + 1;

    Input := TRsLCTrainmanAddInput.Create;
    try
      Input.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);
      Input.DutyUser.Assign(m_DutyUser);
      Input.TrainmanNumber := trainmanView.Trainman.strTrainmanNumber;
      Input.GroupGUID := TOrderGroupInTrainView(trainmanView.Parent).OrderGroupInTrain.Group.strGroupGUID;
      Input.TrainmanIndex := nTrainmanIndex;
      m_RsLCNameBoardEx.Group.DeleteTrainman(Input);
    finally
      Input.Free;
    end;
//
//
//    //ˢ�°��˻�����ʾ
//    orderGroupInTrain := TOrderGroupInTrainView(view.Parent).OrderGroupInTrain;
//    tabtopBoard.BeginUpdate;
//    try
//      togetherView := TTogetherTrainView(view.Parent.Parent);
//      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
//
//      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
//      togetherView.TogetherTrain := TogetherTrain;
//      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
//      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
//      togetherView.Images := PngImageCollection;
//      tabtopBoard.ReComposition;
//    finally
//      tabtopBoard.EndUpdate;
//    end;


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
//  nextOrderView := TOrderGroupView(GetNextView(destOrderView));
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
//  tabtopBoard.BeginUpdate;
//  try
//    tabtopBoard.InsertExistViewAfter(destOrderView, sourceView);
//    ReorderOrderViews;
//  finally
//    tabtopBoard.EndUpdate;
//    tabtopBoard.Repaint;
//  end;
  m_CutView := nil;
end;

procedure TfrmNameBoardManage.miOrderPasteBeforeClick(Sender: TObject);
//var
//  dtArriveTime : TDateTime;
//  sourceVIEW,destOrderView,preOrderView : TOrderGroupView;
//  orderGroup : RRsOrderGroup;
//  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
//  destOrderView := TOrderGroupView(m_SelectView);
//  sourceView := TOrderGroupView(m_CutView);
//  preOrderView := TOrderGroupView(GetPrevView(destOrderView));
//  //û��ǰһ��������ȡĿ�����ĵ���ʱ���ǰ10����
//  dtArriveTime :=  DateUtils.IncMinute(destOrderView.OrderGroup.dtLastArriveTime,-10);
//  //��ǰһ��������ȥ����������м��¼�
//  if preOrderView <> nil then
//  begin
//    dtArriveTime := preOrderView.OrderGroup.dtLastArriveTime +
//      (destOrderView.OrderGroup.dtLastArriveTime - preOrderView.OrderGroup.dtLastArriveTime) /2;
//  end;
//  if not GetSelectedTrainmaJiaolu(TrainmanJiaolu) then Exit;
//  m_InputJL.SetTrainmanJL(TrainmanJiaolu);
//
//  m_RsLCNameBoardEx.Group.UpdateArriveTime(
//    TOrderGroupView(m_CutView).OrderGroup.Group.strGroupGUID,
//    TOrderGroupView(m_CutView).OrderGroup.dtLastArriveTime,
//     dtArriveTime,
//     m_DutyUser,m_InputJL);
//
//
//  orderGroup := sourceVIEW.OrderGroup;
//  orderGroup.dtLastArriveTime := dtArriveTime;
//  sourceVIEW.OrderGroup := orderGroup;
//  tabtopBoard.BeginUpdate;
//  try
//    tabtopBoard.InsertExistViewBefore(destOrderView, sourceView);
//    ReorderOrderViews;
//  finally
//    tabtopBoard.EndUpdate;
//  end;
//  m_CutView := nil;
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
//var
//  view : TView;
//  namedGroupView : TNamedGroupView;
//  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
//  view := m_SelectView;
//  namedGroupView := TNamedGroupView(m_SelectView);
//  
//  if IsGroupBusy(namedGroupView.NamedGroup.Group.strGroupGUID) then exit;
//  
//  if not TBox('ȷ��ҪΪ�û��������') then exit;
//  namedGroupView := TNamedGroupView(view);
//  try
//    GetSelectedTrainmaJiaolu(TrainmanJiaolu);
//    m_InputJL.SetTrainmanJL(TrainmanJiaolu);
//
//    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,namedGroupView.NamedGroup.Group.strGroupGUID);
//
//    tabtopBoard.DeleteView(namedGroupView);
//    ReorderNamedViews;
//  except on e : exception do
//    begin
//      Box('�������ʧ�ܣ�' + e.Message);
//    end;
//  end;
end;

procedure TfrmNameBoardManage.miTX_OrderClick(Sender: TObject);
//var
//  view : TView;
//  orderGroupView : TOrderGroupView;
begin
//  view := m_SelectView;
//  orderGroupView := TOrderGroupView(view);
//  try
//    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
//    if not TBox('ȷ��ҪΪ�û��������') then exit;
//    m_InputJL.SetTrainmanJL(m_SelTmJL);
//    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,orderGroupView.OrderGroup.Group.strGroupGUID);
//    tabtopBoard.DeleteView(orderGroupView);
//    ReorderOrderViews;
//  except on e : exception do
//    begin
//      Box('�������ʧ�ܣ�' + e.Message);
//    end;
//  end;

end;

procedure TfrmNameBoardManage.miTX_TogetherClick(Sender: TObject);
//var
//  view : TView;
//  orderGroupInTrainView : TOrderGroupInTrainView;
//  strTrainGUID: string;
//  TogetherTrain: RRsTogetherTrain;
//  togetherView: TTogetherTrainView;
begin
//  view := m_SelectView;
//
//  orderGroupInTrainView := TOrderGroupInTrainView(view);
//  try
//    if IsGroupBusy(orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID) then exit;
//    if not TBox('ȷ��ҪΪ�û��������') then exit;
//
//
//    m_InputJL.SetTrainmanJL(m_SelTmJL);
//    m_RsLCNameBoardEx.Group.GroupTX.Add(m_InputJL,m_DutyUser,orderGroupInTrainView.OrderGroupInTrain.Group.strGroupGUID);
//
//    tabtopBoard.BeginUpdate;
//    try
//      togetherView := TTogetherTrainView(view.Parent);
//      strTrainGUID := togetherView.TogetherTrain.strTrainGUID;
//      m_RsLCNameBoardEx.Together.GetTrain(strTrainGUID, TogetherTrain);
//      togetherView.TogetherTrain := TogetherTrain;
//      togetherView.OnTrainmanDragOver := TogetherTrainmanDragDrop;
//      togetherView.OnOrderGroupInTrainDragOver := TogetherGroupDragDrop;
//      togetherView.Images := PngImageCollection;
//      tabtopBoard.ReComposition;
//    finally
//      tabtopBoard.EndUpdate;
//    end;
//  except on e : exception do
//    begin
//      BoxErr('�������ʧ�ܣ�' + e.Message);
//    end;
//  end;

end;
procedure TfrmNameBoardManage.miUpdateTrainClick(Sender: TObject);
//var
//  togetherTrain : TTogetherTrainView;
//  togetherGroup : RRsTogetherTrain;
//  strTrainTypeName,strTrainNumber : string;
begin
//  if m_SelectView.ClassName <> TTogetherTrainView.ClassName then
//    Exit;
//  togetherTrain := TTogetherTrainView(m_SelectView);
//  if togetherTrain = nil then exit;
//  togetherGroup := togetherTrain.TogetherTrain;
//  strTrainTypeName := togetherGroup.strTrainTypeName;
//  strTrainNumber := togetherGroup.strTrainNumber;
//  if not TFrmAddJiChe.InputTrainInfo(strTrainTypeName,strTrainNumber) then exit;
//  togetherGroup.strTrainTypeName := strTrainTypeName;
//  togetherGroup.strTrainNumber := strTrainNumber;
//
//  m_RsLCNameBoardEx.Together.UpdateTrain(togetherGroup.strTrainGUID,
//  togetherGroup.strTrainTypeName,togetherGroup.strTrainNumber);
//
//  togetherTrain.TogetherTrain := togetherGroup;
//  tabtopBoard.Repaint;
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
//var
//  view : TView;
//  orderGroupView : TOrderGroupView;
//  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
//  view :=  m_SelectView;;
//  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
//  begin
//    Box('����ָ��Ҫɾ���Ļ�����Ϣ');
//    exit;
//  end;
//
//  orderGroupView := TOrderGroupView(view);
//  try
//    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
//    if not TBox('��ȷ��Ҫɾ���˻�����') then exit;
//    GetSelectedTrainmaJiaolu(TrainmanJiaolu);
//    m_InputJL.jiaoluID := TrainmanJiaolu.strTrainmanJiaoluGUID;
//    m_InputJL.jiaoluName := TrainmanJiaolu.strTrainmanJiaoluName;
//    m_InputJL.jiaoluType := Ord(TrainmanJiaolu.nJiaoluType);
//    
//    m_RsLCNameBoardEx.Group.Delete(m_InputJL,orderGroupView.OrderGroup.Group.strGroupGUID,m_DutyUser);;
//
//    tabtopBoard.DeleteView(orderGroupView);
//    ReorderOrderViews;
//  except on e : exception do
//    begin
//      Box('ɾ������ʧ�ܣ�' + e.Message);
//    end;
//  end;
end;

procedure TfrmNameBoardManage.mniUnnormalOrderMoveClick(Sender: TObject);
//var
//  view : TView;
//  orderGroupView : TOrderGroupView;
//
//  trainJiaoluGUID : string;
//  StationArray: TRsStationArray;
//  strStationGUID:string;
//  ErrorInfo: string;
//  placeList : TRsDutyPlaceList;
//  i: Integer;
begin

//  view :=  m_SelectView;;
//  if (view = nil) or (view.ClassName <> TOrderGroupView.ClassName) then
//  begin
//    Box('����ָ���Ļ�����Ϣ');
//    exit;
//  end;
//  orderGroupView := TOrderGroupView(view);
//
//
//  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
//  begin
//    Box('��ѡ��·��Ϣ');
//    exit;
//  end;
//
//  //��ȡ���еĳ�վ
//  if not m_LCStation.GetStationsOfJiaoJu(trainJiaoluGUID,StationArray,ErrorInfo) then
//  begin
//    Box(ErrorInfo);
//    Exit;
//  end;
//  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(trainjiaoluGUID,placeList,ErrorInfo) then
//  begin
//    box(ErrorInfo);
//    exit;
//  end;
//  SetLength(StationArray,length(placeList));
//  for i := 0 to length(placeList) - 1 do
//  begin
//    StationArray[i].strStationGUID := placeList[i].placeID;
//    StationArray[i].strStationName := placeList[i].placeName;
//    StationArray[i].strStationNumber := placeList[i].placeID;
//  end;
//  if not TFrmNameBorardSelectStation.GetSelStation(StationArray,strStationGUID) then
//    Exit;
//  if strStationGUID <> '' then
//  begin
//    if not m_webNameBoard.ChangeGroupPlace(orderGroupView.OrderGroup.Group.strGroupGUID,
//    orderGroupView.OrderGroup.Group.place.placeID,
//    strStationGUID,ErrorInfo) then
//    begin
//      Box(ErrorInfo);
//      Exit;
//    end;
//
//    tabtopBoard.DeleteView(orderGroupView);
//    ReorderOrderViews;
//    Box('�ƶ��ɹ�');
//
//  end;
end;

procedure TfrmNameBoardManage.miTX_EndClick(Sender: TObject);
//var
//  view : TView;
//  orderGroupView : TOrderGroupView;
begin
//  view := m_SelectView;
//  orderGroupView := TOrderGroupView(view);
//  try
//    if IsGroupBusy(orderGroupView.OrderGroup.Group.strGroupGUID) then exit;
//    if not TBox('ȷ��Ҫ�����û��������') then exit;
//    m_InputJL.SetTrainmanJL(m_SelTmJL);
//    m_RsLCNameBoardEx.Group.GroupTX.Del(m_InputJL,m_DutyUser,orderGroupView.OrderGroup.Group.strGroupGUID);
//    tabtopBoard.DeleteView(orderGroupView);
//    ReorderOrderViews;
//  except on e : exception do
//    begin
//      Box('����ʧ�ܣ�' + e.Message);
//    end;
//  end;

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

    InitOrderBoard(m_SelTmJL.strTrainmanJiaoluGUID);
  except on e : exception do
    begin
      Box('�޸Ļ�����ڵ�ʧ�ܣ�' + e.Message);
    end;
  end;
end;

procedure TfrmNameBoardManage.miInsertOrderGroupClick(Sender: TObject);
//var
//  dtArriveTime : TDateTime;
//  selOrderView,preOrderView : TOrderGroupView;
//  orderGroup : RRsOrderGroup;
//  trainmanJiaolu : RRsTrainmanJiaolu;
//  zfqj : RRsZheFanQuJian;
//  station : RRsStation;
//  strGroupGUID: string;
//  dutyPlace:RRsDutyPlace;
//  InputParam: TRsLCOrderGrpInputParam;
begin
//  if not GetSelectedTrainmaJiaolu(trainmanJiaolu) then exit;
//  if not GetSelectedDutyPlace(dutyPlace) then
//  begin
//    BoxErr('��ѡ����ڵ�!');
//    Exit;
//  end;
//  orderGroup.Group.place := dutyPlace ;
//
//
//  if not TFrmAddGroup.InputGroup(
//    '',
//    orderGroup.Group.Trainman1,
//    orderGroup.Group.Trainman2,orderGroup.Group.Trainman3,orderGroup.Group.Trainman4) then exit;
//  try
//    //����������Ա�Ƿ��ܱ����
//    if not CheckAddGroup(orderGroup.Group) then exit;
//
//        //���������Ա�Ƿ��Ѿ�������������
//    if not CheckGroupIsOwner(orderGroup.Group,jltOrder) then Exit ;
//
//
//    orderGroup.strOrderGUID := NewGUID;
//    orderGroup.nOrder := 0;
//    orderGroup.strTrainmanJiaoluGUID := trainmanJiaolu.strTrainmanJiaoluGUID;
//
//    orderGroup.Group.strGroupGUID := NewGUID;
//    if trainmanJiaolu.nTrainmanRunType = trtZFQJ then
//    begin
//      orderGroup.Group.ZFQJ.strZFQJGUID := zfqj.strZFQJGUID;
//    end
//    else
//    begin
//      orderGroup.Group.Station.strStationGUID := station.strStationGUID;
//    end;
//
//    InputParam := TRsLCOrderGrpInputParam.Create;
//
//    try
//      InputParam.TrainmanJiaolu.SetTrainmanJL(trainmanJiaolu);
//      InputParam.DutyUser.strDutyGUID := m_DutyUser.strDutyGUID;
//      InputParam.DutyUser.strDutyNumber := m_DutyUser.strDutyNumber;
//      InputParam.DutyUser.strDutyName := m_DutyUser.strDutyName;
//      InputParam.OrderGUID := orderGroup.strOrderGUID;
//      InputParam.LastArriveTime := orderGroup.dtLastArriveTime;
//      InputParam.PlaceID := orderGroup.Group.place.placeID;
//      InputParam.TrainmanNumber1 := orderGroup.Group.Trainman1.strTrainmanNumber;
//      InputParam.TrainmanNumber2 := orderGroup.Group.Trainman2.strTrainmanNumber;
//      InputParam.TrainmanNumber3 := orderGroup.Group.Trainman3.strTrainmanNumber;
//      InputParam.TrainmanNumber4 := orderGroup.Group.Trainman4.strTrainmanNumber;
//
//      m_RsLCNameBoardEx.Order.Group.Add(InputParam);;
//    finally
//      InputParam.Free;
//    end;
//
//
//    strGroupGUID := orderGroup.Group.strGroupGUID;
//
//
//    m_RsLCNameBoardEx.Order.Group.GetOrderGroup(strGroupGUID, OrderGroup);
//
//
//
//
//    selOrderView := TOrderGroupView(m_SelectView);
//    preOrderView := TOrderGroupView(GetPrevView(selOrderView));
//    //û��ǰһ��������ȡĿ�����ĵ���ʱ���ǰ60����
//    dtArriveTime :=  DateUtils.IncMinute(selOrderView.OrderGroup.dtLastArriveTime,-60);
//    //��ǰһ��������ȥ����������м��¼�
//    if preOrderView <> nil then
//    begin
//      dtArriveTime := preOrderView.OrderGroup.dtLastArriveTime +
//        (selOrderView.OrderGroup.dtLastArriveTime - preOrderView.OrderGroup.dtLastArriveTime) /2;
//    end ;
//
//    m_InputJL.SetTrainmanJL(trainmanJiaolu);
//    m_RsLCNameBoardEx.Group.UpdateArriveTime(OrderGroup.strOrderGUID,
//    OrderGroup.dtLastArriveTime,dtArriveTime,m_DutyUser,m_InputJL);
//  finally
//
//  end;
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

procedure TfrmNameBoardManage.OnDragViewOver(src, dest: TView;
  var Accept: Boolean);
begin
  Accept := src.ClassType = dest.ClassType;
  if (dest is TTogetherTrainView) and not Accept then
    Accept := src is TOrderGroupInTrainView;
end;

procedure TfrmNameBoardManage.OnDropMode(src, dest: TView; X, Y: integer;
  var Mode: TDropMode);
var
  pt: TPoint;
begin
  if src is TTrainmanView then
    Mode := dmExchange;

  GetCursorPos(pt);
  if (src is TOrderGroupView) and (not (dest is TTogetherTrainView)) then
  begin
    Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
  end;

  if src is TNamedGroupView then
  begin
    Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
  end;
  
  if dest is TTogetherTrainView then
  begin
    if src is TTogetherTrainView then
    begin
      Mode := m_ScrollView.DropModePopMenu.Popup(pt.X,pt.Y);
    end
    else
    begin
      Mode := dmInsertChild;
    end;
  end;
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
    frmNameBoardManage.InitJiaolu;
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
//var
//  tmpTrainman,sourceTrainman : RRsTrainman;
//  sourceGroup,destGroup:RRsGroup;
//  destIndex : integer;
//  sourceParentGUID,destParentGUID : string;
//  AddInput: TRsLCTrainmanAddInput;
begin
//  if not m_bEditEnabled then exit;
//
//  //��Ա�Ƿ��Ѿ����żƻ�
//  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
//  begin
//    exit;
//  end;
//  //�����Ƿ��Ѿ����żƻ�
//  if IsGroupBusy(TOrderGroupView(TrainmanView.Parent).OrderGroup.Group.strGroupGUID) or
//      IsGroupBusy(TOrderGroupView(Sender.Parent).OrderGroup.Group.strGroupGUID) then
//  begin
//    exit;
//  end;
//
//  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
//  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;
//
//  sourceTrainman := TrainmanView.Trainman;
//  sourceGroup := TOrderGroupView(TrainmanView.Parent).OrderGroup.Group;
//  sourceParentGUID := TOrderGroupView(TrainmanView.Parent).OrderGroup.strOrderGUID;
//
//  destGroup := TOrderGroupView(Sender.Parent).OrderGroup.Group;
//  destParentGUID := TOrderGroupView(Sender.Parent).OrderGroup.strOrderGUID;
//  destIndex := TOrderGroupView(Sender.Parent).Childs.IndexOf(Sender) + 1;
//
//  if (TrainmanView.Trainman.strTrainmanGUID = '') then
//  begin
//    sourceTrainman := Sender.Trainman;
//
//    destGroup := TOrderGroupView(TrainmanView.Parent).OrderGroup.Group;
//    destParentGUID := TOrderGroupView(TrainmanView.Parent).OrderGroup.strOrderGUID;
//    destIndex := TOrderGroupView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;
//
//    sourceGroup := TOrderGroupView(Sender.Parent).OrderGroup.Group;
//    sourceParentGUID := TOrderGroupView(Sender.Parent).OrderGroup.strOrderGUID;
//  end;
//
//  
//  try
//    AddInput := TRsLCTrainmanAddInput.Create;
//    try
//      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);
//      AddInput.DutyUser.Assign(m_DutyUser);
//      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
//      AddInput.TrainmanIndex := destIndex;
//      AddInput.GroupGUID := destGroup.strGroupGUID;
//
//      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);
//
//      
//    finally
//      AddInput.Free;
//    end;
//
//    //������Ա����ͼ
//    tmpTrainman := sender.Trainman;
//    Sender.Trainman := TrainmanView.Trainman;
//    TrainmanView.Trainman := tmpTrainman;
//    
//  except on E: Exception do
//    begin
//      Boxerr('������Աʧ�ܣ�' + e.Message);
//    end;
//  end;
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

  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin
    TOrderGroupView(m_ScrollView.Views[I]).SetOrderGroupOrder(i+1);
  end;
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
  m_ScrollView.Views.Clear;


  if not m_webNameBoard.GetNamedGroup(TrainmanJiaoluGUID,namedGroupArray,strError) then
  begin
    BoxErr(strError);
  end;

  blnSelected := false;
  m_ScrollView.Views.BeginUpdate;
  try
    for i := 0 to length(namedGroupArray) - 1 do
    begin
      namedView := TNamedGroupView.Create();

      namedGroupArray[i].nOrgCheciOrder := namedGroupArray[i].nCheciOrder ;
      namedGroupArray[i].nCheciOrder := i + 1;
      namedView.NamedGroup := namedGroupArray[i];
      m_ScrollView.Views.AddView(namedView);
    end;
  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.InitOrderBoard(TrainmanJiaoluGUID: string);
var
  orderGroupArray : TRsOrderGroupArray;
  orderView : TOrderGroupView;
  i : integer;
  placeDuty:RRsDutyPlace;
  strError:string;
begin
  placeDuty := m_listDutyPlace[0];


  m_ScrollView.Views.Clear;

  if not m_webNameBoard.GetOrderGroup(TrainmanJiaoluGUID,placeDuty.placeID,'',orderGroupArray,strError)  then
  begin
    BoxErr(strError);
    Exit;
  end;
  for i := 0 to length(orderGroupArray) - 1 do
  begin

    orderView := TOrderGroupView.Create();
    orderGroupArray[i].nOrder := (i + 1);
    orderView.OrderGroup := orderGroupArray[i];
    m_ScrollView.Views.AddView(orderView);
  end;
end;

procedure TfrmNameBoardManage.InitTogetherBoard(TrainmanJiaoluGUID: string);
var
  togetherGroupArray : TRsTogetherTrainArray;
  togetherView : TTogetherTrainView;
  orderGroupInTrainView: TOrderGroupInTrainView;
  i, j : integer;
  strError:string;
begin
  m_ScrollView.Views.Clear;

  if not m_webNameBoard.GetTogetherGroup(TrainmanJiaoluGUID,togetherGroupArray,strError) then
  begin
    BoxErr(strError);
  end;


  m_ScrollView.Views.BeginUpdate;
  try
    for i := 0 to length(togetherGroupArray) - 1 do
    begin
      togetherView := TTogetherTrainView.Create();
      togetherView.TogetherTrain := togetherGroupArray[i];
      m_ScrollView.Views.AddView(togetherView);
    end;
  finally
    m_ScrollView.Views.EndUpdate;
  end;
end;

procedure TfrmNameBoardManage.ReorderNamedViews;
var
  i : integer;
begin
  for i := 0 to m_ScrollView.Views.Count - 1 do
  begin
    TNamedGroupView(m_ScrollView.Views[I]).SetNamedGroupOrder(i+1);
  end;
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
//  nIndex := tabZFQD.TabIndex  ;
//  strType := tabZFQD.Tabs[nIndex].Caption ;

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
      InitNamedBoard(m_SelTmJL.strTrainmanJiaoluGUID);
    end;
    jltOrder : begin
      InitOrderBoard(m_SelTmJL.strTrainmanJiaoluGUID);
    end;
    jltTogether : begin
     InitTogetherBoard(m_SelTmJL.strTrainmanJiaoluGUID);
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
//var
//  tmpTrainman,sourceTrainman : RRsTrainman;
//  sourceGroup,destGroup:RRsGroup;
//  destIndex : integer;
//  sourceParentGUID,destParentGUID : string;
//  AddInput: TRsLCTrainmanAddInput;
begin
//  if not m_bEditEnabled then exit;
//
//  //��Ա�Ƿ��Ѿ����żƻ�
//  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
//  begin
//    exit;
//  end;
//  //�����Ƿ��Ѿ����żƻ�
//  if IsGroupBusy(TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group.strGroupGUID) or
//      IsGroupBusy(TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group.strGroupGUID) then
//  begin
//    exit;
//  end;
//
//  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
//  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;
//
//  sourceTrainman := TrainmanView.Trainman;
//  sourceGroup := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group;
//  sourceParentGUID := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.strOrderGUID;
//
//  destGroup := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group;
//  destParentGUID := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.strOrderGUID;
//  destIndex := TOrderGroupInTrainView(Sender.Parent).Childs.IndexOf(Sender) + 1;
//  
//  if (TrainmanView.Trainman.strTrainmanGUID = '') then
//  begin
//    sourceTrainman := Sender.Trainman;
//    
//    destGroup := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.Group;
//    destParentGUID := TOrderGroupInTrainView(TrainmanView.Parent).OrderGroupInTrain.strOrderGUID;
//    destIndex := TOrderGroupInTrainView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;
//
//    sourceGroup := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.Group;
//    sourceParentGUID := TOrderGroupInTrainView(Sender.Parent).OrderGroupInTrain.strOrderGUID;
//  end;
//
//  
//  try
//    AddInput := TRsLCTrainmanAddInput.Create;
//    try
//      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);
//      AddInput.DutyUser.Assign(m_DutyUser);
//      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
//      AddInput.TrainmanIndex := destIndex;
//      AddInput.GroupGUID := destGroup.strGroupGUID;
//
//      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);
//
//      
//    finally
//      AddInput.Free;
//    end;
//   
//    
//    //������Ա����ͼ
//    tmpTrainman := sender.Trainman;
//    Sender.Trainman := TrainmanView.Trainman;
//    TrainmanView.Trainman := tmpTrainman;
//  except on E: Exception do
//    begin
//      Boxerr('������Աʧ�ܣ�' + e.Message);
//    end;
//  end;

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
//  if not m_bEditEnabled then exit;
//
//  //��Ա�Ƿ��Ѿ����żƻ�
//  if IsTrainmanBusy(sender.Trainman.strTrainmanGUID) or IsTrainmanBusy(TrainmanView.Trainman.strTrainmanGUID) then
//  begin
//    exit;
//  end;
//  //�����Ƿ��Ѿ����żƻ�
//  if IsGroupBusy(TNamedGroupView(TrainmanView.Parent).NamedGroup.Group.strGroupGUID) or
//      IsGroupBusy(TNamedGroupView(Sender.Parent).NamedGroup.Group.strGroupGUID) then
//  begin
//    exit;
//  end;
//
//  //Դ��Ա��Ŀ����Ա��Ϊ�����Ƴ�
//  if (TrainmanView.Trainman.strTrainmanGUID = '') and (sender.Trainman.strTrainmanGUID = '') then exit;
//
//  sourceTrainman := TrainmanView.Trainman;
//  sourceGroup := TNamedGroupView(TrainmanView.Parent).NamedGroup.Group;
//  sourceParentGUID := TNamedGroupView(TrainmanView.Parent).NamedGroup.strCheciGUID;
//
//  destGroup := TNamedGroupView(Sender.Parent).NamedGroup.Group;
//  destParentGUID := TNamedGroupView(Sender.Parent).NamedGroup.strCheciGUID;
//  destIndex := TNamedGroupView(Sender.Parent).Childs.IndexOf(Sender) + 1;
//  
//  if (TrainmanView.Trainman.strTrainmanGUID = '') then
//  begin
//    sourceTrainman := Sender.Trainman;
//    
//    destGroup := TNamedGroupView(TrainmanView.Parent).NamedGroup.Group;
//    destParentGUID := TNamedGroupView(TrainmanView.Parent).NamedGroup.strCheciGUID;
//    destIndex := TNamedGroupView(TrainmanView.Parent).Childs.IndexOf(TrainmanView) + 1;
//
//    sourceGroup := TNamedGroupView(Sender.Parent).NamedGroup.Group;
//    sourceParentGUID := TNamedGroupView(Sender.Parent).NamedGroup.strCheciGUID;
//  end;
//
//  
//  try
//    AddInput := TRsLCTrainmanAddInput.Create;
//    try
//      AddInput.TrainmanJiaolu.SetTrainmanJL(m_SelTmJL);
//      AddInput.DutyUser.Assign(m_DutyUser);
//      AddInput.TrainmanNumber := sourceTrainman.strTrainmanNumber;
//      AddInput.TrainmanIndex := destIndex;
//      AddInput.GroupGUID := destGroup.strGroupGUID;
//
//      m_RsLCNameBoardEx.Group.AddTrainman(AddInput);
//
//      
//    finally
//      AddInput.Free;
//    end;
//
//    
//   
//    //������Ա����ͼ
//    tmpTrainman := sender.Trainman;
//    Sender.Trainman := TrainmanView.Trainman;
//    TrainmanView.Trainman := tmpTrainman;
//  except on E: Exception do
//    begin
//      Boxerr('������Աʧ�ܣ�' + e.Message);
//    end;
//  end;
end;


procedure TfrmNameBoardManage.treeJiaoluChange(Sender: TObject;
  Node: TTreeNode);
begin  
//  InitJiaoluTab;
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
  InitOrderBoard(m_SelTmJL.strTrainmanJiaoluGUID);
end;

procedure TfrmNameBoardManage.WMMessageRepaint(var Msg: TMessage);
begin
  
end;



{ TTrainJlPlace }

procedure TTrainJlPlace.Add(TrainJl, PlaceID, PlaceName: string);
begin

end;

procedure TTrainJlPlace.GetPlaceLst(TrainJl: string;
  PlaceCollection: TPlaceCollection);
begin

end;

initialization
  _TmJLLst := TTmJlLst.Create;

finalization
  FreeAndNil(_TmJLLst);


end.

