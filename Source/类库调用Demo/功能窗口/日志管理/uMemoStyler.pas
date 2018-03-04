unit uMemoStyler;

interface
uses
  classes,SysUtils,AdvMemo;
type
  TAdvMemoLogStyler = class(TAdvCustomMemoStyler)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TAdvMemoLogStyler }

constructor TAdvMemoLogStyler.Create(AOwner: TComponent);
begin
  inherited;
  LineComment := '[';
  CommentStyle.TextColor := $00B76F59;
end;

end.
