unit uFrmGoodsRangeManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, RzPanel, StdCtrls,uGoodsRange,uLendingDefine,
  RzCmboBx,utfsystem, RzStatus, Menus, ActnList, RzButton, ToolWin, Buttons,
  PngSpeedButton,uLCGoodsMgr;

type
  TFrmGoodsRangeManage = class(TForm)
    RzPanel3: TRzPanel;
    RzPanel4: TRzPanel;
    RzPanel5: TRzPanel;
    lvGoods: TListView;
    Label1: TLabel;
    cmbGoodsType: TRzComboBox;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    StatusPaneCount: TRzStatusPane;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mniExit: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ActionList1: TActionList;
    actQuery: TAction;
    actInsert: TAction;
    actUpdate: TAction;
    actDelete: TAction;
    actExit: TAction;
    SpeedButton1: TSpeedButton;
    btnQuery: TPngSpeedButton;
    btnInsert: TPngSpeedButton;
    btnUpdate: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actQueryExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actUpdateExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    //初始化
    procedure InitData();
    //填充数据到LISTVIEW
    procedure DataToListView(ListGoodsRange:TRsGoodsRangeList);
    // 刷新界面
    procedure RefreshData();
  private
    { Private declarations }
    //物品管理接口
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
    //物品类型列表
    m_LendingTypeList: TRsLendingTypeList ;
    //物品范围列表
    m_ListGoodsRange:TRsGoodsRangeList;
  public
    { Public declarations }
    class procedure ShowForm();
  end;

var
  FrmGoodsRangeManage: TFrmGoodsRangeManage;

implementation

uses
  uGlobal,uFrmGoodsRangeView , RsGlobal_TLB;

{$R *.dfm}

procedure TFrmGoodsRangeManage.actDeleteExecute(Sender: TObject);
var
  strError:string ;
  GoodsRange : RRsGoodsRange ;
begin
  if lvGoods.Selected = nil then
    exit ;
  GoodsRange := ( PRsGoodsRange ( lvGoods.Selected.Data ) ) ^;
  if not TBox('确认删除吗?') then
    exit ;

  if not m_RsLCGoodsMgr.CodeRange.Delete(GoodsRange.strGUID,strError) then
    BoxErr(strError)
  else
    RefreshData;
end;

procedure TFrmGoodsRangeManage.actExitExecute(Sender: TObject);
begin
  Close ;
end;

procedure TFrmGoodsRangeManage.actInsertExecute(Sender: TObject);
var
  strError:string;
  GoodsRange : RRsGoodsRange ;
begin
  GoodsRange.strGUID := NewGUID ;
  GoodsRange.nLendingTypeID := StrToInt( cmbGoodsType.Value );
  GoodsRange.strWorkShopGUID := GlobalDM.WorkShop.ID;
  if not TFrmGoodsRangeView.ShowFrom('增加',GoodsRange) then
    Exit;

  if not m_RsLCGoodsMgr.CodeRange.Add(GoodsRange,strError) then
    BoxErr(strError)
  else
    RefreshData;
end;

procedure TFrmGoodsRangeManage.actQueryExecute(Sender: TObject);
begin
  RefreshData;
end;

procedure TFrmGoodsRangeManage.actUpdateExecute(Sender: TObject);
var
  strError:string ;
  GoodsRange : RRsGoodsRange ;
begin
  if lvGoods.Selected = nil then
    exit ;
  GoodsRange := ( PRsGoodsRange ( lvGoods.Selected.Data ) ) ^;
  if not TFrmGoodsRangeView.ShowFrom('修改',GoodsRange) then
    Exit;
  if not TBox('确认修改吗?') then
    exit ;

    
  if not m_RsLCGoodsMgr.CodeRange.Update(GoodsRange,strError) then
    BoxErr(strError)
  else
    RefreshData;
end;



procedure TFrmGoodsRangeManage.DataToListView(
  ListGoodsRange: TRsGoodsRangeList);
var
  i : Integer ;
  item :TListItem ;
begin
  lvGoods.Items.Clear ;
  for I := 0 to Length(ListGoodsRange) - 1 do
  begin
    with ListGoodsRange[i] do
    begin
      item := lvGoods.Items.Add ;
      item.Caption := IntToStr(i + 1 );
      item.SubItems.Add(cmbGoodsType.Text);
      item.SubItems.Add(IntToStr(nStartCode));
      item.SubItems.Add(IntToStr(nStopCode));
      //item.SubItems.Add(strExceptCodes);
      item.Data := Pointer ( Addr(ListGoodsRange[i]) ) ;
    end;
  end;
end;

procedure TFrmGoodsRangeManage.FormCreate(Sender: TObject);
begin
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(g_WebAPIUtils);
  m_LendingTypeList := TRsLendingTypeList.Create;
end;

procedure TFrmGoodsRangeManage.FormDestroy(Sender: TObject);
begin
  m_RsLCGoodsMgr.Free;
  m_LendingTypeList.Free ;
end;

procedure TFrmGoodsRangeManage.InitData;
var
  i : Integer ;
begin
  m_LendingTypeList.Clear ;
  m_RsLCGoodsMgr.GetGoodType(m_LendingTypeList);
  cmbGoodsType.Items.Clear;
  for I := 0 to m_LendingTypeList.Count - 1 do
  begin
    cmbGoodsType.AddItemValue(m_LendingTypeList.Items[i].strLendingTypeName,
      IntToStr(m_LendingTypeList.Items[i].nLendingTypeID));
  end;
  cmbGoodsType.ItemIndex :=0 ;
end;



procedure TFrmGoodsRangeManage.RefreshData;
var
  strType:string;
begin
  strType := cmbGoodsType.Value ;

  SetLength(m_ListGoodsRange,0);
  m_RsLCGoodsMgr.CodeRange.Get(GlobalDM.WorkShop.ID,StrToIntDef(strType,-1),m_ListGoodsRange);
  DataToListView(m_ListGoodsRange);
  StatusPaneCount.Caption := Format('%d个',[Length(m_ListGoodsRange)]);;
end;


class procedure TFrmGoodsRangeManage.ShowForm;
var
  frm : TFrmGoodsRangeManage ;
begin
  frm := TFrmGoodsRangeManage.Create(nil);
  try
    frm.InitData;
    frm.ShowModal ;
  finally
    frm.Free ;
  end;

end;

end.
