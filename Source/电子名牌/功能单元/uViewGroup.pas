unit uViewGroup;

interface
uses
  Classes,SysUtils,uScrollView,Graphics,Windows,Contnrs;
type
  TViewGroupTitle = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    FFont: TFont;
    FCaption: string;
    FWidth: Integer;
    FColor: TColor;
    FBorderColor: TColor;
  public
    property Font: TFont read FFont;
    property Color: TColor read FColor write FColor;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property Caption: string read FCaption write FCaption;
    property Width: Integer read FWidth write FWidth;
  end;

  TViewGroup = class(TView)
  public
    constructor Create;
    destructor Destroy;override;
  private
    FTitle: TViewGroupTitle;
    FViews: TViews;
  protected
    procedure SetScrollView(Value: TScrollView);override;
    procedure Draw(Canvas: TCanvas);override;
    function CanSelect: Boolean;override;
    function CanDrop: Boolean;override;
  public
    procedure LocateViews();override;
    property Title: TViewGroupTitle read FTitle;
    property Views: TViews read FViews;
  end;  
implementation


{ TViewGroup }

function TViewGroup.CanDrop: Boolean;
begin
  Result := False;
end;

function TViewGroup.CanSelect: Boolean;
begin
  Result := False;
end;

constructor TViewGroup.Create;
begin
  Inherited Create;
  FTitle := TViewGroupTitle.Create;
  FBorderColor := FTitle.BorderColor;
end;

destructor TViewGroup.Destroy;
begin
  FTitle.Free;
  inherited;
end;

procedure TViewGroup.Draw(Canvas: TCanvas);
  procedure DrawTitle();
  var
    s: WideString;
    nTextHeight: integer;
    nTop,nLeft: integer;
    I: Integer;
    r: TRect;
  begin
    s := FTitle.Caption;
    r := ClientRect;
    r.Right := FTitle.Width;

    Canvas.Font.Assign(FTitle.Font);
    
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := FTitle.Color;
    Canvas.FillRect(r);


    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FTitle.BorderColor;
    Canvas.Pen.Width := 1;
    Canvas.Rectangle(r);
    

    nTextHeight := Canvas.TextHeight('A');

    nTop := (Height - ((nTextHeight + 3)* Length(s) )) div 2;

    if nTop < 0 then
      nTop := 0;
        
    nLeft := (FTitle.Width - Canvas.TextWidth('A')) div 2;
    if nLeft < 0 then
      nLeft := 0;
        

    for I := 1 to Length(s) do
    begin
      Canvas.TextOut(nLeft,nTop,s[i]);
      nTop := nTop + nTextHeight + 3;
    end;

  end;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  DrawTitle();

  Canvas.Font.Assign(Font);
  
  DrawChilds(Canvas);
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := BorderColor;
  Canvas.Pen.Width := 1;
  Canvas.Rectangle(ClientRect);
end;



procedure TViewGroup.LocateViews;
var
  nHeight: integer;
  r: TRect;
begin
  r := ClientRect;
  r.Left := r.Left + FTitle.Width;
  
  nHeight := ClacViewsPos(r,Items);
  if nHeight = 0 then
    nHeight := Self.Height;
  FHeight := nHeight ;

  Invalidate();
end;

procedure TViewGroup.SetScrollView(Value: TScrollView);
begin
  inherited;

  if Parent = nil then
  begin
    if FScrollView <> nil then
    begin
      if FWidth <> FScrollView.ClientWidth - FMargin.Left - FMargin.Top then
      begin
        FWidth := FScrollView.ClientWidth - FMargin.Left - FMargin.Top;
        LocateViews();
      end;
    end;
  end
  else
  begin
    if FWidth <> Parent.Width - FMargin.Left - FMargin.Top then
    begin
      FWidth := Parent.Width - FMargin.Left - FMargin.Top;
      LocateViews();
    end;
  end;

end;

{ TViewGroupTitle }

constructor TViewGroupTitle.Create;
begin
  FFont := TFont.Create;
  FWidth := 40;
  FColor := clBtnFace;
  FBorderColor := $00E6E6E6;;
end;

destructor TViewGroupTitle.Destroy;
begin
  FFont.Free;
  inherited;
end;

end.
