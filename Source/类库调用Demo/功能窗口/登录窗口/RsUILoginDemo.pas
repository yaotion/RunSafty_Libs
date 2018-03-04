unit RsUILoginDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTFComObject, StdCtrls,RsUiLoginLib_TLB;

type
  TfrmUILoginDemo = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowDemo;
  end;



implementation
var
  frmUILoginDemo: TfrmUILoginDemo;
{$R *.dfm}

{ TfrmUILoginDemo }
function CreateInterface(dll: string; classid: TGUID): IUnknown;
VAR
  ifObj : TTFComObject;
begin
  ifObj := TTFComObject.Create;
  try
    ifObj.Init(ExtractFilePath(ParamStr(0)) + 'libs\' + dll,classid,IUnKnown);
    Result := ifObj.DefaultInterface;
  finally
    ifObj.Free;
  end;
end;
procedure TfrmUILoginDemo.Button1Click(Sender: TObject);
var
  uiLogin: IRsUILogin;
  tokeString : WideString;
begin
  uiLogin := CreateInterface('RsUILoginLib.dll',CLASS_RsUILogin)as IRsUILogin;
  if not uiLogin.Login(tokeString) then exit;
  ShowMessage('µÇÂ¼³É¹¦:' + tokeString);
end;

class procedure TfrmUILoginDemo.ShowDemo;
begin
  frmUILoginDemo:= TfrmUILoginDemo.Create(nil);
  frmUILoginDemo.ShowModal;
  frmUILoginDemo.free;
end;

end.
