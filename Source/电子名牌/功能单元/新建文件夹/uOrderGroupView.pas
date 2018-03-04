unit uOrderGroupView;   //轮乘机组

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uViewDefine;

Type

  TOrderGroupView = class;

  {轮乘信息拖拽事件}
  TOnOrderGroupDragOver = procedure(Sender:TOrderGroupView;
      OrderGroupView:TOrderGroupView)of object;
  {轮乘信息双击事件}
  TOnOrderGroupDblClick = procedure(Sender:TOrderGroupView)of object;
      
  /////////////////////////////////////////////////////
  /// 类名:TOrderGroupView
  /// 说明:轮乘信息
  /////////////////////////////////////////////////////
  TOrderGroupView = class(TView)
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
    //更换人员
    procedure ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
    //克隆
    procedure Clone(view:TView);override;
  private
     //轮乘交路内机班信息
    m_OrderGroup : RRsOrderGroup;
    {图片集}
    m_Images: TPngImageCollection;
    {乘务员拖拽放置事件}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    {乘务员双击事件}
    m_OnTrainmanDblClick:TOnTrainmanDblClick;
    {检查乘务员是否允许被放置}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {轮乘组拖拽事件}
    m_OnOrderGroupDragOver : TOnOrderGroupDragOver;
    {轮乘组双击事件}
    m_OnOrderGroupDblClick:TOnOrderGroupDblClick;
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
    procedure SetOrderGroup(AOrderGroup : RRsOrderGroup);
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
    //设置RRsOrderGroup中的nOrder
    procedure SetOrderGroupOrder(nOrder: integer);

    property OrderGroup : RRsOrderGroup read m_OrderGroup write SetOrderGroup;
    property Images : TPngImageCollection read m_Images write SetImages;
    property OnTrainmanDragOver : TOnTrainmanDragOver read m_OnTrainmanDragOver
        write SetOnTrainmanDragOver;
    property OnTrainmanDblClick : TOnTrainmanDblClick read m_OnTrainmanDblClick
        write SetOnTrainmanDblClick;


    property OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver
        read m_OnTrainmanBeforeDragOver write SetOnTrainmanBeforeDragOver;

    property OnOrderGroupDragOver : TOnOrderGroupDragOver
        read m_OnOrderGroupDragOver write m_OnOrderGroupDragOver;
    property OnOrderGroupDblClick : TOnOrderGroupDblClick
        read m_OnOrderGroupDblClick write m_OnOrderGroupDblClick;
  end;

implementation

{ TOrderGroupView }

procedure TOrderGroupView.Clone(view: TView);
var
  i:Integer;
begin
  inherited;
  for i := 0 to self.Childs.Count - 1 do
  begin
    self.Childs[i].Clone(TOrderGroupView(view).Childs[i]);
  end;
  self.m_OrderGroup := TOrderGroupView(view).OrderGroup;
end;

constructor TOrderGroupView.Create(vParent: TView);
begin
  inherited;
  Width := 60;
  Height := 477;
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

destructor TOrderGroupView.Destroy;
begin
  inherited;
end;
function TOrderGroupView.GetBKColor():TColor;
var
  nIndex:Integer;
begin
  result := CL_NP_BK_NORMAL;
  nIndex := GetGroupImageIndex(m_OrderGroup.Group);
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
procedure TOrderGroupView.DrawBackground(viewCanvas: TCanvas);
{功能:绘制背景}
var
  strText : String;
begin

  viewCanvas.Brush.Color := GetBKColor();

  viewCanvas.FillRect(viewCanvas.ClipRect);
  //序号
  viewCanvas.Font.Color := m_TitleFontColor;
  viewCanvas.Font.Name := '宋体';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];

  strText := IntToStr(m_OrderGroup.nOrder);

  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

end;

procedure TOrderGroupView.DrawTrainmans(viewCanvas: TCanvas);
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

procedure TOrderGroupView.getBitmap(viewBitmap: TBitmap);
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

  Bitmap.Free;
end;


