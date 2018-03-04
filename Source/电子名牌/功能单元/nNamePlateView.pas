unit nNamePlateView;

interface
uses
  Classes,SysUtils,Graphics,uScrollView,Windows;
type
  TTmView = class(TView)
  public
    constructor Create;
    destructor Destroy;override;
  private
    FName: string;
    FOther: string;
    FNumber: string;
    FDuty: integer;
    procedure SetDuty(const Value: integer);
    procedure SetStringValue(index: integer;const Value: string);
  protected
    procedure DrawContent(Canvas: TCanvas);override;
  public
    property Number: string index 0 read FNumber write SetStringValue;
    property Name: string index 1 read FName write SetStringValue;
    property Other: string index 2 read FOther write SetStringValue;
    property Duty: integer read FDuty write SetDuty;
  end;

  TGrpView = class(TView)
  public
    constructor Create;
    destructor Destroy;override;
  protected
    FOrder: integer;
    procedure DrawContent(Canvas: TCanvas);override;
  public
    procedure LocateViews();override;
    property Order: integer read FOrder write FOrder;
  end;
  
  TTrainView = class(TView)
  
  end;

implementation

{ TTmView }

constructor TTmView.Create;
begin
  inherited Create;
  FWidth := 60;
  FHeight := 114;
  Color := $00DDE1E0;
end;

destructor TTmView.Destroy;
begin

  inherited;
end;

procedure TTmView.DrawContent(Canvas: TCanvas);
  const TOP_NUMBER = 4;
  const TOP_DUTY = 20;
  const TOP_NAME = 32;
  const TOP_OTHER = 94;
var
  nTextWidth: integer;
  x,y: integer;
  s: WideString;

  procedure DrawNumber();
  begin
    Canvas.Brush.Style := bsClear;
    nTextWidth := Canvas.TextWidth(FNumber);
    x := (Width - nTextWidth) div 2;
    Canvas.TextOut(x,4,FNumber);
  end;
  procedure DrawDuty();
  var
    r: TRect;
  begin
    r := Rect(3,TOP_DUTY,Width - 3,TOP_DUTY + 4);

    case FDuty of
      0:;
      1:
        begin
          Canvas.Brush.Color := Font.Color;
          Canvas.Brush.Style := bsSolid;
          Canvas.FillRect(r);          
        end;
      2,3:
        begin
          Canvas.Pen.Color := Font.Color;
          Canvas.Pen.Width := 1;
          
          if FDuty = 2 then
            Canvas.Pen.Style := psSolid
          else
            Canvas.Pen.Style := psDot;
            
          Canvas.MoveTo(r.Left,r.Top);
          Canvas.LineTo(r.Right,r.Top);
          Canvas.MoveTo(r.Left,r.Bottom);
          Canvas.LineTo(r.Right,r.Bottom);                    
        end;
    end;
  end;
  procedure DrawOther();
  begin

  end;
  procedure DrawName();
  var
    i: integer;
  begin
    if FName = '' then Exit;

    Canvas.Brush.Style := bsClear;
    Canvas.Font.Style := [fsBold];
    s := FName;
    x := (Width - Canvas.TextWidth(s[1])) div 2;

    y := TOP_NAME;

    for I := 1 to Length(s) do
    begin
      Canvas.TextOut(x,y,s[i]);
      y := y + Canvas.TextHeight(s[i]) + 4;
    end;
  end;
begin
  Canvas.Font.Assign(Self.Font);

  DrawNumber();
  DrawDuty();
  DrawName();
  DrawOther();
end;



procedure TTmView.SetDuty(const Value: integer);
begin
  if FDuty <> Value then
  begin
    FDuty := Value;
    Invalidate;
  end;
end;


procedure TTmView.SetStringValue(index: integer; const Value: string);
begin
  case index of
    0: FNumber := Value;
    1: FName := Value;
    2: FOther := FOther;  
  end;

  Invalidate;
end;

{ TGrpView }

constructor TGrpView.Create;
begin
  inherited Create;
  
  FWidth := 66;
  FHeight := 392;

  Color := $00B8C0BE;
  
  FItems.AddView(TTmView.Create);
  FItems.AddView(TTmView.Create);
  FItems.AddView(TTmView.Create);
end;

destructor TGrpView.Destroy;
begin

  inherited;
end;

procedure TGrpView.DrawContent(Canvas: TCanvas);
const TITLE_HEIGHT = 26;
  procedure DrawTitle();
  var
    r: TRect;
    s: string;
  begin
    Canvas.Pen.Color := clGray;
    Canvas.MoveTo(0,TITLE_HEIGHT);
    Canvas.LineTo(Width,TITLE_HEIGHT);

    Canvas.Brush.Style := bsClear;
    r := ClientRect;
    r.Bottom := TITLE_HEIGHT;

    s := IntToStr(FOrder);
    Canvas.Font.Size := 10;
    Canvas.Font.Style := [fsBold];
    Canvas.TextRect(r,s,[tfSingleLine,tfCenter,tfVerticalCenter]);

  end;
begin
  Canvas.Font.Assign(Self.Font);
  DrawTitle();
end;

procedure TGrpView.LocateViews;
var
  r: TRect;
begin
  r := ClientRect;
  r.Top := r.Top + 30;

  ClacViewsPos(r,Items);
  
  Invalidate();
end;
end.
