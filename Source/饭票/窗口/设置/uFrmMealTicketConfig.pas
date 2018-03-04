unit uFrmMealTicketConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uMealTicketConfig, Mask, RzEdit, RzTabs,uTFSystem;

type
  TFrmMealTicketConfig = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    edtServerIP: TRzEdit;
    edtLocation: TRzEdit;
    edtUser: TRzEdit;
    edtPass: TRzEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtTFHost: TRzEdit;
    Label5: TLabel;
    edtTFPort: TRzEdit;
    Label6: TLabel;
    edtPlaceID: TRzEdit;
    Label7: TLabel;
    edtPlaceName: TRzEdit;
    Label8: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_CfgFile: string;
    //ªÒ»°≈‰÷√
    procedure InitData();
    //±£¥Ê≈‰÷√
    procedure SaveConfig();
  private
    m_configMealTicket:TRsMealConfigOper;
  public
    { Public declarations }
    class procedure Config();
  end;

var
  FrmMealTicketConfig: TFrmMealTicketConfig;

implementation


{$R *.dfm}

procedure TFrmMealTicketConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmMealTicketConfig.btnSaveClick(Sender: TObject);
begin
  SaveConfig;
  ModalResult := mrOk ;
end;


class procedure TFrmMealTicketConfig.Config;
var
  frm : TFrmMealTicketConfig;
begin
  frm := TFrmMealTicketConfig.Create(nil);
  try
    frm.InitData();
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TFrmMealTicketConfig.FormCreate(Sender: TObject);
begin
  m_CfgFile := Format('%sconfig.ini',[ExtractFilePath(Application.ExeName)]) ;
  m_configMealTicket := TRsMealConfigOper.Create(m_CfgFile);
  RzPageControl1.ActivePageIndex := 0;
end;

procedure TFrmMealTicketConfig.FormDestroy(Sender: TObject);
begin
  m_configMealTicket.Free ;
end;

procedure TFrmMealTicketConfig.InitData;
var
  config:RRsMealServerConfig;
begin
  m_configMealTicket.ReadMealServerConfig(config);
  with config do
  begin
    edtServerIP.Text :=  strServerIP ;
    edtUser.Text := strServerUser ;
    edtPass.Text := strServerPass ;
    edtLocation.Text := strDataLocation ;
  end;

  edtTFHost.Text := ReadIniFile(m_CfgFile,'MealTicketConfig','TFApiHost');
  edtTFPort.Text := ReadIniFile(m_CfgFile,'MealTicketConfig','TFApiPort');
  edtPlaceID.Text := ReadIniFile(m_CfgFile,'MealTicketConfig','ChuQinPlaceID');
  edtPlaceName.Text := ReadIniFile(m_CfgFile,'MealTicketConfig','ChuQinPlaceName');
end;

procedure TFrmMealTicketConfig.SaveConfig;
var
  config : RRsMealServerConfig ;
begin
  with config do
  begin
    strServerIP := edtServerIP.Text ;
    strServerUser := edtUser.Text  ;
    strServerPass := edtPass.Text ;
    strDataLocation :=  edtLocation.Text 
  end;
  m_configMealTicket.WriteMealServerConfig(config);

  WriteIniFile(m_CfgFile,'MealTicketConfig','TFApiHost',edtTFHost.Text);
  WriteIniFile(m_CfgFile,'MealTicketConfig','TFApiPort',edtTFPort.Text);
  WriteIniFile(m_CfgFile,'MealTicketConfig','ChuQinPlaceID',edtPlaceID.Text);
  WriteIniFile(m_CfgFile,'MealTicketConfig','ChuQinPlaceName',edtPlaceName.Text);
end;

end.
