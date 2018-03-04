unit uLogViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, RzPanel, ExtCtrls, StdCtrls, RzEdit, RzCommon, Mask, RzCmboBx,
  RzButton, ImgList, RzStatus, AdvMemo, RzTabs,uFrmChild, RzLstBox, RzChkLst,
  uRsLogLib;

type
  TFrmMain = class(TForm)
    RzStatusBar1: TRzStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    RzStatusPane: TRzStatusPane;
    RzProgressStatus: TRzProgressStatus;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    Edit1: TMenuItem;
    miGoto: TMenuItem;
    miFind: TMenuItem;
    OpenDialog1: TOpenDialog;
    RzFrameController1: TRzFrameController;
    Option1: TMenuItem;
    Config1: TMenuItem;
    ools1: TMenuItem;
    LogListener1: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure miFindClick(Sender: TObject);
    procedure miGotoClick(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure LogListener1Click(Sender: TObject);
  private
    { Private declarations }
    function NewChild(): TFrmChild;
    procedure OnStatubarHint(const hint: string);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  uFrmLogListener;

{$R *.dfm}

procedure TFrmMain.Cascade1Click(Sender: TObject);
begin
  Self.Cascade();
end;

procedure TFrmMain.Config1Click(Sender: TObject);
begin
  CoLog.Config.LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
  CoLog.Config.ShowConfigForm(Application.Handle,0);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  RzStatusBar1.DoubleBuffered := True;
end;

procedure TFrmMain.LogListener1Click(Sender: TObject);
begin
  TFrmLogListner.ShowForm;
end;

procedure TFrmMain.miFindClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    (ActiveMDIChild as TFrmChild).FindString();
  end;
end;

procedure TFrmMain.miGotoClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    (ActiveMDIChild as TFrmChild).GoToLine();
  end;
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.N3Click(Sender: TObject);
var
  frm: TFrmChild;
begin
  if OpenDialog1.InitialDir = '' then
    OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));

  if OpenDialog1.Execute then
  begin
    Caption := ExtractFileName(OpenDialog1.FileName);
    Application.ProcessMessages;

    frm := NewChild();

    frm.LoadLog(OpenDialog1.FileName);
  end;
end;

function TFrmMain.NewChild: TFrmChild;
var
  frm: TFrmChild;
begin
  frm := TFrmChild.Create(self);
  frm.onStatubarHint := OnStatubarHint;
  frm.Show;
  Result := frm;
end;

procedure TFrmMain.OnStatubarHint(const hint: string);
begin
  RzStatusPane.Caption := hint;
  RzStatusPane.Update;
end;

end.
