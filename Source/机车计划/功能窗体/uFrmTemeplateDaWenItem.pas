unit uFrmTemeplateDaWenItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,uTemplateDayPlan,
  uTFSystem,uLCDayPlan,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmTemeplateDaWenItem = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    RzPanel1: TRzPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lbDayPlanGroup: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lbDayPlan: TLabel;
    Label6: TLabel;
    edtCheHao1: TEdit;
    edtCheXing: TEdit;
    edtCheHao2: TEdit;
    edtCheHao3: TEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    { Private declarations }   private
    //初始化
    procedure InitData(DayPlanInfo,PlanGroupInfo:string;DayPlanItem:TRsDayPlanItem;IsAdd:Boolean);
    //检查输入条件
    function CheckInput():Boolean;
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
    class procedure Edit(AppGlobal : IGlobal;DayPlanInfo,PlanGroupInfo:string;DayPlanItem:TRsDayPlanItem;IsAdd:Boolean);
  end;

var
  FrmTemeplateDaWenItem: TFrmTemeplateDaWenItem;

implementation

{$R *.dfm}

procedure TFrmTemeplateDaWenItem.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmTemeplateDaWenItem.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;
  try
    case m_bIsAdd of
      True:
        begin
          m_RsLCDayTemplate.LCPlanModules.AddModule(m_DayPlanItem);
        end;
      False:
        begin
          m_RsLCDayTemplate.LCPlanModules.UpdateModule(m_DayPlanItem);
        end;
    end;
  except
    on e: Exception do
    begin
      BoxErr(e.Message);
    end;
  end;

  ModalResult := mrOk;
end;

function TFrmTemeplateDaWenItem.CheckInput: Boolean;
begin
  Result := False ;
  if edtCheXing.Text = ''then
  begin
    BoxErr('车型不能为空');
    Exit ;
  end;

  m_DayPlanItem.DaWenCheXing := Trim(edtCheXing.Text);
  m_DayPlanItem.DaWenCheHao1 := Trim(edtCheHao1.Text);
  m_DayPlanItem.DaWenCheHao2 := Trim(edtCheHao2.Text);
  m_DayPlanItem.DaWenCheHao3 := Trim(edtCheHao3.Text);
  m_DayPlanItem.IsTomorrow := 0 ;
  Result := True ;

end;

class procedure TFrmTemeplateDaWenItem.Edit(AppGlobal : IGlobal;DayPlanInfo, PlanGroupInfo: string;
  DayPlanItem: TRsDayPlanItem; IsAdd: Boolean);
var
  frm : TFrmTemeplateDaWenItem ;
begin
  frm := TFrmTemeplateDaWenItem.Create(nil);
  try
    frm.Global := AppGlobal;
    frm.InitData(DayPlanInfo,PlanGroupInfo,DayPlanItem,IsAdd);
    frm.ShowModal;
  finally
    frm.Free ;
  end;
end;

procedure TFrmTemeplateDaWenItem.FormCreate(Sender: TObject);
begin
  m_DayPlanItem := TRsDayPlanItem.Create;

end;

procedure TFrmTemeplateDaWenItem.FormDestroy(Sender: TObject);
begin
  m_DayPlanItem.Free ;
  m_RsLCDayTemplate.Free;
end;

procedure TFrmTemeplateDaWenItem.InitData(DayPlanInfo, PlanGroupInfo: string;
  DayPlanItem: TRsDayPlanItem; IsAdd: Boolean);
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=Global.GetProxy.WebAPI.Host;
  webAPIUtils.Port := Global.GetProxy.WebAPI.Port;
  webAPIUtils.OffsetUrl :='/AshxService/QueryProcess.ashx';

  m_RsLCDayTemplate := TRsLCDayTemplate.Create(WebAPIUtils);
  
  m_DayPlanItem.CopyFrom(DayPlanItem);
  m_bIsAdd := IsAdd ;
  lbDayPlan.Caption := DayPlanInfo;
  lbDayPlanGroup.Caption := PlanGroupInfo;
  edtCheXing.Text := DayPlanItem.DaWenCheXing ;
  edtCheHao1.Text := DayPlanItem.DaWenCheHao1 ;
  edtCheHao2.Text := DayPlanItem.DaWenCheHao2 ;
  edtCheHao3.Text := DayPlanItem.DaWenCheHao3 ;
end;

end.
