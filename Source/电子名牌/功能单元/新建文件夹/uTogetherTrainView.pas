unit uTogetherTrainView; //包乘机车

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uOrderGroupInTrainView,
    uViewDefine;

type

  TTogetherTrainView = class;

  {有包承组拖到包乘信息中}
  TOnOrderGroupInTogetherTrain = procedure(
      TogetherTrainView : TTogetherTrainView;
      OrderGroupInTrainView : TOrderGroupInTrainView) of Object;

//  {有包组放入}
//  TOnTogetherTrainViewDragDrop = procedure(
//      Sender,TogetherTrainView:TTogetherTrainView) of Object;
  /////////////////////////////////////////////////////
  /// 类名:TTogetherTrainView
  /// 说明:包乘信息
  /////////////////////////////////////////////////////
  TTogetherTrainView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
    destructor Destroy();override;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    {功能:设置乘务员背景图片索引}
    procedure SetTrainmanBackgroundImageIndex(Trainman:RRsTrainman;
        nImageIndex:Integer);
  private
    //包乘信息
    m_TogetherTrain : RRsTogetherTrain;
    {图片集}
    m_Images: TPngImageCollection;
    {乘务员放下通知}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    //乘务员双击
    m_OnTrainmanDblClick:TOnTrainmanDblClick;
    
    {有包乘组放入本包乘信息中 }
    m_OnOrderGroupInTogetherTrain : TOnOrderGroupInTogetherTrain;
    {有包乘租拖拽}
    m_OnOrderGroupInTrainDragOver : TOnOrderGroupInTrainDragOver;
    {有包乘租双击}
    m_OnOrderGroupInTrainDblClick : TOnOrderGroupInTrainDblClick;
  private
    {功能:设置图片集}
    procedure SetImages(pngImages : TPngImageCollection);
    {功能:包乘组信息变动}
    procedure OrderGroupInTrain(View:TView);
    procedure SetTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetTrainmanDblClick(OnTrainmanDblClick:TOnTrainmanDblClick);
    procedure SetOnOrderGroupInTrainDragOver(
        OnDragOver:TOnOrderGroupInTrainDragOver);
    procedure SetOnOrderGroupInTrainDblClick(
        OnDblClick:TOnOrderGroupInTrainDblClick);
  protected
    {功能:检查是否允许放下}
    function CheckViewDrop(View:TView):Boolean;override;
    {功能:绘制背景}
    procedure DrawBackground(viewCanvas : TCanvas);
    {功能:绘制包乘组信息}
    procedure DrawOrderGroupInTrains(viewCanvas : TCanvas);
    procedure ViewDragDrop(View:TView);override;
  private
    {功能:设置包乘信息}
    procedure SetTogetherTrain(ATogetherTrain : RRsTogetherTrain);
    {功能:返回标题宽度}
    function GetTitleTextWidth():Integer;
  public
    property TogetherTrain : RRsTogetherTrain read m_TogetherTrain
        write SetTogetherTrain;
    property Images: TPngImageCollection read m_Images write SetImages;

    property OnTrainmanDragOver : TOnTrainmanDragOver read m_OnTrainmanDragOver
        write SetTrainmanDragOver;
    property OnTrainmanDblClick : TOnTrainmanDblClick read m_OnTrainmanDblClick
        write SetTrainmanDblClick;

    property OnOrderGroupInTogetherTrain : TOnOrderGroupInTogetherTrain
        read m_OnOrderGroupInTogetherTrain write m_OnOrderGroupInTogetherTrain;

    property OnOrderGroupInTrainDragOver : TOnOrderGroupInTrainDragOver write
        SetOnOrderGroupInTrainDragOver;
    property OnOrderGroupInTrainDblClick : TOnOrderGroupInTrainDblClick write
        SetOnOrderGroupInTrainDblClick;
  end;

implementation

{ TTogetherTrainView }

function TTogetherTrainView.CheckViewDrop(View: TView): Boolean;
begin
  Result := False;
//  if (View.ClassName <> 'TOrderGroupInTrainView') then Exit;
//  //不能自己拖到自己的包乘信息中
//  if (View.Parent = self) then Exit;
//
//
//  Result := True;
end;

constructor TTogetherTrainView.Create(vParent: TView);
begin
  inherited;
  ActionTypeSet := [atMouse{鼠标操作},atClick{点击},atDragDrop{放下},atSelected];
  Height := 514; //512;
  Width := 100;//默认高度，实际高度要看绘制的时候
end;

destructor TTogetherTrainView.Destroy;
begin
  inherited;
