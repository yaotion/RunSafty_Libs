unit uScrollView;

interface
uses
  Classes,SysUtils,Controls,Windows,Messages,math,Graphics,Forms,Menus,ExtCtrls;

type
  TView = class;
  TViews = class;
  TScrollView = class;
  TDropModePopMenu = class;
  TViewMargin = class
  public
    constructor Create(View: TView);
  private
    FView: TView;
    FLeft: integer;
    FTop: integer;
    FRight: integer;
    FBottom: integer;
    procedure SetValue(index: integer;value: integer);
  public
    function BoundRect: TRect;
    procedure SetMargin(ALeft,ATop,ARigth,ABottom: Integer);
    property Left: integer index 0 read FLeft write SetValue;
    property Top: integer index 1 read FTop write SetValue;
    property Right: integer index 2 read FRight write SetValue;
    property Bottom: integer index 3 read FBottom write SetValue;
  end;

  TViewsChangeAction = (caAdd,caExtracting,caExtract,caDeleting,caDelete,caClearing,caClear,caUpdateEnd,caUndefined);
  TViewChangeEvent = procedure(Action: TViewsChangeAction;View: TView) of object;
  TViewState = (vsSelected,vsFixSelected,vsDragDropping);
  TViewStates = set of TViewState;
  TView = class
  public
    constructor Create;
    destructor Destroy;override;
  protected
    FScrollView: TScrollView;
    FLeft: integer;
    FTop: integer;
    FWidth: integer;
    FHeight: integer;
    FStates: TViewStates;
    FData: Pointer;
    FTag: integer;
    FParent: TView;
    FOwnerViews: TViews;
    FItems: TViews;
    FMargin: TViewMargin;
    FAutoLocateChilds: Boolean;
    FFont: TFont;
    FColor: TColor;
    FBorderColor: TColor;
    FDragEnable: Boolean;
    procedure SetHeigth(const Value: integer);
    procedure SetWidth(const Value: integer);
  protected
    procedure OnItemsChange(Action: TViewsChangeAction;View: TView);
    procedure BeforeDraw(Canvas: TCanvas);virtual;
    procedure DrawChilds(Canvas: TCanvas);virtual;
    procedure Draw(Canvas: TCanvas);virtual;
    procedure DrawContent(Canvas: TCanvas);virtual;
    procedure SetScrollView(Value: TScrollView);virtual;
    function CanSelect: Boolean;virtual;
    function CanDrop: Boolean;virtual;
    function ParentOf(View: TView): Boolean;
    function DropAcceptRect(): TRect;virtual;
  public
    function BoundRect: TRect;
    function ClientRect: TRect;

    function AbsolutePos(): TPoint;
    function GetViewAt(X,Y: integer): TView;
    function Desp(): string;virtual;

    procedure LocateViews();virtual;
    procedure Invalidate();
  public
    property AutoLocateChilds: Boolean read FAutoLocateChilds write FAutoLocateChilds;
    property Parent: TView read FParent write FParent;
    property Owner: TViews read FOwnerViews;
    property Font: TFont read FFont;
    property Color: TColor read FColor write FColor;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Width: integer read FWidth write SetWidth;
    property Height: integer read FHeight write SetHeigth;
    property DragEnable: Boolean read FDragEnable write FDragEnable;
    property Margin: TViewMargin read FMargin;
    property Items: TViews read FItems;
    property States: TViewStates read FStates;
    property Tag: integer read FTag write FTag;
    property Data: Pointer read FData write FData;
  end;




  TViews = class
  public
    constructor Create(Parent: TView);
    destructor Destroy;override;
  protected
    FParent: TView;
    FItems: TList;
    FOnChange: TViewChangeEvent;
    FUpdateCount: integer;
    function GetView(index: integer): TView;
    function GetCount: integer;
    procedure DoNotifyChange(Action: TViewsChangeAction;View: TView);
    procedure SetScrollView(Value: TScrollView);
  public
    procedure BeginUpdate;
    procedure EndUpdate();
    
    procedure Remove(View: TView);
    procedure Delete(Index: integer);
    procedure Exchange(Item1,Item2: TView);overload;
    procedure Exchange(Item1,Item2: integer);overload;
    procedure Move(Item: TView;Index: integer);overload;
    procedure Move(Item: integer;Index: integer);overload;
    procedure Insert(Index: integer;View: TView);
    procedure Clear();
    function Exract(Index: integer): TView;
    function AddView(View: TView): integer;
    function IndexOf(View: TView): integer;
    function First: TView;
    function Last: TView;
    property Count: integer read GetCount;
    property Item[index: integer]: TView read GetView; default;
    property OnChange: TViewChangeEvent read FOnChange write FOnChange;
  end;

  


  TDropMode = (dmInsertLeft,dmInsertRight,dmInsertChild,dmExchange,dmCancel);
  TDropModeSet = set of TDropMode;
  TDropModeEvent = procedure(src,dest: TView;X,Y: integer;var Mode: TDropMode) of object;
  TDragViewOverEvent = procedure(src,dest: TView;var Accept: Boolean) of object;
  TDroppedViewEvent = procedure (src,dest: TView) of object;
  TViewEvent = procedure (View: TView) of object;

  THintView = class
  public
    constructor Create(ScrollView: TScrollView);
    destructor Destroy;override;
  private
    FTmr: TTimer;
    FX,FY: integer;
    FView: TView;
    FScrollView: TScrollView;
    procedure OnTimer(Sender: TObject);
  public
    procedure Hint(X,Y: integer);
  end;

  TScrollView = class(TCustomControl)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    FPen: TPen;
    FBrush: TBrush;
    FViews: TViews;
    FBmp: TBitmap;
    FBufBmp: TBitmap;
    FScrollPosition: integer;
    FSelected: TView;
    FPopupView: TView;
    FDisplayViews: TList;
    FViewPopMenu: TPopupMenu;
    FDraggingView: TView;
    FDroppingView: TView;
    FOnDropMode: TDropModeEvent;
    FOnDragViewOver: TDragViewOverEvent;
    FOnDropped: TDroppedViewEvent;
    FOnDblView: TViewEvent;
    FOnDropComplete: TDroppedViewEvent;
    FOnClickView: TViewEvent;
    FOnHintView: TViewEvent;
    FDragEnable: Boolean;
    FScrollRange: integer;
    FDroppingColor: TColor;
    FDropModePopMenu: TDropModePopMenu;
    FSelectedBorderColor: TColor;
    FFixSelectedBorderColor: TColor;

    FHintView: THintView;
    procedure OnViewsChange(Action: TViewsChangeAction;View: TView);
    procedure DoDropModeSelect(SourceView,DestView : TView;
      X,Y: integer;var Mode: TDropMode);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure ExtractVisibleViews();
    procedure SetSelected(const Value: TView);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateScroll(Code, Pos: Cardinal);
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure UpdateScrollRange(Range,PageSize: integer);
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;var Accept: Boolean); override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure SetScrollPosition(Value: integer);
    procedure DoScrollChange(Position: integer);

    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): boolean; override;
    function GetViewAt(X,Y: integer): TView;
    function GetViewDispRectFirstLevel(View: TView): TRect;
  public
    function GetTopParentView(View: TView): TView;
    function DoDrop(SourceView,DestView : TView;X, Y: Integer): TDropMode;
    procedure InvalidateView(View: TView);
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure LocateViews();
    procedure MakeVisible(View: TView;AutoSelect: Boolean = True);
    property Views: TViews read FViews;
    property Selected: TView read FSelected write SetSelected;
    property DraggingView: TView read FDraggingView write FDraggingView;
    property PopupView: TView read FPopupView;
    property ViewPopMenue: TPopupMenu read FViewPopMenu write FViewPopMenu;
    property DragEnable: Boolean read FDragEnable write FDragEnable;
    property DroppingColor: TColor read FDroppingColor write FDroppingColor;
    property SelectedBorderColor: TColor read FSelectedBorderColor write FSelectedBorderColor;
    property OnDropMode: TDropModeEvent read FOnDropMode write FOnDropMode;
    property OnDragViewOver: TDragViewOverEvent read FOnDragViewOver write FOnDragViewOver;
    property OnDroppedView: TDroppedViewEvent read FOnDropped write FOnDropped;
    property OnDblView: TViewEvent read FOnDblView write FOnDblView;
    property OnClickView: TViewEvent read FOnClickView write FOnClickView;
    property OnDropComplete: TDroppedViewEvent read FOnDropComplete write FOnDropComplete;
    property OnHintView: TViewEvent read FOnHintView write FOnHintView;
    property DropModePopMenu: TDropModePopMenu read FDropModePopMenu;
    property Canvas;
    property Color;
    property PopupMenu;
  end;

  TDropModePopMenu = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    FModeSet: TDropModeSet;

    FPopMenu: TPopupMenu;

    FModeName: array[Low(TDropMode)..High(TDropMode)] of string;
    
    FModePosition: array[Low(TDropMode)..High(TDropMode)] of integer;

    procedure InitMenuItem();
  public
    procedure SetValidMode(ModeSet: TDropModeSet);

    procedure SetName(Mode: TDropMode;const Name: string);
    
    function Popup(X,Y: integer): TDropMode;
  end;


  
  function ClacViewsPos(R: TRect;Views: TViews): integer;
