unit uFrmLogDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,uRsLogObject;

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
    btnShowConfig: TButton;
    procedure btnShowConfigClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    procedure btnMessageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    procedure LogProc(ASender: TObject; const Title: WideString; const Log: WideString);
  public
    { Public declarations }
    class procedure Show; 
  end;



implementation
uses
  uGlobalDM,RsLogLib_TLB;
{$R *.dfm}

{ TfrmLogDemo }

procedure TfrmLogDemo.btnConfigClick(Sender: TObject);
begin
  (GlobalDM.LogConfig.DefaultInterface as ILogConfig).LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
  (GlobalDM.LogConfig.DefaultInterface as ILogConfig).ShowConfigForm(Application.Handle,pLogParent.Handle);
end;

procedure TfrmLogDemo.btnDebugClick(Sender: TObject);
begin
  (GlobalDM.Log.DefaultInterface as IRsLog).WriteDebug(PChar(edtMsg.Text),'');
end;

procedure TfrmLogDemo.btnErrorClick(Sender: TObject);
begin
  (GlobalDM.Log.DefaultInterface as IRsLog).WriteError(PChar(edtMsg.Text),'');
end;

procedure TfrmLogDemo.btnMessageClick(Sender: TObject);
begin
  (GlobalDM.Log.DefaultInterface as IRsLog).WriteInfo(PChar(edtMsg.Text),'');
end;

procedure TfrmLogDemo.btnShowConfigClick(Sender: TObject);
begin
  (GlobalDM.LogConfig.DefaultInterface as ILogConfig).LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
  (GlobalDM.LogConfig.DefaultInterface as ILogConfig).ShowConfigForm(Application.Handle,0);
end;

procedure TfrmLogDemo.FormCreate(Sender: TObject);
begin
  GlobalDM.Log := TRsLogObject.Create;
  GlobalDM.Log.Init(ExtractFilePath(Application.ExeName) + 'libs\RsLogLib.dll',
    CLASS_RsLog,DIID_ILogEvents);
  GLobalDM.Log.OnLogout := LogProc;


  GlobalDM.LogConfig := TRsLogConfigObject.Create;
  GlobalDM.LogConfig.Init(ExtractFilePath(Application.ExeName) + 'libs\RsLogLib.dll',
    CLASS_RsLogConfig,IUnKnown);
end;

procedure TfrmLogDemo.FormDestroy(Sender: TObject);
begin
  GlobalDM.Log.Free;
  GlobalDM.LogConfig.Free;
end;

procedure TfrmLogDemo.LogProc(ASender: TObject; const Title: WideString; const Log: WideString);
begin
  //memoLog.Lines.Add(ASender.ClassName);
  memoLog.Lines.Add(title);
  memoLog.Lines.Add(log);
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
