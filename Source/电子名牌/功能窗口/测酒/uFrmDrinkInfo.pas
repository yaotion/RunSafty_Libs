unit uFrmDrinkInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, Buttons, PngCustomButton, ComCtrls,
  Grids, AdvObj, BaseGrid, AdvGrid, RzDTP, PngSpeedButton, uApparatusCommon,
  uTFSystem, uDrinkExtls, uSaftyEnum, uTrainman, uDrink, uLCDrink,uWebApiCollection;

type
  //测酒来源
  TRsDrinkFrom = (dfLocal{本地},dfServer{服务器});

  TFrmDrinkInfo = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    grdMain: TAdvStringGrid;
    statusMain: TStatusBar;
    btnExit: TPngSpeedButton;
    btnOK: TPngSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure grdMainGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
  private
    { Private declarations }
    //测酒记录来源地：本地断网测酒，服务器手工测酒
    m_DrinkFrom: TRsDrinkFrom;
    //所选记录的ID
    m_strDrinkInfoID: string;

    //初始化数据
    procedure Init(DrinkFrom: TRsDrinkFrom; DrinkQuery: RRsDrinkQuery);
    //查询服务器测酒信息，nWorkTypeID=2出勤 3退勤
    procedure QueryServerDrinkInfo(DrinkQuery: RRsDrinkQuery);     
    //获取当前选中的测酒信息
    function GetSelectDrinkInfo(out DrinkInfo: RRsDrinkInfo): boolean;
    //获取当前选中的请假信息
    function GetSelectRowIndex(out rowIndex: integer): boolean;
  public
    { Public declarations }
    //提供类接口，显示请假类型管理窗口
    class function ShowForm(DrinkFrom: TRsDrinkFrom; DrinkQuery: RRsDrinkQuery; out DrinkInfo: RRsDrinkInfo): TModalResult;
  end;

implementation
uses
  uGlobal;

{$R *.dfm}

class function TFrmDrinkInfo.ShowForm(DrinkFrom: TRsDrinkFrom; DrinkQuery: RRsDrinkQuery; out DrinkInfo: RRsDrinkInfo): TModalResult;
var
  FrmDrinkInfo: TFrmDrinkInfo;
begin                          
  result := mrNone;
  FrmDrinkInfo := TFrmDrinkInfo.Create(nil);
  FrmDrinkInfo.Init(DrinkFrom, DrinkQuery);
  if FrmDrinkInfo.ShowModal = mrOK then
  begin
    if FrmDrinkInfo.GetSelectDrinkInfo(DrinkInfo) then result := mrOK;
  end;
  FrmDrinkInfo.Free;
end;

procedure TFrmDrinkInfo.btnOKClick(Sender: TObject);
var
  iRow: integer;
begin
  if not GetSelectRowIndex(iRow) then
  begin
    Box('您没有选中有效的记录！');
    exit;
  end;

  m_strDrinkInfoID := grdMain.Cells[999, iRow];
  self.ModalResult := mrOk;
end;

procedure TFrmDrinkInfo.btnExitClick(Sender: TObject);
begin
  Close;
end;
    
procedure TFrmDrinkInfo.grdMainGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

//==============================================================================

procedure TFrmDrinkInfo.Init(DrinkFrom: TRsDrinkFrom; DrinkQuery: RRsDrinkQuery);
begin
  m_DrinkFrom := DrinkFrom;
  if DrinkQuery.nWorkTypeID = 2 then self.Caption := '出勤测酒记录';
  if DrinkQuery.nWorkTypeID = 3 then self.Caption := '退勤测酒记录';
  


  if m_DrinkFrom = dfServer then
  begin
    QueryServerDrinkInfo(DrinkQuery);
  end;
end;

procedure TFrmDrinkInfo.QueryServerDrinkInfo(DrinkQuery: RRsDrinkQuery);
var
  i: integer;
  DrinkArray: TRsDrinkArray;
begin
  try
    LCWebAPI.LCDrink.QueryNoPlanDrink(DrinkQuery.dtBeginTime, DrinkQuery.dtEndTime,
      DrinkQuery.strTrainmanNumber, DrinkQuery.nWorkTypeID, DrinkArray);
    with grdMain do
    begin
      ClearRows(1, RowCount - 1); 
      ClearCols(999, 999);
      RowCount := Length(DrinkArray) + 1;
      statusMain.Panels[0].Text := Format(' 记录条件：%d 条', [RowCount-1]);
      if RowCount = 1 then
      begin
        RowCount := 2;
        FixedRows := 1;
      end;
      for i := 0 to Length(DrinkArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);
        Cells[1, i + 1] := Format('%s[%s]', [DrinkArray[i].strTrainmanName, DrinkArray[i].strTrainmanNumber]);
        Cells[2, i + 1] := DrinkArray[i].strDrinkResultName;
        Cells[3, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',DrinkArray[i].dtCreateTime);
        Cells[4, i + 1] := DrinkArray[i].strVerifyName;
        Cells[5, i + 1] := '' ;
        Cells[999, i + 1] := DrinkArray[i].strGUID;
      end;
    end;
  except on e : exception do
    begin
      BoxErr('查询信息失败:' + e.Message);
    end;
  end;
end;

function TFrmDrinkInfo.GetSelectDrinkInfo(out DrinkInfo: RRsDrinkInfo): boolean;
var
  Drink: RRsDrink;
begin
  result := false;
 

  if m_DrinkFrom = dfServer then
  begin
    if LCWebAPI.LCDrink.GetDrinkInfo(m_strDrinkInfoID, Drink) then
    begin
      DrinkInfo.strGUID := Drink.strGUID ;
      DrinkInfo.strTrainmanNumber := Drink.strTrainmanNumber;
      DrinkInfo.nDrinkResult := Drink.nDrinkResult;
      DrinkInfo.dtCreateTime := Drink.dtCreateTime;
      DrinkInfo.nVerifyID := Drink.nVerifyID;
      DrinkInfo.strDutyNumber := '';
      DrinkInfo.nWorkTypeID := Drink.nWorkTypeID;
      DrinkInfo.DrinkImage := Drink.DrinkImage;
      DrinkInfo.strPictureURL := Drink.strPictureURL;
      DrinkInfo.dwAlcoholicity := Drink.dwAlcoholicity;
      result := true;
    end;
  end;
end;

function TFrmDrinkInfo.GetSelectRowIndex(out rowIndex: integer): boolean;
begin
  result := false;
  if grdMain.Row <= 0 then exit;
  if grdMain.Cells[999, grdMain.Row] = '' then exit;
  rowIndex := grdMain.Row;
  result := true;
end;

end.

