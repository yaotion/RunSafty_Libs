unit ufrmGoodsQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzTabs, Grids, DBGrids, RzDBGrid, RzStatus,
  RzPanel, DB, ADODB, Buttons, PngSpeedButton, Menus,uLendingDefine,
  ComCtrls, RzListVw,uTFSystem, RzEdit, RzLstBox, RzBckgnd,
  PngCustomButton, ActnList,uLCGoodsMgr;
const
  MinutesPerDay = 1440;
type
  TfrmGoodsQuery = class(TForm)
    RzStatusBar1: TRzStatusBar;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    Panel1: TPanel;
    TabSheet2: TRzTabSheet;
    lstViewNoReturn: TRzListView;
    lstViewAllRecord: TRzListView;
    Splitter1: TSplitter;
    lstViewTongJi: TRzListView;
    btnQuery: TPngSpeedButton;
    edtBianHao: TEdit;
    Label5: TLabel;
    radioOrderNumber: TRadioButton;
    PngCustomButton1: TPngCustomButton;
    radioOrderTime: TRadioButton;
    Label1: TLabel;
    btnViewDetail: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure PngSpeedButton2Click(Sender: TObject);
    procedure edtBianHaoKeyPress(Sender: TObject; var Key: Char);
    procedure lstViewAllRecordCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstViewNoReturnCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstViewNoReturnDblClick(Sender: TObject);
    procedure lstViewTongJiClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure radioOrderTimeClick(Sender: TObject);
    procedure btnViewDetailClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    m_LendingTypeList: TRsLendingTypeList;
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
    m_NoReturnDetailList: TRsLendingDetailList;
    m_HistoryDetailList: TRsLendingDetailList;
    m_lendingToJiList: TRslendingToJiList;
    //查询物品当前状态列表
    procedure QueryGoodsList(DetailsQueryCondition: TRsDetailsQueryCondition);
    //查询物品借出详细信息
    procedure QueryGoodsDetail(DetailsQueryCondition: TRsDetailsQueryCondition);
    //刷新物品当前状态列表
    procedure RefreshGoodsList();
    //刷新物品借出详细信息
    procedure RefreshGoodsDetail();
    //查询统计稀泥
    procedure QueryTongJi();
    function MinutesToTimeString(nMinutes: Integer): string;
  public
    { Public declarations }
  end;


implementation
uses
  uGlobal, RsGlobal_TLB;
{$R *.dfm}

procedure TfrmGoodsQuery.btnViewDetailClick(Sender: TObject);
begin
  lstViewNoReturnDblClick(lstViewNoReturn);
end;

procedure TfrmGoodsQuery.edtBianHaoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#8]) then
    Key := #0
  else begin
    if Key=#13 then
      btnQuery.Click;
  end;
end;

procedure TfrmGoodsQuery.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if RzPageControl1.ActivePageIndex = 1 then
  begin
    CanClose := False;
    RzPageControl1.ActivePageIndex := 0;
  end;
  
end;

procedure TfrmGoodsQuery.FormCreate(Sender: TObject);
begin
  m_LendingTypeList := TRsLendingTypeList.Create;
  m_HistoryDetailList := TRsLendingDetailList.Create;
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(g_WebAPIUtils);
  m_NoReturnDetailList := TRsLendingDetailList.Create;
  m_lendingToJiList := TRslendingToJiList.Create;
  m_RsLCGoodsMgr.GetGoodType(m_LendingTypeList);
  RzPageControl1.ActivePageIndex := 0;
  QueryTongJi();
end;

procedure TfrmGoodsQuery.FormDestroy(Sender: TObject);
begin
  m_LendingTypeList.Free;
  m_HistoryDetailList.Free;
  m_NoReturnDetailList.Free;
  m_lendingToJiList.Free;
  m_RsLCGoodsMgr.Free;
end;
procedure TfrmGoodsQuery.lstViewAllRecordCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := clBlack;
  if SubItem = 7 then
  begin
    if  TRsLendingDetail(Item.Data).nReturnState = 0  then
      Sender.Canvas.Font.Color := clRed;
  end;
end;

procedure TfrmGoodsQuery.lstViewNoReturnCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := clBlack;
  if SubItem = 7 then
  begin
    if  TRsLendingDetail(Item.Data).nReturnState = 0  then
      Sender.Canvas.Font.Color := clRed;
  end;
  if SubItem = 4 then
  begin
    if  TRsLendingDetail(Item.Data).nKeepMunites >  MinutesPerDay*2 then
      Sender.Canvas.Font.Color := clRed;
  end;
end;

