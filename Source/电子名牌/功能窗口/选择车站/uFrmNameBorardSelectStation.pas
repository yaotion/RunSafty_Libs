unit uFrmNameBorardSelectStation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,uStation;

type
  TFrmNameBorardSelectStation = class(TForm)
    chklstSelStation: TCheckListBox;
    lbGroup: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure chklstSelStationClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    m_strSelStationGUD:string;
    m_StationArray:TRsStationArray;
  private
        //初始化机组信息到LISTBOX
    procedure InitData(StationArray: TRsStationArray);
    //检查输入要求
    function CheckInput():Boolean;
  public
    { Public declarations }
    class function GetSelStation(StationArray: TRsStationArray;out StationGUID:string):Boolean;
  end;

var
  FrmNameBorardSelectStation: TFrmNameBorardSelectStation;

implementation

{$R *.dfm}

procedure TFrmNameBorardSelectStation.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmNameBorardSelectStation.btnOkClick(Sender: TObject);
var
  nSel:Integer ;
begin
  if not CheckInput then
    Exit;
  nSel := chklstSelStation.ItemIndex ;
  m_strSelStationGUD := m_StationArray[nSel].strStationGUID;
  ModalResult := mrOk ;
end;

function TFrmNameBorardSelectStation.CheckInput: Boolean;
begin
  if chklstSelStation.ItemIndex = -1  then
    Result := False
  else
    Result := True ;
end;

procedure TFrmNameBorardSelectStation.chklstSelStationClick(Sender: TObject);
var
  i,index:integer;
begin
  //只能选中一个CHECK
  //获取当前选中的INDEX，其他的INDEX的CHECKED都设为FALSE
  //当前选中的INDEX的CHECKER为TRUE
  index := chklstSelStation.ItemIndex;
  if chklstSelStation.Selected[index] then
  begin
    for i:= 0 to chklstSelStation.Items.Count - 1 do
    begin
      chklstSelStation.Checked[i]:= ( i = index );
    end;
  end;
end;

procedure TFrmNameBorardSelectStation.FormCreate(Sender: TObject);
begin
  m_strSelStationGUD := '';
end;

class function TFrmNameBorardSelectStation.GetSelStation(StationArray: TRsStationArray;
  out StationGUID: string): Boolean;
var
  frm:TFrmNameBorardSelectStation;
begin
  Result := False ;
  frm := TFrmNameBorardSelectStation.Create(nil);
  try
    frm.InitData(StationArray);
    if frm.ShowModal = mrOk then
    begin
      StationGUID := frm.m_strSelStationGUD ;
      Result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmNameBorardSelectStation.InitData(StationArray: TRsStationArray);
var
 i:Integer;
begin
  m_StationArray := StationArray ;
  with chklstSelStation.Items do
  begin
    Clear;
    for I := 0 to Length(StationArray) - 1 do
    begin
      Add(StationArray[i].strStationName);
    end;
  end;
  chklstSelStation.ItemIndex := 0 ;
  chklstSelStation.Checked[0] := true ;
end;

end.