end;

procedure TTogetherTrainView.DrawBackground(viewCanvas: TCanvas);
{功能:绘制背景}
var
  strText : String;
  nTextWidth : Integer;
  X : Integer;
  contentRect:TRect;
begin
  //绘制背景
  viewCanvas.Brush.Color := CL_NP_BK_NORMAL;
  if Self.Selected then
    viewCanvas.Brush.Color := CL_NP_BK_SELECT;
  viewCanvas.FillRect(viewCanvas.ClipRect);
  viewCanvas.FrameRect(viewCanvas.ClipRect);

  //文字 车型车号
  viewCanvas.Font.Color := NP_FONT_TITLE_NORMAL;
  if Self.Selected then
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;

    viewCanvas.Font.Name := '宋体';
  viewCanvas.Font.Size := 11;
  viewCanvas.Font.Style := [fsBold];
  strText := m_TogetherTrain.strTrainTypeName + '-'+
      m_TogetherTrain.strTrainNumber;
  nTextWidth := viewCanvas.TextWidth(strText);
  X := (Width  - nTextWidth) div 2;
  viewCanvas.TextOut(X,6,strText);

  //机组区域背景
  contentRect := viewCanvas.ClipRect;
  contentRect.Top := contentRect.Top + 26;
  InflateRect(contentRect,-2,-2);
  viewCanvas.Brush.Color := CL_NP_BK_CONTENT;
  viewCanvas.FillRect(contentRect);

end;

procedure TTogetherTrainView.DrawOrderGroupInTrains(viewCanvas: TCanvas);
{功能:绘制包乘组信息}
var
  i : Integer;
  ChlidBitmap : TBitmap;
  view : TOrderGroupInTrainView;
begin
  ChlidBitmap := TBitmap.Create;
  try
    for I := 0 to m_Childs.Count - 1 do
    begin
      view := TOrderGroupInTrainView(m_Childs.Items[i]);
      if Self.Selected then
        view.Selected := self.Selected;
      ChlidBitmap.Width := view.Width;
      ChlidBitmap.Height := view.Height;

      ChlidBitmap.Canvas.CopyRect(ChlidBitmap.Canvas.ClipRect,
          viewCanvas,view.GetRect);
      view.getBitmap(ChlidBitmap);
      viewCanvas.Draw(view.Left,view.Top,ChlidBitmap);
    end;
  finally
    ChlidBitmap.Free;
  end;
end;

procedure TTogetherTrainView.getBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  inherited;
  Bitmap := TBitmap.Create;
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);

  DrawBackground(Bitmap.Canvas);
  DrawOrderGroupInTrains(Bitmap.Canvas);

  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.CopyRect(viewBitmap.Canvas.ClipRect,
      Bitmap.Canvas,Bitmap.Canvas.ClipRect);
  Bitmap.Free;
end;

function TTogetherTrainView.GetTitleTextWidth: Integer;
{功能:返回标题宽度}
var
  strText : String;
  Bitmap : TBitmap;
begin
  strText :=
      m_TogetherTrain.strTrainTypeName + ' - ' + m_TogetherTrain.strTrainNumber;

  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Width;
    Bitmap.Height := height;
    Bitmap.Canvas.Font.Name := '宋体';
    Bitmap.Canvas.Font.Size := 11;
    Bitmap.Canvas.Font.Style := [fsBold];

    Result := Bitmap.Canvas.TextWidth(strText);

  finally
    Bitmap.Free;
  end;


end;

procedure TTogetherTrainView.OrderGroupInTrain(View: TView);
{功能:包乘组信息变动}
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TTogetherTrainView.SetImages(pngImages: TPngImageCollection);
{功能:设置图片集}
var
  i : Integer;
begin
  m_Images := pngImages;
  for I := 0 to m_Childs.Count - 1 do
    TOrderGroupInTrainView(m_Childs.Items[i]).Images := pngImages;
end;
procedure TTogetherTrainView.SetOnOrderGroupInTrainDblClick(
        OnDblClick:TOnOrderGroupInTrainDblClick);
var
  i : Integer;
begin
  m_OnOrderGroupInTrainDblClick := OnDblClick;
  for I := 0 to m_Childs.Count - 1 do
    TOrderGroupInTrainView(m_Childs.Items[i]).OnOrderGroupDblCLick := OnDblClick;
end;
procedure TTogetherTrainView.SetOnOrderGroupInTrainDragOver(
  OnDragOver: TOnOrderGroupInTrainDragOver);
var
  i : Integer;
