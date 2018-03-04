unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,RsGlobal_TLB,RsMealTicket_TLB, ExtCtrls, RzPanel;

type
  TForm5 = class(TForm)
    RzGroupBox1: TRzGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    RzGroupBox2: TRzGroupBox;
    RzGroupBox3: TRzGroupBox;
    RzGroupBox4: TRzGroupBox;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    { Private declarations }
    FGlobal: IGlobalProxy;
    FConfig: IConfig;
    FQuery: IQuery;
    FTicket: ITicket;

    function CreateInterface(dll: string;classid: TGUID): IUnknown;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses uTFComObject, RsPubJs_TLB,RsGoodsManage_TLB,RsBDPrint_TLB;

{$R *.dfm}

procedure TForm5.Button10Click(Sender: TObject);
var
  tm: RsMealTicket_TLB.ITm;
  plan:  IPlan;
  grp: RsMealTicket_TLB.IGrp;
begin

  plan := FTicket.CreatePlan;

  plan.ID := '9c3032bd-5a10-4913-9713-406a0397302e';
  plan.GrpID := '81eb6879-3b99-4eae-b159-3e6f7fc290d8';
  plan.TrainNo := 'S37021';
  plan.Time := StrToDateTime('2016-08-30 13:30:00.000');
  plan.Section := '唐山东—山海关(货)';

  grp := FTicket.CreateGrp;

  tm := FTicket.CreateTm;
  tm.ID := '733935F1-E6F9-465D-9B79-72A00B191684';
  tm.Number := '2303399';
  tm.Name := '贾红利';
  grp.Tm1 := tm;

  tm := FTicket.CreateTm;
  tm.ID := '0B894218-9EAE-4DE7-BD5C-CA18BB6F160E';
  tm.Number := '2302895';
  tm.Name := '王赞';
  grp.Tm2 := tm;

  FTicket.DelByGrp(plan,grp);
end;
procedure TForm5.Button11Click(Sender: TObject);
var
  BDPrint: IBDPrint;
  Param: RsBDPrint_TLB.IParam;
begin
  BDPrint := CreateInterface('RsBDPrint.dll',CLASS_BDPrint)as IBDPrint;
  Param := BDPrint.CreateParam();
  Param.TrainNo := 'S37021';
  Param.TrainNumber := '8801';
  Param.TrainTypeName := 'SS8';
  Param.RemarkType := 1;
  Param.PlanTime := Now;
  Param.Grp.Tm1.Number := '2303399';
  Param.Grp.Tm1.Name := '贾红利';

  BDPrint.Print(Param);
end;


procedure TForm5.Button12Click(Sender: TObject);
var
  BDPrint: IBDPrint;
begin
  BDPrint := CreateInterface('RsBDPrint.dll',CLASS_BDPrint)as IBDPrint;
  BDPrint.PrintNoPlan();
end;


procedure TForm5.Button13Click(Sender: TObject);
var
  PubJs: IPubJs;
  Param: RsPubJs_TLB.IParam;
begin
  PubJs := CreateInterface('RsPubJs.dll',CLASS_PubJs)as IPubJs;
  Param := PubJs.CreateParam;
//  PubJs.Print(Param);
end;

procedure TForm5.Button14Click(Sender: TObject);
var
  GoodsManage: IGoodsManage;
begin
  GoodsManage := CreateInterface('RsGoodsManage.dll',CLASS_GoodsManage)as IGoodsManage;
  GoodsManage.CodeRangeMgr();
end;


procedure TForm5.Button15Click(Sender: TObject);
var
  GoodsManage: IGoodsManage;
begin
  GoodsManage := CreateInterface('RsGoodsManage.dll',CLASS_GoodsManage)as IGoodsManage;
  GoodsManage.GoodsMgr();
end;


procedure TForm5.Button1Click(Sender: TObject);
begin
  FConfig.TicketCfg();
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  FConfig.ServerCfg();
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
  FConfig.TicketRule();
end;

procedure TForm5.Button4Click(Sender: TObject);
begin
  ShowMessage(IntToStr(GetCurrentThreadId));

  FQuery.Log(false);
end;

procedure TForm5.Button5Click(Sender: TObject);
begin
  FQuery.Ticket();
end;