implementation

uses Types;
  procedure SetInvalidRect(var v: TRect);
  begin
    v.Left := 0;
    v.Top := 0;
    v.Bottom := -1;
    v.Right := -1;
  end;
  
  function IsValidRect(const v: TRect): Boolean;
  begin
    Result := (v.Right > v.Left) and (v.Bottom > v.Top);
  end;

  function ExtendRect(const v: TRect;dx,dy: integer): TRect;
  begin
    Result := v;
    if dy = -1 then
      dy := dx;
      
    Result.Left := Result.Left - dx;
    Result.Top := Result.Top - dy;
    Result.Right := Result.Right + dx;
    Result.Bottom := Result.Bottom + dy;
  end;

function ClacViewsPos(R: TRect;Views: TViews): integer;
var
  I: Integer;
  MaxHeight, MaxWidth: Integer;
  Position: TPoint;
  Size: TSize;
begin
  Result := 0;
  if Views.Count > 0 then
  begin
    MaxHeight := 0;
    MaxWidth := 0;

    Position := R.TopLeft;

    for I := 0 to Views.Count - 1 do
    begin
      with Views[i] do
      begin
        Size.cx := Width + Margin.Left + Margin.Right;
        Size.cy := Height + Margin.Top + Margin.Bottom;
      end;

      if (MaxHeight > 0) and (Position.X + Size.cx > R.Right)then
      begin
        Inc(Position.Y, MaxHeight);
        MaxHeight := 0;
        Position.X := R.Left;
      end;

      if Size.cy > MaxHeight then
        MaxHeight := Size.cy;
      if Size.cx > MaxWidth then
        MaxWidth := Size.cx;

      Views[i].FLeft := Position.X +  Views[i].Margin.Left;
      Views[i].FTop := Position.Y + Views[i].Margin.Top;
      Inc(Position.X, Size.cx );

      if Position.Y + Size.cy > Result then
        Result := Position.Y + Size.cy;
    end;

  end;


