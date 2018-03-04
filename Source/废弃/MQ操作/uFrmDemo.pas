unit uFrmDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, Buttons,uMQUtils, ComCtrls;

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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure comboModeChange(Sender: TObject);
  private
    { Private declarations }
    m_MQ : TMQUtils;
    procedure ConnectOpenMQ();
    procedure MQRec(MessageText :  string;var Confirmed : boolean);
  public
    { Public declarations }
  end;

var
  frmMQDemo: TfrmMQDemo;

implementation

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
  if not m_MQ.Started then
  begin
    ShowMessage('请先打开连接!');
    exit;
  end;

  m_MQ.SendText(edtSend.Text);
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
  m_MQ.ConnectionConfig.UserName := edtUsername.Text;
  m_MQ.ConnectionConfig.UserPSW := edtPassword.Text;
  m_MQ.ConnectionConfig.IP := edtIP.Text;
  m_MQ.ConnectionConfig.Port := edtPort.Text;
  m_MQ.Mode := TMQMode(comboMode.ItemIndex);
  m_MQ.DeliveryMode := mqdmPersistent;
  if not checkPersistent.Checked then
    m_MQ.DeliveryMode := mqdmNonPersistent;

  m_MQ.ClientID := edtClientID.Text;
  m_MQ.SendQueueName := edtSendQueue.Text;
  m_MQ.RecQueueName := edtRecQueue.Text;
  m_MQ.TopicName := edtTopic.Text;
  m_MQ.OnReceiveText := MQRec;
  m_MQ.Open;
end;

procedure TfrmMQDemo.FormCreate(Sender: TObject);
begin
  m_MQ := TMQUtils.Create;
  m_MQ.OnReceiveText := MQRec
end;

procedure TfrmMQDemo.FormDestroy(Sender: TObject);
begin
  m_MQ.Free;
end;

procedure TfrmMQDemo.MQRec(MessageText :  string;var Confirmed : boolean);
begin
  memoRec.Lines.Add(Format('%s收到消息:%s',
    [FormatDateTime('yyyy-MM-dd HH:nn:ss',now),MessageText]));
  confirmed := true;
end;

end.
