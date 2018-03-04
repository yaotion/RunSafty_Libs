unit uFrmSelectDutyPlace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uDutyPlace,uLCDutyPlace,utfsystem;

type
  TFrmSelectDutyPlace = class(TForm)
    Label1: TLabel;
    cmbDutyPlace: TRzComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //初始化
    procedure InitData(JiaoLuID:string;DutyPlace:RRsDutyPlace);
  private
    { Private declarations }
    m_webDutyPlace:TRsLCDutyPlace;
    //选中的DUTY的PLACE
    m_placeDuty:RRsDutyPlace;
  public
    { Public declarations }
    class function SelectDutyPlace(JiaoLuID:string;var DutyPlace:RRsDutyPlace):Boolean;
  end;

var
  FrmSelectDutyPlace: TFrmSelectDutyPlace;

implementation

uses uGlobal;

{$R *.dfm}

procedure TFrmSelectDutyPlace.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmSelectDutyPlace.btnOkClick(Sender: TObject);
begin
  m_placeDuty.placeID := cmbDutyPlace.Value ;
  m_placeDuty.placeName := cmbDutyPlace.Text ;
  ModalResult := mrOk ;
end;

procedure TFrmSelectDutyPlace.FormCreate(Sender: TObject);
begin
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
end;

procedure TFrmSelectDutyPlace.FormDestroy(Sender: TObject);
begin
  m_webDutyPlace.Free ;
end;

procedure TFrmSelectDutyPlace.InitData(JiaoLuID:string;DutyPlace:RRsDutyPlace);
var
  listDutyPlace:TRsDutyPlaceList;
  strError:string;
  i : Integer ;
begin
  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(JiaoLuID,listDutyPlace,strError) then
  begin
    BoxErr(strError);
    Exit;
  end;
  for I := 0 to Length(listDutyPlace) - 1 do
  begin
    cmbDutyPlace.AddItemValue(listDutyPlace[i].placeName,listDutyPlace[i].placeID);
  end;
  cmbDutyPlace.ItemIndex := 0 ;
end;

class function TFrmSelectDutyPlace.SelectDutyPlace(JiaoLuID:string;
  var DutyPlace:RRsDutyPlace): Boolean;
var
  frm : TFrmSelectDutyPlace ;
begin
  Result := False ;
  frm := TFrmSelectDutyPlace.Create(nil);
  try
    frm.InitData(JiaoLuID,DutyPlace);
    if frm.ShowModal = mrOk then
    begin
      DutyPlace := frm.m_placeDuty ; ;
      Result := True ;
    end;
  finally
    frm.Free;
  end;

end;

end.
