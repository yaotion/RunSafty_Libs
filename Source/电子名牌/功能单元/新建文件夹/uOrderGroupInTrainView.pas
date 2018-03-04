unit uOrderGroupInTrainView; //���˻����ڵĻ���

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,Contnrs,uViewDefine ;

Type

  TOrderGroupInTrainView = class;

  {��������Ϣ��ק�¼�}
  TOnOrderGroupInTrainDragOver = procedure(Sender:TOrderGroupInTrainView;
      OrderGroupInTrainView:TOrderGroupInTrainView)of object;
  {��������Ϣ˫���¼�}
  TOnOrderGroupInTrainDblClick = procedure(Sender:TOrderGroupInTrainView)of object;

  /////////////////////////////////////////////////////
  /// ����:TOrderGroupInTrainView
  /// ˵��:��������Ϣ
  /////////////////////////////////////////////////////
  TOrderGroupInTrainView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
    destructor Destroy();override;
  public
    {����Ա1}
    TrainmanView1 : TTrainmanView;
    {����Ա2}
    TrainmanView2 : TTrainmanView;
    {����Ա3}
    TrainmanView3 : TTrainmanView;
    {����Ա4}
    TrainmanView4 : TTrainmanView;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    //������Ա
    procedure ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
    //��¡
    procedure Clone(view:TView);override;
  private
     //���˽�·�ڻ�����Ϣ
    m_OrderGroupInTrain : RRsOrderGroupInTrain;
    {ͼƬ��}
    m_Images: TPngImageCollection;
    {����Ա��ק�����¼�}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    //����Ա˫���¼�
    m_OnTrainmanDblClick:TOnTrainmanDblClick;
    {������Ա�Ƿ���������}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {��������ק�¼�}
    m_OnOrderGroupInTrainDragOver : TOnOrderGroupInTrainDragOver;
    //���˻���˫���¼�
    m_OnOrderGroupInTrainDblClick:TOnOrderGroupInTrainDblClick;
    //������ɫ
    m_TitleFontColor:TColor;
  protected
    property OnViewChange;
  private
    {����:��ȡ����ɫ}
    function GetBKColor():TColor;
    {����:���Ʊ���}
    procedure DrawBackground(viewCanvas : TCanvas);
    {����:���Ƴ���Ա��Ϣ}
    procedure DrawTrainmans(viewCanvas : TCanvas);
  private
    {����:����Ա��Ϣ�䶯}
    procedure OnTrainmanViewChange(View : TView);
    {����:�����ֳ���Ϣ}
    procedure SetOrderGroup(AOrderGroupInTrain : RRsOrderGroupInTrain);
    {����:����ͼƬ��}
    procedure SetImages(pngImages : TPngImageCollection);
    procedure SetOnTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetOnTrainmanDblClick(OnTrainmanDblClick:TOnTrainmanDblClick);
    procedure SetOnTrainmanBeforeDragOver(
        OnBeforeDragOver:TOnTrainmanBeforeDragOver);

  protected
    procedure ViewDragDrop(View:TView);override;
    procedure DblClick();override;
    //��ȡ�������ɫ��Ϣ
    function GetGroupImageIndex(Group : RRsGroup):integer;
    //��ȡ��Ա����ɫ��Ϣ
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
  //��ӵ�Childs�󣬻��Զ�free
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
{����:���Ʊ���}
var
  strText : String;
begin
  viewCanvas.Brush.Color := GetBKColor; 

  viewCanvas.FillRect(viewCanvas.ClipRect);
  //���
  viewCanvas.Font.Color := m_TitleFontColor;
  viewCanvas.Font.Name := '����';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];
  strText := IntToStr(m_OrderGroupInTrain.nOrder);

  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

end;

procedure TOrderGroupInTrainView.DrawTrainmans(viewCanvas: TCanvas);
{����:���Ƴ���Ա��Ϣ}
var
  TrainmanBitmap : TBitmap;
begin
  TrainmanBitmap := TBitmap.Create;
  try
    TrainmanBitmap.Width := TrainmanView1.Width;
    TrainmanBitmap.Height := TrainmanView1.Height;

    //���Ƴ���Ա1
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView1.GetRect);
    TrainmanView1.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView1.Left,TrainmanView1.Top,TrainmanBitmap);

    //���Ƴ���Ա2
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView2.GetRect);
    TrainmanView2.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView2.Left,TrainmanView2.Top,TrainmanBitmap);

    //���Ƴ���Ա3    
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,TrainmanView3.GetRect);
    TrainmanView3.getBitmap(TrainmanBitmap);
    viewCanvas.Draw(TrainmanView3.Left,TrainmanView3.Top,TrainmanBitmap);

    //���Ƴ���Ա4
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
  //Ϊ��ˢ��
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
