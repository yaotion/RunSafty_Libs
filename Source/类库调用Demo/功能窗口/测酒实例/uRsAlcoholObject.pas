unit uRsAlcoholObject;

interface
uses
  ActiveX,uTFComObject,RsAlcoholLib_TLB;
type

  TRsAlcoholObject = class(TTFComObject)
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;  
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);override;
  end;

implementation

{ TRsAlcoholObject }

procedure TRsAlcoholObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  inherited;

end;

end.
