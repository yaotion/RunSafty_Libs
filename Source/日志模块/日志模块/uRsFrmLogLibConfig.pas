unit uRsFrmLogLibConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,uRsLogLib;

type
  TfrmLogLibConfig = class(TForm)
    btnSave: TButton;
    GroupBox1: TGroupBox;
    checkEnableInfo: TCheckBox;
    checkEnableWarn: TCheckBox;
    checkEnableError: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edtLogPath: TEdit;
    checkEnableUDP: TCheckBox;
    Label2: TLabel;
    edtUDPPort: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    m_Config : ILogConfig;
    m_AppHandle : THandle;
    m_ParentHandle : THandle;
    procedure Init;
  public
    { Public declarations }
    class function ShowConfig(AppHandle,PHandle : THandle;
      Config : ILogConfig) : boolean;
  end;



implementation
var
  frmLogLibConfig: TfrmLogLibConfig;
{$R *.dfm}

{ TfrmLogLibConfig }

procedure TfrmLogLibConfig.btnSaveClick(Sender: TObject);
begin
  m_Config.Path := edtLogPath.Text;
  m_Config.EnableInfo := checkEnableInfo.Checked;
  m_Config.EnableDebug := checkEnableWarn.Checked;
  m_Config.EnableError := checkEnableError.Checked;
  m_Config.EnableUDP := checkEnableUDP.Checked;
  m_Config.UDPPort := StrToInt(edtUDPPort.Text);
  m_Config.Save;
  if m_ParentHandle = 0 then
  begin
    Close;
  end;
end;

procedure TfrmLogLibConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmLogLibConfig.Init;
begin
  edtLogPath.Text := m_Config.Path;
  checkEnableInfo.Checked := m_Config.EnableInfo;
  checkEnableWarn.Checked := m_Config.EnableDebug;
  checkEnableError.Checked := m_Config.EnableError;
  checkEnableUDP.Checked := m_Config.EnableUDP;
  edtUDPPort.Text := IntToStr(m_Config.UDPPort);
end;

class function TfrmLogLibConfig.ShowConfig(AppHandle,PHandle : THandle;
  Config: ILogConfig): boolean;
begin
  result := true;
  if AppHandle <> 0 then
    Application.Handle := AppHandle;

  frmLogLibConfig:= TfrmLogLibConfig.Create(Application);
  frmLogLibConfig.m_Config := Config;
  frmLogLibConfig.m_AppHandle := AppHandle;
  frmLogLibConfig.m_ParentHandle := PHandle;
  frmLogLibConfig.Init;
  if PHandle > 0 then
  begin
    windows.SetParent(frmLogLibConfig.Handle,PHandle);
    frmLogLibConfig.Align := alClient;
    frmLogLibConfig.BorderStyle := bsNone;
  end;
  frmLogLibConfig.Show;
end;

end.
