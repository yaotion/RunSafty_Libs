unit uFrmTemeplateTrainNoItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,uTemplateDayPlan,
  uTFSystem,uLCDayPlan,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmTemeplateTrainNoItem = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    RzPanel1: TRzPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lbDayPlanGroup: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtCheCi2: TEdit;
    edtCheCi1: TEdit;
    mmoRemark: TMemo;
    Label5: TLabel;
    lbDayPlan: TLabel;
    chkIsTomorrow: TCheckBox;
    edtCheCi: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure edtCheCi2Exit(Sender: TObject);
  private
    { Private declarations }
    //初始化
    procedure InitData(DayPlanInfo,PlanGroupInfo:string;DayPlanItem:TRsDayPlanItem;IsAdd:Boolean);
    //检查输入条件
    function CheckInput():Boolean;
        //格式化车次
    function FormatCC(SourceString : string) : string ;
  private
    { Private declarations }
    m_DayPlanItem : TRsDayPlanItem ;
    m_RsLCDayTemplate: TRsLCDayTemplate;
    m_bIsAdd: Boolean;
  public
    webAPIUtils : TWebAPIUtils;
    Global : IGlobal;
  public
    { Public declarations }
    class procedure Edit(AppGlobal : IGlobal ;DayPlanInfo,PlanGroupInfo:string;DayPlanItem:TRsDayPlanItem;IsAdd:Boolean);
  end;

var
  FrmTemeplateTrainNoItem: TFrmTemeplateTrainNoItem;

implementation

{$R *.dfm}

procedure TFrmTemeplateTrainNoItem.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;
  try
    case m_bIsAdd of
     True :
      begin
        m_RsLCDayTemplate.LCPlanModules.AddModule(m_DayPlanItem);
      end;
     False :
     begin
        m_RsLCDayTemplate.LCPlanModules.UpdateModule(m_DayPlanItem);
     end;
    end;
  except
    on e:Exception do
    begin
      BoxErr(e.Message);
    end;
  end;

  ModalResult := mrOk ;
end;

procedure TFrmTemeplateTrainNoItem.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

function TFrmTemeplateTrainNoItem.CheckInput: Boolean;
begin
  Result := False ;
  m_DayPlanItem.TrainNo1 := Trim(edtCheCi1.Text) ;


  if Trim(edtCheCi2.Text) = '' then
  begin
    BoxErr('车次2不能为空');
    Exit ;
  end;
  m_DayPlanItem.TrainNo2 := Trim(edtCheCi2.Text);

  m_DayPlanItem.TrainNo := Trim(edtCheCi.Text);

  m_DayPlanItem.Remark := mmoRemark.Lines.Text ;
  if chkIsTomorrow.Checked then
    m_DayPlanItem.IsTomorrow := 1
  else
    m_DayPlanItem.IsTomorrow := 0 ;

  Result := True ;
end;

class procedure TFrmTemeplateTrainNoItem.Edit(AppGlobal : IGlobal ;DayPlanInfo,PlanGroupInfo:string;DayPlanItem:TRsDayPlanItem;IsAdd:Boolean);
var
  frm : TFrmTemeplateTrainNoItem ;
begin
  frm := TFrmTemeplateTrainNoItem.Create(nil);
  try
    frm.Global := AppGlobal;
    frm.InitData(DayPlanInfo,PlanGroupInfo,DayPlanItem,IsAdd);
    frm.ShowModal;
  finally
    frm.Free ;
  end;
end;

procedure TFrmTemeplateTrainNoItem.edtCheCi2Exit(Sender: TObject);
begin
  edtCheCi.Text := FormatCC(edtCheCi2.Text);
end;

function TFrmTemeplateTrainNoItem.FormatCC(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;
  if b > 0 then
  begin
    e := b;
    for i := b+1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-']) then
      begin
        e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if (e <b) or (e*b = 0) then
    result := SourceString;
end;

procedure TFrmTemeplateTrainNoItem.FormDestroy(Sender: TObject);
begin
  m_DayPlanItem.Free ;
  m_RsLCDayTemplate.Free;
end;

procedure TFrmTemeplateTrainNoItem.InitData(DayPlanInfo,PlanGroupInfo:string;
  DayPlanItem:TRsDayPlanItem; IsAdd: Boolean);
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=Global.GetProxy.WebAPI.Host;
  webAPIUtils.Port := Global.GetProxy.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';
  
  m_DayPlanItem := TRsDayPlanItem.Create;
  m_RsLCDayTemplate := TRsLCDayTemplate.Create(WebAPIUtils);
  
  m_DayPlanItem.CopyFrom(DayPlanItem);
  m_bIsAdd := IsAdd ;
  lbDayPlan.Caption := DayPlanInfo;
  lbDayPlanGroup.Caption := PlanGroupInfo;
  edtCheCi1.Text := DayPlanItem.TrainNo1 ;
  edtCheCi2.Text := DayPlanItem.TrainNo2 ;
  edtCheCi.Text := DayPlanItem.TrainNo ;
  mmoRemark.Lines.Text := DayPlanItem.Remark ;
  if DayPlanItem.IsTomorrow > 0 then
    chkIsTomorrow.Checked := True
  else
    chkIsTomorrow.Checked := False ;
end;

end.
