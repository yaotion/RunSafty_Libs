unit uFrmTemeplateTrainNoGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTemplateDayPlan,uTFSystem, RzCmboBx,
  uLCDayPlan,RsGlobal_TLB,uHttpWebAPI;

type
  TFrmTemeplateTrainNoGroup = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    grpQuDuan: TGroupBox;
    Label1: TLabel;
    edtQuDuanName: TEdit;
    Label2: TLabel;
    lbDayPlan: TLabel;
    Label3: TLabel;
    cmbExcelSide: TRzComboBox;
    edtExcelPos: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cmbDaWen: TRzComboBox;
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    //初始化
    procedure InitData(DayPlan:TRsDayPlan;DayPlanItemGroup:TRsDayPlanItemGroup;IsAdd:Boolean);
    //检查输入条件
    function CheckInput():Boolean;
  private
    { Private declarations }
    m_DayPlanItemGroup : TRsDayPlanItemGroup ;
    m_RsLCDayTemplate: TRsLCDayTemplate;
    m_bIsAdd: Boolean;
  public
    webAPIUtils : TWebAPIUtils;
    Global : IGlobal;  
  public
    { Public declarations }
    class procedure Edit(AppGlobal:IGlobal;DayPlan:TRsDayPlan;DayPlanItemGroup:TRsDayPlanItemGroup;IsAdd:Boolean=True);
  end;

var
  FrmTemeplateTrainNoGroup: TFrmTemeplateTrainNoGroup;

implementation

{$R *.dfm}

procedure TFrmTemeplateTrainNoGroup.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit;
  try
    case m_bIsAdd of
      True:
        begin
          m_RsLCDayTemplate.LCPlanGroup.Add(m_DayPlanItemGroup);
        end;
      False:
        begin
          m_RsLCDayTemplate.LCPlanGroup.Update(m_DayPlanItemGroup);
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

procedure TFrmTemeplateTrainNoGroup.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

function TFrmTemeplateTrainNoGroup.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtQuDuanName.Text) = '' then
  begin
    BoxErr('区段名字不能为空');
    Exit ;
  end;

  if Trim(edtExcelPos.Text) = '' then
  begin
    BoxErr('序号不能为空');
    Exit;
  end;


  m_DayPlanItemGroup.IsDaWen := cmbDaWen.ItemIndex ;
  m_DayPlanItemGroup.ExcelSide := cmbExcelSide.itemIndex + 1 ;
  m_DayPlanItemGroup.ExcelPos := StrToInt(edtExcelPos.Text);
  m_DayPlanItemGroup.Name := Trim(edtQuDuanName.Text);
  Result := True ;
end;

class procedure TFrmTemeplateTrainNoGroup.Edit( AppGlobal:IGlobal;DayPlan:TRsDayPlan;
  DayPlanItemGroup: TRsDayPlanItemGroup; IsAdd: Boolean);
var
  frm : TFrmTemeplateTrainNoGroup ;
begin
  frm := TFrmTemeplateTrainNoGroup.Create(nil);
  try
    frm.Global := AppGlobal;
    frm.InitData(DayPlan,DayPlanItemGroup,IsAdd);
    frm.ShowModal;
  finally
    frm.Free ;
  end;
end;

procedure TFrmTemeplateTrainNoGroup.FormDestroy(Sender: TObject);
begin
  m_RsLCDayTemplate.Free;
  m_DayPlanItemGroup.Free ;
end;

procedure TFrmTemeplateTrainNoGroup.InitData(DayPlan:TRsDayPlan;
  DayPlanItemGroup: TRsDayPlanItemGroup; IsAdd: Boolean);
begin
  webAPIUtils := TWebAPIUtils.Create;
  webAPIUtils.Host :=Global.GetProxy.WebAPI.Host;
  webAPIUtils.Port := Global.GetProxy.WebAPI.Port;
  webAPIUtils.OffsetUrl := '/AshxService/QueryProcess.ashx';

  m_RsLCDayTemplate := TRsLCDayTemplate.Create(WebAPIUtils);
  m_DayPlanItemGroup := TRsDayPlanItemGroup.Create;
  
  m_bIsAdd := IsAdd;
  m_DayPlanItemGroup.CopyFrom(DayPlanItemGroup);
  lbDayPlan.Caption := DayPlan.Name ;
  edtQuDuanName.Text := DayPlanItemGroup.Name ;
  cmbExcelSide.ItemIndex := DayPlanItemGroup.ExcelSide -1  ;
  cmbDaWen.ItemIndex := DayPlanItemGroup.IsDaWen ;
  edtExcelPos.Text := IntToStr(DayPlanItemGroup.ExcelPos);
end;

end.
