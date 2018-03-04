unit ufrmLoading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzPanel;


const
  //默认颜色
  NORMAL_COLOR = $006C3938;
  //焦点颜色
  FOCUS_COLOR = $0038BDFF;//$001DE24F;


type
  TfrmLoading = class(TForm)
    Label1: TLabel;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    RzPanel4: TRzPanel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    //功能:显示等待对话框
    class procedure ShowLoading();
    //功能:关闭等待对话框    
    class procedure CloseLoading();
    { Public declarations }
  end;



implementation
 var
  frmLoading: TfrmLoading;
{$R *.dfm}

class procedure TfrmLoading.CloseLoading;
begin
  if assigned(frmLoading) then
  begin
    frmLoading.Close;
    FreeAndNil(frmLoading);
  end;
end;



class procedure TfrmLoading.ShowLoading;
begin
  if Assigned(frmLoading) = false then
    frmLoading := TfrmLoading.Create(nil);

  frmLoading.Show;
end;

procedure TfrmLoading.Timer1Timer(Sender: TObject);
begin
  if RzPanel1.Color = FOCUS_COLOR then
  begin
    RzPanel1.Color := NORMAL_COLOR;
    RzPanel3.Color := NORMAL_COLOR;
    RzPanel4.Color := NORMAL_COLOR;
    RzPanel2.Color := FOCUS_COLOR;
    Exit;
  end;

  if RzPanel2.Color = FOCUS_COLOR then
  begin
    RzPanel1.Color := NORMAL_COLOR;
    RzPanel2.Color := NORMAL_COLOR;
    RzPanel4.Color := NORMAL_COLOR;
    RzPanel3.Color := FOCUS_COLOR;
    Exit;
  end;

  if RzPanel3.Color = FOCUS_COLOR then
  begin
    RzPanel1.Color := NORMAL_COLOR;
    RzPanel2.Color := NORMAL_COLOR;
    RzPanel3.Color := NORMAL_COLOR;
    RzPanel4.Color := FOCUS_COLOR;
    Exit;
  end;

  if RzPanel4.Color = FOCUS_COLOR then
  begin
    RzPanel2.Color := NORMAL_COLOR;
    RzPanel3.Color := NORMAL_COLOR;
    RzPanel4.Color := NORMAL_COLOR;
    RzPanel1.Color := FOCUS_COLOR;
    Exit;
  end;


end;

end.
