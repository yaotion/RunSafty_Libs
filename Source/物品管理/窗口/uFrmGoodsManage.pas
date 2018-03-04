unit uFrmGoodsManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngCustomButton, ExtCtrls, RzPanel, PngSpeedButton,
  ComCtrls, RzCmboBx,ADODB,uLendingDefine,
  uSaftyEnum, Menus,DateUtils,uWorkShop, RzDTP, Mask, RzEdit,
  RzCommon, RzStatus,uFrmGoodsRangeManage,uLCGoodsMgr,RsTMFPLib_TLB;
const
  COL_RETURNSTATE_INDEX = 1;
  COL_BORROWTIME_INDEX = 5;
  COL_GIVEBACKTIME_INDEX = 7;
  COL_MODIFYTIME_INDEX = 10;
type
  {排序方式}
  TLendingSortType = (lstNone{不排序},lstReturnState{归还状态},lstBorrowTime{按借出时间排序},
      lstGiveBackTime{按归还时间排序},lstModifyTime{按最后修改时间排序});
  TfrmGoodsManage = class(TForm,IRsFingerListener)
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    btnQuery: TPngSpeedButton;
    btnSendManage: TPngSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    cbbLendingType: TRzComboBox;
    Label6: TLabel;
    Label7: TLabel;
    cbbReturnType: TRzComboBox;
    RzPanel1: TRzPanel;
    lvGoodsList: TListView;
    btnQueryDetail: TPngSpeedButton;
    Label8: TLabel;
    dtPickerBeginTime: TRzDateTimePicker;
    dtPickerEndTime: TRzDateTimePicker;
    edtLendingNumber: TRzEdit;
    edtTrainmanNumber: TRzEdit;
    edtTrainmanName: TRzEdit;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    btnGoodsRangeManager: TPngSpeedButton;
    RzFrameController1: TRzFrameController;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnSendManageClick(Sender: TObject);
    procedure lvGoodsListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lvGoodsListColumnClick(Sender: TObject; Column: TListColumn);
    procedure btnQueryDetailClick(Sender: TObject);
    procedure edtLendingNumberKeyPress(Sender: TObject; var Key: Char);
    procedure btnGoodsRangeManagerClick(Sender: TObject);
  private
    { Private declarations }
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
    m_ReturnStateList: TRsReturnStateList;
    m_LendingTypeList: TRsLendingTypeList;
    m_LendingInfoList: TRsLendingInfoList;

    function GetColumnSortType(colIndex: Integer): TLendingSortType;
    function FormatTrainmanName(strName,strNumber: string): string;
    procedure InitBaseData();
    procedure BindBaseDataToControl();
    procedure RefreshDisplay();
    procedure CaptureTrainman(const Trainman: IRsFingerTrainman); safecall;
  private
    {排序方式}
    class var LendingSortType: TLendingSortType;
  end;
procedure LengingManage();
function LendingInfoCompare(Item1, Item2: Pointer): Integer;
implementation

uses uFrmGoodsSend, uTrainman, ufrmGoodsQuery, uGlobal, RsGlobal_TLB;

function LendingInfoCompare(Item1, Item2: Pointer): Integer;
begin
  case TfrmGoodsManage.LendingSortType of
    lstReturnState:
      begin
        if Ord(TRsLendingInfo(Item2).nReturnState) > Ord(TRsLendingInfo(Item1).nReturnState) then
          Result := -1
        else
        if Ord(TRsLendingInfo(Item2).nReturnState) < Ord(TRsLendingInfo(Item1).nReturnState) then
          Result := 1
        else
          Result := 0;
      end;
    lstBorrowTime:
      Result := CompareDateTime(TRsLendingInfo(Item2).dtBorrowTime,TRsLendingInfo(Item1).dtBorrowTime);
    lstGiveBackTime:
      Result := CompareDateTime(TRsLendingInfo(Item2).dtGiveBackTime,TRsLendingInfo(Item1).dtGiveBackTime);
    lstModifyTime:
      Result := CompareDateTime(TRsLendingInfo(Item2).dtModifyTime,TRsLendingInfo(Item1).dtModifyTime);
  else
    Result := 0;
  end;
end;


procedure LengingManage();
var
  frmGoodsManage: TfrmGoodsManage;
begin
  frmGoodsManage := TfrmGoodsManage.Create(nil);
  try
    frmGoodsManage.ShowModal;
  finally
    frmGoodsManage.Free;
  end;
end;
{$R *.dfm}

procedure TfrmGoodsManage.BindBaseDataToControl;
var
  i: Integer;
