unit uOrderGroupInTrainView; //包乘机车内的机组

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,Contnrs,uViewDefine ;

Type

  TOrderGroupInTrainView = class;

  {包乘组信息拖拽事件}
  TOnOrderGroupInTrainDragOver = procedure(Sender:TOrderGroupInTrainView;
      OrderGroupInTrainView:TOrderGroupInTrainView)of object;
  {包乘组信息双击事件}
  TOnOrderGroupInTrainDblClick = procedure(Sender:TOrderGroupInTrainView)of object;

  /////////////////////////////////////////////////////
  /// 类名:TOrderGroupInTrainView
  /// 说明:包乘组信息
  /////////////////////////////////////////////////////
  TOrderGroupInTrainView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
    destructor Destroy();override;
  public
    {乘务员1}
    TrainmanView1 : TTrainmanView;
    {乘务员2}
    TrainmanView2 : TTrainmanView;
    {乘务员3}
    TrainmanView3 : TTrainmanView;
    {乘务员4}
    TrainmanView4 : TTrainmanView;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    //交换人员
    procedure ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
    //克隆
    procedure Clone(view:TView);override;
  private
     //包乘交路内机班信息
    m_OrderGroupInTrain : RRsOrderGroupInTrain;
    {图片集}
    m_Images: TPngImageCollection;
    {乘务员拖拽放置事件}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    //乘务员双击事件
    m_OnTrainmanDblClick:TOnTrainmanDblClick;
    {检查乘务员是否允许被放置}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {包乘组拖拽事件}
    m_OnOrderGroupInTrainDragOver : TOnOrderGroupInTrainDragOver;
    //包乘机组双击事件
    m_OnOrderGroupInTrainDblClick:TOnOrderGroupInTrainDblClick;
    //标题颜色
    m_TitleFontColor:TColor;
  protected
    property OnViewChange;
  private
    {功能:获取背景色}
    function GetBKColor():TColor;
    {功能:绘制背景}
    procedure DrawBackground(viewCanvas : TCanvas);
    {功能:绘制乘务员信息}
    procedure DrawTrainmans(viewCanvas : TCanvas);
  private
    {功能:乘务员信息变动}
    procedure OnTrainmanViewChange(View : TView);
    {功能:设置轮乘信息}
    procedure SetOrderGroup(AOrderGroupInTrain : RRsOrderGroupInTrain);
    {功能:设置图片集}
    procedure SetImages(pngImages : TPngImageCollection);
    procedure SetOnTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetOnTrainmanDblClick(OnTrainmanDblClick:TOnTrainmanDblClick);
    procedure SetOnTrainmanBeforeDragOver(
        OnBeforeDragOver:TOnTrainmanBeforeDragOver);

  protected
    procedure ViewDragDrop(View:TView);override;
    procedure DblClick();override;
    //获取机组的颜色信息
    function GetGroupImageIndex(Group : RRsGroup):integer;
    //获取人员的颜色信息
    function GetTrainmanImageIndex(trainman:RRsTrainman):Integer;
  public
    property OrderGroupInTrain : RRsOrderGroupInTrain read m_OrderGroupInTrain write SetOrderGroup;
    property Images : TPngImageCollection read m_Images write SetImages;
    property OnTrainmanDragOver : TOnTrainmanDragOver read m_OnTrainmanDragOver
        write SetOnTrainmanDragOver;
    property OnTrainmanDblClick : TOnTrainmanDblClick read m_OnTrainmanDblClick
        write SetOnTrainmanDblClick;

    property OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver
        read m_OnTrainmanBeforeDragOver write SetOnTrainmanBeforeDragOver;

    property OnOrderGroupDragOver : TOnOrderGroupInTrainDragOver
        read m_OnOrderGroupInTrainDragOver write m_OnOrderGroupInTrainDragOver;
    property OnOrderGroupDblClick : TOnOrderGroupInTrainDblClick
        read m_OnOrderGroupInTrainDblClick write m_OnOrderGroupInTrainDblClick;

  end;


  TOrderGroupInTrainViewList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TOrderGroupInTrainView;
    procedure SetItem(Index: Integer; OrderGroupInTrainView: TOrderGroupInTrainView);
  public
    function Add(OrderGroupInTrainView: TOrderGroupInTrainView): Integer;
    property Items[Index: Integer]: TOrderGroupInTrainView read GetItem write SetItem; default;
  end;

implementation

{ TOrderGroupView }

procedure TOrderGroupInTrainView.Clone(view: TView);
var
  i:Integer;
begin
  inherited;
  for i := 0 to self.Childs.Count - 1 do
  begin
    self.Childs[i].Clone(TOrderGroupInTrainView(view).Childs[i]);
  end;
  self.m_OrderGroupInTrain := TOrderGroupInTrainView(view).m_OrderGroupInTrain;