end;



{ TScrollView }
constructor TScrollView.Create(AOwner: TComponent);
begin
  inherited;
  FDropModePopMenu := TDropModePopMenu.Create;
  FDisplayViews := TList.Create;
  FHintView := THintView.Create(Self);
  FViews := TViews.Create(nil);
  FBmp := TBitmap.Create;
  FBufBmp := TBitmap.Create;
  FBufBmp.Width := Self.Width;
  FBufBmp.Height := Self.Height;
  DoubleBuffered := True;
  FViews.OnChange := OnViewsChange;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
  FDragEnable := True;
end;

procedure TScrollView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or windows.WS_VSCROLL;
end;

destructor TScrollView.Destroy;
begin
  FDisplayViews.Free;
  FViews.Free;
  FBmp.Free;
  FBufBmp.Free;
  FPen.Free;
  FBrush.Free;
  FDropModePopMenu.Free;
  FHintView.Free;
  inherited;
end;

procedure TScrollView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
var
  I: Integer;
  r: TRect;
  v: TView;
begin
  Handled := True;
  for I := FDisplayViews.Count - 1 downto 0 do
  begin
    v := TView(FDisplayViews[i]);
    r := GetViewDispRectFirstLevel(v);

    if PtInRect(r,MousePos) then
    begin
      if (FViewPopMenu <> nil) and FViewPopMenu.AutoPopup then
      begin
        SendCancelMode(Self);
        FViewPopMenu.PopupComponent := Self;


        FPopupView := v.GetViewAt(MousePos.X - v.FLeft, MousePos.Y - v.FTop - -FScrollPosition);
        
        MousePos := ClientToScreen(MousePos);
        FViewPopMenu.Popup(MousePos.X, MousePos.Y);
      end;
      Exit;
    end;

  end;
  if (PopupMenu <> nil) and PopupMenu.AutoPopup then
  begin
    SendCancelMode(Self);
    PopupMenu.PopupComponent := Self;
    MousePos := ClientToScreen(MousePos);
    PopupMenu.Popup(MousePos.X, MousePos.Y);
  end;


end;


procedure TScrollView.DoDropModeSelect(SourceView,DestView : TView;
  X,Y: integer;var Mode: TDropMode);
begin
  Mode := dmInsertLeft;
  if Assigned(FOnDropMode) then
    FOnDropMode(SourceView,DestView,X,Y,Mode);
end;

procedure TScrollView.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  if FDroppingView <> nil then
  begin
    Exclude(FDroppingView.FStates,vsDragDropping);
    FDroppingView.Invalidate();
    FDroppingView := nil;
  end;
end;

function TScrollView.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): boolean;
var
  WMVScroll: TWMVScroll;
begin
  ZeroMemory(@WMVScroll,SizeOf(WMVScroll));
  WMVScroll.Msg := WM_VSCROLL;
  WMVScroll.ScrollBar := 0;
  WMVScroll.ScrollCode := Ord(SB_PAGEDOWN);

  Dispatch(WMVScroll);
  Result := True;
end;


function TScrollView.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): boolean;
var
  WMVScroll: TWMVScroll;
begin
  ZeroMemory(@WMVScroll,SizeOf(WMVScroll));
  WMVScroll.Msg := WM_VSCROLL;
  WMVScroll.ScrollCode := Ord(SB_PAGEUP);
  WMVScroll.ScrollBar := 0;
  Dispatch(WMVScroll);
  Result := True;
end;      

procedure TScrollView.DoScrollChange(Position: integer);
begin
  FScrollPosition := Position;
  ExtractVisibleViews();
  Invalidate;
end;

procedure TScrollView.DragDrop(Source: TObject; X, Y: Integer);
begin
  if DoDrop(FDraggingView,FDroppingView,X,Y) <> dmCancel then
  begin
    if Assigned(FOnDropComplete) then
      FOnDropComplete(FDraggingView,FDroppingView);
  end;

  if FDroppingView = nil then Exit;

  Exclude(FDroppingView.FStates,vsDragDropping);

  if Assigned(FOnDropped) then
    FOnDropped(FDraggingView,FDroppingView);
end;

procedure TScrollView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
  function GetAccetRectOffSet(v: TView): TRect;
  var
    r: TRect;
    nLeft,nTop: integer;
  begin
    nLeft := 0;
    nTop := 0;
    r := v.DropAcceptRect;
    while v.Parent <> nil do
    begin
      nLeft := nLeft + v.Left;
      nTop := nTop + v.Top;
      v := v.Parent;
    end;

    nLeft := nLeft + v.Left;
    nTop := nTop + v.Top;

    OffsetRect(r,nLeft,nTop);
    OffsetRect(r,0,-FScrollPosition);
    Result := r;

    v.DropAcceptRect;
  end;
var
  View: TView;
begin
  View := GetViewAt(X,Y);
