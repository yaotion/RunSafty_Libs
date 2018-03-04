unit uFrmLogDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmLogDemo = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnMessage: TButton;
    btnDebug: TButton;
    btnError: TButton;
    btnConfig: TButton;
    edtMsg: TEdit;
    memoLog: TMemo;
    pLogParent: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    procedure btnMessageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Show; 
  end;



implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TfrmLogDemo }

procedure TfrmLogDemo.btnConfigClick(Sender: TObject);
begin
  GlobalDM.LogConfig.LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
  GlobalDM.LogConfig.ShowConfigForm(Application.Handle,pLogParent.Handle);
end;

procedure TfrmLogDemo.btnDebugClick(Sender: TObject);
begin
  GlobalDM.LogConfig.WriteDebug(PChar(edtMsg.Text));
end;

procedure TfrmLogDemo.btnErrorClick(Sender: TObject);
begin
  GlobalDM.Log.WriteError(PChar(edtMsg.Text));
end;

procedure TfrmLogDemo.btnMessageClick(Sender: TObject);
begin
  GlobalDM.Log.WriteInfo(PChar(edtMsg.Text));
end;

procedure TfrmLogDemo.Button1Click(Sender: TObject);
begin
  GlobalDM.LogConfig.LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
  GlobalDM.LogConfig.ShowConfigForm(Application.Handle,pLogParent.Handle);
end;

class procedure TfrmLogDemo.Show;
var
  frmLogDemo: TfrmLogDemo;
begin
  frmLogDemo:= TfrmLogDemo.Create(nil);
  try
    frmLogDemo.ShowModal;
  finally
    frmLogDemo.Free;
  end;
end;

end.
