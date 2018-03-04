unit uTrainmanOrderView;  //预备人员效果

interface
uses Windows,uTrainmanView,uTFTabletop,Graphics,SysUtils,uTrainman,PngImageList,
  uSaftyEnum,uViewDefine;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TrainmanOrderView
  /// 说明:乘务员信息,包含序号
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanOrderView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
  public
    procedure getBitmap(viewBitmap:TBitmap);override;
    procedure Clone(view:TView);override;
  private
    {功能:绘制背景}
    procedure DrawBackground(viewCanvas : TCanvas);
    {功能:绘制乘务员信息}
    procedure DrawTrainman(viewCanvas : TCanvas);
    {功能:乘务员信息变动}
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
{功能:绘制背景}
var
  strText : String;
begin
 
  viewCanvas.Brush.Color := CL_NP_BK_NORMAL;
  viewCanvas.Font.Color := NP_FONT_TITLE_NORMAL;
  if Selected or TrainmanView.Selected then  //选中
  begin
    viewCanvas.Brush.Color := CL_NP_BK_SELECT;
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;
  end;
  if DblClicked or TrainmanView.DblClicked then  //复制
  begin
    viewCanvas.Brush.Color := CL_NP_BK_DBLCLICK;
    viewCanvas.Font.Color := NP_FONT_TITLE_SELECT;
  end;

  viewCanvas.Pen.Color := NP_FONT_TITLE_NORMAL;
  if self.Selected  then
    viewCanvas.Pen.Color := NP_FONT_TITLE_SELECT;
    
  viewCanvas.FillRect(viewCanvas.ClipRect);
  viewCanvas.FrameRect(viewCanvas.ClipRect);
  //序号


  viewCanvas.Font.Name := '宋体';
  viewCanvas.Font.Size := 10;
  viewCanvas.Font.Style := [fsBold];

  strText := IntToStr(Index);

  viewCanvas.TextOut((width - viewCanvas.TextWidth(strText)) div 2,6,strText);

end;

procedure TTrainmanOrderView.DrawTrainman(viewCanvas: TCanvas);
{功能:绘制乘务员信息}
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
  //绘制背景
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);


  //绘制序号
  DrawBackground(Bitmap.Canvas);
  //绘制乘务员信息
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

