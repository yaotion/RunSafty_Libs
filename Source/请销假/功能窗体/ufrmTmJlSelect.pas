unit ufrmTmJlSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, ComCtrls, ExtCtrls, RzTabs, Mask, RzEdit,uTrainmanJiaolu,
  uDutyPlace,uLCNameBoardEx,uTFSystem,uLCDict_TrainmanJiaoLu;

type
  TfrmTmjlSelect = class(TForm)
    cbbTMJiaolu: TRzComboBox;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    TabSheet3: TRzTabSheet;
    Label1: TLabel;
    cbbDutyPlace: TRzComboBox;
    cbbTrains: TRzComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edtCheCi1: TRzEdit;
    edtCheCi2: TRzEdit;
    Label4: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbTMJiaoluChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_JiaoluArray: TRsTrainmanJiaoluArray;
    m_DutyPlaceList:TRsDutyPlaceList;
    m_RsLCTogetherPlate: TRsLCTogetherPlate;
    m_RsTogetherTrainArray: TRsTogetherTrainArray;
    m_Input: TChangeGrpJLInput;
    procedure InitTMJiaolu();
    procedure InitDutyPlace(JiaoluGUID: string);
    procedure InitTrains(JiaoluGUID: string);
  public
    { Public declarations }
    class function SelectJL(Input: TChangeGrpJLInput): Boolean;
  end;


implementation

uses uGlobal;

{$R *.dfm}

{ TfrmTmjlSelect }

procedure TfrmTmjlSelect.Button1Click(Sender: TObject);
begin
  if Assigned(m_Input) then
  begin
    m_Input.DestJiaolu.jiaoluID := PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).strTrainmanJiaoluGUID;
    m_Input.DestJiaolu.jiaoluName := PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).strTrainmanJiaoluName;
    m_Input.DestJiaolu.jiaoluType := Ord(PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).nJiaoluType);
    m_Input.CheCi1 := edtCheCi1.Text;
    m_Input.CheCi2 := edtCheCi2.Text;
    m_Input.TrainGUID := cbbTrains.Value;
    m_Input.TrainNumber := cbbTrains.Text;

    if (m_Input.TrainGUID = '') and (PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex])).nJiaoluType = jltTogether) then
    begin
      Box('请选择机车!');
      Exit;
    end;
    
  end;
  ModalResult := mrOk;
end;

procedure TfrmTmjlSelect.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTmjlSelect.cbbTMJiaoluChange(Sender: TObject);
var
  RsTrainmanJiaolu: PRsTrainmanJiaolu;
begin
  RsTrainmanJiaolu := PRsTrainmanJiaolu(Pointer(cbbTMJiaolu.Items.Objects[cbbTMJiaolu.ItemIndex]));
  case RsTrainmanJiaolu.nJiaoluType of
    jltNamed:
    begin
      RzPageControl1.ActivePageIndex :=  2;
    end;
    jltOrder:
    begin
      InitDutyPlace(RsTrainmanJiaolu.strTrainmanJiaoluGUID);
      RzPageControl1.ActivePageIndex :=  0;
    end;

    jltTogether:
    begin
      InitTrains(RsTrainmanJiaolu.strTrainmanJiaoluGUID);
      RzPageControl1.ActivePageIndex :=  1;
    end;

  end;

end;

procedure TfrmTmjlSelect.FormCreate(Sender: TObject);
begin
  m_RsLCTogetherPlate := TRsLCTogetherPlate.Create(g_WebAPIUtils);
end;

procedure TfrmTmjlSelect.FormDestroy(Sender: TObject);
begin
  m_RsLCTogetherPlate.Free;
end;

procedure TfrmTmjlSelect.FormShow(Sender: TObject);
begin
  InitTMJiaolu();
  if cbbTMJiaolu.Items.Count > 0 then
  begin
    cbbTMJiaolu.ItemIndex := 0;
    cbbTMJiaoluChange(cbbTMJiaolu);
  end;

end;

procedure TfrmTmjlSelect.InitDutyPlace(JiaoluGUID: string);
var
  I: Integer;
begin
  cbbDutyPlace.Items.Clear;

  //通过人员交路获取出勤点
  for I := 0 to Length(m_DutyPlaceList) - 1 do
  begin
    cbbDutyPlace.AddItemValue(m_DutyPlaceList[i].placeName,m_DutyPlaceList[i].placeID);
  end;

  
end;

procedure TfrmTmjlSelect.InitTMJiaolu;
var
  I: Integer;
  LCTrainmanJiaolu: TRsLCTrainmanJiaolu;
begin
  cbbTMJiaolu.Clear;

  LCTrainmanJiaolu := TRsLCTrainmanJiaolu.Create(GlobalDM.WebAPI.URL,GlobalDM.Site.Number,GlobalDM.Site.ID);
  try
    LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.Site.ID,'',m_JiaoluArray);
  finally
    LCTrainmanJiaolu.Free;
  end;



  for I := 0 to Length(m_JiaoluArray) - 1 do
  begin
    cbbTMJiaolu.Items.AddObject(m_JiaoluArray[i].strTrainmanJiaoluName,TObject(@m_JiaoluArray[i]));
  end;
  

end;

procedure TfrmTmjlSelect.InitTrains(JiaoluGUID: string);
var
  I: Integer;
begin
  cbbTrains.Clear;

  m_RsLCTogetherPlate.GetTrainList(JiaoluGUID,m_RsTogetherTrainArray);
  for I := 0 to Length(m_RsTogetherTrainArray) - 1 do
  begin
    cbbTrains.AddItemValue(m_RsTogetherTrainArray[i].strTrainTypeName + '-' + m_RsTogetherTrainArray[i].strTrainNumber,
    m_RsTogetherTrainArray[i].strTrainGUID);
  end;

end;

class function TfrmTmjlSelect.SelectJL(Input: TChangeGrpJLInput): Boolean;
var
  frmTmjlSelect: TfrmTmjlSelect;
begin
  frmTmjlSelect := TfrmTmjlSelect.Create(nil);
  try
    frmTmjlSelect.m_Input := Input;
    Result := frmTmjlSelect.ShowModal = mrok;
  finally
    frmTmjlSelect.Free;
  end;
end;

end.