begin
  cbbReturnType.Items.Clear;
  cbbReturnType.Items.Add('全部');
  
  for I := 0 to m_ReturnStateList.Count - 1 do
  begin
    cbbReturnType.Items.AddObject(m_ReturnStateList.Items[i].strStateName,
        m_ReturnStateList.Items[i]);
  end;
  cbbReturnType.ItemIndex := 0;

  cbbLendingType.Items.Clear;
  cbbLendingType.Items.Add('全部');
  for I := 0 to m_LendingTypeList.Count - 1 do
  begin
    cbbLendingType.Items.AddObject(m_LendingTypeList.Items[i].strLendingTypeName,
        m_LendingTypeList.Items[i]);  
  end;
  cbbLendingType.ItemIndex := 0;
end;

procedure TfrmGoodsManage.btnSendManageClick(Sender: TObject);
var
  Trainman: RRsTrainman;
begin
  if (lvGoodsList.Selected <> nil) and
     (TRsLendingInfo(lvGoodsList.Selected.Data).nReturnState <> 2) then
  begin
    Trainman.strTrainmanGUID := TRsLendingInfo(lvGoodsList.Selected.Data).strBorrowTrainmanGUID;
    Trainman.strTrainmanName := TRsLendingInfo(lvGoodsList.Selected.Data).strBorrowTrainmanName;
    Trainman.strTrainmanNumber := TRsLendingInfo(lvGoodsList.Selected.Data).strBorrowTrainmanNumber;
    if SendLendings(Trainman,rfInput) then
    begin
      btnQuery.Click();
    end;    
  end
  else
  begin
    if SendLendings() then
    begin
      btnQuery.Click();
    end;
  end;
end;

procedure TfrmGoodsManage.CaptureTrainman(const Trainman: IRsFingerTrainman);
var
  tm: RRsTrainman;
  Verify: TRsRegisterFlag;
begin

  tm.strTrainmanGUID := Trainman.TrainmanGUID;
  tm.strTrainmanName := Trainman.TrainmanName;
  tm.strTrainmanNumber := Trainman.TrainmanNumber;
  Verify := rfFingerprint;
  if SendLendings(tm,Verify) then
  begin
    btnQuery.Click;
  end;
end;
procedure TfrmGoodsManage.edtLendingNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9',#8,#13]) then
  begin
    Key := #0;
  end;
end;

procedure TfrmGoodsManage.btnGoodsRangeManagerClick(Sender: TObject);
begin
  TFrmGoodsRangeManage.ShowForm ;
end;

procedure TfrmGoodsManage.btnQueryClick(Sender: TObject);
var
  Condition: TRsQueryCondition;
begin
  Condition := TRsQueryCondition.Create;
  try
    Condition.dtBeginTime := dtPickerBeginTime.DateTime;
    Condition.dtEndTime := dtPickerEndTime.DateTime;

    Condition.strTrainmanNumber := edtTrainmanNumber.Text;
    Condition.strTrainmanName := edtTrainmanName.Text;

    if Assigned(cbbReturnType.Items.Objects[cbbReturnType.ItemIndex]) then
    begin
      Condition.nReturnState :=
        TRsReturnState(cbbReturnType.Items.Objects[cbbReturnType.ItemIndex]).nReturnStateID;
    end;


    if Assigned(cbbLendingType.Items.Objects[cbbLendingType.ItemIndex]) then
    begin
      Condition.nLendingType :=
        TRsLendingType(cbbLendingType.Items.Objects[cbbLendingType.ItemIndex]).nLendingTypeID;
    end;


    Condition.strWorkShopGUID := GlobalDM.WorkShop.ID;

    if edtLendingNumber.Text <> '' then
    Condition.nLendingNumber := StrToInt(edtLendingNumber.Text);

    m_RsLCGoodsMgr.QueryRecord(Condition,m_LendingInfoList);


    RzStatusPane1.Caption := '共' + IntToStr(m_LendingInfoList.Count)+ '条记录!';

    RefreshDisplay();
  finally
    Condition.Free;
  end;

end;

procedure TfrmGoodsManage.btnQueryDetailClick(Sender: TObject);
var
  frmGoodsQuery: TfrmGoodsQuery;
begin
  frmGoodsQuery := TfrmGoodsQuery.Create(nil);
  try
    frmGoodsQuery.ShowModal;
  finally
    frmGoodsQuery.Free;
  end;
end;

