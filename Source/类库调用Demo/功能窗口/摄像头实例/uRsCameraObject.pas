unit uRsCameraObject;

interface

uses
  ActiveX,uTFComObject,RsCameraLib_TLB;
type

  TRsCameraObject = class(TTFComObject)
  protected
    procedure EventSinkInvoke(Sender: TObject; DispID: Integer;
       const IID: TGUID; LocaleID: Integer; Flags: Word;  
       Params: tagDISPPARAMS; VarResult, ExcepInfo, ArgErr: Pointer);override;
  end;


implementation

{ TRsCameraObject }

procedure TRsCameraObject.EventSinkInvoke(Sender: TObject; DispID: Integer;
  const IID: TGUID; LocaleID: Integer; Flags: Word; Params: tagDISPPARAMS;
  VarResult, ExcepInfo, ArgErr: Pointer);
begin
  inherited;

end;

end.
