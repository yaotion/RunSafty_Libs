unit uFrmMealTicketRule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, ComCtrls,uTrainmanJiaolu,uMealTicketRule
  ,utfsystem,uLCMealTicket;

type
  TFrmMealTicketRule = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel3: TRzPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    btnAddRule: TButton;
    btnModifyRole: TButton;
    btnDelRole: TButton;
    lvRecord: TListView;
    btnViewRoleDetail: TButton;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure btnAddRuleClick(Sender: TObject);
    procedure btnModifyRoleClick(Sender: TObject);
    procedure btnDelRoleClick(Sender: TObject);
    procedure lvRecordDblClick(Sender: TObject);
    procedure btnViewRoleDetailClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    m_iJiaoLuType:TRsJiaoluType;
    //�����б�
    m_listMealTicketRule:TRsMealTicketRuleList;
    //����GUID
    m_strWorkShopGUID:string;
    m_RsMealTicketRule: TRsLCMealTicket;
  private
    { Private declarations }
    //��ʼ��
    procedure InitData();
    //չ�ֵ��б�
    procedure DataToListView(RuleList:TRsMealTicketRuleList);
  public
    { Public declarations }
    class procedure ShowForm();
  end;

var
  FrmMealTicketRule: TFrmMealTicketRule;

implementation

uses
  uGlobal,uFrmAddMealTicketRule,uFrmViewMealTicketRuleInfo;

{$R *.dfm}


{ TFrmMealTicketRule }



procedure TFrmMealTicketRule.btnAddRuleClick(Sender: TObject);
var
  MealTicketRule:RRsMealTicketRule;
begin
  try
    MealTicketRule.strGUID := NewGUID ;
    MealTicketRule.strWorkShopGUID := m_strWorkShopGUID ;
    MealTicketRule.strName := '' ;
    MealTicketRule.iType := Ord(m_iJiaoLuType);
    MealTicketRule.iA := 0 ;
    MealTicketRule.iB := 3 ;
    if TFrmAddMealTicketRule.GetTicketRule(MealTicketRule) then
    begin
      if m_RsMealTicketRule.AddRule(MealTicketRule) then
      begin
        InitData;
        Box('��ӳɹ�');
      end;
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmMealTicketRule.btnDelRoleClick(Sender: TObject);
var
  MealTicketRule:RRsMealTicketRule;
begin
  try
    if lvRecord.Selected = nil then
    begin
      BoxErr('��ѡ��Ҫɾ��������');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    MealTicketRule := ( RRsMealTicketRulePointer (lvRecord.Selected.Data) )^;
    if not TBox('ȷ��ɾ����?') then
      Exit ;
    if m_RsMealTicketRule.DeleteRule(MealTicketRule.strGUID) then
    begin
      InitData;
      Box('ɾ���ɹ�');
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmMealTicketRule.btnLoadClick(Sender: TObject);
begin
  ;
end;

procedure TFrmMealTicketRule.btnModifyRoleClick(Sender: TObject);
var
  MealTicketRule:RRsMealTicketRule;
begin
  try
    if lvRecord.Selected = nil then
    begin
      BoxErr('��ѡ��һ������');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    MealTicketRule := ( RRsMealTicketRulePointer (lvRecord.Selected.Data) )^;
    if TFrmAddMealTicketRule.GetTicketRule(MealTicketRule) then
    begin
      if not TBox('ȷ���޸���?') then
        Exit ;
      if m_RsMealTicketRule.ModifyRule(MealTicketRule.strGUID,MealTicketRule) then
      begin
        InitData;
        Box('�޸ĳɹ�');
      end;
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmMealTicketRule.btnViewRoleDetailClick(Sender: TObject);
var
  MealTicketRule:RRsMealTicketRule;
begin
  try
    if lvRecord.Selected = nil then
    begin
      BoxErr('��ѡ��һ������');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    MealTicketRule := ( RRsMealTicketRulePointer (lvRecord.Selected.Data) )^;
    TFrmViewMealTicketRuleInfo.ShowForm(MealTicketRule);
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmMealTicketRule.DataToListView(RuleList: TRsMealTicketRuleList);
var
  i:Integer;
  listItem:TListItem;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(RuleList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      SubItems.Add(RuleList[i].strName);
      SubItems.Add(IntToStr(RuleList[i].iA));
      SubItems.Add(IntToStr(RuleList[i].iB));
    end;
    listItem.Data := Addr(RuleList[i]);
  end;
end;

procedure TFrmMealTicketRule.FormCreate(Sender: TObject);
begin

  m_strWorkShopGUID := GlobalDM.WorkShop.ID;
  m_RsMealTicketRule := TRsLCMealTicket.Create(g_WebAPIUtils);
  m_iJiaoLuType := jltNamed ;
end;

procedure TFrmMealTicketRule.FormDestroy(Sender: TObject);
begin
  m_RsMealTicketRule.Free;
end;

procedure TFrmMealTicketRule.InitData();
begin
  SetLength(m_listMealTicketRule,0);
  m_RsMealTicketRule.QueryRule(m_strWorkShopGUID,m_iJiaoLuType,m_listMealTicketRule);
  DataToListView(m_listMealTicketRule);
end;

procedure TFrmMealTicketRule.lvRecordDblClick(Sender: TObject);
begin
  btnViewRoleDetailClick(Sender);
end;

class procedure TFrmMealTicketRule.ShowForm();
var
  frm : TFrmMealTicketRule;
begin
  frm := TFrmMealTicketRule.Create(nil);
  try
    frm.InitData();
    frm.ShowModal;
  finally
    frm.Free;
  end;

end;

procedure TFrmMealTicketRule.TreeView1Click(Sender: TObject);
var
  nType : TRsJiaoluType ;
begin
   if  TreeView1.Selected.Index  = 0 then
    nType := jltNamed
   else  if TreeView1.Selected.Index  = 1 then
    nType :=  jltOrder
   else  if TreeView1.Selected.Index  = 2 then
    ntype := jltTogether
   else
    ntype :=  jltNamed;
   m_iJiaoLuType := nType ;
   InitData;
end;

end.
