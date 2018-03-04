unit uFrmViewMealTicket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, Buttons, PngSpeedButton, ExtCtrls,
  RzPanel,uMealTicket,utfsystem,uDBMealTicket,StrUtils, DBXpress, WideStrings,
  DB, SqlExpr;

type
  TFrmViewMealTicket = class(TForm)
    rzpnl1: TRzPanel;
    btnRefresh: TPngSpeedButton;
    lb1: TLabel;
    lb2: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpEndTime: TDateTimePicker;
    lvRecord: TListView;
    actlst1: TActionList;
    actInspect: TAction;
    Label1: TLabel;
    edtDriver: TEdit;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_listTicket:TRsMealTicketList;
    m_RsDBMealTicket: TRsDBMealTicket;
  private
    { Private declarations }
    procedure InitData();
    procedure DataToListView(MealList:TRsMealTicketList);
  public
    { Public declarations }
    class procedure ShowForm();
  end;

var
  FrmViewMealTicket: TFrmViewMealTicket;

implementation

uses
  uGlobal;

{$R *.dfm}

{ TFrmViewMealTicket }

procedure TFrmViewMealTicket.btnRefreshClick(Sender: TObject);
var
  error: string;
begin
  if not ConnectMealDB(g_TicketConn,error) then
  begin
    Box(error);
    Exit;
  end;
  
  InitData;
end;

procedure TFrmViewMealTicket.DataToListView(MealList: TRsMealTicketList);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
   lvRecord.Items.Clear;
  for I := 0 to Length(MealList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;

      strText := Format('[%s]%s',[MealList[i].DRIVER_CODE,MealList[i].DRIVER_NAME]);
      SubItems.Add(strText);

      SubItems.Add(IntToStr(MealList[i].CANQUAN_A));
      SubItems.Add(IntToStr(MealList[i].CANQUAN_B));

      SubItems.Add(MealList[i].CHUQIN_TIME);
      SubItems.Add(MealList[i].PAIBAN_CHECI);

      strText := Format('[%s]%s',[MealList[i].SHENHEREN_CODE,MealList[i].SHENHEREN_NAME]);
      SubItems.Add(strText);

      SubItems.Add(MealList[i].REC_TIME) ;
    end;
  end;
end;

procedure TFrmViewMealTicket.FormCreate(Sender: TObject);
begin
  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';
  m_RsDBMealTicket := TRsDBMealTicket.Create(g_TicketConn);
end;

procedure TFrmViewMealTicket.FormDestroy(Sender: TObject);
begin
  m_RsDBMealTicket.Free;
end;

procedure TFrmViewMealTicket.InitData;
var
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
  strDriver: string;
begin
  //��ȡ��ʼ�ͽ����Ĳ�ѯʱ��
  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  //��ѯ���ݿ�
  SetLength(m_listTicket,0);

  strDriver := edtDriver.Text;


  if (TicketNumberLen < 7) and (Length(strDriver) >= TicketNumberLen) then
    strDriver := RightStr(strDriver,TicketNumberLen);

  { TODO : ��Ҫ������־���� }
//  m_RsDBMealTicket.OnLog := GlobalDM.LogManage.InsertLog;
  m_RsDBMealTicket.Query(dtStart,dtEnd,strDriver,m_listTicket);
  //��ʾ�����
  DataToListView(m_listTicket);
end;

class procedure TFrmViewMealTicket.ShowForm;
var
  frm : TFrmViewMealTicket;
begin
  frm := TFrmViewMealTicket.Create(nil);
  try
    frm.ShowModal;
  finally
    if g_TicketConn.Connected then
      g_TicketConn.Close;
    frm.Free;
  end;
end;

end.
