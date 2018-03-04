unit uTogetherTrainView; //���˻���

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uOrderGroupInTrainView,
    uViewDefine;

type

  TTogetherTrainView = class;

  {�а������ϵ�������Ϣ��}
  TOnOrderGroupInTogetherTrain = procedure(
      TogetherTrainView : TTogetherTrainView;
      OrderGroupInTrainView : TOrderGroupInTrainView) of Object;

//  {�а������}
//  TOnTogetherTrainViewDragDrop = procedure(
//      Sender,TogetherTrainView:TTogetherTrainView) of Object;
  /////////////////////////////////////////////////////
  /// ����:TTogetherTrainView
  /// ˵��:������Ϣ
  /////////////////////////////////////////////////////
  TTogetherTrainView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
    destructor Destroy();override;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    {����:���ó���Ա����ͼƬ����}
    procedure SetTrainmanBackgroundImageIndex(Trainman:RRsTrainman;
        nImageIndex:Integer);
  private
    //������Ϣ
    m_TogetherTrain : RRsTogetherTrain;
    {ͼƬ��}
    m_Images: TPngImageCollection;
    {����Ա����֪ͨ}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    //����Ա˫��
    m_OnTrainmanDblClick:TOnTrainmanDblClick;
    
    {�а�������뱾������Ϣ�� }
    m_OnOrderGroupInTogetherTrain : TOnOrderGroupInTogetherTrain;
    {�а�������ק}
    m_OnOrderGroupInTrainDragOver : TOnOrderGroupInTrainDragOver;
    {�а�����˫��}
    m_OnOrderGroupInTrainDblClick : TOnOrderGroupInTrainDblClick;
  private
    {����:����ͼƬ��}
    procedure SetImages(pngImages : TPngImageCollection);
    {����:��������Ϣ�䶯}
    procedure OrderGroupInTrain(View:TView);
    procedure SetTrainmanDragOver(OnDragOver:TOnTrainmanDragOver);
    procedure SetTrainmanDblClick(OnTrainmanDblClick:TOnTrainmanDblClick);
    procedure SetOnOrderGroupInTrainDragOver(
        OnDragOver:TOnOrderGroupInTrainDragOver);
    procedure SetOnOrderGroupInTrainDblClick(
        OnDblClick:TOnOrderGroupInTrainDblClick);
  protected
    {����:����Ƿ��������}
    function CheckViewDrop(View:TView):Boolean;override;
    {����:���Ʊ���}
    procedure DrawBackground(viewCanvas : TCanvas);
    {����:���ư�������Ϣ}
    procedure DrawOrderGroupInTrains(viewCanvas : TCanvas);
    procedure ViewDragDrop(View:TView);override;
  private
    {����:���ð�����Ϣ}
    procedure SetTogetherTrain(ATogetherTrain : RRsTogetherTrain);
    {����:���ر�����}
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
//  //�����Լ��ϵ��Լ��İ�����Ϣ��
//  if (View.Parent = self) then Exit;
//
//
//  Result := True;
end;

constructor TTogetherTrainView.Create(vParent: TView);
begin
  inherited;
  ActionTypeSet := [atMouse{������},atClick{���},atDragDrop{����},atSelected];
  Height := 514; //512;
  Width := 100;//Ĭ�ϸ߶ȣ�ʵ�ʸ߶�Ҫ�����Ƶ�ʱ��
end;

destructor TTogetherTrainView.Destroy;
begin
  inherited;
end;

procedure TTogetherTrainView.DrawBackground(viewCanvas: TCanvas);
{����:���Ʊ���}
var
  strText : String;
  nTextWidth : Integer;
  X : Integer;
  contentRect:TRect;
begin
  //���Ʊ���
  viewCanvas.Brush.Color := CL_NP_BK_NORMAL;
  if Self.Selected then
    viewCanvas.Brush.Color := CL_NP_BK_SELECT;
  viewCanvas.FillRect(viewCanvas.ClipRect);
  viewCanvas.FrameRect(viewCanvas.ClipRect);

  //���� ���ͳ���
  viewCanvas.Font.Color := NP_FONT_TITLE_NORMAL;
  if Self.Selected then
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;

    viewCanvas.Font.Name := '����';
  viewCanvas.Font.Size := 11;
  viewCanvas.Font.Style := [fsBold];
  strText := m_TogetherTrain.strTrainTypeName + '-'+
      m_TogetherTrain.strTrainNumber;
  nTextWidth := viewCanvas.TextWidth(strText);
  X := (Width  - nTextWidth) div 2;
  viewCanvas.TextOut(X,6,strText);

  //�������򱳾�
  contentRect := viewCanvas.ClipRect;
  contentRect.Top := contentRect.Top + 26;
  InflateRect(contentRect,-2,-2);
  viewCanvas.Brush.Color := CL_NP_BK_CONTENT;
  viewCanvas.FillRect(contentRect);

end;

procedure TTogetherTrainView.DrawOrderGroupInTrains(viewCanvas: TCanvas);
{����:���ư�������Ϣ}
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
{����:���ر�����}
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
    Bitmap.Canvas.Font.Name := '����';
    Bitmap.Canvas.Font.Size := 11;
    Bitmap.Canvas.Font.Style := [fsBold];

    Result := Bitmap.Canvas.TextWidth(strText);

  finally
    Bitmap.Free;
  end;


end;

procedure TTogetherTrainView.OrderGroupInTrain(View: TView);
{����:��������Ϣ�䶯}
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TTogetherTrainView.SetImages(pngImages: TPngImageCollection);
{����:����ͼƬ��}
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
    nChildsWidth := nChildsWidth + OrderGroupView.Width + 4;//4�����صļ��
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
  //֪ͨ���¼���λ��
  if Assigned(m_OnNeedReComposition) then
    m_OnNeedReComposition(self);
  EndUpdate();
  ViewChange;
end;

procedure TTogetherTrainView.SetTrainmanBackgroundImageIndex(
  Trainman: RRsTrainman; nImageIndex:Integer);
{����:���ó���Ա����ͼƬ����}
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
    //�а������Ͻ�����
    if Assigned(m_OnOrderGroupInTogetherTrain) then
      m_OnOrderGroupInTogetherTrain(self,TOrderGroupInTrainView(View));
    
  end;
  

end;

end.
