unit uNamedGroupView;  //记名式

interface
uses Windows,uTrainman,Graphics,
    uSaftyEnum,uTrainmanView,uTrainmanJiaolu,SysUtils,uViewDefine,
    uScrollView;

Type
  /////////////////////////////////////////////////////
  /// 类名:TOrderGroupView
  /// 说明:记名式交路内机班信息视图类
  /////////////////////////////////////////////////////
  TNamedGroupView = class(TView)
  public
    constructor Create();
    destructor Destroy();override;
  private
    m_NamedGroup : RRsNamedGroup;
    procedure SetNamedGroup(ANamedGroup : RRsNamedGroup);
  protected
    function GetColor():TColor;
    function GetFontColor():TColor;
    function GetTMFontColor():TColor;
    function GetTMBorderColor: TColor;
    procedure DrawContent(Canvas: TCanvas);override;
    function DropAcceptRect(): TRect;override;
    procedure BeforeDraw(Canvas: TCanvas);override;
  public
    procedure LocateViews();override;
    
    procedure SetNamedGroupOrder(nOrder: integer);

    property NamedGroup : RRsNamedGroup read m_NamedGroup write SetNamedGroup;
  end;

implementation

{ TOrderGroupView }


procedure TNamedGroupView.BeforeDraw(Canvas: TCanvas);
var
  i: integer;
begin
  for I := 0 to Items.Count - 1 do
  begin
    Items[i].BorderColor := GetTMBorderColor;
    Items[i].Font.Color := GetTMFontColor;
  end;

  Color := GetColor;
  BorderColor := GetColor;
  Canvas.Brush.Style := bsSolid;
end;

constructor TNamedGroupView.Create();
var
  i: integer;
begin
  inherited;
  FWidth := 62;
  FHeight := 410;

  FMargin.SetMargin(1,1,1,1);
  FItems.BeginUpdate;
  for I := 0 to 2 do
  begin
    FItems.AddView(TTrainmanView.Create);
    FItems[i].Margin.SetMargin(1,1,1,0);
  end;
  FItems.EndUpdate;
end;

destructor TNamedGroupView.Destroy;
begin

  inherited;
end;


procedure TNamedGroupView.DrawContent(Canvas: TCanvas);
var
  s : String;
begin  
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := GetFontColor;
  Canvas.Font.Name := '宋体';
  Canvas.Font.Size := 10;
  Canvas.Font.Style := [fsBold];

  if Owner <> nil then
  begin
    s := IntToStr(Owner.IndexOf(self) + 1);
  end
  else
    s := '0'; 
  //绘制序号
  Canvas.TextOut((width - Canvas.TextWidth(s)) div 2,6,s);

  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := GetFontColor;
  Canvas.MoveTo(2,20);
  Canvas.LineTo(Width - 2,20);

  if (m_NamedGroup.nCheciType = cctCheci) then
  begin
    //绘制车次1
    s := m_NamedGroup.strCheci1;
    if s = '' then
      s := '-';
      
    Canvas.TextOut((width - Canvas.TextWidth(s)) div 2,24,s);

    //绘制车次2
    s := m_NamedGroup.strCheci2;
    if s = '' then
      s := '-';
    Canvas.TextOut((width - Canvas.TextWidth(s)) div 2,40,s);
  end
  else
  begin
    s := '休';
    Canvas.TextOut((width - Canvas.TextWidth(s)) div 2,24,s);
  end;

end;




function TNamedGroupView.DropAcceptRect: TRect;
begin
  Result := inherited DropAcceptRect;
  Result.Bottom := 60;
end;

function TNamedGroupView.GetColor(): TColor;
begin
  Result := CL_NP_BK_NORMAL;
  if m_NamedGroup.Group.MinGroupState = tsPlaning then
    Result := CL_NP_BK_PLAN;
  if m_NamedGroup.Group.MinGroupState = tsRuning then
    result := CL_NP_BK_RUN;
  if vsSelected in Self.States then
    Result := CL_NP_BK_SELECT;
end;

function TNamedGroupView.GetFontColor: TColor;
begin
  Result := NP_FONT_TITLE_NORMAL;
  if m_NamedGroup.Group.MinGroupState = tsPlaning then
    Result := NP_FONT_TITLE_SELECT;
  if m_NamedGroup.Group.MinGroupState = tsRuning then
    result := NP_FONT_TITLE_SELECT;

  if vsSelected in Self.States then
    Result := NP_FONT_TITLE_SELECT;
end;

function TNamedGroupView.GetTMBorderColor: TColor;
begin
    Result := CL_NP_BK_NORMAL;
  if m_NamedGroup.Group.MinGroupState = tsPlaning then
    Result := CL_NP_BK_PLAN;
  if m_NamedGroup.Group.MinGroupState = tsRuning then
    result := CL_NP_BK_RUN;

  if vsSelected in Self.States then
    Result := CL_NP_BK_SELECT;
end;

function TNamedGroupView.GetTMFontColor: TColor;
begin
    Result := NP_FONT_TITLE_NORMAL;
  if m_NamedGroup.Group.MinGroupState = tsPlaning then
    Result := CL_NP_BK_PLAN;
  if m_NamedGroup.Group.MinGroupState = tsRuning then
    result := CL_NP_BK_RUN;

  if vsSelected in Self.States then
    Result := CL_NP_BK_SELECT;
end;

procedure TNamedGroupView.LocateViews;
var
  r: TRect;
begin
  r := ClientRect;
  r.Top := r.Top + 60;

  ClacViewsPos(r,Items);
  Invalidate();
end;


procedure TNamedGroupView.SetNamedGroup(ANamedGroup: RRsNamedGroup);
var
  I: Integer;
begin
  m_NamedGroup := ANamedGroup;

  for I := 0 to Items.Count - 1 do
  begin
    with (Items[i] as TTrainmanView) do
    begin
      case i of
        0: Trainman := ANamedGroup.Group.Trainman1;
        1: Trainman := ANamedGroup.Group.Trainman2;
        2: Trainman := ANamedGroup.Group.Trainman3;
      end;

      Font.Color := GetTMFontColor;
    end;
  end;
end;

procedure TNamedGroupView.SetNamedGroupOrder(nOrder: integer);
begin
  m_NamedGroup.nCheciOrder := nOrder;
end;

end.

