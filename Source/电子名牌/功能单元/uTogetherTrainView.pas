unit uTogetherTrainView; //包乘机车

interface

uses
  Windows, uScrollView, uTrainman, Graphics, uSaftyEnum, uTrainmanView,
  uTrainmanJiaolu, SysUtils, uOrderGroupInTrainView, uViewDefine;

type
  /////////////////////////////////////////////////////
  /// 类名:TTogetherTrainView
  /// 说明:包乘信息
  /////////////////////////////////////////////////////
  TTogetherTrainView = class(TView)
  public
    constructor Create();
    destructor Destroy(); override;
  private
    m_TogetherTrain: RRsTogetherTrain;
  protected
    procedure DrawContent(Canvas: TCanvas); override;
    function DropAcceptRect(): TRect;override;
  private
    procedure SetTogetherTrain(ATogetherTrain: RRsTogetherTrain);
    function CalcWidth(GrpCount: integer): integer;
  public
    procedure LocateViews(); override;
    property TogetherTrain: RRsTogetherTrain read m_TogetherTrain write SetTogetherTrain;
  end;

implementation
const
  MARGIN_GRP_LEFT = 1;
  MARGIN_GRP_TOP = 1;
  MARGIN_GRP_RIGHT = 1;
  MARGIN_GRP_BOTTOM = 1;

  GRP_WIDTH = 62;
  DEFAUT_GRPCOUNT = 3;
{ TTogetherTrainView }
function TTogetherTrainView.CalcWidth(GrpCount: integer): integer;
begin
  if GrpCount < DEFAUT_GRPCOUNT then
    GrpCount := DEFAUT_GRPCOUNT;
  //宽度额外增加4个像素，用来左右各留2个像素的空白边
  Result := GrpCount * GRP_WIDTH  + GrpCount * (MARGIN_GRP_LEFT + MARGIN_GRP_RIGHT) + 4;
end;

constructor TTogetherTrainView.Create();
begin
  inherited;
  FColor := CL_NP_BK_NORMAL;

  FMargin.SetMargin(1,1,0,0);
  FHeight := 400;
  //初始化3个机组的宽度
  FWidth := CalcWidth(DEFAUT_GRPCOUNT);
  FDragEnable := False;
end;

destructor TTogetherTrainView.Destroy;
begin
  inherited;
end;

procedure TTogetherTrainView.DrawContent(Canvas: TCanvas);
var
  strText: string;
  nTextWidth: Integer;
  X: Integer;
  contentRect: TRect;
begin
  //文字 车型车号
  Canvas.Font.Color := NP_FONT_TITLE_NORMAL;
  Canvas.Font.Name := '宋体';
  Canvas.Font.Size := 11;
  Canvas.Font.Style := [fsBold];
  strText := m_TogetherTrain.strTrainTypeName + '-' + m_TogetherTrain.strTrainNumber;
  nTextWidth := Canvas.TextWidth(strText);
  X := (Width - nTextWidth) div 2;
  Canvas.TextOut(X, 6, strText);

  //机组区域背景
  contentRect := ClientRect;
  contentRect.Top := contentRect.Top + 26;
  InflateRect(contentRect, -2, -2);

//  Canvas.Brush.Color := CL_NP_BK_CONTENT;
  Canvas.Brush.Color := $007B766F;
  Canvas.FillRect(contentRect);

end;

function TTogetherTrainView.DropAcceptRect: TRect;
begin
  Result := inherited DropAcceptRect;
  Result.Bottom := 27;
end;

procedure TTogetherTrainView.LocateViews;
var
  nWidth: integer;
  r: TRect;
begin
  r := ClientRect;
  r.Top := r.Top + 28;
  nWidth := CalcWidth(Items.Count);
    
  if (nWidth <> FWidth) then
  begin
    FWidth := nWidth;
    if FScrollView <> nil then
      FScrollView.LocateViews;
  end;

  r.Left := 2;
  r.Right := r.Left + FWidth - 2;

  ClacViewsPos(r, Items);
  
  Invalidate();
end;

procedure TTogetherTrainView.SetTogetherTrain(ATogetherTrain: RRsTogetherTrain);
var
  i: Integer;
  OrderGroupView: TOrderGroupInTrainView;
begin
  m_TogetherTrain := ATogetherTrain;
  Items.Clear;
  for I := 0 to length(m_TogetherTrain.Groups) - 1 do
  begin
    OrderGroupView := TOrderGroupInTrainView.Create();
    
    OrderGroupView.Margin.SetMargin(MARGIN_GRP_LEFT,MARGIN_GRP_TOP,MARGIN_GRP_RIGHT,MARGIN_GRP_BOTTOM);

    m_TogetherTrain.Groups[i].nOrder := 0;
    OrderGroupView.OrderGroupInTrain := m_TogetherTrain.Groups[i];
    Items.AddView(OrderGroupView);
  end;
end;

end.