//  View := GetViewAt(X,Y);
  //不允许父VIEW拖拽到子VIEW上
  Accept := (View <> nil) and (View <> FDraggingView) and (View.CanDrop) and
  (not FDraggingView.ParentOf(View));

  try
    if Accept then
    begin
      if not PtInRect(GetAccetRectOffSet(View),Point(X,Y)) then
      begin
        Accept := False;
        Exit;
      end;

      if FDragEnable then
      begin
        if Assigned(FOnDragViewOver) then
          FOnDragViewOver(FDraggingView,View,Accept);
      end
      else
        Accept := False;



      if Accept then
      begin
        if FDroppingView <> View then
        begin
          if FDroppingView <> nil then
          begin
            Exclude(FDroppingView.FStates,vsDragDropping);
            FDroppingView.Invalidate();
          end;


          FDroppingView := View;
          Include(FDroppingView.FStates,vsDragDropping);

          FDroppingView.Invalidate();
        end;
      end;


    end;

  finally
    if not Accept and (FDroppingView <> nil) then
    begin
      if vsDragDropping in FDroppingView.FStates then
      begin
        Exclude(FDroppingView.FStates,vsDragDropping);
        FDroppingView.Invalidate();
      end;

      FDroppingView := nil;
    end;
  end;


end;

procedure TScrollView.ExtractVisibleViews;
var
  R,viewRect: TRect;
  I: Integer;
begin
  R := ClientRect;
  OffsetRect(R,0,FScrollPosition);
  FDisplayViews.Clear;
  for I := 0 to FViews.Count - 1 do
  begin
    viewRect := FViews[i].BoundRect;
    if not PtInRect(R,viewRect.TopLeft) and
          not PtInRect(R,viewRect.BottomRight) and
          not PtInRect(R,Point(viewRect.Right,viewRect.Top)) and
          not PtInRect(R,Point(viewRect.Left,viewRect.Bottom))
      then Continue;
      
    FDisplayViews.Add(FViews[i]);
  end;
end;

function TScrollView.GetTopParentView(View: TView): TView;
begin
  Result := View;
  while Result.Parent <> nil do
    Result := Result.Parent;
end;

function TScrollView.GetViewAt(X, Y: integer): TView;
var
  I: Integer;
  r: TRect;
begin
  Result := nil;
  for I := 0 to FDisplayViews.Count - 1 do
  begin
    r := GetViewDispRectFirstLevel(TView(FDisplayViews[i]));


    if PtInRect(r,Point(X,Y)) then
    begin
      Result := TView(FDisplayViews[i]).GetViewAt(x - r.Left,y - r.Top);
      Break;
    end;
  end;
end;

function TScrollView.GetViewDispRectFirstLevel(View: TView): TRect;
begin
  Result := View.BoundRect;
  OffsetRect(Result,0,-FScrollPosition);
end;


procedure TScrollView.InvalidateView(View: TView);
var
  r: TRect;
begin
  r := View.BoundRect;

  OffsetRect(r,0,-FScrollPosition);
  InvalidateRect(Handle,@r,True);
end;

procedure TScrollView.LocateViews;
var
  ScrollRange: integer;
begin
  FViews.SetScrollView(self);
  ScrollRange := ClacViewsPos(ClientRect,FViews);

  if ScrollRange < ClientHeight then
  begin
    ScrollRange := ClientHeight;
  end;

  UpdateScrollRange(ScrollRange,Round(ClientHeight * 0.8));

  FScrollPosition := GetScrollPos(Handle,SB_VERT);
  ExtractVisibleViews();
  Invalidate;
end;


procedure TScrollView.UpdateScroll(Code, Pos: Cardinal);
var
  scrollInfo: tagSCROLLINFO;
begin
  case Code of
    SB_LINEUP,
    SB_LINEDOWN,
    SB_PAGEUP,
    SB_PAGEDOWN:
      begin
        scrollInfo.cbSize := SizeOf(scrollInfo);
        scrollInfo.fMask := SIF_PAGE or SIF_POS;
        GetScrollInfo(Handle,SB_VERT,scrollInfo);

        Pos := scrollInfo.nPos;
        if scrollInfo.nPage = 0 then
          scrollInfo.nPage := 1;
          
        case Code of
          SB_LINEUP: Dec(Pos);
          SB_LINEDOWN: Inc(Pos);
          SB_PAGEUP: Pos := Pos - scrollInfo.nPage div 2;
          SB_PAGEDOWN: Pos := Pos + scrollInfo.nPage div 2;
        end;
      end;
    SB_THUMBPOSITION:
      begin
        Exit; 
      end;
    SB_THUMBTRACK:
      begin
        scrollInfo.cbSize := SizeOf(scrollInfo);
        scrollInfo.fMask := SIF_TRACKPOS;
        GetScrollInfo(Handle,SB_VERT,scrollInfo);
        Pos := scrollInfo.nTrackPos;
      end;
    SB_BOTTOM,
    SB_TOP:
      begin
        scrollInfo.cbSize := SizeOf(scrollInfo);
        scrollInfo.fMask := SIF_RANGE or SIF_PAGE;
        GetScrollInfo(Handle,SB_VERT,scrollInfo);
        if Code = SB_BOTTOM then
          Pos := scrollInfo.nMax 
        else
          Pos := 0;
      end;
    SB_ENDSCROLL: Exit;
  end;

  SetScrollPos(Handle, SB_VERT, Pos, True);

  Pos := GetScrollPos(Handle, SB_VERT);

  DoScrollChange(Pos);
end;

procedure TScrollView.MakeVisible(View: TView;AutoSelect: Boolean);
var
  r: TRect;
  pos: integer;
begin
  if View = nil then Exit;

