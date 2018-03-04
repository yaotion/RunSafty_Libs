unit uNamedGroupView;  //����ʽ

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uViewDefine;

Type

  TNamedGroupView = class;

  {�ֳ���Ϣ��ק�¼�}
  TOnNamedGroupDragOver = procedure(Sender:TNamedGroupView;
      NamedGroupView:TNamedGroupView)of object;
  {�ֳ˻���˫���¼�}
  TOnNamedGroupDblClick = procedure(Sender:TNamedGroupView)of object;

     //
  /////////////////////////////////////////////////////
  /// ����:TOrderGroupView
  /// ˵��:����ʽ��·�ڻ�����Ϣ��ͼ��
  /////////////////////////////////////////////////////
  TNamedGroupView = class(TView)
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
    {�����ק��Ҫ��Bitmap,Ĭ�ϻ���ʹ��getBitmap,���Լ̳��޸�}
    procedure getDragBitmap(viewBitmap:TBitmap);override;
    //������Ա
    procedure ExChangeTrainman(s_TM_View:TTrainmanView;trainman:RRsTrainman);
    //��¥
    procedure Clone(view:TView);override;
  private
     //����ʽ��·�ڻ�����Ϣ
    m_NamedGroup : RRsNamedGroup;
    {ͼƬ��}
    m_Images: TPngImageCollection;
    {����Ա��ק�����¼�}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    {����Ա˫���¼�}
    m_OnTrainmanDblClick:TOnTrainmanDblClick;

    {������Ա�Ƿ���������}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {�ֳ�����ק�¼�}
    m_OnNamedGroupDragOver : TOnNamedGroupDragOver;  
    {�ֳ���˫���¼�}
    m_OnNamedGroupDblClick : TOnNamedGroupDblClick;
    //����������ɫ
    m_TitleFontColor:TColor;
  protected
    property OnViewChange;
  private
    {����:���Ʊ���}
    procedure DrawBackground(viewCanvas : TCanvas);
    {����:���Ƴ���}
    procedure DrawTitle(viewCanvas : TCanvas);
    {����:��ȡ����ɫ}
    function GetBKColor():TColor;
    {����:���Ƴ���Ա��Ϣ}
    procedure DrawTrainmans(viewCanvas : TCanvas);
  private
    {����:����Ա��Ϣ�䶯}
    procedure OnTrainmanViewChange(View : TView);
    {����:�����ֳ���Ϣ}
    procedure SetNamedGroup(ANamedGroup : RRsNamedGroup);
    {����:����ͼƬ��}
    procedure SetImages(pngImages : TPngImageCollection);
    procedure SetOnTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetOnTrainmanDblClick(OnDblClick:TOnTrainmanDblClick);
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
    //����RRsNamedGroup�е�nCheciOrder
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
  //��ӵ�Childs�󣬻��Զ�free
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
{����:���Ʊ���}
begin
  viewCanvas.Brush.Color := GetBKColor();

  viewCanvas.FillRect(viewCanvas.ClipRect);
end;

procedure TNamedGroupView.DrawTitle(viewCanvas: TCanvas);
{����:���Ƴ���}
var
  strText : String;
begin
  //���
  viewCanvas.Font.color := m_TitleFontColor;
  viewCanvas.Font.Name := '����';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];
  strText := IntToStr(m_NamedGroup.nCheciOrder);

  //�������
  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

  if (m_NamedGroup.nCheciType = cctCheci) then
  begin
    //���Ƴ���1
    strText := m_NamedGroup.strCheci1;
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,24,strText);

    //���Ƴ���2
    strText := m_NamedGroup.strCheci2;
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,40,strText);
  end
  else
  begin
    strText := '��';
    viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,24,strText);
  end;

end;

procedure TNamedGroupView.DrawTrainmans(viewCanvas: TCanvas);
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
  //Ϊ��ˢ��
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

