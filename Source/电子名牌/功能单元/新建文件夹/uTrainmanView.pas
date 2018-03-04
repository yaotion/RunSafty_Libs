unit uTrainmanView;  //人员

interface
uses Windows,uTFTabletop,uTrainman,Graphics,PngImageList,PngFunctions,
    uSaftyEnum,uViewDefine;

Type

  TTrainmanView = class;

  {TOnTrainmanDragOver 乘务员放下通知}
  TOnTrainmanDragOver = procedure(Sender:TTrainmanView;TrainmanView:TTrainmanView)of object;

  {乘务员双击通知}

  {TOnTrainmanBeforeDragOver 乘务员放下之前通知}
  TOnTrainmanBeforeDragOver = procedure(Sender:TTrainmanView;
      TrainmanView:TTrainmanView;var bIsOver:Boolean)of object;

  {TOnDblClick 双击事件回到}
  TOnTrainmanDblClick = procedure(Sender:TTrainmanView) of object;

  /////////////////////////////////////////////////////
  /// 类名:TTrainmanView
  /// 说明:乘务员信息视图
  /////////////////////////////////////////////////////
  TTrainmanView = class(TView)
  public
    constructor Create(vParent:TView = nil);override;
    procedure getBitmap(viewBitmap:TBitmap);override;
  public
    {功能:初始化背景色Index}
    procedure InitBackgroundImageIndex(nIndex:Integer);
    {功能:克隆}
    procedure Clone(view:TView);override;
  protected
    {功能:有视图放下}
    procedure ViewDragDrop(View:TView);override;
    {功能:检测是否可以双击}
    //function CheckCanDblClick():Boolean;override;
    {功能:双击}
    procedure DblClick();override;
    {功能:绘制乘务员信息}
    procedure DrawTrainman(viewBitmap:TBitmap);
    {功能:绘制工号}
    procedure DrawNumber(ViewCanvas:TCanvas);
    {功能:绘制职务}
    procedure DrawDuty(ViewCanvas:TCanvas);
    {功能:绘制姓名}
    procedure DrawName(ViewCanvas:TCanvas);
    {功能:绘制其他信息}
    procedure DrawOther(ViewCanvas:TCanvas);
  protected
    {乘务员信息}
    m_Trainman : RRsTrainman;
  protected
    property OnViewChange;
  private
    {乘务员拖拽通知}
    m_OnTrainmanDragOver : TOnTrainmanDragOver;
    {决定乘务员是否允许被放置}
    m_OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver;
    {图片集}
    m_Images: TPngImageCollection;
    {背景图片索引}
    m_nBackgroundImageIndex : Integer;
    {字体颜色}
    m_FontColor : TColor;
    {乘务员双击事件}
    m_OnTrainmanDblClick :TOnTrainmanDblClick;
  private
    {功能:设置乘务员信息}
    procedure SetTrainman(Trainman : RRsTrainman);
    {功能:设置背景图片索引}
    procedure SetBackgroundImageIndex(nImageIndex:Integer);

  protected
    {功能:检查是否允许放置上来}
        {功能:有View放下}
    function CheckViewDrop(View:TView):Boolean;override;
  public
    property Trainman : RRsTrainman read m_Trainman write SetTrainman;
    property OnTrainmanDragOver : TOnTrainmanDragOver read m_OnTrainmanDragOver write m_OnTrainmanDragOver;
    property Images : TPngImageCollection read m_Images write m_Images;
    property BackgroundImageIndex : Integer read m_nBackgroundImageIndex
        write SetBackgroundImageIndex;
    property OnTrainmanBeforeDragOver : TOnTrainmanBeforeDragOver
        read m_OnTrainmanBeforeDragOver write m_OnTrainmanBeforeDragOver;
    property OnTrainmanDblClick :TOnTrainmanDblClick
        read m_OnTrainmanDblClick write m_OnTrainmanDblClick ;

  end;


implementation

{ TrainmanView }
    {
function TTrainmanView.CheckCanDblClick: Boolean;
begin

end;  }

function TTrainmanView.CheckViewDrop(View: TView): Boolean;
begin
  Result := True;
  if Assigned(m_OnTrainmanBeforeDragOver) then
    m_OnTrainmanBeforeDragOver(TTrainmanView(self),TTrainmanView(View),Result);
end;

procedure TTrainmanView.Clone(view: TView);
begin
  inherited Clone(view);
  Self.Trainman := TTrainmanView(view).Trainman;
end;

constructor TTrainmanView.Create(vParent: TView);
begin
  inherited;
  m_nBackgroundImageIndex := 0;
  m_nWidth := 60;
  m_nHeight := 114;
