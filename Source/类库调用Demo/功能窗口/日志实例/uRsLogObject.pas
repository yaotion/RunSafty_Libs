unit uRsLogObject;

interface

uses
  ActiveX,uTFComObject,RsLogLib_TLB;
type

  TRsLogObject = class(TTFComObject)
  private
    m_OnLogout : TRsLogOnLogout;
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;  
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);override;
  public
    property OnLogout : TRsLogOnLogout read m_OnLogout write m_OnLogout;
  end;

  TRsLogConfigObject = class(TTFComObject)
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;  
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);override;
  end;
implementation

{ TTestObject }

procedure TRsLogObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin

  if DispID = 201 then
  begin
    if Params.cArgs = 2 then
    begin
      if assigned(m_OnLogout) then
      begin
        // Params.rgvarg 为safecall ,从右往左
        //  OnLogout(const Title: WideString; const Log: WideString)
        //  Log = 0 ,   Title = 1 ;
        //  所以本调用应该反过来
        m_OnLogout(Sender,Params.rgvarg[1].bstrVal,Params.rgvarg[0].bstrVal);
      end;
    end;
  end;
end;

{ TRsLogConfigObject }

procedure TRsLogConfigObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
end;

end.