begin
  m_OnOrderGroupInTrainDragOver := OnDragOver;
  for I := 0 to m_Childs.Count - 1 do
    TOrderGroupInTrainView(m_Childs.Items[i]).OnOrderGroupDragOver := OnDragOver;
end;

procedure TTogetherTrainView.SetTogetherTrain(ATogetherTrain: RRsTogetherTrain);
var
  i,nLeft : Integer;
  nChildsWidth : Integer;
  OrderGroupView : TOrderGroupInTrainView;
begin
  BeginUpdate;
  m_Childs.Clear;
  m_TogetherTrain := ATogetherTrain;
  nChildsWidth := 0;
  nLeft := 6;
  for I := 0 to length(m_TogetherTrain.Groups) - 1 do
  begin
    OrderGroupView := TOrderGroupInTrainView.Create(self);
    OrderGroupView.onViewChange := OrderGroupInTrain;
    OrderGroupView.OnTrainmanDragOver := m_OnTrainmanDragOver;
    OrderGroupView.Images := Images;
    OrderGroupView.OrderGroupInTrain := m_TogetherTrain.Groups[i];
    OrderGroupView.Top := 32;
    OrderGroupView.Left := nLeft;
    nLeft := nLeft  + OrderGroupView.Width + 4;
    nChildsWidth := nChildsWidth + OrderGroupView.Width + 4;//4个像素的间隔
    m_Childs.Add(OrderGroupView);
  end;

  if nChildsWidth < GetTitleTextWidth() then
  begin
    for I := 0 to m_Childs.Count - 1 do
    begin
      m_Childs.Items[i].Left := (GetTitleTextWidth() - nChildsWidth) div 2 + 4;
    end;

    nChildsWidth := GetTitleTextWidth();
  end;

  Width := nChildsWidth + 8;
  //通知重新计算位置
  if Assigned(m_OnNeedReComposition) then
    m_OnNeedReComposition(self);
  EndUpdate();
  ViewChange;
end;

procedure TTogetherTrainView.SetTrainmanBackgroundImageIndex(
  Trainman: RRsTrainman; nImageIndex:Integer);
{功能:设置乘务员背景图片索引}
var
  i : Integer;
  OrderGroupInTrainView : TOrderGroupInTrainView;
begin
  for I := 0 to m_Childs.Count - 1 do
  begin
    OrderGroupInTrainView := TOrderGroupInTrainView(m_Childs.Items[i]);
    if (OrderGroupInTrainView.TrainmanView1.Trainman.strTrainmanGUID =
        Trainman.strTrainmanGUID) then
    begin
      OrderGroupInTrainView.TrainmanView1.BackgroundImageIndex := nImageIndex;
      Break;
    end;

    if (OrderGroupInTrainView.TrainmanView2.Trainman.strTrainmanGUID =
        Trainman.strTrainmanGUID) then
    begin
      OrderGroupInTrainView.TrainmanView2.BackgroundImageIndex := nImageIndex;
      Break;
    end;

    if (OrderGroupInTrainView.TrainmanView3.Trainman.strTrainmanGUID =
        Trainman.strTrainmanGUID) then
    begin
      OrderGroupInTrainView.TrainmanView3.BackgroundImageIndex := nImageIndex;
      Break;
    end;


  end;
    

end;
procedure TTogetherTrainView.SetTrainmanDblClick(
    OnTrainmanDblClick:TOnTrainmanDblClick);
var
  i : Integer;
begin
  m_OnTrainmanDblClick := OnTrainmanDblClick;
  for I := 0 to m_Childs.Count - 1 do
  begin
    TOrderGroupInTrainView(m_Childs.Items[i]).OnTrainmanDblClick := OnTrainmanDblClick;
  end;

end;
procedure TTogetherTrainView.SetTrainmanDragOver(
  OnDragOver: TOnTrainmanDragOver);
var
  i : Integer;
begin
  m_OnTrainmanDragOver := OnDragOver;
  for I := 0 to m_Childs.Count - 1 do
  begin
    TOrderGroupInTrainView(m_Childs.Items[i]).OnTrainmanDragOver := OnDragOver;
  end;

end;

procedure TTogetherTrainView.ViewDragDrop(View: TView);
begin
  if View.ClassName = TOrderGroupInTrainView.ClassName then
  begin
    //有包乘组拖进来了
    if Assigned(m_OnOrderGroupInTogetherTrain) then
      m_OnOrderGroupInTogetherTrain(self,TOrderGroupInTrainView(View));
    
  end;
  

end;

end.
