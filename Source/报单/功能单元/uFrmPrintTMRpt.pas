unit uFrmPrintTMRpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTrainman,uTFSystem ,uDrink,
  DateUtils, Buttons, PngSpeedButton, Grids, AdvObj, BaseGrid, AdvGrid,
  uApparatusCommon,uPrintTMReport,uTrainPlan,StrUtils, frxClass,uLCDrink;

type
  TFrmPrintTMRpt = class(TForm)
    btnPrint: TButton;
    lblNote: TLabel;
    lbl6: TLabel;
    edt_TrainNo: TEdit;
    grp1: TGroupBox;
    btnGetDinkInfo: TButton;
    GridTMDrinkInfo: TAdvStringGrid;
    btnUp: TPngSpeedButton;
    btnDown: TPngSpeedButton;
    frxrprt1: TfrxReport;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetDinkInfoClick(Sender: TObject);
    procedure GridTMDrinkInfoCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure GridTMDrinkInfoEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure edt_TrainNoKeyPress(Sender: TObject; var Key: Char);
  private

    //测酒记录
    m_drinkAry:TRsDrinkArray;
    //测酒数据库操作
    m_RsLCDrink: TRsLCDrink;
  private
    //填充司机测酒信息
    procedure FillTrainmanDrinkInfo(index:Integer;drinkInfo:RRsDrink);
    //获取司机的测酒信息
    function GetTMDrinkInfo(strTMNumber: string; var drinkInfo: RRsDrink): Boolean;
    //清空司机的测酒信息
    procedure ClearTMDrinkInfo(index:Integer);
    //上移
    //下移


  public
    class procedure printTMRpt_NoPlan();
  end;



implementation
uses
  uGlobal;
{$R *.dfm}

{ TFrmPrintTMRpt }

procedure TFrmPrintTMRpt.btnDownClick(Sender: TObject);
var
  nSelRow:Integer;
  tDrinkInfo:RRsDrink;
  i:Integer;
begin
  nSelRow := GridTMDrinkInfo.Row-1;
  if nSelRow = 7 then exit;
  GridTMDrinkInfo.Row := GridTMDrinkInfo.Row + 1;
  tDrinkInfo :=m_drinkAry[nSelrow + 1];
  m_drinkAry[nSelRow +1]:= m_drinkAry[nSelRow];
  m_drinkAry[nSelRow ] := tDrinkInfo;
                                              
  for i := 0 to Length(m_drinkAry) - 1 do
  begin
    FillTrainmanDrinkInfo(i+1,m_drinkary[i]);
  end;
end;

procedure TFrmPrintTMRpt.btnGetDinkInfoClick(Sender: TObject);
var
  strTrainNo:string;
  dtStartTime:TDateTime;
  strErr:string;
  i:Integer;
  tempArray: TRsDrinkArray;
