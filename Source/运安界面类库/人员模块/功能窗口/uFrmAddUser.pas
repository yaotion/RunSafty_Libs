unit uFrmAddUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton,   ExtCtrls, DB, ADODB,
   StdCtrls, utfLookupEdit,utfPopTypes,RsAPITrainmanLib_TLB;

type
  TFrmAddUser = class(TForm)
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    Label1: TLabel;
    edtTrainman1: TtfLookupEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtTrainman1Change(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainman1NextPage(Sender: TObject);
    procedure edtTrainman1PrevPage(Sender: TObject);
  private
     m_RsLCTrainmanMgr: IRsAPITrainman;
     UserInfo: RsTrainman;
     m_strWorkShopGUID : string;
     procedure IniColumns(LookupEdit : TtfLookupEdit);
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : RsTrainmanArray);
  public
    class function InputTrainman(RsLCTrainmanMgr: IRsAPITrainman;
      WorkShopGUID : string;out Trainman : RsTrainman) : boolean;
  end;

implementation
{$R *.dfm}

{ TFrmAddUser }

procedure TFrmAddUser.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrcancel;
end;

procedure TFrmAddUser.btnOkClick(Sender: TObject);
begin
  if UserInfo.strTrainmanGUID = '' then
  begin
    Application.MessageBox(PChar('请选择人员'),'提示',MB_OK+MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmAddUser.edtTrainman1Change(Sender: TObject);
var
  TrainmanArray : RsTrainmanArray;
  nCount: Integer;
begin
  with edtTrainman1 do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(m_strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddUser.edtTrainman1NextPage(Sender: TObject);
var
  TrainmanArray : RsTrainmanArray;
begin

  with edtTrainman1 do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(m_strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddUser.edtTrainman1PrevPage(Sender: TObject);
var
  TrainmanArray : RsTrainmanArray;
begin

  with edtTrainman1 do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(m_strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddUser.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman1.OnChange := nil;
  try
   m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,0,UserInfo);

   edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman1.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddUser.FormCreate(Sender: TObject);
begin
  IniColumns(edtTrainman1);
end;

procedure TFrmAddUser.IniColumns(LookupEdit: TtfLookupEdit);
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

class function TFrmAddUser.InputTrainman(RsLCTrainmanMgr: IRsAPITrainman;
  WorkShopGUID : string;out Trainman: RsTrainman): boolean;
var
  frmAddUser : TFrmAddUser; 
begin
  result := false;
  frmAddUser := TFrmAddUser.Create(nil);
  try
    frmAddUser.m_strWorkShopGUID := WorkShopGUID;
    frmAddUser.m_RsLCTrainmanMgr := RsLCTrainmanMgr;
    if frmAddUser.ShowModal = mrCancel then exit;
    Trainman := frmAddUser.UserInfo;
    result := true;
  finally
    frmAddUser.Free;
  end;
end;
     
procedure TFrmAddUser.SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : RsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
  trainman : IRsTrainman;
begin
  LookupEdit.Items.Clear;
  for i := 0 to TrainmanArray.Count - 1 do
  begin
    item := TtfPopupItem.Create();
    TrainmanArray.GetItem(I,trainman);
    item.StringValue := trainman.strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(trainman.strTrainmanNumber);
    item.SubItems.Add(trainman.strTrainmanName);
    item.SubItems.Add(IntToStr(Ord((trainman.nPostID))));
    //item.SubItems.Add(TRsKeHuoNameArray[trainman.nKehuoID]);
    item.SubItems.Add(IntToStr(Ord((trainman.nKehuoID))));
    if trainman.bIsKey > 0 then
    begin
      item.SubItems.Add('是');
    end else begin
      item.SubItems.Add('');
    end;
    item.SubItems.Add(trainman.strABCD);
    item.SubItems.Add(trainman.strMobileNumber);
    //item.SubItems.Add(TRsTrainmanStateNameAry[trainman.nTrainmanState]);
    item.SubItems.Add(IntToStr(Ord((trainman.nTrainmanState))));
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);
end;

end.