procedure TfrmGoodsQuery.lstViewNoReturnDblClick(Sender: TObject);
var
  DetailsQueryCondition: TRsDetailsQueryCondition;
begin
  if TRzListView(Sender).Selected = nil then
    Exit;

  DetailsQueryCondition := TRsDetailsQueryCondition.Create;
  try
    DetailsQueryCondition.nLendingType :=
      TRsLendingDetail(TRzListView(Sender).Selected.Data).nLendingType;

    DetailsQueryCondition.nBianHao :=
      TRsLendingDetail(TRzListView(Sender).Selected.Data).strLendingExInfo;

    DetailsQueryCondition.nReturnState := -1;

    DetailsQueryCondition.WorkShopGUID := GlobalDM.WorkShop.ID;
    DetailsQueryCondition.strOrderField := '';

    QueryGoodsDetail(DetailsQueryCondition);
    RzPageControl1.ActivePageIndex := 1;
  finally
    DetailsQueryCondition.Free;
  end;

end;

procedure TfrmGoodsQuery.lstViewTongJiClick(Sender: TObject);
begin
  btnQuery.Click;
end;

function TfrmGoodsQuery.MinutesToTimeString(nMinutes: Integer): string;
var
  nDay,nHour: Integer;
  nTemp: Integer;
begin
  nDay :=  nMinutes div MinutesPerDay;
  nTemp := nMinutes mod MinutesPerDay;
  nHour := nTemp div 60;
  Result := Format('%.2d天%.2d时',[nDay,nHour])

end;




procedure TfrmGoodsQuery.btnDeleteClick(Sender: TObject);
var
  nLendingType : integer;
  strLendingExInfo : string;
  i : Integer ;
begin
  if not (TBox('您确定要删除选择的物品的库存吗？')) then exit;
  try
    for I := 0 to lstViewNoReturn.Items.Count - 1 do
    begin
      if lstViewNoReturn.Items.Item[i].Checked then
      begin
        nLendingType :=   TRsLendingDetail(lstViewNoReturn.Items.Item[i].Data).nLendingType;
        strLendingExInfo := IntToStr(TRsLendingDetail(lstViewNoReturn.Items.Item[i].Data).strLendingExInfo);

        m_RsLCGoodsMgr.DeleteGoods(nLendingType,strLendingExInfo,GlobalDM.WorkShop.ID);
      end;
    end;
    btnQuery.Click;
  except on e : exception do
    Box('删除失败:' + e.Message);
  end;
end;




procedure TfrmGoodsQuery.btnQueryClick(Sender: TObject);
var
  Condition: TRsDetailsQueryCondition;
begin

  //QueryTongJi;

  Condition := TRsDetailsQueryCondition.Create;
  try
    Condition.nLendingType := -1;
    if (lstViewTongJi.Selected <> nil) then
    begin
      if lstViewTongJi.Selected.Index > 0 then
      begin
        Condition.nLendingType :=
          TRsLendingTongJi(lstViewTongJi.Selected.Data).nLendingType;
      end;
    end;
    Condition.nReturnState := -1;

    if edtBianHao.Text <> '' then
      Condition.nBianHao := StrToInt(edtBianHao.Text)
    else
      Condition.nBianHao := -1;
    QueryGoodsList(Condition);
  finally
    Condition.Free;
  end;

end;

procedure TfrmGoodsQuery.PngSpeedButton2Click(Sender: TObject);
var
  Condition: TRsDetailsQueryCondition;
begin
  Condition := TRsDetailsQueryCondition.Create;
  try
    Condition.WorkShopGUID := GlobalDM.WorkShop.ID;
    Condition.strOrderField := '';
    m_RsLCGoodsMgr.QueryDetails(Condition,m_HistoryDetailList);
    RefreshGoodsDetail();
  finally
    Condition.Free;
  end;

end;


procedure TfrmGoodsQuery.QueryTongJi;
var
  i: Integer;
  Item: TListItem;
begin
  m_RsLCGoodsMgr.GetTongJiInfo(m_lendingToJiList,GlobalDM.WorkShop.ID);

  lstViewTongJi.Items.Clear;
  item :=  lstViewTongJi.Items.Add;
  item.Caption := '全部类型';
  for I := 0 to m_lendingToJiList.Count - 1 do
  begin
    Item := lstViewTongJi.Items.Add;
    Item.Data := m_lendingToJiList[i];
    Item.Caption := m_lendingToJiList[i].strLendingTypeName;
    Item.SubItems.Add(IntToStr(m_lendingToJiList[i].nTotalCount));
    Item.SubItems.Add(IntToStr(m_lendingToJiList[i].nNoReturnCount) )
  end;

end;