begin
  strTrainNo := Trim(edt_TrainNo.Text);
  if strTrainNo = '' then Exit;
  dtStartTime := incHour(GlobalDM.Now,-2);
  SetLength(m_drinkAry,8);
  FillChar(m_drinkAry[0],Length(m_drinkAry) * SizeOf(RRsDrink),#0);

  if m_RsLCDrink.GetTrainNoDrinkInfo(dtStartTime,strTrainNo,GlobalDM.PlaceID,
  8,tempArray,strErr)= False then
  begin
    Box(strErr);
    Exit;
  end;

  for i := 0 to Length(tempArray) - 1 do
  begin
    m_drinkAry[i] := tempArray[i];
  end;

  for I := 0 to Length(m_drinkAry) - 1 do
  begin
    FillTrainmanDrinkInfo(i+1,m_drinkAry[i]);
  end;

end;


procedure TFrmPrintTMRpt.btnPrintClick(Sender: TObject);
var
  chuqinplan1,chuQinplan2:RRsChuQinPlan;
  strErr:string;
begin

  chuqinplan1.ChuQinGroup.Group.Trainman1.strTrainmanGUID := m_drinkAry[0].strTrainmanGUID;
  chuqinplan1.ChuQinGroup.Group.Trainman1.strTrainmanNumber := m_drinkAry[0].strTrainmanNumber;
  chuqinplan1.ChuQinGroup.Group.Trainman1.strTrainmanName := m_drinkAry[0].strTrainmanName;

  chuqinplan1.ChuQinGroup.Group.Trainman2.strTrainmanGUID := m_drinkAry[1].strTrainmanGUID;
  chuqinplan1.ChuQinGroup.Group.Trainman2.strTrainmanNumber := m_drinkAry[1].strTrainmanNumber;
  chuqinplan1.ChuQinGroup.Group.Trainman2.strTrainmanName := m_drinkAry[1].strTrainmanName;

  chuqinplan1.ChuQinGroup.Group.Trainman3.strTrainmanGUID := m_drinkAry[2].strTrainmanGUID;
  chuqinplan1.ChuQinGroup.Group.Trainman3.strTrainmanNumber := m_drinkAry[2].strTrainmanNumber;
  chuqinplan1.ChuQinGroup.Group.Trainman3.strTrainmanName := m_drinkAry[2].strTrainmanName;

  chuqinplan1.ChuQinGroup.Group.Trainman4.strTrainmanGUID := m_drinkAry[3].strTrainmanGUID;
  chuqinplan1.ChuQinGroup.Group.Trainman4.strTrainmanNumber := m_drinkAry[3].strTrainmanNumber;
  chuqinplan1.ChuQinGroup.Group.Trainman4.strTrainmanName := m_drinkAry[3].strTrainmanName;
  //第二组人
  chuqinplan2.ChuQinGroup.Group.Trainman1.strTrainmanGUID := m_drinkAry[4].strTrainmanGUID;
  chuqinplan2.ChuQinGroup.Group.Trainman1.strTrainmanNumber := m_drinkAry[4].strTrainmanNumber;
  chuqinplan2.ChuQinGroup.Group.Trainman1.strTrainmanName := m_drinkAry[4].strTrainmanName;

  chuqinplan2.ChuQinGroup.Group.Trainman2.strTrainmanGUID := m_drinkAry[5].strTrainmanGUID;
  chuqinplan2.ChuQinGroup.Group.Trainman2.strTrainmanNumber := m_drinkAry[5].strTrainmanNumber;
  chuqinplan2.ChuQinGroup.Group.Trainman2.strTrainmanName := m_drinkAry[5].strTrainmanName;

  chuqinplan2.ChuQinGroup.Group.Trainman3.strTrainmanGUID := m_drinkAry[6].strTrainmanGUID;
  chuqinplan2.ChuQinGroup.Group.Trainman3.strTrainmanNumber := m_drinkAry[6].strTrainmanNumber;
  chuqinplan2.ChuQinGroup.Group.Trainman3.strTrainmanName := m_drinkAry[6].strTrainmanName;

  chuqinplan2.ChuQinGroup.Group.Trainman4.strTrainmanGUID := m_drinkAry[7].strTrainmanGUID;
  chuqinplan2.ChuQinGroup.Group.Trainman4.strTrainmanNumber := m_drinkAry[7].strTrainmanNumber;
  chuqinplan2.ChuQinGroup.Group.Trainman4.strTrainmanName := m_drinkAry[7].strTrainmanName;


  if TPrintTMReport.PrintRpt(LeftStr(GlobalDM.Site.Number,2),chuqinplan1,chuqinplan2,strErr)= False then
  begin
    Box(strErr);
    Exit;
  end;

end;

procedure TFrmPrintTMRpt.btnUpClick(Sender: TObject);
var
  nSelRow:Integer;
  tDrinkInfo:RRsDrink;
  i:Integer;
begin
  nSelRow := GridTMDrinkInfo.Row-1;
  if nSelRow = 0 then exit;

  tDrinkInfo :=m_drinkAry[nSelrow -1];
  m_drinkAry[nSelRow -1]:= m_drinkAry[nSelRow];
  m_drinkAry[nSelRow ] := tDrinkInfo;

  GridTMDrinkInfo.Row := GridTMDrinkInfo.Row -1;
  for i := 0 to Length(m_drinkAry) - 1 do
  begin
    FillTrainmanDrinkInfo(i+1,m_drinkary[i]);
  end;


end;

procedure TFrmPrintTMRpt.ClearTMDrinkInfo(index: Integer);
begin
  //GridTMDrinkInfo.Cells[0,index]:= '';
  GridTMDrinkInfo.Cells[1,index]:= '';
  GridTMDrinkInfo.Cells[2,index]:= '';
  GridTMDrinkInfo.Cells[3,index]:= '';
  GridTMDrinkInfo.Cells[4,index]:= '';
  GridTMDrinkInfo.Cells[5,index]:= '';
  GridTMDrinkInfo.Cells[6,index]:= '';
  GridTMDrinkInfo.Cells[7,index]:= '';
  GridTMDrinkInfo.Cells[8,index]:= '';
end;

procedure TFrmPrintTMRpt.edt_TrainNoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    key := #0;
    btnGetDinkInfoClick(nil);
  end;
end;

procedure TFrmPrintTMRpt.FillTrainmanDrinkInfo(index: Integer;
  drinkInfo: RRsDrink);
begin
  GridTMDrinkInfo.Cells[0,index]:= drinkInfo.strTrainmanNumber;
  GridTMDrinkInfo.Cells[1,index]:= drinkInfo.strTrainmanName;
  if drinkInfo.dtCreateTime > 1 then
  begin
    GridTMDrinkInfo.Cells[2,index]:= FormatDateTime('HH:nn',drinkInfo.dtCreateTime);
//    GridTMDrinkInfo.Cells[3,index]:= IntToStr(drinkInfo.Alcoholicity);
    GridTMDrinkInfo.Cells[3,index]:= '0';
    GridTMDrinkInfo.Cells[4,index]:= TestAlcoholResultToString(TTestAlcoholResult(drinkInfo.nDrinkResult));
  end
  else
  begin
    GridTMDrinkInfo.Cells[2,index]:= '';
    GridTMDrinkInfo.Cells[3,index]:= '';
    GridTMDrinkInfo.Cells[4,index]:= '';
  end;
end;

procedure TFrmPrintTMRpt.FormCreate(Sender: TObject);
begin
  m_RsLCDrink := TRsLCDrink.Create(g_WebAPIUtils);
  SetLength(m_drinkAry,8);
end;

procedure TFrmPrintTMRpt.FormDestroy(Sender: TObject);
begin
  m_RsLCDrink.Free;
end;

function TFrmPrintTMRpt.GetTMDrinkInfo(strTMNumber: string; var drinkInfo: RRsDrink): Boolean;
var
  strTrainNo:string;
  dtStartTime:TDateTime;
  strErr:string;
begin
  Result := False;
  strTrainNo := Trim(edt_TrainNo.Text);
//  if strTrainNo = '' then Exit;
  dtStartTime := incHour(GlobalDM.Now,-2);
  FillChar(drinkInfo,SizeOf(drinkInfo),0);
  
  if m_RsLCDrink.GetTMLastDrinkInfo(GlobalDM.Site.Number,strTMNumber,dtStartTime,drinkInfo,strErr)= False then
  begin
    Box(strErr);
    Exit;
  end;
  result := True;
end;

procedure TFrmPrintTMRpt.GridTMDrinkInfoCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if ACol = 0 then
  begin
    CanEdit := True;
  end;
end;

procedure TFrmPrintTMRpt.GridTMDrinkInfoEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  strTrainmanNumber:string;
begin
  if ACol = 0 then
  begin
    strTrainmanNumber := GridTMDrinkInfo.Cells[acol,arow];
    if strTrainmanNumber = m_drinkAry[ARow-1].strTrainmanNumber then Exit;

    ClearTMDrinkInfo(ARow);

    FillChar( m_drinkAry[ARow-1],SizeOf(m_drinkAry[ARow-1]),0);
    if strTrainmanNumber = '' then Exit;

    
    lblNote.Visible := True;
    if Self.GetTMDrinkInfo(strTrainmanNumber,m_drinkAry[ARow-1]) = True then
    begin
      FillTrainmanDrinkInfo(ARow,m_drinkAry[ARow-1]);
    end;
    lblNote.Visible := False;
  end;
end;

class procedure TFrmPrintTMRpt.printTMRpt_NoPlan;
var
  FrmPrintTMRpt: TFrmPrintTMRpt;
begin
  FrmPrintTMRpt:= TFrmPrintTMRpt.Create(nil);
  try
    FrmPrintTMRpt.ShowModal;
  finally
    FrmPrintTMRpt.Free;
  end;
end;

end.
