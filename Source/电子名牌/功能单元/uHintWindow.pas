unit uHintWindow;

interface
uses
  Controls,windows,classes,forms,StdCtrls,ExtCtrls,uFrameNamePlate,SysUtils,
  uTrainman;
type
  TNPHintWindow = class(THintWindow)
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  protected
    m_Tmr: TTimer;
    m_Tm: PTm;
    procedure OnTimer(Sender: TObject);
    procedure Paint; override;
    procedure DrawTmHint(const R: TRect);
    procedure ActiveHint(Rect: TRect; const AHint: string);
  private
    class var _HintWindow: TNPHintWindow;
  public
    class procedure CloseHint();
    class procedure Hint(pt: TPoint;tm: PTm);overload;
    class procedure Hint(pt: TPoint;Text: string);overload;
    class procedure Hint(pt: TPoint;width,height: integer;Text: string);overload;
  end;

  
implementation

{ TTFHintWindow }


class procedure TNPHintWindow.Hint(pt: TPoint;Text: string);
begin
  Hint(pt,200,100,Text);
end;

procedure TNPHintWindow.ActiveHint(Rect: TRect; const AHint: string);
begin
  Inc(Rect.Bottom, 4);
    UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_NOACTIVATE);

  ParentWindow := Application.Handle;
  ShowWindow(Handle, SW_SHOWNOACTIVATE);
  Invalidate;
end;

class procedure TNPHintWindow.CloseHint;
begin
  if _HintWindow <> nil then
  begin
    _HintWindow.Free;
    _HintWindow := nil;
  end;
end;

constructor TNPHintWindow.Create(AOwner: TComponent);
begin
  Inherited Create(nil);
  Font.Size := 12;
  m_Tmr := TTimer.Create(self);
  m_Tmr.Enabled := False;
  m_Tmr.OnTimer := OnTimer;
  m_Tmr.Interval := 2000;
end;

destructor TNPHintWindow.Destroy;
begin
  inherited;
end;

procedure TNPHintWindow.DrawTmHint(const R: TRect);
var
  nLineHeight: integer;
  nTop: integer;
begin
  nLineHeight := Canvas.TextHeight('A');
  nLineHeight := nLineHeight + nLineHeight div 2;
  nTop := R.Top;

  Canvas.TextOut(r.Left,nTop,Format('人员:[%s]%s',[m_Tm.strTrainmanNumber,m_Tm.strTrainmanName]));
  Inc(nTop,nLineHeight);

  Canvas.TextOut(r.Left,nTop,'职位:' + TRsPostNameAry[m_Tm.nPostID]);
  Inc(nTop,nLineHeight);

  Canvas.TextOut(r.Left,nTop,'电话:' + m_Tm.strTelNumber);
  Inc(nTop,nLineHeight);

  Canvas.TextOut(r.Left,nTop,'最后退勤:' + FormatDateTime('mm-dd hh:nn',m_Tm.dtLastEndworkTime));
end;

class procedure TNPHintWindow.Hint(pt: TPoint; tm: PTm);
begin
  CloseHint();
  
  _HintWindow := TNPHintWindow.Create(nil);

  _HintWindow.m_Tm := tm;
  
  _HintWindow.ActiveHint(Rect(pt.X,pt.Y,pt.X + 270,pt.Y + 170),'');

  _HintWindow.m_Tmr.Enabled := True;
end;


class procedure TNPHintWindow.Hint(pt: TPoint; width, height: integer;
  Text: string);
begin
  CloseHint();
  
  _HintWindow := TNPHintWindow.Create(nil);

  _HintWindow.Caption := Text;
  
  _HintWindow.ActiveHint(Rect(pt.X,pt.Y,pt.X + width,pt.Y + height),Text);

  _HintWindow.m_Tmr.Enabled := True;
end;

procedure TNPHintWindow.OnTimer(Sender: TObject);
begin
  m_Tmr.Enabled := False;
  Visible := False;
end;

procedure TNPHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 10);
  Inc(R.Top, 10);
  Canvas.Font := Self.Font;
  Canvas.Font.Color := Screen.HintFont.Color;

  if m_Tm = nil then
    DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
      DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly)
  else
    DrawTmHint(R);

end;


initialization

finalization
  TNPHintWindow.CloseHint();
end.
