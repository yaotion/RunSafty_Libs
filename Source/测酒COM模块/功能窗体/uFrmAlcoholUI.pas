unit uFrmAlcoholUI;

interface

uses
  Classes,Forms,RsAlcoholLib_TLB;

const
  MAX_COUNT = 5; //允许测试的最大计数
  TIMEOUT = 30; //测酒超时时间为30秒
type

  TFormAlcoholUI  = class(TForm)
  private
    m_OnCancel : TNotifyEvent;
    m_OnTimeOut : TNotifyEvent;
  private
    procedure SetOnCancel(const Value: TNotifyEvent);
    function GetOnCancel():TNotifyEvent;

    procedure SetOnTimeOut(const Value: TNotifyEvent);
    function GetOnTimeOut():TNotifyEvent;
  protected
    procedure CancelTest;
    procedure TimerOut;
  public
    procedure InitUI(UI : IAlcoholUI);virtual;
    procedure SetReady;virtual;
    procedure SetNormal;virtual;
    procedure SetMore;virtual;
    procedure SetMuch;virtual;
    procedure SetError(ErrorMsg : string); virtual;
    procedure CloseUI; virtual;
    function  GetCameraHandle: Cardinal; virtual;
    procedure SetPos(Pos:Integer); virtual;

    property CameraHandle : Cardinal   read GetCameraHandle ;
    property OnCancel : TNotifyEvent read GetOnCancel write SetOnCancel ;
    property OnTimeOut : TNotifyEvent read GetOnTimeOut write SetOnTimeOut;
  end;

implementation

uses
  Controls;
{ TFormAlcoholUI }

procedure TFormAlcoholUI.CancelTest;
begin
  if assigned(m_OnCancel) then
  begin
    m_OnCancel(Self);
  end;
end;

procedure TFormAlcoholUI.CloseUI;
begin

end;

function TFormAlcoholUI.GetCameraHandle: Cardinal;
begin
  Result := 0 ;
end;

function TFormAlcoholUI.GetOnCancel: TNotifyEvent;
begin
  Result := m_OnCancel ;
end;

function TFormAlcoholUI.GetOnTimeOut: TNotifyEvent;
begin
  Result :=  m_OnTimeOut ;
end;

procedure TFormAlcoholUI.InitUI(UI: IAlcoholUI);
begin

end;

procedure TFormAlcoholUI.SetError(ErrorMsg: string);
begin

end;

procedure TFormAlcoholUI.SetMore;
begin

end;

procedure TFormAlcoholUI.SetMuch;
begin

end;

procedure TFormAlcoholUI.SetNormal;
begin

end;

procedure TFormAlcoholUI.SetOnCancel(const Value: TNotifyEvent);
begin
  m_OnCancel := Value;
end;

procedure TFormAlcoholUI.SetOnTimeOut(const Value: TNotifyEvent);
begin
  m_OnTimeOut := Value;
end;

procedure TFormAlcoholUI.SetPos(Pos: Integer);
begin

end;

procedure TFormAlcoholUI.SetReady;
begin

end;



procedure TFormAlcoholUI.TimerOut;
begin
  if assigned(m_OnTimeOut) then
  begin
    m_OnTimeOut(Self);
  end;
end;

end.
