unit ufrmTextInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem, ActnList, Buttons, PngCustomButton;

type
  TfrmTextInput = class(TForm)
    lblCaption: TLabel;
    edtText: TEdit;
    btnConfirm: TPngCustomButton;
    btnCancel: TPngCustomButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure edtTextKeyPress(Sender: TObject; var Key: Char);
  private
    //字符长度
    m_nLen:Integer;
  public
    { Public declarations }
  end;

  {功能:文本输入}
  function TextInput(strTitle,strCaption:String;var strText:String;strLen:Integer = 0):Boolean;


implementation
{$R *.dfm}


function TextInput(strTitle,strCaption:String;var strText:String;strLen:Integer = 0):Boolean;
{功能:文本输入}
var
  frmTextInput: TfrmTextInput;
begin
  Result := False;
  frmTextInput:= TfrmTextInput.Create(nil);
  try
    frmTextInput.Caption := strTitle;
    frmTextInput.lblCaption.Caption := strCaption;
    frmTextInput.edtText.Text := strText;
    frmTextInput.m_nLen := strLen;
    if frmTextInput.ShowModal = mrok then
    begin
      Result := True;
      strText := Trim(frmTextInput.edtText.Text);
    end;
  finally
    frmTextInput.Free;
  end;
end;


procedure TfrmTextInput.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTextInput.btnConfirmClick(Sender: TObject);
begin
  if Trim(edtText.Text) = '' then
  begin
    Box('内容不能为空!');
    Exit;
  end;
  if m_nLen <>  0 then
  begin
    if Length(Trim(edtText.Text)) <> m_nLen then
    begin
      Box('必须输入7位字符');
      Exit;
    end;
  end;
  ModalResult := mrok;
end;

procedure TfrmTextInput.edtTextKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    btnConfirm.Click;
  end;
end;

end.