//  r := GetViewDispRectFirstLevel(View);

  r.TopLeft := View.AbsolutePos;
  r.Right := r.Left + View.Width;
  r.Bottom := r.Top + View.Height;
  OffsetRect(r,0,-FScrollPosition);

  if AutoSelect then
    Selected := View;
  if not PtInRect(ClientRect,r.TopLeft) or not PtInRect(ClientRect,r.BottomRight) then
  begin

    pos := FScrollPosition;
    if r.Top < 0 then
    begin
      pos := pos + r.Top;
    end
    else
    if r.Bottom > ClientHeight then    
    begin
      pos := pos + r.Bottom - ClientHeight;
    end;
    
    SetScrollPosition(pos);
    DoScrollChange(FScrollPosition);
  end;
end;

procedure TScrollView.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
var
  View: TView;
begin
  if not Focused then
  begin
    Windows.SetFocus(self.Handle);
  end;

  inherited;
  

  View := GetViewAt(X,Y);
  if Assigned(View) and View.CanSelect then
  begin
    Selected := View;

    if (ssDouble in Shift) then
    begin
      if Assigned(FOnDblView) then
        FOnDblView(View);
    end
    else
    begin
      if (Button = mbLeft) and Self.FDragEnable and (Selected.DragEnable)then
      begin
        FDraggingView := FSelected;
        BeginDrag(False);
      end;
    end;

  end;

end;

procedure TScrollView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  FHintView.Hint(X,Y);  
  inherited;
end;

procedure TScrollView.OnViewsChange(Action: TViewsChangeAction;View: TView);
begin
  case Action of
    caExtracting: Exit;
    caDeleting:
    begin
      if FSelected = View then
      begin
        Selected := nil;
      end;
      Exit;
    end;
    caClearing,caUpdateEnd:
    begin
      Selected := nil;
    end;
    caAdd: ;
    caExtract: ;
    caDelete:;
    caClear: ;
    caUndefined: ;
  end;
  
  LocateViews();
end;

procedure TScrollView.Paint;
var
  I: Integer;
  View: TView;
begin
  FBmp.Width := ClientWidth;
  FBmp.Height := ClientHeight;
  FBmp.Canvas.Brush.Color := Color;
  FBmp.Canvas.FillRect(ClientRect);
  
  for I := 0 to FDisplayViews.Count - 1 do
  begin
    FBufBmp.Canvas.Brush.Assign(FBrush);
    FBufBmp.Canvas.Pen.Assign(FPen);
    FBufBmp.Canvas.FillRect(FBufBmp.Canvas.ClipRect);
    View := TView(FDisplayViews[i]);
    View.Draw(FBufBmp.Canvas);
  
    FBmp.Canvas.CopyRect(GetViewDispRectFirstLevel(View)
      ,FBufBmp.Canvas,View.ClientRect);
  end;

  Canvas.CopyRect(ClientRect,FBmp.Canvas,ClientRect);
end;
function TScrollView.DoDrop(SourceView, DestView: TView; X, Y: Integer): TDropMode;
var
  DragingIndex: integer;
  DroppingIndex: integer;
  Mode: TDropMode;
  Owner1,Owner2: TViews;
begin
  Result := dmCancel;
  if DestView = nil then Exit;
  DroppingIndex := DestView.FOwnerViews.IndexOf(DestView);
  DragingIndex :=  SourceView.FOwnerViews.IndexOf(SourceView);

  DoDropModeSelect(SourceView,DestView,X,Y,Mode);

  case Mode of
    dmCancel: Exit;
    dmInsertLeft:
      begin
        if DestView.FOwnerViews = SourceView.FOwnerViews then
        begin
          DestView.FOwnerViews.Move(DragingIndex,DroppingIndex);
        end
        else
        begin
          SourceView.FOwnerViews.Exract(DragingIndex);
          DestView.FOwnerViews.Insert(DroppingIndex,SourceView);
        end;
      end;
    dmInsertRight:
      begin
        if DestView.FOwnerViews = SourceView.FOwnerViews then
        begin
          DestView.FOwnerViews.Move(DragingIndex,DroppingIndex + 1);
        end
        else
        begin
          SourceView.FOwnerViews.Exract(DragingIndex);
          DestView.FOwnerViews.Insert(DroppingIndex + 1,SourceView);
        end;
      end;
    dmInsertChild:
      begin
        SourceView.FOwnerViews.Exract(DragingIndex);
        DestView.Items.AddView(SourceView);
      end;
    dmExchange:
      begin
        if SourceView.FOwnerViews = DestView.FOwnerViews then
        begin
          SourceView.FOwnerViews.Exchange(DragingIndex,DroppingIndex);
          if SourceView.Parent = nil then
            LocateViews()
          else
            SourceView.Parent.LocateViews();
        end
        else
        begin
          //不允许和父节点交换
          if DestView.ParentOf(SourceView)
            or SourceView.ParentOf(DestView) then Exit;
            
          Owner1 := SourceView.FOwnerViews;
          Owner2 := DestView.FOwnerViews;

          Owner1.Exract(DragingIndex);
          Owner2.Exract(DroppingIndex);

          Owner1.Insert(DragingIndex,DestView);
          Owner2.Insert(DroppingIndex,SourceView);
        end;

      end;
  end;

  Result := Mode;
end;

procedure TScrollView.Resize;
begin
  FBufBmp.Width := Self.Width;
  FBufBmp.Height := Self.Height;
  
  LocateViews();
end;

procedure TScrollView.SetScrollPosition(Value: integer);
begin
  SetScrollPos(Handle,SB_VERT,Value,True);
  FScrollPosition := GetScrollPos(Handle,SB_VERT);
end;

