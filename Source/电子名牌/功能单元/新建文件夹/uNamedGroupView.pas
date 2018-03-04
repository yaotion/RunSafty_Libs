unit uNamedGroupView;  //记名式

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uViewDefine;

Type

  TNamedGroupView = class;

  {轮乘信息拖拽事件}
  TOnNamedGroupDragOver = procedure(Sender:TNamedGroupView;
      NamedGroupView:TNamedGroupView)of object;
  {轮乘机组双击事件}
  TOnNamedGroupDblClick = procedure(Sender:TNamedGroupView)of object;

     //
  /////////////////////////////////////////////////////
  /// 类名:TOrderGroupView
  /// 说明:记名式交路内机班信息视图类
  /////////////////////////////////////////////////////
  TNamedGroupView = class(TView)
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
    {获得拖拽需要的Bitmap,默认还是使用getBitmap,可以继承修改}
    procedure getDragBitmap(viewBitmap:TBitmap);override;
    //交换人员
    procedure ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
    //科楼
    procedure Clone(view:TView);override;
  private
     //记名式交路内机班信息
    m_NamedGroup : RRsNamedGroup;
    {图片集}
    m_Images: TPngImageCollection;
    {乘务员拖拽放置事件}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    {乘务员双击事件}
    m_OnTrainmanDblClick:TOnTrainmanDblClick;

    {检查乘务员是否允许被放置}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {轮乘组拖拽事件}
    m_OnNamedGroupDragOver : TOnNamedGroupDragOver;  
    {轮乘组双击事件}
    m_OnNamedGroupDblClick : TOnNamedGroupDblClick;
    //标题字体颜色
    m_TitleFontColor:TColor;
  protected
    property OnViewChange;
  private
    {功能:绘制背景}
    procedure DrawBackground(viewCanvas : TCanvas);
    {功能:绘制车次}
    procedure DrawTitle(viewCanvas : TCanvas);
    {功能:获取背景色}
    function GetBKColor():TColor;
    {功能:绘制乘务员信息}
    procedure DrawTrainmans(viewCanvas : TCanvas);
  private
    {功能:乘务员信息变动}
    procedure OnTrainmanViewChange(View : TView);
    {功能:设置轮乘信息}
    procedure SetNamedGroup(ANamedGroup : RRsNamedGroup);
    {功能:设置图片集}
    procedure SetImages(pngImages : TPngImageCollection);
    procedure SetOnTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetOnTrainmanDblClick(OnDblClick:TOnTrainmanDblClick);
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
    //设置RRsNamedGroup中的nCheciOrder
    procedure SetNamedGroupOrder(nOrder: integer);

    property NamedGroup : RRsNamedGroup read m_NamedGroup write SetNamedGroup;
    property Images : TPngImageCollection read m_Images write SetImages;
    property OnTrainmanDragOver : TOnTrainmanDragOver read m_OnTrainmanDragOver
        write SetOnTrainmanDragOver;
    property OnTrainmanDblClick:TOnTrainmanDblClick read m_OnTrainmanDblClick
        write SetOnTrainmanDblClick;

    property OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver
        read m_OnTrainmanBeforeDragOver write SetOnTrainmanBeforeDragOver;

    property OnNamedGroupDragOver : TOnNamedGroupDragOver
        read m_OnNamedGroupDragOver write m_OnNamedGroupDragOver;
    property OnNamedGroupDblClick : TOnNamedGroupDblClick
        read m_OnNamedGroupDblClick write m_OnNamedGroupDblClick;
  end;

implementation

{ TOrderGroupView }

procedure TNamedGroupView.Clone(view: TView);
begin
  inherited Clone(view);
  self.TrainmanView1.Clone(TNamedGroupView(view).Childs[0]);
  self.TrainmanView2.Clone(TNamedGroupView(view).Childs[1]);
  self.TrainmanView3.Clone(TNamedGroupView(view).Childs[2]);
  self.TrainmanView4.Clone(TNamedGroupView(view).Childs[3]);
  self.NamedGroup := TNamedGroupView(view).NamedGroup;
end;

constructor TNamedGroupView.Create(vParent: TView);
begin
  inherited;
  Width := 60;
  Height := 518;
  TrainmanView1 := TTrainmanView.Create(self);
  TrainmanView1.OnViewChange := OnTrainmanViewChange;
  TrainmanView1.Left := 0;
  TrainmanView1.Top := 60;
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
  
  ActionTypeSet := [atMouse,atSelected];
  //添加到Childs后，会自动free
end;

destructor TNamedGroupView.Destroy;
begin

  inherited;
end;
function TNamedGroupView.GetBKColor():TColor;
var
  nIndex:Integer;
begin
  result := CL_NP_BK_NORMAL;
  nIndex := GetGroupImageIndex(m_NamedGroup.Group);
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

procedure TNamedGroupView.DrawBackground(viewCanvas: TCanvas);
{功能:绘制背景}
begin
  viewCanvas.Brush.Color := GetBKColor();

  viewCanvas.FillRect(viewCanvas.ClipRect);
end;

procedure TNamedGroupView.DrawTitle(viewCanvas: TCanvas);
{功能:绘制车次}
var
  strText : String;
