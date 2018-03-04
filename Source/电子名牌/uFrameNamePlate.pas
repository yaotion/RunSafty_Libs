unit uFrameNamePlate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uScrollView,uLCNameBoardEx,uTrainman,uTrainmanJiaolu,uTrainPlan,
  Menus,uWebApiCollection,Contnrs, ExtCtrls, RzPanel,uTrainmanOrderView,
  uTogetherTrainView,uOrderGroupView,uOrderGroupInTrainView,
  uNamedGroupView,uTrainmanView;
const
  SHEET_NONEPLATECAPTION = '未在牌';
  SHEET_LEAVESTATECAPTION = '非运转';
  SHEET_PREPARESTATECAPTION = '预备';
  SHEET_TXCAPTION = '调休';
type

  TFillParamCallback = procedure(InputJL: TRsLCBoardInputJL;InputDuty: TRsLCBoardInputDuty) of object;

  TPlateClass = class of TFrameNamePlate;

  PTm = ^RRsTrainman;

  TPlaceCollection = class(TStringList)
  private
    function GetPlaceID(index: integer): string;
    function GetPlaceName(index: integer): string;
  public
    procedure AddPlace(ID,Name: string);
    property PlaceName[index: integer]: string read GetPlaceName;
    property PlaceID[index: integer]: string read GetPlaceID;
  end;



  TTmJL = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_ID: string;
    m_Name: string;
    m_JlType: integer;
    m_PlaceLst: TPlaceCollection;
  public
    procedure Clone(src: TTmJL);
    property ID: string read m_ID write m_ID;
    property Name: string read m_Name write m_Name;
    property JlType: integer read m_JlType write m_JlType;
    property PlaceLst: TPlaceCollection read m_PlaceLst;
  end;

  TTmJlLst = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTmJL;
    procedure SetItem(Index: Integer; AObject: TTmJL);
  public
    function FindJl(ID: string): TTmJL;
    procedure FillData(jlArray: TRsSiteTMJLArray);
    procedure Init();
    property Items[Index: Integer]: TTmJL read GetItem write SetItem; default;
  end;



  TFrameNamePlate = class(TFrame)
    pnlTool: TRzPanel;
  protected
    m_TmJl: TTmJL;
    m_ScrollView: TScrollView;
    m_ParamCallback: TFillParamCallback;
    m_CanImport: Boolean;
    procedure OnDragViewOver(src,dest: TView;var Accept: Boolean);virtual;
    procedure OnDropMode(src,dest: TView;X,Y: integer;var Mode: TDropMode);virtual;
    procedure DoFillParam(InputJL: TRsLCBoardInputJL;InputDuty: TRsLCBoardInputDuty);
    procedure SetJL(JL: TTmJL);
    procedure OnHintView(View: TView);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure RefreshViews();virtual;
    procedure ShowToolButtons(pnlHolder: TRzPanel);
    procedure ExportPlates(const FileName: string);virtual;
    function Search(Tm: PTm): Boolean;virtual;
    property CanImport: Boolean read m_CanImport;
    property ScrollView: TScrollView read m_ScrollView;
    property TmJl: TTmJL read m_TmJl write SetJL;
    property ParamCallback: TFillParamCallback read m_ParamCallback write m_ParamCallback;
  end;

  


  TNPCommonLogic = class
  public
    class function AddTmToGrp(AddInput: TRsLCTrainmanAddInput): Boolean;

    class function RemoveTm(AddInput: TRsLCTrainmanAddInput;const Grp: RRsGroup): Boolean;

    class function RemovePlan(const GrpID: string): Boolean;

    class procedure ShowGprPlan(const GrpID: string);

    class procedure GrpTX(InputJL: TRsLCBoardInputJL;InputDuty: TRsLCBoardInputDuty;const GrpID: string);
  end;


  TNullViewChecker = class
  private
    //检查列表中是不是都是空，只支持 TTrainmanView 列表
    class function IsNull(Views: TViews): Boolean;overload;
  public
    class function IsNull(View: TTrainmanView): Boolean;overload;
    class function IsNull(View: TOrderGroupView): Boolean;overload;
    class function IsNull(View: TOrderGroupInTrainView): Boolean;overload;
    class function IsNull(View: TNamedGroupView): Boolean;overload;
    class function IsNull(View: TView): Boolean;overload;
  end;
  
  function AddMenuItem(Caption: string;Method: TNotifyEvent;PopMenu: TPopupMenu): TMenuItem;