function TfrmGoodsManage.FormatTrainmanName(strName, strNumber: string): string;
begin
  if strNumber <> '' then  
    Result := Format('[%4s]%s',[strNumber,strName])
  else
    Result := '';
end;

procedure TfrmGoodsManage.FormCreate(Sender: TObject);
begin
//  GlobalDM.FingerPrintCtl.EventHolder.Hold();
//  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(g_WebAPIUtils);
  m_ReturnStateList := TRsReturnStateList.Create;
  m_LendingTypeList := TRsLendingTypeList.Create;
  m_LendingInfoList := TRsLendingInfoList.Create;
  RzPanel2.DoubleBuffered := True;
  dtPickerBeginTime.Date := Now;
  dtPickerEndTime.Date := Now;
  InitBaseData();
  BindBaseDataToControl();

  FingerCtl.AddListener(self);
end;

procedure TfrmGoodsManage.FormDestroy(Sender: TObject);
begin
  FingerCtl.DelListener(self);
//  GlobalDM.FingerPrintCtl.EventHolder.Restore();
  m_ReturnStateList.Free;
  m_LendingTypeList.Free;
  m_LendingInfoList.Free;
  m_RsLCGoodsMgr.Free;
end;

function TfrmGoodsManage.GetColumnSortType(
  colIndex: Integer): TLendingSortType;
begin
  case colIndex of
    COL_RETURNSTATE_INDEX: Result := lstReturnState;
    COL_BORROWTIME_INDEX: Result := lstBorrowTime;
    COL_GIVEBACKTIME_INDEX: Result := lstGiveBackTime;
    COL_MODIFYTIME_INDEX: Result := lstModifyTime;
  else
    Result := lstNone;
  end;
end;

procedure TfrmGoodsManage.InitBaseData;
begin
  m_RsLCGoodsMgr.GetGoodType(m_LendingTypeList);
  m_RsLCGoodsMgr.GetStateNames(m_ReturnStateList);
end;

procedure TfrmGoodsManage.lvGoodsListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  LendingSortType := GetColumnSortType(Column.Index);

  if LendingSortType = lstNone then
    Exit;
  
  m_LendingInfoList.Sort(LendingInfoCompare);

  RefreshDisplay();
end;

procedure TfrmGoodsManage.lvGoodsListCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := clBlack;
  if SubItem = 1 then
  begin
    case TRsLendingInfo(Item.Data).nReturnState of
      0: Sender.Canvas.Font.Color := clRed;
      1: Sender.Canvas.Font.Color := clOlive;
      2: Sender.Canvas.Font.Color := clGreen;
    end;

  end;
end;

procedure TfrmGoodsManage.RefreshDisplay;
var
  i: Integer;
  Item: TListItem;
begin
  lvGoodsList.Items.BeginUpdate;
  lvGoodsList.Items.Clear;
  with m_LendingInfoList do
  begin
    for I := 0 to Count - 1 do
    begin
      Item := lvGoodsList.Items.Add;
      Item.Data := Items[I];
      Item.Caption := IntToStr(I + 1);    

      Item.SubItems.Add(Items[i].strStateName);


      Item.SubItems.Add(Items[i].strDetails);


      Item.SubItems.Add(
        FormatTrainmanName(Items[i].strBorrowTrainmanName,
          Items[i].strBorrowTrainmanNumber));

      Item.SubItems.Add(Items[i].strBorrowLoginName);


      if m_LendingInfoList.Items[i].dtBorrowTime > 1 then    
        Item.SubItems.Add(FormatDateTime('mm-dd hh:nn:ss',Items[i].dtBorrowTime))
      else
        Item.SubItems.Add('');

      Item.SubItems.Add(
        FormatTrainmanName(Items[i].strLenderName,Items[i].strLenderNumber));

      if m_LendingInfoList.Items[i].dtGiveBackTime > 1 then    
        Item.SubItems.Add(FormatDateTime('mm-dd hh:nn:ss',Items[i].dtGiveBackTime))
      else
        Item.SubItems.Add('');

      Item.SubItems.Add(Items[i].strGiveBackLoginName);


      Item.SubItems.Add(
        FormatTrainmanName(Items[i].strGiveBackTrainmanName,Items[i].strGiveBackTrainmanNumber));

      if m_LendingInfoList.Items[i].dtModifyTime > 1 then    
        Item.SubItems.Add(FormatDateTime('mm-dd hh:nn:ss',Items[i].dtModifyTime))
      else
        Item.SubItems.Add('');

      Item.SubItems.Add(Items[i].strRemark);
    end;
  end;

  lvGoodsList.Items.EndUpdate;
end;

end.
