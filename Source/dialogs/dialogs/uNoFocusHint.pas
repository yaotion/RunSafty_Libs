unit uNoFocusHint;

interface
uses
  Forms,Messages,Windows,Types,Graphics,Controls,Classes,Contnrs,utfPopTypes,
  StdCtrls, ExtCtrls,  RzPanel, RzLstBox, Buttons, RzCommon, RzBorder, RzPrgres;
type
  TNoFocusHint = class(TForm)
    lblMsg: TLabel;
    RzBorder1: TRzBorder;
    RzFrameController1: TRzFrameController;
  public
    constructor Create(AOwner: TComponent); override;
  protected
    procedure Deactivate; override;
  private
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMMOUSEACTIVATE(var Message : TWMMOUSEACTIVATE ); message WM_MOUSEACTIVATE;
  end;

  function NoFocusHint_Create(): Pointer;stdcall;
  procedure NoFocusHint_Hint(Form: Pointer;Msg: PAnsiChar);stdcall;
  procedure NoFocusHint_Close(Form: Pointer);stdcall;
  procedure NoFocusHint_Free(Form: Pointer);stdcall;
implementation
uses
  SysUtils;
  exports
  NoFocusHint_Create,
  NoFocusHint_Hint,
  NoFocusHint_Close,
  NoFocusHint_Free;


function NoFocusHint_Create(): Pointer;stdcall;
begin
  Result := TNoFocusHint.Create(nil);
end;
procedure NoFocusHint_Hint(Form: Pointer;Msg: PAnsiChar);stdcall;
begin
  with TNoFocusHint(Form) do
  begin
    lblMsg.Caption := Msg;
    if not Visible then
      Show();
      
    lblMsg.Update();
  end;
end;
procedure NoFocusHint_Close(Form: Pointer);stdcall;
begin
  with TNoFocusHint(Form) do
  begin
    Hide();
  end;
end;
procedure NoFocusHint_Free(Form: Pointer);stdcall;
begin
  with TNoFocusHint(Form) do
  begin
    Free;
  end;
end;

{$R *.dfm}

constructor TNoFocusHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  BorderStyle := bsNone;
  {$IFDEF VCL}
  DefaultMonitor := dmDesktop;
  {$ENDIF}
  FormStyle := fsStayOnTop;
end;


procedure TNoFocusHint.Deactivate;
begin
  inherited;
end;

procedure TNoFocusHint.WMActivate(var Message: TWMActivate);
begin

end;

procedure TNoFocusHint.WMMOUSEACTIVATE(var Message: TWMMOUSEACTIVATE);
begin
 Message.result := MA_NOActivate;
end;

end.