implementation

uses
  uViewDefine,
  uGlobal,
  uHintWindow,
  RzCommon,
  uTFSystem,
  uFrmAddUser,
  uValidator,
  uDialogsLib,
  uFrmPlanInfo;
function AddMenuItem(Caption: string;Method: TNotifyEvent;PopMenu: TPopupMenu): TMenuItem;
begin
  Result := TMenuItem.Create(PopMenu);
  Result.Caption := Caption;
  Result.OnClick := Method;
  PopMenu.Items.Add(Result);
end;
{$R *.dfm}

{ TFrameNamePlate }

constructor TFrameNamePlate.Create(AOwner: TComponent);
begin
  inherited;
  m_TmJl := TTmJl.Create;
  m_ScrollView := TScrollView.Create(Self);
//  m_ScrollView.Color := $00626262;
  m_ScrollView.Color := $00484848;
  m_ScrollView.Parent := Self;
  m_ScrollView.Align := alClient;
  m_ScrollView.SelectedBorderColor := CL_NP_BK_SELECT;
  m_ScrollView.DroppingColor := $00156AC8;
  m_ScrollView.OnDragViewOver := OnDragViewOver;
  m_ScrollView.OnDropMode := OnDropMode;
  m_ScrollView.DropModePopMenu.SetValidMode([dmInsertLeft,dmInsertRight,dmExchange,dmCancel]);
  m_ScrollView.OnHintView := OnHintView;
end;

destructor TFrameNamePlate.Destroy;
begin
  m_TmJl.Free;
  inherited;
end;

procedure TFrameNamePlate.DoFillParam(InputJL: TRsLCBoardInputJL;
  InputDuty: TRsLCBoardInputDuty);
begin
  if not Assigned(m_ParamCallback) then
    raise Exception.Create('未设置TFillParamCallback');

  m_ParamCallback(InputJL,InputDuty);  
end;

procedure TFrameNamePlate.ExportPlates(const FileName: string);
begin

end;

procedure TFrameNamePlate.OnHintView(View: TView);
var
  pt: TPoint;
begin
  if View is TTrainmanView then
  begin
    GetCursorPos(pt);
    if (View as TTrainmanView).Trainman.strTrainmanGUID <> '' then
      //TNPHintWindow.Hint(pt,@(View as TTrainmanView).Trainman);
  end;
end;


procedure TFrameNamePlate.OnDragViewOver(src, dest: TView; var Accept: Boolean);
begin
  Accept := src.ClassType = dest.ClassType;
end;

procedure TFrameNamePlate.OnDropMode(src, dest: TView; X, Y: integer;
  var Mode: TDropMode);
begin
  Mode := dmCancel;
end;


procedure TFrameNamePlate.RefreshViews;
begin


end;

function TFrameNamePlate.Search(Tm: PTm): Boolean;
begin
  Result := False;
end;

procedure TFrameNamePlate.SetJL(JL: TTmJL);
begin
  m_TmJl.Clone(JL);
end;

procedure TFrameNamePlate.ShowToolButtons(pnlHolder: TRzPanel);
var
  I: Integer;
begin
  for I := 0 to pnlHolder.ControlCount - 1 do
  begin
    if pnlHolder.Controls[i] <> pnlTool then
      pnlHolder.Controls[i].Visible := False;
  end;
  pnlHolder.BorderOuter := fsNone;
  pnlHolder.BorderInner := fsNone;

  pnlTool.Parent := pnlHolder;
  pnlTool.Align := alClient;
  pnlTool.Visible := True;
