unit uTrainmanOrderView;  //Ԥ����ԱЧ��

interface
uses Windows,uTrainmanView,uTFTabletop,Graphics,SysUtils,uTrainman,PngImageList,
  uSaftyEnum,uViewDefine;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TrainmanOrderView
  /// ˵��:����Ա��Ϣ,�������
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanOrderView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    procedure Clone(view:TView);override;
  private
    {����:���Ʊ���}
    procedure DrawBackground(viewCanvas : TCanvas);
    {����:���Ƴ���Ա��Ϣ}
    procedure DrawTrainman(viewCanvas : TCanvas);
    {����:����Ա��Ϣ�䶯}
    procedure OnTrainmanViewChange(View : TView);
  public
    Index : Integer;
    TrainmanView : TTrainmanView;
  end;

implementation

{ TrainmanOrderView }

procedure TTrainmanOrderView.Clone(view: TView);
begin
  inherited;
  self.TrainmanView.Clone(TTrainmanOrderView(view).TrainmanView);
  
end;

constructor TTrainmanOrderView.Create(vParent: TView);
begin
  inherited;
  Index := 0;
  m_nWidth := 60;
  m_nHeight := 135;
  ActionTypeSet := [atSelected];
  
  TrainmanView := TTrainmanView.Create(self);
  TrainmanView.Left := 0;
  TrainmanView.Top := 20;
  TrainmanView.OnViewChange := OnTrainmanViewChange;
  m_Childs.Add(TrainmanView);
end;

procedure TTrainmanOrderView.DrawBackground(viewCanvas: TCanvas);
{����:���Ʊ���}
var
  strText : String;
begin
 
  viewCanvas.Brush.Color := CL_NP_BK_NORMAL;
  viewCanvas.Font.Color := NP_FONT_TITLE_NORMAL;
  if Selected or TrainmanView.Selected then  //ѡ��
  begin
    viewCanvas.Brush.Color := CL_NP_BK_SELECT;
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;
  end;
  if DblClicked or TrainmanView.DblClicked then  //����
  begin
    viewCanvas.Brush.Color := CL_NP_BK_DBLCLICK;
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;
  end;

  viewCanvas.Pen.Color := NP_FONT_TITLE_NORMAL;
  if self.Selected  then
    viewCanvas.Pen.Color := NP_FONT_TITLE_SELECT;
    
  viewCanvas.FillRect(viewCanvas.ClipRect);
  viewCanvas.FrameRect(viewCanvas.ClipRect);
  //���


  viewCanvas.Font.Name := '����';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];

  strText := IntToStr(Index);

  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

end;

procedure TTrainmanOrderView.DrawTrainman(viewCanvas: TCanvas);
{����:���Ƴ���Ա��Ϣ}
var
  TrainmanBitmap : TBitmap;
  SourceRect : TRect;
begin
  TrainmanBitmap := TBitmap.Create;
  try
    TrainmanBitmap.Width := TrainmanView.Width;
    TrainmanBitmap.Height := TrainmanView.Height ;

    SourceRect.Left := 0;
    SourceRect.Top := 20;
    SourceRect.Right := SourceRect.Left + TrainmanView.Width;
    SourceRect.Bottom := SourceRect.Top + TrainmanView.Height;
    TrainmanBitmap.Canvas.CopyRect(TrainmanBitmap.Canvas.ClipRect,
        viewCanvas,SourceRect);
    if Self.Selected then
      TrainmanView.Selected := Self.Selected;
    TrainmanView.getBitmap(TrainmanBitmap);

    viewCanvas.Draw(SourceRect.Left,SourceRect.Top,TrainmanBitmap);
  finally
    TrainmanBitmap.Free;
  end;

end;

procedure TTrainmanOrderView.getBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  //���Ʊ���
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);


  //�������
  DrawBackground(Bitmap.Canvas);
  //���Ƴ���Ա��Ϣ
  DrawTrainman(Bitmap.Canvas);
//  if Selected then
//    DrawSelectedView(Bitmap);



  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.CopyRect(viewBitmap.Canvas.ClipRect,
      Bitmap.Canvas,Bitmap.Canvas.ClipRect);

  Bitmap.Free;

end;

procedure TTrainmanOrderView.OnTrainmanViewChange(View: TView);
begin
  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;



end.