procedure TForm5.Button6Click(Sender: TObject);
begin
  FTicket.SendDialog();
end;

procedure TForm5.Button7Click(Sender: TObject);
var
  tm: RsMealTicket_TLB.ITm;
  plan: IPlan;
begin
  tm := FTicket.CreateTm;
  plan := FTicket.CreatePlan;

  plan.ID := '9c3032bd-5a10-4913-9713-406a0397302e';
  plan.GrpID := '81eb6879-3b99-4eae-b159-3e6f7fc290d8';
  plan.TrainNo := 'S37021';
  plan.Time := StrToDateTime('2016-08-30 13:30:00.000');
  plan.Section := '唐山东—山海关(货)';


  tm.ID := '733935F1-E6F9-465D-9B79-72A00B191684';
  tm.Number := '2303399';
  tm.Name := '贾红利';
  
  FTicket.AddByTm(plan,tm);
end;

procedure TForm5.Button8Click(Sender: TObject);
var
  tm: RsMealTicket_TLB.ITm;
  plan: IPlan;
  grp: RsMealTicket_TLB.IGrp;
begin

  plan := FTicket.CreatePlan;

  plan.ID := '9c3032bd-5a10-4913-9713-406a0397302e';
  plan.GrpID := '81eb6879-3b99-4eae-b159-3e6f7fc290d8';
  plan.TrainNo := 'S37021';
  plan.Time := StrToDateTime('2016-08-30 13:30:00.000');
  plan.Section := '唐山东—山海关(货)';

  grp := FTicket.CreateGrp;

  tm := FTicket.CreateTm;
  tm.ID := '733935F1-E6F9-465D-9B79-72A00B191684';
  tm.Number := '2303399';
  tm.Name := '贾红利';
  grp.Tm1 := tm;

  tm := FTicket.CreateTm;
  tm.ID := '0B894218-9EAE-4DE7-BD5C-CA18BB6F160E';
  tm.Number := '2302895';
  tm.Name := '王赞';
  grp.Tm2 := tm;

  FTicket.AddByGrp(plan,grp);
end;

procedure TForm5.Button9Click(Sender: TObject);
var
  tm: RsMealTicket_TLB.ITm;
  plan: IPlan;
begin
  tm := FTicket.CreateTm;
  plan := FTicket.CreatePlan;

  plan.ID := '9c3032bd-5a10-4913-9713-406a0397302e';
  plan.GrpID := '81eb6879-3b99-4eae-b159-3e6f7fc290d8';
  plan.TrainNo := 'S37021';
  plan.Time := StrToDateTime('2016-08-30 13:30:00.000');
  plan.Section := '唐山东—山海关(货)';


  tm.ID := '733935F1-E6F9-465D-9B79-72A00B191684';
  tm.Number := '2303399';
  tm.Name := '贾红利';
  
  FTicket.DelByTm(plan,tm);
end;


function TForm5.CreateInterface(dll: string; classid: TGUID): IUnknown;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\' + dll,classid,IUnKnown);
    Result := ifObj.DefaultInterface;
  finally
    ifObj.Free;
  end;
end;
procedure TForm5.FormCreate(Sender: TObject);
begin
  FGlobal := (CreateInterface('RsGlobal.dll',CLASS_Global) as IGlobal).GetProxy;

  FGlobal.AppHandle := Application.Handle;
  FGlobal.Site.ID := '0aeda8cc-71ef-4504-976e-47e935de84bf';
  FGlobal.Site.Number := '2301001';
  FGlobal.Site.Name := '唐山派班室(派班点)';

  FGlobal.User.ID := '01ba2a49-1066-486b-9c60-30f9f9456755';
  FGlobal.User.Number := '8022';
  FGlobal.User.Name := '马玉成';

  FGlobal.WorkShop.ID := '3b50bf66-dabb-48c0-8b6d-05db80591090';
  FGlobal.WorkShop.Name := '唐山车间';

  
  FConfig := CreateInterface('RsMealTicket.dll',CLASS_Config) as IConfig;
  FQuery := CreateInterface('RsMealTicket.dll',CLASS_Query) as IQuery;
  FTicket := CreateInterface('RsMealTicket.dll',CLASS_Ticket) as ITicket;
end;
end.