end;



{ TTmJlLst }

procedure TTmJlLst.FillData(jlArray: TRsSiteTMJLArray);
var
  I: Integer;
  JL: TTmJL;
  k: Integer;
begin
  for I := 0 to Length(jlArray) - 1 do
  begin
    JL := FindJl(jlArray[i].JlGUID);
    if JL = nil then
    begin
      JL := TTmJL.Create;
      JL.ID := jlArray[i].JlGUID;
      JL.Name := jlArray[i].JlName;
      JL.JlType := Ord(jlArray[i].JlType);
      for k := 0 to length(jlArray[i].PlaceList) - 1 do
      begin
        jl.PlaceLst.AddPlace(jlArray[i].PlaceList[k].ID,jlArray[i].PlaceList[k].Name);
      end;
      Add(JL);
    end;
  end;
end;

function TTmJlLst.FindJl(ID: string): TTmJL;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].ID = ID then
    begin
      Result := Items[i];
      Break;
    end;  
  end;
end;

function TTmJlLst.GetItem(Index: Integer): TTmJL;
begin
  Result := TTmJL(inherited GetItem(Index))
end;

procedure TTmJlLst.Init;
var
  jlArray: TRsSiteTMJLArray;
  jl: TTmJL;
begin
  Clear;

  LCWebAPI.LCTMJl.GetTMJLOfSite(GlobalDM.Site.Number,jlArray);
  FillData(jlArray);



  jl := TTmJL.Create;
  jl.Name := SHEET_LEAVESTATECAPTION;
  jl.ID := jl.Name;
  jl.JlType := Ord(jltUnrun);
  Add(jl);

  jl := TTmJL.Create;
  jl.Name := SHEET_NONEPLATECAPTION;
  jl.ID := jl.Name;
  jl.JlType := Ord(jltAny);
  Add(jl);
end;

procedure TTmJlLst.SetItem(Index: Integer; AObject: TTmJL);
begin
  inherited SetItem(Index,AObject);
end;  
{ TPlaceCollection }

procedure TPlaceCollection.AddPlace(ID, Name: string);
begin
  Values[ID] := Name;
end;

function TPlaceCollection.GetPlaceID(index: integer): string;
begin
  Result := Names[index]
end;

function TPlaceCollection.GetPlaceName(index: integer): string;
begin
  Result := ValueFromIndex[index];
end;

  
{ TTmJL }

procedure TTmJL.Clone(src: TTmJL);
begin
  Self.m_ID := src.ID;
  Self.m_Name := src.Name;
  Self.m_JlType := src.JlType;
  Self.m_PlaceLst.Text := src.PlaceLst.Text;
end;

constructor TTmJL.Create;
begin
  m_PlaceLst := TPlaceCollection.Create;
end;

destructor TTmJL.Destroy;
begin
  m_PlaceLst.Free;
  inherited;
end;  
{ TNPCommonLogic }

class function TNPCommonLogic.AddTmToGrp(AddInput: TRsLCTrainmanAddInput): Boolean;
var
  Tm: RRsTrainman;
  ret: TCheckRet;
  reason: string;
begin
  Result := False;
  if not TFrmAddUser.InputTrainman('',Tm) then exit;

  if TLocalValidator.IsBusy(Tm) then
  begin
    TMessageBox.Box(TLocalValidator.Reason);
    Exit;
  end;


  ret := LCWebAPI.LCNameBoardEx.Together.Group.CanSetTM(
    GlobalDM.WorkShop.ID,
    AddInput.TrainmanJiaolu.jiaoluID,
    AddInput.GroupGUID,
    Tm.strTrainmanNumber,
    AddInput.TrainmanIndex,
    reason);

  AddInput.TrainmanNumber := Tm.strTrainmanNumber;

  case ret of
    stOk: LCWebAPI.LCNameBoardEx.Group.AddTrainman(AddInput);
    stHint:
      begin
        if TBox(reason + '，是否继续进行操作？') then
        begin
          LCWebAPI.LCNameBoardEx.Group.AddTrainman(AddInput);
        end
        else
          Exit;
      end;
    stRefuse:
      begin
        BoxErr(reason);
        Exit;
      end;
  end;

  Result := True;
