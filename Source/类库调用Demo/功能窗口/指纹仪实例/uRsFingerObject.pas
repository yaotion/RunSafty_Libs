unit uRsFingerObject;

interface

uses
  ActiveX,uTFComObject,RsFingerLib_TLB;
type

  TRsFingerObject = class(TTFComObject)
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;  
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);override;
  end;

implementation

{ TRsFingerObject }

procedure TRsFingerObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
    if DispID = 201 then
  begin
    if Params.cArgs = 2 then
    begin
      ;
    end;
  end;
end;

end.
