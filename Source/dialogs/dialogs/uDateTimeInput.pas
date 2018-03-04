unit uDateTimeInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, ExtCtrls, Mask, RzEdit,dateutils,uTFSystem;

type
  TDateTimeInput = class(TForm)
    Bevel1: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    dtDate: TRzDateTimePicker;
    dtTime: TRzDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
    class function Input(var value: TDateTime): Boolean;
  end;


  function InputDateTime(var value: TDateTime): Boolean;stdcall;
implementation
exports
  InputDateTime;
function InputDateTime(var value: TDateTime): Boolean;stdcall;
begin
  Result := TDateTimeInput.Input(value)
end;
{$R *.dfm}

{ TDateTimeInput }

class function TDateTimeInput.Input(var value: TDateTime): Boolean;
begin
  with TDateTimeInput.Create(nil) do
  begin
    if value > 1 then
    begin
      dtTime.Time := TimeOf(value);
      dtDate.Date := DateOf(value);
    end
    else
    begin
      dtDate.Date := Now;
      dtTime.Time := Now;
    end;

    Result := ShowModal = mrOk;

    if Result then
    begin
      ReplaceDate(value,dtDate.Date);
      ReplaceTime(value,dtTime.Time);
    end;
    Free;
  end;
end;

end.