end;

procedure TTrainmanView.DrawDuty(ViewCanvas: TCanvas);
{功能:绘制职务}
var
  rtDuty : TRect;
begin
  rtDuty.Left := 10;
  rtDuty.Top := 20;
  rtDuty.Right := 50;
  rtDuty.Bottom := 24;

  case m_Trainman.nPostID of
    ptNone: ;
    ptTrainman:
      begin
        //背景颜色,用来绘制司机职务

        ViewCanvas.Brush.Color := m_FontColor;
        ViewCanvas.FillRect(rtDuty);
      end;
    ptSubTrainman:
      begin
        ViewCanvas.MoveTo(rtDuty.Left,rtDuty.Top);
        ViewCanvas.LineTo(rtDuty.Right,rtDuty.Top);
        ViewCanvas.MoveTo(rtDuty.Left,rtDuty.Bottom);
        ViewCanvas.LineTo(rtDuty.Right,rtDuty.Bottom);
      end;
    ptLearning:
      begin
        //画笔颜色,用来绘制副司机和学员
        ViewCanvas.Brush.Style := bsClear;
        ViewCanvas.Brush.Color := m_FontColor;
        ViewCanvas.Pen.Width := 1;
        ViewCanvas.Pen.Style := psDot;
        ViewCanvas.MoveTo(rtDuty.Left,rtDuty.Top);
        ViewCanvas.LineTo(rtDuty.Right,rtDuty.Top);
        ViewCanvas.MoveTo(rtDuty.Left,rtDuty.Bottom);
        ViewCanvas.LineTo(rtDuty.Right,rtDuty.Bottom);
      end;
  end;

end;

procedure TTrainmanView.DrawName(ViewCanvas: TCanvas);
{功能:绘制姓名}
var
  X,Y : Integer;
  i : Integer;
  strText : WideString;
begin
  if m_Trainman.strTrainmanName = '' then Exit;
  ViewCanvas.Font.Size := 11;
  ViewCanvas.Font.Style := [fsBold];
  ViewCanvas.Brush.Style := bsClear;
  strText := m_Trainman.strTrainmanName;
  X := (Width - ViewCanvas.TextWidth(strText[1])) div 2;
  Y := 32;
  for I := 0 to LengTh(strText) - 1 do
  begin
    ViewCanvas.TextOut(X,Y,strText[i+1]);
    Y := Y + ViewCanvas.TextHeight(strText[i+1])+4;//间隔4个像素
  end;
end;

procedure TTrainmanView.DrawNumber(ViewCanvas: TCanvas);
{功能:绘制工号}
var
  X : Integer;
  strText : String;
  nTextWidth : Integer;
begin
  ViewCanvas.Font.Color := m_FontColor;
  ViewCanvas.Font.Size := 9;
  ViewCanvas.Font.Style := [];
  
  strText := m_Trainman.strTrainmanNumber;
  nTextWidth := ViewCanvas.TextWidth(strText);
  X := (Width - nTextWidth) div 2;
  ViewCanvas.Brush.Style := bsClear;
  ViewCanvas.TextOut(X,4,strText);
end;

procedure TTrainmanView.DrawOther(ViewCanvas: TCanvas);
{功能:绘制其他信息}
var
  strText : String;
begin
  strText := '';
  (*case m_Trainman.nDriverType of
    drtNone : {无}
      begin
        strText := '';
      end;
    drtNeiran : {内燃N}
      begin
        strText := 'N';
      end;
    drtDian :  {电车D}
      begin
        strText := 'D';
      end;
    drtDong :  {动O}
      begin
        strText := 'O';
      end;
  end;  *)
  ViewCanvas.Brush.Style := bsClear;
  ViewCanvas.Font.Color := clRed;
  ViewCanvas.Font.Size := 11;
  ViewCanvas.Font.Style := [fsBold];
  //ViewCanvas.TextOut(5,94,strText);

  //ViewCanvas.TextOut(Width - ViewCanvas.TextWidth(m_Trainman.strABCD) - 5,94,
  //    m_Trainman.strABCD);

  //ViewCanvas.TextOut((Width - ViewCanvas.TextWidth('关')) div 2,94,'关');
  if m_Trainman.bIsKey = 1 then
    ViewCanvas.TextOut(5,94,'关');

  if m_Trainman.strTrainmanGUID <> '' then
  begin
    if m_Trainman.eFixGroupType = Fixed_UnFix then
    begin
       ViewCanvas.TextOut(Width - ViewCanvas.TextWidth('非') - 5,94,'非');
    end;
    if m_Trainman.eFixGroupType = Fixed_Fix then
    begin
      ViewCanvas.Font.Color := clBlack;
      ViewCanvas.TextOut(Width - ViewCanvas.TextWidth('固') - 5,94,'固') ;
    end
  end;
