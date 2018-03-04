unit uBindTMPopEdit;

interface
uses
  Classes,SysUtils,StdCtrls,utfLookupEdit,utfPopTypes,uSaftyEnum,uLCTrainmanMgr,
  uTrainman,ExtCtrls;
type
  TTmPopEditBinder = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_LookupEdit : TTFLookupEdit;
    m_LCTrainmanMgr: TRsLCTrainmanMgr;
    m_WorkShop: string;
    m_Timer: TTimer;
    procedure OnTimer(Sender: TObject);
    procedure IniColumns(LookupEdit : TTFLookupEdit);
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
    procedure OnTextChange(Sender: TObject);
    procedure OnNextPage(Sender: TObject);
    procedure OnPrevPage(Sender: TObject);
    procedure OnSelected(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
  public
    Selected: RRsTrainman;
    procedure Bind(WorkShop: string;LCTrainmanMgr: TRsLCTrainmanMgr;LookupEdit : TTFLookupEdit);
  end;
implementation
const EmptyTm: RRsTrainman  = ();
{ TTmPopEditBinder }

procedure TTmPopEditBinder.Bind(WorkShop: string;
  LCTrainmanMgr: TRsLCTrainmanMgr;LookupEdit : TTFLookupEdit);
begin
  m_WorkShop := WorkShop;
  m_LCTrainmanMgr := LCTrainmanMgr;
  m_LookupEdit := LookupEdit;
  IniColumns(m_LookupEdit);
  m_LookupEdit.IsAutoPopup := True;
  m_LookupEdit.PopStyle.ShowColumn := True;
  m_LookupEdit.PopStyle.ShowFooter := True;
  m_LookupEdit.PopStyle.PageCount := 10;
  m_LookupEdit.PopStyle.ColHeight := 20;
  m_LookupEdit.PopStyle.FooterHeight := 25;
  m_LookupEdit.PopStyle.MaxViewCol := 10;
  m_LookupEdit.PopStyle.RowHeight := 20;
  m_LookupEdit.OnSelected := OnSelected;
  m_LookupEdit.OnChange := OnTextChange;
  m_LookupEdit.OnPrevPage := OnPrevPage;
  m_LookupEdit.OnNextPage := OnNextPage;
end;

constructor TTmPopEditBinder.Create;
begin
  m_Timer := TTimer.Create(nil);
  m_Timer.Enabled := False;
  m_Timer.Interval := 300;
  m_Timer.OnTimer := OnTimer;
end;

destructor TTmPopEditBinder.Destroy;
begin
  m_Timer.Free;
  inherited;
end;

procedure TTmPopEditBinder.IniColumns(LookupEdit: TTFLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '序号';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '工号';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '姓名';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '职务';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '客货';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '关键人';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := 'ABCD';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '联系电话';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '状态';
  col.Width := 80;
end;


procedure TTmPopEditBinder.OnNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with m_LookupEdit do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_LCTrainmanMgr.GetPopupTrainmans(m_WorkShop, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(m_LookupEdit, TrainmanArray);
  end;
end;
procedure TTmPopEditBinder.OnPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with m_LookupEdit do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_LCTrainmanMgr.GetPopupTrainmans(m_WorkShop, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(m_LookupEdit, TrainmanArray);
  end;
end;
procedure TTmPopEditBinder.OnSelected(SelectedItem: TtfPopupItem;SelectedIndex: Integer);
begin
  m_LookupEdit.OnChange := nil;
  try
   m_LCTrainmanMgr.GetTrainman(SelectedItem.StringValue,Selected);

   m_LookupEdit.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    m_LookupEdit.OnChange := OnTextChange;
  end;
end;

procedure TTmPopEditBinder.OnTextChange(Sender: TObject);
begin
  m_Timer.Enabled := False;
  m_Timer.Enabled := True;
end;


procedure TTmPopEditBinder.OnTimer(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  m_Timer.Enabled := False;
  Selected := EmptyTm;
  with m_LookupEdit do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_LCTrainmanMgr.GetPopupTrainmans(m_WorkShop, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
  end;

  SetPopupData(m_LookupEdit, TrainmanArray);
end;

procedure TTmPopEditBinder.SetPopupData(LookupEdit: TtfLookupEdit;
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
      item.SubItems.Add('是');
    end else begin
      item.SubItems.Add('');
    end;
    item.SubItems.Add(TrainmanArray[i].strABCD);
    item.SubItems.Add(TrainmanArray[i].strMobileNumber);
    item.SubItems.Add(TRsTrainmanStateNameAry[TrainmanArray[i].nTrainmanState]);
    LookupEdit.Items.Add(item);
  end;
    //如果不加词句TextChanged()方法，显示内容会滞后一次查询。 
  LookupEdit.PopWindow.TextChanged('');
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);
end;
end.
