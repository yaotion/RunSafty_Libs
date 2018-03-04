unit uFrmNameBoard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, ExtCtrls, Buttons,
  RzPanel, RzStatus, RzTabs, AdvSplitter, RzTreeVw,
  uTrainmanJiaolu,uTrainJiaolu,uTrainman, Menus,uStation,
  uTrainPlan,  Mask, RzEdit, ActnList, PngCustomButton, Contnrs,
  PngImageList,uDutyPlace,
  utfLookupEdit,utfPopTypes,RsGlobal_TLB,uScrollView, RzCommon, RzBorder,
  uWebApiCollection, ImgList,uDialogsLib,uLCNameBoardEx;
type
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
    m_TrainJl: string;
    m_PlaceLst: TPlaceCollection;
  public
    property ID: string read m_ID write m_ID;
    property Name: string read m_Name write m_Name;
    property JlType: integer read m_JlType write m_JlType;
    property TrainJL: string read m_TrainJl write m_TrainJl;
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


  TTrainJlPlace = class
  public
    procedure Add(TrainJl,PlaceID,PlaceName: string);
    procedure GetPlaceLst(TrainJl: string;PlaceCollection: TPlaceCollection);
  end;
  
  TFrmNameBoard = class(TForm)
    StatusBar: TRzStatusBar;
    pnlPlateCount: TRzStatusPane;
    RzFrameController1: TRzFrameController;
    pnlTools: TRzPanel;
    PageControl: TRzPageControl;
    ImageList1: TImageList;
    Label1: TLabel;
    comboTrainmanJiaolu: TComboBox;
    btnToLeft: TPngCustomButton;
    PngCustomButton2: TPngCustomButton;
    btnToRight: TPngCustomButton;
    Panel1: TPanel;
    Panel2: TPanel;
    btnViewLog: TPngCustomButton;
    Panel3: TPanel;
    btnRefresh: TPngCustomButton;
    Panel4: TPanel;
    btnImport: TPngCustomButton;
    PngCustomButton6: TPngCustomButton;
    btnExport: TPngCustomButton;
    btnQuery: TPngCustomButton;
    PngImageList1: TPngImageList;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure comboTrainmanJiaoluChange(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnToLeftClick(Sender: TObject);
    procedure btnToRightClick(Sender: TObject);
    procedure btnViewLogClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    m_NoFocusHint:  TNoFocusHint;
    procedure FillParam(InputJL: TRsLCBoardInputJL;InputDuty: TRsLCBoardInputDuty);
    function  GetSelectedJiaolu(out Jiaolu : TTmJL) : boolean;
    procedure PostTrainman(JL : TTmJL;JiaoluType : TRsJiaoluType;
      TrainmanState : integer;TrainmanNumber : string;PlaceID : string);
    procedure CheckToolBar;
    procedure RefreshCurrent;
  public
    { Public declarations }
    procedure Init();
    procedure BindJL();
    procedure BindPages();
    class procedure OpenForm();
  end;



implementation
uses
  uFrmAddCheCi,
  uFrmAddUser,
  uFrmAddJiChe,
  DateUtils,
  ComObj,
  uFrmPlanInfo,
  uFrmNameBorardSelectStation,
  uGroupXlsExporter,
  uDutyUser,
  uGlobal,

  uViewDefine,
  uNamedGroupView,
  uOrderGroupInTrainView,
  uOrderGroupView,
  uTogetherTrainView,
  uTrainmanView,
  uTrainmanOrderView,
  uSaftyEnum,
  uFrameNamePlate,
  uFrameNamedGrp,
  uFrameOrderGrp,
  uFrameTogetherGrp,
  uFramePrepare,
  uFrameUnrun,
  uFrmNameBoardChangeLog;
var
  _FrmNameBoard: TFrmNameBoard = nil;
{$R *.dfm}
type
  PTmJL = ^RRsTrainmanJiaolu;



  

  
var
  _TmJLLst: TTmJlLst;
  
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
begin
  LCWebAPI.LCTMJl.GetTMJLOfSite(GlobalDM.Site.Number,jlArray);
  FillData(jlArray);
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

constructor TTmJL.Create;
begin
  m_PlaceLst := TPlaceCollection.Create;
end;

destructor TTmJL.Destroy;
begin
  m_PlaceLst.Free;
  inherited;
end;  
{ TFrmNameBoard }
procedure TFrmNameBoard.BindJL;
var
  I: Integer;
begin
  comboTrainmanJiaolu.Items.Clear;
  for i := 0 to _TmJLLst.Count - 1 do
  begin
    comboTrainmanJiaolu.Items.Add(_TmJLLst[i].Name);
  end;
  if comboTrainmanJiaolu.Items.Count > 0 then
  begin
    comboTrainmanJiaolu.ItemIndex := 0;
    BindPages;
  end;
end;

function GetFrameFromSheet(Sheet: TRzTabSheet): TFrameNamePlate;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Sheet.ControlCount - 1 do
  begin
    if Sheet.Controls[i] is TFrameNamePlate then
    begin
      Result := Sheet.Controls[i] as TFrameNamePlate;
      Break;
    end;
  end;
end;

procedure TFrmNameBoard.BindPages();
  function NewFramePlate(ACaption,Jl: string;AClass: TPlateClass): TFrameNamePlate;
  var
    Sheet: TRzTabSheet;
  begin
    Sheet := TRzTabSheet.Create(PageControl);
    Sheet.Name := 'Sheet' + IntToStr(PageControl.ComponentCount);
    Sheet.PageControl := PageControl;
    Sheet.Caption := ACaption;

    Result := AClass.Create(Sheet);
    Result.Parent := Sheet;
    Result.TmJL := jl;
    Result.ParamCallback := FillParam;
  end;
  
  procedure CreateNamedPages(jl: TTmJL);
  begin
    NewFramePlate('非运转人员',jl.ID,TFrameUnrun);
    NewFramePlate('预备人员',jl.ID,TFramePrepare);
    NewFramePlate('记名式名牌',jl.ID,TFrameNamedGrp);
  end;
  procedure CreateOrderPages(jl: TTmJL);
  var
    i: Integer;
  begin
    NewFramePlate('非运转人员',jl.ID,TFrameUnrun);
    NewFramePlate('预备人员',jl.ID,TFramePrepare);
    for i := 0 to jl.PlaceLst.Count - 1 do
    begin
      NewFramePlate(jl.PlaceLst.GetPlaceName(i),JL.ID,TFrameOrderGrp);
    end;


  end;
  procedure CreateTogetherPages(jl: TTmJL);
  begin
    NewFramePlate('非运转人员',jl.ID,TFrameUnrun);
    NewFramePlate('预备人员',jl.ID,TFramePrepare);
    NewFramePlate('包乘名牌',jl.ID,TFrameTogetherGrp);
  end;
  procedure ClearPages();
  var
    i: integer;
  begin
    I := 0;
    while I < PageControl.ComponentCount do
    begin
      if PageControl.Components[I] is TRzTabSheet then
        PageControl.Components[I].Free
      else
        Inc(I);
    end;
  end;
var
  jl : TTmJL;
begin
  //当之前已有选中的交路且和当前指定的交路不同时，清除现有交路信息
  if not GetSelectedJiaolu(jl) then
  begin
   exit;
  end;
  //清除之间数据
  ClearPages();
  case TRsJiaoluType(jl.JlType) of
    jltNamed: CreateNamedPages(jl);
    jltOrder: CreateOrderPages(jl);
    jltTogether: CreateTogetherPages(jl);
  end;

  //有交路且未指定活动页时指定当前第一个交路为缺省
  if (PageControl.PageCount > 0) and (PageControl.ActivePageIndex < 0) then
  begin
    PageControl.ActivePageIndex := 0;
    if PageControl.PageCount > 2 then
      PageControl.ActivePageIndex := 2;
  end;
  CheckToolBar;
end;

procedure TFrmNameBoard.Init;
begin
  _TmJLLst.Init();
  BindJL();
end;

class procedure TFrmNameBoard.OpenForm();
begin
  if _FrmNameBoard = nil then
  begin
    _FrmNameBoard := TFrmNameBoard.Create(nil);
    _FrmNameBoard.Init();
    _FrmNameBoard.ShowModal;
  end
  else
  begin
    //_FrmNameBoard.WindowState := wsMaximized;
    _FrmNameBoard.ShowModal;
  end;

end;


procedure TFrmNameBoard.PostTrainman(JL : TTmJL;JiaoluType: TRsJiaoluType;
  TrainmanState: integer; TrainmanNumber, PlaceID: string);
var
  i: Integer;
  rm : TFrameNamePlate;
begin
  rm := nil;
  case TrainmanState of
    0 : begin
      rm := TFrameUnrun(PageControl.Pages[0].Controls[0]);
      PageControl.ActivePageIndex := 0;
    end;
    1 : begin
      rm := TFramePrepare(PageControl.Pages[1].Controls[0]);
      PageControl.ActivePageIndex := 1;
    end;
    2 : begin
      case JiaoluType of
        jltNamed : begin
           rm := TFrameNamedGrp(PageControl.Pages[2].Controls[0]);
           PageControl.ActivePageIndex := 2;
        end;
        jltTogether : begin
           rm := TFrameTogetherGrp(PageControl.Pages[2].Controls[0]);
           PageControl.ActivePageIndex := 2;
        end;
        jltOrder : begin
          for i := 0 to jl.PlaceLst.Count - 1 do
          begin
            if jl.PlaceLst.GetPlaceID(i) = PlaceID then
            begin
              PageControl.ActivePageIndex := 2 + i;
              rm := TFrameOrderGrp(PageControl.Pages[2+i].Controls[0]);
            end;
          end;
        end;
      end;
    end;
  end;
  if rm = nil then
  begin
    MessageBox(Handle,'错误的名牌信息，请刷新','提示',MB_OK);
    exit;
  end;
  rm.PosTrainman(Trainmannumber);
end;


procedure TFrmNameBoard.RefreshCurrent;
begin
  m_NoFocusHint.Hint('正在加载名牌信息……');
  try
    GetFrameFromSheet(PageControl.ActivePage).RefreshViews();
  finally
    m_NoFocusHint.Close;
  end;
end;

procedure TFrmNameBoard.btnExportClick(Sender: TObject);
var
  strFileName:string;
  trainmanJiaolu : RRsTrainmanJiaolu;
  GroupXlsExporter: TGroupXlsExporter;
  jl : TTmJL;
begin
  if not GetSelectedJiaolu(jl) then
  begin
    Application.MessageBox('请先选择一个人员交路','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if PageControl.ActivePageIndex = 0 then
  begin
    Application.MessageBox('不支持非运转人员的导出','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if PageControl.ActivePageIndex = 1 then
  begin
    Application.MessageBox('不支持预备人员的导出','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not SaveDialog.Execute(Self.Handle)  then
    exit ;
  strFileName := SaveDialog.FileName ;
  trainmanJiaolu.strTrainmanJiaoluGUID := jl.ID;
  trainmanJiaolu.strTrainmanJiaoluName := jl.Name;
  trainmanJiaolu.nJiaoluType := TRsJiaoluType(jl.JlType);

  GroupXlsExporter := TGroupXlsExporter.Create(LCWebAPI.LCNameBoardEx,
    LCWebAPI.LCTrainmanMgr,LCWebAPI.LCNameBoard);
  try
    GroupXlsExporter.ExportGroups(trainmanJiaolu,strFileName);
  finally
    GroupXlsExporter.Free;
  end;
end;

procedure TFrmNameBoard.btnImportClick(Sender: TObject);
var
  strFileName,strText,strError:string;
  trainmanJiaolu : RRsTrainmanJiaolu;
  GroupXlsExporter: TGroupXlsExporter;
  jl : TTmJL;
begin
  if not GetSelectedJiaolu(jl) then
  begin
    Application.MessageBox('请先选择一个人员交路','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if PageControl.ActivePageIndex = 0 then
  begin
    Application.MessageBox('不支持非运转人员的导入','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if PageControl.ActivePageIndex = 1 then
  begin
    Application.MessageBox('不支持预备人员的导导入','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Application.MessageBox('导入前,是否删除该交路下面的名牌?','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;

  if not LCWebAPI.LCNameBoard.DeleteNamedGroupByJiaoLu(trainmanJiaolu.strTrainmanJiaoluGUID,strError) then
  begin
    Application.MessageBox(PChar(strError),'提示',MB_OK + MB_ICONINFORMATION);
    Exit ;
  end;

  strText := Format('当前选中的交路为: [%s] ,是否继续导入?',[trainmanJiaolu.strTrainmanJiaoluName]);
  if Application.MessageBox(PChar(strText),'提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;

  if not OpenDialog.Execute then exit;
  strFileName := OpenDialog.FileName ;
  GroupXlsExporter := TGroupXlsExporter.Create(LCWebAPI.LCNameBoardEx,
    LCWebAPI.LCTrainmanMgr,LCWebAPI.LCNameBoard);
  try
    GroupXlsExporter.ImportGroups(trainmanJiaolu,strFileName,GlobalDM.User.ID,
      GlobalDM.User.Number,GlobalDM.User.Name);
    RefreshCurrent;
  finally
    GroupXlsExporter.Free;
  end;
end;

procedure TFrmNameBoard.btnQueryClick(Sender: TObject);
var
  tm : RRsTrainman;
  ret : TRsLCBoardTmFindRet;
  i: Integer;
  bInJiaolu : boolean;
  selectedJL : TTmJL;
begin
  if not TFrmAddUser.InputTrainman(GlobalDM.WorkShop.ID,tm) then
    exit;
  ret := TRsLCBoardTmFindRet.Create;
  try
    if not LCWebAPI.LCBoardTrainman.Find(tm.strTrainmanNumber,ret) then
    begin
      MessageBox(Handle,'未找到指定的人员','提示',MB_OK + MB_ICONERROR);
      exit;
    end;
    if ret.IsFind = 0 then
    begin
      MessageBox(Handle,'未找到指定的人员','提示',MB_OK + MB_ICONERROR);
      exit;
    end;
    if ret.strTrainmanJiaoluGUID = '' then
    begin
      MessageBox(Handle,'指定的人员未归属任何人员交路','提示',MB_OK + MB_ICONERROR);
      exit;
    end;

    bInJiaolu := false;
    for i := 0 to _TmJLLst.Count - 1 do
    begin
      if _TmJLLst[i].ID = ret.strTrainmanJiaoluGUID then
      begin
        if ret.nTrainmanState > 2 then
        begin
          MessageBox(Handle,'该人员不在牌','提示',MB_OK + MB_ICONERROR);
          exit;
        end;
        if not GetSelectedJiaolu(selectedJL) then
        begin
          comboTrainmanJiaolu.ItemIndex := i;
          BindPages;
        end else begin
          if selectedJL.ID <> _TmJLLst[i].ID then
          begin
            comboTrainmanJiaolu.ItemIndex := i;
            BindPages;          
          end;
        end;
        PostTrainman(_TmJLLst[i],TRsJiaoluType(_TmJLLst[i].JlType),
          Ord(tm.nTrainmanState),tm.strTrainmanNumber,ret.strPlaceID);
        exit;
      end;
    end;
    //人员所属交路不在本客户端管辖的人员交路上
    if not bInJiaolu then
    begin
      MessageBox(Handle,PChar(Format('人员%在%交路上，本客户端无权限查看',
        [tm.strTrainmanName,ret.strTrainmanJiaoluName])),
        '提示',MB_OK + MB_ICONERROR);
    end;
  finally
    ret.Free;
  end;
end;

procedure TFrmNameBoard.btnRefreshClick(Sender: TObject);
begin
  if PageControl.ActivePage = nil then Exit;
  CheckToolBar;
  RefreshCurrent;
end;

procedure TFrmNameBoard.btnToLeftClick(Sender: TObject);
var
  jl : TTmJL;
begin
  if not GetSelectedJiaolu(jl) then
    exit;
  if jl.JlType <> Ord(jltNamed) then
  begin
    Application.MessageBox('只有记名式交路才能翻牌','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Application.MessageBox('您确定要翻牌吗?','提示',MB_OKCANCEL+MB_ICONQUESTION) = mrCancel then
    exit;
  LCWebAPI.LCNamedGroup.Turn(jl.ID,1);
  RefreshCurrent;
end;

procedure TFrmNameBoard.btnToRightClick(Sender: TObject);
var
  jl : TTmJL;
begin
  if not GetSelectedJiaolu(jl) then
    exit;
  if jl.JlType <> Ord(jltNamed) then
  begin
    Application.MessageBox('只有记名式交路才能翻牌','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Application.MessageBox('您确定要翻牌吗?','提示',MB_OKCANCEL+MB_ICONQUESTION) = mrCancel then
    exit;
  LCWebAPI.LCNamedGroup.Turn(jl.ID,2);
  RefreshCurrent;
end;

procedure TFrmNameBoard.btnViewLogClick(Sender: TObject);
begin
  TfrmNameBoardChangeLog.Open;
end;

procedure TFrmNameBoard.CheckToolBar;
var
  jl : TTmJL;
begin
  btnToLeft.Enabled := false;
  btnToRight.Enabled := false;
  if not GetSelectedJiaolu(jl) then
    exit;
  if jl.JlType = Ord(jltNamed) then
  begin
    if PageControl.ActivePageIndex > 1 then
    begin
      btnToLeft.Enabled := true;
      btnToRight.Enabled := true;
    end;
  end; 
end;

procedure TFrmNameBoard.comboTrainmanJiaoluChange(Sender: TObject);
begin
  BindPages();
  CheckToolbar;
end;

procedure TFrmNameBoard.FillParam(InputJL: TRsLCBoardInputJL;
  InputDuty: TRsLCBoardInputDuty);
var
  jl : TTmJL;
begin
  if not GetSelectedJiaolu(jl) then
    Raise Exception.Create('选中的交路为空!');
  with jl do
  begin
    InputJL.jiaoluID := ID;
    InputJL.jiaoluName := Name;
    InputJL.jiaoluType := JlType;
  end;

  InputDuty.strDutyGUID := GlobalDM.User.ID;
  InputDuty.strDutyNumber := GlobalDM.User.Number;
  InputDuty.strDutyName := GlobalDM.User.Name;
end;

procedure TFrmNameBoard.FormCreate(Sender: TObject);
begin
  m_NoFocusHint := TNoFocusHint.Create;
end;

procedure TFrmNameBoard.FormDestroy(Sender: TObject);
begin
  m_NoFocusHint.Free;
end;

function TFrmNameBoard.GetSelectedJiaolu(out Jiaolu: TTmJL): boolean;
begin
  result := false;
  if comboTrainmanJiaolu.ItemIndex < 0 then exit;
  Jiaolu := _TmJLLst[comboTrainmanJiaolu.ItemIndex];
  result := true;
end;


{ TTrainJlPlace }

procedure TTrainJlPlace.Add(TrainJl, PlaceID, PlaceName: string);
begin

end;

procedure TTrainJlPlace.GetPlaceLst(TrainJl: string;
  PlaceCollection: TPlaceCollection);
begin

end;

initialization
  _TmJLLst := TTmJlLst.Create;

finalization
  FreeAndNil(_TmJLLst);


end.