//  if m_Trainman.strFixedGroupGUID <> '' then
//  begin
//    if m_Trainman.bFixGroup = True then
//    begin
//      ViewCanvas.Font.Color := clBlack;
//      ViewCanvas.TextOut(Width - ViewCanvas.TextWidth('固') - 5,94,'固') ;
//    end
//    else
//      ViewCanvas.TextOut(Width - ViewCanvas.TextWidth('非') - 5,94,'非')
//  end;


end;

procedure TTrainmanView.DrawTrainman(viewBitmap: TBitmap);
{功能:绘制乘务员信息}
begin
  viewBitmap.Canvas.Font.Name := '宋体';
  if m_Trainman.strTrainmanNumber = '' then Exit;
  
  // 绘制工号
  DrawNumber(viewBitmap.Canvas);
  //绘制职务
  DrawDuty(viewBitmap.Canvas);
  //绘制姓名
  DrawName(viewBitmap.Canvas);
  //绘制其他信息
  DrawOther(viewBitmap.Canvas);
end;

procedure TTrainmanView.getBitmap(viewBitmap: TBitmap);
var
  Bitmap : TBitmap;
  TMRect:TRect;
begin
  if m_nBackgroundImageIndex = -1 then Exit;
  //if m_Images = nil then Exit;
  //if m_nBackgroundImageIndex >= m_Images.Items.Count then Exit;

  Bitmap := TBitmap.Create;
  //绘制背景
  Bitmap.Width := Width;
  Bitmap.Height := Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
    viewBitmap.Canvas,Bitmap.Canvas.ClipRect);

  //外边框
  case m_nBackgroundImageIndex of
    0: Bitmap.Canvas.Brush.Color := CL_NP_BK_NORMAL;
    1: Bitmap.Canvas.Brush.Color := CL_NP_BK_PLAN;
    2: Bitmap.Canvas.Brush.Color := CL_NP_BK_RUN;
    //3: Bitmap.Canvas.Brush.Color := CL_NP_BK_SELECT;
  end;
  if Selected then
    Bitmap.Canvas.Brush.Color :=  CL_NP_BK_SELECT;
  if self.Parent <> nil then
  begin
    if self.Parent.Selected then
      Bitmap.Canvas.Brush.Color :=  CL_NP_BK_SELECT;
  end;

  if DblClicked  then
    Bitmap.Canvas.Brush.Color :=  CL_NP_BK_DBLCLICK;
  if self.Parent <> nil then
  begin
    if self.Parent.DblClicked then
      Bitmap.Canvas.Brush.Color :=  CL_NP_BK_DBLCLICK;
  end;


  Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);

  m_FontColor := NP_FONT_TITLE_NORMAL;
  if Bitmap.Canvas.Brush.Color <> CL_NP_BK_NORMAL then
    m_FontColor := Bitmap.Canvas.Brush.Color ;

  Bitmap.Canvas.Brush.Color := CL_NP_BK_CONTENT;//$00AF2626 ;
  TMRect := Bitmap.Canvas.ClipRect;
  InflateRect(TMRect,-2,-2);
  Bitmap.Canvas.FillRect(TMRect);

  //DrawPNG(m_Images.Items[m_nBackgroundImageIndex].PngImage,Bitmap.Canvas,
  //    Bitmap.Canvas.ClipRect,[]);

  //绘制乘务员信息
  DrawTrainman(Bitmap);

  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.CopyRect(viewBitmap.Canvas.ClipRect,
      Bitmap.Canvas,Bitmap.Canvas.ClipRect);
  Bitmap.Free;


end;

procedure TTrainmanView.InitBackgroundImageIndex(nIndex: Integer);
begin
  m_nBackgroundImageIndex := nIndex;
end;

procedure TTrainmanView.SetBackgroundImageIndex(nImageIndex: Integer);
begin
  m_nBackgroundImageIndex := nImageIndex;
  ViewChange();
end;

procedure TTrainmanView.SetTrainman(Trainman: RRsTrainman);
begin
  m_Trainman := Trainman;
  ViewChange();
end;
procedure TTrainmanView.DblClick();
begin
  inherited;
  if Assigned(m_OnTrainmanDblClick) then
  begin
    m_OnTrainmanDblClick(Self);
  end;
end;
procedure TTrainmanView.ViewDragDrop(View: TView);
begin
  inherited;
  if Assigned(m_OnTrainmanDragOver) then
    m_OnTrainmanDragOver(self,TTrainmanView(View));

end;

end.
