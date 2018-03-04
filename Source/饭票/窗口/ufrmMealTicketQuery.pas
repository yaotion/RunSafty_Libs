unit ufrmMealTicketQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, Grids, DBGrids, RzDBGrid, DB, SqlExpr, Buttons, StdCtrls,
  Mask, RzEdit, RzPanel, ExtCtrls,StrUtils,uTFSystem, DBClient, Provider,
  ComCtrls, RzListVw, DBXpress, WideStrings;

type
  TfrmMealTicketQuery = class(TForm)
    SQLQuery1: TSQLQuery;
    RzPanel1: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    edtNumber: TRzEdit;
    Label1: TLabel;
    btnQuery: TSpeedButton;
    RzListView1: TRzListView;
    procedure btnQueryClick(Sender: TObject);
  private
    { Private declarations }
    m_strCheJian: string;
  public
    { Public declarations }
    class procedure ShowForm(CheJianName: string);
  end;

implementation
uses
  uGlobal;

{$R *.dfm}

procedure TfrmMealTicketQuery.btnQueryClick(Sender: TObject);
var
  strNumber: string;
  strTxt: string;
  Item: TListItem;
begin
  if not ConnectMealDB(g_TicketConn,strTxt) then
  begin
    Box('·¢·Å·¹Æ±´íÎó: '+strTxt);
    exit;
  end;
  
  SQLQuery1.SQLConnection := g_TicketConn;

  strNumber := edtNumber.Text;

  if (TicketNumberLen < 7) and (Length(strNumber) >= TicketNumberLen) then
    strNumber := RightStr(strNumber,TicketNumberLen);

  SQLQuery1.SQL.Text := Format('select top 20 * from TB_CANJUAN_INFO where DRIVER_CODE = %s '
  + ' and CHEJIAN_NAME = %s order by CHUQIN_TIME desc',[QuotedStr(strNumber),QuotedStr(m_strCheJian) ]);


  RzListView1.Items.Clear;
  SQLQuery1.Open();

  SQLQuery1.First;

  while not SQLQuery1.Eof do
  begin
    Item := RzListView1.Items.Add;
    Item.Caption := SQLQuery1.FieldByName('DRIVER_CODE').AsString;
    Item.SubItems.Add(SQLQuery1.FieldByName('DRIVER_NAME').AsString);
    Item.SubItems.Add(SQLQuery1.FieldByName('CHEJIAN_NAME').AsString);
    Item.SubItems.Add(SQLQuery1.FieldByName('CANQUAN_A').AsString);
    Item.SubItems.Add(SQLQuery1.FieldByName('CANQUAN_B').AsString);
    Item.SubItems.Add(SQLQuery1.FieldByName('CANQUAN_C').AsString);
    Item.SubItems.Add(SQLQuery1.FieldByName('PAIBAN_CHECI').AsString);
    Item.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:nn',SQLQuery1.FieldByName('CHUQIN_TIME').AsDateTime));
    SQLQuery1.Next;
  end;


end;

class procedure TfrmMealTicketQuery.ShowForm(CheJianName: string);
var
  frmMealTicketQuery: TfrmMealTicketQuery;
begin
  frmMealTicketQuery := TfrmMealTicketQuery.Create(NIL);
  try
    frmMealTicketQuery.ShowModal;
  finally
    if g_TicketConn.Connected then
      g_TicketConn.Close;
    frmMealTicketQuery.Free;
  end;
end;

end.
