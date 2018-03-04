unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TfrmMainDemo = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miCamera: TMenuItem;
    miAlcohol: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    miLog: TMenuItem;
    N4: TMenuItem;
    miFinger: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    miLoginLib: TMenuItem;
    procedure miCameraClick(Sender: TObject);
    procedure miAlcoholClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure miLogClick(Sender: TObject);
    procedure miFingerClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure miLoginLibClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainDemo: TfrmMainDemo;

implementation
uses
  uFrmCameraDemo,uFrmAlcoholDemo,uFrmLogViewer,uFrmLogDemo,uFrmFingerDemo,
  uFrmAPITrainman,uFrmRsUIDemo,RsUILoginDemo;
{$R *.dfm}

procedure TfrmMainDemo.miAlcoholClick(Sender: TObject);
begin
  TFrmAlcoholDemo.Show;
end;

procedure TfrmMainDemo.miCameraClick(Sender: TObject);
begin
  TfrmCameraDemo.Show;
end;

procedure TfrmMainDemo.miFingerClick(Sender: TObject);
begin
  TfrmFingerDemo.Show;
end;

procedure TfrmMainDemo.miLogClick(Sender: TObject);
begin
  TFrmLogDemo.Show;
end;

procedure TfrmMainDemo.miLoginLibClick(Sender: TObject);
begin
  TfrmUILoginDemo.ShowDemo;
end;

procedure TfrmMainDemo.N3Click(Sender: TObject);
begin
  TfrmLogViewer.Show;
end;

procedure TfrmMainDemo.N6Click(Sender: TObject);
begin
  TfrmRsAPITrainman.ShowForm;
end;

procedure TfrmMainDemo.N8Click(Sender: TObject);
begin
  frmRsUIDemo:= TfrmRsUIDemo.Create(nil);
  frmRsUIDemo.ShowModal;
  frmRsUIDemo.Free;
end;

end.