procedure TScrollView.SetSelected(const Value: TView);
begin
  if FSelected <> Value then
  begin
    if FSelected <> nil then
    begin
      Exclude(FSelected.FStates,vsSelected);
      FSelected.Invalidate();
    end;

    FSelected := Value;
    if FSelected <> nil then
    begin
      Include(FSelected.FStates,vsSelected);
      FSelected.Invalidate();
    end;

  end;

end;

procedure TScrollView.UpdateScrollRange(Range,PageSize: integer);
var
  SCROLLINFO: tagSCROLLINFO;
begin
  SCROLLINFO.cbSize := SizeOf(SCROLLINFO);
  SCROLLINFO.fMask := SIF_RANGE;
  if PageSize > 0 then
  begin
    SCROLLINFO.fMask := SIF_PAGE OR SCROLLINFO.fMask;
    SCROLLINFO.nPage := PageSize;
  end;

  SCROLLINFO.nMin := 0;
  if Range = ClientHeight then
    SCROLLINFO.nMax := 0
  else
    SCROLLINFO.nMax := Range;

  FScrollRange := Range;
  
  SetScrollInfo(Handle,SB_VERT,SCROLLINFO,True);
end;


procedure TScrollView.WMLButtonUp(var Message: TWMLButtonUp);
var
  View: TView;
begin
  if csCaptureMouse in ControlStyle then MouseCapture := False;
  if csClicked in ControlState then
  begin
    if Assigned(FOnClickView) then
    begin
      View := GetViewAt(Message.XPos,Message.YPos);
      if Assigned(View) then
      begin
        FOnClickView(View);
      end;
    end;
  end;
  inherited;
end;


procedure TScrollView.WMVScroll(var Msg: TWMVScroll);
begin
  UpdateScroll(Msg.ScrollCode, Msg.Pos);
end;



{ TViews }

function TViews.AddView(View: TView): integer;
begin
  Insert(Count,View);
  Result := Count - 1;
end;

procedure TViews.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TViews.Clear;
begin
  DoNotifyChange(caClearing,nil);
  try
    BeginUpdate();
    while FItems.Count > 0 do
    begin
      Delete(FItems.Count - 1);
    end;
  finally
    EndUpdate;
  end;
 DoNotifyChange(caClear,nil);
end;

constructor TViews.Create(Parent: TView);
begin
  FItems := TList.Create;
  FParent := Parent;
end;

procedure TViews.Delete(Index: integer);
begin
  DoNotifyChange(caDeleting,TView(FItems[Index]));
  TView(FItems[Index]).Free;
  FItems.Delete(Index);
  DoNotifyChange(caDelete,nil);
end;

destructor TViews.Destroy;
begin
  FOnChange := nil;
  Clear();
  FItems.Free;
  inherited;
end;
procedure TViews.DoNotifyChange(Action: TViewsChangeAction;View: TView);
begin
  if FUpdateCount > 0 then Exit;
  
  if Assigned(FOnChange) then
    FOnChange(Action,View);
end;


procedure TViews.Exchange(Item1, Item2: TView);
var
  index1,index2: integer;
begin
  index1 := IndexOf(Item1);
  index2 := IndexOf(Item2);
  Exchange(index1,index2);
end;

procedure TViews.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
    begin
      DoNotifyChange(caUpdateEnd,nil);
    end;
    
  end;
end;

procedure TViews.Exchange(Item1, Item2: integer);
begin
  FItems.Exchange(Item1,Item2);
end;

function TViews.Exract(Index: integer): TView;
begin
  DoNotifyChange(caExtract,TView(Item[Index]));
  Result := Item[Index];
  FItems.Delete(Index);
  DoNotifyChange(caExtract,nil);
end;

function TViews.First: TView;
begin
  if Count > 0 then
    Result := Item[0]
  else
    Result := Nil;
  
end;

function TViews.GetCount: integer;
begin
  Result := FItems.Count;
end;

function TViews.GetView(index: integer): TView;
begin
  Result := TView(FItems[index]);
end;

function TViews.IndexOf(View: TView): integer;
begin
  Result := FItems.IndexOf(View);
end;


procedure TViews.Insert(Index: integer; View: TView);
begin
  FItems.Insert(Index,View);
  if (FParent <> nil) and (FParent.FScrollView <> nil) then
    View.SetScrollView(FParent.FScrollView);
    
  View.Parent := FParent;
  View.FOwnerViews := Self;
  DoNotifyChange(caAdd,View);
end;

function TViews.Last: TView;
begin
  if Count > 0 then
    Result := TView(FItems.Last)
  else
    Result := nil;
end;

procedure TViews.Move(Item, Index: integer);
var
  data: Pointer;
begin
  data := FItems[Item];
  FItems.Delete(Item);
  //当Item小于Index时，由于INSERT操作时，ITEM已经删除，需要把IDNEX - 1
  if Item < Index then
    Index := Index - 1;
    
  FItems.Insert(Index,data);
  DoNotifyChange(caUndefined,nil);
end;

procedure TViews.Move(Item: TView; Index: integer);
var
  orgIndex: Integer;
begin
  orgIndex := IndexOf(Item);
  Move(orgIndex,Index);
end;

procedure TViews.Remove(View: TView);
var
  index: integer;
begin
  index := IndexOf(View);
  if index <> -1 then
  begin
    Delete(index);
  end;
end;

procedure TViews.SetScrollView(Value: TScrollView);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    Item[i].SetScrollView(Value);
  end;
end;

function TView.AbsolutePos: TPoint;
var
  v: TView;
