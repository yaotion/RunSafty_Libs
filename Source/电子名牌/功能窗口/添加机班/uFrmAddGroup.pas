unit uFrmAddGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, uTrainman, uTrainmanJiaolu,  StdCtrls,
  ADODB, DB, ExtCtrls,
  utfLookupEdit,utfPopTypes,uSaftyEnum,uLCTrainmanMgr,uHttpWebAPI,RsGlobal_TLB;

type
  TFrmAddGroup = class(TForm)
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtTrainman1: TtfLookupEdit;
    edtTrainman2: TtfLookupEdit;
    edtTrainman3: TtfLookupEdit;
    edtTrainman4: TtfLookupEdit;
    Label4: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure edtTrainman1Change(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainman2Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainman3Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure edtTrainman4Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainman1NextPage(Sender: TObject);
    procedure edtTrainman1PrevPage(Sender: TObject);
  private
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_strWorkShopGUID : string;
    Trainman1: RRsTrainman;
    Trainman2: RRsTrainman;
    Trainman3: RRsTrainman;
    Trainman4: RRsTrainman;
    procedure IniColumns(LookupEdit : TtfLookupEdit);   
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
    procedure Init;
  public
  public
    //获取机组的乘务员输入情况
    class function InputGroup(WorkShopGUID : string;
      out Trainman1 : RRsTrainman;out Trainman2 : RRsTrainman;
      out Trainman3 : RRsTrainman;out Trainman4 : RRsTrainman) : boolean;
  end;

implementation

uses uGlobal;

{$R *.dfm}

{ TFrmAddGroup }

procedure TFrmAddGroup.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmAddGroup.btnOkClick(Sender: TObject);
begin
  
  if ((Trainman1.strTrainmanGUID = Trainman2.strTrainmanGUID) and (Trainman1.strTrainmanGUID<>''))
   or ((Trainman2.strTrainmanGUID = Trainman3.strTrainmanGUID) and (Trainman2.strTrainmanGUID<>''))
   or ((Trainman3.strTrainmanGUID = Trainman4.strTrainmanGUID) and (Trainman3.strTrainmanGUID<>''))
   or ((Trainman4.strTrainmanGUID = Trainman1.strTrainmanGUID) and (Trainman3.strTrainmanGUID<>''))
   or ((Trainman1.strTrainmanGUID = Trainman3.strTrainmanGUID) and (Trainman1.strTrainmanGUID<>'')) then
  begin
    Application.MessageBox('班组内司机不能重复','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  ModalResult := mrOk;
end;

procedure TFrmAddGroup.edtTrainman1Change(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(m_strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;


procedure TFrmAddGroup.edtTrainman1NextPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TFrmAddGroup.edtTrainman1PrevPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
begin        
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.WorkShop.ID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TFrmAddGroup.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman1.OnChange := nil;
  try
    m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,Trainman1);
    edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman1.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddGroup.edtTrainman2Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman2.OnChange := nil;
  try
   m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,Trainman2);
   edtTrainman2.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman2.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddGroup.edtTrainman3Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman3.OnChange := nil;
  try
    m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,Trainman3);
    edtTrainman3.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman3.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddGroup.edtTrainman4Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman4.OnChange := nil;
  try
    m_RsLCTrainmanMgr.GetTrainman(SelectedItem.StringValue,Trainman4);
    edtTrainman4.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman4.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddGroup.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TFrmAddGroup.IniColumns(LookupEdit : TtfLookupEdit);
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

procedure TFrmAddGroup.Init;
begin
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(g_WebAPIUtils);
  IniColumns(edtTrainman1);
  IniColumns(edtTrainman2);
  IniColumns(edtTrainman3);
  IniColumns(edtTrainman4);
end;

class function TFrmAddGroup.InputGroup(WorkShopGUID : string;
      out Trainman1 : RRsTrainman;out Trainman2 : RRsTrainman;
      out Trainman3 : RRsTrainman;out Trainman4 : RRsTrainman): boolean;
var
  frmAddGroup : TFrmAddGroup;
begin
  result := false;
  frmAddGroup := TFrmAddGroup.Create(nil);
  try
    frmAddGroup.m_strWorkShopGUID := WorkShopGUID;
    frmAddGroup.Init;
    if frmAddGroup.ShowModal <> mrOk then exit;
    Trainman1 := frmAddGroup.Trainman1;
    Trainman2 := frmAddGroup.Trainman2;
    Trainman3 := frmAddGroup.Trainman3;
    Trainman4 := frmAddGroup.Trainman4;
    result := true;
  finally
    frmAddGroup.Free;
  end;
end;
  
procedure TFrmAddGroup.SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
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
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);
end;

end.

