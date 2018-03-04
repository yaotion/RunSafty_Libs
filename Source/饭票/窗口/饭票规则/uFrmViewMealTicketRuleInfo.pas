unit uFrmViewMealTicketRuleInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,uMealTicketRule,utfsystem,
  uLCMealTicket;

type
  TFrmViewMealTicketRuleInfo = class(TForm)
    lvRecord: TListView;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    btnLoadBreakfast: TButton;
    btnLoadNormal: TButton;
    btnLoadAll: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnLoadBreakfastClick(Sender: TObject);
    procedure btnLoadNormalClick(Sender: TObject);
    procedure btnLoadAllClick(Sender: TObject);
  private
    { Private declarations }
    m_MealTicketRule:RRsMealTicketRule;
        //�����б�
    m_listCheCi:TRsMealTicketCheCiList;
    m_RsLCMealTicket: TRsLCMealTicket;
    //����������ݿ�
//    m_dbMealTicketRule:TRsDBMealTicketRule;
  private
    //��ʼ��
    procedure InitData(MealTicketRule:RRsMealTicketRule);
    //ˢ��
    procedure RefreshData();
    //
    procedure DataToListView(CheCiList:TRsMealTicketCheCiList);
  private
    procedure LoadBreakfast();  //��������ʱ��(6�㵽9��)
    procedure LoadNormal();     //��������ʱ��(����ʱ����)
    procedure LoadAllDay();     //����ȫ��ʱ��
  public
    { Public declarations }
    class procedure ShowForm(MealTicketRule:RRsMealTicketRule);
  end;

var
  FrmViewMealTicketRuleInfo: TFrmViewMealTicketRuleInfo;

implementation

uses
  uGlobal,uFrmAddMealTicketRuleInfo;

{$R *.dfm}

procedure TFrmViewMealTicketRuleInfo.btnAddClick(Sender: TObject);
var
  CheCiInfo:RRsMealTicketCheCi;
  dtStartTime:TDateTime;
  dtEndTime:TDateTime;
begin
  try
    dtStartTime := StrToDateTime('1899-12-30 06:00:00');
    dtEndTime := StrToDateTime('1899-12-30 09:00:00');
    CheCiInfo.strQuDuan := '';
    CheCiInfo.strCheCi := '';
    CheCiInfo.strGUID := NewGUID ;
    CheCiInfo.strWorkShopGUID := m_MealTicketRule.strWorkShopGUID;
    CheCiInfo.iType := m_MealTicketRule.iType;
    CheCiInfo.strRuleGUID := m_MealTicketRule.strGUID ;
    CheCiInfo.dtStartTime := dtStartTime;
    CheCiInfo.dtEndTime := dtEndTime;
    if TFrmAddMealTicketRuleInfo.GetRuleInfo(CheCiInfo) then
    begin
      if m_RsLCMealTicket.AddCheCiInfo(CheCiInfo) then
      begin
        RefreshData;
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

procedure TFrmViewMealTicketRuleInfo.btnModifyClick(Sender: TObject);
var
  CheCiInfo:RRsMealTicketCheCi;
begin
  try
    if lvRecord.Selected = nil then
    begin
      BoxErr('��ѡ��һ������');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    CheCiInfo := ( RRsMealTicketCheCiPointer (lvRecord.Selected.Data) )^;
    if TFrmAddMealTicketRuleInfo.GetRuleInfo(CheCiInfo) then
    begin
      if not TBox('ȷ���޸���?') then
        Exit ;
      if m_RsLCMealTicket.ModifyCheCiInfo(CheCiInfo.strGUID,CheCiInfo) then
      begin
        RefreshData;
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

procedure TFrmViewMealTicketRuleInfo.btnDelClick(Sender: TObject);
var
  CheCiInfo:RRsMealTicketCheCi;
begin
  try
    if lvRecord.Selected = nil then
    begin
      BoxErr('��ѡ��Ҫɾ��������');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    CheCiInfo := ( RRsMealTicketCheCiPointer (lvRecord.Selected.Data) )^;
    if not TBox('ȷ��ɾ����?') then
      Exit ;

    if m_RsLCMealTicket.DeleteChiCiInfo(CheCiInfo.strGUID) then
    begin
      RefreshData;
      Box('ɾ���ɹ�');
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmViewMealTicketRuleInfo.btnLoadAllClick(Sender: TObject);
begin
  LoadAllDay;
end;

procedure TFrmViewMealTicketRuleInfo.btnLoadBreakfastClick(Sender: TObject);
begin
  LoadBreakfast  ;
end;

procedure TFrmViewMealTicketRuleInfo.btnLoadNormalClick(Sender: TObject);
begin
  LoadNormal ;
end;