begin
  v := Self;

  Result.X := 0;
  Result.Y := 0;

  while v <> nil do
  begin
    Result.X := v.BoundRect.TopLeft.X + Result.X;
    Result.Y := v.BoundRect.TopLeft.Y + Result.Y;

    v := v.Parent;
  end;
  
end;

procedure TView.BeforeDraw(Canvas: TCanvas);
begin
  //由子类实现，用来在绘制前初始化数据，如在动态数据时的背景色等
end;

function TView.BoundRect: TRect;
begin
  Result := Rect(FLeft,FTop,FLeft + FWidth,FTop + FHeight);
end;



function TView.CanDrop: Boolean;
begin
  Result := True;
end;

function TView.CanSelect: Boolean;
begin
  Result := True;
end;

function TView.ClientRect: TRect;
begin
  Result := Rect(0,0,Width,Height);
end;

constructor TView.Create;
begin
  FAutoLocateChilds := True;
  FItems := TViews.Create(self);
  FItems.OnChange := OnItemsChange;
  FWidth := 60;
  FHeight := 100;
  FMargin := TViewMargin.Create(self);
  FFont := TFont.Create;
  FColor := clWindow;
  FBorderColor := clBlack;
  FDragEnable := True;
end;

function TView.Desp: string;
begin
  Result := ClassName;
end;

destructor TView.Destroy;
begin
  FFont.Free;
  FItems.Free;
  FMargin.Free;
  inherited;
end;

procedure TView.Draw(Canvas: TCanvas);
  procedure DrawSelected();
  var
    r: TRect;
  begin
    if vsFixSelected in FStates then
    begin
      if FScrollView.FFixSelectedBorderColor > 0 then
        Canvas.Pen.Color := FScrollView.FFixSelectedBorderColor
      else
        Canvas.Pen.Color := clRed;
    end
    else
    if vsSelected in FStates then    
    begin
      if FScrollView.FSelectedBorderColor > 0 then
        Canvas.Pen.Color := FScrollView.FSelectedBorderColor
      else
        Canvas.Pen.Color := clRed;
    end
    else
      Exit;

    
    Canvas.Pen.Width := 2;
    Canvas.Pen.Style := psSolid;
    r := ClientRect;
    r.Left := 1;
    r.Top := 1;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(r);
  end;
begin
  BeforeDraw(Canvas);
  

  Canvas.Brush.Color := Color; 
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ClientRect);

  if vsDragDropping in FStates then
  begin
    if FScrollView.FDroppingColor <> 0 then
      Canvas.Brush.Color := FScrollView.FDroppingColor
    else
      Canvas.Brush.Color := $00F0EEEC;

    Canvas.FillRect(DropAcceptRect);
  end;
  
  DrawContent(Canvas);
  
  DrawChilds(Canvas);

  if (vsSelected in FStates) or (vsFixSelected in FStates) then
  begin
    DrawSelected();
  end
  else
  begin
    Canvas.Pen.Color := BorderColor;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(ClientRect);
  end;

end;


procedure TView.DrawChilds(Canvas: TCanvas);
var
  i: integer;
  bmp: TBitmap;
begin
  if FItems.Count = 0 then Exit;

  bmp := TBitmap.Create;
  try
    bmp.Width := Width;
    bmp.Height := Height;
    
    for I := 0 to FItems.Count - 1 do
    begin
      if not PtInRect(ClientRect,FItems[i].BoundRect.TopLeft) then Continue;

      if FScrollView = nil then
        OutputDebugString('');
      bmp.Canvas.Brush.Assign(FScrollView.FBrush);
      bmp.Canvas.Pen.Assign(FScrollView.FPen);
      bmp.Canvas.FillRect(bmp.Canvas.ClipRect);

      FItems[i].Draw(bmp.Canvas);
      Canvas.CopyRect(FItems[i].BoundRect,bmp.Canvas,FItems[i].ClientRect);
    end;

  finally
    bmp.Free;
  end;

end;

procedure TView.DrawContent(Canvas: TCanvas);
begin
  Canvas.TextOut(0,0,Format('$%p',[pointer(self)]));
  //由子类实现
end;

function TView.DropAcceptRect: TRect;
begin
  Result := ClientRect;
end;

function TView.GetViewAt(X, Y: integer): TView;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    if PtInRect(FItems[i].BoundRect,point(x,y)) then
    begin
      Result := FItems[i].GetViewAt(x - FItems[i].BoundRect.Left,y - FItems[i].BoundRect.Top);
      Break;
    end;

  end;
  if Result = nil then
    Result := Self;
end;

procedure TView.Invalidate;
begin
  if FScrollView <> nil then
  begin
    FScrollView.InvalidateView(FScrollView.GetTopParentView(self));
  end;
end;

function TView.ParentOf(View: TView): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Items.Count - 1 do
  begin
    Result := Items[i] = View;
    if Result then Break;
      
    Result := Items[i].ParentOf(View);
    if Result then Break;    
  end;
end;

procedure TView.LocateViews;
begin
  if not FAutoLocateChilds then Exit;
  
  ClacViewsPos(ClientRect,FItems);

  Invalidate();
end;

procedure TView.OnItemsChange(Action: TViewsChangeAction;View: TView);
begin
  case Action of
    caDeleting:
      begin
        if Assigned(FScrollView) and (FScrollView.Selected = View) then
          FScrollView.Selected := nil;
      end;
    caClearing:
    begin
      if Assigned(FScrollView) then
      begin
        if FScrollView.Selected <> nil then
        begin
          if Items.IndexOf(FScrollView.Selected) <> -1 then
          begin
            FScrollView.Selected := nil;
          end;
        end;
      end;
    end;
    caExtracting: Exit;
  else
    LocateViews();
  end;

