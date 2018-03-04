unit ufrmTicketCountInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, RzEdit;

type
  TFrmTicketCountInput = class(TForm)
    edtA: TRzEdit;
    edtB: TRzEdit;
    Bevel1: TBevel;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    procedure edtAKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Input(var iA,iB: integer): Boolean;
  end;



implementation

{$R *.dfm}

procedure TFrmTicketCountInput.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmTicketCountInput.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmTicketCountInput.edtAKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13]) then
    Key := #0;
end;

class function TFrmTicketCountInput.Input(var iA, iB: integer): Boolean;
begin
  with TFrmTicketCountInput.Create(nil) do
  begin
    Result := ShowModal = mrOk;
    if Result then
    begin
      iA := StrToIntDef(edtA.Text,0);
      iB := StrToIntDef(edtB.Text,0)
    end;
    Free;
  end; 
end;

end.