end;

constructor TOrderGroupInTrainView.Create(vParent: TView);
begin
  inherited;
  Width := 60;
  Height := 476;

  TrainmanView1 := TTrainmanView.Create(self);
  TrainmanView1.OnViewChange := OnTrainmanViewChange;
  TrainmanView1.Left := 0;
  TrainmanView1.Top := 20;
  m_Childs.Add(TrainmanView1);

  TrainmanView2 := TTrainmanView.Create(self);
  TrainmanView2.OnViewChange := OnTrainmanViewChange;
  TrainmanView2.Left := 0;
  TrainmanView2.Top := TrainmanView1.Top + TrainmanView1.Height ;
  m_Childs.Add(TrainmanView2);

  TrainmanView3 := TTrainmanView.Create(self);
  TrainmanView3.OnViewChange := OnTrainmanViewChange;
  TrainmanView3.Left := 0;
  TrainmanView3.Top := TrainmanView2.Top + TrainmanView2.Height ;
  m_Childs.Add(TrainmanView3);

  TrainmanView4 := TTrainmanView.Create(self);
  TrainmanView4.OnViewChange := OnTrainmanViewChange;
  TrainmanView4.Left := 0;
  TrainmanView4.Top := TrainmanView3.Top + TrainmanView3.Height ;
  m_Childs.Add(TrainmanView4);
  //添加到Childs后，会自动free
end;

destructor TOrderGroupInTrainView.Destroy;
begin

  inherited;
end;
function TOrderGroupInTrainView.GetBKColor: TColor;
var
  nIndex:Integer;
begin
  result := CL_NP_BK_NORMAL;
  nIndex := GetGroupImageIndex(m_OrderGroupInTrain.Group);
  case nIndex of
    0: result :=  CL_NP_BK_NORMAL;
    1: result :=  CL_NP_BK_PLAN;
    2: result :=  CL_NP_BK_RUN;
  end;
  if Self.Selected then
    result := CL_NP_BK_SELECT;
  if self.DblClicked then
    result := CL_NP_BK_DBLCLICK;
  
  m_TitleFontColor := NP_FONT_TITLE_NORMAL;
  if result <> CL_NP_BK_NORMAL then
    m_TitleFontColor := NP_FONT_TITLE_SELECT
end;
procedure TOrderGroupInTrainView.DrawBackground(viewCanvas: TCanvas);
{功能:绘制背景}
var
  strText : String;
begin
  viewCanvas.Brush.Color := GetBKColor; 

  viewCanvas.FillRect(viewCanvas.ClipRect);
  //序号
  viewCanvas.Font.Color := m_TitleFontColor;
  viewCanvas.Font.Name := '宋体';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];
  strText := IntToStr(m_OrderGroupInTrain.nOrder);

  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

end;

procedure TOrderGroupInTrainView.DrawTrainmans(viewCanvas: TCanvas);
{功能:绘制乘务员信息}
var
  TrainmanBitmap : TBitmap;
begin
  TrainmanBitmap := TBitmap.Create;
  try
    TrainmanBitmap.Width := TrainmanView1.Width;
    TrainmanBitmap.Height := TrainmanView1.Height;

    //绘制乘务员1
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView1.GetRect);
    TrainmanView1.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView1.Left,TrainmanView1.Top,TrainmanBitmap);

    //绘制乘务员2
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView2.GetRect);
    TrainmanView2.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView2.Left,TrainmanView2.Top,TrainmanBitmap);

    //绘制乘务员3    
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView3.GetRect);
    TrainmanView3.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView3.Left,TrainmanView3.Top,TrainmanBitmap);

    //绘制乘务员4
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView4.GetRect);
    TrainmanView4.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView4.Left,TrainmanView4.Top,TrainmanBitmap);
  finally
    TrainmanBitmap.Free;
  end;
end;

procedure TOrderGroupInTrainView.getBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;

  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);

  DrawBackground(Bitmap.Canvas);
  DrawTrainmans(Bitmap.Canvas);

  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.CopyRect(viewBitmap.Canvas.ClipRect,
      Bitmap.Canvas,Bitmap.Canvas.ClipRect);

  Bitmap.free;
end;

function TOrderGroupInTrainView.GetGroupImageIndex(Group: RRsGroup): integer;
begin
  Result := 0;
  if Group.MinGroupState = tsPlaning then
    Result := 1;
  if Group.MinGroupState = tsRuning then
    result := 2; 
end;

function TOrderGroupInTrainView.GetTrainmanImageIndex(
  trainman: RRsTrainman): Integer;
