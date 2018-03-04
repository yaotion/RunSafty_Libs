unit ufrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, PngImageList, Buttons, PngCustomButton,
  DB, ADODB, ImgList, ActnList, ComCtrls, Mask, RzEdit, RzLabel, uFrmSQLConfig,
  utfSQLConn, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, AdvSpin,uTFSystem, RzDTP, RzButton,
  RzRadChk, RzTabs, pngimage,Registry{,uLLCommonFun};

type
  TfrmConfig = class(TForm)
    RzPanel1: TRzPanel;
    Image1: TImage;
    RzTabControl1: TRzTabControl;
    RzPanel2: TRzPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    edtHost: TEdit;
    Label1: TLabel;
    RzPanel3: TRzPanel;
    btnSave: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    checkAllowOffline: TCheckBox;
    checkAutoLogin: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RzTabControl1Change(Sender: TObject);
    procedure checkAutoLoginClick(Sender: TObject);
  private
    { Private declarations }
    procedure Init;
    //检测输入
    function CheckInput : boolean;
  public
    { Public declarations }
    class function EditConfig() : boolean;
  end;



implementation
uses
  uGlobal{uGlobalDM, uFrmWorkFlowCheck};
{$R *.dfm}

{ TfrmConfig }

procedure TfrmConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmConfig.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then exit;
  GlobalConfig.HostUrl := edtHost.Text;
  GlobalConfig.AllowOffline := checkAllowOffline.Checked;
  GlobalConfig.Autologin := checkAutoLogin.Checked;
  GlobalConfig.Save;
  ModalResult := mrOk;
end;

procedure TfrmConfig.checkAutoLoginClick(Sender: TObject);
begin
  GlobalConfig.Autologin := checkAutoLogin.Checked;
  GlobalConfig.Save;
end;

function TfrmConfig.CheckInput: boolean;
begin
  result := true;
end;



class function TfrmConfig.EditConfig: boolean;
var
  frmConfig : TfrmConfig;
begin
  result := false;
  frmConfig := TfrmConfig.Create(nil);
  try
    frmConfig.Init;
    if frmConfig.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmConfig.Free;
  end;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  TabSheet1.TabVisible := false;
  RzTabControl1.TabIndex := 0;
  PageControl1.ActivePageIndex := 0;
end;



procedure TfrmConfig.Init;
begin
  //服务器地址
  edtHost.Text :=  GlobalConfig.HostUrl;
  //自动登录
  checkAutoLogin.Checked := GlobalConfig.Autologin ;
  //允许断网模式
  checkAllowOffline.Checked := GlobalConfig.AllowOffline;
end;

procedure TfrmConfig.RzTabControl1Change(Sender: TObject);
begin
  PageControl1.ActivePageIndex := RzTabControl1.TabIndex;
end;



end.
