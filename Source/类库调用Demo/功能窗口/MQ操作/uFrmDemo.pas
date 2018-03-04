unit uFrmDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, Buttons, ComCtrls,uRsMQLib;

type
  TfrmMQDemo = class(TForm)
    RzPanel1: TRzPanel;
    Button2: TButton;
    btnSend: TButton;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    memoRec: TMemo;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnOpen: TSpeedButton;
    edtIP: TEdit;
    edtPort: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    edtSendQueue: TEdit;
    edtRecQueue: TEdit;
    edtClientID: TEdit;
    comboMode: TComboBox;
    checkPersistent: TCheckBox;
    edtTopic: TEdit;
    edtSend: TEdit;
    Label1: TLabel;
    procedure btnSendClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure comboModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_OnMQRec : IMQRec;
    procedure ConnectOpenMQ();
    procedure MQRecText(MessageText :  string;var Confirmed : boolean);
    procedure MQRecStream(S :  TStream;var Confirmed : boolean);
  public
    { Public declarations }
    class procedure Show;
  end;



implementation

uses uGlobalDM;
var
  frmMQDemo: TfrmMQDemo;
{$R *.dfm}

procedure TfrmMQDemo.btnOpenClick(Sender: TObject);
begin
  ConnectOpenMQ;
end;

procedure TfrmMQDemo.btnSendClick(Sender: TObject);
begin
  if edtSend.Text = '' then
  begin
    ShowMessage('请输入要发送的内容!');
    edtSend.SetFocus;
    exit;
  end;
  if not GlobalDM.MQ.Started then
  begin
    ShowMessage('请先打开连接!');
    exit;
  end;

  GlobalDM.MQ.SendText(edtSend.Text);
end;

procedure TfrmMQDemo.comboModeChange(Sender: TObject);
begin
  if comboMode.ItemIndex = 0 then
  begin
    edtSendQueue.Enabled := false;
    edtRecQueue.Enabled := false;
    edtTopic.Enabled := true;
  end else begin
    edtSendQueue.Enabled := true;
    edtRecQueue.Enabled := true;
    edtTopic.Enabled := false;
  end;
end;

procedure TfrmMQDemo.ConnectOpenMQ;
begin
  with GlobalDM.MQ do
  begin
    ConnectionCofing.UserName := edtUsername.Text;
    ConnectionCofing.Password := edtPassword.Text;
    ConnectionCofing.IP := edtIP.Text;
    ConnectionCofing.Port := edtPort.Text;
    Mode := comboMode.ItemIndex;
    DeliveryMode := 1;
    if not checkPersistent.Checked then
      DeliveryMode := 0;

    ClientID := edtClientID.Text;
    SendQueueName := edtSendQueue.Text;
    RecQueueName := edtRecQueue.Text;
    TopicName := edtTopic.Text;
    //OnReceiveText := MQRec;
    OnReceive := m_OnMQRec;
    Open;
  end;
end;

procedure TfrmMQDemo.FormCreate(Sender: TObject);
begin
  m_OnMQRec := TMQRec.Create;
  TMQRec(m_OnMQRec).OnRecText := MQRecText;
  TMQRec(m_OnMQRec).OnRecStream  :=MQRecStream;
end;

procedure TfrmMQDemo.MQRecText(MessageText :  string;var Confirmed : boolean);
begin
  memoRec.Lines.Add(Format('%s收到消息:%s',
    [FormatDateTime('yyyy-MM-dd HH:nn:ss',now),MessageText]));
  confirmed := true;
end;
class procedure TfrmMQDemo.Show;
var
  frmMQDemo: TfrmMQDemo;
begin
  frmMQDemo:= TfrmMQDemo.Create(nil);
  try
    frmMQDemo.ShowModal;
  finally
    frmMQDemo.Free;
  end;
end;

procedure TfrmMQDemo.MQRecStream( S:  TStream;var Confirmed : boolean);
begin
//  memoRec.Lines.Add(Format('%s收到消息:%s',
//    [FormatDateTime('yyyy-MM-dd HH:nn:ss',now),MessageText]));
//  confirmed := true;
end;
end.
