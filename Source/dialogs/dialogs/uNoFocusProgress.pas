unit uNoFocusProgress;

interface
uses
  Forms,Messages,Windows,Types,Graphics,Controls,Classes,Contnrs,utfPopTypes,
  StdCtrls, ExtCtrls,  RzPanel, RzLstBox, Buttons, RzCommon, RzBorder, RzPrgres;
type
  TNoFocusProgress = class(TForm)
    lblMsg: TLabel;
    RzBorder1: TRzBorder;
    RzFrameController1: TRzFrameController;
    RzProgressBar: TRzProgressBar;
  public
    constructor Create(AOwner: TComponent); override;
  protected
    procedure Deactivate; override;
  private
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMMOUSEACTIVATE(var Message : TWMMOUSEACTIVATE ); message WM_MOUSEACTIVATE;
  end;

  function NoFocusProgress_Create(): Pointer;stdcall;
  procedure NoFocusProgress_Step(Form: Pointer;PartsComplete,TotalParts: integer;Msg: PAnsiChar);stdcall;
  procedure NoFocusProgress_Close(Form: Pointer);stdcall;
  procedure NoFocusProgress_Free(Form: Pointer);stdcall;
implementation
uses
  SysUtils;
  exports
  NoFocusProgress_Create,
  NoFocusProgress_Step,
  NoFocusProgress_Close,
  NoFocusProgress_Free;


function NoFocusProgress_Create(): Pointer;stdcall;
begin
  Result := TNoFocusProgress.Create(nil);
end;
procedure NoFocusProgress_Step(Form: Pointer;PartsComplete,TotalParts: integer;Msg: PAnsiChar);stdcall;
begin
  with TNoFocusProgress(Form) do
  begin
    lblMsg.Caption := Msg;
    RzProgressBar.TotalParts := TotalParts;
    RzProgressBar.PartsComplete := PartsComplete;

    if not Visible then
      Show();
      
    Update();
  end;
end;
procedure NoFocusProgress_Close(Form: Pointer);stdcall;
begin
  with TNoFocusProgress(Form) do
  begin
    Hide();
  end;
end;
procedure NoFocusProgress_Free(Form: Pointer);stdcall;
begin
  with TNoFocusProgress(Form) do
  begin
    Free;
  end;
end;

{$R *.dfm}

constructor TNoFocusProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  {$IFDEF VCL}
  DefaultMonitor := dmDesktop;
  {$ENDIF}
  FormStyle := fsStayOnTop;
end;


procedure TNoFocusProgress.Deactivate;
begin
  inherited;
end;

procedure TNoFocusProgress.WMActivate(var Message: TWMActivate);
begin

end;

procedure TNoFocusProgress.WMMOUSEACTIVATE(var Message: TWMMOUSEACTIVATE);
begin
 Message.result := MA_NOActivate;
end;

end.