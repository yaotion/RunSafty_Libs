unit uRsAlcoholLibOption_Impl;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, RsAlcoholLib_TLB, StdVcl;

type
  //²â¾Æ´°¿ÚÎ»ÖÃ
  TPositionOp = (ptNormal,ptRightBottom);

  TAlcoholOption = class(TAutoObject, IAlcoholOption)
  public
    procedure Initialize; override;
  private
    m_Position : Word;
    m_LocalSound : boolean;
  protected
    function Get_LocalSound: WordBool; safecall;
    function Get_Position: Integer; safecall;
    function Get_AppHandle: Integer; safecall;
    procedure Set_LocalSound(Value: WordBool); safecall;
    procedure Set_Position(Value: Integer); safecall;
    procedure Set_AppHandle(Value: Integer); safecall;

  end;

implementation

uses ComServ,forms;

function TAlcoholOption.Get_LocalSound: WordBool;
begin
  result := m_LocalSound;
end;

function TAlcoholOption.Get_Position: Integer;
begin
  result := m_Position;
end;

procedure TAlcoholOption.Initialize;
begin
  inherited;
  m_Position := Ord(ptNormal);
  m_LocalSound := false;
end;

function TAlcoholOption.Get_AppHandle: Integer;
begin
  result := Application.Handle;
end;

procedure TAlcoholOption.Set_LocalSound(Value: WordBool);
begin
  m_LocalSound := value;
end;

procedure TAlcoholOption.Set_Position(Value: Integer);
begin
  m_Position := value;
end;

procedure TAlcoholOption.Set_AppHandle(Value: Integer);
begin
  Application.Handle := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAlcoholOption, Class_AlcoholOption,
    ciMultiInstance, tmApartment);
end.
