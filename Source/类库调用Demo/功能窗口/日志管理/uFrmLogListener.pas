unit uFrmLogListener;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvMemo, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer,
  RzStatus, ExtCtrls, RzPanel,IdGlobal,IdSocketHandle,uMemoStyler,
  RzCommon, RzButton, ImgList,RsLogLib_TLB;

type
  TFrmLogListner = class(TForm)
    memLog: TAdvMemo;
    IdUDPServer: TIdUDPServer;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    RzFrameController1: TRzFrameController;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    btnStart: TRzToolButton;
    btnStop: TRzToolButton;
    procedure IdUDPServerUDPRead(Sender: TObject; AData: TBytes;
      ABinding: TIdSocketHandle);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    m_MemStyler: TAdvMemoLogStyler;
  public
    { Public declarations }
    procedure Init();
    class procedure ShowForm();
  end;


implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TFrmLogListner }

procedure TFrmLogListner.btnStartClick(Sender: TObject);
begin
//  if not GlobalDM.LogConfig.EnableUDP  then
//  begin
//    GlobalDM.LogConfig.EnableUDP := True;
//    GlobalDM.LogConfig.Save();
//  end;

//  IdUDPServer.DefaultPort := GlobalDM.LogConfig.UDPPort;
//  IdUDPServer.Active := true;
//  btnStart.Enabled := False;
//  btnStop.Enabled := True;
end;

procedure TFrmLogListner.btnStopClick(Sender: TObject);
begin
//  if GlobalDM.LogConfig.EnableUDP  then
//  begin
//    GlobalDM.LogConfig.EnableUDP := False;
//    GlobalDM.LogConfig.Save();
//  end;
//  IdUDPServer.Active := False;
//  btnStart.Enabled := True;
//  btnStop.Enabled := False;
end;

procedure TFrmLogListner.FormCreate(Sender: TObject);
begin
  m_MemStyler := TAdvMemoLogStyler.Create(self);
  memLog.SyntaxStyles := m_MemStyler;
end;

procedure TFrmLogListner.IdUDPServerUDPRead(Sender: TObject; AData: TBytes;
  ABinding: TIdSocketHandle);
begin
  if memLog.Lines.Count > 1000 then
    memLog.Lines.Clear;

  memLog.Lines.Add(BytesToString(AData));
  memLog.CurY := memLog.Lines.Count - 1;
end;

procedure TFrmLogListner.Init;
begin
//  GlobalDM.LogConfig.LoadFromFile(ExtractFilePath(Application.ExeName) + 'log.ini');
//  btnStart.Enabled := True;
//  btnStop.Enabled := False;
//
//  if GlobalDM.LogConfig.EnableUDP then
//  begin
//    btnStart.Click;
//  end;
end;

class procedure TFrmLogListner.ShowForm;
var
  FrmLogListner: TFrmLogListner;
begin
  FrmLogListner := TFrmLogListner.Create(nil);
  try
    FrmLogListner.Init();
    FrmLogListner.ShowModal;
  finally
    FrmLogListner.Free;
  end;

end;

end.
