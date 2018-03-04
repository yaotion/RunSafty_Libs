unit uFrmPlanInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTrainPlan, StdCtrls, RzEdit, ExtCtrls, ComCtrls,RichEdit;

type
  TFrmPlanInfo = class(TForm)
    Button1: TButton;
    Bevel1: TBevel;
    RzRichEdit1: TRzRichEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitData(TrainPlan:RRsTrainPlan);
  public
    { Public declarations }
    class procedure ShowPlan(TrainPlan:RRsTrainPlan);
  end;
implementation

{$R *.dfm}

procedure TFrmPlanInfo.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmPlanInfo.InitData(TrainPlan: RRsTrainPlan);
begin
  RzRichEdit1.Lines.Add(Format('��·: %s',[TrainPlan.strTrainJiaoluName]));
  RzRichEdit1.Lines.Add(Format('����: %s',[TrainPlan.strTrainNumber]));
  RzRichEdit1.Lines.Add(Format('����: %s',[TrainPlan.strTrainNo]));
  RzRichEdit1.Lines.Add(Format('��ʼվ: %s',[TrainPlan.strStartStationName]));
  RzRichEdit1.Lines.Add(Format('����վ: %s',[TrainPlan.strEndStationName]));
  RzRichEdit1.Lines.Add(FormatDateTime('�ƻ�ʱ��: mm-dd hh:nn',TrainPlan.dtStartTime));
end;



class procedure TFrmPlanInfo.ShowPlan(TrainPlan: RRsTrainPlan);
var
  frm:TFrmPlanInfo;
begin
  frm := TFrmPlanInfo.Create(nil);
  try
    frm.InitData(TrainPlan);
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