var
  tm_index,group_index:Integer;
begin
  tm_index := 0;
  if trainman.strTrainmanGUID <> '' then
  begin
    if trainman.nTrainmanState = tsPlaning then
      tm_index := 1;
    if trainman.nTrainmanState = tsRuning then
      tm_index := 2;
  end;
  group_index := GetGroupImageIndex(m_OrderGroupInTrain.group) ;
  Result := group_index;
  Exit;
  if tm_index > group_index then
    Result := tm_index;
end;

procedure TOrderGroupInTrainView.OnTrainmanViewChange(View: TView);
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TOrderGroupInTrainView.ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
var
  nIndex:Integer;
begin
  nIndex := TOrderGroupInTrainView(s_TM_View.Parent).Childs.IndexOf(s_TM_View);
  case nIndex of
    0: m_OrderGroupInTrain.Group.Trainman1 := trainman;
    1: m_OrderGroupInTrain.Group.Trainman2 := trainman;
    2: m_OrderGroupInTrain.Group.Trainman3 := trainman;
    3: m_OrderGroupInTrain.Group.Trainman4 := trainman;
  end;
  //为了刷新
  Self.SetOrderGroup(m_OrderGroupInTrain);
end;

procedure TOrderGroupInTrainView.SetImages(pngImages: TPngImageCollection);
begin
  m_Images := pngImages;
  TrainmanView1.Images := pngImages;
  TrainmanView2.Images := pngImages;
  TrainmanView3.Images := pngImages;
  TrainmanView4.Images := pngImages;
end;

procedure TOrderGroupInTrainView.SetOnTrainmanBeforeDragOver(
  OnBeforeDragOver: TOnTrainmanBeforeDragOver);
begin
  m_OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView1.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView2.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView3.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView4.OnTrainmanBeforeDragOver := OnBeforeDragOver;
end;

procedure TOrderGroupInTrainView.SetOnTrainmanDragOver(
  OnDragOver: TOnTrainmanDragOver);
begin
  m_OnTrainmanDragOver := OnDragOver;
  TrainmanView1.OnTrainmanDragOver := OnDragOver;
  TrainmanView2.OnTrainmanDragOver := OnDragOver;
  TrainmanView3.OnTrainmanDragOver := OnDragOver;
  TrainmanView4.OnTrainmanDragOver := OnDragOver;
end;
procedure TOrderGroupInTrainView.SetOnTrainmanDblClick(
    OnTrainmanDblClick:TOnTrainmanDblClick);
begin
   m_OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView1.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView2.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView3.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView4.OnTrainmanDblClick := OnTrainmanDblClick;
end;

procedure TOrderGroupInTrainView.SetOrderGroup(AOrderGroupInTrain: RRsOrderGroupInTrain);
begin
  m_OrderGroupInTrain := AOrderGroupInTrain;
  BeginUpdate();
  TrainmanView1.Trainman := AOrderGroupInTrain.Group.Trainman1;
  TrainmanVIEW1.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView1.Trainman);

  TrainmanView2.Trainman := AOrderGroupInTrain.Group.Trainman2;
  TrainmanVIEW2.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView2.Trainman);

  TrainmanView3.Trainman := AOrderGroupInTrain.Group.Trainman3;
  TrainmanVIEW3.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView3.Trainman);
  
  TrainmanView4.Trainman := AOrderGroupInTrain.Group.Trainman4;
  TrainmanVIEW4.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView4.Trainman);
  EndUpdate();
  ViewChange();
end;

procedure TOrderGroupInTrainView.ViewDragDrop(View: TView);
begin
  inherited;
  if Assigned(m_OnOrderGroupInTrainDragOver) then
    m_OnOrderGroupInTrainDragOver(TOrderGroupInTrainView(self),TOrderGroupInTrainView(View));
end;

procedure TOrderGroupInTrainView.DblClick();
begin
  Inherited;
  if Assigned(m_OnOrderGroupInTrainDblClick) then
    m_OnOrderGroupInTrainDblClick(TOrderGroupInTrainView(self));
end;

{ TOrderGroupInTrainViewList }

function TOrderGroupInTrainViewList.Add(
  OrderGroupInTrainView: TOrderGroupInTrainView): Integer;
begin
  Result := inherited Add(OrderGroupInTrainView);
end;

function TOrderGroupInTrainViewList.GetItem(
  Index: Integer): TOrderGroupInTrainView;
begin
  Result := TOrderGroupInTrainView(inherited GetItem(Index));

end;

procedure TOrderGroupInTrainViewList.SetItem(Index: Integer;
  OrderGroupInTrainView: TOrderGroupInTrainView);
begin
  inherited SetItem(Index,OrderGroupInTrainView);
end;

end.