end;

procedure TView.SetHeigth(const Value: integer);
begin
  if Value <> FHeight then
  begin
    FHeight := Value;
    OnItemsChange(caUndefined,nil);
    if Parent <> nil then
    begin
      Parent.OnItemsChange(caUndefined,nil);
    end;
  end;
end;

procedure TView.SetScrollView(Value: TScrollView);
begin
  if FScrollView <> Value then
  begin
    FScrollView := Value;
    FItems.SetScrollView(Value);
  end;
end;

procedure TView.SetWidth(const Value: integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    OnItemsChange(caUndefined,nil);
    if Parent <> nil then
    begin
      Parent.OnItemsChange(caUndefined,nil);
    end;
  end;
end;

{ TViewMargin }

function TViewMargin.BoundRect: TRect;
begin
  Result := FView.BoundRect;
  Result.Left := Result.Left + Left;
  Result.Top := Result.Top + Top;
  Result.Right := Result.Right - Right;
  Result.Bottom := Result.Bottom - Bottom;
end;

constructor TViewMargin.Create(View: TView);
begin
  FView := View;
  FLeft := 3;
  FTop := 3;
  FRight := 3;
  FBottom := 3;
end;

procedure TViewMargin.SetMargin(ALeft, ATop, ARigth, ABottom: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FRight := ARigth;
  FBottom := ABottom;
end;

procedure TViewMargin.SetValue(index, value: integer);
begin
  case index of
    0: FLeft := value;
    1: FTop := value;
    2: FRight := value;
    3: FBottom := value;
  end;
end;



{ TDropModePopMenu }

constructor TDropModePopMenu.Create;
begin
  FPopMenu := TPopupMenu.Create(nil);
  
  FModeName[dmInsertLeft] := '插入左侧';
  FModeName[dmInsertRight] := '插入右侧';
  FModeName[dmInsertChild] := '插入为子节点';
  FModeName[dmExchange] := '交换位置';
  FModeName[dmCancel] := '取消';

  FModeSet := [dmInsertLeft,dmInsertChild,dmExchange,dmCancel];
  InitMenuItem();
end;

destructor TDropModePopMenu.Destroy;
begin
  FPopMenu.Free;
  inherited;
end;

procedure TDropModePopMenu.InitMenuItem;
var
  Item: TMenuItem;
  I: TDropMode;
  procedure InsertSplit();
  begin
    Item := TMenuItem.Create(FPopMenu);
    Item.Caption := '-';
    FPopMenu.Items.Add(Item);
  end;
begin
  FillChar(POINTER(@FModePosition)^,SizeOf(FModePosition),0);

  FPopMenu.Items.Clear();

  for I := Low(TDropMode) to High(TDropMode) do
  begin
    if not (I in FModeSet) then Continue;
    
    if I = dmCancel then
      InsertSplit();

    Item := TMenuItem.Create(FPopMenu);
    Item.Caption := FModeName[I];
    FPopMenu.Items.Add(Item);

    FModePosition[I] := Item.Command;
  end;
end;

function TDropModePopMenu.Popup(X, Y: integer): TDropMode;
var
  AFlags: integer;
  ret: Bool;
  position: integer;
  I: TDropMode;
begin
  Result := dmCancel;
  AFlags :=
  TPM_NONOTIFY
  OR TPM_RETURNCMD
  OR TPM_LEFTBUTTON;


  ret := TrackPopupMenu(FPopMenu.Items.Handle, AFlags, X, Y, 0 { reserved }, PopupList.Window, nil);

  position := PInteger(@ret)^;

  if position = 0 then
  begin
    Result := dmCancel;
    Exit;
  end;


  for I := Low(FModePosition) to High(FModePosition) do
  begin
    if FModePosition[i] = position then
    begin
      Result := I;
      Break;
    end;
  end;

end;

procedure TDropModePopMenu.SetName(Mode: TDropMode; const Name: string);
begin
  FModeName[Mode] := Name;
  InitMenuItem();
end;

procedure TDropModePopMenu.SetValidMode(ModeSet: TDropModeSet);
begin
  FModeSet := ModeSet;
  InitMenuItem();
end;

{ THintView }
constructor THintView.Create(ScrollView: TScrollView);
begin
  FScrollView := ScrollView;
  FTmr := TTimer.Create(nil);
  FTmr.Enabled := False;
  FTmr.Interval := 1000;
  FTmr.OnTimer := OnTimer;
end;

destructor THintView.Destroy;
begin
  FTmr.Free;
  inherited;
end;

procedure THintView.Hint(X, Y: integer);
var
  View: TView;
begin
  if (FX <> X) or (FY <> Y) then
  begin
    FX := X;
    FY := Y;

    View := FScrollView.GetViewAt(FX,FY);
    if View <> FView then
    begin
      FView := View;
      FTmr.Enabled := False;
      if FView <> nil then      
        FTmr.Enabled := True;
    end;
  end;
end;

procedure THintView.OnTimer(Sender: TObject);
var
  v: TView;
begin
  FTmr.Enabled := False;
  if Assigned(FScrollView.OnHintView) then
  begin
    v := FScrollView.GetViewAt(FX,FY);

    FView := v;
    
    if v <> nil then
    begin
      FScrollView.OnHintView(v);
    end;
  end;

end;

end.