begin
  //序号
  viewCanvas.Font.color := m_TitleFontColor;
  viewCanvas.Font.Name := '宋体';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];
  strText := IntToStr(m_NamedGroup.nCheciOrder);

  //绘制序号
  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

  if (m_NamedGroup.nCheciType = cctCheci) then
  begin
    //绘制车次1
    strText := m_NamedGroup.strCheci1;
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,24,strText);

    //绘制车次2
    strText := m_NamedGroup.strCheci2;
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,40,strText);
  end
  else
  begin
    strText := '休';
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,24,strText);
  end;

end;

procedure TNamedGroupView.DrawTrainmans(viewCanvas: TCanvas);
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

procedure TNamedGroupView.ExChangeTrainman(s_TM_View:TTrainmanView;
  trainman:RRsTrainman);
var
  nIndex:Integer;
begin
  nIndex := TNamedGroupView(s_TM_View.Parent).Childs.IndexOf(s_TM_View);
  case nIndex of
    0: m_NamedGroup.Group.Trainman1 := trainman;
    1: m_NamedGroup.Group.Trainman2 := trainman;
    2: m_NamedGroup.Group.Trainman3 := trainman;
    3: m_NamedGroup.Group.Trainman4 := trainman;
  end;
  //为了刷新
  Self.SetNamedGroup(m_NamedGroup);
end;

procedure TNamedGroupView.getBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;

  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);

  DrawBackground(Bitmap.Canvas);
  DrawTitle(Bitmap.Canvas);
  DrawTrainmans(Bitmap.Canvas);

  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.CopyRect(viewBitmap.Canvas.ClipRect,
      Bitmap.Canvas,Bitmap.Canvas.ClipRect);
      
  Bitmap.free;
end;


procedure TNamedGroupView.getDragBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
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
  finally
    Bitmap.Free;
  end;


end;
function TNamedGroupView.GetTrainmanImageIndex(trainman:RRsTrainman):Integer;
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
  group_index := GetGroupImageIndex(m_NamedGroup.group) ;
  Result := group_index;
  Exit;
  if tm_index > group_index then
    Result := tm_index;
end;

function TNamedGroupView.GetGroupImageIndex(Group: RRsGroup): integer;
begin
  Result := 0;
  if Group.MinGroupState = tsPlaning then
    Result := 1;
  if Group.MinGroupState = tsRuning then
    result := 2;
//  if Self.DblClicked = true then
//    result := 3;
end;

procedure TNamedGroupView.OnTrainmanViewChange(View: TView);
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TNamedGroupView.SetImages(pngImages: TPngImageCollection);
begin
  m_Images := pngImages;
  TrainmanView1.Images := pngImages;
  TrainmanView2.Images := pngImages;
  TrainmanView3.Images := pngImages;
  TrainmanView4.Images := pngImages;
end;

procedure TNamedGroupView.SetOnTrainmanBeforeDragOver(
  OnBeforeDragOver: TOnTrainmanBeforeDragOver);
begin
  m_OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView1.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView2.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView3.OnTrainmanBeforeDragOver := OnBeforeDragOver;
  TrainmanView4.OnTrainmanBeforeDragOver := OnBeforeDragOver;
end;

procedure TNamedGroupView.SetOnTrainmanDragOver(
  OnDragOver: TOnTrainmanDragOver);
begin
  m_OnTrainmanDragOver := OnDragOver;
  TrainmanView1.OnTrainmanDragOver := OnDragOver;
  TrainmanView2.OnTrainmanDragOver := OnDragOver;
  TrainmanView3.OnTrainmanDragOver := OnDragOver;
  TrainmanView4.OnTrainmanDragOver := OnDragOver;  
end;

procedure TNamedGroupView.SetOnTrainmanDblClick(OnDblClick:TOnTrainmanDblClick);
begin
  m_OnTrainmanDblClick := OnDblClick;
  TrainmanView1.OnTrainmanDblClick := OnDblClick;
  TrainmanView2.OnTrainmanDblClick := OnDblClick;
  TrainmanView3.OnTrainmanDblClick := OnDblClick;
  TrainmanView4.OnTrainmanDblClick := OnDblClick;
end;

procedure TNamedGroupView.SetNamedGroup(ANamedGroup: RRsNamedGroup);
begin
  m_NamedGroup := ANamedGroup;
  BeginUpdate();
  TrainmanView1.Trainman := ANamedGroup.Group.Trainman1;
    TrainmanVIEW1.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView1.Trainman);
  TrainmanView2.Trainman := ANamedGroup.Group.Trainman2;
    TrainmanVIEW2.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView2.Trainman);
  TrainmanView3.Trainman := ANamedGroup.Group.Trainman3;
    TrainmanVIEW3.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView3.Trainman);
  TrainmanView4.Trainman := ANamedGroup.Group.Trainman4;
    TrainmanVIEW4.BackgroundImageIndex := GetTrainmanImageIndex(TrainmanView4.Trainman);
  EndUpdate();
  ViewChange();
end;

procedure TNamedGroupView.ViewDragDrop(View: TView);
begin
  inherited;
  if Assigned(m_OnNamedGroupDragOver) then
    m_OnNamedGroupDragOver(TNamedGroupView(self),TNamedGroupView(View));
end;

procedure TNamedGroupView.DblClick();
begin
  inherited;
  if Assigned(m_OnNamedGroupDblClick) then
    m_OnNamedGroupDblClick(TNamedGroupView(self));
end;
  
procedure TNamedGroupView.SetNamedGroupOrder(nOrder: integer);
begin
  m_NamedGroup.nCheciOrder := nOrder;
end;

end.

