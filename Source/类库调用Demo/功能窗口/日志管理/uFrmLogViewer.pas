unit uFrmLogViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, RzPanel, ExtCtrls, StdCtrls, RzEdit, RzCommon, Mask, RzCmboBx,
  RzButton, ImgList, RzStatus, AdvMemo, RzTabs,uFrmChild, RzLstBox, RzChkLst,
  RsLogLib_TLB;

type
  TfrmLogViewer = class(TForm)
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
    class procedure Show;
  end;



implementation

uses
  uFrmLogListener,uGlobalDM;
var
  frmLogViewer: TfrmLogViewer;
{$R *.dfm}

procedure TfrmLogViewer.Cascade1Click(Sender: TObject);
begin
  Self.Cascade();
end;

procedure TfrmLogViewer.Config1Click(Sender: TObject);
begin
//  GlobalDM.LogConfig.LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
//  GlobalDM.LogConfig.ShowConfigForm(Application.Handle,0);
end;

procedure TfrmLogViewer.FormCreate(Sender: TObject);
begin
  RzStatusBar1.DoubleBuffered := True;
end;

procedure TfrmLogViewer.LogListener1Click(Sender: TObject);
begin
  TFrmLogListner.ShowForm;
end;

procedure TfrmLogViewer.miFindClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    (ActiveMDIChild as TFrmChild).FindString();
  end;
end;

procedure TfrmLogViewer.miGotoClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    (ActiveMDIChild as TFrmChild).GoToLine();
  end;
end;

procedure TfrmLogViewer.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogViewer.N3Click(Sender: TObject);
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

function TfrmLogViewer.NewChild: TFrmChild;
var
  frm: TFrmChild;
begin
  frm := TFrmChild.Create(self);
  frm.onStatubarHint := OnStatubarHint;
  frm.Show;
  Result := frm;
end;

procedure TfrmLogViewer.OnStatubarHint(const hint: string);
begin
  RzStatusPane.Caption := hint;
  RzStatusPane.Update;
end;

class procedure TfrmLogViewer.Show;
begin
   frmLogViewer:= TfrmLogViewer.Create(nil);
   try
    frmLogViewer.ShowModal;
   finally
     frmLogViewer.Free;
   end;
end;

end.