procedure TFrmViewMealTicketRuleInfo.DataToListView(CheCiList:TRsMealTicketCheCiList);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(CheCiList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      SubItems.Add(CheCiList[i].strQuDuan);
      SubItems.Add(CheCiList[i].strCheCi);
      strText := Format('%s--%s',[
        FormatDateTime('hh:nn:ss',CheCiList[i].dtStartTime),
        FormatDateTime('hh:nn:ss',CheCiList[i].dtEndTime)]) ;
      SubItems.Add(strText);
    end;
    listItem.Data := Addr(CheCiList[i]);
  end;
end;

procedure TFrmViewMealTicketRuleInfo.FormCreate(Sender: TObject);
begin
  m_RsLCMealTicket := TRsLCMealTicket.Create(g_WebAPIUtils);
end;

procedure TFrmViewMealTicketRuleInfo.FormDestroy(Sender: TObject);
begin
  m_RsLCMealTicket.Free;
end;

procedure TFrmViewMealTicketRuleInfo.InitData(MealTicketRule:RRsMealTicketRule);
begin
  m_MealTicketRule := MealTicketRule ;
  RefreshData;
end;

procedure TFrmViewMealTicketRuleInfo.LoadAllDay;
var
  CheCiInfo:RRsMealTicketCheCi;
  dtStartTime:TDateTime;
  dtEndTime:TDateTime;
begin
  if not TBox('ȷ�ϼ���(0��-23��)ʱ����') then
    Exit;
  try
    dtStartTime := StrToDateTime('1899-12-30 00:00:01');
    dtEndTime := StrToDateTime('1899-12-30 23:59:59');
    CheCiInfo.strQuDuan := '';
    CheCiInfo.strCheCi := '';
    CheCiInfo.strGUID := NewGUID ;
    CheCiInfo.strWorkShopGUID := m_MealTicketRule.strWorkShopGUID;
    CheCiInfo.iType := m_MealTicketRule.iType;
    CheCiInfo.strRuleGUID := m_MealTicketRule.strGUID ;
    CheCiInfo.dtStartTime := dtStartTime;
    CheCiInfo.dtEndTime := dtEndTime;
    if m_RsLCMealTicket.AddCheCiInfo(CheCiInfo) then
    begin
      RefreshData;
      Box('��ӳɹ�');
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmViewMealTicketRuleInfo.LoadBreakfast;
var
  CheCiInfo:RRsMealTicketCheCi;
  dtStartTime:TDateTime;
  dtEndTime:TDateTime;
begin
  if not TBox('ȷ�ϼ�������(6��-9��)ʱ����') then
    Exit;
  try
    dtStartTime := StrToDateTime('1899-12-30 06:00:00');
    dtEndTime := StrToDateTime('1899-12-30 08:59:59');
    CheCiInfo.strQuDuan := '';
    CheCiInfo.strCheCi := '';
    CheCiInfo.strGUID := NewGUID ;
    CheCiInfo.strWorkShopGUID := m_MealTicketRule.strWorkShopGUID;
    CheCiInfo.iType := m_MealTicketRule.iType;
    CheCiInfo.strRuleGUID := m_MealTicketRule.strGUID ;
    CheCiInfo.dtStartTime := dtStartTime;
    CheCiInfo.dtEndTime := dtEndTime;
    if m_RsLCMealTicket.AddCheCiInfo(CheCiInfo) then
    begin
      RefreshData;
      Box('��ӳɹ�');
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmViewMealTicketRuleInfo.LoadNormal;
var
  CheCiInfo:RRsMealTicketCheCi;
  dtStartTime:TDateTime;
  dtEndTime:TDateTime;
begin
  if not TBox('ȷ�ϼ�������ʱ����') then
    Exit;
  try
    //����9�㵽24��
    dtStartTime := StrToDateTime('1899-12-30 09:00:00');
    dtEndTime := StrToDateTime('1899-12-30 23:59:59');
    CheCiInfo.strQuDuan := '';
    CheCiInfo.strCheCi := '';
    CheCiInfo.strGUID := NewGUID ;
    CheCiInfo.strWorkShopGUID := m_MealTicketRule.strWorkShopGUID;
    CheCiInfo.iType := m_MealTicketRule.iType;
    CheCiInfo.strRuleGUID := m_MealTicketRule.strGUID ;
    CheCiInfo.dtStartTime := dtStartTime;
    CheCiInfo.dtEndTime := dtEndTime;
    m_RsLCMealTicket.AddCheCiInfo(CheCiInfo) ;

    //����0�㵽6��
    dtStartTime := StrToDateTime('1899-12-30 00:00:01');
    dtEndTime := StrToDateTime('1899-12-30 05:59:59');
    CheCiInfo.strQuDuan := '';
    CheCiInfo.strCheCi := '';
    CheCiInfo.strGUID := NewGUID ;
    CheCiInfo.strWorkShopGUID := m_MealTicketRule.strWorkShopGUID;
    CheCiInfo.iType := m_MealTicketRule.iType;
    CheCiInfo.strRuleGUID := m_MealTicketRule.strGUID ;
    CheCiInfo.dtStartTime := dtStartTime;
    CheCiInfo.dtEndTime := dtEndTime;
    m_RsLCMealTicket.AddCheCiInfo(CheCiInfo) ;

    RefreshData;
    Box('��ӳɹ�');
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmViewMealTicketRuleInfo.RefreshData;
begin
  SetLength(m_listCheCi,0);
  m_RsLCMealTicket.QueryCheCiInfo(m_MealTicketRule.strGUID,m_listCheCi);
  DataToListView(m_listCheCi);
end;

class procedure TFrmViewMealTicketRuleInfo.ShowForm(MealTicketRule:RRsMealTicketRule);
var
  frm : TFrmViewMealTicketRuleInfo;
begin
  frm := TFrmViewMealTicketRuleInfo.Create(nil);
  try
    frm.InitData(MealTicketRule);
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
