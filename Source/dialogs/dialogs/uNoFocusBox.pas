unit uNoFocusBox;

interface
uses
  Forms,Messages,Windows,Types,Graphics,Controls,Classes,Contnrs,utfPopTypes,
  StdCtrls, ExtCtrls,  RzPanel, RzLstBox, Buttons, RzCommon, RzBorder;
const
  TITLEHEIGHT = 30;

  BOTTOMHEIGHT = 20;

  MINCLIENTHEIGHT = 20;
  
  MAXCLIENTHEIGHT = 500;

  MINWIDTH = 400;
  
  MAXWIDTH = 700;

type
  TNoFocusBox = class(TForm)
    Timer1: TTimer;
    lblMsg1: TLabel;
    lblClose: TLabel;
    RzBorder1: TRzBorder;
    RzFrameController1: TRzFrameController;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblCloseMouseEnter(Sender: TObject);
    procedure lblCloseMouseLeave(Sender: TObject);
    procedure lblCloseClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    FLables: TObjectList;
    //失去焦点时关闭
    procedure Deactivate; override;
  private
    //失去焦点的消息
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    //获取或者失去焦点的消息
    procedure WMMOUSEACTIVATE(var Message : TWMMOUSEACTIVATE ); message WM_MOUSEACTIVATE;

    procedure CenterLabel(lbl: TLabel);

    procedure CreateMsgLabel(msgs: array of PAnsiChar);
  public
    class procedure ShowBox(Msg : string; ShowTime : Cardinal);overload;

    class procedure ShowBox(Msg1,Msg2 : string; ShowTime : Cardinal);overload;

    class procedure ShowBox(Msg1,Msg2,Msg3 : string; ShowTime : Cardinal);overload;

    class procedure ShowBox(msgs: array of PAnsiChar; ShowTime : Cardinal);overload;
  end;

  procedure NoFocusBoxMsg(Msg: array of PAnsiChar; ShowTime : Cardinal);stdcall;
implementation
uses
  SysUtils;
  exports
  NoFocusBoxMsg;

procedure NoFocusBoxMsg(Msg: array of PAnsiChar; ShowTime : Cardinal);stdcall;
begin
  TNoFocusBox.ShowBox(Msg,ShowTime);
end;


{$R *.dfm}
constructor TNoFocusBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  {$IFDEF VCL}
  DefaultMonitor := dmDesktop;
  {$ENDIF}
  FormStyle := fsStayOnTop;

  FLables := TObjectList.Create;
end;

procedure TNoFocusBox.CreateMsgLabel(msgs: array of PAnsiChar);
const LineSpace = 7;
var
  I: Integer;
  needHeight: integer;
  needWidth: integer;
begin
  needWidth := 0;
  FLables.Clear;
  for I := 0 to Length(msgs) - 1 do
  begin
    FLables.Add(TLabel.Create(nil));
    TLabel(FLables.Last).Parent := Self;
    TLabel(FLables.Last).Caption := msgs[i];
    TLabel(FLables.Last).Font := lblMsg1.Font;

    TLabel(FLables.Last).Top := TITLEHEIGHT + (LineSpace + lblMsg1.Height) * i;

    needWidth := Max(Canvas.TextWidth(msgs[i]),needWidth);
  end;

  needHeight := Length(msgs) * (lblMsg1.Height + LineSpace);

  Self.Height  := Max(needHeight + + TITLEHEIGHT + BOTTOMHEIGHT,MINCLIENTHEIGHT + TITLEHEIGHT + BOTTOMHEIGHT);

  Self.Height := Min(Self.Height,MAXCLIENTHEIGHT + TITLEHEIGHT + BOTTOMHEIGHT);

  Self.Width := Min(needWidth,MAXWIDTH);

  Self.Width := Max(Self.Width,MINWIDTH);


  for I := 0 to FLables.Count - 1 do
  begin
    CenterLabel(TLabel(FLables[i]));
  end;


  Self.Update;
end;

procedure TNoFocusBox.Deactivate;
begin
  inherited;
end;

destructor TNoFocusBox.Destroy;
begin
  FLables.Free;
  inherited;
end;


procedure TNoFocusBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TNoFocusBox.lblCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TNoFocusBox.lblCloseMouseEnter(Sender: TObject);
begin
  lblClose.Font.Style := [fsUnderline]
end;

procedure TNoFocusBox.lblCloseMouseLeave(Sender: TObject);
begin
  lblClose.Font.Style := []
end;

procedure TNoFocusBox.CenterLabel(lbl: TLabel);
var
  nWidth: Integer;
begin
  nWidth := lbl.Canvas.TextWidth(lbl.Caption);
  
  lbl.Left := (Self.Width - nWidth) div 2;

  if lbl.Left < 10 then
    lbl.Left := 10;
end;

class procedure TNoFocusBox.ShowBox(Msg1, Msg2: string; ShowTime: Cardinal);
begin
  ShowBox([PAnsiChar(Msg1),PAnsiChar(Msg2)],ShowTime);
end;
class procedure TNoFocusBox.ShowBox(Msg: string; ShowTime: Cardinal);
begin
  ShowBox([PAnsiChar(Msg)],ShowTime);
end;

procedure TNoFocusBox.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  Close;
end;

procedure TNoFocusBox.WMActivate(var Message: TWMActivate);
begin

end;

procedure TNoFocusBox.WMMOUSEACTIVATE(var Message: TWMMOUSEACTIVATE);
begin
 Message.result := MA_NOActivate;
end;

class procedure TNoFocusBox.ShowBox(msgs: array of PAnsiChar; ShowTime: Cardinal);
var
  NoFocusBox: TNoFocusBox;
begin
  NoFocusBox := TNoFocusBox.Create(nil);
  NoFocusBox.Timer1.Interval := ShowTime;
  NoFocusBox.CreateMsgLabel(msgs);
  NoFocusBox.Timer1.Enabled := ShowTime <> 0;
  
  NoFocusBox.lblClose.Visible := not NoFocusBox.Timer1.Enabled;

  NoFocusBox.Show;
end;
class procedure TNoFocusBox.ShowBox(Msg1, Msg2, Msg3: string;
  ShowTime: Cardinal);
begin
  ShowBox([PAnsiChar(Msg1),PAnsiChar(Msg2),PAnsiChar(Msg3)],ShowTime);
end;
end.