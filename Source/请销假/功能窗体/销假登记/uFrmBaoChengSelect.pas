unit uFrmBaoChengSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,
  uDBTrainmanJiaolu,uTrainmanJiaolu,uDBNameBoard;

type
  TFrmBaoChengSelect = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    cmbBaoCheng: TRzComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure InitData(TrainmanJiaoluGUID:string);
  private
    { Private declarations }
        //名牌数据库操作类
    m_DBNameBoard : TRsDBNameBoard;
    m_strTrainmanJiaoluGUID:string;
    m_togetherGroupArray : TRsTogetherTrainArray;
    m_selTogetherTrain:RRsTogetherTrain;
  public
    { Public declarations }
    class function GetSelBaoCheng(TrainmanJiaoluGUID:string;out TogetherTrain:RRsTogetherTrain):Boolean;
  end;

var
  FrmBaoChengSelect: TFrmBaoChengSelect;

implementation

{$R *.dfm}

uses
  uGlobalDM;

procedure TFrmBaoChengSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmBaoChengSelect.btnOkClick(Sender: TObject);
var
  nSel:Integer ;
begin
  nSel := cmbBaoCheng.ItemIndex;
  if nSel = -1 then
    Exit ;
  m_selTogetherTrain := m_togetherGroupArray[nSel];
  ModalResult := mrOk ;
end;

procedure TFrmBaoChengSelect.FormCreate(Sender: TObject);
begin
  m_DBNameBoard := TRsDBNameBoard.Create(GlobalDM.ADOConnection);
end;

procedure TFrmBaoChengSelect.FormDestroy(Sender: TObject);
begin
  m_DBNameBoard.Free;
end;

class function TFrmBaoChengSelect.GetSelBaoCheng(TrainmanJiaoluGUID: string;
  out TogetherTrain: RRsTogetherTrain): Boolean;
var
  frm : TFrmBaoChengSelect;
begin
  Result := False ;
  frm := TFrmBaoChengSelect.Create(nil);
  try
    frm.InitData(TrainmanJiaoluGUID);
    if frm.ShowModal = mrOk then
    begin
      TogetherTrain := frm.m_selTogetherTrain ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

procedure TFrmBaoChengSelect.InitData(TrainmanJiaoluGUID: string);
var
  i:Integer;
  Condition: RNameBoardCondition;
begin
  m_strTrainmanJiaoluGUID := TrainmanJiaoluGUID ;
  Condition.Init;
  Condition.strTrainmanJiaoluGUID := TrainmanJiaoluGUID;
  m_DBNameBoard.GetTogetherTrainsByCondition(Condition,m_togetherGroupArray);
  cmbBaoCheng.Items.Clear;
  for i := 0 to length(m_togetherGroupArray) - 1 do
  begin
    cmbBaoCheng.Add(m_togetherGroupArray[i].strTrainTypeName + '-' + m_togetherGroupArray[i].strTrainNumber);
  end;
  cmbBaoCheng.ItemIndex := 0 ;
end;

end.