procedure TfrmGoodsQuery.QueryGoodsDetail(
  DetailsQueryCondition: TRsDetailsQueryCondition);
begin
  m_RsLCGoodsMgr.QueryDetails(DetailsQueryCondition,m_HistoryDetailList);

  RefreshGoodsDetail();
end;

procedure TfrmGoodsQuery.QueryGoodsList(
  DetailsQueryCondition: TRsDetailsQueryCondition);
var
  orderType : TGoodsOrderType;
begin
  orderType := gotNumber;
  if radioOrderNumber.Checked then
    orderType := gotNumber;
  if radioOrderTime.Checked then
    orderType := gotBorrowTime;
  m_RsLCGoodsMgr.QueryGoodsNow(GlobalDM.WorkShop.ID,
    DetailsQueryCondition.nLendingType,
    DetailsQueryCondition.nBianHao,
    orderType,
    m_NoReturnDetailList);

  RefreshGoodsList();
end;


procedure TfrmGoodsQuery.radioOrderTimeClick(Sender: TObject);
begin
  btnQuery.Click;
end;

procedure TfrmGoodsQuery.RefreshGoodsDetail;
var
  I: Integer;
  Item: TListItem;
begin
  lstViewAllRecord.Items.BeginUpdate;
  try
    lstViewAllRecord.Items.Clear;
    for I := 0 to m_HistoryDetailList.Count - 1 do
    begin
      Item := lstViewAllRecord.Items.Add;
      Item.Data := m_HistoryDetailList[i];
      Item.Caption := IntToStr(i + 1);

      Item.SubItems.Add(m_HistoryDetailList.Items[i].strLendingTypeName);

      Item.SubItems.Add(m_HistoryDetailList.Items[i].strTrainmanName);

      Item.SubItems.Add(
        FormatDateTime('yy-mm-dd hh:nn',
        m_HistoryDetailList.Items[i].dtBorrwoTime));

      if m_HistoryDetailList.Items[i].dtGiveBackTime > 1 then
        Item.SubItems.Add(FormatDateTime('yy-mm-dd hh:nn',
        m_HistoryDetailList.Items[i].dtGiveBackTime))
      else
        Item.SubItems.Add('');
        
      Item.SubItems.Add(m_HistoryDetailList.Items[i].strLenderName);


      Item.SubItems.Add(m_HistoryDetailList.Items[i].strBorrowVerifyTypeName);

      if m_HistoryDetailList.Items[i].nReturnState = 0 then    
        Item.SubItems.Add('未归还')
      else
        Item.SubItems.Add('已归还');

      Item.SubItems.Add(m_HistoryDetailList.Items[i].strGiveBackTrainmanName);

      Item.SubItems.Add(m_HistoryDetailList.Items[i].strGiveBackVerifyTypeName);
    end;
  finally
    lstViewAllRecord.Items.EndUpdate;
  end;


end;

procedure TfrmGoodsQuery.RefreshGoodsList;
var
  I: Integer;
  Item: TListItem;
begin
  lstViewNoReturn.Items.BeginUpdate;
  try
    lstViewNoReturn.Items.Clear;
    for I := 0 to m_NoReturnDetailList.Count - 1 do
    begin
      Item := lstViewNoReturn.Items.Add;
      Item.Data := m_NoReturnDetailList.Items[i];
      Item.Caption := IntToStr(i + 1);
      Item.SubItems.Add(m_NoReturnDetailList.Items[i].strLendingTypeAlias +
        IntToStr(m_NoReturnDetailList.Items[i].strLendingExInfo));
      if (m_NoReturnDetailList.Items[i].nReturnState = 0) then
      begin
        Item.SubItems.Add(m_NoReturnDetailList.Items[i].strTrainmanName);
        Item.SubItems.Add(
          FormatDateTime('yy-mm-dd hh:nn',
          m_NoReturnDetailList.Items[i].dtBorrwoTime));
        Item.SubItems.Add(
          MinutesToTimeString(m_NoReturnDetailList.Items[i].nKeepMunites));

        Item.SubItems.Add(m_NoReturnDetailList.Items[i].strLenderName);

        Item.SubItems.Add(m_NoReturnDetailList.Items[i].strBorrowVerifyTypeName);
      end else begin
        Item.SubItems.Add('');
        Item.SubItems.Add('');
        Item.SubItems.Add('');
        Item.SubItems.Add('');
        Item.SubItems.Add('');
      end;
      if m_NoReturnDetailList.Items[i].nReturnState = 0 then
        Item.SubItems.Add('未归还')
      else
        Item.SubItems.Add('已归还');
    end;
  finally
    lstViewNoReturn.Items.EndUpdate;
  end;


end;

end.