function TOrderGroupView.GetGroupImageIndex(Group: RRsGroup): integer;
begin
  Result := 0;
  if Group.MinGroupState = tsPlaning then
    Result := 1;
  if Group.MinGroupState = tsRuning then
    result := 2;  
end;

function TOrderGroupView.GetTrainmanImageIndex(trainman: RRsTrainman): Integer;
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
  group_index := GetGroupImageIndex(m_OrderGroup.group) ;
  Result := group_index;
  Exit;
  if tm_index > group_index then
    Result := tm_index;
end;

procedure TOrderGroupView.OnTrainmanViewChange(View: TView);
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TOrderGroupView.ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
var
  nIndex:Integer;
begin
  nIndex := TOrderGroupView(s_TM_View.Parent).Childs.IndexOf(s_TM_View);
  case nIndex of
    0: m_OrderGroup.Group.Trainman1 := trainman;
    1: m_OrderGroup.Group.Trainman2 := trainman;
    2: m_OrderGroup.Group.Trainman3 := trainman;
    3: m_OrderGroup.Group.Trainman4 := trainman;
  end;
  //为了刷新
  Self.SetOrderGroup(m_OrderGroup);
end;

procedure TOrderGroupView.SetImages(pngImages: TPngImageCollection);
begin
  m_Images := pngImages;
  TrainmanView1.Images := pngImages;
  TrainmanView2.Images := pngImages;
  TrainmanView3.Images := pngImages;
  TrainmanView4.Images := pngImages;
end;

procedure TOrderGroupView.SetOnTrainmanBeforeDragOver(
  OnBeforeDragOver: TOnTrainmanBeforeDragOver);
begin
  m_OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView1.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView2.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView3.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView4.OnTrainmanBeforeDragOver := OnBeforeDragOver;
end;

procedure TOrderGroupView.SetOnTrainmanDragOver(
  OnDragOver: TOnTrainmanDragOver);
begin
  m_OnTrainmanDragOver := OnDragOver;
  TrainmanView1.OnTrainmanDragOver := OnDragOver;
  TrainmanView2.OnTrainmanDragOver := OnDragOver;
  TrainmanView3.OnTrainmanDragOver := OnDragOver;
  TrainmanView4.OnTrainmanDragOver := OnDragOver;
end;
procedure TOrderGroupView.SetOnTrainmanDblClick(OnTrainmanDblClick:TOnTrainmanDblClick);
begin
  m_OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView1.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView2.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView3.OnTrainmanDblClick := OnTrainmanDblClick;
  TrainmanView4.OnTrainmanDblClick := OnTrainmanDblClick;
end;

procedure TOrderGroupView.SetOrderGroup(AOrderGroup: RRsOrderGroup);
begin
  m_OrderGroup := AOrderGroup;
  BeginUpdate();
  TrainmanView1.Trainman := AOrderGroup.Group.Trainman1;
    TrainmanVIEW1.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView1.Trainman);

  TrainmanView2.Trainman := AOrderGroup.Group.Trainman2;
  TrainmanVIEW2.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView2.Trainman);

  TrainmanView3.Trainman := AOrderGroup.Group.Trainman3;
  TrainmanVIEW3.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView3.Trainman);

  TrainmanView4.Trainman := AOrderGroup.Group.Trainman4;
  TrainmanVIEW4.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView4.Trainman);
  
  EndUpdate();
  ViewChange();
end;

procedure TOrderGroupView.SetOrderGroupOrder(nOrder: integer);
begin
  m_OrderGroup.nOrder := nOrder;
end;

procedure TOrderGroupView.ViewDragDrop(View: TView);
begin
  inherited;
  if Assigned(m_OnOrderGroupDragOver) then
    m_OnOrderGroupDragOver(TOrderGroupView(self),TOrderGroupView(View));
end;
procedure TOrderGroupView.DblClick();
begin
  inherited;
  if Assigned(m_OnOrderGroupDblClick) then
    m_OnOrderGroupDblClick(TOrderGroupView(self));
end;

end.

