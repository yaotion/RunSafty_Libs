unit uFrmRsUIDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls,RsGlobal_TLB,uTFComObject,
  RsLeaveLib_TLB,RsBJTrainPlanLib_TLB,RsNameplateLib_TLB;

type
  TfrmRsUIDemo = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
  private
    { Private declarations }
    Global :IGlobal;
    UILeave : IRsUILeave;
    UIBJTrainPlan : IRsBJTrainPlan;
    UINameplate : IRsNameplate;
  public
    { Public declarations }
  end;

var
  frmRsUIDemo: TfrmRsUIDemo;

implementation

{$R *.dfm}
function GetIF(DLLPath: WideString; IFGUID: TGUID): IUnknown;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(DLLPath,IFGUID,IUnKnown);
    result := ifObj.DefaultInterface;
  finally
    ifObj.Free;
  end;
end;
procedure TfrmRsUIDemo.FormCreate(Sender: TObject);
var
  dllRoot : string;
begin
 dllRoot :=ExtractFilePath(Application.ExeName) + 'libs\';
 Global := GetIF(dllRoot + 'RsGlobal.dll',CLASS_Global) as IGlobal;
 Global.GetProxy.Site.ID := 'a52bb0a9-c801-40c1-8cd1-1e94884cd1f4';
 Global.GetProxy.Site.Number := '1001001';
 Global.GetProxy.Site.Name := '唐山出勤端';

 Global.GetProxy.User.ID := 'f0309e5f-9185-47ac-b6ed-66c3de6a0e9c';
 Global.GetProxy.User.Number := '1064';
 Global.GetProxy.User.Name := '刘晓兵';

 Global.GetProxy.WorkShop.ID := '1001';
 Global.GetProxy.WorkShop.Name := '唐山车间';
 Global.GetProxy.AppHandle := Application.Handle;
//
// Global.GetProxy.WebAPI.Host := '192.168.1.166';
// Global.GetProxy.WebAPI.Port := '12306';
// Global.GetProxy.WebAPI.URL := '/AshxService/QueryProcess.ashx';
// Global.GetProxy.PlaceID := '2301001';




  UINameplate := GetIF(dllRoot + 'RsNameplateLib.dll',CLASS_RsNameplate) as IRsNameplate;



  UILeave := GetIF(dllRoot + 'RsLeaveLib.dll',CLASS_RsUILeave) as IRsUILeave;
//
//
  UIBJTrainPlan := GetIF(dllRoot + 'RsBJTrainPlanLib.dll',CLASS_RsBJTrainPlan) as  IRsBJTrainPlan;

end;

procedure TfrmRsUIDemo.FormDestroy(Sender: TObject);
begin
  Global := nil;
end;

procedure TfrmRsUIDemo.SpeedButton1Click(Sender: TObject);
begin
  UILeave.TypeShowQuery();
end;

procedure TfrmRsUIDemo.SpeedButton2Click(Sender: TObject);
begin
  UILeave.ShowQuery(true);
end;

procedure TfrmRsUIDemo.SpeedButton3Click(Sender: TObject);
begin
  UILeave.Askfor('2301450');
end;

procedure TfrmRsUIDemo.SpeedButton4Click(Sender: TObject);
begin
  UILeave.Askfor('2301450');
end;

procedure TfrmRsUIDemo.SpeedButton5Click(Sender: TObject);
begin
  UIBJTrainPlan.ShowForm(true);
end;

procedure TfrmRsUIDemo.SpeedButton6Click(Sender: TObject);
begin
  UIBJTrainPlan.ShowForm(false);
end;

procedure TfrmRsUIDemo.SpeedButton7Click(Sender: TObject);
begin
  UINameplate.ShowNameplate(True,true);
end;

procedure TfrmRsUIDemo.SpeedButton8Click(Sender: TObject);
begin
  UINameplate.ShowNameplate(false,false);
end;

end.