end;


class procedure TNPCommonLogic.GrpTX(InputJL: TRsLCBoardInputJL;
  InputDuty: TRsLCBoardInputDuty;const GrpID: string);
begin
  LCWebAPI.LCNameBoardEx.Group.GroupTX.Add(
    InputJL,InputDuty,GrpID);
end;

class function TNPCommonLogic.RemovePlan(const GrpID: string): Boolean;
var
  Plan: RRsTrainmanPlan;
  Error: string;
  function PlanToString(): string;
  begin
    Result := Format('该机组正在值乘 [%s] [%s] 计划,确认移除计划吗?',[
    FormatDateTime('mm-dd hh:nn',Plan.TrainPlan.dtStartTime),
    Plan.TrainPlan.strTrainNo
    ]);
  end;
begin
  Result := False;
  if LCWebAPI.LCNameBoardEx.Group.GetPlan(GrpID,Plan) then
  begin
    if TBox(PlanToString()) then
    begin
      if LCWebAPI.LCTrainPlan.RemoveGroup(GrpID,Plan.TrainPlan.strTrainPlanGUID,Error) then
        Result := True
      else
        Box(Error);
    end;
  end
  else
    Box('没有找到该机组值乘的计划!');

end;

class function TNPCommonLogic.RemoveTm(
  AddInput: TRsLCTrainmanAddInput;const Grp: RRsGroup): Boolean;
begin
  Result := False;
  if (Grp.strGroupGUID <> '') and
        TLocalValidator.IsBusy(Grp) then
  begin
    TMessageBox.Box(TLocalValidator.Reason);
    Exit;
  end;
  if not TMessageBox.Question('确定要移除该人员吗？') then Exit;

  LCWebAPI.LCNameBoardEx.Group.DeleteTrainman(AddInput);
  Result := True;
end;

class procedure TNPCommonLogic.ShowGprPlan(const GrpID: string);
var
  Plan:RRsTrainmanPlan;
begin
  if LCWebAPI.LCNameBoardEx.Group.GetPlan(GrpID,Plan) then
    TFrmPlanInfo.ShowPlan(Plan.TrainPlan)
  else
    Box('该机组没有计划!');
end;



{ TNullViewChecker }

class function TNullViewChecker.IsNull(View: TOrderGroupView): Boolean;
begin
  Result := IsNull(View.Items);
end;

class function TNullViewChecker.IsNull(View: TTrainmanView): Boolean;
begin
  Result := View.Trainman.strTrainmanGUID = '';
end;

class function TNullViewChecker.IsNull(View: TOrderGroupInTrainView): Boolean;
begin
  Result := IsNull(View.Items);
end;

class function TNullViewChecker.IsNull(View: TView): Boolean;
begin
  if View is TTrainmanView then
    Result := IsNull(View as TTrainmanView)
  else
  if View is TOrderGroupView then
    Result := IsNull(View as TOrderGroupView)
  else
  if View is TOrderGroupInTrainView then
    Result := IsNull(View as TOrderGroupInTrainView)
  else
  if View is TNamedGroupView then
    Result := IsNull(View as TNamedGroupView)
  else
    Result := True;
end;

class function TNullViewChecker.IsNull(Views: TViews): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to Views.Count - 1 do
  begin
    if not (Views[i] is TTrainmanView) then
      Raise Exception.CreateFmt('参数类型错误: %s',[Views[i].ClassName]);

    Result := IsNull(Views[i] as TTrainmanView);
    
    if not Result then
      Break;
  end;
end;

class function TNullViewChecker.IsNull(View: TNamedGroupView): Boolean;
begin
  Result := IsNull(View.Items);
end;
end.
